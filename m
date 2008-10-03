Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYJCKtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYJCKtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYJCKs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:48:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:10481 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbYJCKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EeB1iHVW4Nk3bMLqQxoRpVb9gwDp7+UG40VQpp4FC7C1FnDxHLo4inVFbKdXH/rqvK
         2tgljCw0gOjU8uGHBEnkcTmYVwPleJB83KAfNutRqIPcNvrMaj563YI0tCyR0deHCdYQ
         1ZkOfK+qu/vMsLrsxUrxkzieXNf9U6xoRiCA0=
Message-ID: <f1c9d250810030348h5c61241fg79bf769e1da16a8@mail.gmail.com>
Date: Fri, 3 Oct 2008 16:18:55 +0530
From: Tej <bewith.tej@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: Kernel PANIC with 2.6.27-rc6
Cc: "Jason Wessel" <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080926085033.GA16849@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f1c9d250809110841s5c3d08b9ha93f0ef1da58642a@mail.gmail.com>
	 <48C94F65.3050405@windriver.com>
	 <f1c9d250809250735i4b98201ft753d6ec2959097e6@mail.gmail.com>
	 <20080925145635.GA7277@localhost> <20080925154724.GB7277@localhost>
	 <f1c9d250809251134j6fac8bfu43f08cbf2b330f0a@mail.gmail.com>
	 <20080925193956.GF7259@localhost> <20080926085033.GA16849@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/08, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Cyrill Gorcunov - Thu, Sep 25, 2008 at 11:39:56PM +0400]
> | [Tej - Fri, Sep 26, 2008 at 12:04:30AM +0530]
> | ...
> |
> | Btw Tej, could you please apply this patch
> | and check if it help.
> |
> | 	http://lkml.org/lkml/2008/9/22/250
> |
> | Aristeu Rozanski fixed one race window which take
> | place on unpredicted nmi's.
> |
> | 		- Cyrill -
>
> Btw Tej, could you post boot log if kernel were started as
>
> 	root=/dev/sda1 ro debug apic=debug kgdbts=V2 splash console=tty0
> console=ttyS0,
sorry for this long pause.

machine boots fine with the options specified, and logs are collected
as follows.
some warning related to sysctl table checking, but its related to
libvirtd (KVM) at the end.

