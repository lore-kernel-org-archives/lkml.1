Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbXBJUk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbXBJUk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 15:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBJUk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 15:40:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:48825 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751869AbXBJUk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 15:40:56 -0500
X-Provags-ID: V01U2FsdGVkX1/xrElELbjxzKVLFohtU1/FzzjRwsbtVHn4BF8hzx
	ucEQ==
From: Florian Schmidt <mista.tapas@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 "IRQ handler type mismatch for IRQ 4"
Date: Sat, 10 Feb 2007 21:40:55 +0100
User-Agent: KMail/1.9.6
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(MZhm
	{/l.>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702102140.55155.mista.tapas@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

i upgraded my system from ubuntu edgy to feisty and a new kernel came with it 
(2.6.15 vs. 2.6.20). Sadly my wireless card (pcmcia) has stopped working 
under this system. Seeing a backttrace in the dmesg output made me believe 
it's a kernel problem. I built a vanilla kernel to see if maybe ubuntu mods 
are the issue, but no dice. I tried different combinations of boot parameters 
(pci=routeirq, etc..)

It seems this message comes about when hald is started, but i don't know for 
sure.

Anyways, here's my dmesg output (the relevant message is near the end, but i 
thought that maybe i should include it all).

I'm grateful for all pointers, etc.. If you need more info, please let me 
know.

Thanks,
Flo

[    0.000000] Linux version 2.6.20vanilla (tapas@banana) (gcc version 4.1.2 
20070129 (prerelease) (Ubuntu 4.1.1-31ubuntu2)) #1 Sat Feb 10 19:50:29 CET 
2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 000000000009f800 
end: 000000000009f800 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f800 size: 0000000000000800 
end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000e0000 size: 0000000000020000 
end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 0000000017ef0000 
end: 0000000017ff0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 0000000017ff0000 size: 000000000000ec00 
end: 0000000017ffec00 type: 3
[    0.000000] copy_e820_map() start: 0000000017ffec00 size: 0000000000001400 
end: 0000000018000000 type: 4
[    0.000000] copy_e820_map() start: 00000000fff80000 size: 0000000000080000 
end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000017ff0000 (usable)
[    0.000000]  BIOS-e820: 0000000017ff0000 - 0000000017ffec00 (ACPI data)
[    0.000000]  BIOS-e820: 0000000017ffec00 - 0000000018000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 383MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 98288) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->    98288
[    0.000000]   HighMem     98288 ->    98288
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->    98288
[    0.000000] On node 0 totalpages: 98288
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 735 pages used for memmap
[    0.000000]   Normal zone: 93457 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP (v000 PTLTD                                 ) @ 
0x000f7180
[    0.000000] ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 
0x17ff4ea7
[    0.000000] ACPI: FADT (v001 IBM    TP-T21   0x06040000  0x00000000) @ 
0x17ffeb65
[    0.000000] ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 
0x17ffebd9
[    0.000000] ACPI: DSDT (v001 IBM    TP-T21   0x06040000 MSFT 0x0100000c) @ 
0x00000000
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 
18000000:e7f80000)
[    0.000000] Detected 796.579 MHz processor.
[   14.103182] Built 1 zonelists.  Total pages: 97521
[   14.103188] Kernel command line: root=/dev/hda1 irqpoll
[   14.103232] Misrouted IRQ fixup and polling support enabled
[   14.103237] This may significantly impact system performance
[   14.103672] Local APIC disabled by BIOS -- you can enable it with "lapic"
[   14.103694] mapped APIC to ffffd000 (01302000)
[   14.103703] Enabling fast FPU save and restore... done.
[   14.103710] Enabling unmasked SIMD FPU exception support... done.
[   14.103732] Initializing CPU#0
[   14.103827] PID hash table entries: 2048 (order: 11, 8192 bytes)
[   14.105743] Console: colour VGA+ 80x25
[   14.108609] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[   14.110053] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[   14.148765] Memory: 347012k/393152k available (1893k kernel code, 45576k 
reserved, 843k data, 316k init, 0k highmem)
[   14.148857] virtual kernel memory layout:
[   14.148860]     fixmap  : 0xfffa9000 - 0xfffff000   ( 344 kB)
[   14.148864]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   14.148868]     vmalloc : 0xd8800000 - 0xff7fe000   ( 623 MB)
[   14.148872]     lowmem  : 0xc0000000 - 0xd7ff0000   ( 383 MB)
[   14.148875]       .init : 0xc03b0000 - 0xc03ff000   ( 316 kB)
[   14.148879]       .data : 0xc02d9633 - 0xc03ac434   ( 843 kB)
[   14.148883]       .text : 0xc0100000 - 0xc02d9633   (1893 kB)
[   14.149248] Checking if this processor honours the WP bit even in 
supervisor mode... Ok.
[   14.227795] Calibrating delay using timer specific routine.. 1596.39 
BogoMIPS (lpj=3192786)
[   14.227964] Security Framework v1.0.0 initialized
[   14.228027] SELinux:  Disabled at boot.
[   14.228102] Mount-cache hash table entries: 512
[   14.228376] CPU: After generic identify, caps: 0383f9ff 00000000 00000000 
00000000 00000000 00000000 00000000
[   14.228400] CPU: L1 I cache: 16K, L1 D cache: 16K
[   14.228484] CPU: L2 cache: 256K
[   14.228534] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 
00000000 00000000 00000000
[   14.228576] CPU: Intel Pentium III (Coppermine) stepping 0a
[   14.228728] Checking 'hlt' instruction... OK.
[   14.244426] ACPI: Core revision 20060707
[   14.254673] ACPI: setting ELCR to 0200 (from 0628)
[   14.265970] Booting paravirtualized kernel on bare hardware
[   14.266172] NET: Registered protocol family 16
[   14.266448] EISA bus registered
[   14.266502] ACPI: bus type pci registered
[   14.267043] PCI: PCI BIOS revision 2.10 entry at 0xfd94f, last bus=7
[   14.267094] PCI: Using configuration type 1
[   14.267141] Setting up standard PCI resources
[   14.560012] ACPI: Interpreter enabled
[   14.560077] ACPI: Using PIC for interrupt routing
[   14.561897] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11)
[   14.563589] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11)
[   14.565326] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11)
[   14.567026] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 9 10 11)
[   14.568247] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   14.568304] PCI: Probing PCI hardware (bus 00)
[   14.569584] ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
[   14.569901] PCI: Firmware left 0000:00:03.0 e100 interrupts enabled, 
disabling
[   14.570280] PCI quirk: region 1000-103f claimed by PIIX4 ACPI
[   14.570332] PCI quirk: region 1040-104f claimed by PIIX4 SMB
[   14.570388] PIIX4 devres C PIO at 15e8-15ef
[   14.570438] PIIX4 devres I PIO at 03f0-03f7
[   14.570487] PIIX4 devres J PIO at 002e-002f
[   14.570672] Boot video device is 0000:01:00.0
[   14.570888] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   14.793438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[   14.795049] ACPI: Power Resource [PSER] (off)
[   14.795422] ACPI: Power Resource [PSIO] (on)
[   14.800834] Linux Plug and Play Support v0.97 (c) Adam Belay
[   14.800918] pnp: PnP ACPI init
[   14.912657] pnp: PnP ACPI: found 15 devices
[   14.912723] PnPBIOS: Disabled by ACPI PNP
[   14.912903] PCI: Using ACPI for IRQ routing
[   14.912955] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   14.920272] pnp: 00:02: ioport range 0x1000-0x103f could not be reserved
[   14.920331] pnp: 00:02: ioport range 0x1040-0x104f has been reserved
[   14.920383] pnp: 00:02: ioport range 0xfe00-0xfe0f has been reserved
[   14.920451] pnp: 00:09: ioport range 0x15e0-0x15ef has been reserved
[   14.921099] PCI: Bridge: 0000:00:01.0
[   14.921148]   IO window: disabled.
[   14.921200]   MEM window: f0000000-f7ffffff
[   14.921251]   PREFETCH window: 30000000-300fffff
[   14.921303] PCI: Bus 2, cardbus bridge: 0000:00:02.0
[   14.921353]   IO window: 00001400-000014ff
[   14.921403]   IO window: 00001c00-00001cff
[   14.921454]   PREFETCH window: 20000000-23ffffff
[   14.921505]   MEM window: 24000000-27ffffff
[   14.921556] PCI: Bus 6, cardbus bridge: 0000:00:02.1
[   14.921605]   IO window: 00002000-000020ff
[   14.921656]   IO window: 00002400-000024ff
[   14.921707]   PREFETCH window: 28000000-2bffffff
[   14.921759]   MEM window: 2c000000-2fffffff
[   14.923001] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 9
[   14.923055] PCI: setting IRQ 9 as level-triggered
[   14.923061] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 9 
(level, low) -> IRQ 9
[   14.924318] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
[   14.924372] PCI: setting IRQ 5 as level-triggered
[   14.924379] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNKB] -> GSI 5 
(level, low) -> IRQ 5
[   14.924561] NET: Registered protocol family 2
[   14.963644] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[   14.963890] TCP established hash table entries: 16384 (order: 4, 65536 
bytes)
[   14.964118] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
[   14.964258] TCP: Hash tables configured (established 16384 bind 8192)
[   14.964311] TCP reno registered
[   14.975830] checking if image is initramfs... it is
[   23.353669] Freeing initrd memory: 38638k freed
[   23.354215] Simple Boot Flag at 0x35 set to 0x1
[   23.354668] audit: initializing netlink socket (disabled)
[   23.354750] audit(1171139280.428:1): initialized
[   23.355069] VFS: Disk quotas dquot_6.5.1
[   23.355164] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   23.355328] io scheduler noop registered
[   23.355409] io scheduler anticipatory registered
[   23.355488] io scheduler deadline registered
[   23.355587] io scheduler cfq registered (default)
[   23.355715] Limiting direct PCI/PCI transfers.
[   23.356290] isapnp: Scanning for PnP cards...
[   23.709795] isapnp: No Plug & Play device found
[   23.783913] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[   23.787063] pnp: Device 00:0c activated.
[   23.787420] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   23.789234] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[   23.789297] PCI: setting IRQ 10 as level-triggered
[   23.789304] ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKC] -> GSI 10 
(level, low) -> IRQ 10
[   23.791172] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 
blocksize
[   23.791671] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   23.791732] ide: Assuming 33MHz system bus speed for PIO modes; override 
with idebus=xx
[   23.792356] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 
1,12
[   23.809069] serio: i8042 KBD port at 0x60,0x64 irq 1
[   23.809136] serio: i8042 AUX port at 0x60,0x64 irq 12
[   23.809538] mice: PS/2 mouse device common for all mice
[   23.809832] EISA: Probing bus 0 at eisa.0
[   23.809893] Cannot allocate resource for EISA slot 1
[   23.809944] Cannot allocate resource for EISA slot 2
[   23.810013] EISA: Detected 0 cards.
[   23.840265] TCP cubic registered
[   23.840328] NET: Registered protocol family 1
[   23.840386] NET: Registered protocol family 8
[   23.840434] NET: Registered protocol family 20
[   23.840544] Using IPI Shortcut mode
[   23.840721] ACPI: (supports S0 S1 S3 S4 S5)
[   23.842140] Freeing unused kernel memory: 316k freed
[   23.844124] Time: tsc clocksource has been installed.
[   23.846115] input: AT Translated Set 2 keyboard as /class/input/input0
[   24.440441] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   24.440636] ACPI: Processor [CPU] (supports 8 throttling states)
[   24.445177] ACPI: Thermal Zone [THM0] (61 C)
[   25.747707] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
[   25.747770] e100: Copyright(c) 1999-2006 Intel Corporation
[   25.747901] ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKC] -> GSI 10 
(level, low) -> IRQ 10
[   25.834657] e100: eth0: e100_probe: addr 0xe8120000, irq 10, MAC addr 
00:10:A4:84:F7:90
[   25.891206] PIIX4: IDE controller at PCI slot 0000:00:07.1
[   25.891292] PIIX4: chipset revision 1
[   25.891422] PIIX4: not 100% native mode: will probe irqs later
[   25.892932]     ide0: BM-DMA at 0x1850-0x1857, BIOS settings: hda:DMA, 
hdb:pio
[   25.893073]     ide1: BM-DMA at 0x1858-0x185f, BIOS settings: hdc:DMA, 
hdd:pio
[   25.893209] Probing IDE interface ide0...
[   25.950671] usbcore: registered new interface driver usbfs
[   25.950778] usbcore: registered new interface driver hub
[   25.950875] usbcore: registered new device driver usb
[   26.033062] USB Universal Host Controller Interface driver v3.0
[   26.231398] hda: HITACHI_DK23BA-20B, ATA DISK drive
[   12.392000] Time: acpi_pm clocksource has been installed.
[   12.796000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   12.796000] Probing IDE interface ide1...
[   13.532000] hdc: MATSHITADVD-ROM SR-8176, ATAPI CD/DVD-ROM drive
[   13.868000] ide1 at 0x170-0x177,0x376 on irq 15
[   13.904000] SCSI subsystem initialized
[   13.932000] libata version 2.00 loaded.
[   13.948000] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 3
[   13.948000] PCI: setting IRQ 3 as level-triggered
[   13.948000] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 3 
(level, low) -> IRQ 3
[   13.948000] uhci_hcd 0000:00:07.2: UHCI Host Controller
[   13.948000] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus 
number 1
[   13.952000] uhci_hcd 0000:00:07.2: irq 3, io base 0x00001860
[   13.952000] usb usb1: configuration #1 chosen from 1 choice
[   13.952000] hub 1-0:1.0: USB hub found
[   13.952000] hub 1-0:1.0: 2 ports detected
[   14.076000] hda: max request size: 128KiB
[   14.164000] hda: 39070080 sectors (20003 MB) w/2048KiB Cache, 
CHS=41344/15/63, UDMA(33)
[   14.168000] hda: cache flushes not supported
[   14.168000]  hda: hda1 hda2 hda3
[   14.196000] hdc: ATAPI 24X DVD-ROM drive, 256kB Cache, UDMA(33)
[   14.196000] Uniform CD-ROM driver Revision: 3.20
[   14.572000] kjournald starting.  Commit interval 5 seconds
[   14.572000] EXT3-fs: mounted filesystem with ordered data mode.
[   29.176000] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[   31.028000] NET: Registered protocol family 17
[   32.132000] Yenta: CardBus bridge found at 0000:00:02.0 [1014:0130]
[   32.132000] Yenta: Using INTVAL to route CSC interrupts to PCI
[   32.132000] Yenta: Routing CardBus interrupts to PCI
[   32.132000] Yenta TI: socket 0000:00:02.0, mfunc 0x00001000, devctl 0x66
[   32.364000] Yenta: ISA IRQ mask 0x0890, PCI irq 9
[   32.364000] Socket status: 30000010
[   32.364000] Yenta: CardBus bridge found at 0000:00:02.1 [1014:0130]
[   32.364000] Yenta: Using INTVAL to route CSC interrupts to PCI
[   32.364000] Yenta: Routing CardBus interrupts to PCI
[   32.364000] Yenta TI: socket 0000:00:02.1, mfunc 0x00001000, devctl 0x66
[   32.364000] spurious 8259A interrupt: IRQ7.
[   32.596000] Yenta: ISA IRQ mask 0x0890, PCI irq 5
[   32.596000] Socket status: 30000006
[   33.000000] pccard: PCMCIA card inserted into slot 0
[   33.532000] Linux agpgart interface v0.101 (c) Dave Jones
[   33.588000] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   33.644000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   33.772000] input: PC Speaker as /class/input/input1
[   33.828000] Real Time Clock Driver v1.12ac
[   33.856000] piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
[   33.856000] piix4_smbus 0000:00:07.3: IBM system detected; this module may 
corrupt your serial eeprom! Refusing to load module!
[   33.856000] piix4_smbus: probe of 0000:00:07.3 failed with error -1
[   34.116000] agpgart: Detected an Intel 440BX Chipset.
[   34.192000] agpgart: AGP aperture is 64M @ 0xf8000000
[   34.220000] Floppy drive(s): fd0 is 1.44M
[   34.236000] FDC 0 is a National Semiconductor PC87306
[   34.348000] parport: PnPBIOS parport detected.
[   34.348000] parport0: PC-style at 0x3bc, irq 7 [PCSPP,TRISTATE]
[   35.004000] irda_init()
[   35.004000] NET: Registered protocol family 23
[   35.384000] cs: IO port probe 0x100-0x3af: clean.
[   35.384000] cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
[   35.384000] cs: IO port probe 0x820-0x8ff: clean.
[   35.384000] cs: IO port probe 0xc00-0xcf7: clean.
[   35.384000] cs: IO port probe 0xa00-0xaff: clean.
[   35.768000] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   35.812000] input: TPPS/2 IBM TrackPoint as /class/input/input2
[   35.820000] pnp: Unable to assign resources to device 00:0e.
[   35.820000] nsc-ircc: probe of 00:0e failed with error -16
[   35.820000] nsc-ircc, Found chip at base=0x02e
[   35.820000] nsc-ircc, Wrong chip version ff
[   36.056000] cs: IO port probe 0x100-0x3af: clean.
[   36.056000] cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
[   36.056000] cs: IO port probe 0x820-0x8ff: clean.
[   36.056000] cs: IO port probe 0xc00-0xcf7: clean.
[   36.056000] cs: IO port probe 0xa00-0xaff: clean.
[   36.060000] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   36.064000] pcmcia: registering new device pcmcia0.0
[   37.036000] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LNKA] -> GSI 9 
(level, low) -> IRQ 9
[   37.200000] cs46xx: failure waiting for FIFO command to complete
[   37.340000] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, 
Pavel Roskin <proski@gnu.org>, et al)
[   37.364000] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, 
Pavel Roskin <proski@gnu.org>, et al)
[   37.512000] eth1: Hardware identity 8003:0000:0001:0000
[   37.512000] eth1: Station identity  001f:0003:0000:0008
[   37.512000] eth1: Firmware determined as Intersil 0.8.3
[   37.512000] eth1: Ad-hoc demo mode supported
[   37.512000] eth1: IEEE standard IBSS ad-hoc mode supported
[   37.512000] eth1: WEP supported, 104-bit key
[   37.512000] eth1: MAC address 00:04:DB:00:1C:CC
[   37.512000] eth1: Station name "Prism  I"
[   37.512000] eth1: ready
[   37.516000] eth1: orinoco_cs at 0.0, irq 4, io 0x0100-0x013f
[   37.608000] gameport: CS46xx Gameport is pci0000:00:05.0/gameport0, speed 
1807kHz
[   37.712000] ieee80211_crypt: registered algorithm 'NULL'
[   37.916000] hostap_cs: 0.4.4-kernel (Jouni Malinen <jkmaline@cc.hut.fi>)
[   38.476000] fuse init (API version 7.8)
[   38.592000] Adding 491392k swap on /dev/hda3.  Priority:-1 extents:1 
across:491392k
[   38.708000] EXT3 FS on hda1, internal journal
[   39.144000] kjournald starting.  Commit interval 5 seconds
[   39.144000] EXT3-fs warning: maximal mount count reached, running e2fsck is 
recommended
[   39.144000] EXT3 FS on hda2, internal journal
[   39.144000] EXT3-fs: mounted filesystem with ordered data mode.
[   39.932000] eth1: New link status: Connected (0001)
[   41.824000] ACPI: AC Adapter [AC] (on-line)
[   42.088000] ACPI: Battery Slot [BAT0] (battery present)
[   42.188000] input: Power Button (FF) as /class/input/input3
[   42.188000] ACPI: Power Button (FF) [PWRF]
[   42.208000] input: Lid Switch as /class/input/input4
[   42.208000] ACPI: Lid Switch [LID]
[   42.220000] input: Sleep Button (CM) as /class/input/input5
[   42.220000] ACPI: Sleep Button (CM) [SLPB]
[   43.088000] ACPI: ACPI Dock Station Driver 
[   43.208000] Using specific hotkey driver
[   43.364000] ibm_acpi: IBM ThinkPad ACPI Extras v0.13
[   43.364000] ibm_acpi: http://ibm-acpi.sf.net/
[   43.628000] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[   43.696000] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   49.364000] [drm] Initialized drm 1.1.0 20060810
[   49.428000] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 9 
(level, low) -> IRQ 9
[   49.432000] [drm] Initialized savage 2.4.1 20050313 on minor 0
[   49.432000] mtrr: base(0xf2000000) is not aligned on a size(0x5000000) 
boundary
[   50.932000] IBM machine detected. Enabling interrupts during APM calls.
[   50.932000] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   50.932000] apm: overridden by ACPI.
[   53.580000] IRQ handler type mismatch for IRQ 4
[   53.580000] current handler: pcmcia0.0
[   53.580000]  [<c0141a25>] setup_irq+0x135/0x1e0
[   53.580000]  [<c0230930>] serial8250_interrupt+0x0/0xf0
[   53.580000]  [<c0141b73>] request_irq+0xa3/0xc0
[   53.580000]  [<c023086e>] serial8250_startup+0x47e/0x4b0
[   53.580000]  [<c022bf58>] uart_startup+0x48/0x160
[   53.580000]  [<c022cb9f>] uart_open+0xbf/0x460
[   53.580000]  [<c01636a3>] cdev_get+0x23/0x40
[   53.580000]  [<c021b2b7>] tty_open+0x147/0x2d0
[   53.580000]  [<c016373c>] chrdev_open+0x6c/0x120
[   53.580000]  [<c01636d0>] chrdev_open+0x0/0x120
[   53.580000]  [<c015f750>] __dentry_open+0xb0/0x1c0
[   53.580000]  [<c015f915>] nameidata_to_filp+0x35/0x40
[   53.580000]  [<c015f970>] do_filp_open+0x50/0x60
[   53.580000]  [<c015f9ce>] do_sys_open+0x4e/0xf0
[   53.580000]  [<c015faac>] sys_open+0x1c/0x20
[   53.580000]  [<c0102fe0>] syscall_call+0x7/0xb
[   53.580000]  [<c02d0033>] atm_dev_release_vccs+0xb3/0xc0
[   53.580000]  =======================
[   63.620000] Capability LSM initialized
[   69.168000] Non-volatile memory driver v1.2
[   70.060000] input: /usr/sbin/thinkpad-keys as /class/input/input6
[   72.160000] ondemand governor failed to load due to too long transition 
latency
[   75.108000] Bluetooth: Core ver 2.11
[   75.108000] NET: Registered protocol family 31
[   75.108000] Bluetooth: HCI device and connection manager initialized
[   75.108000] Bluetooth: HCI socket layer initialized
[   76.084000] Bluetooth: L2CAP ver 2.8
[   76.084000] Bluetooth: L2CAP socket layer initialized
[   76.136000] Bluetooth: RFCOMM socket layer initialized
[   76.136000] Bluetooth: RFCOMM TTY layer initialized
[   76.136000] Bluetooth: RFCOMM ver 1.8

/proc/interrupts:

           CPU0       
  0:     106512    XT-PIC-XT        timer
  1:        155    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:          0    XT-PIC-XT        uhci_hcd:usb1
  4:          4    XT-PIC-XT        pcmcia0.0
  5:          1    XT-PIC-XT        yenta
  6:          5    XT-PIC-XT        floppy
  7:          3    XT-PIC-XT        parport0
  8:          3    XT-PIC-XT        rtc
  9:       1899    XT-PIC-XT        acpi, yenta, CS46XX
 10:        292    XT-PIC-XT        eth0
 12:       1005    XT-PIC-XT        i8042
 14:       7164    XT-PIC-XT        ide0
 15:       3455    XT-PIC-XT        ide1
NMI:          0 
LOC:          0 
ERR:          1
MIS:          0

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
