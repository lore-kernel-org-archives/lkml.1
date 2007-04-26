Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXDZMOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXDZMOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031194AbXDZMOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:14:44 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:64573 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030459AbXDZMOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=l0XjdOLpjl11jvDGmMzo9pF2ru4hsDBmRiWwPMdveBvAqXLFXoAiV+P6KtII9QOl7Z04ksbajmwPPBnJDkGx3E2UbBhyExPyqxHrR63x/6p49Xe37qPZBJMSCYnZiJAq+r1FsOAkC7nXl6nhnBYsq6FHuS5r6nnYZZn1xbzKqhw=
Message-ID: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com>
Date: Thu, 26 Apr 2007 17:44:40 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21 - something wrong with dmesg.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Andrew Morton" <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I did compile the kernel, boots good ;-) BTW, does anyone (on P-III)
facing a memory check skip or sort of? Not getting RAM info in the
dmesg.  Unable to get dmseg from the start of the gcc check! Any clue?
Here is the dmesg I get on my box:

00000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:11 APIC version 17
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
1ff00000:e00c0000)
[    0.000000] Built 1 zonelists.  Total pages: 129779
[    0.000000] Kernel command line: ro root=LABEL=/
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1202.764 MHz processor.
[   13.595214] Console: colour VGA+ 80x25
[   13.601724] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[   13.603679] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[   13.646235] Memory: 513268k/523200k available (2175k kernel code,
9388k reserved, 733k data, 212k init, 0k highmem)
[   13.646415] virtual kernel memory layout:
[   13.646417]     fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
[   13.646420]     vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
[   13.646422]     lowmem  : 0xc0000000 - 0xdfef0000   ( 510 MB)
[   13.646425]       .init : 0xc03da000 - 0xc040f000   ( 212 kB)
[   13.646427]       .data : 0xc031fdd5 - 0xc03d7514   ( 733 kB)
[   13.646430]       .text : 0xc0100000 - 0xc031fdd5   (2175 kB)
[   13.647089] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   13.707417] Calibrating delay using timer specific routine..
2406.24 BogoMIPS (lpj=1203121)
[   13.707685] Security Framework v1.0.0 initialized
[   13.707797] SELinux:  Initializing.
[   13.707914] SELinux:  Starting in permissive mode
[   13.707924] selinux_register_security:  Registering secondary
module capability
[   13.708082] Capability LSM initialized as secondary
[   13.708200] Mount-cache hash table entries: 512
[   13.708547] CPU: After generic identify, caps: 0383fbff 00000000
00000000 00000000 00000000 00000000 00000000
[   13.708568] CPU: L1 I cache: 16K, L1 D cache: 16K
[   13.708695] CPU: L2 cache: 256K
[   13.708785] CPU: After all inits, caps: 0383fbff 00000000 00000000
00000040 00000000 00000000 00000000
[   13.708795] Intel machine check architecture supported.
[   13.708892] Intel machine check reporting enabled on CPU#0.
[   13.709007] CPU: Intel(R) Pentium(R) III CPU             1200MHz stepping 01
[   13.709165] Checking 'hlt' instruction... OK.
[   13.712650] ACPI: Core revision 20070126
[   13.716326] ENABLING IO-APIC IRQs
[   13.716655] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   13.828786] NET: Registered protocol family 16
[   13.829173] ACPI: bus type pci registered
[   13.830908] PCI: PCI BIOS revision 2.10 entry at 0xfdb81, last bus=1
[   13.831014] PCI: Using configuration type 1
[   13.831112] Setting up standard PCI resources
[   13.838325] ACPI: Interpreter enabled
[   13.838440] ACPI: (supports S0 S1 S4 S5)
[   13.838691] ACPI: Using IOAPIC for interrupt routing
[   13.848472] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   13.848617] PCI: Probing PCI hardware (bus 00)
[   13.848796] Boot video device is 0000:00:01.0
[   13.848901] PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[   13.849009] PCI quirk: region 0480-04bf claimed by ICH4 GPIO
[   13.849601] PCI: Transparent bridge - 0000:00:1e.0
[   13.849744] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   13.849943] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.ICHB._PRT]
[   13.865597] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[   13.866208] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   13.866795] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   13.867378] ACPI: PCI Interrupt Link [LNKD] (IRQs 9) *11
[   13.867640] ACPI Error (psargs-0355): [PRSE] Namespace lookup
failure, AE_NOT_FOUND
[   13.867849] ACPI Error (psparse-0537): Method parse/execution
failed [\_SB_.LNKE._PRS] (Node dfd61f40), AE_NOT_FOUND
[   13.868118] ACPI Exception (pci_link-0179): AE_NOT_FOUND,
Evaluating _PRS [20070126]
[   13.868407] ACPI Error (psargs-0355): [PRSF] Namespace lookup
failure, AE_NOT_FOUND
[   13.868635] ACPI Error (psparse-0537): Method parse/execution
failed [\_SB_.LNKF._PRS] (Node dfd61ea0), AE_NOT_FOUND
[   13.868913] ACPI Exception (pci_link-0179): AE_NOT_FOUND,
Evaluating _PRS [20070126]
[   13.869193] ACPI Error (psargs-0355): [PRSG] Namespace lookup
failure, AE_NOT_FOUND
[   13.869421] ACPI Error (psparse-0537): Method parse/execution
failed [\_SB_.LNKG._PRS] (Node dfd61e00), AE_NOT_FOUND
[   13.869704] ACPI Exception (pci_link-0179): AE_NOT_FOUND,
Evaluating _PRS [20070126]
[   13.869980] ACPI Error (psargs-0355): [PRSH] Namespace lookup
failure, AE_NOT_FOUND
[   13.870201] ACPI Error (psparse-0537): Method parse/execution
failed [\_SB_.LNKH._PRS] (Node c147b75c), AE_NOT_FOUND
[   13.870484] ACPI Exception (pci_link-0179): AE_NOT_FOUND,
Evaluating _PRS [20070126]
[   13.870928] ACPI: Power Resource [URP1] (off)
[   13.871079] ACPI: Power Resource [URP2] (off)
[   13.871228] ACPI: Power Resource [FDDP] (off)
[   13.871380] ACPI: Power Resource [LPTP] (off)
[   13.871502] Linux Plug and Play Support v0.97 (c) Adam Belay
[   13.871621] pnp: PnP ACPI init
[   13.877725] pnp: PnP ACPI: found 12 devices
[   13.878121] usbcore: registered new interface driver usbfs
[   13.878293] usbcore: registered new interface driver hub
[   13.878493] usbcore: registered new device driver usb
[   13.878640] PCI: Using ACPI for IRQ routing
[   13.878739] PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
[   13.881330] NetLabel: Initializing
[   13.881419] NetLabel:  domain hash size = 128
[   13.881508] NetLabel:  protocols = UNLABELED CIPSOv4
[   13.881622] NetLabel:  unlabeled traffic allowed by default
[   13.882333] Time: tsc clocksource has been installed.
[   13.912288] PCI: Ignore bogus resource 6 [0:0] of 0000:00:01.0
[   13.912400] PCI: Bridge: 0000:00:1e.0
[   13.912497]   IO window: c000-cfff
[   13.912599]   MEM window: efd00000-efdfffff
[   13.912699]   PREFETCH window: e7b00000-e7bfffff
[   13.912809] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   13.912873] NET: Registered protocol family 2
[   13.922378] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[   13.922633] TCP established hash table entries: 16384 (order: 5,
131072 bytes)
[   13.923353] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[   13.923709] TCP: Hash tables configured (established 16384 bind 16384)
[   13.923806] TCP reno registered
[   13.926723] checking if image is initramfs... it is
[   14.132575] Freeing initrd memory: 1476k freed
[   14.133959] audit: initializing netlink socket (disabled)
[   14.134114] audit(1177607993.133:1): initialized
[   14.134526] VFS: Disk quotas dquot_6.5.1
[   14.134650] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   14.134886] SELinux:  Registering netfilter hooks
[   14.135007] io scheduler noop registered
[   14.135134] io scheduler cfq registered (default)
[   14.136312] ACPI: Processor [CPU1] (supports 8 throttling states)
[   14.136674] isapnp: Scanning for PnP cards...
[   14.411954] Switched to NOHz mode on CPU #0
[   14.493091] isapnp: No Plug & Play device found
[   14.498494] Real Time Clock Driver v1.12ac
[   14.498930] Non-volatile memory driver v1.2
[   14.499032] Linux agpgart interface v0.102 (c) Dave Jones
[   14.499305] agpgart: Detected an Intel i810 E Chipset.
[   14.511472] agpgart: AGP aperture is 64M @ 0xe8000000
[   14.511662] [drm] Initialized drm 1.1.0 20060810
[   14.511760] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing enabled
[   14.512089] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   14.512374] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   14.513183] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   14.514625] RAMDISK driver initialized: 16 RAM disks of 16384K size
4096 blocksize
[   14.515060] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   14.515219] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[   14.515486] ICH2: IDE controller at PCI slot 0000:00:1f.1
[   14.516930] ICH2: chipset revision 5
[   14.517027] ICH2: not 100% native mode: will probe irqs later
[   14.517149]     ide0: BM-DMA at 0xff00-0xff07, BIOS settings:
hda:DMA, hdb:pio
[   14.517385]     ide1: BM-DMA at 0xff08-0xff0f, BIOS settings:
hdc:DMA, hdd:pio
[   14.517612] Probing IDE interface ide0...
[   14.781149] hda: ST310212A, ATA DISK drive
[   15.393499] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   15.393813] Probing IDE interface ide1...
[   16.064782] hdc: SONY CD-RW CRX320E, ATAPI CD/DVD-ROM drive
[   16.676993] ide1 at 0x170-0x177,0x376 on irq 15
[   16.677547] hda: max request size: 128KiB
[   16.678611] hda: 20005650 sectors (10242 MB) w/512KiB Cache,
CHS=19846/16/63, UDMA(66)
[   16.678883] hda: cache flushes not supported
[   16.679055]  hda: hda1 hda2 hda3
[   16.710139] usbcore: registered new interface driver libusual
[   16.710309] usbcore: registered new interface driver hiddev
[   16.710458] usbcore: registered new interface driver usbhid
[   16.710574] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   16.710811] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   16.710915] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   16.961686] serio: i8042 KBD port at 0x60,0x64 irq 1
[   16.962006] mice: PS/2 mouse device common for all mice
[   16.962441] TCP cubic registered
[   16.962542] Initializing XFRM netlink socket
[   16.962679] NET: Registered protocol family 1
[   16.962784] NET: Registered protocol family 17
[   16.962897] Using IPI Shortcut mode
[   16.963912] Freeing unused kernel memory: 212k freed
[   16.987600] input: AT Translated Set 2 keyboard as /class/input/input0
[   17.239843] USB Universal Host Controller Interface driver v3.0
[   17.240103] ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level,
low) -> IRQ 16
[   17.240357] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   17.240364] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[   17.240614] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned
bus number 1
[   17.240819] uhci_hcd 0000:00:1f.2: irq 16, io base 0x0000dd80
[   17.241204] usb usb1: configuration #1 chosen from 1 choice
[   17.241370] hub 1-0:1.0: USB hub found
[   17.241480] hub 1-0:1.0: 2 ports detected
[   17.345406] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller
(OHCI) Driver
[   17.345495] ACPI: PCI Interrupt 0000:01:04.0[B] -> GSI 17 (level,
low) -> IRQ 17
[   17.345701] ohci_hcd 0000:01:04.0: OHCI Host Controller
[   17.345840] ohci_hcd 0000:01:04.0: new USB bus registered, assigned
bus number 2
[   17.346034] ohci_hcd 0000:01:04.0: irq 17, io mem 0xefdfd000
[   17.398519] usb usb2: configuration #1 chosen from 1 choice
[   17.398696] hub 2-0:1.0: USB hub found
[   17.398802] hub 2-0:1.0: 2 ports detected
[   17.499488] ACPI: PCI Interrupt 0000:01:04.1[C] -> GSI 18 (level,
low) -> IRQ 18
[   17.499698] ohci_hcd 0000:01:04.1: OHCI Host Controller
[   17.499845] ohci_hcd 0000:01:04.1: new USB bus registered, assigned
bus number 3
[   17.500030] ohci_hcd 0000:01:04.1: irq 18, io mem 0xefdfe000
[   17.552402] usb usb3: configuration #1 chosen from 1 choice
[   17.552566] hub 3-0:1.0: USB hub found
[   17.552678] hub 3-0:1.0: 2 ports detected
[   17.657372] ACPI: PCI Interrupt 0000:01:04.3[A] -> GSI 16 (level,
low) -> IRQ 19
[   17.657602] ehci_hcd 0000:01:04.3: EHCI Host Controller
[   17.657801] ehci_hcd 0000:01:04.3: new USB bus registered, assigned
bus number 4
[   17.658002] ehci_hcd 0000:01:04.3: debug port 1
[   17.678219] ehci_hcd 0000:01:04.3: irq 19, io mem 0xefdffe00
[   17.678325] ehci_hcd 0000:01:04.3: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[   17.678756] usb usb4: configuration #1 chosen from 1 choice
[   17.678942] hub 4-0:1.0: USB hub found
[   17.679056] hub 4-0:1.0: 6 ports detected
[   17.971021] SCSI subsystem initialized
[   17.990351] libata version 2.20 loaded.
[   18.228227] kjournald starting.  Commit interval 5 seconds
[   18.228358] EXT3-fs: mounted filesystem with ordered data mode.
[   18.469980] usb 3-1: new low speed USB device using ohci_hcd and address 2
[   18.645969] usb 3-1: configuration #1 chosen from 1 choice
[   18.665259] input: Microsoft Basic Optical Mouse as /class/input/input1
[   18.665421] input: USB HID v1.10 Mouse [Microsoft Basic Optical
Mouse] on usb-0000:01:04.1-1
[   18.881856] usb 3-2: new full speed USB device using ohci_hcd and address 3
[   19.076688] usb 3-2: configuration #1 chosen from 1 choice
[   21.360931] SELinux:  Disabled at runtime.
[   21.361053] SELinux:  Unregistering netfilter hooks
[   21.366160] audit(1177608000.132:2): selinux=0 auid=4294967295
[   26.507431] parport: PnPBIOS parport detected.
[   26.507465] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
[   26.655780] hdc: ATAPI 40X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
[   26.655803] Uniform CD-ROM driver Revision: 3.20
[   27.222552] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[   27.222658] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   27.259075] eth0: VIA Rhine III at 0xefdfff00, 00:15:e9:48:b1:a4, IRQ 17.
[   27.259796] eth0: MII PHY found at address 1, status 0x786d
advertising 01e1 Link 0021.
[   27.448739] input: PC Speaker as /class/input/input2
[   27.465215] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   27.465326] iTCO_wdt: failed to reset NO_REBOOT flag, reboot
disabled by hardware
[   27.465336] iTCO_wdt: No card detected
[   27.543127] intel_rng: FWH not detected
[   27.829884] i810_smbus 0000:00:01.0: i810/i815 i2c device found.
[   27.920141] Floppy drive(s): fd0 is 1.44M
[   27.936834] FDC 0 is a post-1991 82077
[   28.232248] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level,
low) -> IRQ 17
[   28.232298] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   28.545156] intel8x0_measure_ac97_clock: measured 50920 usecs
[   28.545165] intel8x0: clocking to 48000
[   30.430914] lp0: using parport0 (interrupt-driven).
[   30.753854] input: Power Button (FF) as /class/input/input3
[   30.772105] ACPI: Power Button (FF) [PWRF]
[   30.790110] input: Power Button (CM) as /class/input/input4
[   30.808898] ACPI: Power Button (CM) [PWRB]
[   30.827050] input: Sleep Button (CM) as /class/input/input5
[   30.845283] ACPI: Sleep Button (CM) [SLPB]
[   31.534526] EXT3 FS on hda3, internal journal
[   31.925279] fuse init (API version 7.8)
[   33.216055] Adding 265032k swap on /dev/hda2.  Priority:-1
extents:1 across:265032k
[   34.875622] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.522114] Netfilter messages via NETLINK v0.30.
[   35.541789] nf_conntrack version 0.5.0 (4087 buckets, 32696 max)
[   38.582733] eth0: link up, 10Mbps, half-duplex, lpa 0x0021
[   40.907876] audit(1177588220.592:3): audit_pid=1676 old=0 by auid=4294967295


~Akula2
