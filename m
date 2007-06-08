Return-Path: <linux-kernel-owner+w=401wt.eu-S970619AbXFHWUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970619AbXFHWUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXFHWUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:20:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:29817 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXFHWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HAjS65KlZr7Rl6qFk9Adh6ENIeWjMmeZUCl9u0oN28vwzgpYbgqhpUup+uR2ri6rBfViVJGqM+EhUnF1dOYWA0y3OHWsbyzVC8FLnyjbP8gWL8/oo6e9MyzyyQUCk+aquo8I1ryyXUZUcOczxA2jOHkpy0zQiEha08M5kzE7kcg=
Message-ID: <4669D608.2070505@gmail.com>
Date: Sat, 09 Jun 2007 00:19:52 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       Joel.Becker@oracle.com,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
References: <Pine.LNX.4.44L0.0706081021400.3473-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706081021400.3473-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Robert, it would help somewhat if you could build a kernel with 
> CONFIG_USB_DEBUG turned on and post the dmesg log showing what happens 
> when you plug in one of those non-working devices.
>   
Sorry, yes I should have done that before...
> Yes, in principle Linux can be made to switch over to full speed when 
> high speed fails.  But there are limitations: The switchover would work 
> only for devices plugged directly into the computer, not for devices 
> plugged into a high-speed hub.  And some Linux systems (not regular 
> PCs) have EHCI implementations that don't allow such a switch -- or 
> if they do, I'm not aware of how to accomplish it.
>   
Interesting, I have a USB 2.0 hub, but have not tried it, mainly because 
I need to find a power supply for it first.
But regardless if the hub works as USB 2.0 or 1.1, it could be that 
another hub behaves differently, just like I have one USB 2.0 memory key 
that still works as such.
> BTW, depending on the kind of failure the system does not keep 
> retrying indefinitely.  It gives up after four attempts.
>
> Alan Stern
***USB related boot messages with CONFIG_USB_DEBUG enabled
Jun  8 23:33:30 localhost kernel: USB Universal Host Controller 
Interface driver v3.0
Jun  8 23:33:30 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> 
Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.0: UHCI Host 
Controller
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.0: new USB bus 
registered, assigned bus number 1
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.0: detected 2 ports
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.0: irq 11, io base 
0x00001800
Jun  8 23:33:30 localhost kernel: usb usb1: Product: UHCI Host Controller
Jun  8 23:33:30 localhost kernel: usb usb1: Manufacturer: Linux 
2.6.22-rc4 uhci_hcd
Jun  8 23:33:30 localhost kernel: usb usb1: SerialNumber: 0000:00:1d.0
Jun  8 23:33:30 localhost kernel: usb usb1: configuration #1 chosen from 
1 choice
Jun  8 23:33:30 localhost kernel: hub 1-0:1.0: USB hub found
Jun  8 23:33:30 localhost kernel: hub 1-0:1.0: 2 ports detected
Jun  8 23:33:30 localhost kernel: ACPI: PCI Interrupt Link [LNKD] 
enabled at IRQ 11
Jun  8 23:33:30 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> 
Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.1: UHCI Host 
Controller
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.1: new USB bus 
registered, assigned bus number 2
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.1: detected 2 ports
Jun  8 23:33:30 localhost kernel: uhci_hcd 0000:00:1d.1: irq 11, io base 
0x00001820
Jun  8 23:33:30 localhost kernel: usb usb2: Product: UHCI Host Controller
Jun  8 23:33:30 localhost kernel: usb usb2: Manufacturer: Linux 
2.6.22-rc4 uhci_hcd
Jun  8 23:33:30 localhost kernel: usb usb2: SerialNumber: 0000:00:1d.1
Jun  8 23:33:31 localhost kernel: usb usb2: configuration #1 chosen from 
1 choice
Jun  8 23:33:31 localhost rpcbind: cannot create socket for udp6
Jun  8 23:33:31 localhost kernel: hub 2-0:1.0: USB hub found
Jun  8 23:33:31 localhost kernel: hub 2-0:1.0: 2 ports detected
Jun  8 23:33:31 localhost rpcbind: cannot create socket for tcp6
Jun  8 23:33:31 localhost kernel: ACPI: PCI Interrupt Link [LNKC] 
enabled at IRQ 11
Jun  8 23:33:31 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> 
Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
Jun  8 23:33:31 localhost kernel: uhci_hcd 0000:00:1d.2: UHCI Host 
Controller
Jun  8 23:33:31 localhost kernel: uhci_hcd 0000:00:1d.2: new USB bus 
registered, assigned bus number 3
Jun  8 23:33:31 localhost kernel: uhci_hcd 0000:00:1d.2: detected 2 ports
Jun  8 23:33:31 localhost kernel: uhci_hcd 0000:00:1d.2: irq 11, io base 
0x00001840
Jun  8 23:33:31 localhost kernel: usb usb3: Product: UHCI Host Controller
Jun  8 23:33:31 localhost kernel: usb usb3: Manufacturer: Linux 
2.6.22-rc4 uhci_hcd
Jun  8 23:33:31 localhost kernel: usb usb3: SerialNumber: 0000:00:1d.2
Jun  8 23:33:31 localhost kernel: usb usb3: configuration #1 chosen from 
1 choice
Jun  8 23:33:31 localhost kernel: hub 3-0:1.0: USB hub found
Jun  8 23:33:31 localhost kernel: hub 3-0:1.0: 2 ports detected
Jun  8 23:33:31 localhost kernel: ACPI: PCI Interrupt Link [LNKH] 
enabled at IRQ 11
Jun  8 23:33:31 localhost kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> 
Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
Jun  8 23:33:31 localhost kernel: ehci_hcd 0000:00:1d.7: EHCI Host 
Controller
Jun  8 23:33:31 localhost kernel: ehci_hcd 0000:00:1d.7: new USB bus 
registered, assigned bus number 4
Jun  8 23:33:31 localhost kernel: ehci_hcd 0000:00:1d.7: debug port 1
Jun  8 23:33:31 localhost kernel: ehci_hcd 0000:00:1d.7: irq 11, io mem 
0xc0000000
Jun  8 23:33:31 localhost kernel: ehci_hcd 0000:00:1d.7: USB 2.0 
started, EHCI 1.00, driver 10 Dec 2004
Jun  8 23:33:31 localhost kernel: usb usb4: Product: EHCI Host Controller
Jun  8 23:33:31 localhost kernel: usb usb4: Manufacturer: Linux 
2.6.22-rc4 ehci_hcd
Jun  8 23:33:31 localhost kernel: usb usb4: SerialNumber: 0000:00:1d.7
Jun  8 23:33:31 localhost kernel: usb usb4: configuration #1 chosen from 
1 choice
Jun  8 23:33:31 localhost kernel: hub 4-0:1.0: USB hub found

