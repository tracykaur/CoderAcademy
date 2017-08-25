require 'urban_dictionary'
require 'gingerice'
require 'colorize'
require 'terminal-table'
class AppStarter
    def starter
        puts "Enter some text to Slango: ".upcase + "(or type 5 to exit)"
        puts ""
        text = gets.chomp
        puts ""
        if text == "5"
            exit
        end
        parser = Gingerice::Parser.new
        output = parser.parse text
        $new_slango = Slango.new(output)
        $new_slango.result
        $new_slango.file_saver
    end
end
class Slango < AppStarter
    def initialize(output)
        $original_corrections = []
        @output = output
    end
    def result
        puts "------------------------------------------------------------------------------------------------".center(525, " ")
        puts "TOTAL NUMBER OF CORRECTIONS: #{@output["corrections"].length}"
        puts ""
        @output["corrections"].each do |correction|
            $original_corrections.push([correction["text"].colorize(:red), correction["correct"].colorize(:blue)])
        end
        table = Terminal::Table.new :headings => ['Original', 'Corrected'], :rows => $original_corrections
        puts table
        puts "------------------------------------------------------------------------------------------------".center(525, " ")
        puts @output["result"]
        puts ""
    end
    def file_saver
        puts "Would you like to save these results to a text file?  y/n".upcase
        users_choice2 = gets.chomp.downcase
        if users_choice2 == "y"
            puts "What would you like to name your file?".upcase
            file_name_choice = gets.chomp.downcase
            puts ""
            File.write("#{file_name_choice}.rb", @output["result"])
        elsif users_choice2 == "n"
        else
            puts "I didn't understand that."
        end
    end
    def urban_search
        puts "------------- Would you like to search UrbanDictionary for any of these words? y/n -------------".upcase.center(525, " ")
        users_choice = gets.chomp.downcase
        puts ""
        if users_choice == "y"
            puts "Which word would you like to search? ".upcase
            users_word = gets.chomp
            word = UrbanDictionary.define(users_word)
            puts "------------------------------------------------------------------------------------------------".center(525, " ")
            puts "RESULT FOR: #{users_word.upcase}"
            puts ""
            word.entries.each do |entry|
              puts "Definition: #{entry.definition}"
              puts "Example: #{entry.example}"
              puts "------------------------"
            end
            puts "------------------------------------------------------------------------------------------------".center(525, " ")
        elsif users_choice == "n"
            starter
        else
            puts "I didn't understand that.".upcase
        end
        urban_search
    end
end
class Welcome
    def welcome
        puts ""
        welcome = "******************************************** Welcome to Slango! ********************************************"
        puts welcome.upcase.center(525, " ")
        puts ""
    end
end
example_text = 'Yesterdiy I went with my brather to a niw gym in Markham. Mang, those dudes were filthy rich. It was like money was growing off their bazooties.Everything they wore was branded from their head to their toes.They were ballin with their new, clean, white, nike shoes and all their nice isht. But we minded our own bizznizzle because we were just there to play some volleyball LMAO. Then when everyone started the drills, the place got crunked up. Everyone was smashing the balls like no tomorrow. It was mad-crazy in that joint.But mang, that was by far the best volleyball practice ever.'
welcome = Welcome.new
welcome.welcome
starter = AppStarter.new
starter.starter
$new_slango.urban_search
