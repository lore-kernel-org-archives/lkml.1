Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbXIORHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbXIORHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXIORHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:07:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXIORHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:07:20 -0400
Message-ID: <46EC113A.4040309@cv-sv.de>
Date: Sat, 15 Sep 2007 19:07:06 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070803 SUSE/1.1.4-3.1 SeaMonkey/1.1.4
MIME-Version: 1.0
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       haveaniceday@cv-sv.de
Subject: Re: [linux-usb-devel] 2.6.23-rc6: usb 1-1: device not accepting address
 2, error -62
References: <Pine.LNX.4.44L0.0709151123590.30525-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709151123590.30525-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+3rygtxsV94Kdf2lNu1mkUd60W/oVdCIKkfTu
 JkGApVOo2D2MY1NNHU5dbgzUY5s+MLeAmX13Rh2ACy3MuywhgY
 E4+6YsM+AQfsA+gBkixbw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please see below for the logs with timestamp and usb-debug.

Alan Stern wrote:
> On Sat, 15 Sep 2007, Christian Volkmann wrote:
> 
>>> Does the machine otherwise work OK?
>>>
>> Yes, the USB is working fine for the easy things I do with it.
>>
>> Hmm, so I expect this 2.6.22 message:
>>>> <6>usb 1-1: USB disconnect, address 2
>> became this 2.6.23rc6 message:
>>>> <3>usb 1-1: device not accepting address 2, error -62
>> and nothing is harmed.
> 
> Maybe.  It's hard to tell because you have not provided enough
> information.  To get a better idea of what's going on you should enable 
> CONFIG_USB_DEBUG, for both 2.6.22 and 2.6.23, and then post the dmesg 
> logs.  It wouldn't hurt to enable CONFIG_PRINTK_TIME also.
> 
> These sorts of errors can occur because of bad cable connections or
> other similar hardware problems.  There's an excellent chance they have
> no connection to the kernel version.
> 
> Alan Stern
> 
> 

Boot of 2.6.22 with CONFIG_PRINTK_TIME and CONFIG_USB_DEBUG


