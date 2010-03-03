Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0CCPR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:17:28 -0500
Received: from thunk.org ([69.25.196.29]:59748 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab0CCPRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:17:23 -0500
Date: Wed, 3 Mar 2010 10:17:20 -0500
From: tytso@mit.edu
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION] X doesn't work with 2.6.33 (can't find any input
 devices)
Message-ID: <20100303151720.GA3191@thunk.org>
Mail-Followup-To: tytso@mit.edu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

After working around lvm breakage so I could at least boot 2.6.33, I'm
now finding the next problem --- X doesn't work.  If I let X come up,
it doesn't find any mouse or keyboard devices, so my machine becomes
useless and I have to power cycle it unless I can log in remotely and
reboot it.

It worked just *fine* using 2.6.33-rc4.  I have no xorg.conf file (X
is autoconfiguring itself) and I'm using an Ubuntu 9.10 userspace.

I've enclosed the dmesg output (which shows the input devices
correctly being detected by the kernel) and the Xorg.0.log file from
the previous boot, where X does not come up.

At this point, I'm not going to be able to dogfood test my ext4
patches I plan to push to Linus, since 2.6.33 is completely useless to
me.  Hopefully running the regression tests under KVM is going to have
to be good enough.

Grumble.

						- Ted

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.busted"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.33-00033-g18de96f (root@closure) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #47 SMP Wed Mar 3 00:18:34 EST 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.33-00033-g18de96f root=/dev/mapper/ssd2-root ro single break=premount
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DBFFF uncachable
[    0.000000]   DC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbda00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f6490] f6490
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] RAMDISK: 37767000 - 37fef11a
[    0.000000] ACPI: RSDP 00000000000f6450 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd94a1df 0009C (v01 LENOVO TP-7U    00003010  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd94a300 000F4 (v03 LENOVO TP-7U    00003010 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd94a6db 0F48F (v01 LENOVO TP-7U    00003010 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd94a4b4 00227 (v01 LENOVO TP-7U    00003010 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd959b6a 00052 (v01 LENOVO TP-7U    00003010 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd959bbc 00078 (v01 LENOVO TP-7U    00003010 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd959c34 0003C (v01 LENOVO TP-7U    00003010 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd959c70 00038 (v01 LENOVO TP-7U    00003010 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd959dc2 00176 (v01 LENOVO TP-7U    00003010  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd959f38 00028 (v01 LENOVO TP-7U    00003010  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd959f60 000A0 (v16 LENOVO TP-7U    00003010 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d213 0054F (v01 LENOVO TP-7U    00003010 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad T400
[    0.000000] ACPI: Added _OSI(Linux)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013c000000
[    0.000000] Bootmem setup node 0 0000000000000000-000000013c000000
[    0.000000]   NODE_DATA [000000000000b000 - 000000000003efff]
[    0.000000]   bootmap [000000000003f000 -  00000000000667ff] pages 28
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 000294fa70]    TEXT DATA BSS ==> [0001000000 - 000294fa70]
[    0.000000]   #2 [0037767000 - 0037fef11a]          RAMDISK ==> [0037767000 - 0037fef11a]
[    0.000000]   #3 [0002950000 - 000295014c]              BRK ==> [0002950000 - 000295014c]
[    0.000000]   #4 [00000f64a0 - 0000100000]    BIOS reserved ==> [00000f64a0 - 0000100000]
[    0.000000]   #5 [00000f6490 - 00000f64a0]     MP-table mpf ==> [00000f6490 - 00000f64a0]
[    0.000000]   #6 [000009ec00 - 000009f071]    BIOS reserved ==> [000009ec00 - 000009f071]
[    0.000000]   #7 [000009f17d - 00000f6490]    BIOS reserved ==> [000009f17d - 00000f6490]
[    0.000000]   #8 [000009f071 - 000009f17d]     MP-table mpc ==> [000009f071 - 000009f17d]
[    0.000000]   #9 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #10 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #11 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #12 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880028600000-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 106 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages/cpu @ffff88002be00000 s1925592 r8192 d24104 u2097152
[    0.000000] pcpu-alloc: s1925592 r8192 d24104 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1003645
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.33-00033-g18de96f root=/dev/mapper/ssd2-root ro single break=premount
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3919452k/5177344k available (5418k kernel code, 1091556k absent, 166336k reserved, 6345k data, 3428k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:440
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2527.341 MHz processor.
[    0.003348] Calibrating delay loop (skipped), value calculated using timer frequency.. 5056.29 BogoMIPS (lpj=8424470)
[    0.003680] Security Framework initialized
[    0.003798] SELinux:  Disabled at boot.
[    0.004378] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008794] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009849] Mount-cache hash table entries: 256
[    0.010917] Initializing cgroup subsys debug
[    0.011026] Initializing cgroup subsys ns
[    0.011136] Initializing cgroup subsys cpuacct
[    0.011252] Initializing cgroup subsys devices
[    0.011359] Initializing cgroup subsys freezer
[    0.011468] Initializing cgroup subsys net_cls
[    0.011647] CPU: Physical Processor ID: 0
[    0.011754] CPU: Processor Core ID: 0
[    0.011862] mce: CPU supports 6 MCE banks
[    0.011974] CPU0: Thermal monitoring enabled (TM2)
[    0.012084] using mwait in idle threads.
[    0.012191] Performance Events: Core2 events, Intel PMU driver.
[    0.012391] ... version:                2
[    0.012498] ... bit width:              40
[    0.012604] ... generic registers:      2
[    0.012711] ... value mask:             000000ffffffffff
[    0.012820] ... max period:             000000007fffffff
[    0.012929] ... fixed-purpose events:   3
[    0.013036] ... event mask:             0000000700000003
[    0.014292] ACPI: Core revision 20091214
[    0.056686] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.056798] ftrace: allocating 26881 entries in 106 pages
[    0.063377] DMAR: Host address width 36
[    0.063484] DMAR: DRHD base: 0x000000feb03000 flags: 0x0
[    0.063601] IOMMU feb03000: ver 1:0 cap c9008020e30260 ecap 1000
[    0.063709] DMAR: DRHD base: 0x000000feb01000 flags: 0x0
[    0.063826] IOMMU feb01000: ver 1:0 cap c0000020630260 ecap 1000
[    0.063934] DMAR: DRHD base: 0x000000feb00000 flags: 0x0
[    0.064053] IOMMU feb00000: ver 1:0 cap c0000020630270 ecap 1000
[    0.064162] DMAR: DRHD base: 0x000000feb02000 flags: 0x1
[    0.064278] IOMMU feb02000: ver 1:0 cap c9008020630260 ecap 1000
[    0.064386] DMAR: RMRR base: 0x000000fc226c00 end: 0x000000fc2273ff
[    0.064495] DMAR: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[    0.064612] Setting APIC routing to flat
[    0.065134] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.098256] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 0a
[    0.099999] lockdep: fixing up alternatives.
[    0.099999] Booting Node   0, Processors  #1
[    0.193388] Brought up 2 CPUs
[    0.193595] Total of 2 processors activated (10112.86 BogoMIPS).
[    0.195499] khelper used greatest stack depth: 5328 bytes left
[    0.195499] khelper used greatest stack depth: 4992 bytes left
[    0.197532] regulator: core version 0.5
[    0.197671] NET: Registered protocol family 16
[    0.197671] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.197671] ACPI: bus type pci registered
[    0.197671] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.197671] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
[    0.213822] PCI: Using configuration type 1 for base access
[    0.223783] bio: create slab <bio-0> at 0
[    0.239856] ACPI: EC: EC description table is found, configuring boot EC
[    0.256664] ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.275516] ACPI: Interpreter enabled
[    0.275623] ACPI: (supports S0 S3 S4 S5)
[    0.275943] ACPI: Using IOAPIC for interrupt routing
[    0.307709] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.307709] ACPI: Power Resource [PUBS] (on)
[    0.313547] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.314272] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.314506] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.314506] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.314506] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.314506] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.314506] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.314506] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.314506] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff] (ignored)
[    0.314506] pci 0000:00:02.0: reg 10: [mem 0xf4400000-0xf47fffff 64bit]
[    0.314506] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.314506] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.314506] pci 0000:00:02.1: reg 10: [mem 0xf4200000-0xf42fffff 64bit]
[    0.314506] pci 0000:00:03.0: reg 10: [mem 0xfc226800-0xfc22680f 64bit]
[    0.314506] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.314506] pci 0000:00:03.0: PME# disabled
[    0.314506] pci 0000:00:19.0: reg 10: [mem 0xfc000000-0xfc01ffff]
[    0.314506] pci 0000:00:19.0: reg 14: [mem 0xfc025000-0xfc025fff]
[    0.314506] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
[    0.314506] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.314506] pci 0000:00:19.0: PME# disabled
[    0.314506] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
[    0.314542] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
[    0.314675] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
[    0.314808] pci 0000:00:1a.7: reg 10: [mem 0xfc226c00-0xfc226fff]
[    0.314909] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.314916] pci 0000:00:1a.7: PME# disabled
[    0.314986] pci 0000:00:1b.0: reg 10: [mem 0xfc020000-0xfc023fff 64bit]
[    0.315075] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.315081] pci 0000:00:1b.0: PME# disabled
[    0.315224] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.315230] pci 0000:00:1c.0: PME# disabled
[    0.315376] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.315382] pci 0000:00:1c.1: PME# disabled
[    0.316756] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.316763] pci 0000:00:1c.3: PME# disabled
[    0.316910] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.316916] pci 0000:00:1c.4: PME# disabled
[    0.317025] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
[    0.317157] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
[    0.317289] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
[    0.317423] pci 0000:00:1d.7: reg 10: [mem 0xfc227000-0xfc2273ff]
[    0.317524] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.317531] pci 0000:00:1d.7: PME# disabled
[    0.317876] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
[    0.317887] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
[    0.317897] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
[    0.317907] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
[    0.317918] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
[    0.317928] pci 0000:00:1f.2: reg 24: [mem 0xfc226000-0xfc2267ff]
[    0.317999] pci 0000:00:1f.2: PME# supported from D3hot
[    0.318005] pci 0000:00:1f.2: PME# disabled
[    0.318065] pci 0000:00:1f.3: reg 10: [mem 0xfc227400-0xfc2274ff 64bit]
[    0.318092] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
[    0.318266] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.318485] pci 0000:03:00.0: reg 10: [mem 0xf4300000-0xf4301fff 64bit]
[    0.318632] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.318640] pci 0000:03:00.0: PME# disabled
[    0.318785] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.318901] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.319039] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.319150] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.319156] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.319167] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.319296] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.319407] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.319414] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.319424] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.319489] pci 0000:15:00.0: reg 10: [mem 0xf4800000-0xf4800fff]
[    0.319529] pci 0000:15:00.0: supports D1 D2
[    0.319531] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.319538] pci 0000:15:00.0: PME# disabled
[    0.319599] pci 0000:15:00.1: reg 10: [mem 0xf4801000-0xf48017ff]
[    0.319699] pci 0000:15:00.1: supports D1 D2
[    0.319701] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.319708] pci 0000:15:00.1: PME# disabled
[    0.319870] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.319984] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.319990] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.320027] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.320123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.320406] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.320498] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.320602] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.320713] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.320824] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.340078] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.340821] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.341561] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.342299] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.343038] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.343810] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.344551] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.345290] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.345940] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.345940] vgaarb: loaded
[    0.346887] SCSI subsystem initialized
[    0.346888] libata version 3.00 loaded.
[    0.346913] ACPI: WMI: Mapper loaded
[    0.346913] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    0.346913] PCI: Using ACPI for IRQ routing
[    0.346984] PCI: pci_cache_line_size set to 64 bytes
[    0.350025] NET: Registered protocol family 8
[    0.350132] NET: Registered protocol family 20
[    0.350290] cfg80211: Using static regulatory domain info
[    0.350290] cfg80211: Regulatory domain: 00
[    0.350290]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.350411]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.350521]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    0.350631]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    0.350741]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.350851]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.351066] cfg80211: Calling CRDA to update world regulatory domain
[    0.351279] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.351279] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.351279] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.356837] Switching to clocksource tsc
[    0.395277] pnp: PnP ACPI init
[    0.395423] ACPI: bus type pnp registered
[    0.459942] pnp: PnP ACPI: found 10 devices
[    0.460049] ACPI: ACPI bus type pnp unregistered
[    0.460174] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.460285] system 00:00: [mem 0x000c0000-0x000c3fff] has been reserved
[    0.460396] system 00:00: [mem 0x000c4000-0x000c7fff] has been reserved
[    0.460506] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.460615] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.460725] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.460836] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.460947] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.461058] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.461168] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.461279] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.461389] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.461500] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.461612] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.461723] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.461846] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.461955] system 00:02: [io  0x1180-0x11ff] has been reserved
[    0.462069] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.462179] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.462288] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.462397] system 00:02: [io  0x1680-0x169f] has been reserved
[    0.462507] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    0.462617] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.462727] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.462855] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.462965] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.463076] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.469110] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    0.469221] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.469392] pci 0000:00:1c.1: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.469569] pci 0000:00:1c.0: BAR 7: assigned [io  0x8000-0x8fff]
[    0.469679] pci 0000:00:1c.1: BAR 7: assigned [io  0x9000-0x9fff]
[    0.469788] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.469897] pci 0000:00:1c.0:   bridge window [io  0x8000-0x8fff]
[    0.470012] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.470126] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.470303] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.470412] pci 0000:00:1c.1:   bridge window [io  0x9000-0x9fff]
[    0.470527] pci 0000:00:1c.1:   bridge window [mem 0xf4300000-0xf43fffff]
[    0.470640] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.470817] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    0.470926] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.471041] pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.471154] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.471331] pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
[    0.471440] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.471555] pci 0000:00:1c.4:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.473344] pci 0000:00:1c.4:   bridge window [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.473523] pci 0000:15:00.0: BAR 9: assigned [mem 0xf0000000-0xf3ffffff pref]
[    0.473693] pci 0000:15:00.0: BAR 10: assigned [mem 0xc4000000-0xc7ffffff]
[    0.473804] pci 0000:15:00.0: BAR 7: assigned [io  0x4000-0x40ff]
[    0.473913] pci 0000:15:00.0: BAR 8: assigned [io  0x4400-0x44ff]
[    0.474021] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.474129] pci 0000:15:00.0:   bridge window [io  0x4000-0x40ff]
[    0.474242] pci 0000:15:00.0:   bridge window [io  0x4400-0x44ff]
[    0.474356] pci 0000:15:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
[    0.474529] pci 0000:15:00.0:   bridge window [mem 0xc4000000-0xc7ffffff]
[    0.474643] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.474752] pci 0000:00:1e.0:   bridge window [io  0x4000-0x7fff]
[    0.474867] pci 0000:00:1e.0:   bridge window [mem 0xf4800000-0xf7ffffff]
[    0.474980] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.475179]   alloc irq_desc for 20 on node -1
[    0.475182]   alloc kstat_irqs on node -1
[    0.475191] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.475306] pci 0000:00:1c.0: setting latency timer to 64
[    0.475321]   alloc irq_desc for 21 on node -1
[    0.475323]   alloc kstat_irqs on node -1
[    0.475346] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.475459] pci 0000:00:1c.1: setting latency timer to 64
[    0.475474]   alloc irq_desc for 23 on node -1
[    0.475476]   alloc kstat_irqs on node -1
[    0.475484] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.475597] pci 0000:00:1c.3: setting latency timer to 64
[    0.475611] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.475725] pci 0000:00:1c.4: setting latency timer to 64
[    0.475737] pci 0000:00:1e.0: setting latency timer to 64
[    0.475753]   alloc irq_desc for 16 on node -1
[    0.475755]   alloc kstat_irqs on node -1
[    0.475763] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.475878] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.475880] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.475883] pci_bus 0000:02: resource 0 [io  0x8000-0x8fff]
[    0.475885] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.475887] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.475890] pci_bus 0000:03: resource 0 [io  0x9000-0x9fff]
[    0.475892] pci_bus 0000:03: resource 1 [mem 0xf4300000-0xf43fffff]
[    0.475894] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.475897] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.475899] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.475901] pci_bus 0000:05: resource 2 [mem 0xf4000000-0xf40fffff 64bit pref]
[    0.475903] pci_bus 0000:0d: resource 0 [io  0x3000-0x3fff]
[    0.475905] pci_bus 0000:0d: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.475908] pci_bus 0000:0d: resource 2 [mem 0xf4100000-0xf41fffff 64bit pref]
[    0.475910] pci_bus 0000:15: resource 0 [io  0x4000-0x7fff]
[    0.475912] pci_bus 0000:15: resource 1 [mem 0xf4800000-0xf7ffffff]
[    0.475914] pci_bus 0000:15: resource 2 [mem 0xf0000000-0xf3ffffff 64bit pref]
[    0.475917] pci_bus 0000:15: resource 3 [io  0x0000-0xffff]
[    0.475919] pci_bus 0000:15: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.475921] pci_bus 0000:16: resource 0 [io  0x4000-0x40ff]
[    0.475923] pci_bus 0000:16: resource 1 [io  0x4400-0x44ff]
[    0.475925] pci_bus 0000:16: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.475928] pci_bus 0000:16: resource 3 [mem 0xc4000000-0xc7ffffff]
[    0.476011] NET: Registered protocol family 2
[    0.476481] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.478757] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.482835] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    0.487530] TCP: Hash tables configured (established 524288 bind 65536)
[    0.487693] TCP reno registered
[    0.487839] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    0.488271] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    0.488907] NET: Registered protocol family 1
[    0.489397] RPC: Registered udp transport module.
[    0.489662] RPC: Registered tcp transport module.
[    0.489769] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.489900] pci 0000:00:02.0: Boot video device
[    0.490198] PCI: CLS 64 bytes, default 64
[    0.490352] Trying to unpack rootfs image as initramfs...
[    0.719687] Freeing initrd memory: 8736k freed
[    0.723647] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.723763] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.723932] software IO TLB at phys 0x20000000 - 0x24000000
[    0.724404] Simple Boot Flag at 0x35 set to 0x1
[    0.726683] audit: initializing netlink socket (disabled)
[    0.726830] type=2000 audit(1267628819.726:1): initialized
[    0.740271] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.748061] VFS: Disk quotas dquot_6.5.2
[    0.748403] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.751362] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.752134] fuse init (API version 7.13)
[    0.752616] msgmni has been set to 7672
[    0.753540] alg: No test for cipher_null (cipher_null-generic)
[    0.753708] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.753861] alg: No test for digest_null (digest_null-generic)
[    0.754013] alg: No test for compress_null (compress_null-generic)
[    0.755308] alg: No test for stdrng (krng)
[    0.755634] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.755815] io scheduler noop registered
[    0.755938] io scheduler cfq registered (default)
[    0.756608] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.756689]   alloc irq_desc for 24 on node -1
[    0.756691]   alloc kstat_irqs on node -1
[    0.756717] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.757098] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.757164]   alloc irq_desc for 25 on node -1
[    0.757166]   alloc kstat_irqs on node -1
[    0.757184] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.757550] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.757616]   alloc irq_desc for 26 on node -1
[    0.757618]   alloc kstat_irqs on node -1
[    0.757636] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.757997] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.758063]   alloc irq_desc for 27 on node -1
[    0.758065]   alloc kstat_irqs on node -1
[    0.758085] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    0.759350] power_supply AC: uevent
[    0.759352] power_supply AC: No power supply yet
[    0.759564] power_supply AC: power_supply_changed
[    0.759571] ACPI: AC Adapter [AC] (on-line)
[    0.759844] power_supply AC: power_supply_changed_work
[    0.759855] power_supply AC: power_supply_update_gen_leds 1
[    0.759879] power_supply AC: uevent
[    0.759881] power_supply AC: POWER_SUPPLY_NAME=AC
[    0.759886] power_supply AC: Static prop TYPE=Mains
[    0.759889] power_supply AC: 1 dynamic props
[    0.759891] power_supply AC: prop ONLINE=1
[    0.760023] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.760378] ACPI: Lid Switch [LID]
[    0.760638] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.760814] ACPI: Sleep Button [SLPB]
[    0.761100] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.761271] ACPI: Power Button [PWRF]
[    0.762987] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.766854] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.774394] Monitor-Mwait will be used to enter C-1 state
[    0.774447] Monitor-Mwait will be used to enter C-2 state
[    0.774498] Monitor-Mwait will be used to enter C-3 state
[    0.774518] Marking TSC unstable due to TSC halts in idle
[    0.774867] Switching to clocksource hpet
[    0.775961] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.779793] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.831191] thermal LNXTHERM:01: registered as thermal_zone0
[    0.831319] ACPI: Thermal Zone [THM0] (42 C)
[    0.833239] thermal LNXTHERM:02: registered as thermal_zone1
[    0.833372] ACPI: Thermal Zone [THM1] (48 C)
[    0.844416] power_supply BAT0: uevent
[    0.844418] power_supply BAT0: No power supply yet
[    0.844547] power_supply BAT0: power_supply_changed
[    0.844639] power_supply BAT0: power_supply_changed_work
[    0.845962] ACPI: Battery Slot [BAT0] (battery present)
[    0.847747] power_supply BAT0: power_supply_update_bat_leds 4
[    0.847755] power_supply BAT0: uevent
[    0.847757] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    0.847761] power_supply BAT0: Static prop TYPE=Battery
[    0.847763] power_supply BAT0: 13 dynamic props
[    0.847766] power_supply BAT0: prop STATUS=Full
[    0.847769] power_supply BAT0: prop PRESENT=1
[    0.847772] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    0.847775] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    0.847778] power_supply BAT0: prop VOLTAGE_NOW=12514000
[    0.847781] power_supply BAT0: prop CURRENT_NOW=0
[    0.847784] power_supply BAT0: prop POWER_NOW=0
[    0.847786] power_supply BAT0: prop ENERGY_FULL_DESIGN=84240000
[    0.847789] power_supply BAT0: prop ENERGY_FULL=82780000
[    0.847792] power_supply BAT0: prop ENERGY_NOW=82780000
[    0.847795] power_supply BAT0: prop MODEL_NAME=42T4644
[    0.847798] power_supply BAT0: prop MANUFACTURER=SANYO
[    0.847801] power_supply BAT0: prop SERIAL_NUMBER=13171
[    0.903936] Non-volatile memory driver v1.3
[    0.904125] Linux agpgart interface v0.103
[    0.904391] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    0.906729] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.927968] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.928338] [drm] Initialized drm 1.1.0 20060810
[    0.928538] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.928653] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.928766] i915 0000:00:02.0: setting latency timer to 64
[    1.001289]   alloc irq_desc for 28 on node -1
[    1.001293]   alloc kstat_irqs on node -1
[    1.001312] i915 0000:00:02.0: irq 28 for MSI/MSI-X
[    1.001323] [drm] set up 31M of stolen space
[    1.841509] Console: switching to colour frame buffer device 160x50
[    1.843720] fb0: inteldrmfb frame buffer device
[    1.843740] registered panic notifier
[    1.843817] async/0 used greatest stack depth: 3920 bytes left
[    1.847719] acpi device:01: registered as cooling_device2
[    1.848310] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.848361] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.848543] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.848696] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.854730] brd: module loaded
[    1.857053] loop: module loaded
[    1.857418] input: Macintosh mouse button emulation as /devices/virtual/input/input4
[    1.857511] Uniform Multi-Platform E-IDE driver
[    1.857710] ide-gd driver 1.18
[    1.858326] ahci 0000:00:1f.2: version 3.0
[    1.858346] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.858436]   alloc irq_desc for 29 on node -1
[    1.858439]   alloc kstat_irqs on node -1
[    1.858477] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    1.858534] ahci: SSS flag set, parallel bus scan disabled
[    1.858587] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    1.858626] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    1.858666] ahci 0000:00:1f.2: setting latency timer to 64
[    1.858881] scsi0 : ahci
[    1.859320] scsi1 : ahci
[    1.859603] scsi2 : ahci
[    1.859881] scsi3 : ahci
[    1.861124] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 29
[    1.861161] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 29
[    1.861196] ata3: DUMMY
[    1.861209] ata4: DUMMY
[    1.861995] Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
[    1.862645] Copyright (c) 1999-2006 Intel Corporation.
[    1.863450] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    1.864220] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.864991] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.865754] e1000e 0000:00:19.0: setting latency timer to 64
[    1.865898]   alloc irq_desc for 30 on node -1
[    1.865900]   alloc kstat_irqs on node -1
[    1.865920] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[    2.099717] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:7e:6e:5e:11
[    2.100504] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.101376] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    2.102309] Fusion MPT base driver 3.04.13
[    2.103139] Copyright (c) 1999-2008 LSI Corporation
[    2.104071] Fusion MPT SPI Host driver 3.04.13
[    2.105302] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.114656] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.115592] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.117635] mice: PS/2 mouse device common for all mice
[    2.120602] cpuidle: using governor ladder
[    2.122998] cpuidle: using governor menu
[    2.124986] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    2.125990] thinkpad_acpi: http://ibm-acpi.sf.net/
[    2.126958] thinkpad_acpi: ThinkPad BIOS 7UET71WW (3.01 ), EC 7VHT14WW-1.03
[    2.127124] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    2.128939] thinkpad_acpi: Lenovo ThinkPad T400, model 7417CTO
[    2.130224] thinkpad_acpi: radio switch found; radios are enabled
[    2.131436] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    2.132423] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    2.140613] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    2.142495] Registered led device: tpacpi::thinklight
[    2.143710] Registered led device: tpacpi::power
[    2.144876] Registered led device: tpacpi:orange:batt
[    2.146022] Registered led device: tpacpi:green:batt
[    2.147235] Registered led device: tpacpi::dock_active
[    2.148339] Registered led device: tpacpi::bay_active
[    2.149411] Registered led device: tpacpi::dock_batt
[    2.150598] Registered led device: tpacpi::unknown_led
[    2.151638] Registered led device: tpacpi::standby
[    2.152657] Registered led device: tpacpi::dock_status1
[    2.153873] Registered led device: tpacpi::dock_status2
[    2.154848] Registered led device: tpacpi::unknown_led2
[    2.155840] Registered led device: tpacpi::unknown_led3
[    2.157073] Registered led device: tpacpi::thinkvantage
[    2.157933] thinkpad_acpi: warning: userspace override of important firmware LEDs is enabled
[    2.162188] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[    2.163609] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    2.168073] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    2.176732] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.178137] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.178141] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.179100] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.180153] ata1.00: ATA-7: INTEL SSDSA2MH160G1GC, 045C8820, max UDMA/133
[    2.181109] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31)
[    2.184400] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.184403] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.184406] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.184648] ata1.00: configured for UDMA/133
[    2.188783] ALSA device list:
[    2.189745]   #29: ThinkPad Console Audio Control at EC reg 0x30, fw 7VHT14WW-1.03
[    2.192159] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.193199] TCP cubic registered
[    2.197847] ata1.00: configured for UDMA/133
[    2.198889] ata1: EH complete
[    2.200628] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2MH16 045C PQ: 0 ANSI: 5
[    2.200754] PM: Resume from disk failed.
[    2.200803] registered taskstats version 1
[    2.204930] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    2.206704] sd 0:0:0:0: [sda] Write Protect is off
[    2.208141] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.208251] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.210078]  sda: sda1 sda2
[    2.213151] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.523898] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.529331] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.529342] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.532135] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.565163] ata2.00: ATA-8: ST9500325ASG, 0001SDM1, max UDMA/133
[    2.568042] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.574867] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.574878] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.577891] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.582972] ata2.00: configured for UDMA/133
[    2.601409] ata2.00: configured for UDMA/133
[    2.604383] ata2: EH complete
[    2.607469] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    2.607790] scsi 1:0:0:0: Direct-Access     ATA      ST9500325ASG     0001 PQ: 0 ANSI: 5
[    2.609584] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.610040] sd 1:0:0:0: [sdb] Write Protect is off
[    2.610047] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.610232] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.611281]  sdb: sdb1 sdb2 sdb3
[    2.635506] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.638962] Freeing unused kernel memory: 3428k freed
[    2.644817] Write protecting the kernel read-only data: 10240k
[    2.645538] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input7
[    2.652169] Freeing unused kernel memory: 704k freed
[    2.654236] Freeing unused kernel memory: 1328k freed
[    2.858716] power_supply AC: uevent
[    2.858719] power_supply AC: POWER_SUPPLY_NAME=AC
[    2.858723] power_supply AC: Static prop TYPE=Mains
[    2.858726] power_supply AC: 1 dynamic props
[    2.858729] power_supply AC: prop ONLINE=1
[    2.858948] power_supply BAT0: uevent
[    2.858950] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    2.858954] power_supply BAT0: Static prop TYPE=Battery
[    2.858956] power_supply BAT0: 13 dynamic props
[    2.862145] power_supply BAT0: prop STATUS=Full
[    2.862149] power_supply BAT0: prop PRESENT=1
[    2.862152] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    2.862155] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    2.862158] power_supply BAT0: prop VOLTAGE_NOW=12514000
[    2.862161] power_supply BAT0: prop CURRENT_NOW=0
[    2.862164] power_supply BAT0: prop POWER_NOW=0
[    2.862167] power_supply BAT0: prop ENERGY_FULL_DESIGN=84240000
[    2.862170] power_supply BAT0: prop ENERGY_FULL=82780000
[    2.862172] power_supply BAT0: prop ENERGY_NOW=82780000
[    2.862175] power_supply BAT0: prop MODEL_NAME=42T4644
[    2.862178] power_supply BAT0: prop MANUFACTURER=SANYO
[    2.862181] power_supply BAT0: prop SERIAL_NUMBER=13171
[    3.024789] usbcore: registered new interface driver usbfs
[    3.026970] usbcore: registered new interface driver hub
[    3.032521] usbcore: registered new device driver usb
[    3.035196] uhci_hcd: USB Universal Host Controller Interface driver
[    3.037309] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.038429] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.039524] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.039529] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.039643] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.039645] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.046347] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.047707] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.049514] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.050978] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    3.052302] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    3.053393] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.054543] usb usb1: Product: UHCI Host Controller
[    3.055606] usb usb1: Manufacturer: Linux 2.6.33-00033-g18de96f uhci_hcd
[    3.056683] usb usb1: SerialNumber: 0000:00:1a.0
[    3.059947] hub 1-0:1.0: USB hub found
[    3.064302] hub 1-0:1.0: 2 ports detected
[    3.066533] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    3.067709] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    3.068809] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.068813] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.069854] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 2
[    3.070985] ehci_hcd 0000:00:1a.7: debug port 1
[    3.075924] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    3.077581] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    3.110101] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.111343] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.112402] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.113398] usb usb2: Product: EHCI Host Controller
[    3.114415] usb usb2: Manufacturer: Linux 2.6.33-00033-g18de96f ehci_hcd
[    3.115451] usb usb2: SerialNumber: 0000:00:1a.7
[    3.117559] hub 2-0:1.0: USB hub found
[    3.118817] hub 2-0:1.0: 6 ports detected
[    3.128518] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.129579] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.129583] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.130688] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[    3.131735] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    3.132815] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.133826] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.134809] usb usb3: Product: UHCI Host Controller
[    3.135777] usb usb3: Manufacturer: Linux 2.6.33-00033-g18de96f uhci_hcd
[    3.136738] usb usb3: SerialNumber: 0000:00:1a.1
[    3.142628] hub 3-0:1.0: USB hub found
[    3.144620] hub 3-0:1.0: 2 ports detected
[    3.146535] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    3.147571]   alloc irq_desc for 19 on node -1
[    3.147574]   alloc kstat_irqs on node -1
[    3.147585] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    3.148596] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.148600] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.149681] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
[    3.150801] ehci_hcd 0000:00:1d.7: debug port 1
[    3.155638] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.155666] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    3.170524] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.171536] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    3.172472] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.173402] usb usb4: Product: EHCI Host Controller
[    3.174423] usb usb4: Manufacturer: Linux 2.6.33-00033-g18de96f ehci_hcd
[    3.175349] usb usb4: SerialNumber: 0000:00:1d.7
[    3.176662] hub 4-0:1.0: USB hub found
[    3.177690] hub 4-0:1.0: 6 ports detected
[    3.179140] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    3.180065]   alloc irq_desc for 22 on node -1
[    3.180067]   alloc kstat_irqs on node -1
[    3.180078] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.181051] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.181056] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.181971] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    3.182958] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    3.184040] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.184962] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.185902] usb usb5: Product: UHCI Host Controller
[    3.186844] usb usb5: Manufacturer: Linux 2.6.33-00033-g18de96f uhci_hcd
[    3.187872] usb usb5: SerialNumber: 0000:00:1a.2
[    3.188944] modprobe used greatest stack depth: 3744 bytes left
[    3.192159] hub 5-0:1.0: USB hub found
[    3.198340] hub 5-0:1.0: 2 ports detected
[    3.200223] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    3.201204] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.204205] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.204210] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.205438] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    3.206782] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    3.209697] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.210724] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.211672] usb usb6: Product: UHCI Host Controller
[    3.212609] usb usb6: Manufacturer: Linux 2.6.33-00033-g18de96f uhci_hcd
[    3.213567] usb usb6: SerialNumber: 0000:00:1d.0
[    3.216362] hub 6-0:1.0: USB hub found
[    3.217421] hub 6-0:1.0: 2 ports detected
[    3.218608]   alloc irq_desc for 17 on node -1
[    3.218610]   alloc kstat_irqs on node -1
[    3.218621] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.219578] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.219583] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.220714] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    3.221702] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    3.222703] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.223658] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.224685] usb usb7: Product: UHCI Host Controller
[    3.225617] usb usb7: Manufacturer: Linux 2.6.33-00033-g18de96f uhci_hcd
[    3.226579] usb usb7: SerialNumber: 0000:00:1d.1
[    3.228882] hub 7-0:1.0: USB hub found
[    3.229844] hub 7-0:1.0: 2 ports detected
[    3.231504]   alloc irq_desc for 18 on node -1
[    3.231507]   alloc kstat_irqs on node -1
[    3.231522] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.232546] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.232550] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.233999] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    3.235011] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    3.236026] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.236975] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.238019] usb usb8: Product: UHCI Host Controller
[    3.238976] usb usb8: Manufacturer: Linux 2.6.33-00033-g18de96f uhci_hcd
[    3.239955] usb usb8: SerialNumber: 0000:00:1d.2
[    3.241508] hub 8-0:1.0: USB hub found
[    3.242484] hub 8-0:1.0: 2 ports detected
[    3.244137] modprobe used greatest stack depth: 3728 bytes left
[    3.400934] device-mapper: uevent: version 1.0.3
[    3.402302] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    3.533540] usb 2-6: new high speed USB device using ehci_hcd and address 3
[    3.673004] usb 2-6: New USB device found, idVendor=17ef, idProduct=1004
[    3.675939] usb 2-6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    3.678853] usb 2-6: Product: Integrated Camera
[    3.681796] usb 2-6: Manufacturer: Chicony Electronics Co., Ltd.
[    3.684715] usb 2-6: SerialNumber: SN0001
[    3.916863] usb 3-2: new full speed USB device using uhci_hcd and address 2
[    4.081872] usb 3-2: New USB device found, idVendor=0a5c, idProduct=2145
[    4.084880] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.087852] usb 3-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
[    4.090844] usb 3-2: Manufacturer: Lenovo Computer Corp
[    4.203554] usb 4-3: new high speed USB device using ehci_hcd and address 2
[    4.332111] usb 4-3: New USB device found, idVendor=8086, idProduct=1405
[    4.335098] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.338088] usb 4-3: Product: Intel(R) WiMAX Link 5350
[    4.341075] usb 4-3: Manufacturer: Intel(R) Corporation
[   12.424587] EXT4-fs (dm-11): INFO: recovery required on readonly filesystem
[   12.425694] EXT4-fs (dm-11): write access will be enabled during recovery
[   12.449658] EXT4-fs (dm-11): recovery complete
[   12.451856] EXT4-fs (dm-11): mounted filesystem with ordered data mode
[   13.810391] udev: starting version 147
[   13.841529] lp: driver loaded but no devices found
[   13.881439] power_supply AC: uevent
[   13.881441] power_supply AC: POWER_SUPPLY_NAME=AC
[   13.881446] power_supply AC: Static prop TYPE=Mains
[   13.881449] power_supply AC: 1 dynamic props
[   13.881451] power_supply AC: prop ONLINE=1
[   13.881971] power_supply BAT0: uevent
[   13.881973] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   13.881977] power_supply BAT0: Static prop TYPE=Battery
[   13.881979] power_supply BAT0: 13 dynamic props
[   13.887313] power_supply BAT0: prop STATUS=Full
[   13.887317] power_supply BAT0: prop PRESENT=1
[   13.887320] power_supply BAT0: prop TECHNOLOGY=Li-ion
[   13.887324] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[   13.887327] power_supply BAT0: prop VOLTAGE_NOW=12514000
[   13.887329] power_supply BAT0: prop CURRENT_NOW=0
[   13.887332] power_supply BAT0: prop POWER_NOW=0
[   13.887335] power_supply BAT0: prop ENERGY_FULL_DESIGN=84240000
[   13.887338] power_supply BAT0: prop ENERGY_FULL=82780000
[   13.887341] power_supply BAT0: prop ENERGY_NOW=82780000
[   13.887344] power_supply BAT0: prop MODEL_NAME=42T4644
[   13.887347] power_supply BAT0: prop MANUFACTURER=SANYO
[   13.887350] power_supply BAT0: prop SERIAL_NUMBER=13171
[   14.028291] rtc_cmos 00:07: RTC can wake from S4
[   14.035864] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   14.035909] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   14.149869] Bluetooth: Core ver 2.15
[   14.187479] NET: Registered protocol family 31
[   14.187481] Bluetooth: HCI device and connection manager initialized
[   14.187535] Bluetooth: HCI socket layer initialized
[   14.204819] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   14.205342] usbcore: registered new interface driver btusb
[   14.213003] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   14.213106]   alloc irq_desc for 31 on node -1
[   14.213108]   alloc kstat_irqs on node -1
[   14.213135] HDA Intel 0000:00:1b.0: irq 31 for MSI/MSI-X
[   14.213224] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.218812] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 2.6.33-00033-g18de96f-kds
[   14.218815] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   14.218909] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.218919] iwlagn 0000:03:00.0: setting latency timer to 64
[   14.218956] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5350AGN REV=0x24
[   14.266328] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   14.266526]   alloc irq_desc for 32 on node -1
[   14.266528]   alloc kstat_irqs on node -1
[   14.266602] iwlagn 0000:03:00.0: irq 32 for MSI/MSI-X
[   14.336337] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   14.383583] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   14.383911] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   14.384058] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   14.384209] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   15.868379] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   15.997207] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   16.050177] e1000e 0000:00:19.0: irq 30 for MSI/MSI-X
[   16.053069] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.ucode
[   16.085957] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   16.391471] udevadm[2598] general protection ip:7f0c0b8c2441 sp:7fff2a084148 error:0 in libc-2.10.1.so[7f0c0b843000+166000]
[   16.409121] NET: Registered protocol family 17
[   17.758070] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   17.758073] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   17.925679] tun: Universal TUN/TAP device driver, 1.6
[   17.925681] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   18.570203] Bluetooth: L2CAP ver 2.14
[   18.570205] Bluetooth: L2CAP socket layer initialized
[   18.576748] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   18.576751] Bluetooth: BNEP filters: protocol multicast
[   18.586816] Bridge firewalling registered
[   18.602536] Bluetooth: SCO (Voice Link) ver 0.6
[   18.602539] Bluetooth: SCO socket layer initialized
[   18.641559] ppdev: user-space parallel port driver

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log-busted"


