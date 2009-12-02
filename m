Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZLBT3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZLBT3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbZLBT3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:29:19 -0500
Received: from pancho.name ([92.48.73.7]:53216 "EHLO pancho.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbZLBT3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:29:19 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2009 14:29:18 EST
Date: Wed, 2 Dec 2009 20:19:42 +0100
From: pancho horrillo <pancho@pancho.name>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Add USB device ID for Apple Cinema Display 23in 2007
Message-ID: <20091202191942.GA7362@pancho.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

$ lsusb -v
Bus 001 Device 008: ID 05ac:921c Apple, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x05ac Apple, Inc.
  idProduct          0x921c 
  bcdDevice            1.15
  iManufacturer           1 
  iProduct                2 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                2mA
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
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      92
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
        bInterval              16



(Against linux-2.6.31.6)

Signed-off-by: pancho horrillo <pancho@pancho.name>

diff -purN a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c	2009-11-10 01:32:31.000000000 +0100
+++ b/drivers/usb/misc/appledisplay.c	2009-12-02 20:01:25.000000000 +0100
@@ -60,6 +60,7 @@
 static struct usb_device_id appledisplay_table [] = {
 	{ APPLEDISPLAY_DEVICE(0x9218) },
 	{ APPLEDISPLAY_DEVICE(0x9219) },
+	{ APPLEDISPLAY_DEVICE(0x921c) },
 	{ APPLEDISPLAY_DEVICE(0x921d) },
 
 	/* Terminating entry */

-- 
pancho horrillo

To be conscious that
you are ignorant is a great step
to knowledge.

		Benjamin Disraeli
