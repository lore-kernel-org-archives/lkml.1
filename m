Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbZIBQ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbZIBQ4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 12:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZIBQ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 12:56:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZIBQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 12:56:31 -0400
From: Christian =?iso-8859-1?q?Kr=E4mer?= <christian@kraemer-eu.de>
Organization: Privat
Subject: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Wed, 2 Sep 2009 18:56:29 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 10910
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909021856.29565.christian@kraemer-eu.de>
X-Provags-ID: V01U2FsdGVkX19r4HaRY08zwmroYOmk8q6FlpZefgxCYkEGjqA
 RJlmqwFEgK6d2Sn6fcMJXxrYqynG/khgLlnr1I3AndBMD9a7P3
 H6sduNq+w2wGvbK5iK1+12FVKWBcaT9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have an old Thinkpad 600 and a problem with the yenta_socket module.
When I insert my WLAN Card (Proxim Orinoco Gold 8470-WD) it seems that the kernel won't recognise it.

pcmciautils tell me that I should see the lspci output for more information and says that there are no product information availiable
lspci (without parameters) doesn't show the card, but when i pass the -H1 Parameter, which uses an "Intel configuration mechanism" as annexed to the lspci man 
page the card is discoverd correctly, but it shows that the interrupts where routed to 255 instead of 11 (the output of both lspci variations with -vvv is attached below)

in dmesg I only can see that the card was inserted or ejected.

I used a Gentoo LiveCD (Kernel 2.6.24-gentoo-r7; Platform: x86)

If you need more information or output from an other kernel (maybe one without distributor patches) please tell me.

Sorry for my bad english and thanks for reply





socket relevant dmesg output:

Yenta: CardBus bridge found at 0000:00:02.0 [1014:0092]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.0, mfunc 0xfba97543, devctl 0x62
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006
Yenta: CardBus bridge found at 0000:00:02.1 [1014:0092]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.1, mfunc 0xfba97543, devctl 0x62
ACPI: CPU0 (power states: C1[C1] C2[C2])
input: Power Button (FF) as /devices/virtual/input/input3
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006



Here is the output of "lspci -vvv":

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) (rev 02)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR+ INTx-
        Latency: 64
        Region 0: Memory at <unassigned> (32-bit, prefetchable)

00:02.0 CardBus bridge: Texas Instruments PCI1250 (rev 02)
        Subsystem: IBM ThinkPad 600
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 20301000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=01, subordinate=04, sec-latency=176
        Memory window 0: 24000000-27fff000 (prefetchable)
        Memory window 1: 28000000-2bfff000
        I/O window 0: 00001000-000010ff
        I/O window 1: 00001400-000014ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
        16-bit legacy interface ports at 0001

00:02.1 CardBus bridge: Texas Instruments PCI1250 (rev 02)
        Subsystem: IBM ThinkPad 600
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 128 bytes
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at 20300000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=05, subordinate=08, sec-latency=176
        Memory window 0: 2c000000-2ffff000 (prefetchable)
        Memory window 1: 30000000-33fff000
        I/O window 0: 00001800-000018ff
        I/O window 1: 00001c00-00001cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

00:03.0 VGA compatible controller: Neomagic Corporation NM2160 [MagicGraph 128XD] (rev 01) (prog-if 00 [VGA controller])
        Subsystem: IBM MagicGraph 128XD
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 128 (4000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=16M]
        Region 1: Memory at 20000000 (32-bit, non-prefetchable) [size=2M]
        Region 2: Memory at 20200000 (32-bit, non-prefetchable) [size=1M]

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at fcf0 [size=16]

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 48
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at 8400 [size=32]

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 01)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin ? routed to IRQ 9



And here is the output of "lcpci -H1 -vvv":

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) (rev 02)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR+ INTx-
        Latency: 64
        Region 0: Memory at <unassigned> (32-bit, prefetchable)

00:02.0 CardBus bridge: Texas Instruments PCI1250 (rev 02)
        Subsystem: IBM ThinkPad 600
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 255
        Region 0: Memory at 20301000 (32-bit, non-prefetchable)
        Bus: primary=00, secondary=01, subordinate=04, sec-latency=176
        Memory window 0: 24000000-27fff000 (prefetchable)
        Memory window 1: 28000000-2bfff000
        I/O window 0: 00001000-000010ff
        I/O window 1: 00001400-000014ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
        16-bit legacy interface ports at 0001

