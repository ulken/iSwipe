#!/usr/bin/env ruby

# Updated version for iSwipe 0.5+
# Original gist by me97esn: https://gist.github.com/me97esn/6407124

require 'plist'
require 'net/http'
require 'i18n'

url = "http://runeberg.org/words/ss100.txt"
content = Net::HTTP.get_response(URI.parse(url)).body
grouped_by_start_and_end_letters = content.encode("UTF-8", "ISO-8859-15").each_line.group_by {|w| 
  s = normalize(w)
  "#{s[0,1]}#{s[s.length-2,s.length-1]}" 
}

grouped_by_start_and_end_letters.each{|k,v|
  File.open("#{k[0]}#{k[1]}.plist", 'a:UTF-8') { |file| 
    words = v.collect{|word| 
      word.gsub!(/\n/, '')
      {
        :Count => 0, 
        :Match => normalize(word),
        :Word  => word
      }
    }
    file.write( words.to_plist )
  }
}

def normalize(string)
  I18n.transliterate string.downcase
end
