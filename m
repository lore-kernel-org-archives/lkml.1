Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYFPDiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYFPDiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 23:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYFPDhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 23:37:52 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63595 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbYFPDht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 23:37:49 -0400
Message-Id: <200806160337.m5G3blQp087139@www262.sakura.ne.jp>
Subject: [2.6.22? VMware?] BUG() at sysfs_follow_link+0x129/0x260
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akataria@vmware.com, dhecht@vmware.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 12:37:47 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got an oops while I was running vmware-install.pl to upgrade
vmware-tools from VMware Workstation 6.0.2 to 6.0.4 on Ubuntu 7.10 on i386.
This may be a bug in vmware-tools kernel module, but I'm not sure.

Regards.
----------
[    0.000000] Linux version 2.6.22-14-generic (buildd@terranova) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Tue Feb 12 07:42:25 UTC 2008 (Ubuntu 2.6.22-14.52-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
[    0.000000]  BIOS-e820: 000000001fef0000 - 000000001feff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001feff000 - 000000001ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001ff00000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 512MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f6cd0
[    0.000000] Entering add_active_range(0, 0, 131072) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   131072
[    0.000000]   HighMem    131072 ->   131072
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   131072
[    0.000000] On node 0 totalpages: 131072
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125984 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP signature @ 0xC00F6C60 checksum 0
[    0.000000] ACPI: RSDP 000F6C60, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT 1FEFAB5A, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP 1FEFEF06, 0074 (r1 INTEL  440BX     6040000 PTL     F4240)
[    0.000000] ACPI: DSDT 1FEFAB8A, 437C (r1 PTLTD  Custom    6040000 MSFT  100000D)
[    0.000000] ACPI: FACS 1FEFFFC0, 0040
[    0.000000] ACPI: APIC 1FEFEF7A, 005E (r1 PTLTD  	 APIC    6040000  LTP        0)
[    0.000000] ACPI: BOOT 1FEFEFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 17
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
[    0.000000] Built 1 zonelists.  Total pages: 130048
[    0.000000] Kernel command line: root=UUID=bb7fd866-d530-4293-a666-009eca2d34ad ro clocksource=acpi_pm quiet splash
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1994.982 MHz processor.
[    6.003847] Console: colour VGA+ 80x25
[    6.004705] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    6.005367] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    6.006224] Memory: 508684k/524288k available (2015k kernel code, 14980k reserved, 915k data, 364k init, 0k highmem)
[    6.006261] virtual kernel memory layout:
[    6.006264]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    6.006266]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    6.006269]     vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
[    6.006270]     lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
[    6.006272]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[    6.006273]       .data : 0xc02f7e86 - 0xc03dce84   ( 915 kB)
[    6.006274]       .text : 0xc0100000 - 0xc02f7e86   (2015 kB)
[    6.006303] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[    6.007161] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    6.087739] Calibrating delay using timer specific routine.. 3995.01 BogoMIPS (lpj=7990037)
[    6.087801] Security Framework v1.0.0 initialized
[    6.087863] SELinux:  Disabled at boot.
[    6.087926] Mount-cache hash table entries: 512
[    6.087988] CPU: After generic identify, caps: 0febfbff 20000000 00000000 00000000 00002211 00000000 00000001
[    6.088051] CPU: L1 I cache: 32K, L1 D cache: 32K
[    6.088080] CPU: L2 cache: 4096K
[    6.088142] CPU: After all inits, caps: 0febfbff 20000000 00000000 00003940 00002211 00000000 00000001
[    6.088205] Compat vDSO mapped to ffffe000.
[    6.088267] Checking 'hlt' instruction... OK.
[    6.103752] SMP alternatives: switching to UP code
[    6.103814] Early unpacking initramfs... done
[    6.423649] ACPI: Core revision 20070126
[    6.423711] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[    6.424024] CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
[    6.424242] SMP alternatives: switching to SMP code
[    6.427647] Booting processor 1/1 eip 3000
[    6.438732] Initializing CPU#1
[    6.515596] Calibrating delay using timer specific routine.. 3991.20 BogoMIPS (lpj=7982407)
[    6.515658] CPU: After generic identify, caps: 0febfbff 20000000 00000000 00000000 00002211 00000000 00000001
[    6.515721] CPU: L1 I cache: 32K, L1 D cache: 32K
[    6.515749] CPU: L2 cache: 4096K
[    6.515811] CPU: After all inits, caps: 0febfbff 20000000 00000000 00003940 00002211 00000000 00000001
[    6.516038] CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 08
[    6.516101] Total of 2 processors activated (7986.22 BogoMIPS).
[    6.516163] ENABLING IO-APIC IRQs
[    6.516387] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    6.665001] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    6.685273] Brought up 2 CPUs
[    6.847467] migration_cost=0
[    6.849183] Booting paravirtualized kernel on bare hardware
[    6.849308] Time: 12:03:20  Date: 05/16/108
[    6.849370] NET: Registered protocol family 16
[    6.851909] EISA bus registered
[    6.851971] ACPI: bus type pci registered
[    6.852034] PCI: PCI BIOS revision 2.10 entry at 0xfd9a0, last bus=2
[    6.852071] PCI: Using configuration type 1
[    6.852113] Setting up standard PCI resources
[    6.859477] ACPI: EC: Look up EC in DSDT
[    6.875464] ACPI: Interpreter enabled
[    6.875492] ACPI: (supports S0 S1 S4 S5)
[    6.875555] ACPI: Using IOAPIC for interrupt routing
[    6.890281] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    6.890343] PCI: Probing PCI hardware (bus 00)
[    6.893221] PCI quirk: region 1000-103f claimed by PIIX4 ACPI
[    6.893261] PCI quirk: region 1040-104f claimed by PIIX4 SMB
[    6.895680] PCI: Transparent bridge - 0000:00:11.0
[    6.895742] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    6.899445] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
[    6.899507] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 14 15)
[    6.899570] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 14 15)
[    6.899632] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 14 15) *0, disabled.
[    6.899801] Linux Plug and Play Support v0.97 (c) Adam Belay
[    6.899841] pnp: PnP ACPI init
[    6.899903] ACPI: bus type pnp registered
[    6.929460] pnp: PnP ACPI: found 12 devices
[    6.929505] ACPI: ACPI bus type pnp unregistered
[    6.929567] PnPBIOS: Disabled by ACPI PNP
[    6.929740] PCI: Using ACPI for IRQ routing
[    6.929802] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    6.951415] NET: Registered protocol family 8
[    6.951429] NET: Registered protocol family 20
[    6.955431] Time: tsc clocksource has been installed.
[    6.983340] Time: acpi_pm clocksource has been installed.
[    6.983740] Switched to high resolution mode on CPU 0
[    6.983802] PCI: Bridge: 0000:00:01.0
[    6.983818]   IO window: disabled.
[    6.983880]   MEM window: disabled.
[    6.983937]   PREFETCH window: disabled.
[    6.983999] PCI: Bridge: 0000:00:11.0
[    6.984039]   IO window: 2000-2fff
[    6.984075]   MEM window: disabled.
[    6.984110]   PREFETCH window: 30000000-300fffff
[    6.984173] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    6.984235] ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 18 (level, low) -> IRQ 16
[    6.984298] NET: Registered protocol family 2
[    6.985562] Switched to high resolution mode on CPU 1
[    7.023425] IP route cache hash table entries: 16384 (order: 4, 65536 bytes)
[    7.023555] TCP established hash table entries: 65536 (order: 7, 786432 bytes)
[    7.023686] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    7.023816] TCP: Hash tables configured (established 65536 bind 65536)
[    7.023946] TCP reno registered
[    7.035420] checking if image is initramfs... it is
[    7.463121] Freeing initrd memory: 6568k freed
[    7.463566] Simple Boot Flag at 0x36 set to 0x1
[    7.467342] audit: initializing netlink socket (disabled)
[    7.467472] audit(1213617798.856:1): initialized
[    7.472404] VFS: Disk quotas dquot_6.5.1
[    7.472565] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    7.472869] io scheduler noop registered
[    7.472909] io scheduler anticipatory registered
[    7.472918] io scheduler deadline registered
[    7.472993] io scheduler cfq registered (default)
[    7.473333] Limiting direct PCI/PCI transfers.
[    7.473463] Boot video device is 0000:00:0f.0
[    7.474118] isapnp: Scanning for PnP cards...
[    7.829407] isapnp: No Plug & Play device found
[    7.860239] Real Time Clock Driver v1.12ac
[    7.860461] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    7.860514] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.860666] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    7.861273] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.861515] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    7.862742] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[    7.863043] input: Macintosh mouse button emulation as /class/input/input0
[    7.863276] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
[    8.364879] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.364959] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.365428] mice: PS/2 mouse device common for all mice
[    8.365827] EISA: Probing bus 0 at eisa.0
[    8.365880] Cannot allocate resource for EISA slot 1
[    8.365894] Cannot allocate resource for EISA slot 2
[    8.365946] EISA: Detected 0 cards.
[    8.366559] TCP cubic registered
[    8.366612] NET: Registered protocol family 1
[    8.366664] Using IPI No-Shortcut mode
[    8.366865]   Magic number: 12:984:76
[    8.366918] Freeing unused kernel memory: 364k freed
[    8.370875] input: AT Translated Set 2 keyboard as /class/input/input1
[    8.555335] fuse init (API version 7.8)
[    8.563021] Capability LSM initialized
[    8.571028] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.571088] ACPI: Processor [CPU1] (supports 8 throttling states)
[    8.571148] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[    8.571209] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[    8.907098] SCSI subsystem initialized
[    8.910411] Fusion MPT base driver 3.04.04
[    8.910423] Copyright (c) 1999-2007 LSI Logic Corporation
[    8.911007] Fusion MPT SPI Host driver 3.04.04
[    8.911113] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 17 (level, low) -> IRQ 17
[    8.911219] mptbase: Initiating ioc0 bringup
[    8.912002] pcnet32.c:v1.33 27.Jun.2006 tsbogend@alpha.franken.de
[    8.926146] libata version 2.21 loaded.
[    8.930975] Floppy drive(s): fd0 is 1.44M
[    8.950508] FDC 0 is a post-1991 82077
[    8.994253] ioc0: 53C1030: Capabilities={Initiator}
[    9.122373] scsi0 : ioc0: LSI53C1030, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
[    9.237956] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 16
[    9.238063] pcnet32: PCnet/PCI II 79C970A at 0x2000,<7>ata_piix 0000:00:07.1: version 2.11
[    9.238169]  00 0c 29 91 8c 5a assigned IRQ 16.
[    9.238557] eth0: registered as PCnet/PCI II 79C970A
[    9.238663] pcnet32: 1 cards_found.
[    9.238828] scsi1 : ata_piix
[    9.239056] scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[    9.239362]  target0:0:0: Beginning Domain Validation
[    9.239584]  target0:0:0: Domain Validation skipping write tests
[    9.239606]  target0:0:0: Ending Domain Validation
[    9.239713]  target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
[    9.241466] scsi2 : ata_piix
[    9.241573] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011050 irq 14
[    9.241592] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011058 irq 15
[    9.242451] ata1: port disabled. ignoring.
[    9.258584] sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
[    9.258796] sd 0:0:0:0: [sda] Write Protect is off
[    9.258825] sd 0:0:0:0: [sda] Mode Sense: 5d 00 00 00
[    9.258931] sd 0:0:0:0: [sda] Cache data unavailable
[    9.258959] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    9.259546] sd 0:0:0:0: [sda] 8388608 512-byte hardware sectors (4295 MB)
[    9.259652] sd 0:0:0:0: [sda] Write Protect is off
[    9.259656] sd 0:0:0:0: [sda] Mode Sense: 5d 00 00 00
[    9.259710] sd 0:0:0:0: [sda] Cache data unavailable
[    9.259713] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    9.259819]  sda: sda1
[    9.262643] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.267326] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.482661] kjournald starting.  Commit interval 5 seconds
[    9.482752] EXT3-fs: mounted filesystem with ordered data mode.
[    9.554680] ata2.00: ATAPI: VMware Virtual IDE CDROM Drive, 00000001, max UDMA/33
[    9.709962] ata2.00: configured for UDMA/33
[    9.710609] scsi 2:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
[    9.710700] scsi 2:0:0:0: Attached scsi generic sg1 type 5
[   12.725120] eth0: link up
[   13.888779] input: PC Speaker as /class/input/input2
[   13.939583] Linux agpgart interface v0.102 (c) Dave Jones
[   13.971787] agpgart: Detected an Intel 440BX Chipset.
[   13.973079] agpgart: AGP aperture is 256M @ 0x0
[   14.088237] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   14.108527] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.127708] piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
[   14.127796] piix4_smbus 0000:00:07.3: Host SMBus controller not enabled!
[   14.635379] input: ImPS/2 Generic Wheel Mouse as /class/input/input3
[   14.639440] parport_pc 00:08: reported by Plug and Play ACPI
[   14.639955] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   14.871456] sr0: scsi3-mmc drive: 1x/1x xa/form2 cdda tray
[   14.871593] Uniform CD-ROM driver Revision: 3.20
[   14.874518] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   15.651525] lp0: using parport0 (interrupt-driven).
[   16.434944] NET: Registered protocol family 17
[   17.529764] EXT3 FS on sda1, internal journal
[   24.470010] NET: Registered protocol family 10
[   24.474330] lo: Disabled Privacy Extensions
[   35.442038] eth0: no IPv6 routers present
[  171.902752] ISO 9660 Extensions: RRIP_1991A
[  368.579546] vmmemctl: module license 'unspecified' taints kernel.
[  368.582693] VMware memory control driver initialized
[  368.582732] vmmemctl: started kernel thread pid=26097
[  368.588995] VMware memory control driver unloaded
[  375.147301] ACPI: PCI interrupt for device 0000:02:00.0 disabled
[  375.194835] VMware vmxnet virtual NIC driver
[  375.195549] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 16
[  375.196128] Found vmxnet/PCI at 0x2024, irq 16.
[  375.197638] features:
[  375.255612] ACPI: PCI interrupt for device 0000:02:00.0 disabled
[  408.193680] BUG: unable to handle kernel paging request at virtual address 1b6ae7c4
[  408.195348]  printing eip:
[  408.195578] c01c4e79
[  408.195592] *pde = 00000000
[  408.195954] Oops: 0000 [#1]
[  408.196197] SMP 
[  408.196843] Modules linked in: isofs ipv6 af_packet lp sr_mod cdrom parport_pc parport ata_generic i2c_piix4 shpchp pci_hotplug psmouse intel_agp agpgart pcspkr i2c_core serio_raw evdev ext3 jbd mbcache sg sd_mod floppy ata_piix libata mii mptspi mptscsih mptbase scsi_transport_spi scsi_mod thermal processor fan commoncap fuse
[  408.204241] CPU:    0
[  408.204244] EIP:    0060:[<c01c4e79>]    Tainted: P       VLI
[  408.204245] EFLAGS: 00010202   (2.6.22-14-generic #1)
[  408.205210] EIP is at sysfs_follow_link+0x129/0x260
[  408.205464] eax: 00000000   ebx: 00000016   ecx: 1b6ae7c4   edx: ffffffff
[  408.205718] esi: 00000000   edi: d6a3d7b4   ebp: 00000001   esp: c9951ea4
[  408.205985] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  408.206240] Process slabinfo (pid: 32516, ti=c9950000 task=df982a60 task.ti=c9950000)
[  408.206504] Stack: 1b6ae7c4 c9951ed8 c98d4000 ffffffea c03b6650 dbf89950 00000001 c0301b60 
[  408.209978]        d66faaa0 00001000 084447e0 c0187aa3 00000803 00000001 00000000 b7f5c000 
[  408.217499]        d1724704 d78f1790 b7f5c000 d78f179c 00000000 c9951f40 ffffff9c d003b000 
[  408.217640] Call Trace:
[  408.225802]  [<c0187aa3>] generic_readlink+0x33/0x90
[  408.226241]  [<c012d211>] current_fs_time+0x41/0x50
[  408.226289]  [<c0183a6b>] sys_readlinkat+0x9b/0xd0
[  408.227059]  [<c0196d44>] mntput_no_expire+0x24/0xa0
[  408.227459]  [<c016ef81>] remove_vma+0x41/0x50
[  408.227857]  [<c0183ac7>] sys_readlink+0x27/0x30
[  408.229601]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[  408.229729]  =======================
[  408.229841] Code: e8 8d ac f7 ff 8b 44 24 10 8b 40 24 83 c5 01 85 c0 75 f6 8b 44 24 14 bb 01 00 00 00 31 f6 ba ff ff ff ff 89 04 24 8b 0c 24 89 f0 <8b> 39 89 d1 f2 ae f7 d1 49 8d 5c 19 01 8b 0c 24 8b 49 24 85 c9 
[  408.255504] EIP: [<c01c4e79>] sysfs_follow_link+0x129/0x260 SS:ESP 0068:c9951ea4
[  468.324478] WARNING: at /build/buildd/linux-source-2.6.22-2.6.22/lib/kref.c:33 kref_get()
[  468.325259]  [<c01fb0ed>] kref_get+0x3d/0x40
[  468.325877]  [<c01fa29f>] kobject_get+0xf/0x20
[  468.326108]  [<c01c4f82>] sysfs_follow_link+0x232/0x260
[  468.326561]  [<c0187aa3>] generic_readlink+0x33/0x90
[  468.326978]  [<c018cf30>] filldir+0x0/0xe0
[  468.327409]  [<c018d095>] vfs_readdir+0x85/0xb0
[  468.327829]  [<c012d211>] current_fs_time+0x41/0x50
[  468.328229]  [<c0183a6b>] sys_readlinkat+0x9b/0xd0
[  468.328641]  [<c02f5ef9>] do_page_fault+0x389/0x690
[  468.329062]  [<c018cf30>] filldir+0x0/0xe0
[  468.329453]  [<c018d095>] vfs_readdir+0x85/0xb0
[  468.329861]  [<c0183ac7>] sys_readlink+0x27/0x30
[  468.329971]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[  468.330377]  =======================
[  468.330800] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  468.331312]  printing eip:
[  468.331569] c01c4e7d
[  468.331801] *pde = 00000000
[  468.332173] Oops: 0000 [#2]
[  468.332736] SMP 
[  468.333411] Modules linked in: isofs ipv6 af_packet lp sr_mod cdrom parport_pc parport ata_generic i2c_piix4 shpchp pci_hotplug psmouse intel_agp agpgart pcspkr i2c_core serio_raw evdev ext3 jbd mbcache sg sd_mod floppy ata_piix libata mii mptspi mptscsih mptbase scsi_transport_spi scsi_mod thermal processor fan commoncap fuse
[  468.338387] CPU:    1
[  468.338834] EIP:    0060:[<c01c4e7d>]    Tainted: P       VLI
[  468.339226] EFLAGS: 00010246   (2.6.22-14-generic #1)
[  468.347090] EIP is at sysfs_follow_link+0x12d/0x260
[  468.347338] eax: 00000000   ebx: 00000001   ecx: ffffffff   edx: ffffffff
[  468.347598] esi: 00000000   edi: 00000000   ebp: 00000001   esp: cf1f5ea4
[  468.347853] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  468.348111] Process slabinfo (pid: 32571, ti=cf1f4000 task=db572f90 task.ti=cf1f4000)
[  468.348377] Stack: d81c9110 cf1f5ed8 c70c3000 ffffffea c03b6650 d81c9110 00000001 c0301b60 
[  468.348575]        c71ad550 00001000 084447e0 c0187aa3 c018cf30 c018d095 cf1f5f94 cf1f5fb8 
[  468.352395]        da4a71f4 db572f90 da4a71c0 ffffffea 00000000 cf1f5f40 ffffff9c cd9ce000 
[  468.352591] Call Trace:
[  468.352761]  [<c0187aa3>] generic_readlink+0x33/0x90
[  468.352911]  [<c018cf30>] filldir+0x0/0xe0
[  468.353041]  [<c018d095>] vfs_readdir+0x85/0xb0
[  468.353156]  [<c012d211>] current_fs_time+0x41/0x50
[  468.356249]  [<c0183a6b>] sys_readlinkat+0x9b/0xd0
[  468.356649]  [<c02f5ef9>] do_page_fault+0x389/0x690
[  468.357052]  [<c018cf30>] filldir+0x0/0xe0
[  468.357442]  [<c018d095>] vfs_readdir+0x85/0xb0
[  468.357837]  [<c0183ac7>] sys_readlink+0x27/0x30
[  468.358242]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[  468.358249]  =======================
[  468.358255] Code: ff 8b 44 24 10 8b 40 24 83 c5 01 85 c0 75 f6 8b 44 24 14 bb 01 00 00 00 31 f6 ba ff ff ff ff 89 04 24 8b 0c 24 89 f0 8b 39 89 d1 <f2> ae f7 d1 49 8d 5c 19 01 8b 0c 24 8b 49 24 85 c9 89 0c 24 75 
[  468.366769] EIP: [<c01c4e7d>] sysfs_follow_link+0x12d/0x260 SS:ESP 0068:cf1f5ea4
[  504.433100] VMware hgfs: HGFS is disabled in the host
[  504.458724] VMware memory control driver initialized
[  504.459189] vmmemctl: started kernel thread pid=32680
[  504.498577] VMware vmxnet virtual NIC driver
[  504.499500] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 16
[  504.500310] Found vmxnet/PCI at 0x2024, irq 16.
[  504.501193] features:
[  504.686333]  ethtool operation 31 not supported
[  515.285335] eth0: no IPv6 routers present
