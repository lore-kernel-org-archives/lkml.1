Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYDCNsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYDCNsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYDCNsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:48:09 -0400
Received: from smtp2e.orange.fr ([80.12.242.112]:12472 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbYDCNsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:48:07 -0400
X-ME-UUID: 20080403134805723.B0A5670000A6@mwinf2e08.orange.fr
Subject: ASUS ScreenDuo
From: Xavier Bestel <xavier.bestel@free.fr>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 03 Apr 2008 15:48:01 +0200
Message-Id: <1207230481.24037.11.camel@skunk.anacadf.mentorg.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an ASUS motherboard with an USB gadget, the ASUS ScreenDUO. It's
an independant little lcd screen with buttons, apparently it runs some
kind of OS because it can access the net (e.g. to retrieve RSS) even
when the computer is off - I guess they mean soft-off.

Well, all that is theory because it's under Vista, which I don't have.
Under Linux the ScreenDUO is kind-of recognized: it says it's a mass
storage device, but I can't mount it (the kernel says it's bound to sdc,
but sdc doesn't exist).
I'd like to access it. Does anyone know how that thing works ?

Thanks,
	Xav

PS: please Cc: me on anwers

interesting dmesg part:

usb 7-4: new high speed USB device using ehci_hcd and address 3
usb 7-4: configuration #1 chosen from 1 choice
scsi9 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 9:0:0:0: Direct-Access     ASUS     ScreenDUO             PQ: 0 ANSI: 2
sd 9:0:0:0: [sdc] Attached SCSI removable disk
usb 7-4: USB disconnect, address 3
usb 7-4: new high speed USB device using ehci_hcd and address 4
usb 7-4: configuration #1 chosen from 1 choice
scsi10 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 10:0:0:0: Direct-Access     ASUS     ScreenDUO             PQ: 0 ANSI: 2
sd 10:0:0:0: [sdc] Attached SCSI removable disk


[root@awak:~]$ fdisk /dev/sdc

Unable to open /dev/sdc



[root@awak:~]$ lsusb -v

Bus 007 Device 004: ID 1043:3100 iCreate Technologies Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1043 iCreate Technologies Corp.
  idProduct          0x3100 
  bcdDevice            0.01
  iManufacturer          16 ASUS
  iProduct               32 ScreenDUO
  iSerial                96 
  bNumConfigurations      1
OTG Descriptor:
  bLength                 3
  bDescriptorType         9
  bmAttributes         0x03
    SRP (Session Request Protocol)
    HNP (Host Negotiation Protocol)
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           35
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration         48 CONFIG STRING
    bmAttributes         0xc0
      Self Powered
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface             64 INTERFACE STRING
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

etc.


