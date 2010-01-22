Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526Ab0AVQkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0AVQkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385Ab0AVQkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:40:09 -0500
Received: from mail-ew0-f171.google.com ([209.85.219.171]:50205 "EHLO
	mail-ew0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0AVQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:40:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rcvNDlWkwJGdsT5iAcyAukcZsA+uoYyYbpJEF8cwub45NgtLmAZ3ZQXBtYlDasTkPa
         GYFExpFIeIwnvc4uJoFAAmh5lcRznPOPa4H4rrkylY398m1IrVb+N9bOfxHlFVqfQ6gM
         6uCMA9Ag/uHbOuZbEQxb++N81GoblezsDwU0w=
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 16:40:06 +0000
Message-ID: <5c343a41001220840x6ce6bd29q3b69bbc978b1899f@mail.gmail.com>
Subject: usbmc seems broken
From: Neil Kalo <neilkalo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I cannot get usbtmc to work with my device. I am using fedora 12:
2.6.31.12-174.2.3.fc12.i686.PAE

Jan 22 15:40:26 localhost kernel: usb 4-1: new full speed USB device
using ohci_hcd and address 4
Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device found,
idVendor=05e6, idProduct=2100
Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device strings:
Mfr=2, Product=3, SerialNumber=1
Jan 22 15:40:26 localhost kernel: usb 4-1: Product: 2100 Multimeter
Jan 22 15:40:26 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
Jan 22 15:40:26 localhost kernel: usb 4-1: SerialNumber: 1160791
Jan 22 15:40:26 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
Jan 22 15:40:26 localhost kernel: usbtmc 4-1:1.0: can't read capabilities

If I compile the original Agilent module from
"http://www.home.agilent.com/upload/cmc_upload/All/usbtmc.html" It
works fine:

Jan 22 15:37:45 localhost kernel: usb 4-1: new full speed USB device
using ohci_hcd and address 3
Jan 22 15:37:45 localhost kernel: usb 4-1: New USB device found,
idVendor=05e6, idProduct=2100
Jan 22 15:37:45 localhost kernel: usb 4-1: New USB device strings:
Mfr=2, Product=3, SerialNumber=1
Jan 22 15:37:45 localhost kernel: usb 4-1: Product: 2100 Multimeter
Jan 22 15:37:45 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
Jan 22 15:37:45 localhost kernel: usb 4-1: SerialNumber: 1160791
Jan 22 15:37:45 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
Jan 22 15:37:45 localhost kernel: USBTMC: MKDEV
Jan 22 15:37:45 localhost kernel: USBTMC: CDEV_ADD f900000 1

Note that I do get one error line per module load, but this does not
prevent the device from working in my application:
Jan 22 15:38:21 localhost kernel: USBTMC: Unable to read data, error -110

This error also sometimes occurs with the standard kernel module, but
I never get a functioning connection to my device:
Jan 16 23:43:36 localhost kernel: usbtmc 1-4.1.1:1.0: can't read capabilities
Jan 16 23:52:31 localhost kernel: usbtmc 1-4.1.1:1.0: Unable to read
data, error -110

Where do I go from here?