*** Plug USB 2.0 128MB memory key (with ehci-hcd loaded)
Jun  8 23:35:14 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 14
Jun  8 23:35:18 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 35
Jun  8 23:35:19 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 39
Jun  8 23:35:19 localhost kernel: ehci_hcd 0000:00:1d.7: port 4 reset 
error -110
Jun  8 23:35:19 localhost kernel: hub 4-0:1.0: hub_port_status failed 
(err = -32)
Jun  8 23:35:19 localhost kernel: ehci_hcd 0000:00:1d.7: port 4 reset 
error -110
Jun  8 23:35:19 localhost kernel: hub 4-0:1.0: hub_port_status failed 
(err = -32)
Jun  8 23:35:19 localhost kernel: hub 4-0:1.0: Cannot enable port 4.  
Maybe the USB cable is bad?
Jun  8 23:35:19 localhost kernel: ehci_hcd 0000:00:1d.7: port 4 reset 
error -110
Jun  8 23:35:19 localhost kernel: hub 4-0:1.0: hub_port_status failed 
(err = -32)
Jun  8 23:35:22 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 55
Jun  8 23:35:23 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 56
Jun  8 23:35:23 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 60
Jun  8 23:35:24 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 66
Jun  8 23:35:25 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 69
Jun  8 23:35:28 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 87
Jun  8 23:35:28 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 88
Jun  8 23:35:29 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 93
Jun  8 23:35:29 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 95
Jun  8 23:35:31 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 105
Jun  8 23:35:35 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 3
Jun  8 23:35:36 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 11
Jun  8 23:35:37 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 16
Jun  8 23:35:38 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 18
Jun  8 23:35:40 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 31
Jun  8 23:35:41 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 36
Jun  8 23:35:42 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 43
Jun  8 23:35:43 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 49
Jun  8 23:35:44 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 55
Jun  8 23:35:44 localhost kernel: ehci_hcd 0000:00:1d.7: port 4 reset 
error -110
Jun  8 23:35:44 localhost kernel: hub 4-0:1.0: hub_port_status failed 
(err = -32)
Jun  8 23:35:45 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 58
Jun  8 23:35:46 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 59
Jun  8 23:35:50 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 87
Jun  8 23:35:51 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 92
Jun  8 23:35:52 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 99
Jun  8 23:35:53 localhost kernel: ehci_hcd 0000:00:1d.7: port 4 reset 
error -110
Jun  8 23:35:53 localhost kernel: hub 4-0:1.0: hub_port_status failed 
(err = -32)
Jun  8 23:35:54 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 105
Jun  8 23:35:54 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 106
Jun  8 23:35:54 localhost kernel: ehci_hcd 0000:00:1d.7: port 4 reset 
error -110
Jun  8 23:35:54 localhost kernel: hub 4-0:1.0: hub_port_status failed 
(err = -32)
Jun  8 23:35:56 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 112
Jun  8 23:35:58 localhost kernel: usb 4-4: new high speed USB device 
using ehci_hcd and address 122