klogd 1.4.1, log source = ksyslog started.
<5>[    0.000000] Linux version 2.6.22-speedy (root@speedy) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #3 PREEMPT Sat Sep 15 18:43:47 CEST 2007
<6>[    0.000000] BIOS-provided physical RAM map:
<4>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
<4>[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
<4>[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<4>[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
<4>[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff3000 (ACPI NVS)
<4>[    0.000000]  BIOS-e820: 000000005fff3000 - 0000000060000000 (ACPI data)
<5>[    0.000000] 639MB HIGHMEM available.
<5>[    0.000000] 896MB LOWMEM available.
<6>[    0.000000] found SMP MP-table at 000f5980
<7>[    0.000000] Entering add_active_range(0, 0, 393200) 0 entries of 256 used
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA             0 ->     4096
<4>[    0.000000]   Normal       4096 ->   229376
<4>[    0.000000]   HighMem    229376 ->   393200
<4>[    0.000000] early_node_map[1] active PFN ranges
<4>[    0.000000]     0:        0 ->   393200
<7>[    0.000000] On node 0 totalpages: 393200
<7>[    0.000000]   DMA zone: 32 pages used for memmap
<7>[    0.000000]   DMA zone: 0 pages reserved
<7>[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
<7>[    0.000000]   Normal zone: 1760 pages used for memmap
<7>[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
<7>[    0.000000]   HighMem zone: 1279 pages used for memmap
<7>[    0.000000]   HighMem zone: 162545 pages, LIFO batch:31
<6>[    0.000000] DMI 2.3 present.
<4>[    0.000000] ACPI: RSDP 000F7350, 0014 (r0 AWARD )
<4>[    0.000000] ACPI: RSDT 5FFF3000, 002C (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
<4>[    0.000000] ACPI: FACP 5FFF3040, 0074 (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
<4>[    0.000000] ACPI: DSDT 5FFF30C0, 38BB (r1 AWARD  AWRDACPI     1000 MSFT  100000D)
<4>[    0.000000] ACPI: FACS 5FFF0000, 0040
<4>[    0.000000] ACPI: APIC 5FFF6980, 0054 (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x1008
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<4>[    0.000000] Processor #0 15:2 APIC version 20
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<4>[    0.000000] IOAPIC[0]: apic_id 2, version 20, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<4>[    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:a0000000)
<4>[    0.000000] Built 1 zonelists.  Total pages: 390129
<5>[    0.000000] Kernel command line: root=/dev/hdb7 vga=0x346 resume=/dev/hdb11 splash=verbose console=tty0 crashkernel=64M@16M  3
<7>[    0.000000] mapped APIC to ffffd000 (fee00000)
<7>[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
<6>[    0.000000] Enabling fast FPU save and restore... done.
<6>[    0.000000] Enabling unmasked SIMD FPU exception support... done.
<6>[    0.000000] Initializing CPU#0
<4>[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
<4>[    0.000000] Detected 2672.804 MHz processor.
<4>[   18.872274] Console: colour dummy device 80x25
<4>[   18.873050] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<4>[   18.873822] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<6>[   18.922125] Memory: 1490032k/1572800k available (1742k kernel code, 81424k reserved, 662k data, 196k init, 655296k highmem)
<4>[   18.922147] virtual kernel memory layout:
<4>[   18.922148]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
<4>[   18.922149]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
<4>[   18.922151]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
<4>[   18.922152]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
<4>[   18.922153]       .init : 0xc125c000 - 0xc128d000   ( 196 kB)
<4>[   18.922155]       .data : 0xc11b38f3 - 0xc1259484   ( 662 kB)
<4>[   18.922156]       .text : 0xc1000000 - 0xc11b38f3   (1742 kB)
<4>[   18.922169] Checking if this processor honours the WP bit even in supervisor mode... Ok.
<4>[   19.002291] Calibrating delay using timer specific routine.. 5349.25 BogoMIPS (lpj=10698513)
<6>[   19.002337] Security Framework v1.0.0 initialized
<4>[   19.002358] Mount-cache hash table entries: 512
<7>[   19.002502] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00000400 00000000 00000000
<6>[   19.002514] CPU: Trace cache: 12K uops, L1 D cache: 8K
<6>[   19.002519] CPU: L2 cache: 512K
<7>[   19.002523] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00000400 00000000 00000000
<6>[   19.002530] Intel machine check architecture supported.
<6>[   19.002536] Intel machine check reporting enabled on CPU#0.
<6>[   19.002540] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
<6>[   19.002545] CPU0: Thermal monitoring enabled
<4>[   19.002554] Compat vDSO mapped to ffffe000.
<4>[   19.002568] CPU: Intel(R) Pentium(R) 4 CPU 2.66GHz stepping 07
<6>[   19.002577] Checking 'hlt' instruction... OK.
<6>[   19.018378] ACPI: Core revision 20070126
<4>[   19.127629] ENABLING IO-APIC IRQs
<6>[   19.127803] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[   19.274383] NET: Registered protocol family 16
<6>[   19.274494] ACPI: bus type pci registered
<6>[   19.313809] PCI: PCI BIOS revision 2.10 entry at 0xfb400, last bus=1
<6>[   19.313813] PCI: Using configuration type 1
<4>[   19.313816] Setting up standard PCI resources
<6>[   19.324546] ACPI: Interpreter enabled
<6>[   19.324556] ACPI: (supports S0 S3 S4 S5)
<6>[   19.324578] ACPI: Using IOAPIC for interrupt routing
<6>[   19.329173] ACPI: PCI Root Bridge [PCI0] (0000:00)
<7>[   19.329191] PCI: Probing PCI hardware (bus 00)
<6>[   19.329479] Enabling SiS 96x SMBus.
<7>[   19.331073] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<4>[   19.352987] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
<4>[   19.353097] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
<4>[   19.353208] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
<4>[   19.353316] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
<4>[   19.353420] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
<4>[   19.353525] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
<4>[   19.353631] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
<4>[   19.353734] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
<6>[   19.353835] Linux Plug and Play Support v0.97 (c) Adam Belay
<6>[   19.353852] pnp: PnP ACPI init
<6>[   19.353862] ACPI: bus type pnp registered
<6>[   19.355941] pnp: PnP ACPI: found 11 devices
<6>[   19.355947] ACPI: ACPI bus type pnp unregistered
<6>[   19.355954] PnPBIOS: Disabled by ACPI PNP
<6>[   19.356032] PCI: Using ACPI for IRQ routing
<6>[   19.356037] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
<6>[   19.372489] pnp: 00:00: iomem range 0xd0000-0xd3fff has been reserved
<6>[   19.372495] pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
<6>[   19.372499] pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
<6>[   19.372503] pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
<6>[   19.374201] Time: tsc clocksource has been installed.
<6>[   19.402836] PCI: Bridge: 0000:00:01.0
<6>[   19.402840]   IO window: disabled.
<6>[   19.402850]   MEM window: e0000000-e1ffffff
<6>[   19.402857]   PREFETCH window: d8000000-dfffffff
<6>[   19.402901] NET: Registered protocol family 2
<4>[   19.442210] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
<4>[   19.442382] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
<4>[   19.443552] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
<6>[   19.443951] TCP: Hash tables configured (established 131072 bind 65536)
<6>[   19.443956] TCP reno registered
<6>[   19.454365] checking if image is initramfs... it is
<6>[   19.685765] Freeing initrd memory: 2802k freed
<6>[   19.685969] Machine check exception polling timer started.
<6>[   19.686000] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
<5>[   19.686004] apm: overridden by ACPI.
<6>[   19.686257] audit: initializing netlink socket (disabled)
<5>[   19.686277] audit(1189882148.244:1): initialized
<4>[   19.686356] highmem bounce pool size: 64 pages
<4>[   19.686362] Total HugeTLB memory allocated, 0
<5>[   19.686423] VFS: Disk quotas dquot_6.5.1
<4>[   19.686436] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
<6>[   19.686513] io scheduler noop registered
<6>[   19.686517] io scheduler anticipatory registered
<6>[   19.686520] io scheduler deadline registered
<6>[   19.686533] io scheduler cfq registered (default)
<7>[   19.770100] pci 0000:00:07.0: uhci_check_and_reset_hc: legsup = 0x2000
<7>[   19.770102] pci 0000:00:07.0: Performing full reset
<7>[   19.770120] pci 0000:00:07.1: uhci_check_and_reset_hc: legsup = 0x2000
<7>[   19.770122] pci 0000:00:07.1: Performing full reset
<7>[   19.770150] Boot video device is 0000:01:00.0
<6>[   19.770391] vesafb: framebuffer at 0xd8000000, mapped to 0xf8880000, using 7500k, total 131072k
<6>[   19.770398] vesafb: mode is 1600x1200x16, linelength=3200, pages=1
<6>[   19.770402] vesafb: protected mode interface info at c000:def0
<6>[   19.770406] vesafb: pmi: set display start = c00cdf35, set palette = c00cdfba
<6>[   19.770409] vesafb: pmi: ports = b4c3 b503 ba03 c003 c103 c403 c503 c603 c703 c803 c903 cc03 ce03 cf03 d003 d103 d203 d303 d403 d503 da03 ff03
<6>[   19.770432] vesafb: scrolling: redraw
<6>[   19.770436] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
<4>[   19.836587] Console: switching to colour frame buffer device 200x75
<6>[   19.902936] fb0: VESA VGA frame buffer device
<6>[   19.903209] isapnp: Scanning for PnP cards...
<6>[   19.930043] Switched to NOHz mode on CPU #0
<6>[   20.213994] isapnp: No Plug & Play device found
<6>[   20.220984] Real Time Clock Driver v1.12ac
<6>[   20.221309] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
<6>[   20.222217] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>[   20.222695] Floppy drive(s): fd0 is 1.44M
<6>[   20.241646] FDC 0 is a post-1991 82077
<4>[   20.243357] RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
<6>[   20.243912] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
<6>[   20.244563] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[   20.244824] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[   20.245210] mice: PS/2 mouse device common for all mice
<6>[   20.278974] input: AT Translated Set 2 keyboard as /class/input/input0
<6>[   20.289144] input: PC Speaker as /class/input/input1
<6>[   20.930810] input: ImPS/2 Generic Wheel Mouse as /class/input/input2
<6>[   20.935659] NET: Registered protocol family 1
<4>[   20.935886] Using IPI Shortcut mode
<6>[   20.936533] Freeing unused kernel memory: 196k freed
<6>[   21.227423] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>[   21.227764] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<6>[   21.245864] ACPI: Thermal Zone [THRM] (47 C)
<6>[   21.250555] SIS5513: IDE controller at PCI slot 0000:00:02.5
<6>[   21.250889] ACPI: PCI Interrupt 0000:00:02.5[A] -> GSI 16 (level, low) -> IRQ 16
<6>[   21.251289] SIS5513: chipset revision 0
<6>[   21.251486] SIS5513: not 100% native mode: will probe irqs later
<6>[   21.251809] SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
<6>[   21.252128]     ide0: BM-DMA at 0x4000-0x4007, BIOS settings: hda:DMA, hdb:DMA
<6>[   21.252530]     ide1: BM-DMA at 0x4008-0x400f, BIOS settings: hdc:DMA, hdd:DMA
<7>[   21.252926] Probing IDE interface ide0...
<4>[   21.541611] hda: ST3120023A, ATA DISK drive
<4>[   21.821506] hdb: SAMSUNG SP2514N, ATA DISK drive
<7>[   21.877534] hda: selected mode 0x45
<7>[   21.894893] hdb: selected mode 0x45
<4>[   21.911444] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<6>[   21.920761] hda: max request size: 128KiB
<6>[   21.921180] hda: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
<6>[   21.921781] hda: cache flushes supported
<6>[   21.922023]  hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 >
<6>[   21.994408] hdb: max request size: 512KiB
<6>[   21.994750] hdb: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(100)
<6>[   22.008117] hdb: cache flushes supported
<6>[   22.008376]  hdb: hdb1 hdb2 < hdb5 hdb6 hdb7 hdb8 hdb9 hdb10 hdb11 hdb12 >
<7>[   22.156505] Probing IDE interface ide1...
<4>[   22.893122] hdc: IDE DVD-ROM 16X, ATAPI CD/DVD-ROM drive
<4>[   23.692825] hdd: _NEC DVD_RW ND-1300A, ATAPI CD/DVD-ROM drive
<7>[   23.765512] hdc: selected mode 0x42
<7>[   23.766684] hdd: selected mode 0x42
<4>[   23.766850] ide1 at 0x170-0x177,0x376 on irq 15
<6>[   23.796256] ACPI: Fan [FAN] (on)
<6>[   23.817791] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
<4>[   24.071685] swsusp: Basic memory bitmaps created
<4>[   24.113309] swsusp: Basic memory bitmaps freed
<4>[   24.145965] Attempting manual resume
<6>[   24.317018] kjournald starting.  Commit interval 5 seconds
<6>[   24.333326] EXT3 FS on hdb7, internal journal
<6>[   24.349502] EXT3-fs: mounted filesystem with ordered data mode.
<6>[   27.119629] lp: driver loaded but no devices found
<6>[   28.527222] Linux agpgart interface v0.102 (c) Dave Jones
<6>[   28.689557] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[   28.736517] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x10c0
<6>[   28.773762] hdc: ATAPI 16X DVD-ROM drive, 512kB Cache, UDMA(33)
<6>[   28.790484] Uniform CD-ROM driver Revision: 3.20
<6>[   28.808164] agpgart: Detected SiS chipset - id:1608
<6>[   28.832562] agpgart: AGP aperture is 128M @ 0xd0000000
<6>[   28.856063] hdd: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
<6>[   28.878911] usbcore: registered new interface driver usbfs
<6>[   28.895484] usbcore: registered new interface driver hub
<6>[   28.911912] usbcore: registered new device driver usb
<6>[   28.948719] ACPI: PCI Interrupt 0000:00:02.3[B] -> GSI 17 (level, low) -> IRQ 17
<6>[   29.016935] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[17]  MMIO=[e2020000-e20207ff]  Max Packet=[2048]  IR/IT contexts=[4/6]
<7>[   29.035665] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
<7>[   29.035669] ohci_hcd: block sizes: ed 64 td 64
<6>[   29.045019] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 18
<6>[   29.061902] ohci_hcd 0000:00:03.0: OHCI Host Controller
<6>[   29.078652] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
<7>[   29.095312] ohci_hcd 0000:00:03.0: created debug files
<6>[   29.095323] ohci_hcd 0000:00:03.0: irq 18, io mem 0xe2021000
<7>[   29.113398] ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
<6>[   29.114643] USB Universal Host Controller Interface driver v3.0
<7>[   29.169233] ohci_hcd 0000:00:03.0: OHCI controller state
<7>[   29.169240] ohci_hcd 0000:00:03.0: OHCI 1.0, NO legacy support registers
<7>[   29.169244] ohci_hcd 0000:00:03.0: control 0x083 HCFS=operational CBSR=3
<7>[   29.169248] ohci_hcd 0000:00:03.0: cmdstatus 0x00000 SOC=0
<7>[   29.169251] ohci_hcd 0000:00:03.0: intrstatus 0x00000044 RHSC SF
<7>[   29.169255] ohci_hcd 0000:00:03.0: intrenable 0x8000000a MIE RD WDH
<7>[   29.169261] ohci_hcd 0000:00:03.0: hcca frame #0003
<7>[   29.169266] ohci_hcd 0000:00:03.0: roothub.a 01001202 POTPGT=1 NOCP NPS NDP=2(2)
<7>[   29.169270] ohci_hcd 0000:00:03.0: roothub.b 00000000 PPCM=0000 DR=0000
<7>[   29.169274] ohci_hcd 0000:00:03.0: roothub.status 00008000 DRWE
<7>[   29.169279] ohci_hcd 0000:00:03.0: roothub.portstatus [0] 0x00010301 CSC LSDA PPS CCS
<7>[   29.169283] ohci_hcd 0000:00:03.0: roothub.portstatus [1] 0x00000100 PPS
<7>[   29.169307] usb usb1: default language 0x0409
<7>[   29.169315] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   29.169318] usb usb1: Product: OHCI Host Controller
<6>[   29.185890] usb usb1: Manufacturer: Linux 2.6.22-speedy ohci_hcd
<6>[   29.202783] usb usb1: SerialNumber: 0000:00:03.0
<7>[   29.219533] usb usb1: uevent
<7>[   29.219553] usb usb1: usb_probe_device
<6>[   29.219618] usb usb1: configuration #1 chosen from 1 choice
<7>[   29.236354] usb usb1: adding 1-0:1.0 (config #1, interface 0)
<7>[   29.236366] usb 1-0:1.0: uevent
<7>[   29.236370] usb 1-0:1.0: uevent
<7>[   29.236382] hub 1-0:1.0: usb_probe_interface
<7>[   29.236384] hub 1-0:1.0: usb_probe_interface - got id
<6>[   29.236387] hub 1-0:1.0: USB hub found
<6>[   29.253193] hub 1-0:1.0: 2 ports detected
<7>[   29.270135] hub 1-0:1.0: standalone hub
<7>[   29.270138] hub 1-0:1.0: no power switching (usb 1.0)
<7>[   29.270140] hub 1-0:1.0: no over-current protection
<7>[   29.270143] hub 1-0:1.0: power on to power good time: 2ms
<7>[   29.270149] hub 1-0:1.0: local power source is good
<7>[   29.270153] hub 1-0:1.0: trying to enable port power on non-switchable hub
<6>[   29.344199] sis900.c: v1.08.10 Apr. 2 2006
<7>[   29.371190] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>[   29.371289] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00010301 CSC LSDA PPS CCS
<7>[   29.371297] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
<6>[   29.371333] ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 21 (level, low) -> IRQ 19
<6>[   29.388672] ohci_hcd 0000:00:03.1: OHCI Host Controller
<6>[   29.406003] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2
<7>[   29.423513] ohci_hcd 0000:00:03.1: created debug files
<6>[   29.423523] ohci_hcd 0000:00:03.1: irq 19, io mem 0xe2022000
<7>[   29.497167] ohci_hcd 0000:00:03.1: OHCI controller state
<7>[   29.497174] ohci_hcd 0000:00:03.1: OHCI 1.0, NO legacy support registers
<7>[   29.497178] ohci_hcd 0000:00:03.1: control 0x083 HCFS=operational CBSR=3
<7>[   29.497181] ohci_hcd 0000:00:03.1: cmdstatus 0x00000 SOC=0
<7>[   29.497185] ohci_hcd 0000:00:03.1: intrstatus 0x00000044 RHSC SF
<7>[   29.497189] ohci_hcd 0000:00:03.1: intrenable 0x8000000a MIE RD WDH
<7>[   29.497195] ohci_hcd 0000:00:03.1: hcca frame #0003
<7>[   29.497199] ohci_hcd 0000:00:03.1: roothub.a 01001202 POTPGT=1 NOCP NPS NDP=2(2)
<7>[   29.497203] ohci_hcd 0000:00:03.1: roothub.b 00000000 PPCM=0000 DR=0000
<7>[   29.497207] ohci_hcd 0000:00:03.1: roothub.status 00008000 DRWE
<7>[   29.497212] ohci_hcd 0000:00:03.1: roothub.portstatus [0] 0x00010101 CSC PPS CCS
<7>[   29.497217] ohci_hcd 0000:00:03.1: roothub.portstatus [1] 0x00000100 PPS
<7>[   29.497238] usb usb2: default language 0x0409
<7>[   29.497246] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   29.497250] usb usb2: Product: OHCI Host Controller
<7>[   29.514516] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
<6>[   29.514527] usb usb2: Manufacturer: Linux 2.6.22-speedy ohci_hcd
<6>[   29.531733] usb usb2: SerialNumber: 0000:00:03.1
<7>[   29.548846] usb usb2: uevent
<7>[   29.548865] usb usb2: usb_probe_device
<6>[   29.548911] usb usb2: configuration #1 chosen from 1 choice
<7>[   29.565986] usb usb2: adding 2-0:1.0 (config #1, interface 0)
<7>[   29.565998] usb 2-0:1.0: uevent
<7>[   29.566001] usb 2-0:1.0: uevent
<7>[   29.566012] hub 2-0:1.0: usb_probe_interface
<7>[   29.566014] hub 2-0:1.0: usb_probe_interface - got id
<6>[   29.566017] hub 2-0:1.0: USB hub found
<6>[   29.582872] hub 2-0:1.0: 2 ports detected
<7>[   29.599493] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<7>[   29.599498] hub 2-0:1.0: standalone hub
<7>[   29.599500] hub 2-0:1.0: no power switching (usb 1.0)
<7>[   29.599503] hub 2-0:1.0: no over-current protection
<7>[   29.599506] hub 2-0:1.0: power on to power good time: 2ms
<7>[   29.599511] hub 2-0:1.0: local power source is good
<7>[   29.599515] hub 2-0:1.0: trying to enable port power on non-switchable hub
<6>[   29.638785] Linux video capture interface: v2.00
<6>[   29.655430] usb 1-1: new low speed USB device using ohci_hcd and address 2
<6>[   29.703221] ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 22 (level, low) -> IRQ 20
<6>[   29.720114] ohci_hcd 0000:00:03.2: OHCI Host Controller
<6>[   29.736975] ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 3
<7>[   29.753911] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<7>[   29.753926] ohci_hcd 0000:00:03.2: created debug files
<6>[   29.753936] ohci_hcd 0000:00:03.2: irq 20, io mem 0xe2023000
<6>[   29.777186] saa7130/34: v4l2 driver version 0.2.14 loaded
<7>[   29.827036] ohci_hcd 0000:00:03.2: enabling initreset quirk
<7>[   29.829035] ohci_hcd 0000:00:03.2: OHCI controller state
<7>[   29.829039] ohci_hcd 0000:00:03.2: OHCI 1.0, NO legacy support registers
<7>[   29.829043] ohci_hcd 0000:00:03.2: control 0x083 HCFS=operational CBSR=3
<7>[   29.829046] ohci_hcd 0000:00:03.2: cmdstatus 0x00000 SOC=0
<7>[   29.829050] ohci_hcd 0000:00:03.2: intrstatus 0x00000004 SF
<7>[   29.829054] ohci_hcd 0000:00:03.2: intrenable 0x8000004a MIE RHSC RD WDH
<7>[   29.829060] ohci_hcd 0000:00:03.2: hcca frame #0003
<7>[   29.829065] ohci_hcd 0000:00:03.2: roothub.a 01001202 POTPGT=1 NOCP NPS NDP=2(2)
<7>[   29.829068] ohci_hcd 0000:00:03.2: roothub.b 00000000 PPCM=0000 DR=0000
<7>[   29.829072] ohci_hcd 0000:00:03.2: roothub.status 00008000 DRWE
<7>[   29.829076] ohci_hcd 0000:00:03.2: roothub.portstatus [0] 0x00000100 PPS
<7>[   29.829080] ohci_hcd 0000:00:03.2: roothub.portstatus [1] 0x00000100 PPS
<7>[   29.829095] usb usb3: default language 0x0409
<7>[   29.829103] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   29.829106] usb usb3: Product: OHCI Host Controller
<6>[   29.846075] usb usb3: Manufacturer: Linux 2.6.22-speedy ohci_hcd
<6>[   29.863230] usb usb3: SerialNumber: 0000:00:03.2
<7>[   29.880478] usb usb3: uevent
<7>[   29.880499] usb usb3: usb_probe_device
<6>[   29.880544] usb usb3: configuration #1 chosen from 1 choice
<7>[   29.897969] usb 1-1: skipped 1 descriptor after interface
<7>[   29.897979] usb usb3: adding 3-0:1.0 (config #1, interface 0)
<7>[   29.897991] usb 3-0:1.0: uevent
<7>[   29.897995] usb 3-0:1.0: uevent
<7>[   29.898007] hub 3-0:1.0: usb_probe_interface
<7>[   29.898009] hub 3-0:1.0: usb_probe_interface - got id
<6>[   29.898012] hub 3-0:1.0: USB hub found
<6>[   29.915524] hub 3-0:1.0: 2 ports detected
<7>[   29.932956] usb 1-1: default language 0x0409
<7>[   29.932961] hub 3-0:1.0: standalone hub
<7>[   29.932963] hub 3-0:1.0: no power switching (usb 1.0)
<7>[   29.932966] hub 3-0:1.0: no over-current protection
<7>[   29.932969] hub 3-0:1.0: power on to power good time: 2ms
<7>[   29.932974] hub 3-0:1.0: local power source is good
<7>[   29.932977] hub 3-0:1.0: trying to enable port power on non-switchable hub
<7>[   29.935868] usb 1-1: new device strings: Mfr=0, Product=2, SerialNumber=0
<6>[   29.935872] usb 1-1: Product: USB Optical Mouse
<7>[   29.953324] usb 1-1: uevent
<7>[   29.953338] usb 1-1: usb_probe_device
<6>[   29.953377] usb 1-1: configuration #1 chosen from 1 choice
<7>[   29.972852] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
<7>[   29.972873] usb 1-1:1.0: uevent
<7>[   29.972876] usb 1-1:1.0: uevent
<7>[   29.972945] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   29.972951] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   29.972957] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
<7>[   29.972962] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
<6>[   30.034746] ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 23 (level, low) -> IRQ 21
<6>[   30.054608] ehci_hcd 0000:00:03.3: EHCI Host Controller
<6>[   30.072347] ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 4
<7>[   30.090141] ehci_hcd 0000:00:03.3: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
<7>[   30.090146] ehci_hcd 0000:00:03.3: reset hcc_params 7070 thresh 7 uframes 1024
<7>[   30.090187] PCI: cache line size of 128 is not supported by device 0000:00:03.3
<7>[   30.090190] ehci_hcd 0000:00:03.3: supports USB remote wakeup
<6>[   30.090200] ehci_hcd 0000:00:03.3: irq 21, io mem 0xe2024000
<7>[   30.107916] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<7>[   30.107944] ehci_hcd 0000:00:03.3: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[   30.107952] ehci_hcd 0000:00:03.3: init command 010001 (park)=0 ithresh=1 period=1024 RUN
<6>[   30.107957] ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
<7>[   30.125785] usb usb4: default language 0x0409
<7>[   30.125793] usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   30.125796] usb usb4: Product: EHCI Host Controller
<6>[   30.143765] usb usb4: Manufacturer: Linux 2.6.22-speedy ehci_hcd
<6>[   30.161728] usb usb4: SerialNumber: 0000:00:03.3
<7>[   30.179546] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00130100 PRSC PESC CSC PPS
<7>[   30.179558] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>[   30.179575] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   30.179580] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00030300 PESC CSC LSDA PPS
<7>[   30.179585] hub 1-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s
<6>[   30.179588] usb 1-1: USB disconnect, address 2
<7>[   30.197112] usb 1-1: unregistering device
<7>[   30.197114] usb 1-1: usb_disable_device nuking all URBs
<7>[   30.197119] usb 1-1: unregistering interface 1-1:1.0
<7>[   30.197158] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
<7>[   30.197176] usb 1-1:1.0: uevent
<7>[   30.197180] usb 1-1:1.0: uevent
<7>[   30.197234] usb_endpoint usbdev1.2_ep00: ep_device_release called for usbdev1.2_ep00
<7>[   30.197250] usb 1-1: uevent
<7>[   30.197291] usb usb4: uevent
<7>[   30.197303] usb usb4: usb_probe_device
<6>[   30.197340] usb usb4: configuration #1 chosen from 1 choice
<7>[   30.214898] usb usb4: adding 4-0:1.0 (config #1, interface 0)
<7>[   30.214910] usb 4-0:1.0: uevent
<7>[   30.214913] usb 4-0:1.0: uevent
<7>[   30.214925] hub 4-0:1.0: usb_probe_interface
<7>[   30.214927] hub 4-0:1.0: usb_probe_interface - got id
<6>[   30.214930] hub 4-0:1.0: USB hub found
<6>[   30.232332] hub 4-0:1.0: 6 ports detected
<7>[   30.249621] hub 4-0:1.0: standalone hub
<7>[   30.249623] hub 4-0:1.0: no power switching (usb 1.0)
<7>[   30.249626] hub 4-0:1.0: individual port over-current protection
<7>[   30.249629] hub 4-0:1.0: Single TT
<7>[   30.249632] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   30.249635] hub 4-0:1.0: power on to power good time: 20ms
<7>[   30.249640] hub 4-0:1.0: local power source is good
<7>[   30.249642] hub 4-0:1.0: trying to enable port power on non-switchable hub
<7>[   30.326909] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300
<7>[   30.326918] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   30.326925] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00030100 PESC CSC PPS
<7>[   30.326932] hub 2-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
<7>[   30.330998] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000010dc001ecc82]
<6>[   30.351035] ACPI: PCI Interrupt 0000:00:07.2[C] -> GSI 16 (level, low) -> IRQ 16
<6>[   30.368610] ehci_hcd 0000:00:07.2: EHCI Host Controller
<6>[   30.386138] ehci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 5
<7>[   30.403788] ehci_hcd 0000:00:07.2: reset hcs_params 0x2204 dbg=0 cc=2 pcc=2 ordered !ppc ports=4
<7>[   30.403793] ehci_hcd 0000:00:07.2: reset hcc_params 6872 thresh 7 uframes 256/512/1024
<7>[   30.403843] ehci_hcd 0000:00:07.2: MWI active
<7>[   30.403846] ehci_hcd 0000:00:07.2: supports USB remote wakeup
<6>[   30.403857] ehci_hcd 0000:00:07.2: irq 16, io mem 0xe2026000
<7>[   30.421321] ehci_hcd 0000:00:07.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[   30.421328] ehci_hcd 0000:00:07.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
<6>[   30.421332] ehci_hcd 0000:00:07.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
<7>[   30.438860] usb usb5: default language 0x0409
<7>[   30.438869] usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   30.438871] usb usb5: Product: EHCI Host Controller
<6>[   30.456350] usb usb5: Manufacturer: Linux 2.6.22-speedy ehci_hcd
<7>[   30.474023] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
<7>[   30.474029] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
<7>[   30.474035] ehci_hcd 0000:00:03.3: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
<7>[   30.474042] hub 4-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
<6>[   30.474047] usb usb5: SerialNumber: 0000:00:07.2
<7>[   30.491714] usb usb5: uevent
<7>[   30.491731] usb usb5: usb_probe_device
<6>[   30.491771] usb usb5: configuration #1 chosen from 1 choice
<7>[   30.509491] usb usb5: adding 5-0:1.0 (config #1, interface 0)
<7>[   30.509510] usb 5-0:1.0: uevent
<7>[   30.509513] usb 5-0:1.0: uevent
<7>[   30.509526] hub 5-0:1.0: usb_probe_interface
<7>[   30.509528] hub 5-0:1.0: usb_probe_interface - got id
<6>[   30.509530] hub 5-0:1.0: USB hub found
<6>[   30.527246] hub 5-0:1.0: 4 ports detected
<7>[   30.544503] hub 5-0:1.0: standalone hub
<7>[   30.544506] hub 5-0:1.0: no power switching (usb 1.0)
<7>[   30.544508] hub 5-0:1.0: individual port over-current protection
<7>[   30.544511] hub 5-0:1.0: Single TT
<7>[   30.544514] hub 5-0:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   30.544517] hub 5-0:1.0: power on to power good time: 20ms
<7>[   30.544521] hub 5-0:1.0: local power source is good
<7>[   30.544524] hub 5-0:1.0: trying to enable port power on non-switchable hub
<7>[   30.606807] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
<7>[   30.606818] ehci_hcd 0000:00:03.3: port 1 low speed --> companion
<6>[   30.647256] ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 18 (level, low) -> IRQ 22
<7>[   30.664457] ehci_hcd 0000:00:03.3: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
<7>[   30.664479] ehci_hcd 0000:00:03.3: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
<7>[   30.664486] hub 4-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
<6>[   30.664503] uhci_hcd 0000:00:07.0: UHCI Host Controller
<6>[   30.681636] uhci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 6
<6>[   30.698836] uhci_hcd 0000:00:07.0: detected 2 ports
<7>[   30.715817] uhci_hcd 0000:00:07.0: uhci_check_and_reset_hc: cmd = 0x0000
<7>[   30.715820] uhci_hcd 0000:00:07.0: Performing full reset
<6>[   30.715843] uhci_hcd 0000:00:07.0: irq 22, io base 0x0000e000
<7>[   30.732755] usb usb6: default language 0x0409
<7>[   30.732764] usb usb6: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   30.732766] usb usb6: Product: UHCI Host Controller
<6>[   30.749603] usb usb6: Manufacturer: Linux 2.6.22-speedy uhci_hcd
<6>[   30.766528] usb usb6: SerialNumber: 0000:00:07.0
<7>[   30.783459] usb usb6: uevent
<7>[   30.783476] usb usb6: usb_probe_device
<6>[   30.783521] usb usb6: configuration #1 chosen from 1 choice
<7>[   30.800325] hub 4-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
<7>[   30.800354] usb usb6: adding 6-0:1.0 (config #1, interface 0)
<7>[   30.800366] usb 6-0:1.0: uevent
<7>[   30.800370] usb 6-0:1.0: uevent
<7>[   30.800383] hub 6-0:1.0: usb_probe_interface
<7>[   30.800386] hub 6-0:1.0: usb_probe_interface - got id
<6>[   30.800388] hub 6-0:1.0: USB hub found
<6>[   30.816995] hub 6-0:1.0: 2 ports detected
<7>[   30.833658] hub 6-0:1.0: standalone hub
<7>[   30.833660] hub 6-0:1.0: no power switching (usb 1.0)
<7>[   30.833662] hub 6-0:1.0: individual port over-current protection
<7>[   30.833665] hub 6-0:1.0: power on to power good time: 2ms
<7>[   30.833669] hub 6-0:1.0: local power source is good
<7>[   30.833671] hub 6-0:1.0: trying to enable port power on non-switchable hub
<7>[   30.854760] ehci_hcd 0000:00:03.3: port 2 full speed --> companion
<7>[   30.854767] ehci_hcd 0000:00:03.3: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
<7>[   30.854804] hub 4-0:1.0: port 2 not reset yet, waiting 50ms
<7>[   30.910744] ehci_hcd 0000:00:03.3: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
<7>[   30.910773] hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0004
<7>[   30.910779] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   30.910786] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00010301 CSC LSDA PPS CCS
<7>[   30.910791] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
<6>[   30.934870] ACPI: PCI Interrupt 0000:00:07.1[B] -> GSI 19 (level, low) -> IRQ 23
<6>[   30.952065] uhci_hcd 0000:00:07.1: UHCI Host Controller
<6>[   30.969096] uhci_hcd 0000:00:07.1: new USB bus registered, assigned bus number 7
<6>[   30.985900] uhci_hcd 0000:00:07.1: detected 2 ports
<7>[   31.002313] uhci_hcd 0000:00:07.1: uhci_check_and_reset_hc: cmd = 0x0000
<7>[   31.002316] uhci_hcd 0000:00:07.1: Performing full reset
<6>[   31.002341] uhci_hcd 0000:00:07.1: irq 23, io base 0x0000e400
<7>[   31.018683] usb usb7: default language 0x0409
<7>[   31.018691] usb usb7: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   31.018694] usb usb7: Product: UHCI Host Controller
<6>[   31.034963] usb usb7: Manufacturer: Linux 2.6.22-speedy uhci_hcd
<7>[   31.051281] ohci_hcd 0000:00:03.2: auto-stop root hub
<7>[   31.051301] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
<6>[   31.051311] usb usb7: SerialNumber: 0000:00:07.1
<7>[   31.067657] usb usb7: uevent
<7>[   31.067677] usb usb7: usb_probe_device
<6>[   31.067720] usb usb7: configuration #1 chosen from 1 choice
<7>[   31.083828] usb usb7: adding 7-0:1.0 (config #1, interface 0)
<7>[   31.083844] usb 7-0:1.0: uevent
<7>[   31.083847] usb 7-0:1.0: uevent
<7>[   31.083860] hub 7-0:1.0: usb_probe_interface
<7>[   31.083862] hub 7-0:1.0: usb_probe_interface - got id
<6>[   31.083865] hub 7-0:1.0: USB hub found
<6>[   31.099887] hub 7-0:1.0: 2 ports detected
<7>[   31.115812] hub 7-0:1.0: standalone hub
<7>[   31.115814] hub 7-0:1.0: no power switching (usb 1.0)
<7>[   31.115816] hub 7-0:1.0: individual port over-current protection
<7>[   31.115819] hub 7-0:1.0: power on to power good time: 2ms
<7>[   31.115824] hub 7-0:1.0: local power source is good
<7>[   31.115827] hub 7-0:1.0: trying to enable port power on non-switchable hub
<7>[   31.122650] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<6>[   31.177917] usb 1-1: new low speed USB device using ohci_hcd and address 3
<6>[   31.218426] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
<6>[   31.237948] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 19 (level, low) -> IRQ 23
<6>[   31.255618] 0000:00:04.0: Unknown PHY transceiver found at address 0.
<7>[   31.272206] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<6>[   31.272978] 0000:00:04.0: Realtek RTL8201 PHY transceiver found at address 1.
<6>[   31.290291] 0000:00:04.0: Unknown PHY transceiver found at address 2.
<6>[   31.307539] 0000:00:04.0: Unknown PHY transceiver found at address 3.
<6>[   31.324593] 0000:00:04.0: Unknown PHY transceiver found at address 4.
<6>[   31.341488] 0000:00:04.0: Unknown PHY transceiver found at address 5.
<6>[   31.358180] 0000:00:04.0: Unknown PHY transceiver found at address 6.
<6>[   31.378415] 0000:00:04.0: Unknown PHY transceiver found at address 7.
<6>[   31.394854] 0000:00:04.0: Unknown PHY transceiver found at address 8.
<6>[   31.411146] 0000:00:04.0: Unknown PHY transceiver found at address 9.
<6>[   31.427198] 0000:00:04.0: Unknown PHY transceiver found at address 10.
<7>[   31.442426] usb 1-1: skipped 1 descriptor after interface
<6>[   31.443205] 0000:00:04.0: Unknown PHY transceiver found at address 11.
<7>[   31.458399] usb 1-1: default language 0x0409
<6>[   31.459175] 0000:00:04.0: Unknown PHY transceiver found at address 12.
<7>[   31.474089] usb 1-1: new device strings: Mfr=0, Product=2, SerialNumber=0
<6>[   31.474093] usb 1-1: Product: USB Optical Mouse
<7>[   31.488807] usb 1-1: uevent
<7>[   31.488828] usb 1-1: usb_probe_device
<6>[   31.488879] usb 1-1: configuration #1 chosen from 1 choice
<6>[   31.504175] 0000:00:04.0: Unknown PHY transceiver found at address 13.
<7>[   31.518833] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
<7>[   31.518851] usb 1-1:1.0: uevent
<7>[   31.518855] usb 1-1:1.0: uevent
<7>[   31.518918] hub 5-0:1.0: state 7 ports 4 chg 0000 evt 0000
<7>[   31.518930] ehci_hcd 0000:00:07.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
<7>[   31.518936] hub 5-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
<6>[   31.519711] 0000:00:04.0: Unknown PHY transceiver found at address 14.
<6>[   31.534966] 0000:00:04.0: Unknown PHY transceiver found at address 15.
<6>[   31.550016] 0000:00:04.0: Unknown PHY transceiver found at address 16.
<6>[   31.565382] 0000:00:04.0: Unknown PHY transceiver found at address 17.
<6>[   31.580101] 0000:00:04.0: Unknown PHY transceiver found at address 18.
<6>[   31.594673] 0000:00:04.0: Unknown PHY transceiver found at address 19.
<6>[   31.609072] 0000:00:04.0: Unknown PHY transceiver found at address 20.
<6>[   31.623301] 0000:00:04.0: Unknown PHY transceiver found at address 21.
<6>[   31.637460] 0000:00:04.0: Unknown PHY transceiver found at address 22.
<6>[   31.651491] 0000:00:04.0: Unknown PHY transceiver found at address 23.
<6>[   31.665379] 0000:00:04.0: Unknown PHY transceiver found at address 24.
<7>[   31.678226] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
<6>[   31.679009] 0000:00:04.0: Unknown PHY transceiver found at address 25.
<6>[   31.692332] 0000:00:04.0: Unknown PHY transceiver found at address 26.
<6>[   31.705493] 0000:00:04.0: Unknown PHY transceiver found at address 27.
<6>[   31.718497] 0000:00:04.0: Unknown PHY transceiver found at address 28.
<6>[   31.731333] 0000:00:04.0: Unknown PHY transceiver found at address 29.
<7>[   31.743328] ehci_hcd 0000:00:07.2: port 2 high speed
<7>[   31.743333] ehci_hcd 0000:00:07.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
<6>[   31.744102] 0000:00:04.0: Unknown PHY transceiver found at address 30.
<6>[   31.756484] 0000:00:04.0: Unknown PHY transceiver found at address 31.
<6>[   31.791907] 0000:00:04.0: Using transceiver found at address 1 as default
<6>[   31.803445] usb 5-2: new high speed USB device using ehci_hcd and address 2
<6>[   31.816112] eth0: SiS 900 PCI Fast Ethernet at 0xdc00, IRQ 23, 00:10:dc:c5:f1:83.
<6>[   31.828648] ACPI: PCI Interrupt 0000:00:02.7[C] -> GSI 18 (level, low) -> IRQ 22
<7>[   31.870682] ehci_hcd 0000:00:07.2: port 2 high speed
<7>[   31.870689] ehci_hcd 0000:00:07.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
<7>[   31.946802] usb 5-2: new device strings: Mfr=0, Product=0, SerialNumber=0
<7>[   31.946846] usb 5-2: uevent
<7>[   31.946869] usb 5-2: usb_probe_device
<6>[   31.946916] usb 5-2: configuration #1 chosen from 1 choice
<7>[   31.959553] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
<7>[   31.959577] usb 5-2:1.0: uevent
<7>[   31.959581] usb 5-2:1.0: uevent
<7>[   31.959598] hub 5-2:1.0: usb_probe_interface
<7>[   31.959600] hub 5-2:1.0: usb_probe_interface - got id
<6>[   31.959603] hub 5-2:1.0: USB hub found
<6>[   31.972044] hub 5-2:1.0: 2 ports detected
<7>[   31.984146] hub 5-2:1.0: compound device; port removable status: FR
<7>[   31.984149] hub 5-2:1.0: ganged power switching
<7>[   31.984151] hub 5-2:1.0: global over-current protection
<7>[   31.984153] hub 5-2:1.0: Single TT
<7>[   31.984155] hub 5-2:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   31.984161] hub 5-2:1.0: power on to power good time: 100ms
<7>[   31.984414] hub 5-2:1.0: local power source is good
<7>[   31.984417] hub 5-2:1.0: no over-current condition exists
<7>[   31.984420] hub 5-2:1.0: enabling power on all ports
<7>[   32.086353] usb 5-2: link qh256-0001/c5f3e100 start 255 [1/0 us]
<7>[   32.086479] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   32.086488] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
<7>[   32.086493] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
<6>[   32.086517] usbcore: registered new interface driver hiddev
<6>[   32.162333] intel8x0_measure_ac97_clock: measured 52676 usecs
<6>[   32.174473] intel8x0: clocking to 48000
<6>[   32.186724] ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 23
<6>[   32.198917] saa7134[0]: found at 0000:00:08.0, rev: 1, irq: 23, latency: 32, mmio: 0xe2027000
<6>[   32.211353] saa7134[0]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
<7>[   32.223909] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<6>[   32.232264] saa7134[0]: board init: gpio is 0
<7>[   32.298279] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
<6>[   32.354258] usb 2-1: new full speed USB device using ohci_hcd and address 3
<6>[   32.390255] saa7134[0]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
<6>[   32.403241] saa7134[0]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
<6>[   32.416115] saa7134[0]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   32.429065] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<7>[   32.441774] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
<6>[   32.441780] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   32.454366] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   32.466746] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   32.478972] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   32.506206] saa7134[0] Tuner type is 38
<7>[   32.518027] usb 2-1: ep0 maxpacket = 8
<7>[   32.528660] usb 2-1: default language 0x0409
<7>[   32.537660] usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=3
<6>[   32.537664] usb 2-1: Product: Medion Flash XL V3.0C
<6>[   32.549438] usb 2-1: Manufacturer: MEDION
<6>[   32.561308] usb 2-1: SerialNumber: 2003-02
<7>[   32.572931] usb 2-1: uevent
<7>[   32.572955] usb 2-1: usb_probe_device
<6>[   32.573012] usb 2-1: configuration #1 chosen from 1 choice
<7>[   32.588650] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
<7>[   32.588692] usb 2-1:1.0: uevent
<7>[   32.588696] usb 2-1:1.0: uevent
<7>[   32.591779] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0006
<7>[   32.591792] uhci_hcd 0000:00:07.0: port 1 portsc 008a,00
<7>[   32.591802] hub 6-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
<6>[   32.634204] tuner 1-0043: chip found @ 0x86 (saa7134[0])
<6>[   32.645840] tda9887 1-0043: tda988[5/6/7] found @ 0x43 (tuner)
<4>[   32.674167] tuner 1-0060: All bytes are equal. It is not a TEA5767
<6>[   32.685974] tuner 1-0060: chip found @ 0xc0 (saa7134[0])
<6>[   32.697676] tuner 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
<6>[   32.709449] tuner 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
<6>[   32.723373] saa7134[0]: registered device video0 [v4l2]
<7>[   32.735064] hub 6-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
<7>[   32.735071] uhci_hcd 0000:00:07.0: port 2 portsc 008a,00
<7>[   32.735080] hub 6-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
<6>[   32.735104] saa7134[0]: registered device vbi0
<6>[   32.746601] saa7134[0]: registered device radio0
<7>[   32.862116] hub 6-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
<7>[   32.862125] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   32.862134] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0006
<7>[   32.862141] uhci_hcd 0000:00:07.1: port 1 portsc 008a,00
<7>[   32.862150] hub 7-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
<5>[   32.913919] SCSI subsystem initialized
<7>[   32.990088] hub 7-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
<7>[   32.990097] uhci_hcd 0000:00:07.1: port 2 portsc 008a,00
<7>[   32.990106] hub 7-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
<6>[   33.014319] Initializing USB Mass Storage driver...
<3>[   33.045021] saa7134[0]/dvb: frontend initialization failed
<7>[   33.121200] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
<7>[   33.121209] hub 5-2:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   33.121235] usbhid 1-1:1.0: usb_probe_interface
<7>[   33.121238] usbhid 1-1:1.0: usb_probe_interface - got id
<7>[   33.121450] hub 5-2:1.0: port 1, status 0101, change 0001, 12 Mb/s
<6>[   33.126508] input: USB Optical Mouse as /class/input/input3
<6>[   33.137731] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:03.0-1
<7>[   33.249304] hub 5-2:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<6>[   33.321165] usb 5-2.1: new high speed USB device using ehci_hcd and address 3
<7>[   33.345159] hub 5-2:1.0: port 1 not reset yet, waiting 10ms
<7>[   33.437393] usb 5-2.1: new device strings: Mfr=0, Product=0, SerialNumber=0
<7>[   33.437428] usb 5-2.1: uevent
<7>[   33.437445] usb 5-2.1: usb_probe_device
<6>[   33.437502] usb 5-2.1: configuration #1 chosen from 1 choice
<7>[   33.449395] usb 5-2.1: adding 5-2.1:1.0 (config #1, interface 0)
<7>[   33.449418] usb 5-2.1:1.0: uevent
<7>[   33.449422] usb 5-2.1:1.0: uevent
<7>[   33.449440] hub 5-2.1:1.0: usb_probe_interface
<7>[   33.449442] hub 5-2.1:1.0: usb_probe_interface - got id
<6>[   33.449445] hub 5-2.1:1.0: USB hub found
<6>[   33.461388] hub 5-2.1:1.0: 4 ports detected
<7>[   33.473182] hub 5-2.1:1.0: compound device; port removable status: FRRR
<7>[   33.473184] hub 5-2.1:1.0: ganged power switching
<7>[   33.473187] hub 5-2.1:1.0: global over-current protection
<7>[   33.473441] hub 5-2.1:1.0: TT per port
<7>[   33.473444] hub 5-2.1:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   33.473447] hub 5-2.1:1.0: power on to power good time: 100ms
<7>[   33.473634] hub 5-2.1:1.0: local power source is good
<7>[   33.473637] hub 5-2.1:1.0: no over-current condition exists
<7>[   33.473639] hub 5-2.1:1.0: enabling power on all ports
<7>[   33.577043] usb 5-2.1: link qh256-0001/c5f3e200 start 255 [1/0 us]
<7>[   33.577255] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   33.577265] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>[   33.577268] hub 5-2.1:1.0: state 7 ports 4 chg 0000 evt 0000
<7>[   33.577291] usb-storage 2-1:1.0: usb_probe_interface
<7>[   33.577298] usb-storage 2-1:1.0: usb_probe_interface - got id
<6>[   33.577391] scsi0 : SCSI emulation for USB Mass Storage devices
<7>[   33.589562] hub 5-2.1:1.0: port 1, status 0101, change 0001, 12 Mb/s
<7>[   33.589622] usb-storage: device found at 3
<7>[   33.589625] usb-storage: waiting for device to settle before scanning
<7>[   33.717091] hub 5-2.1:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<6>[   33.789078] usb 5-2.1.1: new high speed USB device using ehci_hcd and address 4
<7>[   33.821069] hub 5-2.1:1.0: port 1 not reset yet, waiting 10ms
<7>[   33.933300] usb 5-2.1.1: skipped 1 descriptor after endpoint
<7>[   33.940545] usb 5-2.1.1: default language 0x0409
<7>[   33.979789] usb 5-2.1.1: new device strings: Mfr=1, Product=2, SerialNumber=3
<6>[   33.979792] usb 5-2.1.1: Product: Flash Card Reader
<6>[   33.992351] usb 5-2.1.1: Manufacturer: Generic
<7>[   34.004823] usb usb6: suspend_rh (auto-stop)
<6>[   34.004838] usb 5-2.1.1: SerialNumber: 26020128B005
<7>[   34.017449] usb usb7: suspend_rh (auto-stop)
<7>[   34.017498] usb 5-2.1.1: uevent
<7>[   34.017519] usb 5-2.1.1: usb_probe_device
<6>[   34.017579] usb 5-2.1.1: configuration #1 chosen from 1 choice
<7>[   34.030406] usb 5-2.1.1: adding 5-2.1.1:1.0 (config #1, interface 0)
<7>[   34.030422] usb 5-2.1.1:1.0: uevent
<7>[   34.030426] usb 5-2.1.1:1.0: uevent
<7>[   34.030906] hub 5-2.1:1.0: state 7 ports 4 chg 0000 evt 0002
<6>[   34.031542] usbcore: registered new interface driver usbhid
<6>[   34.044775] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
<7>[   34.057930] usb-storage 5-2.1.1:1.0: usb_probe_interface
<7>[   34.057936] usb-storage 5-2.1.1:1.0: usb_probe_interface - got id
<6>[   34.057987] scsi1 : SCSI emulation for USB Mass Storage devices
<7>[   34.071131] usb-storage: device found at 4
<7>[   34.071134] usb-storage: waiting for device to settle before scanning
<6>[   34.071152] usbcore: registered new interface driver usb-storage
<6>[   34.084240] USB Mass Storage support registered.
<6>[   34.411494] Adding 27189972k swap on /dev/hdb11.  Priority:-1 extents:1 across:27189972k
<4>[   34.619907] fuse init (API version 7.8)
<6>[   35.742131] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
<5>[   38.629647] scsi 0:0:0:0: Direct-Access     Medion   Flash XL      CF 3.0C PQ: 0 ANSI: 0 CCS
<5>[   38.651420] scsi 0:0:0:1: Direct-Access     Medion   Flash XL      MS 3.0C PQ: 0 ANSI: 0 CCS
<5>[   38.673632] scsi 0:0:0:2: Direct-Access     Medion   Flash XL  MMC/SD 3.0C PQ: 0 ANSI: 0 CCS
<5>[   38.680436] scsi 0:0:0:3: Direct-Access     Medion   Flash XL      SM 3.0C PQ: 0 ANSI: 0 CCS
<7>[   38.718908] usb-storage: device scan complete
<5>[   38.859617] sd 0:0:0:0: [sda] Attached SCSI removable disk
<5>[   38.886919] sd 0:0:0:1: [sdb] Attached SCSI removable disk
<5>[   38.915016] sd 0:0:0:2: [sdc] Attached SCSI removable disk
<5>[   39.051675] sd 0:0:0:3: [sdd] Attached SCSI removable disk
<5>[   39.080275] scsi 1:0:0:0: Direct-Access     Generic  Flash HS-CF      4.44 PQ: 0 ANSI: 0
<5>[   39.101133] sd 1:0:0:0: [sde] Attached SCSI removable disk
<5>[   39.121756] scsi 1:0:0:1: Direct-Access     Generic  Flash HS-COMBO   4.44 PQ: 0 ANSI: 0
<6>[   39.142494] loop: module loaded
<5>[   39.160980] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>[   39.178094] sd 0:0:0:1: Attached scsi generic sg1 type 0
<5>[   39.195142] sd 0:0:0:2: Attached scsi generic sg2 type 0
<5>[   39.212070] sd 0:0:0:3: Attached scsi generic sg3 type 0
<5>[   39.228703] sd 1:0:0:0: Attached scsi generic sg4 type 0
<5>[   39.245147] sd 1:0:0:1: [sdf] Attached SCSI removable disk
<5>[   39.261436] sd 1:0:0:1: Attached scsi generic sg5 type 0
<7>[   39.278102] usb-storage: device scan complete
<6>[   39.402085] kjournald starting.  Commit interval 5 seconds
<6>[   39.418471] EXT3 FS on hdb8, internal journal
<6>[   39.440739] EXT3-fs: mounted filesystem with ordered data mode.
<6>[   39.483405] kjournald starting.  Commit interval 5 seconds
<6>[   39.499780] EXT3 FS on hdb9, internal journal
<6>[   39.516054] EXT3-fs: mounted filesystem with ordered data mode.
<6>[   39.569724] kjournald starting.  Commit interval 5 seconds
<6>[   39.586305] EXT3 FS on hdb10, internal journal
<6>[   39.602611] EXT3-fs: mounted filesystem with ordered data mode.
<7>[   39.685810] ISO 9660 Extensions: Microsoft Joliet Level 3
<7>[   39.741211] ISO 9660 Extensions: RRIP_1991A
<6>[   39.796165] SGI XFS with ACLs, security attributes, realtime, no debug enabled
<6>[   39.813088] SGI XFS Quota Management subsystem
<5>[   39.896628] XFS mounting filesystem hdb12
<7>[   39.999452] Ending clean XFS mount for filesystem: hdb12
Kernel logging (ksyslog) stopped.
Kernel log daemon terminating.

Boot logging started on /dev/tty1(/dev/console) at Sat Sep 15 18:49:09 2007


Boot of 2.6.23rc6 with CONFIG_PRINTK_TIME and CONFIG_USB_DEBUG

klogd 1.4.1, log source = ksyslog started.
<5>[    0.000000] Linux version 2.6.23-rc6-speedy (root@speedy) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #2 PREEMPT Sat Sep 15 18:44:45 CEST 2007
<6>[    0.000000] BIOS-provided physical RAM map:
<4>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
<4>[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
<4>[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<4>[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
<4>[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff3000 (ACPI NVS)
<4>[    0.000000]  BIOS-e820: 000000005fff3000 - 0000000060000000 (ACPI data)
<5>[    0.000000] 639MB HIGHMEM available.
<5>[    0.000000] 896MB LOWMEM available.
<6>[    0.000000] found SMP MP-table at 000f5980
<7>[    0.000000] Entering add_active_range(0, 0, 393200) 0 entries of 256 used
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA             0 ->     4096
<4>[    0.000000]   Normal       4096 ->   229376
<4>[    0.000000]   HighMem    229376 ->   393200
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[1] active PFN ranges
<4>[    0.000000]     0:        0 ->   393200
<7>[    0.000000] On node 0 totalpages: 393200
<7>[    0.000000]   DMA zone: 32 pages used for memmap
<7>[    0.000000]   DMA zone: 0 pages reserved
<7>[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
<7>[    0.000000]   Normal zone: 1760 pages used for memmap
<7>[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
<7>[    0.000000]   HighMem zone: 1279 pages used for memmap
<7>[    0.000000]   HighMem zone: 162545 pages, LIFO batch:31
<7>[    0.000000]   Movable zone: 0 pages used for memmap
<6>[    0.000000] DMI 2.3 present.
<4>[    0.000000] ACPI: RSDP 000F7350, 0014 (r0 AWARD )
<4>[    0.000000] ACPI: RSDT 5FFF3000, 002C (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
<4>[    0.000000] ACPI: FACP 5FFF3040, 0074 (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
<4>[    0.000000] ACPI: DSDT 5FFF30C0, 38BB (r1 AWARD  AWRDACPI     1000 MSFT  100000D)
<4>[    0.000000] ACPI: FACS 5FFF0000, 0040
<4>[    0.000000] ACPI: APIC 5FFF6980, 0054 (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x1008
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
<4>[    0.000000] Processor #0 15:2 APIC version 20
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<4>[    0.000000] IOAPIC[0]: apic_id 2, version 20, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<4>[    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:a0000000)
<4>[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
<4>[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
<4>[    0.000000] swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
<4>[    0.000000] Built 1 zonelists in Zone order.  Total pages: 390129
<5>[    0.000000] Kernel command line: root=/dev/hdb7 vga=0x346 resume=/dev/hdb11 splash=verbose console=tty0 crashkernel=64M@16M  3
<7>[    0.000000] mapped APIC to ffffb000 (fee00000)
<7>[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
<6>[    0.000000] Enabling fast FPU save and restore... done.
<6>[    0.000000] Enabling unmasked SIMD FPU exception support... done.
<6>[    0.000000] Initializing CPU#0
<4>[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
<4>[    0.000000] Detected 2672.794 MHz processor.
<4>[   16.900420] Console: colour dummy device 80x25
<6>[   16.900425] console [tty0] enabled
<6>[   16.901192] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
<6>[   16.901971] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
<6>[   16.951370] Memory: 1490028k/1572800k available (1740k kernel code, 81432k reserved, 672k data, 196k init, 655296k highmem)
<4>[   16.951391] virtual kernel memory layout:
<4>[   16.951393]     fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
<4>[   16.951394]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
<4>[   16.951395]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
<4>[   16.951397]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
<4>[   16.951398]       .init : 0xc125e000 - 0xc128f000   ( 196 kB)
<4>[   16.951399]       .data : 0xc11b3206 - 0xc125b564   ( 672 kB)
<4>[   16.951400]       .text : 0xc1000000 - 0xc11b3206   (1740 kB)
<4>[   16.951418] Checking if this processor honours the WP bit even in supervisor mode... Ok.
<4>[   17.031546] Calibrating delay using timer specific routine.. 5349.30 BogoMIPS (lpj=10698619)
<6>[   17.031596] Security Framework v1.0.0 initialized
<4>[   17.031618] Mount-cache hash table entries: 512
<7>[   17.031766] CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00000400 00000000 00000000 00000000
<6>[   17.031779] CPU: Trace cache: 12K uops, L1 D cache: 8K
<6>[   17.031783] CPU: L2 cache: 512K
<7>[   17.031786] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00000400 00000000 00000000 00000000
<6>[   17.031793] Intel machine check architecture supported.
<6>[   17.031799] Intel machine check reporting enabled on CPU#0.
<6>[   17.031803] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
<6>[   17.031808] CPU0: Thermal monitoring enabled
<4>[   17.031817] Compat vDSO mapped to ffffe000.
<4>[   17.031830] CPU: Intel(R) Pentium(R) 4 CPU 2.66GHz stepping 07
<6>[   17.031839] Checking 'hlt' instruction... OK.
<6>[   17.047750] ACPI: Core revision 20070126
<4>[   17.155150] ENABLING IO-APIC IRQs
<6>[   17.155322] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[   17.299758] NET: Registered protocol family 16
<6>[   17.299975] ACPI: bus type pci registered
<6>[   17.339368] PCI: PCI BIOS revision 2.10 entry at 0xfb400, last bus=1
<6>[   17.339373] PCI: Using configuration type 1
<4>[   17.339376] Setting up standard PCI resources
<7>[   17.348254] ACPI: EC: Look up EC in DSDT
<6>[   17.351549] ACPI: Interpreter enabled
<6>[   17.351557] ACPI: (supports S0 S3)
<6>[   17.351576] ACPI: Using IOAPIC for interrupt routing
<6>[   17.356558] ACPI: PCI Root Bridge [PCI0] (0000:00)
<6>[   17.356855] Enabling SiS 96x SMBus.
<7>[   17.358446] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<6>[   17.381947] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
<6>[   17.382070] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
<6>[   17.382181] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
<6>[   17.382292] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
<6>[   17.382399] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
<6>[   17.382517] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
<6>[   17.382627] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
<6>[   17.382734] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
<6>[   17.382871] Linux Plug and Play Support v0.97 (c) Adam Belay
<6>[   17.382908] pnp: PnP ACPI init
<6>[   17.382921] ACPI: bus type pnp registered
<6>[   17.385176] pnp: PnP ACPI: found 11 devices
<6>[   17.385182] ACPI: ACPI bus type pnp unregistered
<6>[   17.385189] PnPBIOS: Disabled by ACPI PNP
<6>[   17.385432] PCI: Using ACPI for IRQ routing
<6>[   17.385438] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
<6>[   17.411448] Time: tsc clocksource has been installed.
<6>[   17.419490] pnp: 00:00: iomem range 0xd0000-0xd3fff has been reserved
<6>[   17.419496] pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
<6>[   17.419501] pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
<6>[   17.419505] pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
<6>[   17.449881] PCI: Bridge: 0000:00:01.0
<6>[   17.449886]   IO window: disabled.
<6>[   17.449896]   MEM window: e0000000-e1ffffff
<6>[   17.449904]   PREFETCH window: d8000000-dfffffff
<6>[   17.449949] NET: Registered protocol family 2
<6>[   17.487459] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
<6>[   17.487630] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
<6>[   17.488802] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
<6>[   17.489195] TCP: Hash tables configured (established 131072 bind 65536)
<6>[   17.489201] TCP reno registered
<6>[   17.499608] checking if image is initramfs... it is
<6>[   17.731599] Freeing initrd memory: 2802k freed
<6>[   17.731859] Machine check exception polling timer started.
<6>[   17.731889] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
<5>[   17.731894] apm: overridden by ACPI.
<6>[   17.732247] audit: initializing netlink socket (disabled)
<5>[   17.732268] audit(1189882252.576:1): initialized
<4>[   17.732360] highmem bounce pool size: 64 pages
<4>[   17.732365] Total HugeTLB memory allocated, 0
<6>[   17.732506] io scheduler noop registered
<6>[   17.732510] io scheduler anticipatory registered
<6>[   17.732513] io scheduler deadline registered
<6>[   17.732525] io scheduler cfq registered (default)
<7>[   17.815344] pci 0000:00:07.0: uhci_check_and_reset_hc: legsup = 0x2000
<7>[   17.815347] pci 0000:00:07.0: Performing full reset
<7>[   17.815364] pci 0000:00:07.1: uhci_check_and_reset_hc: legsup = 0x2000
<7>[   17.815367] pci 0000:00:07.1: Performing full reset
<7>[   17.815395] Boot video device is 0000:01:00.0
<6>[   17.815683] vesafb: framebuffer at 0xd8000000, mapped to 0xf8880000, using 7500k, total 131072k
<6>[   17.815691] vesafb: mode is 1600x1200x16, linelength=3200, pages=1
<6>[   17.815695] vesafb: protected mode interface info at c000:def0
<6>[   17.815699] vesafb: pmi: set display start = c00cdf35, set palette = c00cdfba
<6>[   17.815703] vesafb: pmi: ports = b4c3 b503 ba03 c003 c103 c403 c503 c603 c703 c803 c903 cc03 ce03 cf03 d003 d103 d203 d303 d403 d503 da03 ff03
<6>[   17.815725] vesafb: scrolling: redraw
<6>[   17.815730] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
<4>[   17.881948] Console: switching to colour frame buffer device 200x75
<6>[   17.948327] fb0: VESA VGA frame buffer device
<6>[   17.948624] isapnp: Scanning for PnP cards...
<6>[   17.975278] Switched to NOHz mode on CPU #0
<6>[   18.259227] isapnp: No Plug & Play device found
<6>[   18.266523] Real Time Clock Driver v1.12ac
<6>[   18.266847] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
<6>[   18.267355] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>[   18.268169] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>[   18.268661] Floppy drive(s): fd0 is 1.44M
<6>[   18.286905] FDC 0 is a post-1991 82077
<4>[   18.288703] RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
<6>[   18.289277] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
<6>[   18.289930] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[   18.290189] serio: i8042 AUX port at 0x60,0x64 irq 12
<6>[   18.290609] mice: PS/2 mouse device common for all mice
<6>[   18.323758] input: AT Translated Set 2 keyboard as /class/input/input0
<6>[   18.332551] input: PC Speaker as /class/input/input1
<6>[   18.974061] input: ImPS/2 Generic Wheel Mouse as /class/input/input2
<6>[   18.978850] NET: Registered protocol family 1
<4>[   18.979085] Using IPI Shortcut mode
<6>[   18.979705] Freeing unused kernel memory: 196k freed
<6>[   19.294594] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
<6>[   19.294945] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
<6>[   19.318427] ACPI: Thermal Zone [THRM] (46 C)
<6>[   19.325069] SIS5513: IDE controller at PCI slot 0000:00:02.5
<6>[   19.325410] ACPI: PCI Interrupt 0000:00:02.5[A] -> GSI 16 (level, low) -> IRQ 16
<6>[   19.325814] SIS5513: chipset revision 0
<6>[   19.326016] SIS5513: not 100% native mode: will probe irqs later
<6>[   19.326349] SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
<6>[   19.326669]     ide0: BM-DMA at 0x4000-0x4007, BIOS settings: hda:DMA, hdb:DMA
<6>[   19.327083]     ide1: BM-DMA at 0x4008-0x400f, BIOS settings: hdc:DMA, hdd:DMA
<7>[   19.327479] Probing IDE interface ide0...
<4>[   19.614934] hda: ST3120023A, ATA DISK drive
<4>[   19.894731] hdb: SAMSUNG SP2514N, ATA DISK drive
<7>[   19.950794] hda: selected mode 0x45
<7>[   19.963687] hdb: selected mode 0x45
<4>[   19.980228] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
<6>[   19.989612] hda: max request size: 128KiB
<6>[   19.990047] hda: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=65535/16/63, UDMA(100)
<6>[   19.990666] hda: cache flushes supported
<6>[   19.990904]  hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 >
<6>[   20.082750] hdb: max request size: 512KiB
<6>[   20.098815] hdb: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(100)
<6>[   20.101746] hdb: cache flushes supported
<6>[   20.102026]  hdb: hdb1 hdb2 < hdb5 hdb6 hdb7 hdb8 hdb9 hdb10 hdb11 hdb12 >
<7>[   20.259090] Probing IDE interface ide1...
<4>[   21.010319] hdc: IDE DVD-ROM 16X, ATAPI CD/DVD-ROM drive
<4>[   21.810021] hdd: _NEC DVD_RW ND-1300A, ATAPI CD/DVD-ROM drive
<7>[   21.882711] hdc: selected mode 0x42
<7>[   21.883906] hdd: selected mode 0x42
<4>[   21.884072] ide1 at 0x170-0x177,0x376 on irq 15
<6>[   21.913490] ACPI: Fan [FAN] (on)
<6>[   21.953538] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
<4>[   22.106255] swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
<4>[   22.106260] swsusp: Basic memory bitmaps created
<4>[   22.114449] swsusp: Basic memory bitmaps freed
<4>[   22.122212] Attempting manual resume
<6>[   22.246776] kjournald starting.  Commit interval 5 seconds
<6>[   22.246906] EXT3 FS on hdb7, internal journal
<6>[   22.246916] EXT3-fs: mounted filesystem with ordered data mode.
<6>[   25.074963] lp: driver loaded but no devices found
<6>[   26.811082] Linux agpgart interface v0.102
<6>[   26.866255] ACPI: PCI Interrupt 0000:00:02.3[B] -> GSI 17 (level, low) -> IRQ 17
<6>[   26.965764] sis900.c: v1.08.10 Apr. 2 2006
<6>[   26.990844] usbcore: registered new interface driver usbfs
<6>[   27.014306] usbcore: registered new interface driver hub
<6>[   27.050902] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[   27.073691] usbcore: registered new device driver usb
<6>[   27.105311] Linux video capture interface: v2.00
<7>[   27.133379] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
<7>[   27.133384] ohci_hcd: block sizes: ed 64 td 64
<6>[   27.136391] USB Universal Host Controller Interface driver v3.0
<6>[   27.229568] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[17]  MMIO=[e2020000-e20207ff]  Max Packet=[2048]  IR/IT contexts=[4/6]
<6>[   27.261581] agpgart: Detected SiS chipset - id:1608
<7>[   27.288172] ehci_hcd: block sizes: qh 128 qtd 96 itd 192 sitd 96
<6>[   27.303726] agpgart: AGP aperture is 128M @ 0xd0000000
<6>[   27.324070] hdc: ATAPI 16X DVD-ROM drive, 512kB Cache, UDMA(33)
<6>[   27.345841] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 19 (level, low) -> IRQ 18
<6>[   27.364215] 0000:00:04.0: Unknown PHY transceiver found at address 0.
<6>[   27.381688] Uniform CD-ROM driver Revision: 3.20
<6>[   27.400492] 0000:00:04.0: Realtek RTL8201 PHY transceiver found at address 1.
<6>[   27.424810] saa7130/34: v4l2 driver version 0.2.14 loaded
<6>[   27.442837] 0000:00:04.0: Unknown PHY transceiver found at address 2.
<6>[   27.462589] 0000:00:04.0: Unknown PHY transceiver found at address 3.
<6>[   27.480102] hdd: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
<6>[   27.498391] 0000:00:04.0: Unknown PHY transceiver found at address 4.
<6>[   27.516848] 0000:00:04.0: Unknown PHY transceiver found at address 5.
<6>[   27.542732] 0000:00:04.0: Unknown PHY transceiver found at address 6.
<6>[   27.560964] 0000:00:04.0: Unknown PHY transceiver found at address 7.
<6>[   27.578869] 0000:00:04.0: Unknown PHY transceiver found at address 8.
<6>[   27.596762] 0000:00:04.0: Unknown PHY transceiver found at address 9.
<6>[   27.616704] 0000:00:04.0: Unknown PHY transceiver found at address 10.
<6>[   27.634504] 0000:00:04.0: Unknown PHY transceiver found at address 11.
<6>[   27.651702] 0000:00:04.0: Unknown PHY transceiver found at address 12.
<6>[   27.704083] 0000:00:04.0: Unknown PHY transceiver found at address 13.
<6>[   27.720734] 0000:00:04.0: Unknown PHY transceiver found at address 14.
<6>[   27.737118] 0000:00:04.0: Unknown PHY transceiver found at address 15.
<6>[   27.753185] 0000:00:04.0: Unknown PHY transceiver found at address 16.
<6>[   27.768970] 0000:00:04.0: Unknown PHY transceiver found at address 17.
<6>[   27.784510] 0000:00:04.0: Unknown PHY transceiver found at address 18.
<6>[   27.799790] 0000:00:04.0: Unknown PHY transceiver found at address 19.
<6>[   27.814879] 0000:00:04.0: Unknown PHY transceiver found at address 20.
<6>[   27.829800] 0000:00:04.0: Unknown PHY transceiver found at address 21.
<6>[   27.844565] 0000:00:04.0: Unknown PHY transceiver found at address 22.
<6>[   27.859231] 0000:00:04.0: Unknown PHY transceiver found at address 23.
<6>[   27.873651] 0000:00:04.0: Unknown PHY transceiver found at address 24.
<6>[   27.887825] 0000:00:04.0: Unknown PHY transceiver found at address 25.
<6>[   27.901995] 0000:00:04.0: Unknown PHY transceiver found at address 26.
<6>[   27.916161] 0000:00:04.0: Unknown PHY transceiver found at address 27.
<6>[   27.930315] 0000:00:04.0: Unknown PHY transceiver found at address 28.
<6>[   27.944171] 0000:00:04.0: Unknown PHY transceiver found at address 29.
<6>[   27.957830] 0000:00:04.0: Unknown PHY transceiver found at address 30.
<6>[   27.971472] 0000:00:04.0: Unknown PHY transceiver found at address 31.
<6>[   28.008127] 0000:00:04.0: Using transceiver found at address 1 as default
<6>[   28.021973] eth0: SiS 900 PCI Fast Ethernet at 0xdc00, IRQ 18, 00:10:dc:c5:f1:83.
<6>[   28.035056] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 19
<6>[   28.048115] ohci_hcd 0000:00:03.0: OHCI Host Controller
<6>[   28.061139] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
<7>[   28.074419] ohci_hcd 0000:00:03.0: created debug files
<6>[   28.074431] ohci_hcd 0000:00:03.0: irq 19, io mem 0xe2021000
<7>[   28.141497] ohci_hcd 0000:00:03.0: OHCI controller state
<7>[   28.141501] ohci_hcd 0000:00:03.0: OHCI 1.0, NO legacy support registers
<7>[   28.141505] ohci_hcd 0000:00:03.0: control 0x083 HCFS=operational CBSR=3
<7>[   28.141508] ohci_hcd 0000:00:03.0: cmdstatus 0x00000 SOC=0
<7>[   28.141511] ohci_hcd 0000:00:03.0: intrstatus 0x00000044 RHSC SF
<7>[   28.141514] ohci_hcd 0000:00:03.0: intrenable 0x8000000a MIE RD WDH
<7>[   28.141520] ohci_hcd 0000:00:03.0: hcca frame #0003
<7>[   28.141524] ohci_hcd 0000:00:03.0: roothub.a 01001202 POTPGT=1 NOCP NPS NDP=2(2)
<7>[   28.141528] ohci_hcd 0000:00:03.0: roothub.b 00000000 PPCM=0000 DR=0000
<7>[   28.141531] ohci_hcd 0000:00:03.0: roothub.status 00008000 DRWE
<7>[   28.141536] ohci_hcd 0000:00:03.0: roothub.portstatus [0] 0x00010301 CSC LSDA PPS CCS
<7>[   28.141539] ohci_hcd 0000:00:03.0: roothub.portstatus [1] 0x00000100 PPS
<7>[   28.141558] usb usb1: default language 0x0409
<7>[   28.141566] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   28.141568] usb usb1: Product: OHCI Host Controller
<6>[   28.154592] usb usb1: Manufacturer: Linux 2.6.23-rc6-speedy ohci_hcd
<6>[   28.167811] usb usb1: SerialNumber: 0000:00:03.0
<7>[   28.180985] usb usb1: uevent
<7>[   28.181151] usb usb1: usb_probe_device
<6>[   28.182381] usb usb1: configuration #1 chosen from 1 choice
<7>[   28.195604] usb usb1: adding 1-0:1.0 (config #1, interface 0)
<7>[   28.195620] usb 1-0:1.0: uevent
<7>[   28.195623] usb 1-0:1.0: uevent
<7>[   28.195773] hub 1-0:1.0: usb_probe_interface
<7>[   28.195776] hub 1-0:1.0: usb_probe_interface - got id
<6>[   28.195779] hub 1-0:1.0: USB hub found
<6>[   28.208829] hub 1-0:1.0: 2 ports detected
<7>[   28.221712] hub 1-0:1.0: standalone hub
<7>[   28.221715] hub 1-0:1.0: no power switching (usb 1.0)
<7>[   28.221717] hub 1-0:1.0: no over-current protection
<7>[   28.221719] hub 1-0:1.0: power on to power good time: 2ms
<7>[   28.221725] hub 1-0:1.0: local power source is good
<7>[   28.221727] hub 1-0:1.0: trying to enable port power on non-switchable hub
<7>[   28.323442] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>[   28.323768] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00010301 CSC LSDA PPS CCS
<7>[   28.323776] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
<6>[   28.323836] ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 18 (level, low) -> IRQ 20
<6>[   28.337023] uhci_hcd 0000:00:07.0: UHCI Host Controller
<6>[   28.350241] uhci_hcd 0000:00:07.0: new USB bus registered, assigned bus number 2
<6>[   28.363354] uhci_hcd 0000:00:07.0: detected 2 ports
<7>[   28.376317] uhci_hcd 0000:00:07.0: uhci_check_and_reset_hc: cmd = 0x0000
<7>[   28.376319] uhci_hcd 0000:00:07.0: Performing full reset
<6>[   28.376340] uhci_hcd 0000:00:07.0: irq 20, io base 0x0000e000
<7>[   28.389420] usb usb2: default language 0x0409
<7>[   28.389428] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   28.389431] usb usb2: Product: UHCI Host Controller
<6>[   28.402470] usb usb2: Manufacturer: Linux 2.6.23-rc6-speedy uhci_hcd
<6>[   28.415574] usb usb2: SerialNumber: 0000:00:07.0
<7>[   28.428745] usb usb2: uevent
<7>[   28.428913] usb usb2: usb_probe_device
<6>[   28.429082] usb usb2: configuration #1 chosen from 1 choice
<7>[   28.442373] usb usb2: adding 2-0:1.0 (config #1, interface 0)
<7>[   28.442389] usb 2-0:1.0: uevent
<7>[   28.442392] usb 2-0:1.0: uevent
<7>[   28.442544] hub 2-0:1.0: usb_probe_interface
<7>[   28.442547] hub 2-0:1.0: usb_probe_interface - got id
<6>[   28.442550] hub 2-0:1.0: USB hub found
<6>[   28.455767] hub 2-0:1.0: 2 ports detected
<7>[   28.468960] hub 2-0:1.0: standalone hub
<7>[   28.468963] hub 2-0:1.0: no power switching (usb 1.0)
<7>[   28.468964] hub 2-0:1.0: individual port over-current protection
<7>[   28.468967] hub 2-0:1.0: power on to power good time: 2ms
<7>[   28.468971] hub 2-0:1.0: local power source is good
<7>[   28.468974] hub 2-0:1.0: trying to enable port power on non-switchable hub
<7>[   28.472040] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
<7>[   28.543357] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<7>[   28.552385] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000010dc001ecc82]
<6>[   28.571693] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
<6>[   28.584884] sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x10c0
<6>[   28.600358] usb 1-1: new low speed USB device using ohci_hcd and address 2
<6>[   28.616245] ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 23 (level, low) -> IRQ 21
<6>[   28.632262] ehci_hcd 0000:00:03.3: EHCI Host Controller
<6>[   28.652269] ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 3
<7>[   28.665208] ehci_hcd 0000:00:03.3: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
<7>[   28.665212] ehci_hcd 0000:00:03.3: reset hcc_params 7070 thresh 7 uframes 1024
<7>[   28.665254] PCI: cache line size of 128 is not supported by device 0000:00:03.3
<7>[   28.665258] ehci_hcd 0000:00:03.3: supports USB remote wakeup
<6>[   28.665268] ehci_hcd 0000:00:03.3: irq 21, io mem 0xe2024000
<7>[   28.684000] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<7>[   28.684018] ehci_hcd 0000:00:03.3: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[   28.684025] ehci_hcd 0000:00:03.3: init command 010001 (park)=0 ithresh=1 period=1024 RUN
<6>[   28.684030] ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
<7>[   28.713688] usb usb3: default language 0x0409
<7>[   28.713699] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   28.713702] usb usb3: Product: EHCI Host Controller
<6>[   28.726712] usb usb3: Manufacturer: Linux 2.6.23-rc6-speedy ehci_hcd
<6>[   28.739792] usb usb3: SerialNumber: 0000:00:03.3
<7>[   28.752739] ohci_hcd 0000:00:03.0: urb c5ead340 path 1 ep0out 5ec20000 cc 5 --> status -62
<7>[   28.752777] usb usb3: uevent
<7>[   28.752981] usb usb3: usb_probe_device
<6>[   28.753149] usb usb3: configuration #1 chosen from 1 choice
<7>[   28.765850] usb usb3: adding 3-0:1.0 (config #1, interface 0)
<7>[   28.765866] usb 3-0:1.0: uevent
<7>[   28.765870] usb 3-0:1.0: uevent
<7>[   28.766029] hub 3-0:1.0: usb_probe_interface
<7>[   28.766032] hub 3-0:1.0: usb_probe_interface - got id
<6>[   28.766035] hub 3-0:1.0: USB hub found
<6>[   28.778320] hub 3-0:1.0: 6 ports detected
<7>[   28.790546] hub 3-0:1.0: standalone hub
<7>[   28.790548] hub 3-0:1.0: no power switching (usb 1.0)
<7>[   28.790550] hub 3-0:1.0: individual port over-current protection
<7>[   28.790552] hub 3-0:1.0: Single TT
<7>[   28.790554] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   28.790556] hub 3-0:1.0: power on to power good time: 20ms
<7>[   28.790561] hub 3-0:1.0: local power source is good
<7>[   28.790564] hub 3-0:1.0: trying to enable port power on non-switchable hub
<6>[   28.891611] ACPI: PCI Interrupt 0000:00:02.7[C] -> GSI 18 (level, low) -> IRQ 20
<7>[   28.957103] ohci_hcd 0000:00:03.0: urb c5ead340 path 1 ep0out 5ec20000 cc 5 --> status -62
<3>[   29.166906] usb 1-1: device not accepting address 2, error -62
<6>[   29.219108] intel8x0_measure_ac97_clock: measured 52223 usecs
<6>[   29.231404] intel8x0: clocking to 48000
<7>[   29.243556] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00030300 PESC CSC LSDA PPS
<7>[   29.243568] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
<7>[   29.243583] uhci_hcd 0000:00:07.0: port 1 portsc 008a,00
<7>[   29.243591] hub 2-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
<6>[   29.271859] ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 18
<6>[   29.284362] saa7134[0]: found at 0000:00:08.0, rev: 1, irq: 18, latency: 32, mmio: 0xe2027000
<6>[   29.315863] saa7134[0]: subsystem: 16be:0003, board: Medion 7134 [card=12,autodetected]
<6>[   29.331867] saa7134[0]: board init: gpio is 0
<7>[   29.379062] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
<7>[   29.379072] uhci_hcd 0000:00:07.0: port 2 portsc 009b,00
<7>[   29.379081] hub 2-0:1.0: port 2, status 0101, change 0003, 12 Mb/s
<6>[   29.487726] saa7134[0]: i2c eeprom 00: be 16 03 00 08 20 1c 55 43 43 a9 1c 55 43 43 a9
<6>[   29.500640] saa7134[0]: i2c eeprom 10: ff ff ff ff 15 00 0e 01 0c c0 08 00 00 00 00 00
<7>[   29.513424] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
<6>[   29.513439] saa7134[0]: i2c eeprom 20: 00 00 00 e3 ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   29.526287] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   29.539226] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   29.552152] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   29.567181] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   29.580131] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<6>[   29.610960] saa7134[0] Tuner type is 38
<6>[   29.623745] usb 2-2: new full speed USB device using uhci_hcd and address 2
<6>[   29.699660] tuner 1-0043: chip found @ 0x86 (saa7134[0])
<6>[   29.713053] tda9887 1-0043: tda988[5/6/7] found @ 0x43 (tuner)
<4>[   29.738912] tuner 1-0060: All bytes are equal. It is not a TEA5767
<6>[   29.752722] tuner 1-0060: chip found @ 0xc0 (saa7134[0])
<6>[   29.766658] tuner 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
<6>[   29.780914] tuner 1-0060: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
<6>[   29.800731] saa7134[0]: registered device video0 [v4l2]
<6>[   29.815177] usb 2-2: not running at top speed; connect to a high speed hub
<6>[   29.830150] saa7134[0]: registered device vbi0
<6>[   29.845271] saa7134[0]: registered device radio0
<7>[   29.860180] usb 2-2: new device strings: Mfr=0, Product=0, SerialNumber=0
<7>[   29.860206] usb 2-2: uevent
<7>[   29.860382] usb 2-2: usb_probe_device
<6>[   29.860549] usb 2-2: configuration #1 chosen from 1 choice
<7>[   29.877965] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
<7>[   29.877999] usb 2-2:1.0: uevent
<7>[   29.878003] usb 2-2:1.0: uevent
<7>[   29.878281] hub 2-2:1.0: usb_probe_interface
<7>[   29.878285] hub 2-2:1.0: usb_probe_interface - got id
<6>[   29.878287] hub 2-2:1.0: USB hub found
<6>[   29.894949] hub 2-2:1.0: 2 ports detected
<7>[   29.911259] hub 2-2:1.0: compound device; port removable status: FR
<7>[   29.911262] hub 2-2:1.0: ganged power switching
<7>[   29.911264] hub 2-2:1.0: global over-current protection
<7>[   29.911267] hub 2-2:1.0: power on to power good time: 100ms
<6>[   29.912470] ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 21 (level, low) -> IRQ 22
<7>[   29.929246] hub 2-2:1.0: local power source is good
<7>[   29.929249] hub 2-2:1.0: no over-current condition exists
<7>[   29.929251] hub 2-2:1.0: enabling power on all ports
<6>[   29.951861] ohci_hcd 0000:00:03.1: OHCI Host Controller
<6>[   29.977427] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 4
<7>[   29.993578] ohci_hcd 0000:00:03.1: created debug files
<6>[   29.993589] ohci_hcd 0000:00:03.1: irq 22, io mem 0xe2022000
<7>[   30.031582] uhci_hcd 0000:00:07.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
<7>[   30.032042] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   30.032052] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00030300 PESC CSC LSDA PPS
<7>[   30.032060] hub 1-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s
<7>[   30.071577] ohci_hcd 0000:00:03.1: enabling initreset quirk
<7>[   30.073577] ohci_hcd 0000:00:03.1: OHCI controller state
<7>[   30.073581] ohci_hcd 0000:00:03.1: OHCI 1.0, NO legacy support registers
<7>[   30.073585] ohci_hcd 0000:00:03.1: control 0x083 HCFS=operational CBSR=3
<7>[   30.073588] ohci_hcd 0000:00:03.1: cmdstatus 0x00000 SOC=0
<7>[   30.073591] ohci_hcd 0000:00:03.1: intrstatus 0x00000004 SF
<7>[   30.073595] ohci_hcd 0000:00:03.1: intrenable 0x8000004a MIE RHSC RD WDH
<7>[   30.073601] ohci_hcd 0000:00:03.1: hcca frame #0003
<7>[   30.073605] ohci_hcd 0000:00:03.1: roothub.a 01001202 POTPGT=1 NOCP NPS NDP=2(2)
<7>[   30.073609] ohci_hcd 0000:00:03.1: roothub.b 00000000 PPCM=0000 DR=0000
<7>[   30.073613] ohci_hcd 0000:00:03.1: roothub.status 00008000 DRWE
<7>[   30.073617] ohci_hcd 0000:00:03.1: roothub.portstatus [0] 0x00000100 PPS
<7>[   30.073621] ohci_hcd 0000:00:03.1: roothub.portstatus [1] 0x00000100 PPS
<7>[   30.073645] usb usb4: default language 0x0409
<7>[   30.073653] usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   30.073656] usb usb4: Product: OHCI Host Controller
<6>[   30.090046] usb usb4: Manufacturer: Linux 2.6.23-rc6-speedy ohci_hcd
<6>[   30.106677] usb usb4: SerialNumber: 0000:00:03.1
<7>[   30.123266] usb usb4: uevent
<7>[   30.123548] usb usb4: usb_probe_device
<6>[   30.123725] usb usb4: configuration #1 chosen from 1 choice
<7>[   30.140197] usb usb4: adding 4-0:1.0 (config #1, interface 0)
<7>[   30.140213] usb 4-0:1.0: uevent
<7>[   30.140216] usb 4-0:1.0: uevent
<7>[   30.140369] hub 4-0:1.0: usb_probe_interface
<7>[   30.140372] hub 4-0:1.0: usb_probe_interface - got id
<6>[   30.140374] hub 4-0:1.0: USB hub found
<6>[   30.156633] hub 4-0:1.0: 2 ports detected
<7>[   30.172685] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300
<7>[   30.172690] hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0000
<7>[   30.172698] ehci_hcd 0000:00:03.3: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
<7>[   30.172705] hub 3-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
<7>[   30.172710] hub 4-0:1.0: standalone hub
<7>[   30.172712] hub 4-0:1.0: no power switching (usb 1.0)
<7>[   30.172714] hub 4-0:1.0: no over-current protection
<7>[   30.172716] hub 4-0:1.0: power on to power good time: 2ms
<7>[   30.172721] hub 4-0:1.0: local power source is good
<7>[   30.172723] hub 4-0:1.0: trying to enable port power on non-switchable hub
<6>[   30.275988] ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 22 (level, low) -> IRQ 23
<6>[   30.292418] ohci_hcd 0000:00:03.2: OHCI Host Controller
<7>[   30.308749] hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
<7>[   30.308759] ehci_hcd 0000:00:03.3: port 1 low speed --> companion
<6>[   30.308993] ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 5
<7>[   30.325399] ohci_hcd 0000:00:03.2: created debug files
<6>[   30.325409] ohci_hcd 0000:00:03.2: irq 23, io mem 0xe2023000
<7>[   30.363488] ehci_hcd 0000:00:03.3: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
<7>[   30.363514] ehci_hcd 0000:00:03.3: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
<7>[   30.363522] hub 3-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
<7>[   30.394700] ohci_hcd 0000:00:03.2: enabling initreset quirk
<7>[   30.396699] ohci_hcd 0000:00:03.2: OHCI controller state
<7>[   30.396703] ohci_hcd 0000:00:03.2: OHCI 1.0, NO legacy support registers
<7>[   30.396708] ohci_hcd 0000:00:03.2: control 0x083 HCFS=operational CBSR=3
<7>[   30.396711] ohci_hcd 0000:00:03.2: cmdstatus 0x00000 SOC=0
<7>[   30.396714] ohci_hcd 0000:00:03.2: intrstatus 0x00000004 SF
<7>[   30.396718] ohci_hcd 0000:00:03.2: intrenable 0x8000004a MIE RHSC RD WDH
<7>[   30.396724] ohci_hcd 0000:00:03.2: hcca frame #0003
<7>[   30.396728] ohci_hcd 0000:00:03.2: roothub.a 01001202 POTPGT=1 NOCP NPS NDP=2(2)
<7>[   30.396732] ohci_hcd 0000:00:03.2: roothub.b 00000000 PPCM=0000 DR=0000
<7>[   30.396736] ohci_hcd 0000:00:03.2: roothub.status 00008000 DRWE
<7>[   30.396740] ohci_hcd 0000:00:03.2: roothub.portstatus [0] 0x00000100 PPS
<7>[   30.396744] ohci_hcd 0000:00:03.2: roothub.portstatus [1] 0x00000100 PPS
<7>[   30.396761] usb usb5: default language 0x0409
<7>[   30.396769] usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   30.396772] usb usb5: Product: OHCI Host Controller
<6>[   30.413078] usb usb5: Manufacturer: Linux 2.6.23-rc6-speedy ohci_hcd
<6>[   30.429490] usb usb5: SerialNumber: 0000:00:03.2
<7>[   30.445857] usb usb5: uevent
<7>[   30.446071] usb usb5: usb_probe_device
<6>[   30.446244] usb usb5: configuration #1 chosen from 1 choice
<7>[   30.462738] usb usb5: adding 5-0:1.0 (config #1, interface 0)
<7>[   30.462755] usb 5-0:1.0: uevent
<7>[   30.462758] usb 5-0:1.0: uevent
<7>[   30.462930] hub 5-0:1.0: usb_probe_interface
<7>[   30.462933] hub 5-0:1.0: usb_probe_interface - got id
<6>[   30.462935] hub 5-0:1.0: USB hub found
<6>[   30.479219] hub 5-0:1.0: 2 ports detected
<7>[   30.495301] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
<7>[   30.495311] hub 5-0:1.0: standalone hub
<7>[   30.495313] hub 5-0:1.0: no power switching (usb 1.0)
<7>[   30.495315] hub 5-0:1.0: no over-current protection
<7>[   30.495317] hub 5-0:1.0: power on to power good time: 2ms
<7>[   30.495322] hub 5-0:1.0: local power source is good
<7>[   30.495324] hub 5-0:1.0: trying to enable port power on non-switchable hub
<7>[   30.550622] ehci_hcd 0000:00:03.3: port 2 full speed --> companion
<7>[   30.550627] ehci_hcd 0000:00:03.3: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
<7>[   30.550653] hub 3-0:1.0: port 2 not reset yet, waiting 50ms
<6>[   30.598987] ACPI: PCI Interrupt 0000:00:07.1[B] -> GSI 19 (level, low) -> IRQ 18
<6>[   30.615394] uhci_hcd 0000:00:07.1: UHCI Host Controller
<6>[   30.631777] uhci_hcd 0000:00:07.1: new USB bus registered, assigned bus number 6
<7>[   30.648454] ehci_hcd 0000:00:03.3: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
<7>[   30.648479] hub 2-2:1.0: state 7 ports 2 chg 0000 evt 0002
<6>[   30.648492] uhci_hcd 0000:00:07.1: detected 2 ports
<7>[   30.665943] uhci_hcd 0000:00:07.1: uhci_check_and_reset_hc: cmd = 0x0000
<7>[   30.665946] uhci_hcd 0000:00:07.1: Performing full reset
<6>[   30.665968] uhci_hcd 0000:00:07.1: irq 18, io base 0x0000e400
<7>[   30.683350] hub 2-2:1.0: port 1, status 0101, change 0001, 12 Mb/s
<7>[   30.683402] usb usb6: default language 0x0409
<7>[   30.683410] usb usb6: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   30.683412] usb usb6: Product: UHCI Host Controller
<6>[   30.700809] usb usb6: Manufacturer: Linux 2.6.23-rc6-speedy uhci_hcd
<6>[   30.718362] usb usb6: SerialNumber: 0000:00:07.1
<7>[   30.734751] usb usb6: uevent
<7>[   30.734946] usb usb6: usb_probe_device
<6>[   30.735119] usb usb6: configuration #1 chosen from 1 choice
<7>[   30.752644] usb usb6: adding 6-0:1.0 (config #1, interface 0)
<7>[   30.752664] usb 6-0:1.0: uevent
<7>[   30.752667] usb 6-0:1.0: uevent
<7>[   30.752834] hub 6-0:1.0: usb_probe_interface
<7>[   30.752837] hub 6-0:1.0: usb_probe_interface - got id
<6>[   30.752840] hub 6-0:1.0: USB hub found
<6>[   30.770263] hub 6-0:1.0: 2 ports detected
<7>[   30.786439] hub 6-0:1.0: standalone hub
<7>[   30.786442] hub 6-0:1.0: no power switching (usb 1.0)
<7>[   30.786444] hub 6-0:1.0: individual port over-current protection
<7>[   30.786446] hub 6-0:1.0: power on to power good time: 2ms
<7>[   30.786450] hub 6-0:1.0: local power source is good
<7>[   30.786453] hub 6-0:1.0: trying to enable port power on non-switchable hub
<7>[   30.851623] hub 2-2:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<7>[   30.867617] hub 2-2:1.0: port 1 not reset yet, waiting 10ms
<6>[   30.887700] ACPI: PCI Interrupt 0000:00:07.2[C] -> GSI 16 (level, low) -> IRQ 16
<6>[   30.905195] ehci_hcd 0000:00:07.2: EHCI Host Controller
<6>[   30.921451] ehci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 7
<7>[   30.937827] ehci_hcd 0000:00:07.2: reset hcs_params 0x2204 dbg=0 cc=2 pcc=2 ordered !ppc ports=4
<7>[   30.937832] ehci_hcd 0000:00:07.2: reset hcc_params 6872 thresh 7 uframes 256/512/1024
<7>[   30.937878] ehci_hcd 0000:00:07.2: MWI active
<7>[   30.937881] ehci_hcd 0000:00:07.2: supports USB remote wakeup
<6>[   30.937891] ehci_hcd 0000:00:07.2: irq 16, io mem 0xe2026000
<7>[   30.954089] ehci_hcd 0000:00:07.2: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[   30.954095] ehci_hcd 0000:00:07.2: init command 010009 (park)=0 ithresh=1 period=256 RUN
<6>[   30.954099] ehci_hcd 0000:00:07.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
<7>[   30.971361] usb 2-2: uhci_result_common: failed with status 440000
<6>[   30.971380] usb 2-2.1: new full speed USB device using uhci_hcd and address 3
<7>[   30.988908] usb usb7: default language 0x0409
<7>[   30.988916] usb usb7: new device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   30.988918] usb usb7: Product: EHCI Host Controller
<7>[   31.005179] usb 2-2.1: uhci_result_common: failed with status 440000
<6>[   31.005196] usb usb7: Manufacturer: Linux 2.6.23-rc6-speedy ehci_hcd
<7>[   31.021504] usb 2-2.1: uhci_result_common: failed with status 440000
<6>[   31.021516] usb usb7: SerialNumber: 0000:00:07.2
<7>[   31.037752] usb 2-2.1: uhci_result_common: failed with status 440000
<7>[   31.037790] usb usb7: uevent
<7>[   31.037997] usb usb7: usb_probe_device
<6>[   31.038188] usb usb7: configuration #1 chosen from 1 choice
<7>[   31.055498] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.055525] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.073016] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.073029] usb usb7: adding 7-0:1.0 (config #1, interface 0)
<7>[   31.073046] usb 7-0:1.0: uevent
<7>[   31.073049] usb 7-0:1.0: uevent
<7>[   31.073229] hub 7-0:1.0: usb_probe_interface
<7>[   31.073232] hub 7-0:1.0: usb_probe_interface - got id
<6>[   31.073234] hub 7-0:1.0: USB hub found
<7>[   31.090526] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.090543] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.107960] hub 2-2:1.0: port 1 not enabled, trying reset again...
<6>[   31.107983] hub 7-0:1.0: 4 ports detected
<7>[   31.124978] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.124989] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.142136] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.142142] hub 7-0:1.0: standalone hub
<7>[   31.142144] hub 7-0:1.0: no power switching (usb 1.0)
<7>[   31.142146] hub 7-0:1.0: individual port over-current protection
<7>[   31.142148] hub 7-0:1.0: Single TT
<7>[   31.142150] hub 7-0:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   31.142152] hub 7-0:1.0: power on to power good time: 20ms
<7>[   31.142156] hub 7-0:1.0: local power source is good
<7>[   31.142159] hub 7-0:1.0: trying to enable port power on non-switchable hub
<7>[   31.142522] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.142533] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.159509] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.161515] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.161525] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.178576] hub 2-2:1.0: port 1 not enabled, trying reset again...
<3>[   31.178579] hub 2-2:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
<7>[   31.195505] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.195515] hub 2-2:1.0: cannot disable port 1 (err = -71)
<7>[   31.212499] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.212509] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.228606] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.229493] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.229503] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.245406] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.246494] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.246518] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.262262] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.262483] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.262493] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.278094] usb 2-2: uhci_result_common: failed with status 440000
<7>[   31.278098] hub 2-2:1.0: transfer --> -84
<7>[   31.278106] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.278482] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.279269] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.294804] hub 2-2:1.0: port 1 not enabled, trying reset again...
<3>[   31.294807] hub 2-2:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
<7>[   31.350464] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.355200] hub 2-2:1.0: cannot disable port 1 (err = -71)
<7>[   31.379454] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.379480] hub 2-2:1.0: cannot reset port 1 (err = -71)
<3>[   31.397903] saa7134[0]/dvb: frontend initialization failed
<7>[   31.435173] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.436436] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.436833] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.459142] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.460426] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.463160] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.495128] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.496415] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.496435] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.519120] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.520409] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.521857] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.548720] hub 2-2:1.0: port 1 not enabled, trying reset again...
<3>[   31.548725] hub 2-2:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
<7>[   31.572391] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.572955] hub 2-2:1.0: cannot disable port 1 (err = -71)
<7>[   31.603380] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.604766] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.631183] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.632373] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.632936] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.651099] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.652361] usb 2-2: uhci_result_common: failed with status 440000
<7>[   31.653366] usb 2-2: uhci_result_common: failed with status 440000
<7>[   31.653375] hub 2-2:1.0: transfer --> -84
<3>[   31.654778] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.671923] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.673361] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.673680] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.688376] ohci_hcd 0000:00:03.2: auto-stop root hub
<7>[   31.688392] hub 2-2:1.0: port 1 not enabled, trying reset again...
<7>[   31.689348] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.691103] hub 2-2:1.0: cannot reset port 1 (err = -71)
<7>[   31.719453] hub 2-2:1.0: port 1 not enabled, trying reset again...
<3>[   31.719458] hub 2-2:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
<7>[   31.752332] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.753934] hub 2-2:1.0: cannot disable port 1 (err = -71)
<7>[   31.776327] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.779045] hub 2-2:1.0: cannot disable port 1 (err = -71)
<7>[   31.800317] usb 2-2: uhci_result_common: failed with status 440000
<3>[   31.803026] hub 2-2:1.0: hub_port_status failed (err = -71)
<7>[   31.843028] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   31.843041] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
<7>[   31.843050] hub 4-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
<7>[   31.975032] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<7>[   32.037239] usb 2-2: uhci_result_common: failed with status 440000
<7>[   32.037249] hub 2-2:1.0: transfer --> -84
<7>[   32.046947] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
<6>[   32.103008] usb 4-1: new full speed USB device using ohci_hcd and address 2
<7>[   32.186952] ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
<6>[   32.199585] Adding 27189972k swap on /dev/hdb11.  Priority:-1 extents:1 across:27189972k
<7>[   32.262915] usb 4-1: ep0 maxpacket = 8
<7>[   32.273488] usb 4-1: default language 0x0409
<7>[   32.282483] usb 4-1: new device strings: Mfr=1, Product=2, SerialNumber=3
<6>[   32.282486] usb 4-1: Product: Medion Flash XL V3.0C
<6>[   32.296567] usb 4-1: Manufacturer: MEDION
<6>[   32.310483] usb 4-1: SerialNumber: 2003-02
<7>[   32.324355] usb 4-1: uevent
<7>[   32.324378] usb 4-1: usb_probe_device
<6>[   32.324433] usb 4-1: configuration #1 chosen from 1 choice
<7>[   32.342471] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
<7>[   32.342509] usb 4-1:1.0: uevent
<7>[   32.342514] usb 4-1:1.0: uevent
<7>[   32.345578] hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0004
<7>[   32.345587] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   32.345593] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00010301 CSC LSDA PPS CCS
<7>[   32.345598] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
<7>[   32.421115] usb 2-2: uhci_result_common: failed with status 440000
<7>[   32.421126] hub 2-2:1.0: transfer --> -84
<7>[   32.470855] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
<4>[   32.525197] fuse init (API version 7.8)
<7>[   32.550802] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<5>[   32.586605] SCSI subsystem initialized
<6>[   32.606910] usb 1-1: new low speed USB device using ohci_hcd and address 4
<6>[   32.643288] Initializing USB Mass Storage driver...
<7>[   32.694774] ohci_hcd 0000:00:03.0: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
<7>[   32.778183] usb 1-1: skipped 1 descriptor after interface
<7>[   32.781176] usb 1-1: default language 0x0409
<7>[   32.784178] usb 1-1: new device strings: Mfr=0, Product=2, SerialNumber=0
<6>[   32.784181] usb 1-1: Product: USB Optical Mouse
<7>[   32.798182] usb 1-1: uevent
<7>[   32.798700] usb 1-1: usb_probe_device
<6>[   32.798948] usb 1-1: configuration #1 chosen from 1 choice
<7>[   32.812948] usb 2-2: uhci_result_common: failed with status 440000
<7>[   32.812955] hub 2-2:1.0: transfer --> -84
<7>[   32.814729] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
<7>[   32.814767] usb 1-1:1.0: uevent
<7>[   32.814771] usb 1-1:1.0: uevent
<7>[   32.815332] usb-storage 4-1:1.0: usb_probe_interface
<7>[   32.815339] usb-storage 4-1:1.0: usb_probe_interface - got id
<7>[   32.815395] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>[   32.815408] hub 2-2:1.0: state 7 ports 2 chg 0000 evt 0002
<6>[   32.815469] scsi0 : SCSI emulation for USB Mass Storage devices
<7>[   32.830379] usb 2-2: uhci_result_common: failed with status 440000
<3>[   32.830621] hub 2-2:1.0: hub_port_status failed (err = -71)
<7>[   32.845721] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0006
<7>[   32.845729] uhci_hcd 0000:00:07.1: port 1 portsc 008a,00
<7>[   32.845740] hub 6-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
<6>[   32.845777] usbcore: registered new interface driver usb-storage
<6>[   32.859878] USB Mass Storage support registered.
<7>[   32.874741] usb-storage: device found at 2
<7>[   32.874745] usb-storage: waiting for device to settle before scanning
<7>[   32.970663] hub 6-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
<7>[   32.970672] uhci_hcd 0000:00:07.1: port 2 portsc 008a,00
<7>[   32.970681] hub 6-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
<7>[   33.098622] hub 6-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
<7>[   33.098630] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
<7>[   33.098636] uhci_hcd 0000:00:07.0: port 2 portsc 009a,00
<7>[   33.098644] hub 2-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
<6>[   33.098648] usb 2-2: USB disconnect, address 2
<7>[   33.112597] usb 2-2: unregistering device
<7>[   33.112600] usb 2-2: usb_disable_device nuking all URBs
<7>[   33.112610] uhci_hcd 0000:00:07.0: shutdown urb f7d8f2c0 pipe 40408280 ep1in-intr
<7>[   33.113891] uhci_hcd 0000:00:07.0: release dev 2 ep81-INT, period 128, phase 0, 12 us
<7>[   33.113901] usb 2-2: unregistering interface 2-2:1.0
<7>[   33.114435] usb_endpoint usbdev2.2_ep81: ep_device_release called for usbdev2.2_ep81
<7>[   33.114496] usb 2-2:1.0: uevent
<7>[   33.114500] usb 2-2:1.0: uevent
<7>[   33.114988] usb_endpoint usbdev2.2_ep00: ep_device_release called for usbdev2.2_ep00
<7>[   33.115029] usb 2-2: uevent
<7>[   33.241625] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
<7>[   33.241633] hub 7-0:1.0: state 7 ports 4 chg 0000 evt 0000
<7>[   33.241645] ehci_hcd 0000:00:07.2: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
<7>[   33.241651] hub 7-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
<7>[   33.369575] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
<7>[   33.426755] ehci_hcd 0000:00:07.2: port 2 high speed
<7>[   33.426762] ehci_hcd 0000:00:07.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
<6>[   33.482503] usb 7-2: new high speed USB device using ehci_hcd and address 2
<7>[   33.550733] ehci_hcd 0000:00:07.2: port 2 high speed
<7>[   33.550739] ehci_hcd 0000:00:07.2: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
<6>[   33.617758] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
<7>[   33.633103] usb 7-2: new device strings: Mfr=0, Product=0, SerialNumber=0
<7>[   33.633142] usb 7-2: uevent
<7>[   33.633614] usb 7-2: usb_probe_device
<6>[   33.633852] usb 7-2: configuration #1 chosen from 1 choice
<7>[   33.649223] usb 7-2: adding 7-2:1.0 (config #1, interface 0)
<7>[   33.649252] usb 7-2:1.0: uevent
<7>[   33.649256] usb 7-2:1.0: uevent
<7>[   33.649461] hub 7-2:1.0: usb_probe_interface
<7>[   33.649465] hub 7-2:1.0: usb_probe_interface - got id
<6>[   33.649467] hub 7-2:1.0: USB hub found
<6>[   33.664718] hub 7-2:1.0: 2 ports detected
<7>[   33.679720] hub 7-2:1.0: compound device; port removable status: FR
<7>[   33.679723] hub 7-2:1.0: ganged power switching
<7>[   33.679725] hub 7-2:1.0: global over-current protection
<7>[   33.679727] hub 7-2:1.0: Single TT
<7>[   33.679729] hub 7-2:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   33.679731] hub 7-2:1.0: power on to power good time: 100ms
<7>[   33.680035] hub 7-2:1.0: local power source is good
<7>[   33.680038] hub 7-2:1.0: no over-current condition exists
<7>[   33.680040] hub 7-2:1.0: enabling power on all ports
<7>[   33.781438] usb 7-2: link qh256-0001/c5f29100 start 255 [1/0 us]
<7>[   33.782453] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   33.782463] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   33.782468] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
<7>[   33.782472] hub 7-2:1.0: state 7 ports 2 chg 0000 evt 0000
<7>[   33.782694] hub 7-2:1.0: port 1, status 0101, change 0001, 12 Mb/s
<7>[   33.909422] hub 7-2:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<6>[   33.981410] usb 7-2.1: new high speed USB device using ehci_hcd and address 3
<7>[   34.009402] hub 7-2:1.0: port 1 not reset yet, waiting 10ms
<7>[   34.101637] usb 7-2.1: new device strings: Mfr=0, Product=0, SerialNumber=0
<7>[   34.101674] usb 7-2.1: uevent
<7>[   34.102148] usb 7-2.1: usb_probe_device
<6>[   34.102404] usb 7-2.1: configuration #1 chosen from 1 choice
<7>[   34.117886] usb 7-2.1: adding 7-2.1:1.0 (config #1, interface 0)
<7>[   34.117908] usb 7-2.1:1.0: uevent
<7>[   34.117912] usb 7-2.1:1.0: uevent
<7>[   34.118099] hub 7-2.1:1.0: usb_probe_interface
<7>[   34.118103] hub 7-2.1:1.0: usb_probe_interface - got id
<6>[   34.118105] hub 7-2.1:1.0: USB hub found
<6>[   34.134328] hub 7-2.1:1.0: 4 ports detected
<7>[   34.149464] hub 7-2.1:1.0: compound device; port removable status: FRRR
<7>[   34.149466] hub 7-2.1:1.0: ganged power switching
<7>[   34.149468] hub 7-2.1:1.0: global over-current protection
<7>[   34.149923] hub 7-2.1:1.0: TT per port
<7>[   34.149928] hub 7-2.1:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[   34.149930] hub 7-2.1:1.0: power on to power good time: 100ms
<7>[   34.150124] hub 7-2.1:1.0: local power source is good
<7>[   34.150127] hub 7-2.1:1.0: no over-current condition exists
<7>[   34.150130] hub 7-2.1:1.0: enabling power on all ports
<7>[   34.253267] usb 7-2.1: link qh256-0001/c5f29200 start 255 [1/0 us]
<7>[   34.253871] hub 7-2:1.0: state 7 ports 2 chg 0000 evt 0002
<7>[   34.253980] hub 7-2.1:1.0: state 7 ports 4 chg 0000 evt 0000
<7>[   34.254483] hub 7-2.1:1.0: port 1, status 0101, change 0001, 12 Mb/s
<7>[   34.381333] hub 7-2.1:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
<7>[   34.414220] usb usb2: suspend_rh (auto-stop)
<7>[   34.414239] usb usb6: suspend_rh (auto-stop)
<6>[   34.453319] usb 7-2.1.1: new high speed USB device using ehci_hcd and address 4
<7>[   34.489310] hub 7-2.1:1.0: port 1 not reset yet, waiting 10ms
<7>[   34.601417] usb 7-2.1.1: skipped 1 descriptor after endpoint
<7>[   34.608537] usb 7-2.1.1: default language 0x0409
<7>[   34.647905] usb 7-2.1.1: new device strings: Mfr=1, Product=2, SerialNumber=3
<6>[   34.647908] usb 7-2.1.1: Product: Flash Card Reader
<6>[   34.663016] usb 7-2.1.1: Manufacturer: Generic
<6>[   34.677774] usb 7-2.1.1: SerialNumber: 26020128B005
<7>[   34.692456] usb 7-2.1.1: uevent
<7>[   34.694184] usb 7-2.1.1: usb_probe_device
<6>[   34.694499] usb 7-2.1.1: configuration #1 chosen from 1 choice
<7>[   34.710146] usb 7-2.1.1: adding 7-2.1.1:1.0 (config #1, interface 0)
<7>[   34.710187] usb 7-2.1.1:1.0: uevent
<7>[   34.710191] usb 7-2.1.1:1.0: uevent
<7>[   34.710452] usb-storage 7-2.1.1:1.0: usb_probe_interface
<7>[   34.710458] usb-storage 7-2.1.1:1.0: usb_probe_interface - got id
<6>[   34.710520] scsi1 : SCSI emulation for USB Mass Storage devices
<7>[   34.725720] usb-storage: device found at 4
<7>[   34.725723] usb-storage: waiting for device to settle before scanning
<7>[   34.726521] hub 7-2.1:1.0: state 7 ports 4 chg 0000 evt 0002
<6>[   34.735981] usbcore: registered new interface driver hiddev
<7>[   34.759779] usbhid 1-1:1.0: usb_probe_interface
<7>[   34.759784] usbhid 1-1:1.0: usb_probe_interface - got id
<6>[   34.775517] input: USB Optical Mouse as /class/input/input3
<6>[   34.794539] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:03.0-1
<6>[   34.809588] usbcore: registered new interface driver usbhid
<6>[   34.838919] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
<5>[   37.930697] scsi 0:0:0:0: Direct-Access     Medion   Flash XL      CF 3.0C PQ: 0 ANSI: 0 CCS
<5>[   37.937694] scsi 0:0:0:1: Direct-Access     Medion   Flash XL      MS 3.0C PQ: 0 ANSI: 0 CCS
<5>[   37.945183] scsi 0:0:0:2: Direct-Access     Medion   Flash XL  MMC/SD 3.0C PQ: 0 ANSI: 0 CCS
<5>[   37.953175] scsi 0:0:0:3: Direct-Access     Medion   Flash XL      SM 3.0C PQ: 0 ANSI: 0 CCS
<7>[   37.962926] usb-storage: device scan complete
<5>[   37.981197] sd 0:0:0:0: [sda] Attached SCSI removable disk
<5>[   37.992234] sd 0:0:0:1: [sdb] Attached SCSI removable disk
<5>[   38.003224] sd 0:0:0:2: [sdc] Attached SCSI removable disk
<5>[   38.013694] sd 0:0:0:3: [sdd] Attached SCSI removable disk
<5>[   38.048981] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>[   38.050118] sd 0:0:0:1: Attached scsi generic sg1 type 0
<5>[   38.051218] sd 0:0:0:2: Attached scsi generic sg2 type 0
<5>[   38.052303] sd 0:0:0:3: Attached scsi generic sg3 type 0
<6>[   38.409965] loop: module loaded
<6>[   38.486212] kjournald starting.  Commit interval 5 seconds
<6>[   38.501848] EXT3 FS on hdb8, internal journal
<6>[   38.517372] EXT3-fs: mounted filesystem with ordered data mode.
<6>[   38.560004] kjournald starting.  Commit interval 5 seconds
<6>[   38.575769] EXT3 FS on hdb9, internal journal
<6>[   38.591328] EXT3-fs: mounted filesystem with ordered data mode.
<6>[   38.636545] kjournald starting.  Commit interval 5 seconds
<6>[   38.652348] EXT3 FS on hdb10, internal journal
<6>[   38.667898] EXT3-fs: mounted filesystem with ordered data mode.
<7>[   38.737498] ISO 9660 Extensions: Microsoft Joliet Level 3
<7>[   38.784723] ISO 9660 Extensions: RRIP_1991A
<6>[   38.823999] SGI XFS with ACLs, security attributes, realtime, no debug enabled
<6>[   38.840268] SGI XFS Quota Management subsystem
<5>[   38.940168] XFS mounting filesystem hdb12
<7>[   39.051261] Ending clean XFS mount for filesystem: hdb12
<5>[   39.732844] scsi 1:0:0:0: Direct-Access     Generic  Flash HS-CF      4.44 PQ: 0 ANSI: 0
<5>[   39.753803] sd 1:0:0:0: [sde] Attached SCSI removable disk
<5>[   39.770498] sd 1:0:0:0: Attached scsi generic sg4 type 0
<5>[   39.790701] scsi 1:0:0:1: Direct-Access     Generic  Flash HS-COMBO   4.44 PQ: 0 ANSI: 0
<5>[   39.857314] sd 1:0:0:1: [sdf] Attached SCSI removable disk
<5>[   39.874312] sd 1:0:0:1: Attached scsi generic sg5 type 0
<7>[   39.892592] usb-storage: device scan complete
Kernel logging (ksyslog) stopped.
Kernel log daemon terminating.

Boot logging started on /dev/tty1(/dev/console) at Sat Sep 15 18:50:53 2007



