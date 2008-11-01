Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbYKAMci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbYKAMci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 08:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYKAMc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 08:32:29 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1670 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYKAMc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 08:32:28 -0400
Message-ID: <490C4C59.7070003@shikadi.net>
Date: Sat, 01 Nov 2008 22:32:25 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Can you use the USB HID interface within a driver?
References: <490C4133.30400@shikadi.net> <200811011308.41339.oliver@neukum.org>
In-Reply-To: <200811011308.41339.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Or perhaps someone could point me in the direction of a USB HID driver 
>> that does things "properly" already?
> 
> Please post "lsusb -v" for your device.

Here's the output.  I don't think any of the "class" drivers are 
suitable, except as templates for interfacing with the main HID code...I 
think...

Bus 008 Device 002: ID 1044:4001 Chu Yuen Enterprise Co., Ltd
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x1044 Chu Yuen Enterprise Co., Ltd
   idProduct          0x4001
   bcdDevice            1.01
   iManufacturer           1 GIGABYTE TECHNOLOGY
   iProduct                2 GBT 800W PSU
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           34
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              100mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0 No Subclass
       bInterfaceProtocol      0 None
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.10
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      32
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              10
Device Status:     0x0000
   (Bus Powered)


Cheers,
Adam.

