Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXFIVn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXFIVn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 17:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760510AbXFIVnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 17:43:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:10952 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760610AbXFIVns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 17:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=n22tnkSQDIKm0hpD/NlcwySDXSrR7SIUEC2hA0YpLbsFO2BJbJpEWtUD1Z9CUQww7/hs9FOagWRKGLIRF0ougWpFinDrrpiEzDC4GVXPWrM9cn/eYmNZvgx12koq8GTd8A39Owb2OM/S+2HaBDQMTKijRM5jwPeXwsUQ/nD/IGU=
Message-ID: <466B3B20.5040003@gmail.com>
Date: Sun, 10 Jun 2007 01:43:28 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       Joel.Becker@oracle.com,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
References: <Pine.LNX.4.44L0.0706091716590.30086-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706091716590.30086-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Unfortunately you posted the system log file instead of the dmesg log, 
> and your syslogd was configured not to retain debug-level messages.
>   
Ok, I did not realize my syslog was filtering the debug-level messages, 
here is the output from dmesg

***USB related boot messages
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, 
low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc4 uhci_hcd
usb usb1: SerialNumber: 0000:00:1d.0
PM: Adding info for usb:usb1
usb usb1: uevent
usb usb1: usb_probe_device
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
PM: Adding info for usb:1-0:1.0
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
PM: Adding info for No Bus:usbdev1.1_ep81
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, 
low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
usb usb2: default language 0x0409
usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc4 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.1
PM: Adding info for usb:usb2
usb usb2: uevent
usb usb2: usb_probe_device
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
PM: Adding info for usb:2-0:1.0
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
PM: Adding info for No Bus:usbdev2.1_ep81
drivers/usb/core/inode.c: creating file '001'
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 11 (level, 
low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
usb usb3: default language 0x0409
usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc4 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.2
PM: Adding info for usb:usb3
usb usb3: uevent
usb usb3: usb_probe_device
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
PM: Adding info for usb:3-0:1.0
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
PM: Adding info for No Bus:usbdev3.1_ep81
drivers/usb/core/inode.c: creating file '001'
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 11 (level, 
low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 
ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 
bit addr
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xc0000000
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 
period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: default language 0x0409
usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: EHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.22-rc4 ehci_hcd
usb usb4: SerialNumber: 0000:00:1d.7
PM: Adding info for usb:usb4
usb usb4: uevent
usb usb4: usb_probe_device
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
PM: Adding info for usb:4-0:1.0
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: Single TT
hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 4-0:1.0: power on to power good time: 20ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub

usb usb1: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
Clocksource tsc unstable (delta = -65524005 ns)
hub 1-0:1.0: hub_suspend
usb usb1: suspend_rh
usb usb1: usb auto-suspend
hub 2-0:1.0: hub_suspend
usb usb2: suspend_rh
usb usb2: usb auto-suspend
hub 3-0:1.0: hub_suspend
usb usb3: suspend_rh
usb usb3: usb auto-suspend
hub 4-0:1.0: hub_suspend
ehci_hcd 0000:00:1d.7: suspend root hub
usb usb4: usb auto-suspend

usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent

usb usb4: usb auto-resume
usb usb4: finish resume
hub 4-0:1.0: hub_resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
usb usb3: usb auto-resume
usb usb3: finish resume
hub 3-0:1.0: hub_resume
usb usb3: wakeup_rh
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb2: usb auto-resume
usb usb2: finish resume
hub 2-0:1.0: hub_resume
usb usb2: wakeup_rh
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb1: usb auto-resume
usb usb1: finish resume
hub 1-0:1.0: hub_resume
usb usb1: wakeup_rh
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: suspend_rh (auto-stop)
usb usb2: suspend_rh (auto-stop)
usb usb1: suspend_rh (auto-stop)
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
hub 4-0:1.0: hub_suspend
ehci_hcd 0000:00:1d.7: suspend root hub
usb usb4: usb auto-suspend
hub 3-0:1.0: hub_suspend
usb usb3: suspend_rh
usb usb3: usb auto-suspend
hub 2-0:1.0: hub_suspend
usb usb2: suspend_rh
usb usb2: usb auto-suspend
hub 1-0:1.0: hub_suspend
usb usb1: suspend_rh
usb usb1: usb auto-suspend

*** plugging device (leaving it in slightly to long, hence the long 
log); removing the device; rmmod ehci-hcd; plug back in
usb usb4: usb resume
usb usb4: finish resume
hub 4-0:1.0: hub_resume
ehci_hcd 0000:00:1d.7: resume root hub
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 15
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 20
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 38
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 43
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001004 POWER sig=se0 PE
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 49
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 53
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 62
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001004 POWER sig=se0 PE
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 95
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 110
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
CONNECT
usb 4-4: new high speed USB device using ehci_hcd and address 117
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001007 POWER sig=se0 PE 
CSC CONNECT
hub 4-0:1.0: port_wait_reset: err = -22
hub 4-0:1.0: port 4 not enabled, trying reset again...
ehci_hcd 0000:00:1d.7: port 4 reset error -110
hub 4-0:1.0: hub_port_status failed (err = -32)
hub 4-0:1.0: port_wait_reset: err = -32
hub 4-0:1.0: port 4 not enabled, trying reset again...
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port_wait_reset: err = -22
hub 4-0:1.0: port 4 not enabled, trying reset again...
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
CONNECT
hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 4-0:1.0: hub_suspend
ehci_hcd 0000:00:1d.7: suspend root hub
usb usb4: usb auto-suspend
ehci_hcd 0000:00:1d.7: remove, state 4
ehci_hcd 0000:00:1d.7: roothub graceful disconnect
usb usb4: USB disconnect, address 1
usb usb4: unregistering device
usb usb4: usb_disable_device nuking all URBs
usb usb4: unregistering interface 4-0:1.0
PM: Removing info for No Bus:usbdev4.1_ep81
usb_endpoint usbdev4.1_ep81: ep_device_release called for usbdev4.1_ep81
PM: Removing info for usb:4-0:1.0
usb 4-0:1.0: uevent
usb 4-0:1.0: uevent
PM: Removing info for No Bus:usbdev4.1_ep00
usb_endpoint usbdev4.1_ep00: ep_device_release called for usbdev4.1_ep00
PM: Removing info for usb:usb4
usb usb4: uevent
ehci_hcd 0000:00:1d.7: stop
ehci_hcd 0000:00:1d.7: reset command 010002 (park)=0 ithresh=1 
period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: irq normal 0 err 33 reclaim 33 (lost 0)
ehci_hcd 0000:00:1d.7: complete 33 unlink 0
ehci_hcd 0000:00:1d.7: ehci_stop completed status 1000 Halt
ehci_hcd 0000:00:1d.7: USB bus 4 deregistered
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
usb usb2: usb resume
usb usb2: finish resume
hub 2-0:1.0: hub_resume
usb usb2: wakeup_rh
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
uhci_hcd 0000:00:1d.1: port 2 portsc 0093,00
hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: default language 0x0409
usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: IBM USB Memory Key
usb 2-2: Manufacturer: IBM
PM: Adding info for usb:2-2
usb 2-2: uevent
usb 2-2: usb_probe_device
PM: Adding info for No Bus:usbdev2.2_ep00
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
PM: Adding info for usb:2-2:1.0
usb 2-2:1.0: uevent
usb 2-2:1.0: uevent
libusual 2-2:1.0: usb_probe_interface
libusual 2-2:1.0: usb_probe_interface - got id
PM: Adding info for No Bus:usbdev2.2_ep01
PM: Adding info for No Bus:usbdev2.2_ep82
drivers/usb/core/inode.c: creating file '002'
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
Initializing USB Mass Storage driver...
usb-storage 2-2:1.0: usb_probe_interface
usb-storage 2-2:1.0: usb_probe_interface - got id
scsi2 : SCSI emulation for USB Mass Storage devices
PM: Adding info for No Bus:host2
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
PM: Adding info for No Bus:target2:0:0
scsi 2:0:0:0: Direct-Access     IBM      Memory Key       1.01 PQ: 0 
ANSI: 0 CCS
PM: Adding info for No Bus:target2:0:1
PM: Removing info for No Bus:target2:0:1
PM: Adding info for No Bus:target2:0:2
PM: Removing info for No Bus:target2:0:2
PM: Adding info for No Bus:target2:0:3
PM: Removing info for No Bus:target2:0:3
PM: Adding info for No Bus:target2:0:4
PM: Removing info for No Bus:target2:0:4
PM: Adding info for No Bus:target2:0:5
PM: Removing info for No Bus:target2:0:5
PM: Adding info for No Bus:target2:0:6
PM: Removing info for No Bus:target2:0:6
PM: Adding info for No Bus:target2:0:7
PM: Removing info for No Bus:target2:0:7
PM: Adding info for scsi:2:0:0:0
sd 2:0:0:0: [sdc] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 2:0:0:0: [sdc] 256000 512-byte hardware sectors (131 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 43 00 00 00
sd 2:0:0:0: [sdc] Assuming drive cache: write through
sd 2:0:0:0: [sdc] 256000 512-byte hardware sectors (131 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 43 00 00 00
sd 2:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1

