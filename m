Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbYLUSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbYLUSWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 13:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYLUSWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 13:22:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:23317 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYLUSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 13:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XjoNHcTB7Aoeoz2t2hPqJvoxFfKJPVDM0xHLPol2y26uRrZaQpcAOA4WOt1Vt8tlY2
         OBan8xcmzI801Lgvj/XWVjT/9rkvpYidz0Hzj9378H/5sYsabc0eKKrsybl+3i2EbKpI
         nebG1vEoHafpFTeo3uulN1yOFKlidL36VuHbQ=
Message-ID: <f7848160812211022t6ac2396dob906d21921c48b87@mail.gmail.com>
Date: Sun, 21 Dec 2008 13:22:03 -0500
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: 2.6.28-rc9: USB Mouse unhappy
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LRH.1.10.0812211823510.11630@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
	 <alpine.LRH.1.10.0812211823510.11630@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2008 at 12:24 PM, Jiri Kosina <jkosina@suse.cz> wrote:

> Could you please provide vendor and product IDs of this device? (lsusb -v
> will tell you).

Bus 004 Device 003: ID 046d:c525 Logitech, Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc525
  bcdDevice            2.00
  iManufacturer           1 Logitech
  iProduct                2 USB Receiver
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          4 RQR02.00_B0020
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               98mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      67
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
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
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
          wDescriptorLength      79
         Report Descriptors:
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0014  1x 20 bytes
        bInterval               1
Device Status:     0x0000
  (Bus Powered)
