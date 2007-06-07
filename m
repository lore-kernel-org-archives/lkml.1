Return-Path: <linux-kernel-owner+w=401wt.eu-S934873AbXFGSdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873AbXFGSdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbXFGSdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:33:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:58764 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761368AbXFGSdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:33:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GeUL0YOIRNXh7qXbgLJGq1DybQ6vQgZyb88fNch6dzbW+A5WtgUb++jF65C8OS4rwICoRho4deOU0dBexB1PMddwOeryAa5kkNQu4nQ9zkibWd5tNoffV2FxWc/4pigPo/ugp9O/YT90gxCew+ihw5k7K41u2wlZiSL6jIbq/IA=
Message-ID: <a44ae5cd0706071133w19272d8bkb392ffe58f1af6b7@mail.gmail.com>
Date: Thu, 7 Jun 2007 11:33:12 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc4-mm2 -- Bus #03 (-#06) is hidden behind transparent bridge #02 (-#02) (try 'pci=assign-busses')
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, is it okay to debug this with the MM tree?  I see this with
Linus' kernels as well.  It's a long-standing issue, but I have always
just used pci=assign-busses in the past.

[    0.000000] Linux version 2.6.22-rc4-mm2 (root@toolbox) (gcc
version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #14 SMP PREEMPT Thu Jun 7
08:29:32 PDT 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003dee0000 (usable)
[    0.000000]  BIOS-e820: 000000003dee0000 - 000000003deec000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003deec000 - 000000003df00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003df00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
[    0.000000] 94MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f7e30
[    0.000000] Entering add_active_range(0, 0, 253664) 0 entries of 256 used
[    0.000000] sizeof(struct page) = 56
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   253664
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   253664
[    0.000000] On node 0 totalpages: 253664
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4040 pages, LIFO batch:0
[    0.000000]   Normal zone: 3080 pages used for memmap
[    0.000000]   Normal zone: 222200 pages, LIFO batch:31
[    0.000000]   HighMem zone: 332 pages used for memmap
[    0.000000]   HighMem zone: 23956 pages, LIFO batch:3
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F7E00, 0014 (r0 HP    )
[    0.000000] ACPI: RSDT 3DEE76BB, 0040 (r1 HP     09B8      6040000
LTP        0)
[    0.000000] ACPI: FACP 3DEEBE8C, 0074 (r1 HP     09B8      6040000
PTL        50)
[    0.000000] ACPI: DSDT 3DEE7B9A, 42F2 (r1 HP     09B8      6040000
MSFT  100000E)
[    0.000000] ACPI: FACS 3DEFCFC0, 0040
[    0.000000] ACPI: HPET 3DEEBF00, 0038 (r1 HP     09B8      6040000
PTL         0)
[    0.000000] ACPI: APIC 3DEEBF38, 005A (r1 HP     09B8      6040000
PTL        50)
[    0.000000] ACPI: APIC 3DEEBF92, 0046 (r1 HP     09B8      6040000
PTL         0)
[    0.000000] ACPI: BOOT 3DEEBFD8, 0028 (r1 HP     09B8      6040000
LTP        1)
[    0.000000] ACPI: SSDT 3DEE7AFE, 009C (r1 HP     09B8            1
INTL 20030224)
[    0.000000] ACPI: SSDT 3DEE76FB, 0277 (r1 HP     09B8         2000
INTL 20030224)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify
linux-acpi@vger.kernel.org
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0x0
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:bec00000)
[    0.000000] swsusp: Registered nosave memory region:
000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region:
00000000000a0000 - 00000000000ce000
[    0.000000] swsusp: Registered nosave memory region:
00000000000ce000 - 00000000000d0000
[    0.000000] swsusp: Registered nosave memory region:
00000000000d0000 - 00000000000dc000
[    0.000000] swsusp: Registered nosave memory region:
00000000000dc000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 250196
[    0.000000] Kernel command line:
root=UUID=b346f896-08b2-45c9-8a0c-eccfe46bcd21 ro vga=0x27e quiet
splash
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c046d000 soft=c0465000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1695.883 MHz processor.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.000000] ... MAX_LOCK_DEPTH:          30
[    0.000000] ... MAX_LOCKDEP_KEYS:        2048
[    0.000000] ... CLASSHASH_SIZE:           1024
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000000] ... CHAINHASH_SIZE:          8192
[    0.000000]  memory used by lock dependency info: 992 kB
[    0.000000]  per task-struct memory footprint: 1200 bytes
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 989180k/1014656k available (1762k kernel code,
24904k reserved, 1357k data, 304k init, 97152k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffedc000 - 0xfffff000   (1164 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000000]       .init : 0xc0410000 - 0xc045c000   ( 304 kB)
[    0.000000]       .data : 0xc02b89f2 - 0xc040bec4   (1357 kB)
[    0.000000]       .text : 0xc0100000 - 0xc02b89f2   (1762 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[    0.000000] SLUB: Genslabs=23, HWalign=64, Order=0-3,
MinObjects=16, Processors=1, Nodes=1
[    0.086666] Calibrating delay using timer specific routine..
3395.43 BogoMIPS (lpj=5656702)
[    0.086666] kswapd reclaim order set to 3
[    0.086666] Mount-cache hash table entries: 512
[    0.090000] CPU: After generic identify, caps: afe9fbbf 00000000
00000000 00000000 00000180 00000000 00000000
[    0.090000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.090000] CPU: L2 cache: 2048K
[    0.090000] CPU: After all inits, caps: afe9fbbf 00000000 00000000
00002040 00000180 00000000 00000000
[    0.090000] Intel machine check architecture supported.
[    0.090000] Intel machine check reporting enabled on CPU#0.
[    0.090000] Compat vDSO mapped to ffffe000.
[    0.090000] Checking 'hlt' instruction... OK.
[    0.103333] SMP alternatives: switching to UP code
[    0.103333] Freeing SMP alternatives: 9k freed
[    0.103333] ACPI: Core revision 20070126
[    0.116666] Parsing all Control Methods:
[    0.116666] Table [DSDT](id 0001) - 654 Objects with 50 Devices 163
Methods 17 Regions
[    0.116666] Parsing all Control Methods:
[    0.116666] Table [SSDT](id 0002) - 1 Objects with 0 Devices 1
Methods 0 Regions
[    0.116666] Parsing all Control Methods:
[    0.116666] Table [SSDT](id 0003) - 6 Objects with 0 Devices 3
Methods 0 Regions
[    0.116666]  tbxface-0587 [00] tb_load_namespace     : ACPI Tables
successfully acquired
[    0.119999] evxfevnt-0091 [00] enable                : Transition
to ACPI mode successful
[    0.120000] CPU0: Intel(R) Pentium(R) M processor 1.70GHz stepping 06
[    0.120000] Total of 1 processors activated (3395.43 BogoMIPS).
[    0.120000] ENABLING IO-APIC IRQs
[    0.120000] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.153333] Brought up 1 CPUs
[    0.153332] Booting paravirtualized kernel on bare hardware
[    0.154454] NET: Registered protocol family 16
[    0.156338] EISA bus registered
[    0.156486] ACPI: bus type pci registered
[    0.158336] PCI: PCI BIOS revision 2.10 entry at 0xfd9c2, last bus=2
[    0.158339] PCI: Using configuration type 1
[    0.158343] Setting up standard PCI resources
[    0.181851] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F
[_GPE] 4 regs on int 0x9
[    0.183140] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 6
Wake, Enabled 0 Runtime GPEs in this block
[    0.183513] Completing Region/Field/Buffer/Package
initialization:.....................................................
[    0.189057] Initialized 17/17 Regions 0/0 Fields 22/22 Buffers
14/23 Packages (670 nodes)
[    0.189061] Initializing Device/Processor/Thermal objects by
executing _INI methods:.
[    0.189488] Executed 1 _INI methods requiring 0 _STA executions
(examined 54 objects)
[    0.189514] ACPI: Interpreter enabled
[    0.189518] ACPI: (supports S0 S3 S4 S5)
[    0.189699] ACPI: Using IOAPIC for interrupt routing
[    0.212058] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.212195] PCI: Probing PCI hardware (bus 00)
[    0.212517] PCI: Scanning bus 0000:00
[    0.212689] PCI: Found 0000:00:00.0 [8086/3580] 000600 00
[    0.212692] PCI: Calling quirk c01e20aa for 0000:00:00.0
[    0.212748] PCI: Calling quirk c0424165 for 0000:00:00.0
[    0.212752] PCI: Calling quirk c0257a0e for 0000:00:00.0
[    0.212770] PCI: Found 0000:00:00.1 [8086/3584] 000880 00
[    0.212772] PCI: Calling quirk c01e20aa for 0000:00:00.1
[    0.212840] PCI: Calling quirk c0257a0e for 0000:00:00.1
[    0.212859] PCI: Found 0000:00:00.3 [8086/3585] 000880 00
[    0.212862] PCI: Calling quirk c01e20aa for 0000:00:00.3
[    0.212930] PCI: Calling quirk c0257a0e for 0000:00:00.3
[    0.212962] PCI: Found 0000:00:02.0 [8086/3582] 000300 00
[    0.212965] PCI: Calling quirk c01e20aa for 0000:00:02.0
[    0.213038] PCI: Calling quirk c0257a0e for 0000:00:02.0
[    0.213062] PCI: Found 0000:00:02.1 [8086/3582] 000380 00
[    0.213065] PCI: Calling quirk c01e20aa for 0000:00:02.1
[    0.213133] PCI: Calling quirk c0257a0e for 0000:00:02.1
[    0.213216] PCI: Found 0000:00:1d.0 [8086/24c2] 000c03 00
[    0.213219] PCI: Calling quirk c01e20aa for 0000:00:1d.0
[    0.213313] PCI: Calling quirk c0257a0e for 0000:00:1d.0
[    0.213333] PCI: Found 0000:00:1d.1 [8086/24c4] 000c03 00
[    0.213336] PCI: Calling quirk c01e20aa for 0000:00:1d.1
[    0.213430] PCI: Calling quirk c0257a0e for 0000:00:1d.1
[    0.213450] PCI: Found 0000:00:1d.2 [8086/24c7] 000c03 00
[    0.213452] PCI: Calling quirk c01e20aa for 0000:00:1d.2
[    0.213547] PCI: Calling quirk c0257a0e for 0000:00:1d.2
[    0.213591] PCI: Found 0000:00:1d.7 [8086/24cd] 000c03 00
[    0.213594] PCI: Calling quirk c01e20aa for 0000:00:1d.7
[    0.213697] PCI: Calling quirk c0257a0e for 0000:00:1d.7
[    0.213717] PCI: Found 0000:00:1e.0 [8086/2448] 000604 01
[    0.213720] PCI: Calling quirk c01e20aa for 0000:00:1e.0
[    0.213758] PCI: Calling quirk c0257a0e for 0000:00:1e.0
[    0.213777] PCI: Found 0000:00:1f.0 [8086/24cc] 000601 00
[    0.213780] PCI: Calling quirk c01e20aa for 0000:00:1f.0
[    0.213873] PCI: Calling quirk c01e2889 for 0000:00:1f.0
[    0.213876] PCI: Calling quirk c01e2465 for 0000:00:1f.0
[    0.213884] PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[    0.213889] PCI quirk: region 1180-11bf claimed by ICH4 GPIO
[    0.213892] PCI: Calling quirk c0257a0e for 0000:00:1f.0
[    0.213912] PCI: Found 0000:00:1f.1 [8086/24ca] 000101 00
[    0.213914] PCI: Calling quirk c01e20aa for 0000:00:1f.1
[    0.214017] PCI: Calling quirk c0257a0e for 0000:00:1f.1
[    0.214038] PCI: Found 0000:00:1f.3 [8086/24c3] 000c05 00
[    0.214041] PCI: Calling quirk c01e20aa for 0000:00:1f.3
[    0.214135] PCI: Calling quirk c0257a0e for 0000:00:1f.3
[    0.214165] PCI: Found 0000:00:1f.5 [8086/24c5] 000401 00
[    0.214168] PCI: Calling quirk c01e20aa for 0000:00:1f.5
[    0.214256] PCI: Calling quirk c0257a0e for 0000:00:1f.5
[    0.214284] PCI: Found 0000:00:1f.6 [8086/24c6] 000703 00
[    0.214286] PCI: Calling quirk c01e20aa for 0000:00:1f.6
[    0.214374] PCI: Calling quirk c0257a0e for 0000:00:1f.6
[    0.214379] PCI: Fixups for bus 0000:00
[    0.214384] PCI: Scanning behind PCI bridge 0000:00:1e.0, config
020200, pass 0
[    0.214398] PCI: Scanning bus 0000:02
[    0.214426] PCI: Found 0000:02:00.0 [10ec/8139] 000200 00
[    0.214551] PCI: Found 0000:02:06.0 [8086/4220] 000280 00
[    0.214553] PCI: Calling quirk c01e20aa for 0000:02:06.0
[    0.214646] PCI: Calling quirk c0257a0e for 0000:02:06.0
[    0.214678] PCI: Found 0000:02:09.0 [104c/8031] 000607 02
[    0.214728] PCI: Found 0000:02:09.2 [104c/8032] 000c00 00
[    0.214821] PCI: Calling quirk c0257bdd for 0000:02:09.2
[    0.214852] PCI: Found 0000:02:09.3 [104c/8033] 000180 00
[    0.214994] PCI: Found 0000:02:09.4 [104c/8034] 000805 00
[    0.215125] PCI: Fixups for bus 0000:02
[    0.215128] PCI: Transparent bridge - 0000:00:1e.0
[    0.215142] PCI: Scanning behind PCI bridge 0000:02:09.0, config
000000, pass 0
[    0.215158] PCI: Scanning behind PCI bridge 0000:02:09.0, config
000000, pass 1
[    0.215184] PCI: Bus #03 (-#06) is hidden behind transparent bridge
#02 (-#02) (try 'pci=assign-busses')
[    0.215187] Please report the result to linux-kernel to fix this permanently
[    0.215192] PCI: Bus scan for 0000:02 returning with max=06
[    0.215199] PCI: Scanning behind PCI bridge 0000:00:1e.0, config
020200, pass 1
[    0.215209] PCI: Bus scan for 0000:00 returning with max=06


