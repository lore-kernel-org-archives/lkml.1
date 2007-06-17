Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbXFQLOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbXFQLOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbXFQLOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:14:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:60808 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756026AbXFQLOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:14:21 -0400
X-Authenticated: #4283818
X-Provags-ID: V01U2FsdGVkX1/2C5hYJuH2cyJGz/OhIrVrv12flBQ7MvrfMMf9ut
	WWzWyv6XTrGzqa
From: Wolfgang Schnitker <wolfgang.schnitker@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: solution to "usb disconnect problems regarding usb 1.1 and 2.0"
Date: Sun, 17 Jun 2007 13:14:11 +0200
User-Agent: KMail/1.9.5
X-Face: #K{nHa"UEZhQ&[QL)`u8IPW%::V-EzK({kZA+<3c/3@2BP\M*RpQ}RbXBrO7bvp(=?iso-8859-15?q?Ef=7B=26=7B=26=0A=09?=>Ve.H8>6XiuC=-qKg<VPu"L>_Dehhp<=?iso-8859-15?q?X=3Dx=3BY3=3FP=5EE=26=7DBk=5BOehDwr*-uc1yw=7B0XRx=60nI=26eS?=
 =?iso-8859-15?q?=0A=09yvx=5C=3FIMpD?=(\X`j[iUi]N$x6PQU?i)@ov.H`|6k9RsX9^~,]5w_ab)8<
 =?iso-8859-15?q?=3FpY=3F=26TV=3BK=24=7EiN=3F5=0A=09=25J-=7CG=3Fsqf=2E0?=
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706171314.12254.wolfgang.schnitker@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel Developers,

I had some trouble with my usb devices, often showing a disconnect problem. I 
did some googleing and saw, that it is a less or more common problem.

This problem is discussed in various internet sites. 

log from my machine:

#############################
usb 4-6: new high speed USB device using ehci_hcd and address 7
usb 4-6: configuration #1 chosen from 1 choice
hub 4-6:1.0: USB hub found
hub 4-6:1.0: 4 ports detected
usb 4-6.1: new full speed USB device using ehci_hcd and address 8
usb 4-6.1: device descriptor read/64, error -32
usb 4-6.1: device descriptor read/64, error -32
usb 4-6.1: new full speed USB device using ehci_hcd and address 9
usb 4-6.1: device descriptor read/64, error -110
usb 4-6.1: device descriptor read/64, error -110
usb 4-6.1: new full speed USB device using ehci_hcd and address 10
usb 4-6.1: device not accepting address 10, error -32
usb 4-6.1: new full speed USB device using ehci_hcd and address 11
usb 4-6.1: device not accepting address 11, error -71
usb 4-6: USB disconnect, address 7
usb 4-6: new high speed USB device using ehci_hcd and address 12
usb 4-6: configuration #1 chosen from 1 choice
hub 4-6:1.0: USB hub found
hub 4-6:1.0: 4 ports detected
usb 4-6.1: new full speed USB device using ehci_hcd and address 13
usb 4-6.1: device descriptor read/64, error -32
usb 4-6.1: device descriptor read/64, error -32
usb 4-6.1: new full speed USB device using ehci_hcd and address 14
usb 4-6.1: device descriptor read/64, error -110
usb 4-6.1: device descriptor read/64, error -71
usb 4-6.1: new full speed USB device using ehci_hcd and address 15
usb 4-6.1: device not accepting address 15, error -71
usb 4-6.1: new full speed USB device using ehci_hcd and address 16
usb 4-6.1: device not accepting address 16, error -71
usb 4-6.1: new full speed USB device using ehci_hcd and address 17
usb 4-6.1: configuration #1 chosen from 1 choice
SCSI subsystem initialized
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new driver usb-storage
usb-storage: device found at 17
usb-storage: waiting for device to settle before scanning
USB Mass Storage support registered.
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
usb-storage: device scan complete
sd 0:0:0:0: Attached scsi removable disk sda
sd 0:0:0:1: Attached scsi removable disk sdb
sd 0:0:0:2: Attached scsi removable disk sdc
sd 0:0:0:3: Attached scsi removable disk sdd
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: reset full speed USB device using ehci_hcd and address 17
usb 4-6.1: USB disconnect, address 17

#########################

I have a solution/hint to solve this problem.

In my case I had following NOT WORKING config:

internal USB-Card PCI --> USB Hub --> Card Reader 
( ali usb card, i-rocks hub, Phision cardreader)

00:08.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:08.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:08.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:08.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)

linux sets it up using:

ehci --> ehci --> ehci (total usb 2.0 support)

Bus 004 Device 028: ID 0d7d:0240 Phison Electronics Corp. I/O-Magic/Transcend 
6-in-1 Card Reader
Bus 004 Device 027: ID 05e3:0605 Genesys Logic, Inc. USB 2.0 Hub [ednet]



but only the hub is a usb 2.0 compliant product. the card-reader is usb 1.1!!

So i changed physically the hub back to a 1.1 device.

and now linux sets this to 

ohci --> ohci --> ohci

Bus 003 Device 011: ID 0d7d:0240 Phison Electronics Corp. I/O-Magic/Transcend 
6-in-1 Card Reader
Bus 003 Device 010: ID 03eb:3301 Atmel Corp. at43301 4-port Hub


And this configuration works perfect, without any trouble any more.

So in my opinion the problem is comming from ehci, which tries to set up a usb 
1.1 device in a 2.0 mode. this results in severe timing problems, because the 
1.1 device is too slow to handle this protocol, this results in a "dead" 
device from the point of view of the driver (no reaction). It disconnects the 
device and reconnects it again. It is only a problem, if you use a HUB 
between the USB Controller and the end device. I think we have to take care 
about the last device in the chain to set it up in the correct way.

now log looks like this (and I am happy):

########################
usb 3-1: USB disconnect, address 8
ohci_hcd 0000:00:08.2: wakeup
usb 3-2: new full speed USB device using ohci_hcd and address 9
usb 3-2: configuration #1 chosen from 1 choice
drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 9 if 1 alt 0 
proto 2 vid 0x03F0 pid 0x2D11
usbcore: registered new driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
usb 3-1: new full speed USB device using ohci_hcd and address 10
usb 3-1: configuration #1 chosen from 1 choice
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 4 ports detected
usb 3-1.2: new full speed USB device using ohci_hcd and address 11
usb 3-1.2: configuration #1 chosen from 1 choice
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 11
usb-storage: waiting for device to settle before scanning
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
sd 2:0:0:0: Attached scsi removable disk sda
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
sd 2:0:0:1: Attached scsi removable disk sdb
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
sd 2:0:0:2: Attached scsi removable disk sdc
  Vendor:           Model: USB Card Reader   Rev: 1.05
  Type:   Direct-Access                      ANSI SCSI revision: 00
sd 2:0:0:3: Attached scsi removable disk sdd
usb-storage: device scan complete
SCSI device sda: 510976 512-byte hdwr sectors (262 MB)
sda: Write Protect is off
sda: Mode Sense: 43 00 00 00
sda: assuming drive cache: write through
SCSI device sda: 510976 512-byte hdwr sectors (262 MB)
sda: Write Protect is off
sda: Mode Sense: 43 00 00 00
sda: assuming drive cache: write through
 sda: sda1

##############################


I hope, that this will help you to work on this point.

Chears & have a nice day.

-- 
Wolfgang Schnitker
