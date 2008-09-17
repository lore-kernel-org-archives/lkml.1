Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYIQCn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYIQCn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 22:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYIQCnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 22:43:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYIQCnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 22:43:17 -0400
Date: Tue, 16 Sep 2008 16:43:12 -1000
From: j_kernel@hoblitt.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917024312.GA23209@hoblitt.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In-Reply-To: <20080916175629.GE7187@lenovo>
On Tue, Sep 16, 2008 at 09:56:29PM +0400, Cyrill Gorcunov wrote:
> [Thomas Gleixner - Tue, Sep 16, 2008 at 07:14:40AM -0700]
> | Can you try nmi_watchdog=2 ?
> | 
> | Thanks,
> | 
> | 	tglx
> | 
> 
> And get apic=debug a try too please. I remember there
> was a problem with SB600 on ACPI side (but they should
> be already fixed)

Attached is the updated dmesg from adding the nmi_watchdog=2 and acpi=debug boot params.

-J

--

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipp005.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-rc5-22033-gd26acd9-dirty (root@ipp000) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #2 SMP Fri Sep 12 10:04:18 HST 2008
[    0.000000] Command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc nmi_watchdog=2 show_msr=1 apic=debug console=tty0 console=ttyS0,115200n8
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
[    0.000000] Kernel command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc nmi_watchdog=2 show_msr=1 apic=debug console=tty0 console=ttyS0,115200n8
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
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 5602.20 BogoMIPS (lpj=9333123)
[    0.006694] Security Framework initialized
[    0.010741] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.019180] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.025703] Mount-cache hash table entries: 256
[    0.026977] Initializing cgroup subsys ns
[    0.030005] Initializing cgroup subsys cpuacct
[    0.033335] Initializing cgroup subsys memory
[    0.036674] Initializing cgroup subsys devices
[    0.040006] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.043332] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.046666] CPU 0/0 -> Node 0
[    0.049999] tseg: 00cff80000
[    0.050000] CPU: Physical Processor ID: 0
[    0.053331] CPU: Processor Core ID: 0
[    0.056670] using C1E aware idle routine
[    0.060018] ACPI: Core revision 20080609
[    0.070057] Getting VERSION: 80050010
[    0.073331] Getting VERSION: 80050010
[    0.076663] Getting ID: 0
[    0.079466] Getting ID: ff000000
[    0.079994] Getting LVT0: 10000
[    0.079997] Getting LVT1: 10000
[    0.083331] masked ExtINT on CPU#0
[    0.086902] ENABLING IO-APIC IRQs
[    0.089996] init IO_APIC IRQs
[    0.089997]  IO-APIC (apicid-pin) 4-0 not connected.
[    0.090004] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.090011] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.090018] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.090024] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.090031] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.090037] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.090044] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.090050] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.090057] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1)
[    0.090064] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.090070] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.090077] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.090083] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.090090] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.090096] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.090102]  IO-APIC (apicid-pin) 4-16, 4-17, 4-18, 4-19, 4-20, 4-21, 4-22, 4-23 not connected.
[    0.090269] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.128401] CPU0: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.134745] Using local APIC timer interrupts.
[    0.139992] APIC timer calibration result 12499723
[    0.139993] Detected 12.499 MHz APIC timer.
[    0.143480] lockdep: fixing up alternatives.
[    0.146682] Booting processor 1/1 ip 6000
[    0.003333] Initializing CPU#1
[    0.003333] masked ExtINT on CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 5602.22 BogoMIPS (lpj=9333163)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU 1/1 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.243715] CPU1: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.253369] lockdep: fixing up alternatives.
[    0.256664] Booting processor 2/2 ip 6000
[    0.003333] Initializing CPU#2
[    0.003333] masked ExtINT on CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 5602.19 BogoMIPS (lpj=9333118)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU 2/2 -> Node 1
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.353887] CPU2: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.363387] lockdep: fixing up alternatives.
[    0.366664] Booting processor 3/3 ip 6000
[    0.003333] Initializing CPU#3
[    0.003333] masked ExtINT on CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 5602.23 BogoMIPS (lpj=9333181)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU 3/3 -> Node 1
[    0.003333] CPU: Physical Processor ID: 1
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.463879] CPU3: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
[    0.473316] Brought up 4 CPUs
[    0.476465] Total of 4 processors activated (22408.86 BogoMIPS).
[    0.476698] Testing NMI watchdog ... OK.
[    0.550266] net_namespace: 968 bytes
[    0.553490] xor: automatically using best checksumming function: generic_sse
[    0.573302]    generic_sse:  8630.400 MB/sec
[    0.576635] xor: using function: generic_sse (8630.400 MB/sec)
[    0.580028] NET: Registered protocol family 16
[    0.583586] No dock devices found.
[    0.586837] node 0 link 2: io port [1000, 3fff]
[    0.586839] TOM: 00000000d0000000 aka 3328M
[    0.589969] node 0 link 2: mmio [d0000000, dfffffff]
[    0.589972] node 0 link 2: mmio [a0000, bffff]
[    0.589974] node 0 link 2: mmio [e0000000, e7ffffff]
[    0.589976] TOM2: 0000000230000000 aka 8960M
[    0.593302] bus: [00,ff] on node 0 link 2
[    0.593304] bus: 00 index 0 io port: [0, ffff]
[    0.593306] bus: 00 index 1 mmio: [d0000000, ffffffff]
[    0.593307] bus: 00 index 2 mmio: [a0000, bffff]
[    0.593309] bus: 00 index 3 mmio: [230000000, fcffffffff]
[    0.593324] ACPI: bus type pci registered
[    0.596780] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 4
[    0.599969] PCI: MCFG area at e0000000 reserved in E820
[    0.603407] PCI: Using MMCONFIG at e0000000 - e04fffff
[    0.606635] PCI: Using configuration type 1 for base access
[    0.617553] ACPI: EC: Look up EC in DSDT
[    0.621933] ACPI: Interpreter enabled
[    0.623302] ACPI: (supports S0 S1 S3 S4 S5)
[    0.630429] ACPI: Using IOAPIC for interrupt routing
[    0.643218] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.643602] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.646639] pci 0000:00:01.1: PME# disabled
[    0.650008] pci 0000:00:02.0: supports D1
[    0.650009] pci 0000:00:02.0: supports D2
[    0.650011] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.653303] pci 0000:00:02.0: PME# disabled
[    0.656671] pci 0000:00:02.1: supports D1
[    0.656673] pci 0000:00:02.1: supports D2
[    0.656674] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.659969] pci 0000:00:02.1: PME# disabled
[    0.663528] pci 0000:00:08.0: supports D1
[    0.663530] pci 0000:00:08.0: supports D2
[    0.663531] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.666637] pci 0000:00:08.0: PME# disabled
[    0.670016] pci 0000:00:09.0: supports D1
[    0.670017] pci 0000:00:09.0: supports D2
[    0.670019] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.673304] pci 0000:00:09.0: PME# disabled
[    0.676666] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.679969] pci 0000:00:0a.0: PME# disabled
[    0.683330] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.686636] pci 0000:00:0d.0: PME# disabled
[    0.689998] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.693302] pci 0000:00:0f.0: PME# disabled
[    0.696873] pci 0000:01:04.0: supports D1
[    0.696875] pci 0000:01:04.0: supports D2
[    0.696898] pci 0000:00:06.0: transparent bridge
[    0.699969] PCI: bridge 0000:00:06.0 io port: [3000, 3fff]
[    0.703303] PCI: bridge 0000:00:06.0 32bit mmio: [d0100000, d01fffff]
[    0.706636] PCI: bridge 0000:00:06.0 32bit mmio pref: [d8000000, dfffffff]
[    0.710035] pci 0000:02:00.0: supports D1
[    0.710066] PCI: bridge 0000:00:0a.0 32bit mmio: [d0200000, d02fffff]
[    0.713386] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.713458] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    0.713481] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
[    0.713508] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
[    0.713533] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR5._PRT]
[    0.739522] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.746786] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    0.756769] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.767155] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.778473] ACPI: PCI Interrupt Link [LK1E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.789236] ACPI: PCI Interrupt Link [LK2E] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    0.795676] ACPI: PCI Interrupt Link [LK3E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.803377] ACPI: PCI Interrupt Link [LK4E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.813825] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.825139] ACPI: PCI Interrupt Link [LUS0] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    0.834586] ACPI: PCI Interrupt Link [LMA2] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    0.844277] ACPI: PCI Interrupt Link [LUS2] (IRQs *5 7 10 11 14 15 16 17 18 19 20 21 22 23)
[    0.853963] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    0.863825] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.873830] ACPI: PCI Interrupt Link [LPID] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
[    0.885589] ACPI: PCI Interrupt Link [LTID] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    0.891879] ACPI: PCI Interrupt Link [LSI1] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
[    0.901564] ACPI: PCI Interrupt Link [LSI2] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
[    0.911393] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.913365] pnp: PnP ACPI init
[    0.916646] ACPI: bus type pnp registered
[    0.920659] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.921289] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.921379] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.923450] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.923886] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.924783] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.925590] pnp: PnP ACPI: found 14 devices
[    0.926636] ACPI: ACPI bus type pnp unregistered
[    0.930238] SCSI subsystem initialized
[    0.933467] libata version 3.00 loaded.
[    0.933747] usbcore: registered new interface driver usbfs
[    0.936702] usbcore: registered new interface driver hub
[    0.940064] usbcore: registered new device driver usb
[    0.943673] PCI: Using ACPI for IRQ routing
[    0.946637] number of MP IRQ sources: 16.
[    0.946639] number of IO-APIC #4 registers: 24.
[    0.946640] testing the IO APIC.......................
[    0.949973] 
[    0.953302] IO APIC #4......
[    0.953303] .... register #00: 04000000
[    0.953304] .......    : physical APIC id: 04
[    0.953306] .... register #01: 00170011
[    0.953307] .......     : max redirection entries: 0017
[    0.953308] .......     : PRQ implemented: 0
[    0.953310] .......     : IO APIC version: 0011
[    0.953311] .... register #02: 04000000
[    0.953312] .......     : arbitration: 04
[    0.953314] .... IRQ redirection table:
[    0.953315]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    0.953320]  00 000 1    0    0   0   0    0    0    00
[    0.953326]  01 00F 0    0    0   0   0    1    1    31
[    0.953331]  02 00F 0    0    0   0   0    1    1    30
[    0.953337]  03 00F 0    0    0   0   0    1    1    33
[    0.953343]  04 00F 0    0    0   0   0    1    1    34
[    0.953348]  05 00F 1    0    0   0   0    1    1    35
[    0.953354]  06 00F 0    0    0   0   0    1    1    36
[    0.953360]  07 00F 0    0    0   0   0    1    1    37
[    0.953365]  08 00F 0    0    0   0   0    1    1    38
[    0.953371]  09 00F 0    1    0   1   0    1    1    39
[    0.953377]  0a 00F 1    0    0   0   0    1    1    3A
[    0.953382]  0b 00F 1    0    0   0   0    1    1    3B
[    0.953388]  0c 00F 0    0    0   0   0    1    1    3C
[    0.953393]  0d 00F 0    0    0   0   0    1    1    3D
[    0.953399]  0e 00F 0    0    0   0   0    1    1    3E
[    0.953405]  0f 00F 0    0    0   0   0    1    1    3F
[    0.953410]  10 000 1    0    0   0   0    0    0    00
[    0.953416]  11 000 1    0    0   0   0    0    0    00
[    0.953422]  12 000 1    0    0   0   0    0    0    00
[    0.953427]  13 000 1    0    0   0   0    0    0    00
[    0.953433]  14 000 1    0    0   0   0    0    0    00
[    0.953438]  15 000 1    0    0   0   0    0    0    00
[    0.953444]  16 000 1    0    0   0   0    0    0    00
[    0.953450]  17 000 1    0    0   0   0    0    0    00
[    0.953452] IRQ to pin mappings:
[    0.953453] IRQ0 -> 0:2
[    0.953455] IRQ1 -> 0:1
[    0.953457] IRQ3 -> 0:3
[    0.953459] IRQ4 -> 0:4
[    0.953460] IRQ5 -> 0:5
[    0.953462] IRQ6 -> 0:6
[    0.953464] IRQ7 -> 0:7
[    0.953466] IRQ8 -> 0:8
[    0.953467] IRQ9 -> 0:9
[    0.953469] IRQ10 -> 0:10
[    0.953471] IRQ11 -> 0:11
[    0.953472] IRQ12 -> 0:12
[    0.953474] IRQ13 -> 0:13
[    0.953476] IRQ14 -> 0:14
[    0.953478] IRQ15 -> 0:15
[    0.953483] .................................... done.
[    0.973557] PCI-DMA: Disabling AGP.
[    0.977781] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.979968] PCI-DMA: using GART IOMMU.
[    0.983304] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.987206] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.993677] hpet0: 3 32-bit timers, 25000000 Hz
[    0.997730] ACPI: RTC can wake from S4
[    0.999979] Switched to high resolution mode on CPU 0
[    1.000026] Switched to high resolution mode on CPU 3
[    1.000047] Switched to high resolution mode on CPU 2
[    1.003246] Switched to high resolution mode on CPU 1
[    1.013368] system 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
[    1.021203] system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.029036] system 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
[    1.036872] system 00:00: iomem range 0xfed00000-0xfed00fff has been reserved
[    1.044213] system 00:03: iomem range 0xd0000000-0xd0007fff has been reserved
[    1.051552] system 00:04: ioport range 0x1000-0x107f has been reserved
[    1.058279] system 00:04: ioport range 0x1080-0x10ff has been reserved
[    1.065003] system 00:04: ioport range 0x1400-0x147f has been reserved
[    1.071729] system 00:04: ioport range 0x1480-0x14ff has been reserved
[    1.078456] system 00:04: ioport range 0x1800-0x187f has been reserved
[    1.085183] system 00:04: ioport range 0x1880-0x18ff has been reserved
[    1.091907] system 00:04: ioport range 0x2440-0x247f has been reserved
[    1.098632] system 00:04: ioport range 0x2400-0x243f has been reserved
[    1.105366] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    1.111916] system 00:07: ioport range 0xc05-0xc06 has been reserved
[    1.119679] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    1.125800] pci 0000:00:06.0:   IO window: 0x3000-0x3fff
[    1.131311] pci 0000:00:06.0:   MEM window: 0xd0100000-0xd01fffff
[    1.137610] pci 0000:00:06.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
[    1.145526] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    1.151643] pci 0000:00:0a.0:   IO window: disabled
[    1.156719] pci 0000:00:0a.0:   MEM window: 0xd0200000-0xd02fffff
[    1.163006] pci 0000:00:0a.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
[    1.170932] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:03
[    1.177044] pci 0000:00:0d.0:   IO window: disabled
[    1.182114] pci 0000:00:0d.0:   MEM window: disabled
[    1.187271] pci 0000:00:0d.0:   PREFETCH window: disabled
[    1.192861] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:04
[    1.198979] pci 0000:00:0f.0:   IO window: disabled
[    1.204048] pci 0000:00:0f.0:   MEM window: disabled
[    1.209205] pci 0000:00:0f.0:   PREFETCH window: disabled
[    1.214801] pci 0000:00:06.0: setting latency timer to 64
[    1.214807] pci 0000:00:0a.0: setting latency timer to 64
[    1.214812] pci 0000:00:0d.0: setting latency timer to 64
[    1.214817] pci 0000:00:0f.0: setting latency timer to 64
[    1.214820] bus: 00 index 0 io port: [0, ffff]
[    1.219456] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    1.224874] bus: 01 index 0 io port: [3000, 3fff]
[    1.229771] bus: 01 index 1 mmio: [d0100000, d01fffff]
[    1.239972] bus: 01 index 2 mmio: [d8000000, dfffffff]
[    1.245301] bus: 01 index 3 io port: [0, ffff]
[    1.249937] bus: 01 index 4 mmio: [0, ffffffffffffffff]
[    1.255354] bus: 02 index 0 mmio: [0, 0]
[    1.259472] bus: 02 index 1 mmio: [d0200000, d02fffff]
[    1.264801] bus: 02 index 2 mmio: [d1000000, d10fffff]
[    1.270132] bus: 02 index 3 mmio: [0, 0]
[    1.274253] bus: 03 index 0 mmio: [0, 0]
[    1.278370] bus: 03 index 1 mmio: [0, 0]
[    1.282488] bus: 03 index 2 mmio: [0, 0]
[    1.286605] bus: 03 index 3 mmio: [0, 0]
[    1.290722] bus: 04 index 0 mmio: [0, 0]
[    1.294838] bus: 04 index 1 mmio: [0, 0]
[    1.298955] bus: 04 index 2 mmio: [0, 0]
[    1.303073] bus: 04 index 3 mmio: [0, 0]
[    1.307207] NET: Registered protocol family 2
[    1.343606] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.353558] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.366101] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    1.375860] TCP: Hash tables configured (established 524288 bind 65536)
[    1.382707] TCP reno registered
[    1.393492] NET: Registered protocol family 1
[    1.398166] checking if image is initramfs... it is
[    1.501735] Freeing initrd memory: 1922k freed
[    1.507469] Simple Boot Flag at 0x37 set to 0x80
[    1.515235] audit: initializing netlink socket (disabled)
[    1.520899] type=2000 audit(1221619050.520:1): initialized
[    1.532146] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.542716] VFS: Disk quotas dquot_6.5.1
[    1.546980] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.555347] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.562281] msgmni has been set to 15840
[    1.566647] async_tx: api initialized (async)
[    1.571215] io scheduler noop registered
[    1.575345] io scheduler anticipatory registered
[    1.580169] io scheduler deadline registered
[    1.584841] io scheduler cfq registered (default)
[    1.589785] pci 0000:00:00.0: Enabling HT MSI Mapping
[    1.797529] pci 0000:00:05.0: Enabling HT MSI Mapping
[    1.802799] pci 0000:00:05.1: Enabling HT MSI Mapping
[    1.808074] pci 0000:00:05.2: Enabling HT MSI Mapping
[    1.813351] pci 0000:00:06.0: Enabling HT MSI Mapping
[    1.818632] pci 0000:00:08.0: Enabling HT MSI Mapping
[    1.823910] pci 0000:00:09.0: Enabling HT MSI Mapping
[    1.829182] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    1.834452] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    1.839721] pci 0000:00:0f.0: Enabling HT MSI Mapping
[    1.844991] pci 0000:01:04.0: Boot video device
[    1.845193] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    1.845222] pcieport-driver 0000:00:0a.0: found MSI capability
[    1.851316] pci_express 0000:00:0a.0:pcie00: allocate port service
[    1.851407] pci_express 0000:00:0a.0:pcie01: allocate port service
[    1.851468] pci_express 0000:00:0a.0:pcie03: allocate port service
[    1.851570] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[    1.851596] pcieport-driver 0000:00:0d.0: found MSI capability
[    1.857661] pci_express 0000:00:0d.0:pcie00: allocate port service
[    1.857732] pci_express 0000:00:0d.0:pcie01: allocate port service
[    1.857791] pci_express 0000:00:0d.0:pcie03: allocate port service
[    1.857892] pcieport-driver 0000:00:0f.0: setting latency timer to 64
[    1.857923] pcieport-driver 0000:00:0f.0: found MSI capability
[    1.863984] pci_express 0000:00:0f.0:pcie00: allocate port service
[    1.864056] pci_express 0000:00:0f.0:pcie01: allocate port service
[    1.864116] pci_express 0000:00:0f.0:pcie03: allocate port service
[    1.865960] aer 0000:00:0a.0:pcie01: AER service couldn't init device: no _OSC support
[    1.867614] aer 0000:00:0d.0:pcie01: AER service couldn't init device: no _OSC support
[    1.869243] aer 0000:00:0f.0:pcie01: AER service couldn't init device: no _OSC support
[    1.869694] input: Power Button (FF) as /class/input/input0
[    1.875475] ACPI: Power Button (FF) [PWRF]
[    1.879888] input: Power Button (CM) as /class/input/input1
[    1.885657] ACPI: Power Button (CM) [PWRB]
[    1.890403] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.896470] processor ACPI0007:00: registered as cooling_device0
[    1.902681] ACPI: Processor [C000] (supports 2 throttling states)
[    1.909166] processor ACPI0007:01: registered as cooling_device1
[    1.915478] processor ACPI0007:02: registered as cooling_device2
[    1.921779] processor ACPI0007:03: registered as cooling_device3
[    2.001837] hpet_resources: 0xfed00000 is busy
[    2.002038] Non-volatile memory driver v1.2
[    2.006568] Linux agpgart interface v0.103
[    2.010966] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
[    2.017552] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.024529] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.030642] Floppy drive(s): fd0 is 1.44M
[    5.046687] floppy0: no floppy controllers found
[    5.054215] brd: module loaded
[    5.058709] loop: module loaded
[    5.062049] tun: Universal TUN/TAP device driver, 1.6
[    5.067295] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.073870] console [netcon0] enabled
[    5.077726] netconsole: network logging started
[    5.082451] Uniform Multi-Platform E-IDE driver
[    5.087308] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    5.097421] Probing IDE interface ide0...
[    6.063534] hdb: CD-224E-N, ATAPI CD/DVD-ROM drive
[    6.120118] Probing IDE interface ide1...
[    6.653446] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.658285] ide1 at 0x170-0x177,0x376 on irq 15
[    6.665085] hdb: ATAPI 24X CD-ROM drive, 256kB Cache
[    6.670460] Uniform CD-ROM driver Revision: 3.20
[    6.685431] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    6.693244] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    6.700497] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
[    6.706688] Driver 'sd' needs updating - please use bus_type methods
[    6.713309] Driver 'sr' needs updating - please use bus_type methods
[    6.720482] sata_nv 0000:00:05.0: version 3.5
[    6.720779] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
[    6.726726] IOAPIC[0]: Set routing entry (4-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
[    6.726743] sata_nv 0000:00:05.0: PCI INT A -> Link[LTID] -> GSI 23 (level, low) -> IRQ 23
[    6.735353] sata_nv 0000:00:05.0: Using SWNCQ mode
[    6.740472] sata_nv 0000:00:05.0: setting latency timer to 64
[    6.740651] scsi0 : sata_nv
[    6.743839] scsi1 : sata_nv
[    6.747023] ata1: SATA max UDMA/133 cmd 0x24d0 ctl 0x24c4 bmdma 0x2490 irq 23
[    6.754354] ata2: SATA max UDMA/133 cmd 0x24c8 ctl 0x24c0 bmdma 0x2498 irq 23
[    7.090373] ata1: SATA link down (SStatus 0 SControl 300)
[    7.423705] ata2: SATA link down (SStatus 0 SControl 300)
[    7.429582] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 22
[    7.435536] IOAPIC[0]: Set routing entry (4-22 -> 0x69 -> IRQ 22 Mode:1 Active:1)
[    7.435551] sata_nv 0000:00:05.1: PCI INT B -> Link[LSI1] -> GSI 22 (level, low) -> IRQ 22
[    7.444165] sata_nv 0000:00:05.1: Using SWNCQ mode
[    7.449263] sata_nv 0000:00:05.1: setting latency timer to 64
[    7.449402] scsi2 : sata_nv
[    7.452526] scsi3 : sata_nv
[    7.455714] ata3: SATA max UDMA/133 cmd 0x24e8 ctl 0x24dc bmdma 0x24a0 irq 22
[    7.463043] ata4: SATA max UDMA/133 cmd 0x24e0 ctl 0x24d8 bmdma 0x24a8 irq 22
[    7.797000] ata3: SATA link down (SStatus 0 SControl 300)
[    8.130331] ata4: SATA link down (SStatus 0 SControl 300)
[    8.136202] ACPI: PCI Interrupt Link [LSI2] enabled at IRQ 21
[    8.142156] IOAPIC[0]: Set routing entry (4-21 -> 0x71 -> IRQ 21 Mode:1 Active:1)
[    8.142172] sata_nv 0000:00:05.2: PCI INT C -> Link[LSI2] -> GSI 21 (level, low) -> IRQ 21
[    8.150785] sata_nv 0000:00:05.2: Using SWNCQ mode
[    8.155882] sata_nv 0000:00:05.2: setting latency timer to 64
[    8.156027] scsi4 : sata_nv
[    8.159160] scsi5 : sata_nv
[    8.162335] ata5: SATA max UDMA/133 cmd 0x2800 ctl 0x24f4 bmdma 0x24b0 irq 21
[    8.169672] ata6: SATA max UDMA/133 cmd 0x24f8 ctl 0x24f0 bmdma 0x24b8 irq 21
[    8.507038] ata5: SATA link down (SStatus 0 SControl 300)
[    8.840372] ata6: SATA link down (SStatus 0 SControl 300)
[    8.846110] pata_amd 0000:00:04.0: version 0.3.10
[    8.846134] pata_amd 0000:00:04.0: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
[    8.853891] pata_amd 0000:00:04.0: failed to request/iomap BARs for port 0 (errno=-16)
[    8.862160] pata_amd 0000:00:04.0: BAR 2: can't reserve I/O region [0x170-0x177]
[    8.869906] pata_amd 0000:00:04.0: failed to request/iomap BARs for port 1 (errno=-16)
[    8.878166] pata_amd 0000:00:04.0: no available native port
[    8.884290] Fusion MPT base driver 3.04.07
[    8.888582] Copyright (c) 1999-2008 LSI Corporation
[    8.893666] Fusion MPT SPI Host driver 3.04.07
[    8.898396] Fusion MPT SAS Host driver 3.04.07
[    8.903765] ieee1394: raw1394: /dev/raw1394 device initialized
[    8.910299] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
[    8.916243] IOAPIC[0]: Set routing entry (4-20 -> 0x79 -> IRQ 20 Mode:1 Active:1)
[    8.916257] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 20 (level, low) -> IRQ 20
[    8.924965] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    8.924968] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    8.930641] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    8.938414] ehci_hcd 0000:00:02.1: debug port 1
[    8.943142] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    8.943159] ehci_hcd 0000:00:02.1: irq 20, io mem 0xd0041000
[    8.956681] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    8.964675] usb usb1: configuration #1 chosen from 1 choice
[    8.970539] hub 1-0:1.0: USB hub found
[    8.974502] hub 1-0:1.0: 10 ports detected
[    9.080399] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.080655] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 19
[    9.086607] IOAPIC[0]: Set routing entry (4-19 -> 0x81 -> IRQ 19 Mode:1 Active:1)
[    9.086622] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 19 (level, low) -> IRQ 19
[    9.095328] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    9.095330] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    9.100926] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    9.108695] ohci_hcd 0000:00:02.0: irq 19, io mem 0xd0040000
[    9.168822] usb usb2: configuration #1 chosen from 1 choice
[    9.174679] hub 2-0:1.0: USB hub found
[    9.178639] hub 2-0:1.0: 10 ports detected
[    9.283663] USB Universal Host Controller Interface driver v3.0
[    9.289954] usbcore: registered new interface driver usblp
[    9.295643] Initializing USB Mass Storage driver...
[    9.300787] usbcore: registered new interface driver usb-storage
[    9.306995] USB Mass Storage support registered.
[    9.311965] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    9.570302] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.575666] mice: PS/2 mouse device common for all mice
[    9.613337] md: linear personality registered for level -1
[    9.780862] md: raid0 personality registered for level 0
[    9.786372] md: raid1 personality registered for level 1
[    9.791884] md: raid10 personality registered for level 10
[    9.853774] raid6: int64x1   2557 MB/s
[    9.913770] raid6: int64x2   3277 MB/s
[    9.973759] raid6: int64x4   3227 MB/s
[   10.033775] raid6: int64x8   2269 MB/s
[   10.093762] raid6: sse2x1    3908 MB/s
[   10.153763] raid6: sse2x2    5114 MB/s
[   10.213758] raid6: sse2x4    5239 MB/s
[   10.217700] raid6: using algorithm sse2x4 (5239 MB/s)
[   10.222948] md: raid6 personality registered for level 6
[   10.228459] md: raid5 personality registered for level 5
[   10.233971] md: raid4 personality registered for level 4
[   10.244367] md: multipath personality registered for level -4
[   10.250567] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[   10.259494] cpuidle: using governor ladder
[   10.264025] cpuidle: using governor menu
[   10.268217] usbcore: registered new interface driver usbhid
[   10.273985] usbhid: v2.6:USB HID core driver
[   10.278568] oprofile: using NMI interrupt.
[   10.283357] TCP cubic registered
[   10.287003] NET: Registered protocol family 10
[   10.292656] IPv6 over IPv4 tunneling driver
[   10.297796] NET: Registered protocol family 17
[   10.302830] RPC: Registered udp transport module.
[   10.307731] RPC: Registered tcp transport module.
[   10.312719] powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 2220 processors (4 cpu cores) (version 2.20.00)
[   10.316673] powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
[   10.329561] powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
[   10.335416] powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
[   10.341275] powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
[   10.347059] powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
[   10.352912] powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
[   10.358772] powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
[   10.317508] powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
[   10.370709] powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
[   10.376570] powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
[   10.382429] powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
[   10.388200] powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
[   10.394060] powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
[   10.399918] powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
[   10.406608] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   10.413157] Freeing unused kernel memory: 676k freed
[   10.418705] Write protecting the kernel read-only data: 5672k
[   10.853151] ACPI: PCI Interrupt Link [LK3E] enabled at IRQ 18
[   10.853161] IOAPIC[0]: Set routing entry (4-18 -> 0x89 -> IRQ 18 Mode:1 Active:1)
[   10.853223] arcmsr 0000:02:00.0: PCI INT A -> Link[LK3E] -> GSI 18 (level, low) -> IRQ 18
[   10.853230] arcmsr 0000:02:00.0: setting latency timer to 64
[   10.866697] ARECA RAID ADAPTER6: FIRMWARE VERSION V1.44 2008-1-31  
[   10.880018] scsi6 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
[   10.880019]  Driver Version 1.20.00.15 2008/02/27
[   10.881528] scsi 6:0:0:0: Direct-Access     Areca    ARC-1280-VOL#00  R001 PQ: 0 ANSI: 5
[   10.882676] sd 6:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[   10.882721] sd 6:0:0:0: [sda] 21484367872 512-byte hardware sectors (10999996 MB)
[   10.882768] sd 6:0:0:0: [sda] Write Protect is off
[   10.882772] sd 6:0:0:0: [sda] Mode Sense: cb 00 00 08
[   10.882851] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.883023] sd 6:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
[   10.883067] sd 6:0:0:0: [sda] 21484367872 512-byte hardware sectors (10999996 MB)
[   10.883108] sd 6:0:0:0: [sda] Write Protect is off
[   10.883111] sd 6:0:0:0: [sda] Mode Sense: cb 00 00 08
[   10.883190] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.883195]  sda: sda1 sda2 sda3 sda4
[   10.915493] sd 6:0:0:0: [sda] Attached SCSI disk
[   10.916329] sd 6:0:0:0: Attached scsi generic sg0 type 0
[   10.917710] scsi 6:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
[   10.918870] scsi 6:0:16:0: Attached scsi generic sg1 type 3
[   11.000429] Clocksource tsc unstable (delta = -89318010 ns)
[   11.073271] 3ware Storage Controller device driver for Linux v1.26.02.002.
[   11.094544] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
[   11.128602] Adaptec aacraid driver 1.1-5[2456]-ms
[   11.402730] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[   11.408669] SGI XFS Quota Management subsystem
[   11.459380] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
[   11.459388] Copyright (c) 1999-2006 Intel Corporation.
[   14.751255] kjournald starting.  Commit interval 5 seconds
[   14.751255] EXT3-fs: mounted filesystem with ordered data mode.
[   17.062543] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2440
[   17.062600] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2400
[   17.073911] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   17.074765] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 17
[   17.074780] IOAPIC[0]: Set routing entry (4-17 -> 0x91 -> IRQ 17 Mode:1 Active:1)
[   17.074895] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 17 (level, low) -> IRQ 17
[   17.074908] forcedeth 0000:00:08.0: setting latency timer to 64
[   17.079543] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 0, addr 00:e0:81:76:28:d6
[   17.079558] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   17.080351] ACPI: PCI Interrupt Link [LMA2] enabled at IRQ 16
[   17.080363] IOAPIC[0]: Set routing entry (4-16 -> 0x99 -> IRQ 16 Mode:1 Active:1)
[   17.080418] forcedeth 0000:00:09.0: PCI INT A -> Link[LMA2] -> GSI 16 (level, low) -> IRQ 16
[   17.080427] forcedeth 0000:00:09.0: setting latency timer to 64
[   17.083446] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:76:28:d7
[   17.083454] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   17.972394] EXT3 FS on sda3, internal journal
[   18.304174] SMsC 37B787 watchdog component driver 1.1 initialising...
[   18.305555] smsc37b787_wdt: Timeout set to 60 second(s).
[   18.305560] smsc37b787_wdt: Watchdog initialized and sleeping (nowayout=0)...
[   20.567087] kjournald starting.  Commit interval 5 seconds
[   20.590125] EXT3 FS on sda4, internal journal
[   20.590141] EXT3-fs: mounted filesystem with journal data mode.
[   20.644881] Adding 15999992k swap on /dev/sda2.  Priority:-1 extents:1 across:15999992k
[   40.560439] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   40.567835] NFSD: starting 90-second grace period
[   42.150031] eth0: no IPv6 routers present
[   48.719390] w83627hf: Found W83627HF chip at 0xc00
[   49.799833] kjournald starting.  Commit interval 5 seconds
[   49.800228] EXT3 FS on sda1, internal journal
[   49.800255] EXT3-fs: mounted filesystem with ordered data mode.

--vkogqOf2sHV7VnPd--