X.Org X Server 1.6.4
Release Date: 2009-9-27
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.24-23-server x86_64 Ubuntu
Current Operating System: Linux closure 2.6.33-00033-g18de96f #47 SMP Wed Mar 3 00:18:34 EST 2010 x86_64
Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.33-00033-g18de96f root=/dev/mapper/ssd2-root ro quiet splash
Build Date: 14 November 2009  05:48:57PM
xorg-server 2:1.6.4-2ubuntu4.1 (buildd@) 
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Wed Mar  3 10:05:09 2010
(II) Loader magic: 0xb40
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 5.0
	X.Org XInput driver : 4.0
	X.Org Server Extension : 2.0
(II) Loader running on linux
(++) using VT number 7

(--) PCI:*(0:0:2:0) 8086:2a42:17aa:20e4 Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller rev 7, Mem @ 0xf4400000/4194304, 0xd0000000/268435456, I/O @ 0x00001800/8
(==) Using default built-in configuration (39 lines)
(==) --- Start of built-in configuration ---
	Section "Device"
		Identifier	"Builtin Default intel Device 0"
		Driver	"intel"
	EndSection
	Section "Screen"
		Identifier	"Builtin Default intel Screen 0"
		Device	"Builtin Default intel Device 0"
	EndSection
	Section "Device"
		Identifier	"Builtin Default i810 Device 0"
		Driver	"i810"
	EndSection
	Section "Screen"
		Identifier	"Builtin Default i810 Screen 0"
		Device	"Builtin Default i810 Device 0"
	EndSection
	Section "Device"
		Identifier	"Builtin Default vesa Device 0"
		Driver	"vesa"
	EndSection
	Section "Screen"
		Identifier	"Builtin Default vesa Screen 0"
		Device	"Builtin Default vesa Device 0"
	EndSection
	Section "Device"
		Identifier	"Builtin Default fbdev Device 0"
		Driver	"fbdev"
	EndSection
	Section "Screen"
		Identifier	"Builtin Default fbdev Screen 0"
		Device	"Builtin Default fbdev Device 0"
	EndSection
	Section "ServerLayout"
		Identifier	"Builtin Default Layout"
		Screen	"Builtin Default intel Screen 0"
		Screen	"Builtin Default i810 Screen 0"
		Screen	"Builtin Default vesa Screen 0"
		Screen	"Builtin Default fbdev Screen 0"
	EndSection
