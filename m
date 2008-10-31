Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbYJaQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbYJaQv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYJaQvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:51:12 -0400
Received: from vena.lwn.net ([206.168.112.25]:53238 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYJaQvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:51:09 -0400
Date: Fri, 31 Oct 2008 10:51:05 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
Message-ID: <20081031105105.092ebad3@bike.lwn.net>
In-Reply-To: <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
	<490A5532.2000704@shaw.ca>
	<20081030205851.3208f52f@bike.lwn.net>
	<86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
	<alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
	<alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
	<20081031100040.1f0cf34f@bike.lwn.net>
	<alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 09:24:40 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Does this patch work for you?

Sort of.  Weirdly.

The system boots, and I get what appears to be a working eth0.  This
machine mounts some NFS filesystems, though, and as soon as I try to do
that, everything locks up.  I've come to expect NFS to be slow, but
that exceeds my expectations somewhat.

Other things seem to work, so, maybe, the NFS thing is a totally
different problem, don't know.

Nothing useful in the syslog, of course.  Here's dmesg, in case that
helps.  I have to run to a meeting, can't really look any deeper at the
moment.

Thanks,

jon

    5.498434] ehci_hcd 0000:00:1d.7: debug port 1
[    5.498487] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    5.498500] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980800
[    5.510020] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.510212] usb usb2: configuration #1 chosen from 1 choice
[    5.510322] hub 2-0:1.0: USB hub found
[    5.510374] hub 2-0:1.0: 6 ports detected
[    5.510601] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.510656] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.510729] usb usb2: Product: EHCI Host Controller
[    5.510779] usb usb2: Manufacturer: Linux 2.6.28-rc2 ehci_hcd
[    5.510831] usb usb2: SerialNumber: 0000:00:1d.7
[    5.510920] uhci_hcd: USB Universal Host Controller Interface driver
[    5.511003] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.511065] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.511068] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.511164] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.511267] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
[    5.511436] usb usb3: configuration #1 chosen from 1 choice
[    5.511542] hub 3-0:1.0: USB hub found
[    5.511595] hub 3-0:1.0: 2 ports detected
[    5.511812] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.511867] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.511940] usb usb3: Product: UHCI Host Controller
[    5.511991] usb usb3: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
[    5.512043] usb usb3: SerialNumber: 0000:00:1a.0
[    5.512112] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.512171] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.512174] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.512270] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.512371] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
[    5.512534] usb usb4: configuration #1 chosen from 1 choice
[    5.512638] hub 4-0:1.0: USB hub found
[    5.512690] hub 4-0:1.0: 2 ports detected
[    5.512911] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.512966] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.513039] usb usb4: Product: UHCI Host Controller
[    5.513090] usb usb4: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
[    5.513142] usb usb4: SerialNumber: 0000:00:1a.1
[    5.515364] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.515423] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.515426] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.515530] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    5.515625] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
[    5.515790] usb usb5: configuration #1 chosen from 1 choice
[    5.515892] hub 5-0:1.0: USB hub found
[    5.515944] hub 5-0:1.0: 2 ports detected
[    5.516166] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.516222] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.516294] usb usb5: Product: UHCI Host Controller
[    5.516344] usb usb5: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
[    5.516397] usb usb5: SerialNumber: 0000:00:1d.0
[    5.516463] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.516522] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.516525] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.516623] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    5.516718] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
[    5.516886] usb usb6: configuration #1 chosen from 1 choice
[    5.516993] hub 6-0:1.0: USB hub found
[    5.517048] hub 6-0:1.0: 2 ports detected
[    5.517283] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.517339] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.517411] usb usb6: Product: UHCI Host Controller
[    5.517462] usb usb6: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
[    5.517514] usb usb6: SerialNumber: 0000:00:1d.1
[    5.517580] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.517639] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.517642] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.517741] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    5.517836] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    5.517999] usb usb7: configuration #1 chosen from 1 choice
[    5.518104] hub 7-0:1.0: USB hub found
[    5.518157] hub 7-0:1.0: 2 ports detected
[    5.518393] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.518448] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.518521] usb usb7: Product: UHCI Host Controller
[    5.518571] usb usb7: Manufacturer: Linux 2.6.28-rc2 uhci_hcd
[    5.518624] usb usb7: SerialNumber: 0000:00:1d.2
[    5.518767] usbcore: registered new interface driver usblp
[    5.518820] Initializing USB Mass Storage driver...
[    5.518932] usbcore: registered new interface driver usb-storage
[    5.518986] USB Mass Storage support registered.
[    5.519194] PNP: No PS/2 controller found. Probing ports directly.
[    5.521837] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.521890] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.522076] mice: PS/2 mouse device common for all mice
[    5.522302] coretemp coretemp.0: Using relative temperature scale!
[    5.522450] coretemp coretemp.1: Using relative temperature scale!
[    5.522549] EDAC MC: Ver: 2.1.0 Oct 30 2008
[    5.523198] TCP bic registered
[    5.523246] NET: Registered protocol family 17
[    5.523499] registered taskstats version 1
[    5.649771] kjournald starting.  Commit interval 5 seconds
[    5.649861] EXT3-fs: mounted filesystem with ordered data mode.
[    5.649930] VFS: Mounted root (ext3 filesystem) readonly.
[    5.649992] Freeing unused kernel memory: 340k freed
[    5.853372] usb 2-3: new high speed USB device using ehci_hcd and address 2
[    5.977209] usb 2-3: configuration #1 chosen from 1 choice
[    5.977499] hub 2-3:1.0: USB hub found
[    5.977647] hub 2-3:1.0: 4 ports detected
[    5.978786] usb 2-3: New USB device found, idVendor=050d, idProduct=0234
[    5.978842] usb 2-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    6.310238] usb 3-2: new low speed USB device using uhci_hcd and address 2
[    6.480431] usb 3-2: configuration #1 chosen from 1 choice
[    6.483547] usb 3-2: New USB device found, idVendor=046d, idProduct=c01b
[    6.483603] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.483659] usb 3-2: Product: USB-PS/2 Optical Mouse
[    6.483709] usb 3-2: Manufacturer: Logitech
[    6.710036] usb 7-2: new full speed USB device using uhci_hcd and address 2
[    6.885947] usb 7-2: configuration #1 chosen from 1 choice
[    6.888832] hub 7-2:1.0: USB hub found
[    6.890736] hub 7-2:1.0: 3 ports detected
[    6.895994] usb 7-2: New USB device found, idVendor=046d, idProduct=0b04
[    6.896052] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.896110] usb 7-2: Product: Logitech BT Mini-Receiver
[    6.896163] usb 7-2: Manufacturer: Logitech
[    7.164707] usb 7-2.2: new full speed USB device using uhci_hcd and address 3
[    7.308906] usb 7-2.2: configuration #1 chosen from 1 choice
[    7.315002] usb 7-2.2: New USB device found, idVendor=046d, idProduct=c713
[    7.315005] usb 7-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.315007] usb 7-2.2: Product: Logitech BT Mini-Receiver
[    7.315009] usb 7-2.2: Manufacturer: Logitech
[    7.315011] usb 7-2.2: SerialNumber: 0007617AC3F9
[    7.382201] usb 7-2.3: new full speed USB device using uhci_hcd and address 4
[    7.525877] usb 7-2.3: configuration #1 chosen from 1 choice
[    7.532024] usb 7-2.3: New USB device found, idVendor=046d, idProduct=c714
[    7.532027] usb 7-2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.532030] usb 7-2.3: Product: Logitech BT Mini-Receiver
[    7.532031] usb 7-2.3: Manufacturer: Logitech
[    7.532033] usb 7-2.3: SerialNumber: 0007617AC3F9
[    8.910220] input: Power Button (FF) as /class/input/input0
[    8.934637] ACPI: Power Button (FF) [PWRF]
[    8.934730] input: Power Button (CM) as /class/input/input1
[    8.938782] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.938827] scsi 0:0:1:0: Attached scsi generic sg1 type 5
[    8.938868] sd 1:0:0:0: Attached scsi generic sg2 type 0
[    8.950224] ACPI: Power Button (CM) [VBTN]
[    8.996152] Driver 'sr' needs updating - please use bus_type methods
[    9.055986] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    9.055990] Uniform CD-ROM driver Revision: 3.20
[    9.056092] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    9.064793] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    9.080705] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    9.080855] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    9.199808] processor ACPI0007:00: registered as cooling_device0
[    9.199852] processor ACPI0007:01: registered as cooling_device1
[    9.239083] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    9.250964] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    9.250966] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    9.251024] e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    9.251035] e1000e 0000:00:19.0: setting latency timer to 64
[    9.251220] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[    9.320082] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
[    9.357086] generic-usb 0003:046D:C01B.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-2/input0
[    9.363702] input: Logitech Logitech BT Mini-Receiver as /class/input/input3
[    9.390192] generic-usb 0003:046D:C713.0002: input,hidraw1: USB HID v1.11 Keyboard [Logitech Logitech BT Mini-Receiver] on usb-0000:00:1d.2-2.2/input0
[    9.392467] usbcore: registered new interface driver usbhid
[    9.392473] usbhid: v2.6:USB HID core driver
[    9.445987] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:a0:e1:c3:e9
[    9.445990] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    9.446014] 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: 1041ff-0ff
[    9.462560] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.462967] 0000:00:03.3: ttyS1 at I/O 0xec98 (irq = 17) is a 16550A
[    9.742862] Linux video capture interface: v2.00
[    9.776865] i2c_algo_bit: exports duplicate symbol i2c_bit_add_numbered_bus (owned by kernel)
[    9.805792] ivtv:  Start initialization, version 1.4.0
[    9.805865] ivtv0: Initializing card #0
[    9.805867] ivtv0: Autodetected Hauppauge card (cx23416 based)
[    9.805931] ivtv 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.821075] input: Logitech Logitech BT Mini-Receiver as /class/input/input4
[    9.860073] tveeprom 1-0050: Hauppauge model 32062, rev C199, serial# 8510288
[    9.860077] tveeprom 1-0050: tuner model is TCL 2002N 5H (idx 99, type 50)
[    9.860080] tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
[    9.860082] tveeprom 1-0050: audio processor is MSP3445 (idx 12)
[    9.860084] tveeprom 1-0050: decoder processor is SAA7115 (idx 19)
[    9.860086] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
[    9.860090] ivtv0: Autodetected Hauppauge WinTV PVR-250
[    9.890336] logitech 0003:046D:C714.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech Logitech BT Mini-Receiver] on usb-0000:00:1d.2-2.3/input0
[   10.007907] saa7115 1-0021: saa7115 found (1f7115d0e100000) @ 0x42 (ivtv i2c driver #0)
[   10.137992] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.138050] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.148114] msp3400 1-0040: MSP3445G-B8 found @ 0x80 (ivtv i2c driver #0)
[   10.148117] msp3400 1-0040: msp3400 supports radio, mode is autodetect and autoselect
[   10.149466] tuner 1-0061: chip found @ 0xc2 (ivtv i2c driver #0)
[   10.149474] simple_tuner_attach: driver disabled by Kconfig
[   10.149872] ivtv0: Registered device video0 for encoder MPG (4096 kB)
[   10.149907] ivtv0: Registered device video32 for encoder YUV (2048 kB)
[   10.149941] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
[   10.149975] ivtv0: Registered device video24 for encoder PCM (320 kB)
[   10.149977] ivtv0: Initialized card #0: Hauppauge WinTV PVR-250
[   10.149997] ivtv:  End initialization
[   13.427494] EXT3 FS on sda7, internal journal
[   13.716544] kjournald starting.  Commit interval 5 seconds
[   13.716680] EXT3 FS on sda1, internal journal
[   13.716688] EXT3-fs: mounted filesystem with ordered data mode.
[   13.750347] kjournald starting.  Commit interval 5 seconds
[   13.750485] EXT3 FS on sda8, internal journal
[   13.750492] EXT3-fs: mounted filesystem with ordered data mode.
[   13.771320] kjournald starting.  Commit interval 5 seconds
[   13.771464] EXT3 FS on sda6, internal journal
[   13.771471] EXT3-fs: mounted filesystem with ordered data mode.
[   13.785773] kjournald starting.  Commit interval 5 seconds
[   13.785919] EXT3 FS on sda5, internal journal
[   13.785926] EXT3-fs: mounted filesystem with ordered data mode.
[   13.809261] kjournald starting.  Commit interval 5 seconds
[   13.809430] EXT3 FS on sda2, internal journal
[   13.809437] EXT3-fs: mounted filesystem with ordered data mode.
[   13.834247] kjournald starting.  Commit interval 5 seconds
[   13.834379] EXT3 FS on sda3, internal journal
[   13.834386] EXT3-fs: mounted filesystem with ordered data mode.
[   13.854431] kjournald starting.  Commit interval 5 seconds
[   13.854732] EXT3 FS on sdb1, internal journal
[   13.854739] EXT3-fs: mounted filesystem with ordered data mode.
[   15.088260] Adding 1020088k swap on /dev/sda9.  Priority:-1 extents:1 across:1020088k
[   15.499646] platform microcode: firmware: requesting intel-ucode/06-0f-0d
[   15.512295] platform microcode: firmware: requesting intel-ucode/06-0f-0d
[   15.515166] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk> <peter.oruba@amd.com>
[   15.737633] microcode: CPU0 updated from revision 0xa1 to 0xa3, date = 2007-08-13 
[   15.738989] microcode: CPU1 updated from revision 0xa1 to 0xa3, date = 2007-08-13 
[   15.763083] Microcode Update Driver: v2.00 removed.
[   16.520253] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   16.573398] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
[   17.964209] 0000:00:19.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   17.964212] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   22.593001] RPC: Registered udp transport module.
[   22.593004] RPC: Registered tcp transport module.
[   23.299570] fuse init (API version 7.10)
[   28.940019] ivtv 0000:02:00.0: firmware: requesting v4l-cx2341x-enc.fw
[   29.083553] ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
[   29.283495] ivtv0: Encoder revision: 0x02060039
[   29.304674] tuner 1-0061: Tuner has no way to set tv freq
[   29.369022] tuner 1-0061: Tuner has no way to set tv freq
[   32.545132] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   32.545136] pci 0000:00:02.0: enabling bus mastering
[   32.545140] pci 0000:00:02.0: setting latency timer to 64
[   32.545205] pci 0000:00:02.0: irq 45 for MSI/MSI-X
[   32.545361] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   32.556773] mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
