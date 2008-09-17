Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYIQUtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYIQUtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYIQUs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:48:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46404 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYIQUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:48:55 -0400
Date: Wed, 17 Sep 2008 10:48:50 -1000
From: j_kernel@hoblitt.com
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917204850.GC23209@hoblitt.com>
References: <20080917024312.GA23209@hoblitt.com> <20080917071357.GA7455@lenovo> <20080917092058.GB23209@hoblitt.com> <20080917162704.GE7309@lenovo>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20080917162704.GE7309@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 17, 2008 at 08:27:04PM +0400, Cyrill Gorcunov wrote:
> Joshua, could you please do one more thing - boot the kernel
> with "debug apic=debug nmi_watchdog=1" (among others) and
> publish dmsg?

dmesg from "debug apic=debug nmi_watchdog=2" is attached.
                                          ^

-J

--

--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipp005-debug.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-rc5-22033-gd26acd9-dirty (root@ipp000) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #2 SMP Fri Sep 12 10:04:18 HST 2008
[    0.000000] Command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc debug nmi_watchdog=2 show_msr=1 apic=debug console=tty0 console=ttyS0,115200n8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ce000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
[    0.000000]  BIOS-e820: 00000000cff60000 - 00000000cff6a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff6a000 - 00000000cff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xcff60 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff60000 page 4k
[    0.000000] kernel direct mapping tables up to cff60000 @ 8000-e000
[    0.000000] last_map_addr: cff60000 end: cff60000
[    0.000000] init_memory_mapping
[    0.000000]  0100000000 - 0230000000 page 2M
[    0.000000] kernel direct mapping tables up to 230000000 @ c000-16000
[    0.000000] last_map_addr: 230000000 end: 230000000
[    0.000000] RAMDISK: 37e0f000 - 37fef850
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F75D0, 0024 (r2 PTLTD )
[    0.000000] ACPI: XSDT CFF656FA, 0064 (r1 PTLTD       XSDT    6040000  LTP        0)
[    0.000000] ACPI: FACP CFF6970E, 00F4 (r3 NVIDIA CK8S      6040000 PTL_    F4240)
[    0.000000] ACPI: DSDT CFF6575E, 3F3C (r1 NVIDIA      CK8  6040000 MSFT  3000000)
[    0.000000] ACPI: FACS CFF6AFC0, 0040
[    0.000000] ACPI: SSDT CFF69802, 0574 (r1 AMD    POWERNOW  6040000 AMD         1)
[    0.000000] ACPI: SRAT CFF69D76, 0110 (r1 AMD    HAMMER    6040000 AMD         1)
[    0.000000] ACPI: SPCR CFF69E86, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
[    0.000000] ACPI: MCFG CFF69ED6, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
[    0.000000] ACPI: HPET CFF69F12, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
[    0.000000] ACPI: APIC CFF69F4A, 008E (r1 PTLTD       APIC    6040000  LTP        0)
[    0.000000] ACPI: BOOT CFF69FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-d0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-130000000
[    0.000000] SRAT: Node 1 PXM 1 130000000-230000000
[    0.000000] NUMA: Allocated memnodemap from 11000 - 15680
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [0000000000015680 - 000000000002067f]
[    0.000000]   bootmap [0000000000021000 -  0000000000046fff] pages 26
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000f96910]    TEXT DATA BSS ==> [0000200000 - 0000f96910]
[    0.000000]   #3 [0037e0f000 - 0037fef850]          RAMDISK ==> [0037e0f000 - 0037fef850]
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #6 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 0000011000]
[    0.000000]   #7 [0000011000 - 0000015680]       MEMNODEMAP ==> [0000011000 - 0000015680]
[    0.000000] Bootmem setup node 1 0000000130000000-0000000230000000
[    0.000000]   NODE_DATA [0000000130000000 - 000000013000afff]
[    0.000000]   bootmap [000000013000b000 -  000000013002afff] pages 20
[    0.000000] (8 early reservations) ==> bootmem [0130000000 - 0230000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 0000f96910]    TEXT DATA BSS
[    0.000000]   #3 [0037e0f000 - 0037fef850]          RAMDISK
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE
[    0.000000]   #6 [000000c000 - 0000011000]          PGTABLE
[    0.000000]   #7 [0000011000 - 0000015680]       MEMNODEMAP
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f7600] 000f7600
[    0.000000]  [ffffe20000000000-ffffe200071fffff] PMD -> [ffff880028200000-ffff88002e1fffff] on node 0
[    0.000000]  [ffffe20007200000-ffffe2000d1fffff] PMD -> [ffff880130200000-ffff8801361fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000cff60
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000]     1: 0x00130000 -> 0x00230000
[    0.000000] On node 0 totalpages: 1048317
[    0.000000]   DMA zone: 307 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 823232 pages, LIFO batch:31
[    0.000000]   Normal zone: 192000 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 1024000 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (00000000fec00000)
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ce000
[    0.000000] PM: Registered nosave memory: 00000000000ce000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff60000 - 00000000cff6a000
[    0.000000] PM: Registered nosave memory: 00000000cff6a000 - 00000000cff80000
[    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff80000
[    0.000000] PM: Registered nosave memory: 00000000fff80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
[    0.000000] PERCPU: Allocating 51872 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 4, nr_node_ids 2
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2039539
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc debug nmi_watchdog=2 show_msr=1 apic=debug console=tty0 console=ttyS0,115200n8
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PIT calibration value
[    0.000000] Detected 2799.937 MHz processor.
[    0.003333] spurious 8259A interrupt: IRQ7.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:           4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 3839 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Node 0: aperture @ 0 size 32 MB
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.003333] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.003333] Memory: 8108304k/9175040k available (3897k kernel code, 279268k reserved, 2242k data, 676k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=2
[    0.003333] hpet clockevent registered
[    0.003341] Calibrating delay loop (skipped), value calculated using timer frequency.. 5602.20 BogoMIPS (lpj=9333123)
[    0.010027] Security Framework initialized
[    0.016692] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.026447] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.029173] Mount-cache hash table entries: 256
[    0.030310] Initializing cgroup subsys ns
[    0.033338] Initializing cgroup subsys cpuacct
[    0.036668] Initializing cgroup subsys memory
[    0.040007] Initializing cgroup subsys devices
[    0.043340] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.046665] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.049999] CPU 0/0 -> Node 0
[    0.053332] tseg: 00cff80000
[    0.056665] CPU: Physical Processor ID: 0
[    0.059998] CPU: Processor Core ID: 0
[    0.063336] using C1E aware idle routine
[    0.066685] ACPI: Core revision 20080609
[    0.076723] Getting VERSION: 80050010
[    0.079997] Getting VERSION: 80050010
[    0.083330] Getting ID: 0
[    0.086663] Getting ID: ff000000
[    0.089994] Getting LVT0: 10000
[    0.089996] Getting LVT1: 10000
[    0.093330] masked ExtINT on CPU#0
[    0.096903] ENABLING IO-APIC IRQs
[    0.099995] init IO_APIC IRQs
[    0.103329]  IO-APIC (apicid-pin) 4-0 not connected.
[    0.108339] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.110000] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.113325] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.113332] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.116665] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.119998] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.123331] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.126664] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.129997] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1)
[    0.133330] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.136663] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.139997] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.143330] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.146663] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.149996] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.153328]  IO-APIC (apicid-pin) 4-16, 4-17, 4-18, 4-19, 4-20, 4-21, 4-22, 4-23 not connected.
[    0.163485] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.200845] CPU0: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.206654] Using local APIC timer interrupts.
[    0.213320] APIC timer calibration result 12499727
[    0.216654] Detected 12.499 MHz APIC timer.
[    0.220144] lockdep: fixing up alternatives.
[    0.223342] Booting processor 1/1 ip 6000
[    0.003333] Initializing CPU#1
[    0.003333] masked ExtINT on CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 5602.22 BogoMIPS (lpj=9333158)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU 1/1 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.320369] CPU1: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.330023] lockdep: fixing up alternatives.
[    0.333325] Booting processor 2/2 ip 6000
[    0.003333] Initializing CPU#2
[    0.003333] masked ExtINT on CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 5602.25 BogoMIPS (lpj=9333200)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU 2/2 -> Node 1
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.430543] CPU2: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.440047] lockdep: fixing up alternatives.
[    0.443324] Booting processor 3/3 ip 6000
[    0.003333] Initializing CPU#3
[    0.003333] masked ExtINT on CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 5602.23 BogoMIPS (lpj=9333179)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU 3/3 -> Node 1
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.540532] CPU3: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.549981] Brought up 4 CPUs
[    0.553128] Total of 4 processors activated (22408.91 BogoMIPS).
[    0.553363] Testing NMI watchdog ... OK.
[    0.626894] net_namespace: 968 bytes
[    0.630205] xor: automatically using best checksumming function: generic_sse
[    0.649969]    generic_sse:  8630.400 MB/sec
[    0.653302] xor: using function: generic_sse (8630.400 MB/sec)
[    0.656696] NET: Registered protocol family 16
[    0.660253] No dock devices found.
[    0.663504] node 0 link 2: io port [1000, 3fff]
[    0.666636] TOM: 00000000d0000000 aka 3328M
[    0.669969] node 0 link 2: mmio [d0000000, dfffffff]
[    0.676635] node 0 link 2: mmio [a0000, bffff]
[    0.680343] node 0 link 2: mmio [e0000000, e7ffffff]
[    0.686635] TOM2: 0000000230000000 aka 8960M
[    0.689969] bus: [00,ff] on node 0 link 2
[    0.693307] bus: 00 index 0 io port: [0, ffff]
[    0.696635] bus: 00 index 1 mmio: [d0000000, ffffffff]
[    0.699968] bus: 00 index 2 mmio: [a0000, bffff]
[    0.703302] bus: 00 index 3 mmio: [230000000, fcffffffff]
[    0.706647] ACPI: bus type pci registered
[    0.710112] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 4
[    0.713303] PCI: MCFG area at e0000000 reserved in E820
[    0.716740] PCI: Using MMCONFIG at e0000000 - e04fffff
[    0.719968] PCI: Using configuration type 1 for base access
[    0.728437] ACPI: EC: Look up EC in DSDT
[    0.736968] ACPI: Interpreter enabled
[    0.739969] ACPI: (supports S0 S1 S3 S4 S5)
[    0.745030] ACPI: Using IOAPIC for interrupt routing
[    0.755036] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.756944] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.759972] pci 0000:00:01.1: PME# disabled
[    0.763342] pci 0000:00:02.0: supports D1
[    0.766635] pci 0000:00:02.0: supports D2
[    0.769968] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.773303] pci 0000:00:02.0: PME# disabled
[    0.776673] pci 0000:00:02.1: supports D1
[    0.779968] pci 0000:00:02.1: supports D2
[    0.783302] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.786636] pci 0000:00:02.1: PME# disabled
[    0.790205] pci 0000:00:08.0: supports D1
[    0.793301] pci 0000:00:08.0: supports D2
[    0.796635] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.799971] pci 0000:00:08.0: PME# disabled
[    0.803350] pci 0000:00:09.0: supports D1
[    0.806635] pci 0000:00:09.0: supports D2
[    0.809968] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.813304] pci 0000:00:09.0: PME# disabled
[    0.816667] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.819969] pci 0000:00:0a.0: PME# disabled
[    0.823336] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.826636] pci 0000:00:0d.0: PME# disabled
[    0.829998] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.833302] pci 0000:00:0f.0: PME# disabled
[    0.836887] pci 0000:01:04.0: supports D1
[    0.839968] pci 0000:01:04.0: supports D2
[    0.846644] pci 0000:00:06.0: transparent bridge
[    0.849969] PCI: bridge 0000:00:06.0 io port: [3000, 3fff]
[    0.853303] PCI: bridge 0000:00:06.0 32bit mmio: [d0100000, d01fffff]
[    0.856636] PCI: bridge 0000:00:06.0 32bit mmio pref: [d8000000, dfffffff]
[    0.860036] pci 0000:02:00.0: supports D1
[    0.863330] PCI: bridge 0000:00:0a.0 32bit mmio: [d0200000, d02fffff]
[    0.866721] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.870040] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    0.873324] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    0.876660] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    0.879993] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR5._PRT]
[    0.908235] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.918928] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    0.925216] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.932886] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.940495] ACPI: PCI Interrupt Link [LK1E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.951499] ACPI: PCI Interrupt Link [LK2E] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    0.960946] ACPI: PCI Interrupt Link [LK3E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.971949] ACPI: PCI Interrupt Link [LK4E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.979551] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.987162] ACPI: PCI Interrupt Link [LUS0] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    0.996787] ACPI: PCI Interrupt Link [LMA2] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    1.006297] ACPI: PCI Interrupt Link [LUS2] (IRQs *5 7 10 11 14 15 16 17 18 19 20 21 22 23)
[    1.012659] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    1.019013] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    1.026787] ACPI: PCI Interrupt Link [LPID] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    1.037162] ACPI: PCI Interrupt Link [LTID] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    1.047300] ACPI: PCI Interrupt Link [LSI1] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    1.056787] ACPI: PCI Interrupt Link [LSI2] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    1.066914] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.070030] pnp: PnP ACPI init
[    1.073313] ACPI: bus type pnp registered
[    1.077375] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    1.080619] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    1.083402] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    1.087135] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    1.093699] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    1.097564] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    1.104093] pnp: PnP ACPI: found 14 devices
[    1.106636] ACPI: ACPI bus type pnp unregistered
[    1.113565] SCSI subsystem initialized
[    1.116800] libata version 3.00 loaded.
[    1.120253] usbcore: registered new interface driver usbfs
[    1.123369] usbcore: registered new interface driver hub
[    1.130010] usbcore: registered new device driver usb
[    1.133672] PCI: Using ACPI for IRQ routing
[    1.136637] number of MP IRQ sources: 16.
[    1.139968] number of IO-APIC #4 registers: 24.
[    1.143301] testing the IO APIC.......................
[    1.146640] 
[    1.148314] IO APIC #4......
[    1.149968] .... register #00: 04000000
[    1.153302] .......    : physical APIC id: 04
[    1.156635] .... register #01: 00170011
[    1.159968] .......     : max redirection entries: 0017
[    1.163301] .......     : PRQ implemented: 0
[    1.166635] .......     : IO APIC version: 0011
[    1.169968] .... register #02: 04000000
[    1.173301] .......     : arbitration: 04
[    1.176635] .... IRQ redirection table:
[    1.179968]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    1.183305]  00 000 1    0    0   0   0    0    0    00
[    1.186638]  01 00F 0    0    0   0   0    1    1    31
[    1.193305]  02 00F 0    0    0   0   0    1    1    30
[    1.199971]  03 00F 0    0    0   0   0    1    1    33
[    1.203305]  04 00F 0    0    0   0   0    1    1    34
[    1.209971]  05 00F 1    0    0   0   0    1    1    35
[    1.216638]  06 00F 0    0    0   0   0    1    1    36
[    1.219971]  07 00F 0    0    0   0   0    1    1    37
[    1.226638]  08 00F 0    0    0   0   0    1    1    38
[    1.233305]  09 00F 0    1    0   1   0    1    1    39
[    1.236638]  0a 00F 1    0    0   0   0    1    1    3A
[    1.243305]  0b 00F 1    0    0   0   0    1    1    3B
[    1.249971]  0c 00F 0    0    0   0   0    1    1    3C
[    1.253305]  0d 00F 0    0    0   0   0    1    1    3D
[    1.259971]  0e 00F 0    0    0   0   0    1    1    3E
[    1.263305]  0f 00F 0    0    0   0   0    1    1    3F
[    1.269974]  10 000 1    0    0   0   0    0    0    00
[    1.276638]  11 000 1    0    0   0   0    0    0    00
[    1.279971]  12 000 1    0    0   0   0    0    0    00
[    1.286638]  13 000 1    0    0   0   0    0    0    00
[    1.293305]  14 000 1    0    0   0   0    0    0    00
[    1.296638]  15 000 1    0    0   0   0    0    0    00
[    1.303305]  16 000 1    0    0   0   0    0    0    00
[    1.309971]  17 000 1    0    0   0   0    0    0    00
[    1.313301] IRQ to pin mappings:
[    1.316635] IRQ0 -> 0:2
[    1.320918] IRQ1 -> 0:1
[    1.324251] IRQ3 -> 0:3
[    1.327009] IRQ4 -> 0:4
[    1.329968] IRQ5 -> 0:5
[    1.332701] IRQ6 -> 0:6
[    1.334254] IRQ7 -> 0:7
[    1.337587] IRQ8 -> 0:8
[    1.340914] IRQ9 -> 0:9
[    1.343676] IRQ10 -> 0:10
[    1.346635] IRQ11 -> 0:11
[    1.349540] IRQ12 -> 0:12
[    1.350999] IRQ13 -> 0:13
[    1.354339] IRQ14 -> 0:14
[    1.357670] IRQ15 -> 0:15
[    1.361004] .................................... done.
[    1.376899] PCI-DMA: Disabling AGP.
[    1.381108] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    1.383302] PCI-DMA: using GART IOMMU.
[    1.386637] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.390525] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    1.397011] hpet0: 3 32-bit timers, 25000000 Hz
[    1.401065] ACPI: RTC can wake from S4
[    1.403313] Switched to high resolution mode on CPU 0
[    1.403376] Switched to high resolution mode on CPU 2
[    1.403396] Switched to high resolution mode on CPU 3
[    1.406608] Switched to high resolution mode on CPU 1
[    1.436703] system 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
[    1.444539] system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.452372] system 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
[    1.460206] system 00:00: iomem range 0xfed00000-0xfed00fff has been reserved
[    1.467553] system 00:03: iomem range 0xd0000000-0xd0007fff has been reserved
[    1.474888] system 00:04: ioport range 0x1000-0x107f has been reserved
[    1.481616] system 00:04: ioport range 0x1080-0x10ff has been reserved
[    1.488341] system 00:04: ioport range 0x1400-0x147f has been reserved
[    1.495066] system 00:04: ioport range 0x1480-0x14ff has been reserved
[    1.501791] system 00:04: ioport range 0x1800-0x187f has been reserved
[    1.508520] system 00:04: ioport range 0x1880-0x18ff has been reserved
[    1.515244] system 00:04: ioport range 0x2440-0x247f has been reserved
[    1.521967] system 00:04: ioport range 0x2400-0x243f has been reserved
[    1.528705] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    1.535252] system 00:07: ioport range 0xc05-0xc06 has been reserved
[    1.542958] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    1.549075] pci 0000:00:06.0:   IO window: 0x3000-0x3fff
[    1.554587] pci 0000:00:06.0:   MEM window: 0xd0100000-0xd01fffff
[    1.560884] pci 0000:00:06.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
[    1.568802] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    1.574919] pci 0000:00:0a.0:   IO window: disabled
[    1.579997] pci 0000:00:0a.0:   MEM window: 0xd0200000-0xd02fffff
[    1.586290] pci 0000:00:0a.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
[    1.594222] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:03
[    1.600336] pci 0000:00:0d.0:   IO window: disabled
[    1.605406] pci 0000:00:0d.0:   MEM window: disabled
[    1.610562] pci 0000:00:0d.0:   PREFETCH window: disabled
[    1.616154] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:04
[    1.622273] pci 0000:00:0f.0:   IO window: disabled
[    1.627350] pci 0000:00:0f.0:   MEM window: disabled
[    1.632508] pci 0000:00:0f.0:   PREFETCH window: disabled
[    1.638115] pci 0000:00:06.0: setting latency timer to 64
[    1.643717] pci 0000:00:0a.0: setting latency timer to 64
[    1.654201] pci 0000:00:0d.0: setting latency timer to 64
[    1.659803] pci 0000:00:0f.0: setting latency timer to 64
[    1.665399] bus: 00 index 0 io port: [0, ffff]
[    1.670040] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    1.675458] bus: 01 index 0 io port: [3000, 3fff]
[    1.680356] bus: 01 index 1 mmio: [d0100000, d01fffff]
[    1.685687] bus: 01 index 2 mmio: [d8000000, dfffffff]
[    1.691027] bus: 01 index 3 io port: [0, ffff]
[    1.695669] bus: 01 index 4 mmio: [0, ffffffffffffffff]
[    1.701085] bus: 02 index 0 mmio: [0, 0]
[    1.705201] bus: 02 index 1 mmio: [d0200000, d02fffff]
[    1.710532] bus: 02 index 2 mmio: [d1000000, d10fffff]
[    1.715862] bus: 02 index 3 mmio: [0, 0]
[    1.719976] bus: 03 index 0 mmio: [0, 0]
[    1.724093] bus: 03 index 1 mmio: [0, 0]
[    1.728211] bus: 03 index 2 mmio: [0, 0]
[    1.732327] bus: 03 index 3 mmio: [0, 0]
[    1.736443] bus: 04 index 0 mmio: [0, 0]
[    1.740562] bus: 04 index 1 mmio: [0, 0]
[    1.744683] bus: 04 index 2 mmio: [0, 0]
[    1.748801] bus: 04 index 3 mmio: [0, 0]
[    1.752934] NET: Registered protocol family 2
[    1.790275] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.800242] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.813278] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    1.822932] TCP: Hash tables configured (established 524288 bind 65536)
[    1.829770] TCP reno registered
[    1.840164] NET: Registered protocol family 1
[    1.844853] checking if image is initramfs... it is
[    1.946863] Freeing initrd memory: 1922k freed
[    1.952558] Simple Boot Flag at 0x37 set to 0x80
[    1.960282] audit: initializing netlink socket (disabled)
[    1.965948] type=2000 audit(1221684197.964:1): initialized
[    1.977176] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.987996] VFS: Disk quotas dquot_6.5.1
[    1.992322] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.000631] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.007574] msgmni has been set to 15840
[    2.011926] async_tx: api initialized (async)
[    2.016496] io scheduler noop registered
[    2.020626] io scheduler anticipatory registered
[    2.025443] io scheduler deadline registered
[    2.030096] io scheduler cfq registered (default)
[    2.035040] pci 0000:00:00.0: Enabling HT MSI Mapping
[    2.242753] pci 0000:00:05.0: Enabling HT MSI Mapping
[    2.248026] pci 0000:00:05.1: Enabling HT MSI Mapping
[    2.253298] pci 0000:00:05.2: Enabling HT MSI Mapping
[    2.258569] pci 0000:00:06.0: Enabling HT MSI Mapping
[    2.263840] pci 0000:00:08.0: Enabling HT MSI Mapping
[    2.269115] pci 0000:00:09.0: Enabling HT MSI Mapping
[    2.274384] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    2.279654] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    2.284923] pci 0000:00:0f.0: Enabling HT MSI Mapping
[    2.290198] pci 0000:01:04.0: Boot video device
[    2.295130] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    2.301796] pcieport-driver 0000:00:0a.0: found MSI capability
[    2.307876] pci_express 0000:00:0a.0:pcie00: allocate port service
[    2.314364] pci_express 0000:00:0a.0:pcie01: allocate port service
[    2.320814] pci_express 0000:00:0a.0:pcie03: allocate port service
[    2.327310] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[    2.333972] pcieport-driver 0000:00:0d.0: found MSI capability
[    2.340033] pci_express 0000:00:0d.0:pcie00: allocate port service
[    2.346478] pci_express 0000:00:0d.0:pcie01: allocate port service
[    2.352928] pci_express 0000:00:0d.0:pcie03: allocate port service
[    2.359412] pcieport-driver 0000:00:0f.0: setting latency timer to 64
[    2.366074] pcieport-driver 0000:00:0f.0: found MSI capability
[    2.372130] pci_express 0000:00:0f.0:pcie00: allocate port service
[    2.378570] pci_express 0000:00:0f.0:pcie01: allocate port service
[    2.385024] pci_express 0000:00:0f.0:pcie03: allocate port service
[    2.393252] aer 0000:00:0a.0:pcie01: AER service couldn't init device: no _OSC support
[    2.403151] aer 0000:00:0d.0:pcie01: AER service couldn't init device: no _OSC support
[    2.413036] aer 0000:00:0f.0:pcie01: AER service couldn't init device: no _OSC support
[    2.421764] input: Power Button (FF) as /class/input/input0
[    2.427547] ACPI: Power Button (FF) [PWRF]
[    2.431956] input: Power Button (CM) as /class/input/input1
[    2.437730] ACPI: Power Button (CM) [PWRB]
[    2.442465] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    2.448539] processor ACPI0007:00: registered as cooling_device0
[    2.454750] ACPI: Processor [C000] (supports 2 throttling states)
[    2.461243] processor ACPI0007:01: registered as cooling_device1
[    2.467553] processor ACPI0007:02: registered as cooling_device2
[    2.473856] processor ACPI0007:03: registered as cooling_device3
[    2.551196] hpet_resources: 0xfed00000 is busy
[    2.556037] Non-volatile memory driver v1.2
[    2.560567] Linux agpgart interface v0.103
[    2.564963] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    2.571547] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.578525] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.584655] Floppy drive(s): fd0 is 1.44M
[    5.600023] floppy0: no floppy controllers found
[    5.607494] brd: module loaded
[    5.611934] loop: module loaded
[    5.615273] tun: Universal TUN/TAP device driver, 1.6
[    5.620523] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.627097] console [netcon0] enabled
[    5.630964] netconsole: network logging started
[    5.635691] Uniform Multi-Platform E-IDE driver
[    5.640554] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    5.650661] Probing IDE interface ide0...
[    6.623534] hdb: CD-224E-N, ATAPI CD/DVD-ROM drive
[    6.680121] Probing IDE interface ide1...
[    7.220119] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.224942] ide1 at 0x170-0x177,0x376 on irq 15
[    7.231765] hdb: ATAPI 24X CD-ROM drive, 256kB Cache
[    7.237145] Uniform CD-ROM driver Revision: 3.20
[    7.252071] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    7.259881] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    7.267154] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[    7.273348] Driver 'sd' needs updating - please use bus_type methods
[    7.279972] Driver 'sr' needs updating - please use bus_type methods
[    7.287151] sata_nv 0000:00:05.0: version 3.5
[    7.291999] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
[    7.297948] IOAPIC[0]: Set routing entry (4-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
[    7.305794] sata_nv 0000:00:05.0: PCI INT A -> Link[LTID] -> GSI 23 (level, low) -> IRQ 23
[    7.314408] sata_nv 0000:00:05.0: Using SWNCQ mode
[    7.319523] sata_nv 0000:00:05.0: setting latency timer to 64
[    7.325654] scsi0 : sata_nv
[    7.328840] scsi1 : sata_nv
[    7.332023] ata1: SATA max UDMA/133 cmd 0x24d0 ctl 0x24c4 bmdma 0x2490 irq 23
[    7.339356] ata2: SATA max UDMA/133 cmd 0x24c8 ctl 0x24c0 bmdma 0x2498 irq 23
[    7.677046] ata1: SATA link down (SStatus 0 SControl 300)
[    8.010394] ata2: SATA link down (SStatus 0 SControl 300)
[    8.016279] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 22
[    8.022230] IOAPIC[0]: Set routing entry (4-22 -> 0x69 -> IRQ 22 Mode:1 Active:1)
[    8.030072] sata_nv 0000:00:05.1: PCI INT B -> Link[LSI1] -> GSI 22 (level, low) -> IRQ 22
[    8.038685] sata_nv 0000:00:05.1: Using SWNCQ mode
[    8.043786] sata_nv 0000:00:05.1: setting latency timer to 64
[    8.049864] scsi2 : sata_nv
[    8.052998] scsi3 : sata_nv
[    8.056180] ata3: SATA max UDMA/133 cmd 0x24e8 ctl 0x24dc bmdma 0x24a0 irq 22
[    8.063516] ata4: SATA max UDMA/133 cmd 0x24e0 ctl 0x24d8 bmdma 0x24a8 irq 22
[    8.400336] ata3: SATA link down (SStatus 0 SControl 300)
[    8.733666] ata4: SATA link down (SStatus 0 SControl 300)
[    8.739534] ACPI: PCI Interrupt Link [LSI2] enabled at IRQ 21
[    8.745490] IOAPIC[0]: Set routing entry (4-21 -> 0x71 -> IRQ 21 Mode:1 Active:1)
[    8.753340] sata_nv 0000:00:05.2: PCI INT C -> Link[LSI2] -> GSI 21 (level, low) -> IRQ 21
[    8.761952] sata_nv 0000:00:05.2: Using SWNCQ mode
[    8.767051] sata_nv 0000:00:05.2: setting latency timer to 64
[    8.773139] scsi4 : sata_nv
[    8.776273] scsi5 : sata_nv
[    8.779449] ata5: SATA max UDMA/133 cmd 0x2800 ctl 0x24f4 bmdma 0x24b0 irq 21
[    8.786784] ata6: SATA max UDMA/133 cmd 0x24f8 ctl 0x24f0 bmdma 0x24b8 irq 21
[    9.123711] ata5: SATA link down (SStatus 0 SControl 300)
[    9.457043] ata6: SATA link down (SStatus 0 SControl 300)
[    9.462786] pata_amd 0000:00:04.0: version 0.3.10
[    9.467719] pata_amd 0000:00:04.0: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
[    9.475461] pata_amd 0000:00:04.0: failed to request/iomap BARs for port 0 (errno=-16)
[    9.483729] pata_amd 0000:00:04.0: BAR 2: can't reserve I/O region [0x170-0x177]
[    9.491476] pata_amd 0000:00:04.0: failed to request/iomap BARs for port 1 (errno=-16)
[    9.499744] pata_amd 0000:00:04.0: no available native port
[    9.505848] Fusion MPT base driver 3.04.07
[    9.510141] Copyright (c) 1999-2008 LSI Corporation
[    9.515225] Fusion MPT SPI Host driver 3.04.07
[    9.519953] Fusion MPT SAS Host driver 3.04.07
[    9.525373] ieee1394: raw1394: /dev/raw1394 device initialized
[    9.531907] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
[    9.537855] IOAPIC[0]: Set routing entry (4-20 -> 0x79 -> IRQ 20 Mode:1 Active:1)
[    9.545699] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 20 (level, low) -> IRQ 20
[    9.554409] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    9.560437] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    9.566111] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    9.578754] ehci_hcd 0000:00:02.1: debug port 1
[    9.583480] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    9.590474] ehci_hcd 0000:00:02.1: irq 20, io mem 0xd0041000
[    9.603347] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    9.611332] usb usb1: configuration #1 chosen from 1 choice
[    9.617202] hub 1-0:1.0: USB hub found
[    9.621170] hub 1-0:1.0: 10 ports detected
[    9.727087] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.735198] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 19
[    9.741141] IOAPIC[0]: Set routing entry (4-19 -> 0x81 -> IRQ 19 Mode:1 Active:1)
[    9.748986] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 19 (level, low) -> IRQ 19
[    9.757691] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    9.763725] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    9.769310] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    9.777074] ohci_hcd 0000:00:02.0: irq 19, io mem 0xd0040000
[    9.835493] usb usb2: configuration #1 chosen from 1 choice
[    9.841355] hub 2-0:1.0: USB hub found
[    9.845307] hub 2-0:1.0: 10 ports detected
[    9.950334] USB Universal Host Controller Interface driver v3.0
[    9.956623] usbcore: registered new interface driver usblp
[    9.962303] Initializing USB Mass Storage driver...
[    9.967449] usbcore: registered new interface driver usb-storage
[    9.973658] USB Mass Storage support registered.
[    9.978631] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[   10.236985] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.242370] mice: PS/2 mouse device common for all mice
[   10.353338] md: linear personality registered for level -1
[   10.447540] md: raid0 personality registered for level 0
[   10.453050] md: raid1 personality registered for level 1
[   10.458553] md: raid10 personality registered for level 10
[   10.520442] raid6: int64x1   2568 MB/s
[   10.580428] raid6: int64x2   3277 MB/s
[   10.640437] raid6: int64x4   3227 MB/s
[   10.700434] raid6: int64x8   2278 MB/s
[   10.760424] raid6: sse2x1    3921 MB/s
[   10.820421] raid6: sse2x2    5110 MB/s
[   10.880420] raid6: sse2x4    5274 MB/s
[   10.884370] raid6: using algorithm sse2x4 (5274 MB/s)
[   10.889617] md: raid6 personality registered for level 6
[   10.895129] md: raid5 personality registered for level 5
[   10.900642] md: raid4 personality registered for level 4
[   10.906153] md: multipath personality registered for level -4
[   10.912349] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   10.921284] cpuidle: using governor ladder
[   10.925801] cpuidle: using governor menu
[   10.930007] usbcore: registered new interface driver usbhid
[   10.935775] usbhid: v2.6:USB HID core driver
[   10.940354] oprofile: using NMI interrupt.
[   10.945133] TCP cubic registered
[   10.948765] NET: Registered protocol family 10
[   10.954418] IPv6 over IPv4 tunneling driver
[   10.959568] NET: Registered protocol family 17
[   10.964611] RPC: Registered udp transport module.
[   10.969516] RPC: Registered tcp transport module.
[   10.974504] powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 2220 processors (4 cpu cores) (version 2.20.00)
[   10.980007] powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
[   10.991352] powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
[   10.997210] powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
[   11.003068] powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
[   11.008840] powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
[   11.014696] powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
[   11.020559] powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
[   10.980842] powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
[   11.032498] powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
[   11.038362] powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
[   11.044220] powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
[   11.049992] powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
[   11.055850] powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
[   11.061710] powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
[   11.068400] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   11.074956] Freeing unused kernel memory: 676k freed
[   11.080499] Write protecting the kernel read-only data: 5672k
[   11.500848] Clocksource tsc unstable (delta = -74982452 ns)
[   11.622045] ACPI: PCI Interrupt Link [LK3E] enabled at IRQ 18
[   11.622054] IOAPIC[0]: Set routing entry (4-18 -> 0x89 -> IRQ 18 Mode:1 Active:1)
[   11.622117] arcmsr 0000:02:00.0: PCI INT A -> Link[LK3E] -> GSI 18 (level, low) -> IRQ 18
[   11.622124] arcmsr 0000:02:00.0: setting latency timer to 64
[   11.633781] ARECA RAID ADAPTER6: FIRMWARE VERSION V1.44 2008-1-31  
[   11.647101] scsi6 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[   11.647103]  Driver Version 1.20.00.15 2008/02/27
[   11.648067] scsi 6:0:0:0: Direct-Access     Areca    ARC-1280-VOL#00  R001 PQ: 0 ANSI: 5
[   11.649251] sd 6:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[   11.649299] sd 6:0:0:0: [sda] 21484367872 512-byte hardware sectors (10999996 MB)
[   11.649347] sd 6:0:0:0: [sda] Write Protect is off
[   11.649350] sd 6:0:0:0: [sda] Mode Sense: cb 00 00 08
[   11.649433] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.649633] sd 6:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[   11.649678] sd 6:0:0:0: [sda] 21484367872 512-byte hardware sectors (10999996 MB)
[   11.649720] sd 6:0:0:0: [sda] Write Protect is off
[   11.649723] sd 6:0:0:0: [sda] Mode Sense: cb 00 00 08
[   11.649805] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.649809]  sda: sda1 sda2 sda3 sda4
[   11.681499] sd 6:0:0:0: [sda] Attached SCSI disk
[   11.682282] sd 6:0:0:0: Attached scsi generic sg0 type 0
[   11.683553] scsi 6:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[   11.684441] scsi 6:0:16:0: Attached scsi generic sg1 type 3
[   11.859757] 3ware Storage Controller device driver for Linux v1.26.02.002.
[   11.891003] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
[   11.956151] Adaptec aacraid driver 1.1-5[2456]-ms
[   12.396745] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[   12.404532] SGI XFS Quota Management subsystem
[   12.457945] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[   12.457954] Copyright (c) 1999-2006 Intel Corporation.

--lEGEL1/lMxI0MVQ2--