7b0084f7ffff0000ffff0000#2f
Singlestep stopped at IP: c02a5e91
get8: $Z0,c02a5e90,1#3c
put8: $OK#9a
get9: $c#63
kgdbts: breakpoint complete
put9: $T05thread:0000000000000001;#a7
get10: $g#67
put10: $105f6dc08600000000c01001e403000068672ac04c1f84f700000000e8030000915e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#0a
Stopped at IP: c02a5e91
get11: $G105f6dc08600000000c01001e4030000000000004c1f84f700000000e8030000905e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#cf
put11: $OK#9a
get12: $D#44
put12: $OK#9a
kgdbts: breakpoint complete
get0: $?#3f
put0: $S05#b8
get1: $Z0,c02a5e90,1#3c
put1: $OK#9a
get2: $c#63
put2: $T05thread:0000000000000001;#a7
get3: $g#67
put3: $000000000000000084030000e503000063672ac04c1f84f700000000e8030000915e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#29
Stopped at IP: c02a5e91
get4: $G000000000000000084030000e5030000000000004c1f84f700000000e8030000905e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#f3
put4: $OK#9a
get5: $z0,c02a5e90,1#5c
put5: $OK#9a
get6: $s#73
put6: $T05thread:0000000000000001;#a7
get7: $g#67
put7: $000000000000000084030000e50300004c1f84f74c1f84f700000000e8030000915e2ac04603000060000000680000007b0000007b0084f7ffff0000ffff0000#30
Singlestep stopped at IP: c02a5e91
get8: $Z0,c02a5e90,1#3c
put8: $OK#9a
get9: $c#63
kgdbts: breakpoint complete
put9: $T05thread:0000000000000001;#a7
get10: $g#67
put10: $105f6dc08600000000c01001e503000068672ac04c1f84f700000000e8030000915e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#0b
Stopped at IP: c02a5e91
get11: $G105f6dc08600000000c01001e5030000000000004c1f84f700000000e8030000905e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#d0
put11: $OK#9a
get12: $D#44
put12: $OK#9a
kgdbts: breakpoint complete
get0: $?#3f
put0: $S05#b8
get1: $Z0,c02a5e90,1#3c
put1: $OK#9a
get2: $c#63
put2: $T05thread:0000000000000001;#a7
get3: $g#67
put3: $000000000000000084030000e603000063672ac04c1f84f700000000e8030000915e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#2a
Stopped at IP: c02a5e91
get4: $G000000000000000084030000e6030000000000004c1f84f700000000e8030000905e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#f4
put4: $OK#9a
get5: $z0,c02a5e90,1#5c
put5: $OK#9a
get6: $s#73
put6: $T05thread:0000000000000001;#a7
get7: $g#67
put7: $000000000000000084030000e60300004c1f84f74c1f84f700000000e8030000915e2ac04603000060000000680000007b0000007b0084f7ffff0000ffff0000#31
Singlestep stopped at IP: c02a5e91
get8: $Z0,c02a5e90,1#3c
put8: $OK#9a
get9: $c#63
kgdbts: breakpoint complete
put9: $T05thread:0000000000000001;#a7
get10: $g#67
put10: $105f6dc08600000000c01001e603000068672ac04c1f84f700000000e8030000915e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#0c
Stopped at IP: c02a5e91
get11: $G105f6dc08600000000c01001e6030000000000004c1f84f700000000e8030000905e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#d1
put11: $OK#9a
get12: $D#44
put12: $OK#9a
kgdbts: breakpoint complete
get0: $?#3f
put0: $S05#b8
get1: $Z0,c02a5e90,1#3c
put1: $OK#9a
get2: $c#63
put2: $T05thread:0000000000000001;#a7
get3: $g#67
put3: $000000000000000084030000e703000063672ac04c1f84f700000000e8030000915e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#2b
Stopped at IP: c02a5e91
get4: $G000000000000000084030000e7030000000000004c1f84f700000000e8030000905e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#f5
put4: $OK#9a
get5: $z0,c02a5e90,1#5c
put5: $OK#9a
get6: $s#73
put6: $T05thread:0000000000000001;#a7
get7: $g#67
put7: $000000000000000084030000e70300004c1f84f74c1f84f700000000e8030000915e2ac04603000060000000680000007b0000007b0084f7ffff0000ffff0000#32
Singlestep stopped at IP: c02a5e91
get8: $Z0,c02a5e90,1#3c
put8: $OK#9a
get9: $c#63
kgdbts: breakpoint complete
put9: $T05thread:0000000000000001;#a7
get10: $g#67
put10: $105f6dc08600000000c01001e703000068672ac04c1f84f700000000e8030000915e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#0d
Stopped at IP: c02a5e91
get11: $G105f6dc08600000000c01001e7030000000000004c1f84f700000000e8030000905e2ac04602000060000000680000007b0084f77b0011c0ffff0000ffff0000#d2
put11: $OK#9a
get12: $D#44
put12: $OK#9a
kgdbts: breakpoint complete
kgdbts:RUN hw breakpoint test
get0: $?#3f
put0: $S05#b8
get1: $Z1,c02a5e90,1#3d
put1: $OK#9a
get2: $c#63
put2: $T05thread:0000000000000001;#a7
get3: $g#67
put3: $000000000000000046000000010000007a602ac01c1f84f700000000e8030000905e2ac00202000060000000680000007b0000007b000000ffff0000ffff0000#86
Stopped at IP: c02a5e90
get4: $G00000000000000004600000001000000000000001c1f84f700000000e8030000905e2ac00202000060000000680000007b0000007b000000ffff0000ffff0000#29
put4: $OK#9a
get5: $z1,c02a5e90,1#5d
put5: $OK#9a
get6: $D#44
put6: $OK#9a
kgdbts: breakpoint complete
get7: $D#44
put7: $OK#9a
kgdbts:RUN hw write breakpoint test
get0: $?#3f
put0: $S05#b8
get1: $Z2,c071955c,1#16
put1: $OK#9a
get2: $c#63
put2: $T05thread:0000000000000001;#a7
get3: $g#67
put3: $00000000000000004600000001000000c8e658c01c1f84f700000000e80300009f5f2ac00202000060000000680000007b0011c07b00ffffffff0000ffff0000#dc
Stopped at IP: c02a5f9f
get4: $G00000000000000004600000001000000000000001c1f84f700000000e80300009f5f2ac00202000060000000680000007b0011c07b00ffffffff0000ffff0000#6d
put4: $OK#9a
get5: $z2,c071955c,1#36
put5: $OK#9a
get6: $D#44
put6: $OK#9a
get7: $D#44
put7: $OK#9a
kgdbts:RUN access write breakpoint test
get0: $?#3f
put0: $S05#b8
get1: $Z4,c071955c,1#18
put1: $OK#9a
get2: $c#63
put2: $T05thread:0000000000000001;#a7
get3: $g#67
put3: $01000000000000004600000000000000f0e658c01c1f84f700000000e8030000ff5f2ac04602000060000000680000007b0011c07b00ffffffff0000ffff0000#0c
Stopped at IP: c02a5fff
get4: $G01000000000000004600000000000000000000001c1f84f700000000e8030000ff5f2ac04602000060000000680000007b0011c07b00ffffffff0000ffff0000#a2
put4: $OK#9a
get5: $z4,c071955c,1#38
put5: $OK#9a
get6: $D#44
put6: $OK#9a
get7: $D#44
put7: $OK#9a
kgdb: Unregistered I/O driver kgdbts, debugger disabled.
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
IOAPIC[0]: Set PCI routing entry (2-20 -> 0xc9 -> IRQ 20 Mode:1 Active:1)
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:19:d1:9f:c8:96
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
Probing IDE interface ide0...
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
Adaptec aacraid driver 1.1-5[2456]-ms
QLogic Fibre Channel HBA Driver: 8.02.01-k7
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.002.
Driver 'sd' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x2438 ctl 0x2454 bmdma 0x2410 irq 19
ata2: SATA max UDMA/133 cmd 0x2430 ctl 0x2450 bmdma 0x2418 irq 19
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD1600AAJS-22PSA0, 05.06H05, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-2 05.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata_piix 0000:00:1f.5: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x2428 ctl 0x244c bmdma 0x20f0 irq 19
ata4: SATA max UDMA/133 cmd 0x2420 ctl 0x2448 bmdma 0x20f8 irq 19
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
pata_marvell 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pata_marvell 0000:02:00.0: setting latency timer to 64
scsi4 : pata_marvell
scsi5 : pata_marvell
ata5: PATA max UDMA/100 cmd 0x1018 ctl 0x1024 bmdma 0x1000 irq 17
ata6: DUMMY
ata5.01: ATAPI: SAMSUNG CD-ROM  SC-152L, C100, max MWDMA2
ata5.01: configured for MWDMA2
scsi 4:0:1:0: CD-ROM            SAMSUNG  CD-ROM SC-152L   C100 PQ: 0 ANSI: 5
scsi 4:0:1:0: Attached scsi generic sg1 type 5
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
usbmon: debugfs is not available
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020a0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
IOAPIC[0]: Set PCI routing entry (2-21 -> 0xd1 -> IRQ 21 Mode:1 Active:1)
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00002080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
IOAPIC[0]: Set PCI routing entry (2-23 -> 0xd9 -> IRQ 23 Mode:1 Active:1)
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:0a: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:09: driver attached
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
Bridge firewalling registered
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Starting balanced_irq
Using IPI No-Shortcut mode
Freeing unused kernel memory: 312k freed
usplash[1400]: segfault at c0014 ip 00000014 sp 00000ffa error 15 in mem[0+1000]
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda1: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 552246
EXT3-fs: sda1: 1 orphan inode deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Linux agpgart interface v0.103
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [SLPB]
agpgart-intel 0000:00:00.0: Intel 965Q Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x40000000
warning: `ntpd' uses 32-bit capabilities (legacy support in use)
0000:00:19.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: None
0000:00:19.0: eth0: 10/100 speed: disabling TSO
Adding 2000052k swap on /dev/sda10.  Priority:-1 extents:1 across:2000052k
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
device eth0 entered promiscuous mode
br0: port 1(eth0) entering learning state
br0: topology change detected, propagating
br0: port 1(eth0) entering forwarding state


sysctl table check failed: /net/ipv4/conf/default/log_martians
.3.5.16.4.11 Sysctl already exists
Pid: 5691, comm: libvirtd Not tainted 2.6.27-rc7 #1
 [<c013d4b5>] set_fail+0x45/0x60
 [<c013d785>] sysctl_check_table+0x2b5/0x610
 [<c013d79e>] sysctl_check_table+0x2ce/0x610
 [<c013d79e>] sysctl_check_table+0x2ce/0x610
 [<c013d79e>] sysctl_check_table+0x2ce/0x610
 [<c013d79e>] sysctl_check_table+0x2ce/0x610
 [<c012ce19>] __register_sysctl_paths+0xc9/0x2c0
 [<c011f7f2>] ? try_to_wake_up+0xc2/0x160
 [<c04a672f>] register_net_sysctl_table+0x4f/0x60
 [<c04722f3>] __devinet_sysctl_register+0xd3/0x100
 [<c047236c>] devinet_sysctl_register+0x4c/0x60
 [<c047241c>] inetdev_init+0x9c/0x110
 [<c044699b>] ? nlmsg_notify+0x3b/0x80
 [<c047373b>] inetdev_event+0x22b/0x370
 [<c013c36d>] notifier_call_chain+0x2d/0x60
 [<c013c429>] __raw_notifier_call_chain+0x19/0x20
 [<c013c44a>] raw_notifier_call_chain+0x1a/0x20
 [<c0435a71>] call_netdevice_notifiers+0x11/0x20
 [<c0436310>] register_netdevice+0x200/0x340
 [<c048beb9>] br_add_bridge+0x159/0x190
 [<c048cac3>] br_ioctl_deviceless_stub+0x1d3/0x1e0
 [<c0429dae>] ? sock_attach_fd+0x8e/0xc0
 [<c048c8f0>] ? br_ioctl_deviceless_stub+0x0/0x1e0
 [<c042972f>] sock_ioctl+0xbf/0x210
 [<c0429670>] ? sock_ioctl+0x0/0x210
 [<c017d738>] vfs_ioctl+0x28/0x80
 [<c042a982>] ? sys_socket+0x52/0x70
 [<c017d9f2>] do_vfs_ioctl+0x262/0x2b0
 [<c017da79>] sys_ioctl+0x39/0x60
 [<c0103bd1>] sysenter_do_call+0x12/0x25
default: starting userspace STP failed, starting kernel STP
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0

thanks
HTH

>
> Ie your original option "quiet" is to be replace with "debug apic=debug
> kgdbts=V2".
> Thanks!
>
> 		- Cyrill -
>