(==) --- End of built-in configuration ---
(==) ServerLayout "Builtin Default Layout"
(**) |-->Screen "Builtin Default intel Screen 0" (0)
(**) |   |-->Monitor "<default monitor>"
(**) |   |-->Device "Builtin Default intel Device 0"
(==) No monitor specified for screen "Builtin Default intel Screen 0".
	Using a default monitor configuration.
(**) |-->Screen "Builtin Default i810 Screen 0" (1)
(**) |   |-->Monitor "<default monitor>"
(**) |   |-->Device "Builtin Default i810 Device 0"
(==) No monitor specified for screen "Builtin Default i810 Screen 0".
	Using a default monitor configuration.
(**) |-->Screen "Builtin Default vesa Screen 0" (2)
(**) |   |-->Monitor "<default monitor>"
(**) |   |-->Device "Builtin Default vesa Device 0"
(==) No monitor specified for screen "Builtin Default vesa Screen 0".
	Using a default monitor configuration.
(**) |-->Screen "Builtin Default fbdev Screen 0" (3)
(**) |   |-->Monitor "<default monitor>"
(**) |   |-->Device "Builtin Default fbdev Device 0"
(==) No monitor specified for screen "Builtin Default fbdev Screen 0".
	Using a default monitor configuration.
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) Cannot locate a core pointer device.
(II) Cannot locate a core keyboard device.
(II) The server relies on HAL to provide the list of input devices.
	If no devices become available, reconfigure HAL or disable AllowEmptyInput.
(WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
(II) No APM support in BIOS or kernel
(II) System resource ranges:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions//libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.1.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(II) LoadModule: "intel"
(II) Loading /usr/lib/xorg/modules/drivers//intel_drv.so
(II) Module intel: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 2.9.0
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) LoadModule: "i810"
(WW) Warning, couldn't open module i810
(II) UnloadModule: "i810"
(EE) Failed to load module "i810" (module does not exist, 0)
(II) LoadModule: "vesa"
(II) Loading /usr/lib/xorg/modules/drivers//vesa_drv.so
(II) Module vesa: vendor="X.Org Foundation"
	compiled for 1.6.3, module version = 2.2.1
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) LoadModule: "fbdev"
(II) Loading /usr/lib/xorg/modules/drivers//fbdev_drv.so
(II) Module fbdev: vendor="X.Org Foundation"
	compiled for 1.6.0, module version = 0.4.0
	ABI class: X.Org Video Driver, version 5.0
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, Clarkdale, Arrandale
(II) VESA: driver for VESA chipsets: vesa
(II) FBDEV: driver for framebuffer: fbdev
(II) Primary Device is: PCI 00@00:02:0
(WW) Falling back to old probe method for vesa
(WW) Falling back to old probe method for fbdev
(II) Loading sub module "fbdevhw"
(II) LoadModule: "fbdevhw"
(II) Loading /usr/lib/xorg/modules/linux//libfbdevhw.so
(II) Module fbdevhw: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 0.0.2
	ABI class: X.Org Video Driver, version 5.0