00:02.1 CardBus bridge: Texas Instruments PCI1250 (rev 02)
        Subsystem: IBM ThinkPad 600
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 128 bytes
        Interrupt: pin B routed to IRQ 255
        Region 0: Memory at 20300000 (32-bit, non-prefetchable)
        Bus: primary=00, secondary=05, subordinate=08, sec-latency=176
        Memory window 0: 2c000000-2ffff000 (prefetchable)
        Memory window 1: 30000000-33fff000
        I/O window 0: 00001800-000018ff
        I/O window 1: 00001c00-00001cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

00:03.0 VGA compatible controller: Neomagic Corporation NM2160 [MagicGraph 128XD] (rev 01) (prog-if 00 [VGA controller])
        Subsystem: IBM MagicGraph 128XD
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 128 (4000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e0000000 (32-bit, prefetchable)
        Region 1: Memory at 20000000 (32-bit, non-prefetchable)
        Region 2: Memory at 20200000 (32-bit, non-prefetchable)

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Region 4: I/O ports at fcf0

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 48
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at 8400

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 01)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor (rev 01)
        Subsystem: PROXIM Inc Unknown device 0a40
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 0
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-



complete dmesg output:

Linux version 2.6.24-gentoo-r7 (root@miranda) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #1 SMP Tue Jun 17 12:50:42 UTC 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000011fd0000 (usable)
 BIOS-e820: 0000000011fd0000 - 0000000011fdf000 (ACPI data)
 BIOS-e820: 0000000011fdf000 - 0000000011fe0000 (ACPI NVS)
 BIOS-e820: 0000000011fe0000 - 0000000012000000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