# lspci -vvv
00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Region 0: Memory at <unassigned> (32-bit, prefetchable)
        Capabilities: [40] Vendor Specific Information

00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:02.0 VGA compatible controller: Intel Corporation 82852/855GM
Integrated Graphics Device (rev 02) (prog-if 00 [VGA])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
        Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at 1800 [size=8]
        Capabilities: [d0] Power Management version 1
                Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation 82852/855GM Integrated
Graphics Device (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Region 1: Memory at e0080000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: [d0] Power Management version 1
                Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03) (prog-if 00
[UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 4: I/O ports at 1820 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03) (prog-if 00
[UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 22
        Region 4: I/O ports at 1840 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03) (prog-if 00
[UHCI])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 21
        Region 4: I/O ports at 1860 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M)
USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 19
        Region 0: Memory at e0100000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR+
        Latency: 0
        Bus: primary=00, secondary=02, subordinate=06, sec-latency=64
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: e0200000-e02fffff
        Prefetchable memory behind bridge: 50000000-53ffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface
Bridge (rev 03)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE
Controller (rev 03) (prog-if 8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 21
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 1810 [size=16]
        Region 5: Memory at 54000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
SMBus Controller (rev 03)
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 5
        Region 4: I/O ports at 1880 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 1c00 [size=256]
        Region 1: I/O ports at 18c0 [size=64]
        Region 2: Memory at e0100c00 (32-bit, non-prefetchable) [size=512]
        Region 3: Memory at e0100800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 2400 [size=256]
        Region 1: I/O ports at 2000 [size=128]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 3000 [size=256]
        Region 1: Memory at e0207800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:06.0 Network controller: Intel Corporation PRO/Wireless 2200BG
Network Connection (rev 05)
        Subsystem: Hewlett-Packard Company Unknown device 12f5
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (750ns min, 6000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at e0206000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-

02:09.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e0209000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
        Memory window 0: 50000000-53fff000 (prefetchable)
        Memory window 1: 58000000-5bfff000
        I/O window 0: 00003400-000034ff
        I/O window 1: 00003800-000038ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

02:09.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE
1394 Host Controller (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (750ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 20
        Region 0: Memory at e0207000 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at e0200000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+

02:09.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
FlashMedia Controller
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e0204000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:09.4 Generic system peripheral [0805]: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
        Subsystem: Hewlett-Packard Company Unknown device 3080
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e0208400 (32-bit, non-prefetchable) [size=256]
        Region 1: Memory at e0208000 (32-bit, non-prefetchable) [size=256]
        Region 2: Memory at e0207c00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