(II) resource ranges after probing:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 7, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 7, (OK)
drmOpenByBusid: drmOpenMinor returns 7
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(II) intel(0): Creating default Display subsection in Screen section
	"Builtin Default intel Screen 0" for depth/fbbpp 24/32
(==) intel(0): Depth 24, (--) framebuffer bpp 32
(==) intel(0): RGB weight 888
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) GM45
(--) intel(0): Chipset: "GM45"
(II) intel(0): Output VGA1 has no monitor section
(II) intel(0): Output LVDS1 has no monitor section
(II) intel(0): found backlight control interface /sys/class/backlight/acpi_video0
(II) intel(0): Output HDMI1 has no monitor section
(II) intel(0): Output DP1 has no monitor section
(II) intel(0): Output HDMI2 has no monitor section
(II) intel(0): Output DP2 has no monitor section
(II) intel(0): Output DP3 has no monitor section
(II) intel(0): EDID for output VGA1
(II) intel(0): EDID for output LVDS1
(II) intel(0): Manufacturer: LEN  Model: 4037  Serial#: 0
(II) intel(0): Year: 2008  Week: 0
(II) intel(0): EDID Version: 1.3
(II) intel(0): Digital Display Input
(II) intel(0): Max Image Size [cm]: horiz.: 30  vert.: 19
(II) intel(0): Gamma: 2.20
(II) intel(0): DPMS capabilities: StandBy Suspend Off
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.345 greenY: 0.590
(II) intel(0): blueX: 0.155 blueY: 0.070   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 69.5 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1416 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 818 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 57.7 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1384 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 834 v_border: 0
(WW) intel(0): Unknown vendor-specific block f
(II) intel(0):  LTN141AT09201
(II) intel(0): EDID (in hex):
(II) intel(0): 	00ffffffffffff0030ae374000000000
(II) intel(0): 	00120103801e1378ea44c59c57589727
(II) intel(0): 	12505400000001010101010101010101
(II) intel(0): 	010101010101261b0088502012303440
(II) intel(0): 	33002fbe100000198b16006850202230
(II) intel(0): 	344033002fbe100000190000000f0081
(II) intel(0): 	0a32810a284409004ca34154000000fe
(II) intel(0): 	004c544e31343141543039323031008d
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1360x768" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1360x768" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1440x900" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1080" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1200" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Printing probed modes for output LVDS1
(II) intel(0): Modeline "1280x800"x60.0   69.50  1280 1332 1396 1416  800 803 806 818 -hsync -vsync (49.1 kHz)
(II) intel(0): Modeline "1024x768"x85.0   94.50  1024 1072 1168 1376  768 769 772 808 +hsync +vsync (68.7 kHz)
(II) intel(0): Modeline "1024x768"x75.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
(II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
(II) intel(0): Modeline "800x600"x85.1   56.30  800 832 896 1048  600 601 604 631 +hsync +vsync (53.7 kHz)
(II) intel(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
(II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
(II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
(II) intel(0): Modeline "640x480"x85.0   36.00  640 696 752 832  480 481 484 509 -hsync -vsync (43.3 kHz)
(II) intel(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
(II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "720x400"x85.0   35.50  720 756 828 936  400 401 404 446 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x400"x85.1   31.50  640 672 736 832  400 401 404 445 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x350"x85.1   31.50  640 672 736 832  350 382 385 445 +hsync -vsync (37.9 kHz)
(II) intel(0): EDID for output HDMI1
(II) intel(0): EDID for output DP1
(II) intel(0): EDID for output HDMI2
(II) intel(0): EDID for output DP2
(II) intel(0): EDID for output DP3
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output LVDS1 connected
(II) intel(0): Output HDMI1 disconnected
(II) intel(0): Output DP1 disconnected
(II) intel(0): Output HDMI2 disconnected
(II) intel(0): Output DP2 disconnected
(II) intel(0): Output DP3 disconnected
(II) intel(0): Using exact sizes for initial modes
(II) intel(0): Output LVDS1 using initial mode 1280x800
(==) intel(0): video overlay key set to 0x101fe
(==) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(==) intel(0): DPI set to (96, 96)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(II) UnloadModule: "vesa"
(II) Unloading /usr/lib/xorg/modules/drivers//vesa_drv.so
(II) UnloadModule: "fbdev"
(II) Unloading /usr/lib/xorg/modules/drivers//fbdev_drv.so
(II) UnloadModule: "fbdevhw"
(II) Unloading /usr/lib/xorg/modules/linux//libfbdevhw.so
(==) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) intel(0): [DRI2] Setup complete
(**) intel(0): Kernel mode setting active, disabling FBC.
(**) intel(0): Framebuffer compression disabled
(**) intel(0): Tiling enabled
(**) intel(0): SwapBuffers wait enabled
(==) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Tiled allocation successful.
(II) UXA(0): Driver registered support for the following operations:
(II)         solid
(II)         copy
(II)         composite (RENDER acceleration)
(==) intel(0): Backing store disabled
(==) intel(0): Silken mouse enabled
(II) intel(0): Initializing HW Cursor
(II) intel(0): No memory allocations
(II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
(II) intel(0): DPMS enabled
(==) intel(0): Intel XvMC decoder disabled
(II) intel(0): Set up textured video
(II) intel(0): direct rendering: DRI2 Enabled
(--) RandR disabled
(II) Initializing built-in extension Generic Event Extension
(II) Initializing built-in extension SHAPE
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension BIG-REQUESTS
(II) Initializing built-in extension SYNC
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-MISC
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
(II) AIGLX: enabled GLX_MESA_copy_sub_buffer
(II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
(II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
(II) AIGLX: Loaded and initialized /usr/lib/dri/i965_dri.so
(II) GLX: Initialized DRI2 GL provider for screen 0
(II) intel(0): Setting screen physical size to 303 x 190
(II) intel(0): EDID for output VGA1
(II) intel(0): EDID for output LVDS1
(II) intel(0): Manufacturer: LEN  Model: 4037  Serial#: 0
(II) intel(0): Year: 2008  Week: 0
(II) intel(0): EDID Version: 1.3
(II) intel(0): Digital Display Input
(II) intel(0): Max Image Size [cm]: horiz.: 30  vert.: 19
(II) intel(0): Gamma: 2.20
(II) intel(0): DPMS capabilities: StandBy Suspend Off
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.345 greenY: 0.590
(II) intel(0): blueX: 0.155 blueY: 0.070   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 69.5 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1416 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 818 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 57.7 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1384 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 834 v_border: 0
(WW) intel(0): Unknown vendor-specific block f
(II) intel(0):  LTN141AT09201
(II) intel(0): EDID (in hex):
(II) intel(0): 	00ffffffffffff0030ae374000000000
(II) intel(0): 	00120103801e1378ea44c59c57589727
(II) intel(0): 	12505400000001010101010101010101
(II) intel(0): 	010101010101261b0088502012303440
(II) intel(0): 	33002fbe100000198b16006850202230
(II) intel(0): 	344033002fbe100000190000000f0081
(II) intel(0): 	0a32810a284409004ca34154000000fe
(II) intel(0): 	004c544e31343141543039323031008d
(II) intel(0): EDID vendor "LEN", prod id 16439
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1280x800"x0.0   69.50  1280 1332 1396 1416  800 803 806 818 -hsync -vsync (49.1 kHz)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1360x768" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1360x768" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1440x900" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1080" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1200" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Printing probed modes for output LVDS1
(II) intel(0): Modeline "1280x800"x60.0   69.50  1280 1332 1396 1416  800 803 806 818 -hsync -vsync (49.1 kHz)
(II) intel(0): Modeline "1024x768"x85.0   94.50  1024 1072 1168 1376  768 769 772 808 +hsync +vsync (68.7 kHz)
(II) intel(0): Modeline "1024x768"x75.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
(II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
(II) intel(0): Modeline "800x600"x85.1   56.30  800 832 896 1048  600 601 604 631 +hsync +vsync (53.7 kHz)
(II) intel(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
(II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
(II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
(II) intel(0): Modeline "640x480"x85.0   36.00  640 696 752 832  480 481 484 509 -hsync -vsync (43.3 kHz)
(II) intel(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
(II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "720x400"x85.0   35.50  720 756 828 936  400 401 404 446 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x400"x85.1   31.50  640 672 736 832  400 401 404 445 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x350"x85.1   31.50  640 672 736 832  350 382 385 445 +hsync -vsync (37.9 kHz)
(II) intel(0): EDID for output HDMI1
(II) intel(0): EDID for output DP1
(II) intel(0): EDID for output HDMI2
(II) intel(0): EDID for output DP2
(II) intel(0): EDID for output DP3
(II) intel(0): EDID for output VGA1
(II) intel(0): EDID for output LVDS1
(II) intel(0): Manufacturer: LEN  Model: 4037  Serial#: 0
(II) intel(0): Year: 2008  Week: 0
(II) intel(0): EDID Version: 1.3
(II) intel(0): Digital Display Input
(II) intel(0): Max Image Size [cm]: horiz.: 30  vert.: 19
(II) intel(0): Gamma: 2.20
(II) intel(0): DPMS capabilities: StandBy Suspend Off
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.345 greenY: 0.590
(II) intel(0): blueX: 0.155 blueY: 0.070   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 69.5 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1416 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 818 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 57.7 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1384 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 834 v_border: 0
(WW) intel(0): Unknown vendor-specific block f
(II) intel(0):  LTN141AT09201
(II) intel(0): EDID (in hex):
(II) intel(0): 	00ffffffffffff0030ae374000000000
(II) intel(0): 	00120103801e1378ea44c59c57589727
(II) intel(0): 	12505400000001010101010101010101
(II) intel(0): 	010101010101261b0088502012303440
(II) intel(0): 	33002fbe100000198b16006850202230
(II) intel(0): 	344033002fbe100000190000000f0081
(II) intel(0): 	0a32810a284409004ca34154000000fe
(II) intel(0): 	004c544e31343141543039323031008d
(II) intel(0): EDID vendor "LEN", prod id 16439
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1280x800"x0.0   69.50  1280 1332 1396 1416  800 803 806 818 -hsync -vsync (49.1 kHz)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1360x768" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1360x768" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1440x900" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1080" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1200" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Printing probed modes for output LVDS1
(II) intel(0): Modeline "1280x800"x60.0   69.50  1280 1332 1396 1416  800 803 806 818 -hsync -vsync (49.1 kHz)
(II) intel(0): Modeline "1024x768"x85.0   94.50  1024 1072 1168 1376  768 769 772 808 +hsync +vsync (68.7 kHz)
(II) intel(0): Modeline "1024x768"x75.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
(II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
(II) intel(0): Modeline "800x600"x85.1   56.30  800 832 896 1048  600 601 604 631 +hsync +vsync (53.7 kHz)
(II) intel(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
(II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
(II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
(II) intel(0): Modeline "640x480"x85.0   36.00  640 696 752 832  480 481 484 509 -hsync -vsync (43.3 kHz)
(II) intel(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
(II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "720x400"x85.0   35.50  720 756 828 936  400 401 404 446 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x400"x85.1   31.50  640 672 736 832  400 401 404 445 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x350"x85.1   31.50  640 672 736 832  350 382 385 445 +hsync -vsync (37.9 kHz)
(II) intel(0): EDID for output HDMI1
(II) intel(0): EDID for output DP1
(II) intel(0): EDID for output HDMI2
(II) intel(0): EDID for output DP2
(II) intel(0): EDID for output DP3
(II) intel(0): EDID for output VGA1
(II) intel(0): EDID for output LVDS1
(II) intel(0): Manufacturer: LEN  Model: 4037  Serial#: 0
(II) intel(0): Year: 2008  Week: 0
(II) intel(0): EDID Version: 1.3
(II) intel(0): Digital Display Input
(II) intel(0): Max Image Size [cm]: horiz.: 30  vert.: 19
(II) intel(0): Gamma: 2.20
(II) intel(0): DPMS capabilities: StandBy Suspend Off
(II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) intel(0): First detailed timing is preferred mode
(II) intel(0): redX: 0.610 redY: 0.340   greenX: 0.345 greenY: 0.590
(II) intel(0): blueX: 0.155 blueY: 0.070   whiteX: 0.313 whiteY: 0.329
(II) intel(0): Manufacturer's mask: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 69.5 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1416 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 818 v_border: 0
(II) intel(0): Supported detailed timing:
(II) intel(0): clock: 57.7 MHz   Image Size:  303 x 190 mm
(II) intel(0): h_active: 1280  h_sync: 1332  h_sync_end 1396 h_blank_end 1384 h_border: 0
(II) intel(0): v_active: 800  v_sync: 803  v_sync_end 806 v_blanking: 834 v_border: 0
(WW) intel(0): Unknown vendor-specific block f
(II) intel(0):  LTN141AT09201
(II) intel(0): EDID (in hex):
(II) intel(0): 	00ffffffffffff0030ae374000000000
(II) intel(0): 	00120103801e1378ea44c59c57589727
(II) intel(0): 	12505400000001010101010101010101
(II) intel(0): 	010101010101261b0088502012303440
(II) intel(0): 	33002fbe100000198b16006850202230
(II) intel(0): 	344033002fbe100000190000000f0081
(II) intel(0): 	0a32810a284409004ca34154000000fe
(II) intel(0): 	004c544e31343141543039323031008d
(II) intel(0): EDID vendor "LEN", prod id 16439
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1280x800"x0.0   69.50  1280 1332 1396 1416  800 803 806 818 -hsync -vsync (49.1 kHz)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x960" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1280x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1200" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1792x1344" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1856x1392" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1152x864" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1360x768" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1360x768" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1400x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1440x900" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1600x1024" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1680x1050" (exceeds panel dimensions)
(II) intel(0): Not using default mode "1920x1080" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1200" (monitor doesn't support reduced blanking)
(II) intel(0): Not using default mode "1920x1440" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Not using default mode "2048x1536" (exceeds panel dimensions)
(II) intel(0): Printing probed modes for output LVDS1
(II) intel(0): Modeline "1280x800"x60.0   69.50  1280 1332 1396 1416  800 803 806 818 -hsync -vsync (49.1 kHz)
(II) intel(0): Modeline "1024x768"x85.0   94.50  1024 1072 1168 1376  768 769 772 808 +hsync +vsync (68.7 kHz)
(II) intel(0): Modeline "1024x768"x75.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
(II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
(II) intel(0): Modeline "800x600"x85.1   56.30  800 832 896 1048  600 601 604 631 +hsync +vsync (53.7 kHz)
(II) intel(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
(II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
(II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
(II) intel(0): Modeline "640x480"x85.0   36.00  640 696 752 832  480 481 484 509 -hsync -vsync (43.3 kHz)
(II) intel(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
(II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
(II) intel(0): Modeline "720x400"x85.0   35.50  720 756 828 936  400 401 404 446 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x400"x85.1   31.50  640 672 736 832  400 401 404 445 -hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x350"x85.1   31.50  640 672 736 832  350 382 385 445 +hsync -vsync (37.9 kHz)
(II) intel(0): EDID for output HDMI1
(II) intel(0): EDID for output DP1
(II) intel(0): EDID for output HDMI2
(II) intel(0): EDID for output DP2
(II) intel(0): EDID for output DP3

--M9NhX3UHpAaciwkO--
