Return-Path: <linux-kernel-owner+w=401wt.eu-S1030200AbXBFWs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200AbXBFWs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030227AbXBFWs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:48:27 -0500
Received: from yuma.hostsharing.net ([212.42.230.35]:32854 "EHLO
	yuma.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200AbXBFWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:48:25 -0500
Date: Tue, 6 Feb 2007 23:48:09 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: UNS: Re: [Linux-fbdev-devel] radeonfb: Can't use the dvi port
Message-ID: <20070206224809.GA7510@frodo.home.lxtec.de>
Mail-Followup-To: linux-fbdev-devel@lists.sourceforge.net,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <20070204161521.GA9623@frodo.home.lxtec.de> <1170624733.2620.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170624733.2620.41.camel@localhost.localdomain>
Organization: LXTEC
X-gnupg-key-fingerprint: BE65 85E4 4867 7E9B 1F2A  B2CE DC88 3C6E C54F 7FB0
X-Editor: VIM - Vi IMproved 7.0 (2006 May 7, compiled Jan 21 2007 22:03:27)
User-Agent: Mutt/1.5.13-muttng (2007-01-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Feb 2007 the mental interface of
Benjamin Herrenschmidt told:

[...]

> > Switching to the analog port works well.
> 
> Can I have the -full- dmesg log ?

Yep and thanks ;)

This is trying dvi but switching to analog while booting:

radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=275.00 Mhz, System=250.00 MHz
radeonfb: PLL min 20000 max 40000
1 chips in connector info
 - chip 1 has 2 connectors
  * connector 0 of type 2 (CRT) : 2300
  * connector 1 of type 3 (DVI-I) : 3201
Starting monitor auto detection...
radeonfb: I2C (port 1) ... not found
radeonfb: I2C (port 2) ... found TMDS panel
radeonfb: I2C (port 3) ... found CRT display
i2c_adapter i2c-3: unable to read EDID block.
i2c_adapter i2c-3: unable to read EDID block.
i2c_adapter i2c-3: unable to read EDID block.
radeonfb: I2C (port 4) ... not found
radeonfb: I2C (port 2) ... found TMDS panel
radeonfb: I2C (port 3) ... found CRT display
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type CRT found
radeonfb: EDID probed
Parsing EDID data for panel info
Setting up default mode based on panel info
hStart = 1664, hEnd = 1856, hTotal = 2160
vStart = 1201, vEnd = 1204, vTotal = 1250
h_total_disp = 0xc7010d	   hsync_strt_wid = 0x18067a
v_total_disp = 0x4af04e1	   vsync_strt_wid = 0x304b0
pixclock = 6172
freq = 16202
freq = 16202, PLL min = 20000, PLL max = 40000
ref_div = 12, ref_clk = 2700, output_freq = 32404
ref_div = 12, ref_clk = 2700, output_freq = 32404
post div = 0x1
fb_div = 0x90
ppll_div_3 = 0x10090
Console: switching to colour frame buffer device 200x75
radeonfb (0000:01:00.0): ATI Radeon If 
radeonfb_pci_register END
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
Using specific hotkey driver
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 2 throttling states)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xa000-0xa007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xa008-0xa00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: PLEXTOR DVD-ROM PX-130A, ATAPI CD/DVD-ROM drive
hdd: HL-DT-ST GCE-8400B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide0...
sata_sil 0000:00:0b.0: version 2.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
ata1: SATA max UDMA/100 cmd 0xF0802080 ctl 0xF080208A bmdma 0xF0802000 irq 11
ata2: SATA max UDMA/100 cmd 0xF08020C0 ctl 0xF08020CA bmdma 0xF0802008 irq 11
scsi0 : sata_sil
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-6, max UDMA/133, 234441648 sectors: LBA48 
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/100
scsi1 : sata_sil
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-6, max UDMA/133, 234441648 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST3120026AS      3.18 PQ: 0 ANSI: 5
SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13 >
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      ST3120827AS      3.42 PQ: 0 ANSI: 5
SCSI device sdb: 234441648 512-byte hdwr sectors (120034 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 234441648 512-byte hdwr sectors (120034 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12 sdb13 >
sd 1:0:0:0: Attached scsi disk sdb
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
I2O subsystem v1.325
i2o: max drivers = 8
i2c /dev entries driver
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI Shortcut mode
ACPI: (supports S0 S1 S4 S5)
Time: tsc clocksource has been installed.
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Time: acpi_pm clocksource has been installed.
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb12 ...
md:  adding sdb12 ...
md: sdb11 has different UUID to sdb12
md: sdb10 has different UUID to sdb12
md: sdb9 has different UUID to sdb12
md: sdb8 has different UUID to sdb12
md: sdb7 has different UUID to sdb12
md: sdb6 has different UUID to sdb12
md: sdb3 has different UUID to sdb12
md:  adding sda12 ...
md: sda11 has different UUID to sdb12
md: sda10 has different UUID to sdb12
md: sda9 has different UUID to sdb12
md: sda8 has different UUID to sdb12
md: sda7 has different UUID to sdb12
md: sda6 has different UUID to sdb12
md: sda3 has different UUID to sdb12
md: created md12
md: bind<sda12>
md: bind<sdb12>
md: running: <sdb12><sda12>
raid1: raid set md12 active with 2 out of 2 mirrors
md: considering sdb11 ...
md:  adding sdb11 ...
md: sdb10 has different UUID to sdb11
md: sdb9 has different UUID to sdb11
md: sdb8 has different UUID to sdb11
md: sdb7 has different UUID to sdb11
md: sdb6 has different UUID to sdb11
md: sdb3 has different UUID to sdb11
md:  adding sda11 ...
md: sda10 has different UUID to sdb11
md: sda9 has different UUID to sdb11
md: sda8 has different UUID to sdb11
md: sda7 has different UUID to sdb11
md: sda6 has different UUID to sdb11
md: sda3 has different UUID to sdb11
md: created md11
md: bind<sda11>
md: bind<sdb11>
md: running: <sdb11><sda11>
raid1: raid set md11 active with 2 out of 2 mirrors
md: considering sdb10 ...
md:  adding sdb10 ...
md: sdb9 has different UUID to sdb10
md: sdb8 has different UUID to sdb10
md: sdb7 has different UUID to sdb10
md: sdb6 has different UUID to sdb10
md: sdb3 has different UUID to sdb10
md:  adding sda10 ...
md: sda9 has different UUID to sdb10
md: sda8 has different UUID to sdb10
md: sda7 has different UUID to sdb10
md: sda6 has different UUID to sdb10
md: sda3 has different UUID to sdb10
md: created md10
md: bind<sda10>
md: bind<sdb10>
md: running: <sdb10><sda10>
raid1: raid set md10 active with 2 out of 2 mirrors
md: considering sdb9 ...
md:  adding sdb9 ...
md: sdb8 has different UUID to sdb9
md: sdb7 has different UUID to sdb9
md: sdb6 has different UUID to sdb9
md: sdb3 has different UUID to sdb9
md:  adding sda9 ...
md: sda8 has different UUID to sdb9
md: sda7 has different UUID to sdb9
md: sda6 has different UUID to sdb9
md: sda3 has different UUID to sdb9
md: created md9
md: bind<sda9>
md: bind<sdb9>
md: running: <sdb9><sda9>
raid1: raid set md9 active with 2 out of 2 mirrors
md: considering sdb8 ...
md:  adding sdb8 ...
md: sdb7 has different UUID to sdb8
md: sdb6 has different UUID to sdb8
md: sdb3 has different UUID to sdb8
md:  adding sda8 ...
md: sda7 has different UUID to sdb8
md: sda6 has different UUID to sdb8
md: sda3 has different UUID to sdb8
md: created md8
md: bind<sda8>
md: bind<sdb8>
md: running: <sdb8><sda8>
raid1: raid set md8 active with 2 out of 2 mirrors
md: considering sdb7 ...
md:  adding sdb7 ...
md: sdb6 has different UUID to sdb7
md: sdb3 has different UUID to sdb7
md:  adding sda7 ...
md: sda6 has different UUID to sdb7
md: sda3 has different UUID to sdb7
md: created md7
md: bind<sda7>
md: bind<sdb7>
md: running: <sdb7><sda7>
raid1: raid set md7 active with 2 out of 2 mirrors
md: considering sdb6 ...
md:  adding sdb6 ...
md: sdb3 has different UUID to sdb6
md:  adding sda6 ...
md: sda3 has different UUID to sdb6
md: created md6
md: bind<sda6>
md: bind<sdb6>
md: running: <sdb6><sda6>
raid1: raid set md6 active with 2 out of 2 mirrors
md: considering sdb3 ...
md:  adding sdb3 ...
md:  adding sda3 ...
md: created md3
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
raid1: raid set md3 active with 2 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 224k freed
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
agpgart: AGP aperture is 256M @ 0xc0000000
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
parport0: Printer, Samsung ML-6060
parport_pc: VIA parallel port: io=0x378, irq=7
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x0000a400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hdc: ATAPI 50X DVD-ROM drive, 512kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 40X CD-ROM CD-R/RW drive, 8192kB Cache, DMA
ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 11, io base 0x0000a800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
gameport: EMU10K1 is pci0000:00:08.1/gameport0, io 0xb000, speed 1269kHz
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0f.0: 3Com PCI 3c905C Tornado at f086a000.
usb 1-1: new low speed USB device using uhci_hcd and address 2
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
usb 1-1: configuration #1 chosen from 1 choice
usb 2-2: new full speed USB device using uhci_hcd and address 2
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
usb 2-2.4: new full speed USB device using uhci_hcd and address 3
usb 2-2.4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /class/input/input4
input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:07.2-1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver libusual
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
Adding 979924k swap on /dev/sda5.  Priority:0 extents:1 across:979924k
Adding 979920k swap on /dev/sdb5.  Priority:0 extents:1 across:979920k
EXT3 FS on md6, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md12, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda13, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb13, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
scsi 2:0:0:0: Direct-Access     ICSI     IC1100        CF 2.5b PQ: 0 ANSI: 0 CCS
sd 2:0:0:0: Attached scsi removable disk sdc
usb-storage: device scan complete
eth0:  setting full-duplex.
eth0: no IPv6 routers present
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.25.0 20060524 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.1 into 4x mode
hStart = 1664, hEnd = 1856, hTotal = 2160
vStart = 1201, vEnd = 1204, vTotal = 1250
h_total_disp = 0xc7010d	   hsync_strt_wid = 0x18067d
v_total_disp = 0x4af04e1	   vsync_strt_wid = 0x304b0
pixclock = 6172
freq = 16202
freq = 16202, PLL min = 20000, PLL max = 40000
ref_div = 12, ref_clk = 2700, output_freq = 32404
ref_div = 12, ref_clk = 2700, output_freq = 32404
post div = 0x1
fb_div = 0x90
ppll_div_3 = 0x10090
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs


-- 
  You cannot propel yourself forward by
  patting yourself on the back.