*** unplug USB key, rmmod ehci-hcd
Jun  8 23:36:26 localhost kernel: ehci_hcd 0000:00:1d.7: remove, state 4
Jun  8 23:36:26 localhost kernel: usb usb4: USB disconnect, address 1
Jun  8 23:36:26 localhost kernel: ehci_hcd 0000:00:1d.7: USB bus 4 
deregistered
Jun  8 23:36:26 localhost kernel: ACPI: PCI interrupt for device 
0000:00:1d.7 disabled

*** plug USB key (without ehci-hcd)
Jun  8 23:36:41 localhost kernel: usb 2-2: new full speed USB device 
using uhci_hcd and address 2
Jun  8 23:36:41 localhost kernel: usb 2-2: Product: IBM USB Memory Key
Jun  8 23:36:41 localhost kernel: usb 2-2: Manufacturer: IBM
Jun  8 23:36:41 localhost kernel: usb 2-2: configuration #1 chosen from 
1 choice
Jun  8 23:36:41 localhost kernel: Initializing USB Mass Storage driver...
Jun  8 23:36:41 localhost kernel: scsi2 : SCSI emulation for USB Mass 
Storage devices
Jun  8 23:36:41 localhost kernel: usbcore: registered new interface 
driver usb-storage
Jun  8 23:36:41 localhost kernel: USB Mass Storage support registered.
Jun  8 23:36:46 localhost kernel: scsi 2:0:0:0: Direct-Access     
IBM      Memory Key       1.01 PQ: 0 ANSI: 0 CCS
Jun  8 23:36:46 localhost kernel: sd 2:0:0:0: [sdc] Attached SCSI 
removable disk
Jun  8 23:36:46 localhost kernel: sd 2:0:0:0: Attached scsi generic sg2 
type 0
Jun  8 23:36:47 localhost kernel: sd 2:0:0:0: [sdc] 256000 512-byte 
hardware sectors (131 MB)
Jun  8 23:36:47 localhost kernel: sd 2:0:0:0: [sdc] Write Protect is off
Jun  8 23:36:47 localhost kernel: sd 2:0:0:0: [sdc] Assuming drive 
cache: write through
Jun  8 23:36:47 localhost kernel: sd 2:0:0:0: [sdc] 256000 512-byte 
hardware sectors (131 MB)
Jun  8 23:36:47 localhost kernel: sd 2:0:0:0: [sdc] Write Protect is off
Jun  8 23:36:47 localhost kernel: sd 2:0:0:0: [sdc] Assuming drive 
cache: write through
Jun  8 23:36:47 localhost kernel:  sdc: sdc1
Jun  8 23:36:48 localhost hald: mounted /dev/sdc1 on behalf of uid 0

