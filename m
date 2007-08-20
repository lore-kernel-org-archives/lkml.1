Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXHTGwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXHTGwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 02:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXHTGwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 02:52:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41390 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXHTGwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 02:52:04 -0400
Subject: Re: 2.6.23-rc3-hrt2 stall during boot on ASUS F3T (x86_64)
From: Peter Zijlstra <peterz@infradead.org>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070820104455.0dc7fe3d@localhost>
References: <20070820104455.0dc7fe3d@localhost>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 08:51:57 +0200
Message-Id: <1187592717.6114.170.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 10:44 +0400, Mikhail Kshevetskiy wrote:
> There are at list two serious delays:
> 
>   at 73.442744: I do nothing, the kernel continue to boot after 168 sec
> 
>   at 243.497822: After 2 hours i press and hold "shift" button to continue booting 
> 
> The dmesg output and my kernel configuration are listed below. 
> 
> I test i386 version of the same kernel with very similar configuration, it boot normally.
> 
> 
> 
> PS: please CC me, as I am not in list.

Please CC Thomas as he might miss it on the list.

> Mikhail Kshevetskiy
> 
> 
> 
> 
> dmesg output:
> =====================================
> [    0.000000] Linux version 2.6.23-rc3-hrt2 (root@aspid) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #8 SMP Fri Aug 17 12:34:42 MSD 2007
> [    0.000000] Command line: BOOT_IMAGE=2.6.23-rc3-hrt ro root=802 resume2=swap:/dev/sda1
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffa0000 (usable)
> [    0.000000]  BIOS-e820: 000000003ffa0000 - 000000003ffae000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003ffae000 - 000000003fff0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 262048) 1 entries of 256 used
> [    0.000000] end_pfn_map = 1048576
> [    0.000000] DMI 2.4 present.
> [    0.000000] ACPI: RSDP 000FBB20, 0014 (r0 ACPIAM)
> [    0.000000] ACPI: RSDT 3FFA0000, 0040 (r1 _ASUS_ Notebook  4000724 MSFT       97)
> [    0.000000] ACPI: FACP 3FFA0200, 0084 (r2 A M I  OEMFACP   4000724 MSFT       97)
> [    0.000000] ACPI: DSDT 3FFA05F0, 916E (r1  A0427 A0427000        0 INTL  2002026)
> [    0.000000] ACPI: FACS 3FFAE000, 0040
> [    0.000000] ACPI: APIC 3FFA0390, 0070 (r1 A M I  OEMAPIC   4000724 MSFT       97)
> [    0.000000] ACPI: MCFG 3FFA0400, 003C (r1 A M I  OEMMCFG   4000724 MSFT       97)
> [    0.000000] ACPI: BOOT 3FFA05C0, 0028 (r1 A M I  OEMBOOT   4000724 MSFT       97)
> [    0.000000] ACPI: SLIC 3FFA0440, 0176 (r1 _ASUS_ Notebook  4000724 MSFT       97)
> [    0.000000] ACPI: OEMB 3FFAE040, 0060 (r1 A M I  AMI_OEM   4000724 MSFT       97)
> [    0.000000] ACPI: HPET 3FFA9760, 0038 (r1 A M I  OEMHPET0  4000724 MSFT       97)
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 262048) 1 entries of 256 used
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   DMA32        4096 ->  1048576
> [    0.000000]   Normal    1048576 ->  1048576
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0:        0 ->      159
> [    0.000000]     0:      256 ->   262048
> [    0.000000] On node 0 totalpages: 261951
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 2200 pages reserved
> [    0.000000]   DMA zone: 1743 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 3526 pages used for memmap
> [    0.000000]   DMA32 zone: 254426 pages, LIFO batch:31
> [    0.000000]   Normal zone: 0 pages used for memmap
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] ACPI: PM-Timer IO Port: 0x508
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] Processor #1
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ14 used by override.
> [    0.000000] ACPI: IRQ15 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
> [    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
> [    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] PERCPU: Allocating 425608 bytes of per cpu data
> [    0.000000] Built 1 zonelists in Zone order.  Total pages: 256169
> [    0.000000] Kernel command line: BOOT_IMAGE=2.6.23-rc3-hrt ro root=802 resume2=swap:/dev/sda1
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] hpet clockevent registered
> [    0.000000] TSC calibrated against HPET
> [    0.000000] Marking TSC unstable due to TSCs unsynchronized
> [   69.334294] time.c: Detected 1607.314 MHz processor.
> [   69.342603] Console: colour VGA+ 80x25
> [   69.342612] console [tty0] enabled
> [   69.369218] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [   69.369856] ... MAX_LOCKDEP_SUBCLASSES:    8
> [   69.370199] ... MAX_LOCK_DEPTH:          30
> [   69.370542] ... MAX_LOCKDEP_KEYS:        2048
> [   69.370885] ... CLASSHASH_SIZE:           1024
> [   69.371228] ... MAX_LOCKDEP_ENTRIES:     8192
> [   69.371571] ... MAX_LOCKDEP_CHAINS:      16384
> [   69.371914] ... CHAINHASH_SIZE:          8192
> [   69.372268]  memory used by lock dependency info: 1712 kB
> [   69.372613]  per task-struct memory footprint: 2160 bytes
> [   69.372958] ------------------------
> [   69.373301] | Locking API testsuite:
> [   69.373643] ----------------------------------------------------------------------------
> [   69.374282]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [   69.374921]   --------------------------------------------------------------------------
> [   69.375563]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.377842]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.380127]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.382503]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.384886]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.387340]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.389809]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.392280]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.394494]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.396719]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   69.399013]   --------------------------------------------------------------------------
> [   69.399651]               recursive read-lock:             |  ok  |             |  ok  |
> [   69.400957]            recursive read-lock #2:             |  ok  |             |  ok  |
> [   69.402249]             mixed read-write-lock:             |  ok  |             |  ok  |
> [   69.403552]             mixed write-read-lock:             |  ok  |             |  ok  |
> [   69.404863]   --------------------------------------------------------------------------
> [   69.405498]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   69.406654]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   69.407814]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   69.408986]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   69.410493]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [   69.411649]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [   69.412819]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   69.413972]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   69.415130]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   69.416299]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   69.417459]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   69.418651]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   69.419843]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   69.421046]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   69.422237]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   69.423428]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   69.424633]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   69.425813]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   69.426996]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   69.428160]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   69.429340]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   69.430520]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   69.431703]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   69.432898]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   69.434085]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   69.435265]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   69.436467]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   69.437648]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   69.438836]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   69.440010]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   69.441204]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   69.442384]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   69.443572]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   69.444760]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   69.445939]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   69.447123]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   69.448329]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   69.449518]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   69.450712]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   69.451901]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   69.453110]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   69.454290]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   69.455478]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   69.456676]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   69.457871]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   69.459051]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   69.460237]       hard-irq read-recursion/123:  ok  |
> [   69.460906]       soft-irq read-recursion/123:  ok  |
> [   69.461565]       hard-irq read-recursion/132:  ok  |
> [   69.462220]       soft-irq read-recursion/132:  ok  |
> [   69.470001]       hard-irq read-recursion/213:  ok  |
> [   69.470656]       soft-irq read-recursion/213:  ok  |
> [   69.471314]       hard-irq read-recursion/231:  ok  |
> [   69.471968]       soft-irq read-recursion/231:  ok  |
> [   69.472640]       hard-irq read-recursion/312:  ok  |
> [   69.473642]       soft-irq read-recursion/312:  ok  |
> [   69.474300]       hard-irq read-recursion/321:  ok  |
> [   69.474956]       soft-irq read-recursion/321:  ok  |
> [   69.475614] -------------------------------------------------------
> [   69.475958] Good, all 218 testcases passed! |
> [   69.476313] ---------------------------------
> [   69.477410] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [   69.478605] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> [   69.479141] Checking aperture...
> [   69.479485] CPU 0: aperture @ 262000000 size 32 MB
> [   69.479829] Aperture too small (32 MB)
> [   69.490044] No AGP bridge found
> [   69.501507] Memory: 1002772k/1048192k available (2321k kernel code, 44700k reserved, 1356k data, 600k init)
> [   69.502230] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
> [   69.580233] Calibrating delay using timer specific routine.. 3218.88 BogoMIPS (lpj=6437764)
> [   69.581018] Security Framework v1.0.0 initialized
> [   69.581366] SELinux:  Disabled at boot.
> [   69.581710] Capability LSM initialized
> [   69.582098] Mount-cache hash table entries: 256
> [   69.583109] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [   69.583455] CPU: L2 Cache: 512K (64 bytes/line)
> [   69.583800] CPU: Physical Processor ID: 0
> [   69.584144] CPU: Processor Core ID: 0
> [   69.584533] lockdep: not fixing up alternatives.
> [   69.584877] ACPI: Core revision 20070126
> [   69.634505] Using local APIC timer interrupts.
> [   69.697061] APIC timer calibration result 12557153
> [   69.697064] Detected 12.557 MHz APIC timer.
> [   69.697779] lockdep: not fixing up alternatives.
> [   69.698245] Booting processor 1/2 APIC 0x1
> [   69.709047] Initializing CPU#1
> [   69.789784] Calibrating delay using timer specific routine.. 3214.65 BogoMIPS (lpj=6429306)
> [   69.789791] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [   69.789794] CPU: L2 Cache: 512K (64 bytes/line)
> [   69.789797] CPU: Physical Processor ID: 0
> [   69.789798] CPU: Processor Core ID: 1
> [   69.789910] AMD Turion(tm) 64 X2 Mobile Technology TL-52 stepping 02
> [   69.789641] Brought up 2 CPUs
> [   69.793858] NET: Registered protocol family 16
> [   69.794679] No dock devices found.
> [   69.795264] ACPI: bus type pci registered
> [   69.795814] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
> [   69.796159] PCI: Not using MMCONFIG.
> [   69.796503] PCI: Using configuration type 1
> [   69.803897] ACPI: EC: Look up EC in DSDT
> [   69.804144] ACPI: EC: GPE = 0x20, I/O: command/status = 0x66, data = 0x62
> [   69.877695] ACPI: Interpreter enabled
> [   69.878040] ACPI: (supports S0 S1 S3)
> [   69.878622] ACPI: Using IOAPIC for interrupt routing
> [   69.879574] Error attaching device data
> [   69.879925] Error attaching device data
> [   69.899002] ACPI: EC: GPE = 0x20, I/O: command/status = 0x66, data = 0x62
> [   69.899832] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [   69.903005] PCI: Transparent bridge - 0000:00:10.0
> [   69.903441] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [   69.903909] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
> [   69.904115] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
> [   69.904365] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [   69.935095] ACPI: PCI Interrupt Link [LNKA] (IRQs 16) *5
> [   69.936041] ACPI: PCI Interrupt Link [LNKB] (IRQs 17) *10
> [   69.936978] ACPI: PCI Interrupt Link [LNKC] (IRQs 16) *0, disabled.
> [   69.937974] ACPI: PCI Interrupt Link [LNKD] (IRQs 17) *0, disabled.
> [   69.938958] ACPI: PCI Interrupt Link [LNEA] (IRQs 18) *11
> [   69.939892] ACPI: PCI Interrupt Link [LNEB] (IRQs 19) *11
> [   69.940826] ACPI: PCI Interrupt Link [LNEC] (IRQs 5) *0, disabled.
> [   69.941846] ACPI: PCI Interrupt Link [LNED] (IRQs 11) *0, disabled.
> [   69.942831] ACPI: PCI Interrupt Link [LUB0] (IRQs 10) *11
> [   69.943766] ACPI: PCI Interrupt Link [LUB2] (IRQs 20) *7
> [   69.944701] ACPI: PCI Interrupt Link [LMAC] (IRQs 21) *5
> [   69.945647] ACPI: PCI Interrupt Link [LAZA] (IRQs 22) *5
> [   69.946582] ACPI: PCI Interrupt Link [LACI] (IRQs 22) *0, disabled.
> [   69.947569] ACPI: PCI Interrupt Link [LMC9] (IRQs 7) *0, disabled.
> [   69.948556] ACPI: PCI Interrupt Link [LSMB] (IRQs 7) *5
> [   69.949499] ACPI: PCI Interrupt Link [LPMU] (IRQs 7) *10
> [   69.950438] ACPI: PCI Interrupt Link [LSA0] (IRQs 23) *10
> [   69.951391] ACPI: PCI Interrupt Link [LSA1] (IRQs 23) *0, disabled.
> [   69.952541] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
> [   69.953569] Linux Plug and Play Support v0.97 (c) Adam Belay
> [   69.953981] pnp: PnP ACPI init
> [   69.954357] ACPI: bus type pnp registered
> [   69.960919] pnp: PnP ACPI: found 14 devices
> [   69.961266] ACPI: ACPI bus type pnp unregistered
> [   69.962033] usbcore: registered new interface driver usbfs
> [   69.962455] usbcore: registered new interface driver hub
> [   69.962916] usbcore: registered new device driver usb
> [   69.963684] PCI: Using ACPI for IRQ routing
> [   69.964031] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> [   70.177605] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> [   70.178146] hpet0: 3 32-bit timers, 25000000 Hz
> [   70.179650] ACPI: RTC can wake from S4
> [   70.241288] Time: hpet clocksource has been installed.
> [   70.242035] Switched to high resolution mode on CPU 1
> [   70.241664] Switched to high resolution mode on CPU 0
> [   70.433355] pnp: 00:07: ioport range 0x25c-0x25f has been reserved
> [   70.433715] pnp: 00:08: iomem range 0x0-0x0 could not be reserved
> [   70.434072] pnp: 00:09: iomem range 0x0-0x0 could not be reserved
> [   70.434427] pnp: 00:09: iomem range 0xfee01000-0xfeefffff has been reserved
> [   70.434786] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
> [   70.435425] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
> [   70.436074] pnp: 00:0c: iomem range 0xe0000000-0xe7ffffff has been reserved
> [   70.436434] pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
> [   70.436781] pnp: 00:0d: iomem range 0xc0000-0xcffff has been reserved
> [   70.437128] pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
> [   70.437491] pnp: 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
> [   70.438758] PCI: Bridge: 0000:00:02.0
> [   70.439103]   IO window: disabled.
> [   70.439449]   MEM window: dc700000-dc7fffff
> [   70.439795]   PREFETCH window: disabled.
> [   70.440141] PCI: Bridge: 0000:00:03.0
> [   70.440485]   IO window: d000-dfff
> [   70.440831]   MEM window: dc800000-dcffffff
> [   70.441177]   PREFETCH window: be000000-bfffffff
> [   70.441538] PCI: Bridge: 0000:00:04.0
> [   70.441882]   IO window: e000-efff
> [   70.442229]   MEM window: dd000000-dfefffff
> [   70.442577]   PREFETCH window: c0000000-cfffffff
> [   70.442925] PCI: Bridge: 0000:00:10.0
> [   70.443267]   IO window: disabled.
> [   70.443614]   MEM window: dff00000-dfffffff
> [   70.443959]   PREFETCH window: disabled.
> [   70.444326] PCI: Setting latency timer of device 0000:00:02.0 to 64
> [   70.444342] PCI: Setting latency timer of device 0000:00:03.0 to 64
> [   70.444358] PCI: Setting latency timer of device 0000:00:04.0 to 64
> [   70.444375] PCI: Setting latency timer of device 0000:00:10.0 to 64
> [   70.444398] NET: Registered protocol family 2
> [   71.009287] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
> [   71.010092] TCP established hash table entries: 32768 (order: 9, 2359296 bytes)
> [   71.014191] TCP bind hash table entries: 32768 (order: 9, 2097152 bytes)
> [   71.017851] TCP: Hash tables configured (established 32768 bind 32768)
> [   71.018235] TCP reno registered
> [   71.265498] checking if image is initramfs... it is
> [   73.413464] Freeing initrd memory: 19001k freed
> [   73.425098] Simple Boot Flag at 0x4c set to 0x1
> [   73.426611] microcode: CPU0 not a capable Intel processor
> [   73.427496] microcode: CPU1 not a capable Intel processor
> [   73.427850] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
> [   73.431077] Initializing RT-Tester: OK
> [   73.431524] audit: initializing netlink socket (disabled)
> [   73.431910] audit(1187343067.712:1): initialized
> [   73.438978] VFS: Disk quotas dquot_6.5.1
> [   73.439461] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [   73.440462] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> [   73.441446] io scheduler noop registered
> [   73.441790] io scheduler anticipatory registered
> [   73.442149] io scheduler deadline registered
> [   73.442744] io scheduler cfq registered (default)
> [  242.021230] Boot video device is 0000:04:00.0
> [  242.021643] PCI: Setting latency timer of device 0000:00:02.0 to 64
> [  242.021710] assign_interrupt_mode Found MSI capability
> [  242.022107] Allocate Port Service[0000:00:02.0:pcie00]
> [  242.022280] PCI: Setting latency timer of device 0000:00:03.0 to 64
> [  242.022345] assign_interrupt_mode Found MSI capability
> [  242.022735] Allocate Port Service[0000:00:03.0:pcie00]
> [  242.022899] PCI: Setting latency timer of device 0000:00:04.0 to 64
> [  242.022967] assign_interrupt_mode Found MSI capability
> [  242.023357] Allocate Port Service[0000:00:04.0:pcie00]
> [  242.023796] ALI M7101 PMU not found.
> [  242.024456] vga16fb: initializing
> [  242.024460] vga16fb: mapped to 0xffff8100000a0000
> [  242.294540] Console: switching to colour frame buffer device 80x30
> [  242.299539] fb0: VGA16 VGA frame buffer device
> [  242.300011] ACPI: AC Adapter [AC0] (on-line)
> [  242.300514] ACPI: Battery Slot [BAT0] (battery present)
> [  242.301040] input: Power Button (FF) as /devices/virtual/input/input0
> [  242.301302] ACPI: Power Button (FF) [PWRF]
> [  242.303745] input: Sleep Button (CM) as /devices/virtual/input/input1
> [  242.306283] ACPI: Sleep Button (CM) [SLPB]
> [  242.309214] input: Lid Switch as /devices/virtual/input/input2
> [  242.312255] ACPI: Lid Switch [LID]
> [  242.315650] input: Power Button (CM) as /devices/virtual/input/input3
> [  242.319239] ACPI: Power Button (CM) [PWRB]
> [  242.331823] set_level status: 0
> [  242.332065] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> [  242.336930] cpuidle: driver acpi_idle failed to attach to cpu 1
> [  242.341717] cpuidle: driver acpi_idle failed to attach to cpu 0
> [  242.352919] ACPI: Thermal Zone [TZ00] (60 C)
> [  242.367191] Real Time Clock Driver v1.12ac
> [  242.373090] hpet_resources: 0xfed00000 is busy
> [  242.373168] Linux agpgart interface v0.102
> [  242.378978] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> [  242.394224] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
> [  242.409879] asus-laptop: Asus Laptop Support version 0.42
> [  242.418775] asus-laptop:   F3T model detected
> [  242.449332] Registered led device: asus:mail
> [  242.458989] usbmon: debugfs is not available
> [  242.468402] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [  242.489548] i8042.c: Detected active multiplexing controller, rev 1.1.
> [  242.501052] serio: i8042 KBD port at 0x60,0x64 irq 1
> [  242.511439] serio: i8042 AUX0 port at 0x60,0x64 irq 12
> [  242.521642] serio: i8042 AUX1 port at 0x60,0x64 irq 12
> [  242.531849] serio: i8042 AUX2 port at 0x60,0x64 irq 12
> [  242.542016] serio: i8042 AUX3 port at 0x60,0x64 irq 12
> [  242.552385] mice: PS/2 mouse device common for all mice
> [  242.562542] cpuidle: using governor menu
> [  242.572850] TCP bic registered
> [  242.583146] NET: Registered protocol family 1
> [  242.593314] NET: Registered protocol family 17
> [  242.603491] powernow-k8: Found 1 AMD Turion(tm) 64 X2 Mobile Technology TL-52 processors (2 cpu cores) (version 2.00.00)
> [  242.624720] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
> [  242.624260] powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x13
> [  242.624264] powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x1e
> [  242.624640] powernow-k8: ph2 null fid transition 0x8
> [  242.624950] Freeing unused kernel memory: 600k freed
> [  243.169989] SCSI subsystem initialized
> [  243.179623] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> [  243.180330] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 10
> [  243.189540] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LUB0] -> GSI 10 (level, low) -> IRQ 10
> [  243.209198] PCI: Setting latency timer of device 0000:00:0b.0 to 64
> [  243.209206] ohci_hcd 0000:00:0b.0: OHCI Host Controller
> [  243.220000] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 1
> [  243.261842] ohci_hcd 0000:00:0b.0: irq 10, io mem 0xdc6be000
> [  243.281506] libata version 2.21 loaded.
> [  243.328197] usb usb1: configuration #1 chosen from 1 choice
> [  243.338681] hub 1-0:1.0: USB hub found
> [  243.349295] hub 1-0:1.0: 8 ports detected
> [  243.380180] forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
> [  243.462913] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
> [  243.474335] ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LMAC] -> GSI 21 (level, low) -> IRQ 21
> [  243.497811] PCI: Setting latency timer of device 0000:00:14.0 to 64
> [  243.497822] forcedeth: using HIGHDMA
> [ 8355.489027] usb 1-3: new low speed USB device using ohci_hcd and address 2
> [ 8355.503919] eth0: forcedeth.c: subsystem: 01043:1385 bound to 0000:00:14.0
> [ 8355.515882] sata_nv 0000:00:0e.0: version 3.4
> [ 8355.516451] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
> [ 8355.528184] ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
> [ 8355.551948] PCI: Setting latency timer of device 0000:00:0e.0 to 64
> [ 8355.552821] scsi0 : sata_nv
> [ 8355.564602] scsi1 : sata_nv
> [ 8355.576153] ata1: SATA max UDMA/133 cmd 0x000000000001c800 ctl 0x000000000001c482 bmdma 0x000000000001c000 irq 23
> [ 8355.599463] ata2: SATA max UDMA/133 cmd 0x000000000001c400 ctl 0x000000000001c082 bmdma 0x000000000001c008 irq 23
> [ 8355.815008] usb 1-3: configuration #1 chosen from 1 choice
> [ 8356.106310] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [ 8356.141678] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60R, max UDMA/100
> [ 8356.154092] ata1.00: 195371568 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [ 8356.174910] usb 1-7: new full speed USB device using ohci_hcd and address 3
> [ 8356.210229] ata1.00: configured for UDMA/100
> [ 8356.466396] usb 1-7: configuration #1 chosen from 1 choice
> [ 8356.587098] ata2: SATA link down (SStatus 0 SControl 300)
> [ 8356.610878] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00  MBZO PQ: 0 ANSI: 5
> [ 8356.636795] pata_amd 0000:00:0d.0: version 0.3.8
> [ 8356.636890] PCI: Setting latency timer of device 0000:00:0d.0 to 64
> [ 8356.636473] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
> [ 8356.637001] scsi2 : pata_amd
> [ 8356.637117] scsi3 : pata_amd
> [ 8356.637173] ata3: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001ffa0 irq 14
> [ 8356.637177] ata4: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001ffa8 irq 15
> [ 8356.639809] udev: renamed network interface eth0 to eth1
> [ 8356.730390] ACPI: PCI Interrupt 0000:05:01.0[A] -> Link [LNKA] -> GSI 16 (level, low) -> IRQ 16
> [ 8356.806377] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[16]  MMIO=[dfffe800-dfffefff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [ 8357.170753] ata4.00: ATAPI: HL-DT-ST DVDRAM GMA-4082N, HJ02, max UDMA/33
> [ 8357.410818] ata4.00: configured for UDMA/33
> [ 8357.426580] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRAM GMA-4082N HJ02 PQ: 0 ANSI: 5
> [ 8357.452182] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 20
> [ 8357.464904] ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [LUB2] -> GSI 20 (level, low) -> IRQ 20
> [ 8357.502914] PCI: Setting latency timer of device 0000:00:0b.1 to 64
> [ 8357.502923] ehci_hcd 0000:00:0b.1: EHCI Host Controller
> [ 8357.516863] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 2
> [ 8357.542401] ehci_hcd 0000:00:0b.1: debug port 1
> [ 8357.555527] PCI: cache line size of 64 is not supported by device 0000:00:0b.1
> [ 8357.555547] ehci_hcd 0000:00:0b.1: irq 20, io mem 0xdc6bfc00
> [ 8357.568489] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [ 8357.594089] usb 1-3: USB disconnect, address 2
> [ 8357.594866] usb usb2: configuration #1 chosen from 1 choice
> [ 8357.594930] hub 2-0:1.0: USB hub found
> [ 8357.595040] hub 2-0:1.0: 8 ports detected
> [ 8357.749105] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> [ 8357.761730] sd 0:0:0:0: [sda] Write Protect is off
> [ 8357.774507] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 8357.774592] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [ 8357.801446] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
> [ 8357.802195] usb 1-7: USB disconnect, address 3
> [ 8357.827331] sd 0:0:0:0: [sda] Write Protect is off
> [ 8357.839991] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [ 8357.842079] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [ 8357.867042]  sda:<6>usbcore: registered new interface driver hiddev
> [ 8358.132258] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e0180003715a18]
> [ 8358.237187]  sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
> [ 8358.331850] sd 0:0:0:0: [sda] Attached SCSI disk
> [ 8358.364226] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [ 8358.389063] Uniform CD-ROM driver Revision: 3.20
> [ 8358.401559] sr 3:0:0:0: Attached scsi CD-ROM sr0
> [ 8358.408739] usb 2-7: new high speed USB device using ehci_hcd and address 3
> [ 8358.430401] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [ 8358.443557] sr 3:0:0:0: Attached scsi generic sg1 type 5
> [ 8358.559828] usb 2-7: configuration #1 chosen from 1 choice
> [ 8358.574778] usbcore: registered new interface driver usbhid
> [ 8358.586623] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> [ 8358.913610] usb 1-3: new low speed USB device using ohci_hcd and address 4
> [ 8359.142333] usb 1-3: configuration #1 chosen from 1 choice
> [ 8359.163098] input: Logitech Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:0b.0/usb1/1-3/1-3:1.0/input/input5
> [ 8359.185735] input: USB HID v1.11 Mouse [Logitech Logitech USB Optical Mouse] on usb-0000:00:0b.0-3
> [ 8359.486620] Attempting manual resume
> [ 8359.534344] swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> [ 8359.534351] swsusp: Basic memory bitmaps created
> [ 8359.551846] swsusp: Basic memory bitmaps freed
> [ 8359.596338] ReiserFS: sda2: found reiserfs format "3.6" with standard journal
> [ 8359.606368] ReiserFS: sda2: using ordered data mode
> [ 8359.634682] ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [ 8359.666707] ReiserFS: sda2: checking transaction log (sda2)
> [ 8359.729473] ReiserFS: sda2: Using r5 hash to sort names
> [ 8363.511282] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x600
> [ 8363.531612] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x700
> [ 8434.904426] input: PC Speaker as /devices/platform/pcspkr/input/input6
> [ 8434.957483] sdhci: Secure Digital Host Controller Interface driver
> [ 8434.967648] sdhci: Copyright(c) Pierre Ossman
> [ 8434.977941] sdhci: SDHCI controller found at 0000:05:01.1 [1180:0822] (rev 19)
> [ 8434.999960] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
> [ 8434.999977] ACPI: PCI Interrupt 0000:05:01.1[B] -> Link [LNKB] -> GSI 17 (level, low) -> IRQ 17
> [ 8435.035618] mmc0: SDHCI at 0xdffff400 irq 17 DMA
> [ 8435.312834] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
> [ 8435.325281] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 22 (level, low) -> IRQ 22
> [ 8435.350239] PCI: Setting latency timer of device 0000:00:10.1 to 64
> [ 8435.379595] input: PS/2 Mouse as /devices/virtual/input/input7
> [ 8435.419726] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input8
> [ 8436.130549] Adding 1951856k swap on /dev/sda1.  Priority:-1 extents:1 across:1951856k
> [ 8440.404199] loop: module loaded
> [ 8440.526389] fuse init (API version 7.8)
> [ 8441.882353] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> [ 8454.214739] ReiserFS: sda5: found reiserfs format "3.6" with standard journal
> [ 8454.239058] ReiserFS: sda5: using ordered data mode
> [ 8454.257609] ReiserFS: sda5: journal params: device sda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [ 8454.294911] ReiserFS: sda5: checking transaction log (sda5)
> [ 8454.334842] ReiserFS: sda5: Using r5 hash to sort names
> [ 8454.362048] ReiserFS: sda6: found reiserfs format "3.6" with standard journal
> [ 8454.374773] ReiserFS: sda6: using ordered data mode
> [ 8454.392052] ReiserFS: sda6: journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [ 8454.432683] ReiserFS: sda6: checking transaction log (sda6)
> [ 8454.490892] ReiserFS: sda6: Using r5 hash to sort names
> [ 8454.559279] ReiserFS: sda7: found reiserfs format "3.6" with standard journal
> [ 8454.572331] ReiserFS: sda7: using ordered data mode
> [ 8454.592559] ReiserFS: sda7: journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [ 8454.634264] ReiserFS: sda7: checking transaction log (sda7)
> [ 8454.705760] ReiserFS: sda7: Using r5 hash to sort names
> [ 8454.768849] ReiserFS: sda8: found reiserfs format "3.6" with standard journal
> [ 8454.782975] ReiserFS: sda8: using ordered data mode
> [ 8454.857846] ReiserFS: sda8: journal params: device sda8, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [ 8454.901760] ReiserFS: sda8: checking transaction log (sda8)
> [ 8455.065718] ReiserFS: sda8: Using r5 hash to sort names
> [ 8457.459433] eth1: no link during initialization.
> [ 8461.967997] eth1: no link during initialization.
> [ 8463.525571] vbetool[3474]: segfault at 0000000000009405 rip 00000000004248df rsp 00007fff172a0c90 error 4
> [ 8465.081117] NET: Registered protocol family 10
> [ 8465.082143] lo: Disabled Privacy Extensions
> [ 8465.085371] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 8466.174773] eth1: no link during initialization.
> [ 8466.190016] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 8469.787484] eth1: no link during initialization.
> [ 8469.802447] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 8471.967679] lp: driver loaded but no devices found
> [ 8478.191868] Bluetooth: Core ver 2.11
> [ 8478.200629] NET: Registered protocol family 31
> [ 8478.209006] Bluetooth: HCI device and connection manager initialized
> [ 8478.217314] Bluetooth: HCI socket layer initialized
> [ 8478.260322] Bluetooth: L2CAP ver 2.8
> [ 8478.268273] Bluetooth: L2CAP socket layer initialized
> [ 8478.308306] Bluetooth: RFCOMM socket layer initialized
> [ 8478.316086] Bluetooth: RFCOMM TTY layer initialized
> [ 8478.323844] Bluetooth: RFCOMM ver 1.8
> 
> 
> 
> My kernel configuration
> =========================
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.23-rc3-hrt2
> # Fri Aug 17 12:33:48 2007
> #
> CONFIG_X86_64=y
> CONFIG_64BIT=y
> CONFIG_X86=y
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_NONIRQ_WAKEUP=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_ZONE_DMA32=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_SEMAPHORE_SLEEPERS=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_QUICKLIST=y
> CONFIG_NR_QUICK=2
> CONFIG_RWSEM_GENERIC_SPINLOCK=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_X86_CMPXCHG=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_DMI=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_GENERIC_BUG=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> 
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_TASKSTATS is not set
> # CONFIG_USER_NS is not set
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> # CONFIG_CPUSETS is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> CONFIG_MODVERSIONS=y
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> CONFIG_KMOD=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_BLK_DEV_BSG=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_AS is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> 
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_X86_PC=y
> # CONFIG_X86_VSMP is not set
> CONFIG_MK8=y
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_L1_CACHE_BYTES=64
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_INTERNODE_CACHE_BYTES=64
> CONFIG_X86_TSC=y
> CONFIG_X86_GOOD_APIC=y
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_MTRR=y
> CONFIG_SMP=y
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_BKL=y
> # CONFIG_NUMA is not set
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> # CONFIG_SPARSEMEM_STATIC is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_RESOURCES_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_NR_CPUS=2
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_IOMMU=y
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_SWIOTLB=y
> CONFIG_X86_MCE=y
> # CONFIG_X86_MCE_INTEL is not set
> CONFIG_X86_MCE_AMD=y
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_START=0x200000
> CONFIG_SECCOMP=y
> # CONFIG_CC_STACKPROTECTOR is not set
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_K8_NB=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_ISA_DMA_API=y
> CONFIG_GENERIC_PENDING_IRQ=y
> 
> #
> # Power management options
> #
> CONFIG_PM=y
> # CONFIG_PM_LEGACY is not set
> # CONFIG_PM_DEBUG is not set
> CONFIG_SUSPEND_SMP_POSSIBLE=y
> CONFIG_SUSPEND_SMP=y
> CONFIG_PM_SLEEP=y
> CONFIG_SUSPEND=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> # CONFIG_ACPI_BAY is not set
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> # CONFIG_CPU_FREQ_DEBUG is not set
> CONFIG_CPU_FREQ_STAT=m
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
> # CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> 
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_POWERNOW_K8=y
> CONFIG_X86_POWERNOW_K8_ACPI=y
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> 
> #
> # shared options
> #
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> # CONFIG_X86_SPEEDSTEP_LIB is not set
> 
> #
> # CPU idle PM support
> #
> CONFIG_CPU_IDLE=y
> 
> #
> # Governors
> #
> # CONFIG_CPU_IDLE_GOV_LADDER is not set
> CONFIG_CPU_IDLE_GOV_MENU=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=m
> # CONFIG_HOTPLUG_PCI_PCIE_POLL_EVENT_MODE is not set
> CONFIG_PCIEAER=y
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> CONFIG_HT_IRQ=y
> 
> #
> # PCCARD (PCMCIA/CardBus) support
> #
> CONFIG_PCCARD=m
> # CONFIG_PCMCIA_DEBUG is not set
> CONFIG_PCMCIA=m
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_PCMCIA_IOCTL=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_PD6729=m
> CONFIG_I82092=m
> CONFIG_PCCARD_NONSTATIC=m
> CONFIG_HOTPLUG_PCI=m
> CONFIG_HOTPLUG_PCI_FAKE=m
> CONFIG_HOTPLUG_PCI_ACPI=m
> CONFIG_HOTPLUG_PCI_ACPI_IBM=m
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> CONFIG_HOTPLUG_PCI_SHPC=m
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_BINFMT_MISC=m
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=y
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> 
> #
> # Networking
> #
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=m
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> CONFIG_NET_KEY=m
> # CONFIG_NET_KEY_MIGRATE is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=m
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=y
> CONFIG_TCP_CONG_CUBIC=m
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> CONFIG_TCP_CONG_HSTCP=m
> CONFIG_TCP_CONG_HYBLA=m
> CONFIG_TCP_CONG_VEGAS=m
> CONFIG_TCP_CONG_SCALABLE=m
> CONFIG_TCP_CONG_LP=m
> CONFIG_TCP_CONG_VENO=m
> CONFIG_TCP_CONG_YEAH=m
> CONFIG_TCP_CONG_ILLINOIS=m
> CONFIG_DEFAULT_BIC=y
> # CONFIG_DEFAULT_CUBIC is not set
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="bic"
> # CONFIG_TCP_MD5SIG is not set
> # CONFIG_IP_VS is not set
> CONFIG_IPV6=m
> CONFIG_IPV6_PRIVACY=y
> # CONFIG_IPV6_ROUTER_PREF is not set
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> CONFIG_INET6_IPCOMP=m
> # CONFIG_IPV6_MIP6 is not set
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_SIT=m
> CONFIG_IPV6_TUNNEL=m
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> # CONFIG_NETLABEL is not set
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_BRIDGE_NETFILTER=y
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK_ENABLED=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CT_PROTO_SCTP=m
> CONFIG_NF_CT_PROTO_UDPLITE=m
> CONFIG_NF_CONNTRACK_AMANDA=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_H323=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_PPTP=m
> CONFIG_NF_CONNTRACK_SANE=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NF_CT_NETLINK=m
> CONFIG_NETFILTER_XTABLES=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_SECMARK=m
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV4=m
> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
> CONFIG_IP_NF_QUEUE=m
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_IPRANGE=m
> CONFIG_IP_NF_MATCH_TOS=m
> CONFIG_IP_NF_MATCH_RECENT=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_MATCH_OWNER=m
> CONFIG_IP_NF_MATCH_ADDRTYPE=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_IP_NF_TARGET_SAME=m
> CONFIG_NF_NAT_SNMP_BASIC=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NF_NAT_AMANDA=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_NF_NAT_H323=m
> CONFIG_NF_NAT_SIP=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_TOS=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_TARGET_CLUSTERIP=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> 
> #
> # IPv6: Netfilter Configuration (EXPERIMENTAL)
> #
> CONFIG_NF_CONNTRACK_IPV6=m
> CONFIG_IP6_NF_QUEUE=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_IP6_NF_MATCH_RT=m
> CONFIG_IP6_NF_MATCH_OPTS=m
> CONFIG_IP6_NF_MATCH_FRAG=m
> CONFIG_IP6_NF_MATCH_HL=m
> CONFIG_IP6_NF_MATCH_OWNER=m
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> CONFIG_IP6_NF_MATCH_AH=m
> CONFIG_IP6_NF_MATCH_MH=m
> CONFIG_IP6_NF_MATCH_EUI64=m
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_LOG=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> CONFIG_IP6_NF_MANGLE=m
> CONFIG_IP6_NF_TARGET_HL=m
> CONFIG_IP6_NF_RAW=m
> 
> #
> # Bridge: Netfilter Configuration
> #
> CONFIG_BRIDGE_NF_EBTABLES=m
> CONFIG_BRIDGE_EBT_BROUTE=m
> CONFIG_BRIDGE_EBT_T_FILTER=m
> CONFIG_BRIDGE_EBT_T_NAT=m
> CONFIG_BRIDGE_EBT_802_3=m
> CONFIG_BRIDGE_EBT_AMONG=m
> CONFIG_BRIDGE_EBT_ARP=m
> CONFIG_BRIDGE_EBT_IP=m
> CONFIG_BRIDGE_EBT_LIMIT=m
> CONFIG_BRIDGE_EBT_MARK=m
> CONFIG_BRIDGE_EBT_PKTTYPE=m
> CONFIG_BRIDGE_EBT_STP=m
> CONFIG_BRIDGE_EBT_VLAN=m
> CONFIG_BRIDGE_EBT_ARPREPLY=m
> CONFIG_BRIDGE_EBT_DNAT=m
> CONFIG_BRIDGE_EBT_MARK_T=m
> CONFIG_BRIDGE_EBT_REDIRECT=m
> CONFIG_BRIDGE_EBT_SNAT=m
> CONFIG_BRIDGE_EBT_LOG=m
> CONFIG_BRIDGE_EBT_ULOG=m
> CONFIG_IP_DCCP=m
> CONFIG_INET_DCCP_DIAG=m
> CONFIG_IP_DCCP_ACKVEC=y
> 
> #
> # DCCP CCIDs Configuration (EXPERIMENTAL)
> #
> CONFIG_IP_DCCP_CCID2=m
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=m
> CONFIG_IP_DCCP_TFRC_LIB=m
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_CCID3_RTO=100
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_IP_SCTP=m
> # CONFIG_SCTP_DBG_MSG is not set
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_HMAC_NONE is not set
> # CONFIG_SCTP_HMAC_SHA1 is not set
> CONFIG_SCTP_HMAC_MD5=y
> CONFIG_TIPC=m
> CONFIG_TIPC_ADVANCED=y
> CONFIG_TIPC_ZONES=3
> CONFIG_TIPC_CLUSTERS=1
> CONFIG_TIPC_NODES=255
> CONFIG_TIPC_SLAVE_NODES=0
> CONFIG_TIPC_PORTS=8191
> CONFIG_TIPC_LOG=0
> # CONFIG_TIPC_DEBUG is not set
> # CONFIG_ATM is not set
> CONFIG_BRIDGE=m
> CONFIG_VLAN_8021Q=m
> # CONFIG_DECNET is not set
> CONFIG_LLC=m
> CONFIG_LLC2=m
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> 
> #
> # QoS and/or fair queueing
> #
> CONFIG_NET_SCHED=y
> CONFIG_NET_SCH_FIFO=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=m
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_RR=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
> CONFIG_NET_SCH_INGRESS=m
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_ROUTE=y
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=m
> CONFIG_NET_CLS_RSVP6=m
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=m
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=m
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> CONFIG_NET_ACT_IPT=m
> CONFIG_NET_ACT_PEDIT=m
> CONFIG_NET_ACT_SIMP=m
> # CONFIG_NET_CLS_POLICE is not set
> CONFIG_NET_CLS_IND=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> CONFIG_AX25=m
> # CONFIG_AX25_DAMA_SLAVE is not set
> CONFIG_NETROM=m
> CONFIG_ROSE=m
> 
> #
> # AX.25 network device drivers
> #
> CONFIG_MKISS=m
> CONFIG_6PACK=m
> CONFIG_BPQETHER=m
> CONFIG_BAYCOM_SER_FDX=m
> CONFIG_BAYCOM_SER_HDX=m
> CONFIG_BAYCOM_PAR=m
> CONFIG_YAM=m
> CONFIG_IRDA=m
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=m
> CONFIG_IRNET=m
> CONFIG_IRCOMM=m
> # CONFIG_IRDA_ULTRA is not set
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> CONFIG_IRDA_FAST_RR=y
> CONFIG_IRDA_DEBUG=y
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=m
> 
> #
> # Dongle support
> #
> CONFIG_DONGLE=y
> CONFIG_ESI_DONGLE=m
> CONFIG_ACTISYS_DONGLE=m
> CONFIG_TEKRAM_DONGLE=m
> CONFIG_TOIM3232_DONGLE=m
> CONFIG_LITELINK_DONGLE=m
> CONFIG_MA600_DONGLE=m
> CONFIG_GIRBIL_DONGLE=m
> CONFIG_MCP2120_DONGLE=m
> CONFIG_OLD_BELKIN_DONGLE=m
> CONFIG_ACT200L_DONGLE=m
> CONFIG_KINGSUN_DONGLE=m
> 
> #
> # Old SIR device drivers
> #
> 
> #
> # Old Serial dongle support
> #
> 
> #
> # FIR device drivers
> #
> CONFIG_USB_IRDA=m
> CONFIG_SIGMATEL_FIR=m
> CONFIG_NSC_FIR=m
> CONFIG_WINBOND_FIR=m
> CONFIG_SMC_IRCC_FIR=m
> CONFIG_ALI_FIR=m
> CONFIG_VLSI_FIR=m
> CONFIG_VIA_FIR=m
> CONFIG_MCS_FIR=m
> CONFIG_BT=m
> CONFIG_BT_L2CAP=m
> CONFIG_BT_SCO=m
> CONFIG_BT_RFCOMM=m
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=m
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_CMTP=m
> CONFIG_BT_HIDP=m
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIUSB=m
> CONFIG_BT_HCIUSB_SCO=y
> CONFIG_BT_HCIUART=m
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> CONFIG_BT_HCIBCM203X=m
> CONFIG_BT_HCIBPA10X=m
> CONFIG_BT_HCIBFUSB=m
> CONFIG_BT_HCIDTL1=m
> CONFIG_BT_HCIBT3C=m
> CONFIG_BT_HCIBLUECARD=m
> CONFIG_BT_HCIBTUART=m
> CONFIG_BT_HCIVHCI=m
> CONFIG_AF_RXRPC=m
> # CONFIG_AF_RXRPC_DEBUG is not set
> CONFIG_RXKAD=m
> CONFIG_FIB_RULES=y
> 
> #
> # Wireless
> #
> CONFIG_CFG80211=m
> CONFIG_WIRELESS_EXT=y
> CONFIG_MAC80211=m
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUG is not set
> CONFIG_IEEE80211=m
> # CONFIG_IEEE80211_DEBUG is not set
> CONFIG_IEEE80211_CRYPT_WEP=m
> CONFIG_IEEE80211_CRYPT_CCMP=m
> CONFIG_IEEE80211_CRYPT_TKIP=m
> CONFIG_IEEE80211_SOFTMAC=m
> # CONFIG_IEEE80211_SOFTMAC_DEBUG is not set
> CONFIG_RFKILL=m
> CONFIG_RFKILL_INPUT=m
> CONFIG_NET_9P=m
> # CONFIG_NET_9P_DEBUG is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=m
> CONFIG_MTD=m
> # CONFIG_MTD_DEBUG is not set
> CONFIG_MTD_CONCAT=m
> CONFIG_MTD_PARTITIONS=y
> CONFIG_MTD_REDBOOT_PARTS=m
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_CHAR=m
> CONFIG_MTD_BLKDEVS=m
> CONFIG_MTD_BLOCK=m
> CONFIG_MTD_BLOCK_RO=m
> CONFIG_FTL=m
> CONFIG_NFTL=m
> CONFIG_NFTL_RW=y
> CONFIG_INFTL=m
> CONFIG_RFD_FTL=m
> CONFIG_SSFDC=m
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=m
> CONFIG_MTD_JEDECPROBE=m
> CONFIG_MTD_GEN_PROBE=m
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=m
> CONFIG_MTD_CFI_AMDSTD=m
> CONFIG_MTD_CFI_STAA=m
> CONFIG_MTD_CFI_UTIL=m
> CONFIG_MTD_RAM=m
> CONFIG_MTD_ROM=m
> CONFIG_MTD_ABSENT=m
> 
> #
> # Mapping drivers for chip access
> #
> CONFIG_MTD_COMPLEX_MAPPINGS=y
> CONFIG_MTD_PHYSMAP=m
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0x4000000
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
> CONFIG_MTD_PNC2000=m
> CONFIG_MTD_SC520CDP=m
> CONFIG_MTD_NETSC520=m
> CONFIG_MTD_TS5500=m
> CONFIG_MTD_SBC_GXX=m
> CONFIG_MTD_AMD76XROM=m
> CONFIG_MTD_ICHXROM=m
> CONFIG_MTD_ESB2ROM=m
> CONFIG_MTD_CK804XROM=m
> CONFIG_MTD_SCB2_FLASH=m
> CONFIG_MTD_NETtel=m
> CONFIG_MTD_DILNETPC=m
> CONFIG_MTD_DILNETPC_BOOTSIZE=0x80000
> CONFIG_MTD_L440GX=m
> CONFIG_MTD_PCI=m
> CONFIG_MTD_PLATRAM=m
> 
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_PMC551=m
> # CONFIG_MTD_PMC551_BUGFIX is not set
> # CONFIG_MTD_PMC551_DEBUG is not set
> CONFIG_MTD_DATAFLASH=m
> CONFIG_MTD_M25P80=m
> CONFIG_MTD_SLRAM=m
> CONFIG_MTD_PHRAM=m
> CONFIG_MTD_MTDRAM=m
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTD_BLOCK2MTD=m
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOC2000=m
> CONFIG_MTD_DOC2001=m
> CONFIG_MTD_DOC2001PLUS=m
> CONFIG_MTD_DOCPROBE=m
> CONFIG_MTD_DOCECC=m
> # CONFIG_MTD_DOCPROBE_ADVANCED is not set
> CONFIG_MTD_DOCPROBE_ADDRESS=0
> CONFIG_MTD_NAND=m
> # CONFIG_MTD_NAND_VERIFY_WRITE is not set
> # CONFIG_MTD_NAND_ECC_SMC is not set
> CONFIG_MTD_NAND_MUSEUM_IDS=y
> CONFIG_MTD_NAND_IDS=m
> CONFIG_MTD_NAND_DISKONCHIP=m
> # CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
> CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
> # CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
> CONFIG_MTD_NAND_CAFE=m
> CONFIG_MTD_NAND_NANDSIM=m
> CONFIG_MTD_NAND_PLATFORM=m
> CONFIG_MTD_ONENAND=m
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> CONFIG_MTD_ONENAND_OTP=y
> 
> #
> # UBI - Unsorted block images
> #
> CONFIG_MTD_UBI=m
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_RESERVE=1
> CONFIG_MTD_UBI_GLUEBI=y
> 
> #
> # UBI debugging options
> #
> # CONFIG_MTD_UBI_DEBUG is not set
> CONFIG_PARPORT=m
> CONFIG_PARPORT_PC=m
> CONFIG_PARPORT_SERIAL=m
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> CONFIG_PARPORT_PC_PCMCIA=m
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=m
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_CRYPTOLOOP=m
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=65536
> CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
> CONFIG_CDROM_PKTCDVD=m
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> CONFIG_ATA_OVER_ETH=m
> CONFIG_MISC_DEVICES=y
> # CONFIG_IBM_ASM is not set
> CONFIG_PHANTOM=m
> CONFIG_EEPROM_93CX6=m
> CONFIG_SGI_IOC4=m
> CONFIG_TIFM_CORE=m
> CONFIG_TIFM_7XX1=m
> CONFIG_ASUS_LAPTOP=y
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=m
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=m
> CONFIG_CHR_DEV_ST=m
> CONFIG_CHR_DEV_OSST=m
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> 
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> CONFIG_SCSI_FC_ATTRS=m
> CONFIG_SCSI_ISCSI_ATTRS=m
> CONFIG_SCSI_SAS_ATTRS=m
> CONFIG_SCSI_SAS_LIBSAS=m
> # CONFIG_SCSI_SAS_ATA is not set
> CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=m
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_PPA is not set
> # CONFIG_SCSI_IMM is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_SRP is not set
> CONFIG_SCSI_LOWLEVEL_PCMCIA=y
> CONFIG_PCMCIA_FDOMAIN=m
> CONFIG_PCMCIA_QLOGIC=m
> CONFIG_PCMCIA_SYM53C500=m
> CONFIG_ATA=m
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_ATA_PIIX is not set
> # CONFIG_SATA_MV is not set
> CONFIG_SATA_NV=m
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SX4 is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIL24 is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_PATA_ALI is not set
> CONFIG_PATA_AMD=m
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> CONFIG_ATA_GENERIC=m
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_OPTIDMA is not set
> CONFIG_PATA_PCMCIA=m
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> CONFIG_MD_LINEAR=m
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> CONFIG_MD_RAID5_RESHAPE=y
> CONFIG_MD_MULTIPATH=m
> CONFIG_MD_FAULTY=m
> CONFIG_BLK_DEV_DM=m
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_MIRROR=m
> CONFIG_DM_ZERO=m
> CONFIG_DM_MULTIPATH=m
> CONFIG_DM_MULTIPATH_EMC=m
> CONFIG_DM_MULTIPATH_RDAC=m
> # CONFIG_DM_DELAY is not set
> 
> #
> # Fusion MPT device support
> #
> # CONFIG_FUSION is not set
> # CONFIG_FUSION_SPI is not set
> # CONFIG_FUSION_FC is not set
> # CONFIG_FUSION_SAS is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=m
> CONFIG_FIREWIRE_OHCI=m
> CONFIG_FIREWIRE_SBP2=m
> CONFIG_IEEE1394=m
> 
> #
> # Subsystem Options
> #
> # CONFIG_IEEE1394_VERBOSEDEBUG is not set
> 
> #
> # Controllers
> #
> CONFIG_IEEE1394_PCILYNX=m
> CONFIG_IEEE1394_OHCI1394=m
> 
> #
> # Protocols
> #
> CONFIG_IEEE1394_VIDEO1394=m
> CONFIG_IEEE1394_SBP2=m
> # CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
> CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
> CONFIG_IEEE1394_ETH1394=m
> CONFIG_IEEE1394_DV1394=m
> CONFIG_IEEE1394_RAWIO=m
> CONFIG_I2O=m
> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
> CONFIG_I2O_EXT_ADAPTEC=y
> CONFIG_I2O_EXT_ADAPTEC_DMA64=y
> CONFIG_I2O_CONFIG=m
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=m
> CONFIG_I2O_BLOCK=m
> CONFIG_I2O_SCSI=m
> CONFIG_I2O_PROC=m
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_NETDEVICES_MULTIQUEUE=y
> CONFIG_IFB=m
> CONFIG_DUMMY=m
> CONFIG_BONDING=m
> CONFIG_MACVLAN=m
> CONFIG_EQUALIZER=m
> CONFIG_TUN=m
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> CONFIG_PHYLIB=m
> 
> #
> # MII PHY device drivers
> #
> CONFIG_MARVELL_PHY=m
> CONFIG_DAVICOM_PHY=m
> CONFIG_QSEMI_PHY=m
> CONFIG_LXT_PHY=m
> CONFIG_CICADA_PHY=m
> CONFIG_VITESSE_PHY=m
> CONFIG_SMSC_PHY=m
> CONFIG_BROADCOM_PHY=m
> CONFIG_ICPLUS_PHY=m
> CONFIG_FIXED_PHY=m
> # CONFIG_FIXED_MII_10_FDX is not set
> # CONFIG_FIXED_MII_100_FDX is not set
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=m
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_NET_TULIP is not set
> # CONFIG_HP100 is not set
> CONFIG_NET_PCI=y
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_B44 is not set
> CONFIG_FORCEDETH=m
> CONFIG_FORCEDETH_NAPI=y
> # CONFIG_DGRS is not set
> # CONFIG_EEPRO100 is not set
> # CONFIG_E100 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> # CONFIG_NET_POCKET is not set
> # CONFIG_NETDEV_1000 is not set
> # CONFIG_NETDEV_10000 is not set
> CONFIG_MLX4_CORE=m
> # CONFIG_TR is not set
> 
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> # CONFIG_WLAN_80211 is not set
> 
> #
> # USB Network Adapters
> #
> CONFIG_USB_CATC=m
> CONFIG_USB_KAWETH=m
> CONFIG_USB_PEGASUS=m
> CONFIG_USB_RTL8150=m
> CONFIG_USB_USBNET_MII=m
> CONFIG_USB_USBNET=m
> CONFIG_USB_NET_AX8817X=m
> CONFIG_USB_NET_CDCETHER=m
> CONFIG_USB_NET_DM9601=m
> CONFIG_USB_NET_GL620A=m
> CONFIG_USB_NET_NET1080=m
> CONFIG_USB_NET_PLUSB=m
> CONFIG_USB_NET_MCS7830=m
> CONFIG_USB_NET_RNDIS_HOST=m
> CONFIG_USB_NET_CDC_SUBSET=m
> CONFIG_USB_ALI_M5632=y
> CONFIG_USB_AN2720=y
> CONFIG_USB_BELKIN=y
> CONFIG_USB_ARMLINUX=y
> CONFIG_USB_EPSON2888=y
> CONFIG_USB_KC2190=y
> CONFIG_USB_NET_ZAURUS=m
> # CONFIG_NET_PCMCIA is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PLIP is not set
> CONFIG_PPP=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_MPPE=m
> CONFIG_PPPOE=m
> CONFIG_PPPOL2TP=m
> CONFIG_SLIP=m
> CONFIG_SLIP_COMPRESSED=y
> CONFIG_SLHC=m
> CONFIG_SLIP_SMART=y
> # CONFIG_SLIP_MODE_SLIP6 is not set
> CONFIG_NET_FC=y
> # CONFIG_SHAPER is not set
> CONFIG_NETCONSOLE=m
> CONFIG_NETPOLL=y
> # CONFIG_NETPOLL_TRAP is not set
> CONFIG_NET_POLL_CONTROLLER=y
> CONFIG_ISDN=m
> CONFIG_ISDN_I4L=m
> CONFIG_ISDN_PPP=y
> CONFIG_ISDN_PPP_VJ=y
> CONFIG_ISDN_MPP=y
> CONFIG_IPPP_FILTER=y
> CONFIG_ISDN_PPP_BSDCOMP=m
> CONFIG_ISDN_AUDIO=y
> CONFIG_ISDN_TTY_FAX=y
> 
> #
> # ISDN feature submodules
> #
> CONFIG_ISDN_DIVERSION=m
> 
> #
> # ISDN4Linux hardware drivers
> #
> 
> #
> # Passive cards
> #
> CONFIG_ISDN_DRV_HISAX=m
> 
> #
> # D-channel protocol features
> #
> CONFIG_HISAX_EURO=y
> CONFIG_DE_AOC=y
> # CONFIG_HISAX_NO_SENDCOMPLETE is not set
> # CONFIG_HISAX_NO_LLC is not set
> # CONFIG_HISAX_NO_KEYPAD is not set
> CONFIG_HISAX_1TR6=y
> CONFIG_HISAX_NI1=y
> CONFIG_HISAX_MAX_CARDS=8
> 
> #
> # HiSax supported cards
> #
> CONFIG_HISAX_16_3=y
> CONFIG_HISAX_TELESPCI=y
> CONFIG_HISAX_S0BOX=y
> CONFIG_HISAX_FRITZPCI=y
> CONFIG_HISAX_AVM_A1_PCMCIA=y
> CONFIG_HISAX_ELSA=y
> CONFIG_HISAX_DIEHLDIVA=y
> CONFIG_HISAX_SEDLBAUER=y
> CONFIG_HISAX_NETJET=y
> CONFIG_HISAX_NETJET_U=y
> CONFIG_HISAX_NICCY=y
> CONFIG_HISAX_BKM_A4T=y
> CONFIG_HISAX_SCT_QUADRO=y
> CONFIG_HISAX_GAZEL=y
> CONFIG_HISAX_HFC_PCI=y
> CONFIG_HISAX_W6692=y
> CONFIG_HISAX_HFC_SX=y
> CONFIG_HISAX_ENTERNOW_PCI=y
> # CONFIG_HISAX_DEBUG is not set
> 
> #
> # HiSax PCMCIA card service modules
> #
> CONFIG_HISAX_SEDLBAUER_CS=m
> CONFIG_HISAX_ELSA_CS=m
> CONFIG_HISAX_AVM_A1_CS=m
> CONFIG_HISAX_TELES_CS=m
> 
> #
> # HiSax sub driver modules
> #
> CONFIG_HISAX_ST5481=m
> CONFIG_HISAX_HFCUSB=m
> CONFIG_HISAX_HFC4S8S=m
> CONFIG_HISAX_FRITZ_PCIPNP=m
> CONFIG_HISAX_HDLC=y
> 
> #
> # Active cards
> #
> CONFIG_ISDN_DRV_GIGASET=m
> CONFIG_GIGASET_BASE=m
> CONFIG_GIGASET_M105=m
> CONFIG_GIGASET_M101=m
> # CONFIG_GIGASET_DEBUG is not set
> # CONFIG_GIGASET_UNDOCREQ is not set
> CONFIG_ISDN_CAPI=m
> CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
> CONFIG_CAPI_TRACE=y
> CONFIG_ISDN_CAPI_MIDDLEWARE=y
> CONFIG_ISDN_CAPI_CAPI20=m
> CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
> CONFIG_ISDN_CAPI_CAPIFS=m
> CONFIG_ISDN_CAPI_CAPIDRV=m
> 
> #
> # CAPI hardware drivers
> #
> CONFIG_CAPI_AVM=y
> CONFIG_ISDN_DRV_AVMB1_B1PCI=m
> CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
> CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
> CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
> CONFIG_ISDN_DRV_AVMB1_T1PCI=m
> CONFIG_ISDN_DRV_AVMB1_C4=m
> CONFIG_CAPI_EICON=y
> CONFIG_ISDN_DIVAS=m
> CONFIG_ISDN_DIVAS_BRIPCI=y
> CONFIG_ISDN_DIVAS_PRIPCI=y
> CONFIG_ISDN_DIVAS_DIVACAPI=m
> CONFIG_ISDN_DIVAS_USERIDI=m
> CONFIG_ISDN_DIVAS_MAINT=m
> CONFIG_PHONE=m
> CONFIG_PHONE_IXJ=m
> CONFIG_PHONE_IXJ_PCMCIA=m
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=m
> CONFIG_INPUT_TSDEV=m
> CONFIG_INPUT_TSDEV_SCREEN_X=240
> CONFIG_INPUT_TSDEV_SCREEN_Y=320
> CONFIG_INPUT_EVDEV=m
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_SUNKBD=m
> CONFIG_KEYBOARD_LKKBD=m
> CONFIG_KEYBOARD_XTKBD=m
> CONFIG_KEYBOARD_NEWTON=m
> CONFIG_KEYBOARD_STOWAWAY=m
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=m
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_MOUSE_PS2_TOUCHKIT=y
> CONFIG_MOUSE_SERIAL=m
> CONFIG_MOUSE_APPLETOUCH=m
> CONFIG_MOUSE_VSXXXAA=m
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=m
> CONFIG_JOYSTICK_A3D=m
> CONFIG_JOYSTICK_ADI=m
> CONFIG_JOYSTICK_COBRA=m
> CONFIG_JOYSTICK_GF2K=m
> CONFIG_JOYSTICK_GRIP=m
> CONFIG_JOYSTICK_GRIP_MP=m
> CONFIG_JOYSTICK_GUILLEMOT=m
> CONFIG_JOYSTICK_INTERACT=m
> CONFIG_JOYSTICK_SIDEWINDER=m
> CONFIG_JOYSTICK_TMDC=m
> CONFIG_JOYSTICK_IFORCE=m
> CONFIG_JOYSTICK_IFORCE_USB=y
> CONFIG_JOYSTICK_IFORCE_232=y
> CONFIG_JOYSTICK_WARRIOR=m
> CONFIG_JOYSTICK_MAGELLAN=m
> CONFIG_JOYSTICK_SPACEORB=m
> CONFIG_JOYSTICK_SPACEBALL=m
> CONFIG_JOYSTICK_STINGER=m
> CONFIG_JOYSTICK_TWIDJOY=m
> CONFIG_JOYSTICK_DB9=m
> CONFIG_JOYSTICK_GAMECON=m
> CONFIG_JOYSTICK_TURBOGRAFX=m
> CONFIG_JOYSTICK_JOYDUMP=m
> CONFIG_JOYSTICK_XPAD=m
> CONFIG_JOYSTICK_XPAD_FF=y
> CONFIG_JOYSTICK_XPAD_LEDS=y
> CONFIG_INPUT_TABLET=y
> CONFIG_TABLET_USB_ACECAD=m
> CONFIG_TABLET_USB_AIPTEK=m
> CONFIG_TABLET_USB_GTCO=m
> CONFIG_TABLET_USB_KBTAB=m
> CONFIG_TABLET_USB_WACOM=m
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_ADS7846=m
> CONFIG_TOUCHSCREEN_FUJITSU=m
> CONFIG_TOUCHSCREEN_GUNZE=m
> CONFIG_TOUCHSCREEN_ELO=m
> CONFIG_TOUCHSCREEN_MTOUCH=m
> CONFIG_TOUCHSCREEN_MK712=m
> CONFIG_TOUCHSCREEN_PENMOUNT=m
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
> CONFIG_TOUCHSCREEN_TOUCHWIN=m
> CONFIG_TOUCHSCREEN_UCB1400=m
> CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
> CONFIG_TOUCHSCREEN_USB_EGALAX=y
> CONFIG_TOUCHSCREEN_USB_PANJIT=y
> CONFIG_TOUCHSCREEN_USB_3M=y
> CONFIG_TOUCHSCREEN_USB_ITM=y
> CONFIG_TOUCHSCREEN_USB_ETURBO=y
> CONFIG_TOUCHSCREEN_USB_GUNZE=y
> CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
> CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_PCSPKR=m
> CONFIG_INPUT_ATLAS_BTNS=m
> CONFIG_INPUT_ATI_REMOTE=m
> CONFIG_INPUT_ATI_REMOTE2=m
> CONFIG_INPUT_KEYSPAN_REMOTE=m
> CONFIG_INPUT_POWERMATE=m
> CONFIG_INPUT_YEALINK=m
> CONFIG_INPUT_UINPUT=m
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> CONFIG_SERIO_CT82C710=m
> CONFIG_SERIO_PARKBD=m
> CONFIG_SERIO_PCIPS2=m
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> CONFIG_GAMEPORT=m
> CONFIG_GAMEPORT_NS558=m
> CONFIG_GAMEPORT_L4=m
> CONFIG_GAMEPORT_EMU10K1=m
> CONFIG_GAMEPORT_FM801=m
> 
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> # CONFIG_SERIAL_NONSTANDARD is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CS=m
> CONFIG_SERIAL_8250_NR_UARTS=16
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=m
> CONFIG_UNIX98_PTYS=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=16
> CONFIG_PRINTER=m
> # CONFIG_LP_CONSOLE is not set
> # CONFIG_PPDEV is not set
> # CONFIG_TIPAR is not set
> CONFIG_IPMI_HANDLER=m
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=m
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=m
> # CONFIG_WATCHDOG is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_INTEL is not set
> # CONFIG_HW_RANDOM_AMD is not set
> CONFIG_NVRAM=m
> CONFIG_RTC=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> # CONFIG_AGP_INTEL is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_VIA is not set
> CONFIG_DRM=m
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=m
> CONFIG_CARDMAN_4000=m
> CONFIG_CARDMAN_4040=m
> # CONFIG_MWAVE is not set
> CONFIG_PC8736x_GPIO=m
> CONFIG_NSC_GPIO=m
> # CONFIG_RAW_DRIVER is not set
> CONFIG_HPET=y
> # CONFIG_HPET_RTC_IRQ is not set
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=m
> # CONFIG_TCG_TPM is not set
> CONFIG_TELCLOCK=m
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_CHARDEV=m
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=m
> CONFIG_I2C_ALGOPCA=m
> 
> #
> # I2C Hardware Bus support
> #
> CONFIG_I2C_ALI1535=m
> CONFIG_I2C_ALI1563=m
> CONFIG_I2C_ALI15X3=m
> CONFIG_I2C_AMD756=m
> CONFIG_I2C_AMD756_S4882=m
> CONFIG_I2C_AMD8111=m
> CONFIG_I2C_I801=m
> CONFIG_I2C_I810=m
> CONFIG_I2C_PIIX4=m
> CONFIG_I2C_NFORCE2=m
> CONFIG_I2C_OCORES=m
> CONFIG_I2C_PARPORT=m
> CONFIG_I2C_PARPORT_LIGHT=m
> CONFIG_I2C_PROSAVAGE=m
> CONFIG_I2C_SAVAGE4=m
> CONFIG_I2C_SIMTEC=m
> CONFIG_I2C_SIS5595=m
> CONFIG_I2C_SIS630=m
> CONFIG_I2C_SIS96X=m
> CONFIG_I2C_TAOS_EVM=m
> CONFIG_I2C_STUB=m
> CONFIG_I2C_TINY_USB=m
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
> CONFIG_I2C_VOODOO3=m
> 
> #
> # Miscellaneous I2C Chip support
> #
> CONFIG_SENSORS_DS1337=m
> CONFIG_SENSORS_DS1374=m
> CONFIG_DS1682=m
> CONFIG_SENSORS_EEPROM=m
> CONFIG_SENSORS_PCF8574=m
> CONFIG_SENSORS_PCA9539=m
> CONFIG_SENSORS_PCF8591=m
> CONFIG_SENSORS_MAX6875=m
> CONFIG_SENSORS_TSL2550=m
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> 
> #
> # SPI support
> #
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_BITBANG=m
> CONFIG_SPI_BUTTERFLY=m
> CONFIG_SPI_LM70_LLP=m
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_AT25=m
> CONFIG_SPI_SPIDEV=m
> CONFIG_SPI_TLE62X0=m
> CONFIG_W1=m
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=m
> CONFIG_W1_MASTER_DS2490=m
> CONFIG_W1_MASTER_DS2482=m
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=m
> CONFIG_W1_SLAVE_SMEM=m
> CONFIG_W1_SLAVE_DS2433=m
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
> CONFIG_W1_SLAVE_DS2760=m
> CONFIG_POWER_SUPPLY=m
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=m
> CONFIG_BATTERY_DS2760=m
> CONFIG_HWMON=m
> CONFIG_HWMON_VID=m
> CONFIG_SENSORS_ABITUGURU=m
> CONFIG_SENSORS_ABITUGURU3=m
> CONFIG_SENSORS_AD7418=m
> CONFIG_SENSORS_ADM1021=m
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> CONFIG_SENSORS_ADM9240=m
> CONFIG_SENSORS_K8TEMP=m
> CONFIG_SENSORS_ASB100=m
> CONFIG_SENSORS_ATXP1=m
> CONFIG_SENSORS_DS1621=m
> CONFIG_SENSORS_F71805F=m
> CONFIG_SENSORS_FSCHER=m
> CONFIG_SENSORS_FSCPOS=m
> CONFIG_SENSORS_GL518SM=m
> CONFIG_SENSORS_GL520SM=m
> CONFIG_SENSORS_CORETEMP=m
> CONFIG_SENSORS_IT87=m
> CONFIG_SENSORS_LM63=m
> CONFIG_SENSORS_LM70=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=m
> CONFIG_SENSORS_LM85=m
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_MAX1619=m
> CONFIG_SENSORS_MAX6650=m
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> CONFIG_SENSORS_SIS5595=m
> CONFIG_SENSORS_DME1737=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=m
> CONFIG_SENSORS_THMC50=m
> CONFIG_SENSORS_VIA686A=m
> CONFIG_SENSORS_VT1211=m
> CONFIG_SENSORS_VT8231=m
> CONFIG_SENSORS_W83781D=m
> CONFIG_SENSORS_W83791D=m
> CONFIG_SENSORS_W83792D=m
> CONFIG_SENSORS_W83793=m
> CONFIG_SENSORS_W83L785TS=m
> CONFIG_SENSORS_W83627HF=m
> CONFIG_SENSORS_W83627EHF=m
> CONFIG_SENSORS_HDAPS=m
> CONFIG_SENSORS_APPLESMC=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_SM501 is not set
> 
> #
> # Multimedia devices
> #
> CONFIG_VIDEO_DEV=m
> CONFIG_VIDEO_V4L1=y
> CONFIG_VIDEO_V4L1_COMPAT=y
> CONFIG_VIDEO_V4L2=y
> CONFIG_VIDEO_CAPTURE_DRIVERS=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
> CONFIG_VIDEO_TVAUDIO=m
> CONFIG_VIDEO_TDA7432=m
> CONFIG_VIDEO_TDA9840=m
> CONFIG_VIDEO_TDA9875=m
> CONFIG_VIDEO_TEA6415C=m
> CONFIG_VIDEO_TEA6420=m
> CONFIG_VIDEO_MSP3400=m
> CONFIG_VIDEO_CS53L32A=m
> CONFIG_VIDEO_WM8775=m
> CONFIG_VIDEO_WM8739=m
> CONFIG_VIDEO_BT819=m
> CONFIG_VIDEO_BT856=m
> CONFIG_VIDEO_KS0127=m
> CONFIG_VIDEO_OV7670=m
> CONFIG_VIDEO_SAA7110=m
> CONFIG_VIDEO_SAA7111=m
> CONFIG_VIDEO_SAA7114=m
> CONFIG_VIDEO_SAA711X=m
> CONFIG_VIDEO_TVP5150=m
> CONFIG_VIDEO_VPX3220=m
> CONFIG_VIDEO_CX25840=m
> CONFIG_VIDEO_CX2341X=m
> CONFIG_VIDEO_SAA7127=m
> CONFIG_VIDEO_SAA7185=m
> CONFIG_VIDEO_ADV7170=m
> CONFIG_VIDEO_ADV7175=m
> CONFIG_VIDEO_UPD64031A=m
> CONFIG_VIDEO_UPD64083=m
> CONFIG_VIDEO_VIVI=m
> CONFIG_VIDEO_BT848=m
> CONFIG_VIDEO_BT848_DVB=y
> CONFIG_VIDEO_SAA6588=m
> CONFIG_VIDEO_BWQCAM=m
> CONFIG_VIDEO_CQCAM=m
> CONFIG_VIDEO_W9966=m
> CONFIG_VIDEO_CPIA=m
> CONFIG_VIDEO_CPIA_PP=m
> CONFIG_VIDEO_CPIA_USB=m
> CONFIG_VIDEO_CPIA2=m
> CONFIG_VIDEO_SAA5246A=m
> CONFIG_VIDEO_SAA5249=m
> CONFIG_TUNER_3036=m
> CONFIG_TUNER_TEA5761=y
> CONFIG_VIDEO_STRADIS=m
> CONFIG_VIDEO_ZORAN_ZR36060=m
> CONFIG_VIDEO_ZORAN=m
> CONFIG_VIDEO_ZORAN_BUZ=m
> CONFIG_VIDEO_ZORAN_DC10=m
> CONFIG_VIDEO_ZORAN_DC30=m
> CONFIG_VIDEO_ZORAN_LML33=m
> CONFIG_VIDEO_ZORAN_LML33R10=m
> CONFIG_VIDEO_ZORAN_AVS6EYES=m
> CONFIG_VIDEO_SAA7134=m
> CONFIG_VIDEO_SAA7134_ALSA=m
> CONFIG_VIDEO_SAA7134_DVB=m
> CONFIG_VIDEO_MXB=m
> CONFIG_VIDEO_DPC=m
> CONFIG_VIDEO_HEXIUM_ORION=m
> CONFIG_VIDEO_HEXIUM_GEMINI=m
> CONFIG_VIDEO_CX88=m
> CONFIG_VIDEO_CX88_ALSA=m
> CONFIG_VIDEO_CX88_BLACKBIRD=m
> CONFIG_VIDEO_CX88_DVB=m
> CONFIG_VIDEO_CX88_VP3054=m
> CONFIG_VIDEO_IVTV=m
> CONFIG_VIDEO_CAFE_CCIC=m
> CONFIG_V4L_USB_DRIVERS=y
> CONFIG_VIDEO_PVRUSB2=m
> # CONFIG_VIDEO_PVRUSB2_29XXX is not set
> CONFIG_VIDEO_PVRUSB2_24XXX=y
> CONFIG_VIDEO_PVRUSB2_SYSFS=y
> # CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
> CONFIG_VIDEO_EM28XX=m
> CONFIG_VIDEO_USBVISION=m
> CONFIG_VIDEO_USBVIDEO=m
> CONFIG_USB_VICAM=m
> CONFIG_USB_IBMCAM=m
> CONFIG_USB_KONICAWC=m
> CONFIG_USB_QUICKCAM_MESSENGER=m
> CONFIG_USB_ET61X251=m
> CONFIG_VIDEO_OVCAMCHIP=m
> CONFIG_USB_W9968CF=m
> CONFIG_USB_OV511=m
> CONFIG_USB_SE401=m
> CONFIG_USB_SN9C102=m
> CONFIG_USB_STV680=m
> CONFIG_USB_ZC0301=m
> CONFIG_USB_PWC=m
> # CONFIG_USB_PWC_DEBUG is not set
> CONFIG_USB_ZR364XX=m
> CONFIG_RADIO_ADAPTERS=y
> CONFIG_RADIO_GEMTEK_PCI=m
> CONFIG_RADIO_MAXIRADIO=m
> CONFIG_RADIO_MAESTRO=m
> CONFIG_USB_DSBR=m
> CONFIG_DVB_CORE=m
> CONFIG_DVB_CORE_ATTACH=y
> CONFIG_DVB_CAPTURE_DRIVERS=y
> 
> #
> # Supported SAA7146 based PCI Adapters
> #
> CONFIG_DVB_AV7110=m
> CONFIG_DVB_AV7110_OSD=y
> CONFIG_DVB_BUDGET=m
> CONFIG_DVB_BUDGET_CI=m
> CONFIG_DVB_BUDGET_AV=m
> CONFIG_DVB_BUDGET_PATCH=m
> 
> #
> # Supported USB Adapters
> #
> CONFIG_DVB_USB=m
> # CONFIG_DVB_USB_DEBUG is not set
> CONFIG_DVB_USB_A800=m
> CONFIG_DVB_USB_DIBUSB_MB=m
> CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
> CONFIG_DVB_USB_DIBUSB_MC=m
> CONFIG_DVB_USB_DIB0700=m
> CONFIG_DVB_USB_UMT_010=m
> CONFIG_DVB_USB_CXUSB=m
> CONFIG_DVB_USB_M920X=m
> CONFIG_DVB_USB_GL861=m
> CONFIG_DVB_USB_AU6610=m
> CONFIG_DVB_USB_DIGITV=m
> CONFIG_DVB_USB_VP7045=m
> CONFIG_DVB_USB_VP702X=m
> CONFIG_DVB_USB_GP8PSK=m
> CONFIG_DVB_USB_NOVA_T_USB2=m
> CONFIG_DVB_USB_TTUSB2=m
> CONFIG_DVB_USB_DTT200U=m
> CONFIG_DVB_USB_OPERA1=m
> CONFIG_DVB_USB_AF9005=m
> CONFIG_DVB_USB_AF9005_REMOTE=m
> CONFIG_DVB_TTUSB_BUDGET=m
> CONFIG_DVB_TTUSB_DEC=m
> CONFIG_DVB_CINERGYT2=m
> # CONFIG_DVB_CINERGYT2_TUNING is not set
> 
> #
> # Supported FlexCopII (B2C2) Adapters
> #
> CONFIG_DVB_B2C2_FLEXCOP=m
> CONFIG_DVB_B2C2_FLEXCOP_PCI=m
> CONFIG_DVB_B2C2_FLEXCOP_USB=m
> # CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set
> 
> #
> # Supported BT878 Adapters
> #
> CONFIG_DVB_BT8XX=m
> 
> #
> # Supported Pluto2 Adapters
> #
> CONFIG_DVB_PLUTO2=m
> 
> #
> # Supported DVB Frontends
> #
> 
> #
> # Customise DVB Frontends
> #
> CONFIG_DVB_FE_CUSTOMISE=y
> 
> #
> # DVB-S (satellite) frontends
> #
> CONFIG_DVB_STV0299=m
> CONFIG_DVB_CX24110=m
> CONFIG_DVB_CX24123=m
> CONFIG_DVB_TDA8083=m
> CONFIG_DVB_MT312=m
> CONFIG_DVB_VES1X93=m
> CONFIG_DVB_S5H1420=m
> CONFIG_DVB_TDA10086=m
> 
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP8870=m
> CONFIG_DVB_SP887X=m
> CONFIG_DVB_CX22700=m
> CONFIG_DVB_CX22702=m
> CONFIG_DVB_L64781=m
> CONFIG_DVB_TDA1004X=m
> CONFIG_DVB_NXT6000=m
> CONFIG_DVB_MT352=m
> CONFIG_DVB_ZL10353=m
> CONFIG_DVB_DIB3000MB=m
> CONFIG_DVB_DIB3000MC=m
> CONFIG_DVB_DIB7000M=m
> CONFIG_DVB_DIB7000P=m
> 
> #
> # DVB-C (cable) frontends
> #
> CONFIG_DVB_VES1820=m
> CONFIG_DVB_TDA10021=m
> CONFIG_DVB_TDA10023=m
> CONFIG_DVB_STV0297=m
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=m
> CONFIG_DVB_OR51211=m
> CONFIG_DVB_OR51132=m
> CONFIG_DVB_BCM3510=m
> CONFIG_DVB_LGDT330X=m
> 
> #
> # Tuners/PLL support
> #
> CONFIG_DVB_PLL=m
> CONFIG_DVB_TDA826X=m
> CONFIG_DVB_TDA827X=m
> CONFIG_DVB_TUNER_QT1010=m
> CONFIG_DVB_TUNER_MT2060=m
> 
> #
> # Miscellaneous devices
> #
> CONFIG_DVB_LNBP21=m
> CONFIG_DVB_ISL6421=m
> CONFIG_DVB_TUA6100=m
> CONFIG_VIDEO_SAA7146=m
> CONFIG_VIDEO_SAA7146_VV=m
> CONFIG_VIDEO_TUNER=m
> CONFIG_VIDEO_BUF=m
> CONFIG_VIDEO_BUF_DVB=m
> CONFIG_VIDEO_BTCX=m
> CONFIG_VIDEO_IR_I2C=m
> CONFIG_VIDEO_IR=m
> CONFIG_VIDEO_TVEEPROM=m
> CONFIG_DAB=y
> CONFIG_USB_DABUSB=m
> 
> #
> # Graphics support
> #
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_PROGEAR=y
> 
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=y
> 
> #
> # Display hardware drivers
> #
> CONFIG_VGASTATE=y
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> # CONFIG_FB_DDC is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_SYS_FOPS is not set
> CONFIG_FB_DEFERRED_IO=y
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> CONFIG_FB_VGA16=y
> CONFIG_FB_VESA=y
> # CONFIG_FB_HECUBA is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_INTEL is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_VIRTUAL is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_VIDEO_SELECT=y
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_LOGO is not set
> 
> #
> # Sound
> #
> CONFIG_SOUND=m
> 
> #
> # Advanced Linux Sound Architecture
> #
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_SEQUENCER=m
> CONFIG_SND_SEQ_DUMMY=m
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_SEQUENCER_OSS=y
> CONFIG_SND_RTCTIMER=m
> CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
> CONFIG_SND_DYNAMIC_MINORS=y
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> 
> #
> # Generic devices
> #
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_VX_LIB=m
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DUMMY=m
> CONFIG_SND_VIRMIDI=m
> CONFIG_SND_MTPAV=m
> CONFIG_SND_MTS64=m
> CONFIG_SND_SERIAL_U16550=m
> CONFIG_SND_MPU401=m
> CONFIG_SND_PORTMAN2X4=m
> 
> #
> # PCI devices
> #
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> CONFIG_SND_INTEL8X0=m
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> CONFIG_SND_AC97_POWER_SAVE=y
> 
> #
> # USB devices
> #
> CONFIG_SND_USB_AUDIO=m
> CONFIG_SND_USB_USX2Y=m
> CONFIG_SND_USB_CAIAQ=m
> CONFIG_SND_USB_CAIAQ_INPUT=y
> 
> #
> # PCMCIA devices
> #
> CONFIG_SND_VXPOCKET=m
> CONFIG_SND_PDAUDIOCF=m
> 
> #
> # System on Chip audio support
> #
> # CONFIG_SND_SOC is not set
> 
> #
> # SoC Audio support for SuperH
> #
> 
> #
> # Open Sound System
> #
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=m
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HID_DEBUG is not set
> 
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=m
> CONFIG_USB_HIDINPUT_POWERBOOK=y
> # CONFIG_HID_FF is not set
> CONFIG_USB_HIDDEV=y
> 
> #
> # USB HID Boot Protocol drivers
> #
> CONFIG_USB_KBD=m
> CONFIG_USB_MOUSE=m
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_PERSIST is not set
> # CONFIG_USB_OTG is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_EHCI_HCD=m
> CONFIG_USB_EHCI_SPLIT_ISO=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_ISP116X_HCD=m
> CONFIG_USB_OHCI_HCD=m
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=m
> CONFIG_USB_U132_HCD=m
> CONFIG_USB_SL811_HCD=m
> CONFIG_USB_SL811_CS=m
> CONFIG_USB_R8A66597_HCD=m
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=m
> 
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
> 
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_DATAFAB=y
> CONFIG_USB_STORAGE_FREECOM=y
> CONFIG_USB_STORAGE_DPCM=y
> CONFIG_USB_STORAGE_USBAT=y
> CONFIG_USB_STORAGE_SDDR09=y
> CONFIG_USB_STORAGE_SDDR55=y
> CONFIG_USB_STORAGE_JUMPSHOT=y
> CONFIG_USB_STORAGE_ALAUDA=y
> CONFIG_USB_STORAGE_KARMA=y
> # CONFIG_USB_LIBUSUAL is not set
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=m
> CONFIG_USB_MICROTEK=m
> CONFIG_USB_MON=y
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=m
> 
> #
> # USB Serial Converter support
> #
> CONFIG_USB_SERIAL=m
> CONFIG_USB_SERIAL_GENERIC=y
> CONFIG_USB_SERIAL_AIRCABLE=m
> CONFIG_USB_SERIAL_AIRPRIME=m
> CONFIG_USB_SERIAL_ARK3116=m
> CONFIG_USB_SERIAL_BELKIN=m
> CONFIG_USB_SERIAL_WHITEHEAT=m
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
> CONFIG_USB_SERIAL_CP2101=m
> CONFIG_USB_SERIAL_CYPRESS_M8=m
> CONFIG_USB_SERIAL_EMPEG=m
> CONFIG_USB_SERIAL_FTDI_SIO=m
> CONFIG_USB_SERIAL_FUNSOFT=m
> CONFIG_USB_SERIAL_VISOR=m
> CONFIG_USB_SERIAL_IPAQ=m
> CONFIG_USB_SERIAL_IR=m
> CONFIG_USB_SERIAL_EDGEPORT=m
> CONFIG_USB_SERIAL_EDGEPORT_TI=m
> CONFIG_USB_SERIAL_GARMIN=m
> CONFIG_USB_SERIAL_IPW=m
> CONFIG_USB_SERIAL_KEYSPAN_PDA=m
> CONFIG_USB_SERIAL_KEYSPAN=m
> CONFIG_USB_SERIAL_KEYSPAN_MPR=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19=y
> CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
> CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
> CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
> CONFIG_USB_SERIAL_KLSI=m
> CONFIG_USB_SERIAL_KOBIL_SCT=m
> CONFIG_USB_SERIAL_MCT_U232=m
> CONFIG_USB_SERIAL_MOS7720=m
> CONFIG_USB_SERIAL_MOS7840=m
> CONFIG_USB_SERIAL_NAVMAN=m
> CONFIG_USB_SERIAL_PL2303=m
> CONFIG_USB_SERIAL_OTI6858=m
> CONFIG_USB_SERIAL_HP4X=m
> CONFIG_USB_SERIAL_SAFE=m
> CONFIG_USB_SERIAL_SAFE_PADDED=y
> CONFIG_USB_SERIAL_SIERRAWIRELESS=m
> CONFIG_USB_SERIAL_TI=m
> CONFIG_USB_SERIAL_CYBERJACK=m
> CONFIG_USB_SERIAL_XIRCOM=m
> CONFIG_USB_SERIAL_OPTION=m
> CONFIG_USB_SERIAL_OMNINET=m
> CONFIG_USB_SERIAL_DEBUG=m
> CONFIG_USB_EZUSB=y
> 
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=m
> CONFIG_USB_EMI26=m
> CONFIG_USB_ADUTUX=m
> CONFIG_USB_AUERSWALD=m
> CONFIG_USB_RIO500=m
> CONFIG_USB_LEGOTOWER=m
> CONFIG_USB_LCD=m
> CONFIG_USB_BERRY_CHARGE=m
> CONFIG_USB_LED=m
> CONFIG_USB_CYPRESS_CY7C63=m
> CONFIG_USB_CYTHERM=m
> CONFIG_USB_PHIDGET=m
> CONFIG_USB_PHIDGETKIT=m
> CONFIG_USB_PHIDGETMOTORCONTROL=m
> CONFIG_USB_PHIDGETSERVO=m
> CONFIG_USB_IDMOUSE=m
> CONFIG_USB_FTDI_ELAN=m
> CONFIG_USB_APPLEDISPLAY=m
> CONFIG_USB_SISUSBVGA=m
> CONFIG_USB_SISUSBVGA_CON=y
> CONFIG_USB_LD=m
> CONFIG_USB_TRANCEVIBRATOR=m
> CONFIG_USB_IOWARRIOR=m
> CONFIG_USB_TEST=m
> 
> #
> # USB DSL modem support
> #
> 
> #
> # USB Gadget Support
> #
> CONFIG_USB_GADGET=m
> # CONFIG_USB_GADGET_DEBUG is not set
> # CONFIG_USB_GADGET_DEBUG_FILES is not set
> CONFIG_USB_GADGET_SELECTED=y
> # CONFIG_USB_GADGET_AMD5536UDC is not set
> # CONFIG_USB_GADGET_FSL_USB2 is not set
> CONFIG_USB_GADGET_NET2280=y
> CONFIG_USB_NET2280=m
> # CONFIG_USB_GADGET_PXA2XX is not set
> # CONFIG_USB_GADGET_M66592 is not set
> # CONFIG_USB_GADGET_GOKU is not set
> # CONFIG_USB_GADGET_LH7A40X is not set
> # CONFIG_USB_GADGET_OMAP is not set
> # CONFIG_USB_GADGET_S3C2410 is not set
> # CONFIG_USB_GADGET_AT91 is not set
> # CONFIG_USB_GADGET_DUMMY_HCD is not set
> CONFIG_USB_GADGET_DUALSPEED=y
> CONFIG_USB_ZERO=m
> CONFIG_USB_ETH=m
> CONFIG_USB_ETH_RNDIS=y
> CONFIG_USB_GADGETFS=m
> CONFIG_USB_FILE_STORAGE=m
> # CONFIG_USB_FILE_STORAGE_TEST is not set
> CONFIG_USB_G_SERIAL=m
> CONFIG_USB_MIDI_GADGET=m
> CONFIG_MMC=m
> # CONFIG_MMC_DEBUG is not set
> # CONFIG_MMC_UNSAFE_RESUME is not set
> 
> #
> # MMC/SD Card Drivers
> #
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_BOUNCE=y
> 
> #
> # MMC/SD Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=m
> CONFIG_MMC_WBSD=m
> CONFIG_MMC_TIFM_SD=m
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> CONFIG_INFINIBAND=m
> CONFIG_INFINIBAND_USER_MAD=m
> CONFIG_INFINIBAND_USER_ACCESS=m
> CONFIG_INFINIBAND_USER_MEM=y
> CONFIG_INFINIBAND_ADDR_TRANS=y
> CONFIG_INFINIBAND_MTHCA=m
> CONFIG_INFINIBAND_MTHCA_DEBUG=y
> CONFIG_INFINIBAND_IPATH=m
> CONFIG_INFINIBAND_AMSO1100=m
> # CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
> CONFIG_MLX4_INFINIBAND=m
> CONFIG_INFINIBAND_IPOIB=m
> CONFIG_INFINIBAND_IPOIB_CM=y
> CONFIG_INFINIBAND_IPOIB_DEBUG=y
> # CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
> CONFIG_INFINIBAND_SRP=m
> CONFIG_INFINIBAND_ISER=m
> CONFIG_EDAC=y
> 
> #
> # Reporting subsystems
> #
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_MM_EDAC=m
> CONFIG_EDAC_E752X=m
> CONFIG_EDAC_I82975X=m
> CONFIG_EDAC_I5000=m
> CONFIG_RTC_LIB=m
> CONFIG_RTC_CLASS=m
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> CONFIG_RTC_DRV_TEST=m
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=m
> CONFIG_RTC_DRV_DS1672=m
> CONFIG_RTC_DRV_MAX6900=m
> CONFIG_RTC_DRV_RS5C372=m
> CONFIG_RTC_DRV_ISL1208=m
> CONFIG_RTC_DRV_X1205=m
> CONFIG_RTC_DRV_PCF8563=m
> CONFIG_RTC_DRV_PCF8583=m
> CONFIG_RTC_DRV_M41T80=m
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> 
> #
> # SPI RTC drivers
> #
> CONFIG_RTC_DRV_RS5C348=m
> CONFIG_RTC_DRV_MAX6902=m
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=m
> CONFIG_RTC_DRV_DS1553=m
> CONFIG_RTC_DRV_STK17TA8=m
> CONFIG_RTC_DRV_DS1742=m
> CONFIG_RTC_DRV_M48T86=m
> CONFIG_RTC_DRV_M48T59=m
> CONFIG_RTC_DRV_V3020=m
> 
> #
> # on-CPU RTC drivers
> #
> 
> #
> # DMA Engine support
> #
> CONFIG_DMA_ENGINE=y
> 
> #
> # DMA Clients
> #
> CONFIG_NET_DMA=y
> 
> #
> # DMA Devices
> #
> CONFIG_INTEL_IOATDMA=m
> # CONFIG_AUXDISPLAY is not set
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=m
> # CONFIG_KVM_INTEL is not set
> CONFIG_KVM_AMD=m
> 
> #
> # Userspace I/O
> #
> CONFIG_UIO=m
> CONFIG_UIO_CIF=m
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> CONFIG_DELL_RBU=m
> CONFIG_DCDBAS=m
> CONFIG_DMIID=y
> 
> #
> # File systems
> #
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=m
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> # CONFIG_EXT4DEV_FS is not set
> CONFIG_JBD=m
> # CONFIG_JBD_DEBUG is not set
> CONFIG_FS_MBCACHE=m
> CONFIG_REISERFS_FS=m
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> CONFIG_REISERFS_FS_SECURITY=y
> CONFIG_JFS_FS=m
> CONFIG_JFS_POSIX_ACL=y
> CONFIG_JFS_SECURITY=y
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_SECURITY=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_GFS2_FS=m
> CONFIG_GFS2_FS_LOCKING_NOLOCK=m
> CONFIG_GFS2_FS_LOCKING_DLM=m
> CONFIG_OCFS2_FS=m
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> CONFIG_MINIX_FS=m
> CONFIG_ROMFS_FS=m
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_QUOTA=y
> CONFIG_QFMT_V1=m
> CONFIG_QFMT_V2=m
> CONFIG_QUOTACTL=y
> CONFIG_DNOTIFY=y
> CONFIG_AUTOFS_FS=m
> CONFIG_AUTOFS4_FS=m
> CONFIG_FUSE_FS=m
> CONFIG_GENERIC_ACL=y
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=866
> CONFIG_FAT_DEFAULT_IOCHARSET="koi8-r"
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_RAMFS=y
> CONFIG_CONFIGFS_FS=m
> 
> #
> # Miscellaneous filesystems
> #
> CONFIG_ADFS_FS=m
> # CONFIG_ADFS_FS_RW is not set
> CONFIG_AFFS_FS=m
> CONFIG_ECRYPT_FS=m
> CONFIG_HFS_FS=m
> CONFIG_HFSPLUS_FS=m
> CONFIG_BEFS_FS=m
> # CONFIG_BEFS_DEBUG is not set
> CONFIG_BFS_FS=m
> CONFIG_EFS_FS=m
> CONFIG_JFFS2_FS=m
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> # CONFIG_JFFS2_SUMMARY is not set
> CONFIG_JFFS2_FS_XATTR=y
> CONFIG_JFFS2_FS_POSIX_ACL=y
> CONFIG_JFFS2_FS_SECURITY=y
> # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
> CONFIG_JFFS2_ZLIB=y
> CONFIG_JFFS2_RTIME=y
> # CONFIG_JFFS2_RUBIN is not set
> CONFIG_CRAMFS=y
> CONFIG_VXFS_FS=m
> CONFIG_HPFS_FS=m
> CONFIG_QNX4FS_FS=m
> CONFIG_SYSV_FS=m
> CONFIG_UFS_FS=m
> # CONFIG_UFS_FS_WRITE is not set
> # CONFIG_UFS_DEBUG is not set
> 
> #
> # Network File Systems
> #
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=y
> CONFIG_NFS_DIRECTIO=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_NFSD_TCP=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=m
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_SUNRPC_BIND34=y
> CONFIG_RPCSEC_GSS_KRB5=m
> CONFIG_RPCSEC_GSS_SPKM3=m
> CONFIG_SMB_FS=m
> CONFIG_SMB_NLS_DEFAULT=y
> CONFIG_SMB_NLS_REMOTE="cp866"
> CONFIG_CIFS=m
> # CONFIG_CIFS_STATS is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> # CONFIG_CIFS_DEBUG2 is not set
> # CONFIG_CIFS_EXPERIMENTAL is not set
> CONFIG_NCP_FS=m
> CONFIG_NCPFS_PACKET_SIGNING=y
> CONFIG_NCPFS_IOCTL_LOCKING=y
> CONFIG_NCPFS_STRONG=y
> CONFIG_NCPFS_NFS_NS=y
> CONFIG_NCPFS_OS2_NS=y
> CONFIG_NCPFS_SMALLDOS=y
> CONFIG_NCPFS_NLS=y
> CONFIG_NCPFS_EXTRAS=y
> CONFIG_CODA_FS=m
> # CONFIG_CODA_FS_OLD_API is not set
> CONFIG_AFS_FS=m
> # CONFIG_AFS_DEBUG is not set
> CONFIG_9P_FS=m
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> # CONFIG_ACORN_PARTITION_CUMANA is not set
> # CONFIG_ACORN_PARTITION_EESOX is not set
> CONFIG_ACORN_PARTITION_ICS=y
> # CONFIG_ACORN_PARTITION_ADFS is not set
> # CONFIG_ACORN_PARTITION_POWERTEC is not set
> CONFIG_ACORN_PARTITION_RISCIX=y
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> CONFIG_ATARI_PARTITION=y
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_UNIXWARE_DISKLABEL=y
> CONFIG_LDM_PARTITION=y
> # CONFIG_LDM_DEBUG is not set
> CONFIG_SGI_PARTITION=y
> CONFIG_ULTRIX_PARTITION=y
> CONFIG_SUN_PARTITION=y
> CONFIG_KARMA_PARTITION=y
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> 
> #
> # Native Language Support
> #
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=m
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=m
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=m
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=m
> CONFIG_NLS_CODEPAGE_866=m
> CONFIG_NLS_CODEPAGE_869=m
> CONFIG_NLS_CODEPAGE_936=m
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=m
> CONFIG_NLS_CODEPAGE_874=m
> CONFIG_NLS_ISO8859_8=m
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=m
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=m
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=m
> CONFIG_NLS_KOI8_R=m
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_UTF8=m
> 
> #
> # Distributed Lock Manager
> #
> CONFIG_DLM=m
> # CONFIG_DLM_DEBUG is not set
> 
> #
> # Instrumentation Support
> #
> CONFIG_PROFILING=y
> CONFIG_OPROFILE=m
> # CONFIG_KPROBES is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_UNUSED_SYMBOLS=y
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> CONFIG_DETECT_SOFTLOCKUP=y
> # CONFIG_SCHED_DEBUG is not set
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> # CONFIG_SLUB_DEBUG_ON is not set
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_LIST is not set
> CONFIG_FRAME_POINTER=y
> # CONFIG_FORCED_INLINING is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_IOMMU_DEBUG is not set
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_CAPABILITIES=y
> CONFIG_SECURITY_ROOTPLUG=m
> CONFIG_SECURITY_SELINUX=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
> CONFIG_SECURITY_SELINUX_DISABLE=y
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> CONFIG_SECURITY_SELINUX_AVC_STATS=y
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=y
> CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
> CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
> CONFIG_XOR_BLOCKS=m
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ABLKCIPHER=m
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_NULL=m
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_SHA1=m
> CONFIG_CRYPTO_SHA256=m
> CONFIG_CRYPTO_SHA512=m
> CONFIG_CRYPTO_WP512=m
> CONFIG_CRYPTO_TGR192=m
> CONFIG_CRYPTO_GF128MUL=m
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_CBC=m
> CONFIG_CRYPTO_PCBC=m
> CONFIG_CRYPTO_LRW=m
> CONFIG_CRYPTO_CRYPTD=m
> CONFIG_CRYPTO_DES=m
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_X86_64=m
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_AES=m
> CONFIG_CRYPTO_AES_X86_64=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_ANUBIS=m
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_MICHAEL_MIC=m
> CONFIG_CRYPTO_CRC32C=m
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_HW=y
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_CRC_CCITT=m
> CONFIG_CRC16=m
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> CONFIG_CRC7=m
> CONFIG_LIBCRC32C=m
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_REED_SOLOMON=m
> CONFIG_REED_SOLOMON_DEC16=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