287MB LOWMEM available.
Entering add_active_range(0, 0, 73680) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    73680
  HighMem     73680 ->    73680
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    73680
On node 0 totalpages: 73680
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 543 pages used for memmap
  Normal zone: 69041 pages, LIFO batch:15
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.0 present.
IBM Thinkpad 600 Series 2645 detected: force use of acpi=noirq
ACPI: RSDP 000FD6E0, 0014 (r0 IBM   )
ACPI: RSDT 11FD0000, 0028 (r1 IBM    TP600           1             0)
ACPI: FACP 11FD0100, 0074 (r1 IBM    TP600           1             0)
ACPI: DSDT 11FD0200, B2E4 (r1 IBM    TP600          13 MSFT  100000B)
ACPI: FACS 11FDF000, 0040
Allocating PCI resources starting at 20000000 (gap: 12000000:edfe0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 73105
Kernel command line: root=/dev/ram0 init=/linuxrc dokeymap looptype=squashfs loop=/image.squashfs cdroot initrd=gentoo.igz vga=791 BOOT_IMAGE=gentoo
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (0124b000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 232.108 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 281924k/294720k available (2970k kernel code, 12192k reserved, 1112k data, 280k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc74000 - 0xfffff000   (3628 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xd2800000 - 0xff7fe000   ( 719 MB)
    lowmem  : 0xc0000000 - 0xd1fd0000   ( 287 MB)
      .init : 0xc0505000 - 0xc054b000   ( 280 kB)
      .data : 0xc03e6b88 - 0xc04fcd1c   (1112 kB)
      .text : 0xc0100000 - 0xc03e6b88   (2970 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 465.01 BogoMIPS (lpj=2325074)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU: After all inits, caps: 0183f9ff 00000000 00000000 00000040 00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 17k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0a00 (from 0800)
CPU0: Intel Pentium II (Deschutes) stepping 02
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000001
  groups: 00000000,00000001
net_namespace: 64 bytes
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd880, last bus=6
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region ef00-ef3f claimed by PIIX4 ACPI
PCI quirk: region efa0-efaf claimed by PIIX4 SMB
PIIX4 devres B PIO at 02f8-02ff
PIIX4 devres E PIO at 0538-053f
PIIX4 devres G PIO at 0130-013f
PIIX4 devres I PIO at 002e-002f
PIIX4 devres J PIO at 15e8-15ef
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: Power Resource [PSIO] (on)
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PFN1] (off)
ACPI: Power Resource [PVID] (on)
ACPI: Power Resource [PRSD] (off)
ACPI: Power Resource [PDCK] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 18 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Probing PCI hardware
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r7 #1
 [<c0187ceb>] sysfs_add_one+0x54/0xb8
 [<c01888da>] sysfs_create_link+0xaf/0xfd
 [<c02c8020>] pci_bus_add_devices+0xba/0xff
 [<c037ac1d>] pcibios_scan_root+0x25/0x80
 [<c011ab3d>] printk+0x1b/0x1f
 [<c052822f>] pci_legacy_init+0x53/0xe1
 [<c0505769>] kernel_init+0x154/0x2b6
 [<c0102546>] ret_from_fork+0x6/0x20
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0103877>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:02.0: Error creating sysfs bridge symlink, continuing...
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-gentoo-r7 #1
 [<c0187ceb>] sysfs_add_one+0x54/0xb8
 [<c01888da>] sysfs_create_link+0xaf/0xfd
 [<c02c8020>] pci_bus_add_devices+0xba/0xff
 [<c052822f>] pci_legacy_init+0x53/0xe1
 [<c0505769>] kernel_init+0x154/0x2b6
 [<c0102546>] ret_from_fork+0x6/0x20
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0505615>] kernel_init+0x0/0x2b6
 [<c0103877>] kernel_thread_helper+0x7/0x10
 =======================
pci 0000:00:02.1: Error creating sysfs bridge symlink, continuing...
PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:07.0
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:02.0
PCI: Sharing IRQ 11 with 0000:00:03.0
PCI: Found IRQ 11 for device 0000:00:02.1
Time: tsc clocksource has been installed.
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xcbfff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x11ffffff could not be reserved
system 00:00: iomem range 0xfffe0000-0xffffffff could not be reserved
system 00:0d: ioport range 0x15e0-0x15ef has been reserved
system 00:0d: ioport range 0xef00-0xef3f has been reserved
system 00:0d: ioport range 0xefa0-0xefaf has been reserved
PCI: Bus 1, cardbus bridge: 0000:00:02.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 24000000-27ffffff
  MEM window: 28000000-2bffffff
PCI: Bus 5, cardbus bridge: 0000:00:02.1
  IO window: 00001800-000018ff
  IO window: 00001c00-00001cff
  PREFETCH window: 2c000000-2fffffff
  MEM window: 30000000-33ffffff
PCI: Found IRQ 11 for device 0000:00:02.0
PCI: Sharing IRQ 11 with 0000:00:03.0
PCI: Found IRQ 11 for device 0000:00:02.1
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4772k freed
Machine check exception polling timer started.
squashfs: version 3.3 (2007/10/31) Phillip Lougher
NTFS driver 2.1.29 [Flags: R/O].
SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered (default)
Limiting direct PCI/PCI transfers.
Boot video device is 0000:00:03.0
vesafb: framebuffer at 0xe0000000, mapped to 0xd2880000, using 1984k, total 1984k
vesafb: mode is 1024x768x16, linelength=2048, pages=0
vesafb: protected mode interface info at c000:8d50
vesafb: pmi: set display start = c00c8d50, set palette = c00c8d50
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
serial 00:03: unable to assign resources
serial: probe of 00:03 failed with error -16
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfcf0-0xfcf7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xfcf8-0xfcff, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: IBM-DADA-26480, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: SANYO CRD-S372B, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: MWDMA2 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 12594960 sectors (6448 MB) w/460KiB Cache, CHS=13328/15/63
hda: cache flushes not supported
 hda: hda1
 hda1: <netbsd: hda5 hda6 >
hdc: ATAPI 24X CD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
SCSI Media Changer driver v0.25
Driver 'ch' needs updating - please use bus_type methods
aoe: AoE v32 initialised.
PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:MOU0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Clocksource tsc unstable (delta = 260006273 ns)
Time: pit clocksource has been installed.
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI Shortcut mode
Freeing unused kernel memory: 280k freed
IBM TrackPoint firmware: 0x0b, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input2
libata version 3.00 loaded.
NCR53c406a: no available ports found
scsi: <fdomain> Detection failed (no card)
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options<6>seagate: ST0x/TMC-8xx not detected.
Failed initialization of WD-7000 SCSI card!
NCR53c406a: no available ports found
sym53c416.c: Version 1.0.0-ac
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
Fusion MPT FC Host driver 3.04.06
Fusion MPT SAS Host driver 3.04.06
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.14)
Adaptec aacraid driver 1.1-5[2449]-ms
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc5 Thu May 17 10:09:32 PDT 2007
QLogic Fibre Channel HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.2
Copyright(c) 2004-2007 Emulex.  All rights reserved.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
USB Universal Host Controller Interface driver v3.0
PCI: Found IRQ 11 for device 0000:00:07.2
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00008400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
sl811: driver sl811-hcd, 19 May 2005
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
async_tx: api initialized (async)
xor: measuring software checksum speed
   8regs     :   428.800 MB/sec
   8regs_prefetch:   383.600 MB/sec
   32regs    :   230.000 MB/sec
   32regs_prefetch:   212.000 MB/sec
   pII_mmx   :   594.400 MB/sec
   p5_mmx    :   617.600 MB/sec
xor: using function: p5_mmx (617.600 MB/sec)
raid6: int32x1     56 MB/s
raid6: int32x2     55 MB/s
raid6: int32x4     58 MB/s
raid6: int32x8     54 MB/s
raid6: mmxx1      135 MB/s
raid6: mmxx2      167 MB/s
raid6: using algorithm mmxx2 (167 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: raid10 personality registered for level 10
JFS: nTxBlock = 2243, nTxLock = 17951
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
UDF-fs: No partition found (1)
UDF-fs: No partition found (1)
UDF-fs: No VRS found
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
Real Time Clock Driver v1.12ac
warning: process `hwsetup' used the deprecated sysctl system call with 1.23.
Yenta: CardBus bridge found at 0000:00:02.0 [1014:0092]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.0, mfunc 0xfba97543, devctl 0x62
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006
Yenta: CardBus bridge found at 0000:00:02.1 [1014:0092]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.1, mfunc 0xfba97543, devctl 0x62
ACPI: CPU0 (power states: C1[C1] C2[C2])
input: Power Button (FF) as /devices/virtual/input/input3
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/virtual/input/input4
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /devices/virtual/input/input5
ACPI: Sleep Button (CM) [SLPB]
ACPI: Thermal Zone [THM0] (55 C)
ACPI: Thermal Zone [THM2] (37 C)
ACPI: Thermal Zone [THM6] (27 C)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/LNXVIDEO:00/input/input6
ACPI: Video Device [VID0] (multi-head: yes  rom: no  post: no)
ACPI: Transitioning device [FN00] to D3
ACPI: Transitioning device [FN00] to D3
ACPI: Fan [FN00] (off)
ACPI: Transitioning device [FN01] to D3
ACPI: Transitioning device [FN01] to D3
ACPI: Fan [FN01] (off)
ACPI: Transitioning device [FN20] to D3
ACPI: Transitioning device [FN20] to D3
ACPI: Fan [FN20] (off)
ACPI: Transitioning device [FN21] to D3
ACPI: Transitioning device [FN21] to D3
ACPI: Fan [FN21] (off)
ACPI: Transitioning device [FN60] to D3
ACPI: Transitioning device [FN60] to D3
ACPI: Fan [FN60] (off)
ACPI: Transitioning device [FN61] to D3
ACPI: Transitioning device [FN61] to D3
ACPI: Fan [FN61] (off)
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
ACPI: Battery Slot [BAT0] (battery absent)
ACPI: AC Adapter [AC] (on-line)
cs: IO port probe 0x100-0x3af: excluding 0x130-0x137 0x200-0x207 0x220-0x22f 0x388-0x38f
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0x100-0x3af: excluding 0x130-0x137 0x200-0x207 0x220-0x22f 0x388-0x38f
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwsetup.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
warning: process `hwsetup' used the deprecated sysctl system call with 1.49.
warning: process `hwsetup' used the deprecated sysctl system call with 1.49.
ACPI: ACPI Dock Station Driver
hda: UDMA/33 mode selected
hdc: MWDMA2 mode selected

