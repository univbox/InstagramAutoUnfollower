# encoding = utf-8
require 'selenium-webdriver'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'rspec/expectations'
include RSpec::Matchers

#@out_button = [[],[]]
@out_button = []
@id = ""
@pw = ""
def setup
  @id = gets.chomp
  @pw = gets.chomp

  @driver = Selenium::WebDriver.for :safari
end

def login
  @driver.navigate.to "https://www.instagram.com/"
  sleep(2)
  @driver.find_element(:xpath, "//p[@class='_dyp7q']//a[@class='_fcn8k']").click
  sleep(2)
  form = @driver.find_elements(:class,"_kp5f7 _qy55y")
  
  @id = ARGV[0]
  @pw = ARGV[1]
  form[0].send_key(@id)
  form[1].send_key(@pw)


  @driver.find_element(:class, "_rz1lq _7k49n").click
end

def find_profile
  sleep(6)
  icons = @driver.find_elements(:class,"_7smet")
  icons[2].click
  sleep(4)

  follows = @driver.find_elements(:class,"_218yx")
  follows[2].click
  sleep(4)


  #@driver.find_elements(:css, 'div.pic').last.location_once_scrolled_into_view
  #@driver.find_element(:xpath,"div[@class='_pq5am']//div[@class='_7smet']//a[@class='_soakw _vbtk2 coreSpriteDesktopNavProfile']").click
end

def unfollow
  first = 1
  sleep(1)
  following_list = @driver.find_elements(:class,"_7k49n")
  @driver.find_elements(:class, '_7k49n').last.location_once_scrolled_into_view
  following_list.each do |f|
    if first==1
      first = 0
    elsif f.text.include?("팔로우")
      fist = 0
    else
      f.click
    end
  end
end

def teardown
  @driver.quit
end

def run
  @out_button = []
  @driver = Selenium::WebDriver.for :safari
  login
  find_profile
  count = 0
  while(count < 10)
    unfollow
    count += 1
  end
  #yield

  #teardown
end

run do

  @driver.navigate.to "https://docs.google.com/forms/d/e/1FAIpQLSdu4X1q1s87YK6BX8fFSCvsbwbqzkIC6cQrx_lQQ3ah6enxpw/viewform"
  @radio_buttons = @driver.find_elements(:class, "docssharedWizToggleLabeledLabelText exportLabel freebirdFormviewerViewItemsRadioLabel")

  @out_button.each do |num|
    num = num.to_i
    @radio_buttons[num].click
    sleep(0.2)
  end


  sleep(2)
end
