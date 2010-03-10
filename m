Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab0CJJUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:20:31 -0500
Received: from 109.Red-80-25-134.staticIP.rima-tde.net ([80.25.134.109]:55339
	"EHLO ux1.multimensaje.es" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753170Ab0CJJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:20:19 -0500
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 04:20:17 EST
Date: Wed, 10 Mar 2010 10:01:00 +0100
From: "Pedro M. =?UTF-8?B?TMOzcGV6?=" <pmlopez@multimensaje.es>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at arch/x86/kernel/hpet.c:404 hpet_next_event+0x57/0x77()
Message-ID: <20100310100100.0d175592@multimensaje.es>
Organization: Multimensaje S.L.
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/u_SV8xq8+sr1ZS8=B1Xu=eF"
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/u_SV8xq8+sr1ZS8=B1Xu=eF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Kernel 2.6.33

[    1.200658] ------------[ cut here ]------------
[    1.200662] WARNING: at arch/x86/kernel/hpet.c:404 hpet_next_event+0x57/0x77() 
[    1.200663] Hardware name: P55A-UD4
[    1.200664] hpet: compare register read back failed.
[    1.200665] Modules linked in:
[    1.200666] Pid: 0, comm: swapper Not tainted 2.6.33-p1 #10
[    1.200668] Call Trace:
[    1.200671]  [<ffffffff8102c98f>] ? warn_slowpath_common+0x76/0x8c
[    1.200673]  [<ffffffff8102c9f7>] ? warn_slowpath_fmt+0x40/0x45
[    1.200676]  [<ffffffff81026166>] ? find_busiest_group+0x341/0x7fe
[    1.200678]  [<ffffffff81018eb1>] ? hpet_next_event+0x57/0x77
[    1.200681]  [<ffffffff81048d1e>] ? tick_dev_program_event+0x33/0x9e
[    1.200684]  [<ffffffff81048836>] ?
tick_broadcast_oneshot_control+0x9c/0xf5
[    1.200686]  [<ffffffff81048220>] ? tick_notify+0x1f9/0x34d 
[    1.200688]  [<ffffffff8104257a>] ? notifier_call_chain+0x2e/0x5b 
[    1.200690]  [<ffffffff81047c56>] ? clockevents_notify+0x31/0x139 
[    1.200693]  [<ffffffff81175aa0>] ? acpi_idle_enter_simple+0x93/0x130
[    1.200696]  [<ffffffff811673c3>] ?
acpi_write_bit_register+0x9e/0xab 
[    1.200698]  [<ffffffff8117585c>] ? acpi_idle_enter_bm+0xd3/0x284 
[    1.200701]  [<ffffffff811f2705>] ? cpuidle_idle_call+0x89/0xc0 
[    1.200704]  [<ffffffff81001256>] ? cpu_idle+0x9d/0xd7 
[    1.200707] ---[ end trace a4e806103d58b3e6 ]---

More info need??

--MP_/u_SV8xq8+sr1ZS8=B1Xu=eF
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=kernel.log

[    0.000000] Linux version 2.6.33-p1 (pmlopez@debian) (gcc version 4.4.3 (Debian 4.4.3-3) ) #10 SMP Tue Mar 9 21:13:09 CET 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33-p1 root=/dev/sda3 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000094c00 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfbe0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfbe0000 - 00000000bfbe2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfbe2000 - 00000000bfbf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfbf0000 - 00000000bfc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CDFFF write-protect
[    0.000000]   CE000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   2 base 100000000 mask F00000000 write-back
[    0.000000]   3 base 200000000 mask FC0000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfbe0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f5710] f5710
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfbe0000
[    0.000000]  0000000000 - 00bfa00000 page 2M
[    0.000000]  00bfa00000 - 00bfbe0000 page 4k
[    0.000000] kernel direct mapping tables up to bfbe0000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
[    0.000000]  0100000000 - 0240000000 page 2M
[    0.000000] kernel direct mapping tables up to 240000000 @ b000-15000
[    0.000000] ACPI: RSDP 00000000000f70d0 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000bfbe2040 00040 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000bfbe20c0 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000bfbe2180 0530D (v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000bfbe0000 00040
[    0.000000] ACPI: HPET 00000000bfbe7600 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000bfbe7680 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: EUDS 00000000bfbe76c0 00560 (v01 GBT             00000000      00000000)
[    0.000000] ACPI: TAMG 00000000bfbe7c20 00A32 (v01 GBT    GBT   B0 5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 00000000bfbe7500 000BC (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000bfbe8660 03404 (v01  INTEL PPM RCM  80000001 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (12 early reservations) ==> bootmem [0000000000 - 0240000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0001744f28]    TEXT DATA BSS ==> [0001000000 - 0001744f28]
[    0.000000]   #2 [0001745000 - 00017450f6]              BRK ==> [0001745000 - 00017450f6]
[    0.000000]   #3 [00000f5720 - 0000100000]    BIOS reserved ==> [00000f5720 - 0000100000]
[    0.000000]   #4 [00000f5710 - 00000f5720]     MP-table mpf ==> [00000f5710 - 00000f5720]
[    0.000000]   #5 [0000094c00 - 00000f0d00]    BIOS reserved ==> [0000094c00 - 00000f0d00]
[    0.000000]   #6 [00000f0ef4 - 00000f5710]    BIOS reserved ==> [00000f0ef4 - 00000f5710]
[    0.000000]   #7 [00000f0d00 - 00000f0ef4]     MP-table mpc ==> [00000f0d00 - 00000f0ef4]
[    0.000000]   #8 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
[    0.000000]   #9 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
[    0.000000]   #10 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #11 [000000b000 - 0000010000]          PGTABLE ==> [000000b000 - 0000010000]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880028600000-ffff88002f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00240000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000094
[    0.000000]     0: 0x00000100 -> 0x000bfbe0
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000] On node 0 totalpages: 2095988
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 121 pages reserved
[    0.000000]   DMA zone: 3811 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767000 pages, LIFO batch:31
[    0.000000]   Normal zone: 17920 pages used for memmap
[    0.000000]   Normal zone: 1292800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfbe0000 - 00000000bfbe2000
[    0.000000] PM: Registered nosave memory: 00000000bfbe2000 - 00000000bfbf0000
[    0.000000] PM: Registered nosave memory: 00000000bfbf0000 - 00000000bfc00000
[    0.000000] PM: Registered nosave memory: 00000000bfc00000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bfc00000 (gap: bfc00000:30400000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880028200000 s77016 r8192 d21288 u262144
[    0.000000] pcpu-alloc: s77016 r8192 d21288 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063611
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33-p1 root=/dev/sda3 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8181484k/9437184k available (2466k kernel code, 1053232k absent, 201532k reserved, 3911k data, 368k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2798.052 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5596.10 BogoMIPS (lpj=2798052)
[    0.000018] Mount-cache hash table entries: 256
[    0.000093] CPU: Physical Processor ID: 0
[    0.000094] CPU: Processor Core ID: 0
[    0.000097] mce: CPU supports 9 MCE banks
[    0.000104] CPU0: Thermal monitoring enabled (TM1)
[    0.000107] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.000111] using mwait in idle threads.
[    0.000112] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.000115] ... version:                3
[    0.000116] ... bit width:              48
[    0.000117] ... generic registers:      4
[    0.000118] ... value mask:             0000ffffffffffff
[    0.000119] ... max period:             000000007fffffff
[    0.000120] ... fixed-purpose events:   3
[    0.000121] ... event mask:             000000070000000f
[    0.000131] ACPI: Core revision 20091214
[    0.009549] Setting APIC routing to flat
[    0.009881] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.019856] CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
[    0.121323] Booting Node   0, Processors  #1
[    0.192090] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.212106]  #2
[    0.282833] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.302843]  #3
[    0.373575] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.393580]  #4
[    0.464318] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.484322]  #5
[    0.555059] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.575059]  #6
[    0.645801] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.665897]  #7 Ok.
[    0.736544] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.756600] Brought up 8 CPUs
[    0.756601] Total of 8 processors activated (44761.83 BogoMIPS).
[    0.759122] devtmpfs: initialized
[    0.759240] NET: Registered protocol family 16
[    0.759275] ACPI: bus type pci registered
[    0.759312] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.759314] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.760356] PCI: Using configuration type 1 for base access
[    0.760742] bio: create slab <bio-0> at 0
[    0.761319] ACPI: EC: Look up EC in DSDT
[    0.766363] ACPI: Interpreter enabled
[    0.766365] ACPI: (supports S0 S3 S4 S5)
[    0.766379] ACPI: Using IOAPIC for interrupt routing
[    0.769824] ACPI Warning: Incorrect checksum in table [TAMG] - AF, should be AE (20091214/tbutils-314)
[    0.769919] ACPI: No dock devices found.
[    0.769986] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.770000] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.770111] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.770112] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.770114] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.770116] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.770117] pci_root PNP0A03:00: host bridge window [mem 0xbfc00000-0xfebfffff] (ignored)
[    0.770189] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.770191] pci 0000:00:03.0: PME# disabled
[    0.770408] pci 0000:00:1a.0: reg 20: [io  0xff00-0xff1f]
[    0.770463] pci 0000:00:1a.1: reg 20: [io  0xfe00-0xfe1f]
[    0.770519] pci 0000:00:1a.2: reg 20: [io  0xfd00-0xfd1f]
[    0.770572] pci 0000:00:1a.7: reg 10: [mem 0xfbfff000-0xfbfff3ff]
[    0.770618] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.770621] pci 0000:00:1a.7: PME# disabled
[    0.770649] pci 0000:00:1b.0: reg 10: [mem 0xfbff8000-0xfbffbfff 64bit]
[    0.770683] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.770686] pci 0000:00:1b.0: PME# disabled
[    0.770740] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.770742] pci 0000:00:1c.0: PME# disabled
[    0.770798] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.770801] pci 0000:00:1c.3: PME# disabled
[    0.770856] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.770858] pci 0000:00:1c.4: PME# disabled
[    0.770913] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.770916] pci 0000:00:1c.5: PME# disabled
[    0.770971] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.770974] pci 0000:00:1c.6: PME# disabled
[    0.771015] pci 0000:00:1d.0: reg 20: [io  0xfc00-0xfc1f]
[    0.771069] pci 0000:00:1d.1: reg 20: [io  0xfb00-0xfb1f]
[    0.771123] pci 0000:00:1d.2: reg 20: [io  0xfa00-0xfa1f]
[    0.771176] pci 0000:00:1d.3: reg 20: [io  0xf900-0xf91f]
[    0.771229] pci 0000:00:1d.7: reg 10: [mem 0xfbffe000-0xfbffe3ff]
[    0.771275] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.771279] pci 0000:00:1d.7: PME# disabled
[    0.771421] pci 0000:00:1f.2: reg 10: [io  0xf800-0xf807]
[    0.771425] pci 0000:00:1f.2: reg 14: [io  0xf700-0xf703]
[    0.771430] pci 0000:00:1f.2: reg 18: [io  0xf600-0xf607]
[    0.771434] pci 0000:00:1f.2: reg 1c: [io  0xf500-0xf503]
[    0.771438] pci 0000:00:1f.2: reg 20: [io  0xf400-0xf41f]
[    0.771443] pci 0000:00:1f.2: reg 24: [mem 0xfbffd000-0xfbffd7ff]
[    0.771468] pci 0000:00:1f.2: PME# supported from D3hot
[    0.771472] pci 0000:00:1f.2: PME# disabled
[    0.771495] pci 0000:00:1f.3: reg 10: [mem 0xfbffc000-0xfbffc0ff 64bit]
[    0.771505] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.771539] pci 0000:01:00.0: reg 10: [mem 0xf8000000-0xf8ffffff]
[    0.771546] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.771553] pci 0000:01:00.0: reg 1c: [mem 0xf6000000-0xf7ffffff 64bit]
[    0.771557] pci 0000:01:00.0: reg 24: [io  0xaf00-0xaf7f]
[    0.771561] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.773483] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    0.773485] pci 0000:00:03.0:   bridge window [io  0xa000-0xafff]
[    0.773488] pci 0000:00:03.0:   bridge window [mem 0xf6000000-0xf9ffffff]
[    0.773491] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.773522] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.773574] pci 0000:03:00.0: reg 10: [mem 0xfbcfe000-0xfbcfffff 64bit]
[    0.773650] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.773655] pci 0000:03:00.0: PME# disabled
[    0.775494] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.775498] pci 0000:00:1c.3:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.775575] pci 0000:04:00.0: reg 24: [mem 0xfbafe000-0xfbafffff]
[    0.775610] pci 0000:04:00.0: PME# supported from D3hot
[    0.775614] pci 0000:04:00.0: PME# disabled
[    0.775656] pci 0000:04:00.1: reg 10: [io  0xef00-0xef07]
[    0.775664] pci 0000:04:00.1: reg 14: [io  0xee00-0xee03]
[    0.775672] pci 0000:04:00.1: reg 18: [io  0xed00-0xed07]
[    0.775679] pci 0000:04:00.1: reg 1c: [io  0xec00-0xec03]
[    0.775687] pci 0000:04:00.1: reg 20: [io  0xeb00-0xeb0f]
[    0.775742] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.775777] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.775780] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.775783] pci 0000:00:1c.4:   bridge window [mem 0xfba00000-0xfbafffff]
[    0.775817] pci 0000:05:00.0: reg 10: [io  0xdf00-0xdf07]
[    0.775823] pci 0000:05:00.0: reg 14: [io  0xde00-0xde03]
[    0.775830] pci 0000:05:00.0: reg 18: [io  0xdd00-0xdd07]
[    0.775836] pci 0000:05:00.0: reg 1c: [io  0xdc00-0xdc03]
[    0.775843] pci 0000:05:00.0: reg 20: [io  0xdb00-0xdb0f]
[    0.775850] pci 0000:05:00.0: reg 24: [mem 0xfb9ff000-0xfb9ff7ff]
[    0.775856] pci 0000:05:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.775886] pci 0000:05:00.0: PME# supported from D3hot
[    0.775890] pci 0000:05:00.0: PME# disabled
[    0.777485] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    0.777488] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.777491] pci 0000:00:1c.5:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.777526] pci 0000:06:00.0: reg 10: [io  0xce00-0xceff]
[    0.777544] pci 0000:06:00.0: reg 18: [mem 0xfbdff000-0xfbdfffff 64bit pref]
[    0.777556] pci 0000:06:00.0: reg 20: [mem 0xfbdf8000-0xfbdfbfff 64bit pref]
[    0.777563] pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.777599] pci 0000:06:00.0: supports D1 D2
[    0.777600] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.777604] pci 0000:06:00.0: PME# disabled
[    0.779481] pci 0000:00:1c.6: PCI bridge to [bus 06-06]
[    0.779484] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.779487] pci 0000:00:1c.6:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.779491] pci 0000:00:1c.6:   bridge window [mem 0xfbd00000-0xfbdfffff 64bit pref]
[    0.779518] pci 0000:07:03.0: reg 10: [io  0xbf00-0xbf07]
[    0.779523] pci 0000:07:03.0: reg 14: [io  0xbe00-0xbe03]
[    0.779528] pci 0000:07:03.0: reg 18: [io  0xbd00-0xbd07]
[    0.779533] pci 0000:07:03.0: reg 1c: [io  0xbc00-0xbc03]
[    0.779538] pci 0000:07:03.0: reg 20: [io  0xbb00-0xbb0f]
[    0.779589] pci 0000:07:07.0: reg 10: [mem 0xfbbff000-0xfbbff7ff]
[    0.779595] pci 0000:07:07.0: reg 14: [mem 0xfbbf8000-0xfbbfbfff]
[    0.779632] pci 0000:07:07.0: supports D1 D2
[    0.779633] pci 0000:07:07.0: PME# supported from D0 D1 D2 D3hot
[    0.779637] pci 0000:07:07.0: PME# disabled
[    0.779668] pci 0000:00:1e.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.779671] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.779674] pci 0000:00:1e.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    0.779700] pci_bus 0000:00: on NUMA node 0
[    0.779702] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.779865] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.779906] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.779941] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.779987] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.780022] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.780060] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.798682] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.798751] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.798819] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
[    0.798888] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
[    0.798956] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.799025] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
[    0.799093] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.799161] ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[    0.799230] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.799233] vgaarb: loaded
[    0.799273] SCSI subsystem initialized
[    0.799349] libata version 3.00 loaded.
[    0.799374] usbcore: registered new interface driver usbfs
[    0.799386] usbcore: registered new interface driver hub
[    0.799399] usbcore: registered new device driver usb
[    0.799426] PCI: Using ACPI for IRQ routing
[    0.799428] PCI: pci_cache_line_size set to 64 bytes
[    0.799562]   alloc irq_desc for 24 on node 0
[    0.799563]   alloc kstat_irqs on node 0
[    0.799568]   alloc irq_desc for 25 on node 0
[    0.799569]   alloc kstat_irqs on node 0
[    0.799571]   alloc irq_desc for 26 on node 0
[    0.799572]   alloc kstat_irqs on node 0
[    0.799575]   alloc irq_desc for 27 on node 0
[    0.799576]   alloc kstat_irqs on node 0
[    0.799578]   alloc irq_desc for 28 on node 0
[    0.799579]   alloc kstat_irqs on node 0
[    0.799581] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    0.799587] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[    0.799591] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.802354] hpet: hpet2 irq 24 for MSI
[    0.802408] hpet: hpet3 irq 25 for MSI
[    0.803402] hpet: hpet4 irq 26 for MSI
[    0.804395] hpet: hpet5 irq 27 for MSI
[    0.805387] hpet: hpet6 irq 28 for MSI
[    0.807462] Switching to clocksource tsc
[    0.807698] pnp: PnP ACPI init
[    0.807705] ACPI: bus type pnp registered
[    0.809267] pnp: PnP ACPI: found 11 devices
[    0.809268] ACPI: ACPI bus type pnp unregistered
[    0.809273] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.809275] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.809277] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.809278] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.809280] system 00:01: [io  0x0880-0x088f] has been reserved
[    0.809284] system 00:07: [io  0x0400-0x04cf] has been reserved
[    0.809285] system 00:07: [io  0x04d2-0x04ff] has been reserved
[    0.809288] system 00:08: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.809291] system 00:09: [mem 0x000dd000-0x000dffff] has been reserved
[    0.809293] system 00:09: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.809295] system 00:09: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.809297] system 00:09: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.809298] system 00:09: [mem 0xbfbe0000-0xbfbfffff] could not be reserved
[    0.809300] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.809302] system 00:09: [mem 0x00100000-0xbfbdffff] could not be reserved
[    0.809304] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.809306] system 00:09: [mem 0xfed10000-0xfed1dfff] has been reserved
[    0.809307] system 00:09: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.809309] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.809311] system 00:09: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.809312] system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
[    0.809314] system 00:09: [mem 0x000e0000-0x000effff] has been reserved
[    0.813999] pci 0000:00:1c.0: BAR 14: assigned [mem 0xe0000000-0xe01fffff]
[    0.814001] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe0200000-0xe03fffff 64bit pref]
[    0.814003] pci 0000:00:1c.3: BAR 15: assigned [mem 0xe0400000-0xe05fffff 64bit pref]
[    0.814005] pci 0000:00:1c.4: BAR 15: assigned [mem 0xe0600000-0xe07fffff 64bit pref]
[    0.814007] pci 0000:00:1c.5: BAR 15: assigned [mem 0xe0800000-0xe09fffff pref]
[    0.814009] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.814010] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.814013] pci 0000:01:00.0: BAR 6: assigned [mem 0xf9000000-0xf907ffff pref]
[    0.814014] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    0.814016] pci 0000:00:03.0:   bridge window [io  0xa000-0xafff]
[    0.814019] pci 0000:00:03.0:   bridge window [mem 0xf6000000-0xf9ffffff]
[    0.814021] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.814025] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.814027] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.814030] pci 0000:00:1c.0:   bridge window [mem 0xe0000000-0xe01fffff]
[    0.814033] pci 0000:00:1c.0:   bridge window [mem 0xe0200000-0xe03fffff 64bit pref]
[    0.814038] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
[    0.814040] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.814043] pci 0000:00:1c.3:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.814047] pci 0000:00:1c.3:   bridge window [mem 0xe0400000-0xe05fffff 64bit pref]
[    0.814051] pci 0000:00:1c.4: PCI bridge to [bus 04-04]
[    0.814053] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.814057] pci 0000:00:1c.4:   bridge window [mem 0xfba00000-0xfbafffff]
[    0.814060] pci 0000:00:1c.4:   bridge window [mem 0xe0600000-0xe07fffff 64bit pref]
[    0.814065] pci 0000:05:00.0: BAR 6: assigned [mem 0xe0800000-0xe080ffff pref]
[    0.814066] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    0.814068] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.814072] pci 0000:00:1c.5:   bridge window [mem 0xfb900000-0xfb9fffff]
[    0.814075] pci 0000:00:1c.5:   bridge window [mem 0xe0800000-0xe09fffff pref]
[    0.814079] pci 0000:06:00.0: BAR 6: assigned [mem 0xfbd00000-0xfbd1ffff pref]
[    0.814081] pci 0000:00:1c.6: PCI bridge to [bus 06-06]
[    0.814083] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.814086] pci 0000:00:1c.6:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.814089] pci 0000:00:1c.6:   bridge window [mem 0xfbd00000-0xfbdfffff 64bit pref]
[    0.814094] pci 0000:00:1e.0: PCI bridge to [bus 07-07]
[    0.814096] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.814099] pci 0000:00:1e.0:   bridge window [mem 0xfbb00000-0xfbbfffff]
[    0.814102] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.814110]   alloc irq_desc for 16 on node -1
[    0.814111]   alloc kstat_irqs on node -1
[    0.814114] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.814117] pci 0000:00:03.0: setting latency timer to 64
[    0.814123] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.814125] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.814129] pci 0000:00:1c.0: setting latency timer to 64
[    0.814134] pci 0000:00:1c.3: enabling device (0006 -> 0007)
[    0.814136]   alloc irq_desc for 19 on node -1
[    0.814137]   alloc kstat_irqs on node -1
[    0.814140] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.814142] pci 0000:00:1c.3: setting latency timer to 64
[    0.814148] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.814151] pci 0000:00:1c.4: setting latency timer to 64
[    0.814156]   alloc irq_desc for 17 on node -1
[    0.814157]   alloc kstat_irqs on node -1
[    0.814159] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.814162] pci 0000:00:1c.5: setting latency timer to 64
[    0.814167]   alloc irq_desc for 18 on node -1
[    0.814168]   alloc kstat_irqs on node -1
[    0.814171] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.814174] pci 0000:00:1c.6: setting latency timer to 64
[    0.814178] pci 0000:00:1e.0: setting latency timer to 64
[    0.814181] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.814182] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.814184] pci_bus 0000:01: resource 0 [io  0xa000-0xafff]
[    0.814185] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf9ffffff]
[    0.814187] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.814188] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.814189] pci_bus 0000:02: resource 1 [mem 0xe0000000-0xe01fffff]
[    0.814191] pci_bus 0000:02: resource 2 [mem 0xe0200000-0xe03fffff 64bit pref]
[    0.814192] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.814194] pci_bus 0000:03: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    0.814195] pci_bus 0000:03: resource 2 [mem 0xe0400000-0xe05fffff 64bit pref]
[    0.814197] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.814198] pci_bus 0000:04: resource 1 [mem 0xfba00000-0xfbafffff]
[    0.814199] pci_bus 0000:04: resource 2 [mem 0xe0600000-0xe07fffff 64bit pref]
[    0.814201] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.814202] pci_bus 0000:05: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.814204] pci_bus 0000:05: resource 2 [mem 0xe0800000-0xe09fffff pref]
[    0.814205] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.814206] pci_bus 0000:06: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.814208] pci_bus 0000:06: resource 2 [mem 0xfbd00000-0xfbdfffff 64bit pref]
[    0.814209] pci_bus 0000:07: resource 0 [io  0xb000-0xbfff]
[    0.814211] pci_bus 0000:07: resource 1 [mem 0xfbb00000-0xfbbfffff]
[    0.814212] pci_bus 0000:07: resource 3 [io  0x0000-0xffff]
[    0.814213] pci_bus 0000:07: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.814224] NET: Registered protocol family 2
[    0.814251] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.814475] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.815498] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.815753] TCP: Hash tables configured (established 262144 bind 65536)
[    0.815755] TCP reno registered
[    0.815757] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.815811] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.815908] NET: Registered protocol family 1
[    0.837573] pci 0000:01:00.0: Boot video device
[    0.837610] PCI: CLS 64 bytes, default 64
[    0.837620] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.837622] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.837624] software IO TLB at phys 0x20000000 - 0x24000000
[    0.839006] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    0.839338] msgmni has been set to 15981
[    0.839371] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.839373] io scheduler noop registered
[    0.839405] io scheduler cfq registered (default)
[    0.839459] pcieport 0000:00:03.0: setting latency timer to 64
[    0.839479]   alloc irq_desc for 29 on node -1
[    0.839480]   alloc kstat_irqs on node -1
[    0.839485] pcieport 0000:00:03.0: irq 29 for MSI/MSI-X
[    0.839527] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.839551]   alloc irq_desc for 30 on node -1
[    0.839552]   alloc kstat_irqs on node -1
[    0.839557] pcieport 0000:00:1c.0: irq 30 for MSI/MSI-X
[    0.839607] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.839631]   alloc irq_desc for 31 on node -1
[    0.839632]   alloc kstat_irqs on node -1
[    0.839637] pcieport 0000:00:1c.3: irq 31 for MSI/MSI-X
[    0.839684] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.839709]   alloc irq_desc for 32 on node -1
[    0.839710]   alloc kstat_irqs on node -1
[    0.839715] pcieport 0000:00:1c.4: irq 32 for MSI/MSI-X
[    0.839769] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.839794]   alloc irq_desc for 33 on node -1
[    0.839795]   alloc kstat_irqs on node -1
[    0.839800] pcieport 0000:00:1c.5: irq 33 for MSI/MSI-X
[    0.839847] pcieport 0000:00:1c.6: setting latency timer to 64
[    0.839872]   alloc irq_desc for 34 on node -1
[    0.839873]   alloc kstat_irqs on node -1
[    0.839878] pcieport 0000:00:1c.6: irq 34 for MSI/MSI-X
[    0.839933] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    0.839994] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.839995] ACPI: Power Button [PWRB]
[    0.840026] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.840028] ACPI: Power Button [PWRF]
[    0.840456] Monitor-Mwait will be used to enter C-1 state
[    0.840471] Monitor-Mwait will be used to enter C-2 state
[    0.840481] Monitor-Mwait will be used to enter C-3 state
[    0.845734] ahci 0000:00:1f.2: version 3.0
[    0.845743] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.845763]   alloc irq_desc for 35 on node -1
[    0.845764]   alloc kstat_irqs on node -1
[    0.845769] ahci 0000:00:1f.2: irq 35 for MSI/MSI-X
[    0.845777] ahci 0000:00:1f.2: controller can't do SNTF, turning off CAP_SNTF
[    0.845794] ahci: SSS flag set, parallel bus scan disabled
[    0.856959] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
[    0.856962] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pmp pio slum part ems apst 
[    0.856965] ahci 0000:00:1f.2: setting latency timer to 64
[    0.866495] scsi0 : ahci
[    0.866539] scsi1 : ahci
[    0.866567] scsi2 : ahci
[    0.866594] scsi3 : ahci
[    0.866621] scsi4 : ahci
[    0.866649] scsi5 : ahci
[    0.866668] ata1: SATA max UDMA/133 abar m2048@0xfbffd000 port 0xfbffd100 irq 35
[    0.866670] ata2: SATA max UDMA/133 abar m2048@0xfbffd000 port 0xfbffd180 irq 35
[    0.866672] ata3: SATA max UDMA/133 abar m2048@0xfbffd000 port 0xfbffd200 irq 35
[    0.866674] ata4: SATA max UDMA/133 abar m2048@0xfbffd000 port 0xfbffd280 irq 35
[    0.866676] ata5: SATA max UDMA/133 abar m2048@0xfbffd000 port 0xfbffd300 irq 35
[    0.866678] ata6: SATA max UDMA/133 abar m2048@0xfbffd000 port 0xfbffd380 irq 35
[    0.866695] ahci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.877470] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    0.877472] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    0.877476] ahci 0000:04:00.0: setting latency timer to 64
[    0.877555] scsi6 : ahci
[    0.877585] scsi7 : ahci
[    0.877608] ata7: SATA max UDMA/133 abar m8192@0xfbafe000 port 0xfbafe100 irq 16
[    0.877611] ata8: SATA max UDMA/133 abar m8192@0xfbafe000 port 0xfbafe180 irq 16
[    0.877641] ahci 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.877678]   alloc irq_desc for 36 on node -1
[    0.877679]   alloc kstat_irqs on node -1
[    0.877686] ahci 0000:05:00.0: irq 36 for MSI/MSI-X
[    0.888476] ahci 0000:05:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    0.888479] ahci 0000:05:00.0: flags: 64bit ncq pio 
[    0.888482] ahci 0000:05:00.0: setting latency timer to 64
[    0.888732] scsi8 : ahci
[    0.888762] scsi9 : ahci
[    0.888791] scsi10 : ahci
[    0.888819] scsi11 : ahci
[    0.888849] scsi12 : ahci
[    0.888878] scsi13 : ahci
[    0.888906] scsi14 : ahci
[    0.888937] scsi15 : ahci
[    0.888958] ata9: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff100 irq 36
[    0.888961] ata10: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff180 irq 36
[    0.888963] ata11: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff200 irq 36
[    0.888966] ata12: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff280 irq 36
[    0.888968] ata13: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff300 irq 36
[    0.888971] ata14: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff380 irq 36
[    0.888973] ata15: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff400 irq 36
[    0.888976] ata16: SATA max UDMA/133 abar m2048@0xfb9ff000 port 0xfb9ff480 irq 36
[    0.889042] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.889055] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.889063] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.889065] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.889079] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.889103] ehci_hcd 0000:00:1a.7: debug port 2
[    0.892973] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.892982] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbfff000
[    0.902377] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.902388] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.902390] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.902391] usb usb1: Product: EHCI Host Controller
[    0.902392] usb usb1: Manufacturer: Linux 2.6.33-p1 ehci_hcd
[    0.902393] usb usb1: SerialNumber: 0000:00:1a.7
[    0.902441] hub 1-0:1.0: USB hub found
[    0.902444] hub 1-0:1.0: 6 ports detected
[    0.902490]   alloc irq_desc for 23 on node -1
[    0.902491]   alloc kstat_irqs on node -1
[    0.902494] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.902502] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.902504] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.902509] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.902526] ehci_hcd 0000:00:1d.7: debug port 2
[    0.906394] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.906402] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbffe000
[    0.915778] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.915786] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.915787] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.915789] usb usb2: Product: EHCI Host Controller
[    0.915790] usb usb2: Manufacturer: Linux 2.6.33-p1 ehci_hcd
[    0.915791] usb usb2: SerialNumber: 0000:00:1d.7
[    0.915833] hub 2-0:1.0: USB hub found
[    0.915835] hub 2-0:1.0: 8 ports detected
[    0.915882] uhci_hcd: USB Universal Host Controller Interface driver
[    0.915909] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.915913] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.915915] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.915919] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.915939] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff00
[    0.915958] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.915959] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.915960] usb usb3: Product: UHCI Host Controller
[    0.915961] usb usb3: Manufacturer: Linux 2.6.33-p1 uhci_hcd
[    0.915963] usb usb3: SerialNumber: 0000:00:1a.0
[    0.916003] hub 3-0:1.0: USB hub found
[    0.916005] hub 3-0:1.0: 2 ports detected
[    0.916039]   alloc irq_desc for 21 on node -1
[    0.916040]   alloc kstat_irqs on node -1
[    0.916043] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.916047] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.916049] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.916053] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.916077] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fe00
[    0.916096] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.916097] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.916099] usb usb4: Product: UHCI Host Controller
[    0.916100] usb usb4: Manufacturer: Linux 2.6.33-p1 uhci_hcd
[    0.916101] usb usb4: SerialNumber: 0000:00:1a.1
[    0.916146] hub 4-0:1.0: USB hub found
[    0.916148] hub 4-0:1.0: 2 ports detected
[    0.916184] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.916188] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.916190] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.916194] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.916213] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000fd00
[    0.916231] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.916233] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.916234] usb usb5: Product: UHCI Host Controller
[    0.916235] usb usb5: Manufacturer: Linux 2.6.33-p1 uhci_hcd
[    0.916236] usb usb5: SerialNumber: 0000:00:1a.2
[    0.916279] hub 5-0:1.0: USB hub found
[    0.916281] hub 5-0:1.0: 2 ports detected
[    0.916316] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.916320] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.916322] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.916325] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.916344] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
[    0.916362] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.916364] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.916365] usb usb6: Product: UHCI Host Controller
[    0.916366] usb usb6: Manufacturer: Linux 2.6.33-p1 uhci_hcd
[    0.916367] usb usb6: SerialNumber: 0000:00:1d.0
[    0.916406] hub 6-0:1.0: USB hub found
[    0.916408] hub 6-0:1.0: 2 ports detected
[    0.916443] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.916447] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.916449] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.916453] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.916478] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
[    0.916496] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.916497] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.916499] usb usb7: Product: UHCI Host Controller
[    0.916500] usb usb7: Manufacturer: Linux 2.6.33-p1 uhci_hcd
[    0.916501] usb usb7: SerialNumber: 0000:00:1d.1
[    0.916541] hub 7-0:1.0: USB hub found
[    0.916543] hub 7-0:1.0: 2 ports detected
[    0.916579] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.916583] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.916585] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.916588] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.916607] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
[    0.916625] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.916627] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.916628] usb usb8: Product: UHCI Host Controller
[    0.916629] usb usb8: Manufacturer: Linux 2.6.33-p1 uhci_hcd
[    0.916630] usb usb8: SerialNumber: 0000:00:1d.2
[    0.916671] hub 8-0:1.0: USB hub found
[    0.916676] hub 8-0:1.0: 2 ports detected
[    0.916710] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.916714] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.916716] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.916720] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 9
[    0.916738] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000f900
[    0.916757] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
[    0.916759] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.916760] usb usb9: Product: UHCI Host Controller
[    0.916761] usb usb9: Manufacturer: Linux 2.6.33-p1 uhci_hcd
[    0.916762] usb usb9: SerialNumber: 0000:00:1d.3
[    0.916806] hub 9-0:1.0: USB hub found
[    0.916808] hub 9-0:1.0: 2 ports detected
[    0.916857] xhci_hcd 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.916866] xhci_hcd 0000:03:00.0: setting latency timer to 64
[    0.916869] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    0.916873] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 10
[    0.917003] xhci_hcd 0000:03:00.0: irq 19, io mem 0xfbcfe000
[    0.917036] usb usb10: config 1 interface 0 altsetting 0 endpoint 0x81 has no SuperSpeed companion descriptor
[    0.917041] usb usb10: New USB device found, idVendor=1d6b, idProduct=0002
[    0.917042] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.917044] usb usb10: Product: xHCI Host Controller
[    0.917045] usb usb10: Manufacturer: Linux 2.6.33-p1 xhci_hcd
[    0.917046] usb usb10: SerialNumber: 0000:03:00.0
[    0.917077] xHCI xhci_add_endpoint called for root hub
[    0.917078] xHCI xhci_check_bandwidth called for root hub
[    0.917092] hub 10-0:1.0: USB hub found
[    0.917094] hub 10-0:1.0: 4 ports detected
[    0.917146] Initializing USB Mass Storage driver...
[    0.917171] usbcore: registered new interface driver usb-storage
[    0.917172] USB Mass Storage support registered.
[    0.917195] usbcore: registered new interface driver libusual
[    0.917217] PNP: No PS/2 controller found. Probing ports directly.
[    0.950836] Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    0.950837] If AUX port is really absent please use the 'i8042.noaux' option.
[    1.170678] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.172199] ata1.00: ATA-8: MAXTOR STM3750330AS, MX15, max UDMA/133
[    1.172201] ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.174134] ata1.00: configured for UDMA/133
[    1.181964] ata7: SATA link down (SStatus 0 SControl 300)
[    1.181993] ata8: SATA link down (SStatus 0 SControl 300)
[    1.184688] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM375033 MX15 PQ: 0 ANSI: 5
[    1.184779] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    1.184803] sd 0:0:0:0: [sda] Write Protect is off
[    1.184805] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.184814] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.184886]  sda: sda1 sda2 sda3 sda4 <
[    1.198632] ata9: SATA link down (SStatus 0 SControl 300)
[    1.198636] ata13: SATA link down (SStatus 0 SControl 300)
[    1.198641] ata14: SATA link down (SStatus 0 SControl 300)
[    1.198645] ata11: SATA link down (SStatus 0 SControl 300)
[    1.198685] ata10: SATA link down (SStatus 0 SControl 300)
[    1.198688] ata12: SATA link down (SStatus 0 SControl 300)
[    1.198692] ata15: SATA link down (SStatus 0 SControl 300)
[    1.200101] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.200135] mice: PS/2 mouse device common for all mice
[    1.200156] rtc_cmos 00:04: RTC can wake from S4
[    1.200174] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.200197] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.200331] cpuidle: using governor ladder
[    1.200543] cpuidle: using governor menu
[    1.200608] ata16: SATA link up <unknown> (SStatus FFFFFF93 SControl 300)
[    1.200658] ------------[ cut here ]------------
[    1.200662] WARNING: at arch/x86/kernel/hpet.c:404 hpet_next_event+0x57/0x77()
[    1.200663] Hardware name: P55A-UD4
[    1.200664] hpet: compare register read back failed.
[    1.200665] Modules linked in:
[    1.200666] Pid: 0, comm: swapper Not tainted 2.6.33-p1 #10
[    1.200668] Call Trace:
[    1.200671]  [<ffffffff8102c98f>] ? warn_slowpath_common+0x76/0x8c
[    1.200673]  [<ffffffff8102c9f7>] ? warn_slowpath_fmt+0x40/0x45
[    1.200676]  [<ffffffff81026166>] ? find_busiest_group+0x341/0x7fe
[    1.200678]  [<ffffffff81018eb1>] ? hpet_next_event+0x57/0x77
[    1.200681]  [<ffffffff81048d1e>] ? tick_dev_program_event+0x33/0x9e
[    1.200684]  [<ffffffff81048836>] ? tick_broadcast_oneshot_control+0x9c/0xf5
[    1.200686]  [<ffffffff81048220>] ? tick_notify+0x1f9/0x34d
[    1.200688]  [<ffffffff8104257a>] ? notifier_call_chain+0x2e/0x5b
[    1.200690]  [<ffffffff81047c56>] ? clockevents_notify+0x31/0x139
[    1.200693]  [<ffffffff81175aa0>] ? acpi_idle_enter_simple+0x93/0x130
[    1.200696]  [<ffffffff811673c3>] ? acpi_write_bit_register+0x9e/0xab
[    1.200698]  [<ffffffff8117585c>] ? acpi_idle_enter_bm+0xd3/0x284
[    1.200701]  [<ffffffff811f2705>] ? cpuidle_idle_call+0x89/0xc0
[    1.200704]  [<ffffffff81001256>] ? cpu_idle+0x9d/0xd7
[    1.200707] ---[ end trace a4e806103d58b3e6 ]---
[    1.200719] ata16.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.200725] usbcore: registered new interface driver hiddev
[    1.200732] usbcore: registered new interface driver usbhid
[    1.200733] usbhid: USB HID core driver
[    1.200810] TCP cubic registered
[    1.200811] NET: Registered protocol family 17
[    1.200957] ata16.00: configured for UDMA/66
[    1.203697] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.216877]  sda5 >
[    1.217103] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.217615] registered taskstats version 1
[    1.218143] rtc_cmos 00:04: setting system clock to 2010-03-09 21:14:54 UTC (1268169294)
[    1.321687] usb 1-1: New USB device found, idVendor=0dda, idProduct=2005
[    1.321691] usb 1-1: New USB device strings: Mfr=3, Product=4, SerialNumber=5
[    1.321694] usb 1-1: Product: Card Reader
[    1.321696] usb 1-1: Manufacturer: Hama
[    1.321699] usb 1-1: SerialNumber: 000000000013
[    1.323401] scsi16 : usb-storage 1-1:1.0
[    1.425039] usb 1-2: new high speed USB device using ehci_hcd and address 3
[    1.541342] usb 1-2: New USB device found, idVendor=2040, idProduct=7060
[    1.541346] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.541349] usb 1-2: Product: Nova-T Stick
[    1.541351] usb 1-2: Manufacturer: Hauppauge
[    1.541354] usb 1-2: SerialNumber: 4027602366
[    1.643452] usb 2-7: new high speed USB device using ehci_hcd and address 2
[    1.757891] usb 2-7: New USB device found, idVendor=0409, idProduct=0058
[    1.757896] usb 2-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.757899] usb 2-7: Product: USB2.0 Hub Controller
[    1.757902] usb 2-7: Manufacturer: NEC Corporation
[    1.758186] hub 2-7:1.0: USB hub found
[    1.758237] hub 2-7:1.0: 4 ports detected
[    1.905764] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.945632] ata2.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    1.945636] ata2.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.987287] ata2.00: configured for UDMA/133
[    1.997654] scsi 1:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
[    1.997787] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    1.997821] sd 1:0:0:0: [sdb] Write Protect is off
[    1.997822] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.997831] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.997893]  sdb: sdb1
[    2.008267] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.091264] usb 9-2: new full speed USB device using uhci_hcd and address 2
[    2.202972] usb 9-2: device descriptor read/64, error -71
[    2.415413] usb 9-2: device descriptor read/64, error -71
[    2.617873] usb 9-2: new full speed USB device using uhci_hcd and address 3
[    2.718649] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.729579] usb 9-2: device descriptor read/64, error -71
[    2.771979] ata3.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    2.771983] ata3.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.813723] ata3.00: configured for UDMA/133
[    2.824447] scsi 2:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
[    2.824569] sd 2:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    2.824608] sd 2:0:0:0: [sdc] Write Protect is off
[    2.824610] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.824620] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.824678]  sdc: unknown partition table
[    2.838645] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.942015] usb 9-2: device descriptor read/64, error -71
[    3.128591] ata4: SATA link down (SStatus 0 SControl 300)
[    3.144484] usb 9-2: new full speed USB device using uhci_hcd and address 4
[    3.551391] usb 9-2: device not accepting address 4, error -71
[    3.653177] usb 9-2: new full speed USB device using uhci_hcd and address 5
[    3.860626] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.864749] ata5.00: ATAPI: HL-DT-ST DVDRAM GH22NS50, TN02, max UDMA/100, ATAPI AN
[    3.869068] ata5.00: configured for UDMA/100
[    3.887893] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH22NS50  TN02 PQ: 0 ANSI: 5
[    4.060046] usb 9-2: device not accepting address 5, error -71
[    4.060103] hub 9-0:1.0: unable to enumerate USB device on port 2
[    4.132898] usb 2-7.3: new low speed USB device using ehci_hcd and address 4
[    4.191735] ata6: SATA link down (SStatus 0 SControl 300)
[    4.203026] scsi 15:0:0:0: Processor         Marvell  91xx Config      1.01 PQ: 0 ANSI: 5
[    4.225436] usb 2-7.3: New USB device found, idVendor=0458, idProduct=002e
[    4.225440] usb 2-7.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.225444] usb 2-7.3: Product: NetScroll+ Traveler
[    4.225446] usb 2-7.3: Manufacturer: KYE
[    4.230336] input: KYE NetScroll+ Traveler as /devices/pci0000:00/0000:00:1d.7/usb2/2-7/2-7.3/2-7.3:1.0/input/input2
[    4.230370] generic-usb 0003:0458:002E.0001: input: USB HID v1.10 Mouse [KYE NetScroll+ Traveler] on usb-0000:00:1d.7-7.3/input0
[    4.240650] XFS mounting filesystem sda3
[    4.303603] usb 2-7.4: new low speed USB device using ehci_hcd and address 5
[    4.374214] Ending clean XFS mount for filesystem: sda3
[    4.374298] VFS: Mounted root (xfs filesystem) readonly on device 8:3.
[    4.374363] Freeing unused kernel memory: 368k freed
[    4.374441] Write protecting the kernel read-only data: 6144k
[    4.374769] Freeing unused kernel memory: 1612k freed
[    4.375136] Freeing unused kernel memory: 1148k freed
[    4.394728] usb 2-7.4: New USB device found, idVendor=413c, idProduct=2003
[    4.394733] usb 2-7.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.394736] usb 2-7.4: Product: Dell USB Keyboard
[    4.394739] usb 2-7.4: Manufacturer: Dell
[    4.399901] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.7/usb2/2-7/2-7.4/2-7.4:1.0/input/input3
[    4.399911] generic-usb 0003:413C:2003.0002: input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.7-7.4/input0
[    6.149402] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.149422] r8169 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.149562] r8169 0000:06:00.0: setting latency timer to 64
[    6.149604]   alloc irq_desc for 37 on node -1
[    6.149606]   alloc kstat_irqs on node -1
[    6.149620] r8169 0000:06:00.0: irq 37 for MSI/MSI-X
[    6.149854] eth0: RTL8168d/8111d at 0xffffc9000007c000, 6c:f0:49:50:b5:72, XID 083000c0 IRQ 37
[    6.171857] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.171892] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    6.171914] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    6.171939] scsi 4:0:0:0: Attached scsi generic sg3 type 5
[    6.171958] scsi 15:0:0:0: Attached scsi generic sg4 type 3
[    6.177400] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    6.198272] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.198277] Uniform CD-ROM driver Revision: 3.20
[    6.198430] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    6.311724] scsi 16:0:0:0: Direct-Access     Hama     CF  Card Reader  9317 PQ: 0 ANSI: 0
[    6.311836] sd 16:0:0:0: Attached scsi generic sg5 type 0
[    6.312969] scsi 16:0:0:1: Direct-Access     Hama     SM  Card Reader  9317 PQ: 0 ANSI: 0
[    6.313069] sd 16:0:0:1: Attached scsi generic sg6 type 0
[    6.314574] scsi 16:0:0:2: Direct-Access     Hama     SD  Card Reader  9317 PQ: 0 ANSI: 0
[    6.314647] sd 16:0:0:2: Attached scsi generic sg7 type 0
[    6.316076] sd 16:0:0:0: [sdd] Attached SCSI removable disk
[    6.317065] scsi 16:0:0:3: Direct-Access     Hama     MS  Card Reader  9317 PQ: 0 ANSI: 0
[    6.317147] sd 16:0:0:3: Attached scsi generic sg8 type 0
[    6.320301] sd 16:0:0:2: [sdf] Attached SCSI removable disk
[    6.321547] sd 16:0:0:3: [sdg] Attached SCSI removable disk
[    6.324108] sd 16:0:0:1: [sde] Attached SCSI removable disk
[    6.566521]   alloc irq_desc for 22 on node -1
[    6.566523]   alloc kstat_irqs on node -1
[    6.566528] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.566648]   alloc irq_desc for 38 on node -1
[    6.566649]   alloc kstat_irqs on node -1
[    6.566656] HDA Intel 0000:00:1b.0: irq 38 for MSI/MSI-X
[    6.566677] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.660583] hda_codec: ALC889: BIOS auto-probing.
[    7.907741] Adding 8980292k swap on /dev/sda5.  Priority:-1 extents:1 across:8980292k 
[    8.027484] loop: module loaded
[    8.069900] it87: Found IT8720F chip at 0x290, revision 8
[    8.069907] it87: VID is disabled (pins used for GPIO)
[    8.069913] it87: in3 is VCC (+5V)
[    8.126412] coretemp coretemp.0: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.126493] coretemp coretemp.1: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.126573] coretemp coretemp.2: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.126676] coretemp coretemp.3: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.126703] coretemp coretemp.4: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.126735] coretemp coretemp.5: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.126767] coretemp coretemp.6: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.127353] coretemp coretemp.7: Unable to access MSR 0xEE, for Tjmax, left at default
[    8.141736] iTCO_vendor_support: vendor-support=0
[    8.154792] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.154944] iTCO_wdt: Found a P55 TCO device (Version=2, TCOBASE=0x0460)
[    8.155007] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.854964] r8169: eth0: link up
[    8.854968] r8169: eth0: link up
[   17.979694] microcode: CPU0 sig=0x106e5, pf=0x2, revision=0x3
[   17.979701] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.010532] microcode: CPU1 sig=0x106e5, pf=0x2, revision=0x3
[   18.010540] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.012166] microcode: CPU2 sig=0x106e5, pf=0x2, revision=0x3
[   18.012170] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.013343] microcode: CPU3 sig=0x106e5, pf=0x2, revision=0x3
[   18.013346] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.014553] microcode: CPU4 sig=0x106e5, pf=0x2, revision=0x3
[   18.014561] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.015698] microcode: CPU5 sig=0x106e5, pf=0x2, revision=0x3
[   18.015701] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.016785] microcode: CPU6 sig=0x106e5, pf=0x2, revision=0x3
[   18.016788] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.017808] microcode: CPU7 sig=0x106e5, pf=0x2, revision=0x3
[   18.017811] platform microcode: firmware: requesting intel-ucode/06-1e-05
[   18.018880] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba


--MP_/u_SV8xq8+sr1ZS8=B1Xu=eF
Content-Type: application/octet-stream; name=config
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=config

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIG1ha2UgY29uZmlnOiBkb24ndCBlZGl0CiMgTGlu
dXgga2VybmVsIHZlcnNpb246IDIuNi4zMwojIFR1ZSBNYXIgIDkgMjE6Mjc6MDkgMjAxMAojCkNP
TkZJR182NEJJVD15CiMgQ09ORklHX1g4Nl8zMiBpcyBub3Qgc2V0CkNPTkZJR19YODZfNjQ9eQpD
T05GSUdfWDg2PXkKQ09ORklHX09VVFBVVF9GT1JNQVQ9ImVsZjY0LXg4Ni02NCIKQ09ORklHX0FS
Q0hfREVGQ09ORklHPSJhcmNoL3g4Ni9jb25maWdzL3g4Nl82NF9kZWZjb25maWciCkNPTkZJR19H
RU5FUklDX1RJTUU9eQpDT05GSUdfR0VORVJJQ19DTU9TX1VQREFURT15CkNPTkZJR19DTE9DS1NP
VVJDRV9XQVRDSERPRz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTPXkKQ09ORklHX0dFTkVS
SUNfQ0xPQ0tFVkVOVFNfQlJPQURDQVNUPXkKQ09ORklHX0xPQ0tERVBfU1VQUE9SVD15CkNPTkZJ
R19TVEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9MQVRFTkNZVE9QX1NVUFBPUlQ9eQpD
T05GSUdfTU1VPXkKQ09ORklHX1pPTkVfRE1BPXkKQ09ORklHX0dFTkVSSUNfSVNBX0RNQT15CkNP
TkZJR19HRU5FUklDX0lPTUFQPXkKQ09ORklHX0dFTkVSSUNfQlVHPXkKQ09ORklHX0dFTkVSSUNf
QlVHX1JFTEFUSVZFX1BPSU5URVJTPXkKQ09ORklHX0dFTkVSSUNfSFdFSUdIVD15CkNPTkZJR19B
UkNIX01BWV9IQVZFX1BDX0ZEQz15CkNPTkZJR19SV1NFTV9HRU5FUklDX1NQSU5MT0NLPXkKIyBD
T05GSUdfUldTRU1fWENIR0FERF9BTEdPUklUSE0gaXMgbm90IHNldApDT05GSUdfQVJDSF9IQVNf
Q1BVX0lETEVfV0FJVD15CkNPTkZJR19HRU5FUklDX0NBTElCUkFURV9ERUxBWT15CkNPTkZJR19H
RU5FUklDX1RJTUVfVlNZU0NBTEw9eQpDT05GSUdfQVJDSF9IQVNfQ1BVX1JFTEFYPXkKQ09ORklH
X0FSQ0hfSEFTX0RFRkFVTFRfSURMRT15CkNPTkZJR19BUkNIX0hBU19DQUNIRV9MSU5FX1NJWkU9
eQpDT05GSUdfSEFWRV9TRVRVUF9QRVJfQ1BVX0FSRUE9eQpDT05GSUdfTkVFRF9QRVJfQ1BVX0VN
QkVEX0ZJUlNUX0NIVU5LPXkKQ09ORklHX05FRURfUEVSX0NQVV9QQUdFX0ZJUlNUX0NIVU5LPXkK
Q09ORklHX0hBVkVfQ1BVTUFTS19PRl9DUFVfTUFQPXkKQ09ORklHX0FSQ0hfSElCRVJOQVRJT05f
UE9TU0lCTEU9eQpDT05GSUdfQVJDSF9TVVNQRU5EX1BPU1NJQkxFPXkKQ09ORklHX1pPTkVfRE1B
MzI9eQpDT05GSUdfQVJDSF9QT1BVTEFURVNfTk9ERV9NQVA9eQpDT05GSUdfQVVESVRfQVJDSD15
CkNPTkZJR19BUkNIX1NVUFBPUlRTX09QVElNSVpFRF9JTkxJTklORz15CkNPTkZJR19BUkNIX1NV
UFBPUlRTX0RFQlVHX1BBR0VBTExPQz15CkNPTkZJR19HRU5FUklDX0hBUkRJUlFTPXkKQ09ORklH
X0dFTkVSSUNfSEFSRElSUVNfTk9fX0RPX0lSUT15CkNPTkZJR19HRU5FUklDX0lSUV9QUk9CRT15
CkNPTkZJR19HRU5FUklDX1BFTkRJTkdfSVJRPXkKQ09ORklHX1VTRV9HRU5FUklDX1NNUF9IRUxQ
RVJTPXkKQ09ORklHX1g4Nl82NF9TTVA9eQpDT05GSUdfWDg2X0hUPXkKQ09ORklHX1g4Nl9UUkFN
UE9MSU5FPXkKIyBDT05GSUdfS1RJTUVfU0NBTEFSIGlzIG5vdCBzZXQKQ09ORklHX0RFRkNPTkZJ
R19MSVNUPSIvbGliL21vZHVsZXMvJFVOQU1FX1JFTEVBU0UvLmNvbmZpZyIKQ09ORklHX0NPTlNU
UlVDVE9SUz15CgojCiMgR2VuZXJhbCBzZXR1cAojCkNPTkZJR19FWFBFUklNRU5UQUw9eQpDT05G
SUdfTE9DS19LRVJORUw9eQpDT05GSUdfSU5JVF9FTlZfQVJHX0xJTUlUPTMyCkNPTkZJR19MT0NB
TFZFUlNJT049Ii1wMSIKQ09ORklHX0xPQ0FMVkVSU0lPTl9BVVRPPXkKQ09ORklHX0hBVkVfS0VS
TkVMX0daSVA9eQpDT05GSUdfSEFWRV9LRVJORUxfQlpJUDI9eQpDT05GSUdfSEFWRV9LRVJORUxf
TFpNQT15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk89eQojIENPTkZJR19LRVJORUxfR1pJUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9CWklQMiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFUk5FTF9M
Wk1BIGlzIG5vdCBzZXQKQ09ORklHX0tFUk5FTF9MWk89eQpDT05GSUdfU1dBUD15CkNPTkZJR19T
WVNWSVBDPXkKQ09ORklHX1NZU1ZJUENfU1lTQ1RMPXkKIyBDT05GSUdfUE9TSVhfTVFVRVVFIGlz
IG5vdCBzZXQKIyBDT05GSUdfQlNEX1BST0NFU1NfQUNDVCBpcyBub3Qgc2V0CkNPTkZJR19UQVNL
U1RBVFM9eQpDT05GSUdfVEFTS19ERUxBWV9BQ0NUPXkKQ09ORklHX1RBU0tfWEFDQ1Q9eQpDT05G
SUdfVEFTS19JT19BQ0NPVU5USU5HPXkKIyBDT05GSUdfQVVESVQgaXMgbm90IHNldAoKIwojIFJD
VSBTdWJzeXN0ZW0KIwpDT05GSUdfVFJFRV9SQ1U9eQojIENPTkZJR19UUkVFX1BSRUVNUFRfUkNV
IGlzIG5vdCBzZXQKIyBDT05GSUdfVElOWV9SQ1UgaXMgbm90IHNldAojIENPTkZJR19SQ1VfVFJB
Q0UgaXMgbm90IHNldApDT05GSUdfUkNVX0ZBTk9VVD02NAojIENPTkZJR19SQ1VfRkFOT1VUX0VY
QUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfVFJFRV9SQ1VfVFJBQ0UgaXMgbm90IHNldApDT05GSUdf
SUtDT05GSUc9bQpDT05GSUdfSUtDT05GSUdfUFJPQz15CkNPTkZJR19MT0dfQlVGX1NISUZUPTE5
CkNPTkZJR19IQVZFX1VOU1RBQkxFX1NDSEVEX0NMT0NLPXkKIyBDT05GSUdfR1JPVVBfU0NIRUQg
aXMgbm90IHNldAojIENPTkZJR19DR1JPVVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lTRlNfREVQ
UkVDQVRFRF9WMiBpcyBub3Qgc2V0CkNPTkZJR19SRUxBWT15CkNPTkZJR19OQU1FU1BBQ0VTPXkK
IyBDT05GSUdfVVRTX05TIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBDX05TIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNFUl9OUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BJRF9OUyBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9OUyBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSU5JVFJEIGlzIG5vdCBzZXQK
Q09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFPXkKQ09ORklHX1NZU0NUTD15CkNPTkZJR19BTk9O
X0lOT0RFUz15CiMgQ09ORklHX0VNQkVEREVEIGlzIG5vdCBzZXQKQ09ORklHX1VJRDE2PXkKQ09O
RklHX1NZU0NUTF9TWVNDQUxMPXkKQ09ORklHX0tBTExTWU1TPXkKIyBDT05GSUdfS0FMTFNZTVNf
QUxMIGlzIG5vdCBzZXQKIyBDT05GSUdfS0FMTFNZTVNfRVhUUkFfUEFTUyBpcyBub3Qgc2V0CkNP
TkZJR19IT1RQTFVHPXkKQ09ORklHX1BSSU5USz15CkNPTkZJR19CVUc9eQpDT05GSUdfRUxGX0NP
UkU9eQpDT05GSUdfUENTUEtSX1BMQVRGT1JNPXkKQ09ORklHX0JBU0VfRlVMTD15CkNPTkZJR19G
VVRFWD15CkNPTkZJR19FUE9MTD15CkNPTkZJR19TSUdOQUxGRD15CkNPTkZJR19USU1FUkZEPXkK
Q09ORklHX0VWRU5URkQ9eQpDT05GSUdfU0hNRU09eQpDT05GSUdfQUlPPXkKQ09ORklHX0hBVkVf
UEVSRl9FVkVOVFM9eQoKIwojIEtlcm5lbCBQZXJmb3JtYW5jZSBFdmVudHMgQW5kIENvdW50ZXJz
CiMKQ09ORklHX1BFUkZfRVZFTlRTPXkKIyBDT05GSUdfUEVSRl9DT1VOVEVSUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFQlVHX1BFUkZfVVNFX1ZNQUxMT0MgaXMgbm90IHNldApDT05GSUdfVk1fRVZF
TlRfQ09VTlRFUlM9eQpDT05GSUdfUENJX1FVSVJLUz15CkNPTkZJR19TTFVCX0RFQlVHPXkKIyBD
T05GSUdfQ09NUEFUX0JSSyBpcyBub3Qgc2V0CiMgQ09ORklHX1NMQUIgaXMgbm90IHNldApDT05G
SUdfU0xVQj15CiMgQ09ORklHX1NMT0IgaXMgbm90IHNldAojIENPTkZJR19QUk9GSUxJTkcgaXMg
bm90IHNldApDT05GSUdfSEFWRV9PUFJPRklMRT15CiMgQ09ORklHX0tQUk9CRVMgaXMgbm90IHNl
dApDT05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUz15CkNPTkZJR19IQVZFX0lP
UkVNQVBfUFJPVD15CkNPTkZJR19IQVZFX0tQUk9CRVM9eQpDT05GSUdfSEFWRV9LUkVUUFJPQkVT
PXkKQ09ORklHX0hBVkVfQVJDSF9UUkFDRUhPT0s9eQpDT05GSUdfSEFWRV9ETUFfQVRUUlM9eQpD
T05GSUdfSEFWRV9ETUFfQVBJX0RFQlVHPXkKQ09ORklHX0hBVkVfSFdfQlJFQUtQT0lOVD15CkNP
TkZJR19IQVZFX1VTRVJfUkVUVVJOX05PVElGSUVSPXkKCiMKIyBHQ09WLWJhc2VkIGtlcm5lbCBw
cm9maWxpbmcKIwojIENPTkZJR19TTE9XX1dPUksgaXMgbm90IHNldAojIENPTkZJR19IQVZFX0dF
TkVSSUNfRE1BX0NPSEVSRU5UIGlzIG5vdCBzZXQKQ09ORklHX1NMQUJJTkZPPXkKQ09ORklHX1JU
X01VVEVYRVM9eQpDT05GSUdfQkFTRV9TTUFMTD0wCkNPTkZJR19NT0RVTEVTPXkKIyBDT05GSUdf
TU9EVUxFX0ZPUkNFX0xPQUQgaXMgbm90IHNldApDT05GSUdfTU9EVUxFX1VOTE9BRD15CiMgQ09O
RklHX01PRFVMRV9GT1JDRV9VTkxPQUQgaXMgbm90IHNldAojIENPTkZJR19NT0RWRVJTSU9OUyBp
cyBub3Qgc2V0CiMgQ09ORklHX01PRFVMRV9TUkNWRVJTSU9OX0FMTCBpcyBub3Qgc2V0CkNPTkZJ
R19TVE9QX01BQ0hJTkU9eQpDT05GSUdfQkxPQ0s9eQpDT05GSUdfQkxLX0RFVl9CU0c9eQpDT05G
SUdfQkxLX0RFVl9JTlRFR1JJVFk9eQpDT05GSUdfQkxPQ0tfQ09NUEFUPXkKCiMKIyBJTyBTY2hl
ZHVsZXJzCiMKQ09ORklHX0lPU0NIRURfTk9PUD15CiMgQ09ORklHX0lPU0NIRURfREVBRExJTkUg
aXMgbm90IHNldApDT05GSUdfSU9TQ0hFRF9DRlE9eQojIENPTkZJR19ERUZBVUxUX0RFQURMSU5F
IGlzIG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfQ0ZRPXkKIyBDT05GSUdfREVGQVVMVF9OT09QIGlz
IG5vdCBzZXQKQ09ORklHX0RFRkFVTFRfSU9TQ0hFRD0iY2ZxIgojIENPTkZJR19JTkxJTkVfU1BJ
Tl9UUllMT0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fVFJZTE9DS19CSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOTElORV9TUElOX0xPQ0sgaXMgbm90IHNldAojIENPTkZJR19JTkxJ
TkVfU1BJTl9MT0NLX0JIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1NQSU5fTE9DS19JUlEg
aXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfU1BJTl9MT0NLX0lSUVNBVkUgaXMgbm90IHNldApD
T05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLPXkKIyBDT05GSUdfSU5MSU5FX1NQSU5fVU5MT0NLX0JI
IGlzIG5vdCBzZXQKQ09ORklHX0lOTElORV9TUElOX1VOTE9DS19JUlE9eQojIENPTkZJR19JTkxJ
TkVfU1BJTl9VTkxPQ0tfSVJRUkVTVE9SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9SRUFE
X1RSWUxPQ0sgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVfUkVBRF9MT0NLIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5MSU5FX1JFQURfTE9DS19CSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9S
RUFEX0xPQ0tfSVJRIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1JFQURfTE9DS19JUlFTQVZF
IGlzIG5vdCBzZXQKQ09ORklHX0lOTElORV9SRUFEX1VOTE9DSz15CiMgQ09ORklHX0lOTElORV9S
RUFEX1VOTE9DS19CSCBpcyBub3Qgc2V0CkNPTkZJR19JTkxJTkVfUkVBRF9VTkxPQ0tfSVJRPXkK
IyBDT05GSUdfSU5MSU5FX1JFQURfVU5MT0NLX0lSUVJFU1RPUkUgaXMgbm90IHNldAojIENPTkZJ
R19JTkxJTkVfV1JJVEVfVFJZTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOTElORV9XUklURV9M
T0NLIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5MSU5FX1dSSVRFX0xPQ0tfQkggaXMgbm90IHNldAoj
IENPTkZJR19JTkxJTkVfV1JJVEVfTE9DS19JUlEgaXMgbm90IHNldAojIENPTkZJR19JTkxJTkVf
V1JJVEVfTE9DS19JUlFTQVZFIGlzIG5vdCBzZXQKQ09ORklHX0lOTElORV9XUklURV9VTkxPQ0s9
eQojIENPTkZJR19JTkxJTkVfV1JJVEVfVU5MT0NLX0JIIGlzIG5vdCBzZXQKQ09ORklHX0lOTElO
RV9XUklURV9VTkxPQ0tfSVJRPXkKIyBDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DS19JUlFSRVNU
T1JFIGlzIG5vdCBzZXQKQ09ORklHX01VVEVYX1NQSU5fT05fT1dORVI9eQpDT05GSUdfRlJFRVpF
Uj15CgojCiMgUHJvY2Vzc29yIHR5cGUgYW5kIGZlYXR1cmVzCiMKQ09ORklHX1RJQ0tfT05FU0hP
VD15CkNPTkZJR19OT19IWj15CkNPTkZJR19ISUdIX1JFU19USU1FUlM9eQpDT05GSUdfR0VORVJJ
Q19DTE9DS0VWRU5UU19CVUlMRD15CkNPTkZJR19TTVA9eQojIENPTkZJR19YODZfWDJBUElDIGlz
IG5vdCBzZXQKQ09ORklHX1NQQVJTRV9JUlE9eQpDT05GSUdfWDg2X01QUEFSU0U9eQojIENPTkZJ
R19YODZfRVhURU5ERURfUExBVEZPUk0gaXMgbm90IHNldApDT05GSUdfWDg2X1NVUFBPUlRTX01F
TU9SWV9GQUlMVVJFPXkKQ09ORklHX1NDSEVEX09NSVRfRlJBTUVfUE9JTlRFUj15CiMgQ09ORklH
X1BBUkFWSVJUX0dVRVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVNVEVTVCBpcyBub3Qgc2V0CiMg
Q09ORklHX00zODYgaXMgbm90IHNldAojIENPTkZJR19NNDg2IGlzIG5vdCBzZXQKIyBDT05GSUdf
TTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX001ODZUU0MgaXMgbm90IHNldAojIENPTkZJR19NNTg2
TU1YIGlzIG5vdCBzZXQKIyBDT05GSUdfTTY4NiBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVN
SUkgaXMgbm90IHNldAojIENPTkZJR19NUEVOVElVTUlJSSBpcyBub3Qgc2V0CiMgQ09ORklHX01Q
RU5USVVNTSBpcyBub3Qgc2V0CiMgQ09ORklHX01QRU5USVVNNCBpcyBub3Qgc2V0CiMgQ09ORklH
X01LNiBpcyBub3Qgc2V0CiMgQ09ORklHX01LNyBpcyBub3Qgc2V0CiMgQ09ORklHX01LOCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01DUlVTT0UgaXMgbm90IHNldAojIENPTkZJR19NRUZGSUNFT04gaXMg
bm90IHNldAojIENPTkZJR19NV0lOQ0hJUEM2IGlzIG5vdCBzZXQKIyBDT05GSUdfTVdJTkNISVAz
RCBpcyBub3Qgc2V0CiMgQ09ORklHX01HRU9ERUdYMSBpcyBub3Qgc2V0CiMgQ09ORklHX01HRU9E
RV9MWCBpcyBub3Qgc2V0CiMgQ09ORklHX01DWVJJWElJSSBpcyBub3Qgc2V0CiMgQ09ORklHX01W
SUFDM18yIGlzIG5vdCBzZXQKIyBDT05GSUdfTVZJQUM3IGlzIG5vdCBzZXQKIyBDT05GSUdfTVBT
QyBpcyBub3Qgc2V0CkNPTkZJR19NQ09SRTI9eQojIENPTkZJR19NQVRPTSBpcyBub3Qgc2V0CiMg
Q09ORklHX0dFTkVSSUNfQ1BVIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9DUFU9eQpDT05GSUdfWDg2
X0lOVEVSTk9ERV9DQUNIRV9TSElGVD02CkNPTkZJR19YODZfQ01QWENIRz15CkNPTkZJR19YODZf
TDFfQ0FDSEVfU0hJRlQ9NgpDT05GSUdfWDg2X1dQX1dPUktTX09LPXkKQ09ORklHX1g4Nl9JTlRF
TF9VU0VSQ09QWT15CkNPTkZJR19YODZfVVNFX1BQUk9fQ0hFQ0tTVU09eQpDT05GSUdfWDg2X1A2
X05PUD15CkNPTkZJR19YODZfVFNDPXkKQ09ORklHX1g4Nl9DTVBYQ0hHNjQ9eQpDT05GSUdfWDg2
X0NNT1Y9eQpDT05GSUdfWDg2X01JTklNVU1fQ1BVX0ZBTUlMWT02NApDT05GSUdfWDg2X0RFQlVH
Q1RMTVNSPXkKQ09ORklHX0NQVV9TVVBfSU5URUw9eQpDT05GSUdfQ1BVX1NVUF9BTUQ9eQpDT05G
SUdfQ1BVX1NVUF9DRU5UQVVSPXkKIyBDT05GSUdfWDg2X0RTIGlzIG5vdCBzZXQKQ09ORklHX0hQ
RVRfVElNRVI9eQpDT05GSUdfSFBFVF9FTVVMQVRFX1JUQz15CkNPTkZJR19ETUk9eQpDT05GSUdf
R0FSVF9JT01NVT15CiMgQ09ORklHX0NBTEdBUllfSU9NTVUgaXMgbm90IHNldAojIENPTkZJR19B
TURfSU9NTVUgaXMgbm90IHNldApDT05GSUdfU1dJT1RMQj15CkNPTkZJR19JT01NVV9IRUxQRVI9
eQojIENPTkZJR19JT01NVV9BUEkgaXMgbm90IHNldAojIENPTkZJR19NQVhTTVAgaXMgbm90IHNl
dApDT05GSUdfTlJfQ1BVUz04CkNPTkZJR19TQ0hFRF9TTVQ9eQpDT05GSUdfU0NIRURfTUM9eQoj
IENPTkZJR19QUkVFTVBUX05PTkUgaXMgbm90IHNldApDT05GSUdfUFJFRU1QVF9WT0xVTlRBUlk9
eQojIENPTkZJR19QUkVFTVBUIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9MT0NBTF9BUElDPXkKQ09O
RklHX1g4Nl9JT19BUElDPXkKQ09ORklHX1g4Nl9SRVJPVVRFX0ZPUl9CUk9LRU5fQk9PVF9JUlFT
PXkKQ09ORklHX1g4Nl9NQ0U9eQpDT05GSUdfWDg2X01DRV9JTlRFTD15CiMgQ09ORklHX1g4Nl9N
Q0VfQU1EIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9NQ0VfVEhSRVNIT0xEPXkKQ09ORklHX1g4Nl9N
Q0VfSU5KRUNUPW0KQ09ORklHX1g4Nl9USEVSTUFMX1ZFQ1RPUj15CiMgQ09ORklHX0k4SyBpcyBu
b3Qgc2V0CkNPTkZJR19NSUNST0NPREU9bQpDT05GSUdfTUlDUk9DT0RFX0lOVEVMPXkKIyBDT05G
SUdfTUlDUk9DT0RFX0FNRCBpcyBub3Qgc2V0CkNPTkZJR19NSUNST0NPREVfT0xEX0lOVEVSRkFD
RT15CkNPTkZJR19YODZfTVNSPW0KQ09ORklHX1g4Nl9DUFVJRD1tCkNPTkZJR19BUkNIX1BIWVNf
QUREUl9UXzY0QklUPXkKQ09ORklHX0RJUkVDVF9HQlBBR0VTPXkKIyBDT05GSUdfTlVNQSBpcyBu
b3Qgc2V0CkNPTkZJR19BUkNIX1NQQVJTRU1FTV9ERUZBVUxUPXkKQ09ORklHX0FSQ0hfU1BBUlNF
TUVNX0VOQUJMRT15CkNPTkZJR19BUkNIX1NFTEVDVF9NRU1PUllfTU9ERUw9eQpDT05GSUdfSUxM
RUdBTF9QT0lOVEVSX1ZBTFVFPTB4ZGVhZDAwMDAwMDAwMDAwMApDT05GSUdfU0VMRUNUX01FTU9S
WV9NT0RFTD15CiMgQ09ORklHX0ZMQVRNRU1fTUFOVUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfRElT
Q09OVElHTUVNX01BTlVBTCBpcyBub3Qgc2V0CkNPTkZJR19TUEFSU0VNRU1fTUFOVUFMPXkKQ09O
RklHX1NQQVJTRU1FTT15CkNPTkZJR19IQVZFX01FTU9SWV9QUkVTRU5UPXkKQ09ORklHX1NQQVJT
RU1FTV9FWFRSRU1FPXkKQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQX0VOQUJMRT15CkNPTkZJR19T
UEFSU0VNRU1fVk1FTU1BUD15CiMgQ09ORklHX01FTU9SWV9IT1RQTFVHIGlzIG5vdCBzZXQKQ09O
RklHX1BBR0VGTEFHU19FWFRFTkRFRD15CkNPTkZJR19TUExJVF9QVExPQ0tfQ1BVUz00CkNPTkZJ
R19QSFlTX0FERFJfVF82NEJJVD15CkNPTkZJR19aT05FX0RNQV9GTEFHPTEKQ09ORklHX0JPVU5D
RT15CkNPTkZJR19WSVJUX1RPX0JVUz15CiMgQ09ORklHX0tTTSBpcyBub3Qgc2V0CkNPTkZJR19E
RUZBVUxUX01NQVBfTUlOX0FERFI9NjU1MzYKQ09ORklHX0FSQ0hfU1VQUE9SVFNfTUVNT1JZX0ZB
SUxVUkU9eQojIENPTkZJR19NRU1PUllfRkFJTFVSRSBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9D
SEVDS19CSU9TX0NPUlJVUFRJT04gaXMgbm90IHNldAojIENPTkZJR19YODZfUkVTRVJWRV9MT1df
NjRLIGlzIG5vdCBzZXQKQ09ORklHX01UUlI9eQpDT05GSUdfTVRSUl9TQU5JVElaRVI9eQpDT05G
SUdfTVRSUl9TQU5JVElaRVJfRU5BQkxFX0RFRkFVTFQ9MApDT05GSUdfTVRSUl9TQU5JVElaRVJf
U1BBUkVfUkVHX05SX0RFRkFVTFQ9MQpDT05GSUdfWDg2X1BBVD15CkNPTkZJR19BUkNIX1VTRVNf
UEdfVU5DQUNIRUQ9eQojIENPTkZJR19FRkkgaXMgbm90IHNldApDT05GSUdfU0VDQ09NUD15CkNP
TkZJR19DQ19TVEFDS1BST1RFQ1RPUj15CiMgQ09ORklHX0haXzEwMCBpcyBub3Qgc2V0CiMgQ09O
RklHX0haXzI1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0haXzMwMCBpcyBub3Qgc2V0CkNPTkZJR19I
Wl8xMDAwPXkKQ09ORklHX0haPTEwMDAKQ09ORklHX1NDSEVEX0hSVElDSz15CiMgQ09ORklHX0tF
WEVDIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JBU0hfRFVNUCBpcyBub3Qgc2V0CkNPTkZJR19QSFlT
SUNBTF9TVEFSVD0weDEwMDAwMDAKIyBDT05GSUdfUkVMT0NBVEFCTEUgaXMgbm90IHNldApDT05G
SUdfUEhZU0lDQUxfQUxJR049MHgxMDAwMDAwCkNPTkZJR19IT1RQTFVHX0NQVT15CiMgQ09ORklH
X0NPTVBBVF9WRFNPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ01ETElORV9CT09MIGlzIG5vdCBzZXQK
Q09ORklHX0FSQ0hfRU5BQkxFX01FTU9SWV9IT1RQTFVHPXkKCiMKIyBQb3dlciBtYW5hZ2VtZW50
IGFuZCBBQ1BJIG9wdGlvbnMKIwpDT05GSUdfQVJDSF9ISUJFUk5BVElPTl9IRUFERVI9eQpDT05G
SUdfUE09eQojIENPTkZJR19QTV9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19QTV9TTEVFUF9TTVA9
eQpDT05GSUdfUE1fU0xFRVA9eQpDT05GSUdfU1VTUEVORD15CkNPTkZJR19TVVNQRU5EX0ZSRUVa
RVI9eQpDT05GSUdfSElCRVJOQVRJT05fTlZTPXkKQ09ORklHX0hJQkVSTkFUSU9OPXkKQ09ORklH
X1BNX1NURF9QQVJUSVRJT049Ii9kZXYvc2RhNSIKQ09ORklHX1BNX1JVTlRJTUU9eQpDT05GSUdf
QUNQST15CkNPTkZJR19BQ1BJX1NMRUVQPXkKIyBDT05GSUdfQUNQSV9QUk9DRlMgaXMgbm90IHNl
dAojIENPTkZJR19BQ1BJX1BST0NGU19QT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfUE9X
RVJfTUVURVIgaXMgbm90IHNldApDT05GSUdfQUNQSV9TWVNGU19QT1dFUj15CkNPTkZJR19BQ1BJ
X1BST0NfRVZFTlQ9eQpDT05GSUdfQUNQSV9BQz15CiMgQ09ORklHX0FDUElfQkFUVEVSWSBpcyBu
b3Qgc2V0CkNPTkZJR19BQ1BJX0JVVFRPTj15CkNPTkZJR19BQ1BJX0ZBTj15CkNPTkZJR19BQ1BJ
X0RPQ0s9eQpDT05GSUdfQUNQSV9QUk9DRVNTT1I9eQpDT05GSUdfQUNQSV9IT1RQTFVHX0NQVT15
CiMgQ09ORklHX0FDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1IgaXMgbm90IHNldApDT05GSUdfQUNQ
SV9USEVSTUFMPXkKIyBDT05GSUdfQUNQSV9DVVNUT01fRFNEVCBpcyBub3Qgc2V0CkNPTkZJR19B
Q1BJX0JMQUNLTElTVF9ZRUFSPTAKIyBDT05GSUdfQUNQSV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09O
RklHX0FDUElfUENJX1NMT1QgaXMgbm90IHNldApDT05GSUdfWDg2X1BNX1RJTUVSPXkKQ09ORklH
X0FDUElfQ09OVEFJTkVSPXkKIyBDT05GSUdfQUNQSV9TQlMgaXMgbm90IHNldAojIENPTkZJR19T
RkkgaXMgbm90IHNldAoKIwojIENQVSBGcmVxdWVuY3kgc2NhbGluZwojCkNPTkZJR19DUFVfRlJF
UT15CkNPTkZJR19DUFVfRlJFUV9UQUJMRT15CiMgQ09ORklHX0NQVV9GUkVRX0RFQlVHIGlzIG5v
dCBzZXQKQ09ORklHX0NQVV9GUkVRX1NUQVQ9eQojIENPTkZJR19DUFVfRlJFUV9TVEFUX0RFVEFJ
TFMgaXMgbm90IHNldAojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QRVJGT1JNQU5DRSBp
cyBub3Qgc2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1BPV0VSU0FWRSBpcyBub3Qg
c2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1VTRVJTUEFDRSBpcyBub3Qgc2V0CkNP
TkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9PTkRFTUFORD15CiMgQ09ORklHX0NQVV9GUkVRX0RF
RkFVTFRfR09WX0NPTlNFUlZBVElWRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9HT1ZfUEVS
Rk9STUFOQ0U9eQojIENPTkZJR19DUFVfRlJFUV9HT1ZfUE9XRVJTQVZFIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1BVX0ZSRVFfR09WX1VTRVJTUEFDRSBpcyBub3Qgc2V0CkNPTkZJR19DUFVfRlJFUV9H
T1ZfT05ERU1BTkQ9eQojIENPTkZJR19DUFVfRlJFUV9HT1ZfQ09OU0VSVkFUSVZFIGlzIG5vdCBz
ZXQKCiMKIyBDUFVGcmVxIHByb2Nlc3NvciBkcml2ZXJzCiMKQ09ORklHX1g4Nl9BQ1BJX0NQVUZS
RVE9bQojIENPTkZJR19YODZfUE9XRVJOT1dfSzggaXMgbm90IHNldAojIENPTkZJR19YODZfU1BF
RURTVEVQX0NFTlRSSU5PIGlzIG5vdCBzZXQKIyBDT05GSUdfWDg2X1A0X0NMT0NLTU9EIGlzIG5v
dCBzZXQKCiMKIyBzaGFyZWQgb3B0aW9ucwojCiMgQ09ORklHX1g4Nl9TUEVFRFNURVBfTElCIGlz
IG5vdCBzZXQKQ09ORklHX0NQVV9JRExFPXkKQ09ORklHX0NQVV9JRExFX0dPVl9MQURERVI9eQpD
T05GSUdfQ1BVX0lETEVfR09WX01FTlU9eQoKIwojIE1lbW9yeSBwb3dlciBzYXZpbmdzCiMKIyBD
T05GSUdfSTczMDBfSURMRSBpcyBub3Qgc2V0CgojCiMgQnVzIG9wdGlvbnMgKFBDSSBldGMuKQoj
CkNPTkZJR19QQ0k9eQpDT05GSUdfUENJX0RJUkVDVD15CkNPTkZJR19QQ0lfTU1DT05GSUc9eQpD
T05GSUdfUENJX0RPTUFJTlM9eQojIENPTkZJR19ETUFSIGlzIG5vdCBzZXQKQ09ORklHX0lOVFJf
UkVNQVA9eQpDT05GSUdfUENJRVBPUlRCVVM9eQpDT05GSUdfUENJRUFFUj15CiMgQ09ORklHX1BD
SUVfRUNSQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSUVBRVJfSU5KRUNUIGlzIG5vdCBzZXQKQ09O
RklHX1BDSUVBU1BNPXkKIyBDT05GSUdfUENJRUFTUE1fREVCVUcgaXMgbm90IHNldApDT05GSUdf
QVJDSF9TVVBQT1JUU19NU0k9eQpDT05GSUdfUENJX01TST15CiMgQ09ORklHX1BDSV9MRUdBQ1kg
aXMgbm90IHNldAojIENPTkZJR19QQ0lfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19QQ0lfU1RV
QiBpcyBub3Qgc2V0CiMgQ09ORklHX0hUX0lSUSBpcyBub3Qgc2V0CkNPTkZJR19QQ0lfSU9WPXkK
Q09ORklHX1BDSV9JT0FQSUM9eQpDT05GSUdfSVNBX0RNQV9BUEk9eQpDT05GSUdfSzhfTkI9eQoj
IENPTkZJR19QQ0NBUkQgaXMgbm90IHNldAojIENPTkZJR19IT1RQTFVHX1BDSSBpcyBub3Qgc2V0
CgojCiMgRXhlY3V0YWJsZSBmaWxlIGZvcm1hdHMgLyBFbXVsYXRpb25zCiMKQ09ORklHX0JJTkZN
VF9FTEY9eQpDT05GSUdfQ09NUEFUX0JJTkZNVF9FTEY9eQojIENPTkZJR19DT1JFX0RVTVBfREVG
QVVMVF9FTEZfSEVBREVSUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hBVkVfQU9VVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0JJTkZNVF9NSVNDIGlzIG5vdCBzZXQKQ09ORklHX0lBMzJfRU1VTEFUSU9OPXkK
Q09ORklHX0lBMzJfQU9VVD15CkNPTkZJR19DT01QQVQ9eQpDT05GSUdfQ09NUEFUX0ZPUl9VNjRf
QUxJR05NRU5UPXkKQ09ORklHX1NZU1ZJUENfQ09NUEFUPXkKQ09ORklHX05FVD15CgojCiMgTmV0
d29ya2luZyBvcHRpb25zCiMKQ09ORklHX1BBQ0tFVD15CkNPTkZJR19QQUNLRVRfTU1BUD15CkNP
TkZJR19VTklYPXkKIyBDT05GSUdfTkVUX0tFWSBpcyBub3Qgc2V0CkNPTkZJR19JTkVUPXkKIyBD
T05GSUdfSVBfTVVMVElDQVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBfQURWQU5DRURfUk9VVEVS
IGlzIG5vdCBzZXQKQ09ORklHX0lQX0ZJQl9IQVNIPXkKIyBDT05GSUdfSVBfUE5QIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX0lQSVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfSVBHUkUgaXMgbm90
IHNldAojIENPTkZJR19BUlBEIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lOX0NPT0tJRVMgaXMgbm90
IHNldAojIENPTkZJR19JTkVUX0FIIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5FVF9FU1AgaXMgbm90
IHNldAojIENPTkZJR19JTkVUX0lQQ09NUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfWEZSTV9U
VU5ORUwgaXMgbm90IHNldAojIENPTkZJR19JTkVUX1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklH
X0lORVRfWEZSTV9NT0RFX1RSQU5TUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfWEZSTV9N
T0RFX1RVTk5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfWEZSTV9NT0RFX0JFRVQgaXMgbm90
IHNldAojIENPTkZJR19JTkVUX0xSTyBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfRElBRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RDUF9DT05HX0FEVkFOQ0VEIGlzIG5vdCBzZXQKQ09ORklHX1RDUF9D
T05HX0NVQklDPXkKQ09ORklHX0RFRkFVTFRfVENQX0NPTkc9ImN1YmljIgojIENPTkZJR19UQ1Bf
TUQ1U0lHIGlzIG5vdCBzZXQKIyBDT05GSUdfSVBWNiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVFdP
UktfU0VDTUFSSyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEZJTFRFUiBpcyBub3Qgc2V0CiMgQ09O
RklHX0lQX0RDQ1AgaXMgbm90IHNldAojIENPTkZJR19JUF9TQ1RQIGlzIG5vdCBzZXQKIyBDT05G
SUdfUkRTIGlzIG5vdCBzZXQKIyBDT05GSUdfVElQQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FUTSBp
cyBub3Qgc2V0CiMgQ09ORklHX0JSSURHRSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9EU0EgaXMg
bm90IHNldAojIENPTkZJR19WTEFOXzgwMjFRIGlzIG5vdCBzZXQKIyBDT05GSUdfREVDTkVUIGlz
IG5vdCBzZXQKIyBDT05GSUdfTExDMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0FUQUxLIGlzIG5vdCBzZXQKIyBDT05GSUdfWDI1IGlzIG5vdCBzZXQKIyBDT05G
SUdfTEFQQiBpcyBub3Qgc2V0CiMgQ09ORklHX0VDT05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX1dB
Tl9ST1VURVIgaXMgbm90IHNldAojIENPTkZJR19QSE9ORVQgaXMgbm90IHNldAojIENPTkZJR19J
RUVFODAyMTU0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSEVEIGlzIG5vdCBzZXQKIyBDT05G
SUdfRENCIGlzIG5vdCBzZXQKCiMKIyBOZXR3b3JrIHRlc3RpbmcKIwojIENPTkZJR19ORVRfUEtU
R0VOIGlzIG5vdCBzZXQKIyBDT05GSUdfSEFNUkFESU8gaXMgbm90IHNldAojIENPTkZJR19DQU4g
aXMgbm90IHNldAojIENPTkZJR19JUkRBIGlzIG5vdCBzZXQKIyBDT05GSUdfQlQgaXMgbm90IHNl
dAojIENPTkZJR19BRl9SWFJQQyBpcyBub3Qgc2V0CiMgQ09ORklHX1dJUkVMRVNTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfV0lNQVggaXMgbm90IHNldAojIENPTkZJR19SRktJTEwgaXMgbm90IHNldAoj
IENPTkZJR19ORVRfOVAgaXMgbm90IHNldAoKIwojIERldmljZSBEcml2ZXJzCiMKCiMKIyBHZW5l
cmljIERyaXZlciBPcHRpb25zCiMKQ09ORklHX1VFVkVOVF9IRUxQRVJfUEFUSD0iIgpDT05GSUdf
REVWVE1QRlM9eQojIENPTkZJR19ERVZUTVBGU19NT1VOVCBpcyBub3Qgc2V0CkNPTkZJR19TVEFO
REFMT05FPXkKQ09ORklHX1BSRVZFTlRfRklSTVdBUkVfQlVJTEQ9eQpDT05GSUdfRldfTE9BREVS
PXkKIyBDT05GSUdfRklSTVdBUkVfSU5fS0VSTkVMIGlzIG5vdCBzZXQKQ09ORklHX0VYVFJBX0ZJ
Uk1XQVJFPSIiCiMgQ09ORklHX0RFQlVHX0RSSVZFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X0RFVlJFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU19IWVBFUlZJU09SIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ09OTkVDVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTVREIGlzIG5vdCBzZXQKIyBDT05G
SUdfUEFSUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19QTlA9eQpDT05GSUdfUE5QX0RFQlVHX01FU1NB
R0VTPXkKCiMKIyBQcm90b2NvbHMKIwpDT05GSUdfUE5QQUNQST15CkNPTkZJR19CTEtfREVWPXkK
IyBDT05GSUdfQkxLX0RFVl9GRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19DUFFfREEgaXMgbm90
IHNldAojIENPTkZJR19CTEtfQ1BRX0NJU1NfREEgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVW
X0RBQzk2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfVU1FTSBpcyBub3Qgc2V0CiMgQ09O
RklHX0JMS19ERVZfQ09XX0NPTU1PTiBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0xPT1A9bQoj
IENPTkZJR19CTEtfREVWX0NSWVBUT0xPT1AgaXMgbm90IHNldAoKIwojIERSQkQgZGlzYWJsZWQg
YmVjYXVzZSBQUk9DX0ZTLCBJTkVUIG9yIENPTk5FQ1RPUiBub3Qgc2VsZWN0ZWQKIwojIENPTkZJ
R19CTEtfREVWX05CRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfU1g4IGlzIG5vdCBzZXQK
IyBDT05GSUdfQkxLX0RFVl9VQiBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfUkFNIGlzIG5v
dCBzZXQKIyBDT05GSUdfQ0RST01fUEtUQ0RWRCBpcyBub3Qgc2V0CiMgQ09ORklHX0FUQV9PVkVS
X0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfSEQgaXMgbm90IHNldApDT05GSUdfTUlT
Q19ERVZJQ0VTPXkKIyBDT05GSUdfQUQ1MjVYX0RQT1QgaXMgbm90IHNldAojIENPTkZJR19JQk1f
QVNNIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhBTlRPTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NHSV9J
T0M0IGlzIG5vdCBzZXQKIyBDT05GSUdfVElGTV9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSUNT
OTMyUzQwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0VOQ0xPU1VSRV9TRVJWSUNFUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0NTNTUzNV9NRkdQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0hQX0lMTyBpcyBub3Qg
c2V0CiMgQ09ORklHX0lTTDI5MDAzIGlzIG5vdCBzZXQKIyBDT05GSUdfRFMxNjgyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQzJQT1JUIGlzIG5vdCBzZXQKCiMKIyBFRVBST00gc3VwcG9ydAojCiMgQ09O
RklHX0VFUFJPTV9BVDI0IGlzIG5vdCBzZXQKIyBDT05GSUdfRUVQUk9NX0xFR0FDWSBpcyBub3Qg
c2V0CiMgQ09ORklHX0VFUFJPTV9NQVg2ODc1IGlzIG5vdCBzZXQKIyBDT05GSUdfRUVQUk9NXzkz
Q1g2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0I3MTBfQ09SRSBpcyBub3Qgc2V0CkNPTkZJR19IQVZF
X0lERT15CiMgQ09ORklHX0lERSBpcyBub3Qgc2V0CgojCiMgU0NTSSBkZXZpY2Ugc3VwcG9ydAoj
CiMgQ09ORklHX1JBSURfQVRUUlMgaXMgbm90IHNldApDT05GSUdfU0NTST15CkNPTkZJR19TQ1NJ
X0RNQT15CkNPTkZJR19TQ1NJX1RHVD1tCiMgQ09ORklHX1NDU0lfTkVUTElOSyBpcyBub3Qgc2V0
CiMgQ09ORklHX1NDU0lfUFJPQ19GUyBpcyBub3Qgc2V0CgojCiMgU0NTSSBzdXBwb3J0IHR5cGUg
KGRpc2ssIHRhcGUsIENELVJPTSkKIwpDT05GSUdfQkxLX0RFVl9TRD15CiMgQ09ORklHX0NIUl9E
RVZfU1QgaXMgbm90IHNldAojIENPTkZJR19DSFJfREVWX09TU1QgaXMgbm90IHNldApDT05GSUdf
QkxLX0RFVl9TUj1tCkNPTkZJR19CTEtfREVWX1NSX1ZFTkRPUj15CkNPTkZJR19DSFJfREVWX1NH
PW0KIyBDT05GSUdfQ0hSX0RFVl9TQ0ggaXMgbm90IHNldApDT05GSUdfU0NTSV9NVUxUSV9MVU49
eQpDT05GSUdfU0NTSV9DT05TVEFOVFM9eQojIENPTkZJR19TQ1NJX0xPR0dJTkcgaXMgbm90IHNl
dAojIENPTkZJR19TQ1NJX1NDQU5fQVNZTkMgaXMgbm90IHNldApDT05GSUdfU0NTSV9XQUlUX1ND
QU49bQoKIwojIFNDU0kgVHJhbnNwb3J0cwojCiMgQ09ORklHX1NDU0lfU1BJX0FUVFJTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9GQ19BVFRSUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSVND
U0lfQVRUUlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NBU19BVFRSUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NDU0lfU0FTX0xJQlNBUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfU1JQX0FUVFJT
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9MT1dMRVZFTCBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
U0lfREggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX09TRF9JTklUSUFUT1IgaXMgbm90IHNldApD
T05GSUdfQVRBPXkKIyBDT05GSUdfQVRBX05PTlNUQU5EQVJEIGlzIG5vdCBzZXQKQ09ORklHX0FU
QV9WRVJCT1NFX0VSUk9SPXkKIyBDT05GSUdfQVRBX0FDUEkgaXMgbm90IHNldAojIENPTkZJR19T
QVRBX1BNUCBpcyBub3Qgc2V0CkNPTkZJR19TQVRBX0FIQ0k9eQojIENPTkZJR19TQVRBX1NJTDI0
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBX1NGRiBpcyBub3Qgc2V0CiMgQ09ORklHX01EIGlzIG5v
dCBzZXQKIyBDT05GSUdfRlVTSU9OIGlzIG5vdCBzZXQKCiMKIyBJRUVFIDEzOTQgKEZpcmVXaXJl
KSBzdXBwb3J0CiMKCiMKIyBZb3UgY2FuIGVuYWJsZSBvbmUgb3IgYm90aCBGaXJlV2lyZSBkcml2
ZXIgc3RhY2tzLgojCgojCiMgVGhlIG5ld2VyIHN0YWNrIGlzIHJlY29tbWVuZGVkLgojCiMgQ09O
RklHX0ZJUkVXSVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfSUVFRTEzOTQgaXMgbm90IHNldAojIENP
TkZJR19JMk8gaXMgbm90IHNldAojIENPTkZJR19NQUNJTlRPU0hfRFJJVkVSUyBpcyBub3Qgc2V0
CkNPTkZJR19ORVRERVZJQ0VTPXkKIyBDT05GSUdfRFVNTVkgaXMgbm90IHNldAojIENPTkZJR19C
T05ESU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFDVkxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0VR
VUFMSVpFUiBpcyBub3Qgc2V0CiMgQ09ORklHX1RVTiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZFVEgg
aXMgbm90IHNldAojIENPTkZJR19ORVRfU0IxMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQVJDTkVU
IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0VUSEVSTkVUIGlzIG5vdCBzZXQKQ09ORklHX01JST1t
CkNPTkZJR19ORVRERVZfMTAwMD15CiMgQ09ORklHX0FDRU5JQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0RMMksgaXMgbm90IHNldAojIENPTkZJR19FMTAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0UxMDAw
RSBpcyBub3Qgc2V0CiMgQ09ORklHX0lQMTAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0lHQiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lHQlZGIGlzIG5vdCBzZXQKIyBDT05GSUdfTlM4MzgyMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0hBTUFDSEkgaXMgbm90IHNldAojIENPTkZJR19ZRUxMT1dGSU4gaXMgbm90
IHNldApDT05GSUdfUjgxNjk9bQojIENPTkZJR19TSVMxOTAgaXMgbm90IHNldAojIENPTkZJR19T
S0dFIGlzIG5vdCBzZXQKIyBDT05GSUdfU0tZMiBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJQV9WRUxP
Q0lUWSBpcyBub3Qgc2V0CiMgQ09ORklHX1RJR09OMyBpcyBub3Qgc2V0CiMgQ09ORklHX0JOWDIg
aXMgbm90IHNldAojIENPTkZJR19DTklDIGlzIG5vdCBzZXQKIyBDT05GSUdfUUxBM1hYWCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FUTDEgaXMgbm90IHNldAojIENPTkZJR19BVEwxRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FUTDFDIGlzIG5vdCBzZXQKIyBDT05GSUdfSk1FIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUREVWXzEwMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVFIgaXMgbm90IHNldAojIENPTkZJ
R19XTEFOIGlzIG5vdCBzZXQKCiMKIyBFbmFibGUgV2lNQVggKE5ldHdvcmtpbmcgb3B0aW9ucykg
dG8gc2VlIHRoZSBXaU1BWCBkcml2ZXJzCiMKCiMKIyBVU0IgTmV0d29yayBBZGFwdGVycwojCiMg
Q09ORklHX1VTQl9DQVRDIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0tBV0VUSCBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9QRUdBU1VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1JUTDgxNTAgaXMg
bm90IHNldAojIENPTkZJR19VU0JfVVNCTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfV0FOIGlzIG5v
dCBzZXQKIyBDT05GSUdfRkRESSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJUFBJIGlzIG5vdCBzZXQK
IyBDT05GSUdfUFBQIGlzIG5vdCBzZXQKIyBDT05GSUdfU0xJUCBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9GQyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVENPTlNPTEUgaXMgbm90IHNldAojIENPTkZJ
R19ORVRQT0xMIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUiBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZNWE5FVDMgaXMgbm90IHNldAojIENPTkZJR19JU0ROIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEhPTkUgaXMgbm90IHNldAoKIwojIElucHV0IGRldmljZSBzdXBwb3J0CiMKQ09O
RklHX0lOUFVUPXkKIyBDT05GSUdfSU5QVVRfRkZfTUVNTEVTUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOUFVUX1BPTExERVYgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9TUEFSU0VLTUFQIGlzIG5v
dCBzZXQKCiMKIyBVc2VybGFuZCBpbnRlcmZhY2VzCiMKQ09ORklHX0lOUFVUX01PVVNFREVWPXkK
Q09ORklHX0lOUFVUX01PVVNFREVWX1BTQVVYPXkKQ09ORklHX0lOUFVUX01PVVNFREVWX1NDUkVF
Tl9YPTEyODAKQ09ORklHX0lOUFVUX01PVVNFREVWX1NDUkVFTl9ZPTEwMjQKIyBDT05GSUdfSU5Q
VVRfSk9ZREVWIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVUX0VWREVWPW0KIyBDT05GSUdfSU5QVVRf
RVZCVUcgaXMgbm90IHNldAoKIwojIElucHV0IERldmljZSBEcml2ZXJzCiMKQ09ORklHX0lOUFVU
X0tFWUJPQVJEPXkKIyBDT05GSUdfS0VZQk9BUkRfQURQNTU4OCBpcyBub3Qgc2V0CkNPTkZJR19L
RVlCT0FSRF9BVEtCRD15CiMgQ09ORklHX1FUMjE2MCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJP
QVJEX0xLS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFYNzM1OSBpcyBub3Qgc2V0
CiMgQ09ORklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX09Q
RU5DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NUT1dBV0FZIGlzIG5vdCBzZXQK
IyBDT05GSUdfS0VZQk9BUkRfU1VOS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfWFRL
QkQgaXMgbm90IHNldApDT05GSUdfSU5QVVRfTU9VU0U9eQojIENPTkZJR19NT1VTRV9QUzIgaXMg
bm90IHNldAojIENPTkZJR19NT1VTRV9TRVJJQUwgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9B
UFBMRVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfQkNNNTk3NCBpcyBub3Qgc2V0CiMg
Q09ORklHX01PVVNFX1ZTWFhYQUEgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9TWU5BUFRJQ1Nf
STJDIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfSk9ZU1RJQ0sgaXMgbm90IHNldAojIENPTkZJ
R19JTlBVVF9UQUJMRVQgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UT1VDSFNDUkVFTiBpcyBu
b3Qgc2V0CkNPTkZJR19JTlBVVF9NSVNDPXkKQ09ORklHX0lOUFVUX1BDU1BLUj1tCiMgQ09ORklH
X0lOUFVUX0FUTEFTX0JUTlMgaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9BVElfUkVNT1RFIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVRJX1JFTU9URTIgaXMgbm90IHNldAojIENPTkZJR19J
TlBVVF9LRVlTUEFOX1JFTU9URSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1BPV0VSTUFURSBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1lFQUxJTksgaXMgbm90IHNldAojIENPTkZJR19JTlBV
VF9DTTEwOSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1VJTlBVVCBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX1dJTkJPTkRfQ0lSIGlzIG5vdCBzZXQKCiMKIyBIYXJkd2FyZSBJL08gcG9ydHMK
IwpDT05GSUdfU0VSSU89eQpDT05GSUdfU0VSSU9fSTgwNDI9eQojIENPTkZJR19TRVJJT19TRVJQ
T1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fQ1Q4MkM3MTAgaXMgbm90IHNldAojIENPTkZJ
R19TRVJJT19QQ0lQUzIgaXMgbm90IHNldApDT05GSUdfU0VSSU9fTElCUFMyPXkKIyBDT05GSUdf
U0VSSU9fUkFXIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fQUxURVJBX1BTMiBpcyBub3Qgc2V0
CiMgQ09ORklHX0dBTUVQT1JUIGlzIG5vdCBzZXQKCiMKIyBDaGFyYWN0ZXIgZGV2aWNlcwojCkNP
TkZJR19WVD15CkNPTkZJR19DT05TT0xFX1RSQU5TTEFUSU9OUz15CkNPTkZJR19WVF9DT05TT0xF
PXkKQ09ORklHX0hXX0NPTlNPTEU9eQojIENPTkZJR19WVF9IV19DT05TT0xFX0JJTkRJTkcgaXMg
bm90IHNldAojIENPTkZJR19ERVZLTUVNIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX05PTlNU
QU5EQVJEIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9aT01JIGlzIG5vdCBzZXQKCiMKIyBTZXJpYWwg
ZHJpdmVycwojCiMgQ09ORklHX1NFUklBTF84MjUwIGlzIG5vdCBzZXQKQ09ORklHX0ZJWF9FQVJM
WUNPTl9NRU09eQoKIwojIE5vbi04MjUwIHNlcmlhbCBwb3J0IHN1cHBvcnQKIwojIENPTkZJR19T
RVJJQUxfSlNNIGlzIG5vdCBzZXQKQ09ORklHX1VOSVg5OF9QVFlTPXkKIyBDT05GSUdfREVWUFRT
X01VTFRJUExFX0lOU1RBTkNFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0xFR0FDWV9QVFlTIGlzIG5v
dCBzZXQKIyBDT05GSUdfSVBNSV9IQU5ETEVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9N
IGlzIG5vdCBzZXQKIyBDT05GSUdfTlZSQU0gaXMgbm90IHNldAojIENPTkZJR19SMzk2NCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FQUExJQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfTVdBVkUgaXMgbm90
IHNldAojIENPTkZJR19QQzg3MzZ4X0dQSU8gaXMgbm90IHNldAojIENPTkZJR19SQVdfRFJJVkVS
IGlzIG5vdCBzZXQKQ09ORklHX0hQRVQ9eQpDT05GSUdfSFBFVF9NTUFQPXkKQ09ORklHX0hBTkdD
SEVDS19USU1FUj1tCiMgQ09ORklHX1RDR19UUE0gaXMgbm90IHNldAojIENPTkZJR19URUxDTE9D
SyBpcyBub3Qgc2V0CkNPTkZJR19ERVZQT1JUPXkKQ09ORklHX0kyQz1tCkNPTkZJR19JMkNfQk9B
UkRJTkZPPXkKQ09ORklHX0kyQ19DT01QQVQ9eQojIENPTkZJR19JMkNfQ0hBUkRFViBpcyBub3Qg
c2V0CkNPTkZJR19JMkNfSEVMUEVSX0FVVE89eQoKIwojIEkyQyBIYXJkd2FyZSBCdXMgc3VwcG9y
dAojCgojCiMgUEMgU01CdXMgaG9zdCBjb250cm9sbGVyIGRyaXZlcnMKIwojIENPTkZJR19JMkNf
QUxJMTUzNSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19BTEkxNTYzIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX0FMSTE1WDMgaXMgbm90IHNldAojIENPTkZJR19JMkNfQU1ENzU2IGlzIG5vdCBzZXQK
IyBDT05GSUdfSTJDX0FNRDgxMTEgaXMgbm90IHNldAojIENPTkZJR19JMkNfSTgwMSBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19JU0NIIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1BJSVg0IGlzIG5v
dCBzZXQKIyBDT05GSUdfSTJDX05GT1JDRTIgaXMgbm90IHNldAojIENPTkZJR19JMkNfU0lTNTU5
NSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19TSVM2MzAgaXMgbm90IHNldAojIENPTkZJR19JMkNf
U0lTOTZYIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1ZJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0ky
Q19WSUFQUk8gaXMgbm90IHNldAoKIwojIEFDUEkgZHJpdmVycwojCiMgQ09ORklHX0kyQ19TQ01J
IGlzIG5vdCBzZXQKCiMKIyBJMkMgc3lzdGVtIGJ1cyBkcml2ZXJzIChtb3N0bHkgZW1iZWRkZWQg
LyBzeXN0ZW0tb24tY2hpcCkKIwojIENPTkZJR19JMkNfT0NPUkVTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX1NJTVRFQyBpcyBub3Qgc2V0CgojCiMgRXh0ZXJuYWwgSTJDL1NNQnVzIGFkYXB0ZXIg
ZHJpdmVycwojCiMgQ09ORklHX0kyQ19QQVJQT1JUX0xJR0hUIGlzIG5vdCBzZXQKIyBDT05GSUdf
STJDX1RBT1NfRVZNIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1RJTllfVVNCIGlzIG5vdCBzZXQK
CiMKIyBPdGhlciBJMkMvU01CdXMgYnVzIGRyaXZlcnMKIwojIENPTkZJR19JMkNfUENBX1BMQVRG
T1JNIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NUVUIgaXMgbm90IHNldAoKIwojIE1pc2NlbGxh
bmVvdXMgSTJDIENoaXAgc3VwcG9ydAojCiMgQ09ORklHX1NFTlNPUlNfVFNMMjU1MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19ERUJVR19DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVH
X0FMR08gaXMgbm90IHNldAojIENPTkZJR19JMkNfREVCVUdfQlVTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX0RFQlVHX0NISVAgaXMgbm90IHNldAojIENPTkZJR19TUEkgaXMgbm90IHNldAoKIwoj
IFBQUyBzdXBwb3J0CiMKIyBDT05GSUdfUFBTIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfV0FOVF9P
UFRJT05BTF9HUElPTElCPXkKIyBDT05GSUdfR1BJT0xJQiBpcyBub3Qgc2V0CiMgQ09ORklHX1cx
IGlzIG5vdCBzZXQKQ09ORklHX1BPV0VSX1NVUFBMWT15CiMgQ09ORklHX1BPV0VSX1NVUFBMWV9E
RUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1BEQV9QT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0JB
VFRFUllfRFMyNzYwIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9EUzI3ODIgaXMgbm90IHNl
dAojIENPTkZJR19CQVRURVJZX0JRMjd4MDAgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX01B
WDE3MDQwIGlzIG5vdCBzZXQKQ09ORklHX0hXTU9OPW0KQ09ORklHX0hXTU9OX1ZJRD1tCiMgQ09O
RklHX0hXTU9OX0RFQlVHX0NISVAgaXMgbm90IHNldAoKIwojIE5hdGl2ZSBkcml2ZXJzCiMKIyBD
T05GSUdfU0VOU09SU19BQklUVUdVUlUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FCSVRV
R1VSVTMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FENzQxNCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfQUQ3NDE4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDIxIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19BRE0xMDI2IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
RE05MjQwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDYyIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19BRFQ3NDcwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDcz
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19LOFRFTVAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0sxMFRFTVAgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0FTQjEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
QVRYUDEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0RTMTYyMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfSTVLX0FNQiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODA1RiBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjcxODgyRkcgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0Y3NTM3NVMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0ZTQ0hNRCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfRzc2MEEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0dM
NTE4U00gaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0dMNTIwU00gaXMgbm90IHNldApDT05G
SUdfU0VOU09SU19DT1JFVEVNUD1tCkNPTkZJR19TRU5TT1JTX0lUODc9bQojIENPTkZJR19TRU5T
T1JTX0xNNjMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNNzMgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX0xNNzUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNNzcgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0xNNzggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xN
ODAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODMgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0xNODUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNODcgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0xNOTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNOTIgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0xNOTMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0xUQzQyMTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xUQzQyNDUgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0xNOTUyNDEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDE2
MTkgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDY2NTAgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX1BDODczNjAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDODc0MjcgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX1BDRjg1OTEgaXMgbm90IHNldAojIENPTkZJR19TRU5T
T1JTX1NJUzU1OTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0RNRTE3MzcgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1NNU0M0N00xIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19T
TVNDNDdNMTkyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19TTVNDNDdCMzk3IGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BRFM3ODI4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
TUM2ODIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19USE1DNTAgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1RNUDQwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVE1QNDIxIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19WSUFfQ1BVVEVNUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfVklBNjg2QSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVlQxMjExIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VOU09SU19WVDgyMzEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X1c4Mzc4MUQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc5MUQgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX1c4Mzc5MkQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4Mzc5
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzTDc4NVRTIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19XODNMNzg2TkcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4MzYyN0hG
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODM2MjdFSEYgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0hEQVBTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MSVMzX0kyQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVBQTEVTTUMgaXMgbm90IHNldAoKIwojIEFDUEkgZHJp
dmVycwojCiMgQ09ORklHX1NFTlNPUlNfQVRLMDExMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTElTM0xWMDJEIGlzIG5vdCBzZXQKQ09ORklHX1RIRVJNQUw9eQpDT05GSUdfV0FUQ0hET0c9
eQojIENPTkZJR19XQVRDSERPR19OT1dBWU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0Y2hkb2cgRGV2
aWNlIERyaXZlcnMKIwojIENPTkZJR19TT0ZUX1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdf
QUNRVUlSRV9XRFQgaXMgbm90IHNldAojIENPTkZJR19BRFZBTlRFQ0hfV0RUIGlzIG5vdCBzZXQK
IyBDT05GSUdfQUxJTTE1MzVfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfQUxJTTcxMDFfV0RUIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0M1MjBfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0JDX0ZJVFBD
Ml9XQVRDSERPRyBpcyBub3Qgc2V0CiMgQ09ORklHX0VVUk9URUNIX1dEVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lCNzAwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0lCTUFTUiBpcyBub3Qgc2V0CiMg
Q09ORklHX1dBRkVSX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0k2MzAwRVNCX1dEVCBpcyBub3Qg
c2V0CkNPTkZJR19JVENPX1dEVD1tCkNPTkZJR19JVENPX1ZFTkRPUl9TVVBQT1JUPXkKIyBDT05G
SUdfSVQ4NzEyRl9XRFQgaXMgbm90IHNldAojIENPTkZJR19JVDg3X1dEVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0hQX1dBVENIRE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfU0MxMjAwX1dEVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1BDODc0MTNfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfNjBYWF9XRFQgaXMg
bm90IHNldAojIENPTkZJR19TQkM4MzYwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVTVfV0RU
IGlzIG5vdCBzZXQKIyBDT05GSUdfU01TQ19TQ0gzMTFYX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NNU0MzN0I3ODdfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzNjI3SEZfV0RUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVzgzNjk3SEZfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzNjk3VUdfV0RU
IGlzIG5vdCBzZXQKIyBDT05GSUdfVzgzODc3Rl9XRFQgaXMgbm90IHNldAojIENPTkZJR19XODM5
NzdGX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ0haX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NCQ19FUFhfQzNfV0FUQ0hET0cgaXMgbm90IHNldAoKIwojIFBDSS1iYXNlZCBXYXRjaGRvZyBD
YXJkcwojCiMgQ09ORklHX1BDSVBDV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19XRFRQQ0kg
aXMgbm90IHNldAoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCiMgQ09ORklHX1VTQlBD
V0FUQ0hET0cgaXMgbm90IHNldApDT05GSUdfU1NCX1BPU1NJQkxFPXkKCiMKIyBTb25pY3MgU2ls
aWNvbiBCYWNrcGxhbmUKIwojIENPTkZJR19TU0IgaXMgbm90IHNldAoKIwojIE11bHRpZnVuY3Rp
b24gZGV2aWNlIGRyaXZlcnMKIwojIENPTkZJR19NRkRfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklH
X01GRF9TTTUwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0hUQ19QQVNJQzMgaXMgbm90IHNldAojIENP
TkZJR19NRkRfVE1JTyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9XTTg0MDAgaXMgbm90IHNldAoj
IENPTkZJR19NRkRfV004MzUwX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9QQ0Y1MDYzMyBp
cyBub3Qgc2V0CiMgQ09ORklHX0FCMzEwMF9DT1JFIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxB
VE9SIGlzIG5vdCBzZXQKQ09ORklHX01FRElBX1NVUFBPUlQ9bQoKIwojIE11bHRpbWVkaWEgY29y
ZSBzdXBwb3J0CiMKIyBDT05GSUdfVklERU9fREVWIGlzIG5vdCBzZXQKQ09ORklHX0RWQl9DT1JF
PW0KQ09ORklHX1ZJREVPX01FRElBPW0KCiMKIyBNdWx0aW1lZGlhIGRyaXZlcnMKIwpDT05GSUdf
SVJfQ09SRT1tCkNPTkZJR19WSURFT19JUj1tCkNPTkZJR19NRURJQV9BVFRBQ0g9eQpDT05GSUdf
TUVESUFfVFVORVI9bQojIENPTkZJR19NRURJQV9UVU5FUl9DVVNUT01JU0UgaXMgbm90IHNldApD
T05GSUdfTUVESUFfVFVORVJfU0lNUExFPW0KQ09ORklHX01FRElBX1RVTkVSX1REQTgyOTA9bQpD
T05GSUdfTUVESUFfVFVORVJfVERBOTg4Nz1tCkNPTkZJR19NRURJQV9UVU5FUl9URUE1NzYxPW0K
Q09ORklHX01FRElBX1RVTkVSX1RFQTU3Njc9bQpDT05GSUdfTUVESUFfVFVORVJfTVQyMFhYPW0K
Q09ORklHX01FRElBX1RVTkVSX01UMjA2MD1tCkNPTkZJR19NRURJQV9UVU5FUl9NVDIyNjY9bQpD
T05GSUdfTUVESUFfVFVORVJfWEMyMDI4PW0KQ09ORklHX01FRElBX1RVTkVSX1hDNTAwMD1tCkNP
TkZJR19NRURJQV9UVU5FUl9NWEw1MDA3VD1tCkNPTkZJR19NRURJQV9UVU5FUl9NQzQ0UzgwMz1t
CkNPTkZJR19EVkJfTUFYX0FEQVBURVJTPTgKIyBDT05GSUdfRFZCX0RZTkFNSUNfTUlOT1JTIGlz
IG5vdCBzZXQKQ09ORklHX0RWQl9DQVBUVVJFX0RSSVZFUlM9eQoKIwojIFN1cHBvcnRlZCBTQUE3
MTQ2IGJhc2VkIFBDSSBBZGFwdGVycwojCiMgQ09ORklHX1RUUENJX0VFUFJPTSBpcyBub3Qgc2V0
CiMgQ09ORklHX0RWQl9CVURHRVRfQ09SRSBpcyBub3Qgc2V0CgojCiMgU3VwcG9ydGVkIFVTQiBB
ZGFwdGVycwojCkNPTkZJR19EVkJfVVNCPW0KIyBDT05GSUdfRFZCX1VTQl9ERUJVRyBpcyBub3Qg
c2V0CiMgQ09ORklHX0RWQl9VU0JfQTgwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9VU0JfRElC
VVNCX01CIGlzIG5vdCBzZXQKIyBDT05GSUdfRFZCX1VTQl9ESUJVU0JfTUMgaXMgbm90IHNldApD
T05GSUdfRFZCX1VTQl9ESUIwNzAwPW0KIyBDT05GSUdfRFZCX1VTQl9VTVRfMDEwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFZCX1VTQl9DWFVTQiBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9VU0JfTTky
MFggaXMgbm90IHNldAojIENPTkZJR19EVkJfVVNCX0dMODYxIGlzIG5vdCBzZXQKIyBDT05GSUdf
RFZCX1VTQl9BVTY2MTAgaXMgbm90IHNldAojIENPTkZJR19EVkJfVVNCX0RJR0lUViBpcyBub3Qg
c2V0CiMgQ09ORklHX0RWQl9VU0JfVlA3MDQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfRFZCX1VTQl9W
UDcwMlggaXMgbm90IHNldAojIENPTkZJR19EVkJfVVNCX0dQOFBTSyBpcyBub3Qgc2V0CkNPTkZJ
R19EVkJfVVNCX05PVkFfVF9VU0IyPW0KIyBDT05GSUdfRFZCX1VTQl9UVFVTQjIgaXMgbm90IHNl
dAojIENPTkZJR19EVkJfVVNCX0RUVDIwMFUgaXMgbm90IHNldAojIENPTkZJR19EVkJfVVNCX09Q
RVJBMSBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9VU0JfQUY5MDA1IGlzIG5vdCBzZXQKIyBDT05G
SUdfRFZCX1VTQl9EVzIxMDIgaXMgbm90IHNldAojIENPTkZJR19EVkJfVVNCX0NJTkVSR1lfVDIg
aXMgbm90IHNldAojIENPTkZJR19EVkJfVVNCX0FOWVNFRSBpcyBub3Qgc2V0CiMgQ09ORklHX0RW
Ql9VU0JfRFRWNTEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0RWQl9VU0JfQUY5MDE1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFZCX1VTQl9DRTYyMzAgaXMgbm90IHNldAojIENPTkZJR19EVkJfVVNCX0ZS
SUlPIGlzIG5vdCBzZXQKIyBDT05GSUdfRFZCX1VTQl9FQzE2OCBpcyBub3Qgc2V0CiMgQ09ORklH
X0RWQl9UVFVTQl9CVURHRVQgaXMgbm90IHNldAojIENPTkZJR19EVkJfVFRVU0JfREVDIGlzIG5v
dCBzZXQKIyBDT05GSUdfU01TX1NJQU5PX01EVFYgaXMgbm90IHNldAoKIwojIFN1cHBvcnRlZCBG
bGV4Q29wSUkgKEIyQzIpIEFkYXB0ZXJzCiMKIyBDT05GSUdfRFZCX0IyQzJfRkxFWENPUCBpcyBu
b3Qgc2V0CgojCiMgU3VwcG9ydGVkIEJUODc4IEFkYXB0ZXJzCiMKCiMKIyBTdXBwb3J0ZWQgUGx1
dG8yIEFkYXB0ZXJzCiMKIyBDT05GSUdfRFZCX1BMVVRPMiBpcyBub3Qgc2V0CgojCiMgU3VwcG9y
dGVkIFNETUMgRE0xMTA1IEFkYXB0ZXJzCiMKIyBDT05GSUdfRFZCX0RNMTEwNSBpcyBub3Qgc2V0
CgojCiMgU3VwcG9ydGVkIEVhcnRoc29mdCBQVDEgQWRhcHRlcnMKIwojIENPTkZJR19EVkJfUFQx
IGlzIG5vdCBzZXQKCiMKIyBTdXBwb3J0ZWQgTWFudGlzIEFkYXB0ZXJzCiMKIyBDT05GSUdfTUFO
VElTX0NPUkUgaXMgbm90IHNldAoKIwojIFN1cHBvcnRlZCBEVkIgRnJvbnRlbmRzCiMKIyBDT05G
SUdfRFZCX0ZFX0NVU1RPTUlTRSBpcyBub3Qgc2V0CkNPTkZJR19EVkJfRElCMzAwME1DPW0KQ09O
RklHX0RWQl9ESUI3MDAwTT1tCkNPTkZJR19EVkJfRElCNzAwMFA9bQpDT05GSUdfRFZCX0xHRFQz
MzA1PW0KQ09ORklHX0RWQl9TNUgxNDExPW0KQ09ORklHX0RWQl9ESUI4MDAwPW0KQ09ORklHX0RW
Ql9QTEw9bQpDT05GSUdfRFZCX1RVTkVSX0RJQjAwNzA9bQojIENPTkZJR19EQUIgaXMgbm90IHNl
dAoKIwojIEdyYXBoaWNzIHN1cHBvcnQKIwojIENPTkZJR19BR1AgaXMgbm90IHNldApDT05GSUdf
VkdBX0FSQj15CiMgQ09ORklHX0RSTSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZHQVNUQVRFIGlzIG5v
dCBzZXQKIyBDT05GSUdfVklERU9fT1VUUFVUX0NPTlRST0wgaXMgbm90IHNldAojIENPTkZJR19G
QiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9MQ0RfU1VQUE9SVCBpcyBub3Qgc2V0Cgoj
CiMgRGlzcGxheSBkZXZpY2Ugc3VwcG9ydAojCiMgQ09ORklHX0RJU1BMQVlfU1VQUE9SVCBpcyBu
b3Qgc2V0CgojCiMgQ29uc29sZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09ORklHX1ZHQV9D
T05TT0xFPXkKIyBDT05GSUdfVkdBQ09OX1NPRlRfU0NST0xMQkFDSyBpcyBub3Qgc2V0CkNPTkZJ
R19EVU1NWV9DT05TT0xFPXkKQ09ORklHX1NPVU5EPW0KIyBDT05GSUdfU09VTkRfT1NTX0NPUkUg
aXMgbm90IHNldApDT05GSUdfU05EPW0KQ09ORklHX1NORF9USU1FUj1tCkNPTkZJR19TTkRfUENN
PW0KQ09ORklHX1NORF9TRVFVRU5DRVI9bQojIENPTkZJR19TTkRfU0VRX0RVTU1ZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX01JWEVSX09TUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9QQ01fT1NT
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1NFUVVFTkNFUl9PU1MgaXMgbm90IHNldApDT05GSUdf
U05EX0hSVElNRVI9bQpDT05GSUdfU05EX1NFUV9IUlRJTUVSX0RFRkFVTFQ9eQojIENPTkZJR19T
TkRfRFlOQU1JQ19NSU5PUlMgaXMgbm90IHNldAojIENPTkZJR19TTkRfU1VQUE9SVF9PTERfQVBJ
IGlzIG5vdCBzZXQKQ09ORklHX1NORF9WRVJCT1NFX1BST0NGUz15CiMgQ09ORklHX1NORF9WRVJC
T1NFX1BSSU5USyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJ
R19TTkRfVk1BU1RFUj15CkNPTkZJR19TTkRfRE1BX1NHQlVGPXkKIyBDT05GSUdfU05EX1JBV01J
RElfU0VRIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX09QTDNfTElCX1NFUSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NORF9PUEw0X0xJQl9TRVEgaXMgbm90IHNldAojIENPTkZJR19TTkRfU0JBV0VfU0VR
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0VNVTEwSzFfU0VRIGlzIG5vdCBzZXQKQ09ORklHX1NO
RF9EUklWRVJTPXkKIyBDT05GSUdfU05EX1BDU1AgaXMgbm90IHNldAojIENPTkZJR19TTkRfRFVN
TVkgaXMgbm90IHNldAojIENPTkZJR19TTkRfVklSTUlESSBpcyBub3Qgc2V0CiMgQ09ORklHX1NO
RF9NVFBBViBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9TRVJJQUxfVTE2NTUwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX01QVTQwMSBpcyBub3Qgc2V0CkNPTkZJR19TTkRfUENJPXkKIyBDT05GSUdf
U05EX0FEMTg4OSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BTFMzMDAgaXMgbm90IHNldAojIENP
TkZJR19TTkRfQUxTNDAwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BTEk1NDUxIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0FUSUlYUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BVElJWFBfTU9E
RU0gaXMgbm90IHNldAojIENPTkZJR19TTkRfQVU4ODEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0FVODgyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9BVTg4MzAgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfQVcyIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0FaVDMzMjggaXMgbm90IHNldAojIENP
TkZJR19TTkRfQlQ4N1ggaXMgbm90IHNldAojIENPTkZJR19TTkRfQ0EwMTA2IGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX0NNSVBDSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9PWFlHRU4gaXMgbm90
IHNldAojIENPTkZJR19TTkRfQ1M0MjgxIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0NTNDZYWCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9DUzU1MzAgaXMgbm90IHNldAojIENPTkZJR19TTkRfQ1M1
NTM1QVVESU8gaXMgbm90IHNldAojIENPTkZJR19TTkRfQ1RYRkkgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfREFSTEEyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9HSU5BMjAgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfTEFZTEEyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9EQVJMQTI0IGlzIG5v
dCBzZXQKIyBDT05GSUdfU05EX0dJTkEyNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9MQVlMQTI0
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX01PTkEgaXMgbm90IHNldAojIENPTkZJR19TTkRfTUlB
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0VDSE8zRyBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9J
TkRJR08gaXMgbm90IHNldAojIENPTkZJR19TTkRfSU5ESUdPSU8gaXMgbm90IHNldAojIENPTkZJ
R19TTkRfSU5ESUdPREogaXMgbm90IHNldAojIENPTkZJR19TTkRfSU5ESUdPSU9YIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0lORElHT0RKWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9FTVUxMEsx
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0VNVTEwSzFYIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0VOUzEzNzAgaXMgbm90IHNldAojIENPTkZJR19TTkRfRU5TMTM3MSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9FUzE5MzggaXMgbm90IHNldAojIENPTkZJR19TTkRfRVMxOTY4IGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX0ZNODAxIGlzIG5vdCBzZXQKQ09ORklHX1NORF9IREFfSU5URUw9bQojIENP
TkZJR19TTkRfSERBX0hXREVQIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9JTlBVVF9CRUVQ
IGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9JTlBVVF9KQUNLIGlzIG5vdCBzZXQKIyBDT05G
SUdfU05EX0hEQV9QQVRDSF9MT0FERVIgaXMgbm90IHNldApDT05GSUdfU05EX0hEQV9DT0RFQ19S
RUFMVEVLPXkKIyBDT05GSUdfU05EX0hEQV9DT0RFQ19BTkFMT0cgaXMgbm90IHNldAojIENPTkZJ
R19TTkRfSERBX0NPREVDX1NJR01BVEVMIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9DT0RF
Q19WSUEgaXMgbm90IHNldAojIENPTkZJR19TTkRfSERBX0NPREVDX0FUSUhETUkgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfSERBX0NPREVDX05WSERNSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9I
REFfQ09ERUNfSU5URUxIRE1JIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9DT0RFQ19DSVJS
VVMgaXMgbm90IHNldAojIENPTkZJR19TTkRfSERBX0NPREVDX0NPTkVYQU5UIGlzIG5vdCBzZXQK
IyBDT05GSUdfU05EX0hEQV9DT0RFQ19DQTAxMTAgaXMgbm90IHNldAojIENPTkZJR19TTkRfSERB
X0NPREVDX0NNRURJQSBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9IREFfQ09ERUNfU0kzMDU0IGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX0hEQV9HRU5FUklDIGlzIG5vdCBzZXQKIyBDT05GSUdfU05E
X0hEQV9QT1dFUl9TQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX0hEU1AgaXMgbm90IHNldAoj
IENPTkZJR19TTkRfSERTUE0gaXMgbm90IHNldAojIENPTkZJR19TTkRfSElGSUVSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU05EX0lDRTE3MTIgaXMgbm90IHNldAojIENPTkZJR19TTkRfSUNFMTcyNCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NORF9JTlRFTDhYMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9J
TlRFTDhYME0gaXMgbm90IHNldAojIENPTkZJR19TTkRfS09SRzEyMTIgaXMgbm90IHNldAojIENP
TkZJR19TTkRfTFg2NDY0RVMgaXMgbm90IHNldAojIENPTkZJR19TTkRfTUFFU1RSTzMgaXMgbm90
IHNldAojIENPTkZJR19TTkRfTUlYQVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX05NMjU2IGlz
IG5vdCBzZXQKIyBDT05GSUdfU05EX1BDWEhSIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1JJUFRJ
REUgaXMgbm90IHNldAojIENPTkZJR19TTkRfUk1FMzIgaXMgbm90IHNldAojIENPTkZJR19TTkRf
Uk1FOTYgaXMgbm90IHNldAojIENPTkZJR19TTkRfUk1FOTY1MiBpcyBub3Qgc2V0CiMgQ09ORklH
X1NORF9TT05JQ1ZJQkVTIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1RSSURFTlQgaXMgbm90IHNl
dAojIENPTkZJR19TTkRfVklBODJYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NORF9WSUE4MlhYX01P
REVNIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1ZJUlRVT1NPIGlzIG5vdCBzZXQKIyBDT05GSUdf
U05EX1ZYMjIyIGlzIG5vdCBzZXQKIyBDT05GSUdfU05EX1lNRlBDSSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NORF9VU0IgaXMgbm90IHNldAojIENPTkZJR19TTkRfU09DIGlzIG5vdCBzZXQKIyBDT05G
SUdfU09VTkRfUFJJTUUgaXMgbm90IHNldApDT05GSUdfSElEX1NVUFBPUlQ9eQpDT05GSUdfSElE
PXkKIyBDT05GSUdfSElEUkFXIGlzIG5vdCBzZXQKCiMKIyBVU0IgSW5wdXQgRGV2aWNlcwojCkNP
TkZJR19VU0JfSElEPXkKIyBDT05GSUdfSElEX1BJRCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfSElE
REVWPXkKCiMKIyBTcGVjaWFsIEhJRCBkcml2ZXJzCiMKQ09ORklHX0hJRF9BNFRFQ0g9eQpDT05G
SUdfSElEX0FQUExFPXkKQ09ORklHX0hJRF9CRUxLSU49eQpDT05GSUdfSElEX0NIRVJSWT15CkNP
TkZJR19ISURfQ0hJQ09OWT15CkNPTkZJR19ISURfQ1lQUkVTUz15CkNPTkZJR19ISURfRFJBR09O
UklTRT15CiMgQ09ORklHX0RSQUdPTlJJU0VfRkYgaXMgbm90IHNldApDT05GSUdfSElEX0VaS0VZ
PXkKQ09ORklHX0hJRF9LWUU9eQpDT05GSUdfSElEX0dZUkFUSU9OPXkKQ09ORklHX0hJRF9UV0lO
SEFOPXkKQ09ORklHX0hJRF9LRU5TSU5HVE9OPXkKQ09ORklHX0hJRF9MT0dJVEVDSD15CiMgQ09O
RklHX0xPR0lURUNIX0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9HSVJVTUJMRVBBRDJfRkYgaXMg
bm90IHNldApDT05GSUdfSElEX01JQ1JPU09GVD15CkNPTkZJR19ISURfTU9OVEVSRVk9eQpDT05G
SUdfSElEX05UUklHPXkKQ09ORklHX0hJRF9QQU5USEVSTE9SRD15CiMgQ09ORklHX1BBTlRIRVJM
T1JEX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9QRVRBTFlOWD15CkNPTkZJR19ISURfU0FNU1VO
Rz15CkNPTkZJR19ISURfU09OWT15CkNPTkZJR19ISURfU1VOUExVUz15CkNPTkZJR19ISURfR1JF
RU5BU0lBPXkKIyBDT05GSUdfR1JFRU5BU0lBX0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hJRF9TTUFS
VEpPWVBMVVM9eQojIENPTkZJR19TTUFSVEpPWVBMVVNfRkYgaXMgbm90IHNldApDT05GSUdfSElE
X1RPUFNFRUQ9eQpDT05GSUdfSElEX1RIUlVTVE1BU1RFUj15CiMgQ09ORklHX1RIUlVTVE1BU1RF
Ul9GRiBpcyBub3Qgc2V0CkNPTkZJR19ISURfWkVST1BMVVM9eQojIENPTkZJR19aRVJPUExVU19G
RiBpcyBub3Qgc2V0CkNPTkZJR19VU0JfU1VQUE9SVD15CkNPTkZJR19VU0JfQVJDSF9IQVNfSENE
PXkKQ09ORklHX1VTQl9BUkNIX0hBU19PSENJPXkKQ09ORklHX1VTQl9BUkNIX0hBU19FSENJPXkK
Q09ORklHX1VTQj15CiMgQ09ORklHX1VTQl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19VU0JfQU5O
T1VOQ0VfTkVXX0RFVklDRVM9eQoKIwojIE1pc2NlbGxhbmVvdXMgVVNCIG9wdGlvbnMKIwpDT05G
SUdfVVNCX0RFVklDRUZTPXkKQ09ORklHX1VTQl9ERVZJQ0VfQ0xBU1M9eQpDT05GSUdfVVNCX0RZ
TkFNSUNfTUlOT1JTPXkKIyBDT05GSUdfVVNCX1NVU1BFTkQgaXMgbm90IHNldAojIENPTkZJR19V
U0JfT1RHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX01PTiBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9XVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1dVU0JfQ0JBRiBpcyBub3Qgc2V0CgojCiMg
VVNCIEhvc3QgQ29udHJvbGxlciBEcml2ZXJzCiMKIyBDT05GSUdfVVNCX0M2N1gwMF9IQ0QgaXMg
bm90IHNldApDT05GSUdfVVNCX1hIQ0lfSENEPXkKIyBDT05GSUdfVVNCX1hIQ0lfSENEX0RFQlVH
R0lORyBpcyBub3Qgc2V0CkNPTkZJR19VU0JfRUhDSV9IQ0Q9eQpDT05GSUdfVVNCX0VIQ0lfUk9P
VF9IVUJfVFQ9eQpDT05GSUdfVVNCX0VIQ0lfVFRfTkVXU0NIRUQ9eQojIENPTkZJR19VU0JfT1hV
MjEwSFBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDExNlhfSENEIGlzIG5vdCBzZXQK
IyBDT05GSUdfVVNCX0lTUDE3NjBfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDEzNjJf
SENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09IQ0lfSENEIGlzIG5vdCBzZXQKQ09ORklHX1VT
Ql9VSENJX0hDRD15CiMgQ09ORklHX1VTQl9TTDgxMV9IQ0QgaXMgbm90IHNldAojIENPTkZJR19V
U0JfUjhBNjY1OTdfSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1dIQ0lfSENEIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVVNCX0hXQV9IQ0QgaXMgbm90IHNldAoKIwojIFVTQiBEZXZpY2UgQ2xhc3Mg
ZHJpdmVycwojCiMgQ09ORklHX1VTQl9BQ00gaXMgbm90IHNldAojIENPTkZJR19VU0JfUFJJTlRF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9XRE0gaXMgbm90IHNldAojIENPTkZJR19VU0JfVE1D
IGlzIG5vdCBzZXQKCiMKIyBOT1RFOiBVU0JfU1RPUkFHRSBkZXBlbmRzIG9uIFNDU0kgYnV0IEJM
S19ERVZfU0QgbWF5CiMKCiMKIyBhbHNvIGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAg
Zm9yIG1vcmUgaW5mbwojCkNPTkZJR19VU0JfU1RPUkFHRT15CiMgQ09ORklHX1VTQl9TVE9SQUdF
X0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfREFUQUZBQiBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT00gaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RP
UkFHRV9JU0QyMDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9VU0JBVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX1NERFIwOSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9T
VE9SQUdFX1NERFI1NSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0pVTVBTSE9UIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfQUxBVURBIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX1NUT1JBR0VfT05FVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9LQVJN
QSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0NZUFJFU1NfQVRBQ0IgaXMgbm90IHNl
dApDT05GSUdfVVNCX0xJQlVTVUFMPXkKCiMKIyBVU0IgSW1hZ2luZyBkZXZpY2VzCiMKIyBDT05G
SUdfVVNCX01EQzgwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NSUNST1RFSyBpcyBub3Qgc2V0
CgojCiMgVVNCIHBvcnQgZHJpdmVycwojCiMgQ09ORklHX1VTQl9TRVJJQUwgaXMgbm90IHNldAoK
IwojIFVTQiBNaXNjZWxsYW5lb3VzIGRyaXZlcnMKIwojIENPTkZJR19VU0JfRU1JNjIgaXMgbm90
IHNldAojIENPTkZJR19VU0JfRU1JMjYgaXMgbm90IHNldAojIENPTkZJR19VU0JfQURVVFVYIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1NFVlNFRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SSU81
MDAgaXMgbm90IHNldAojIENPTkZJR19VU0JfTEVHT1RPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0xDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9CRVJSWV9DSEFSR0UgaXMgbm90IHNldAoj
IENPTkZJR19VU0JfTEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZUFJFU1NfQ1k3QzYzIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX0NZVEhFUk0gaXMgbm90IHNldAojIENPTkZJR19VU0JfSURN
T1VTRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9GVERJX0VMQU4gaXMgbm90IHNldAojIENPTkZJ
R19VU0JfQVBQTEVESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NJU1VTQlZHQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9MRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9UUkFOQ0VWSUJS
QVRPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JT1dBUlJJT1IgaXMgbm90IHNldAojIENPTkZJ
R19VU0JfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU0lHSFRGVyBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9WU1QgaXMgbm90IHNldAojIENPTkZJR19VU0JfR0FER0VUIGlzIG5vdCBzZXQK
CiMKIyBPVEcgYW5kIHJlbGF0ZWQgaW5mcmFzdHJ1Y3R1cmUKIwojIENPTkZJR19OT1BfVVNCX1hD
RUlWIGlzIG5vdCBzZXQKIyBDT05GSUdfVVdCIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUVNU1RJQ0sgaXMgbm90IHNldAojIENPTkZJR19ORVdfTEVEUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0FDQ0VTU0lCSUxJVFkgaXMgbm90IHNldAojIENPTkZJR19JTkZJTklC
QU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfRURBQyBpcyBub3Qgc2V0CkNPTkZJR19SVENfTElCPXkK
Q09ORklHX1JUQ19DTEFTUz15CkNPTkZJR19SVENfSENUT1NZUz15CkNPTkZJR19SVENfSENUT1NZ
U19ERVZJQ0U9InJ0YzAiCiMgQ09ORklHX1JUQ19ERUJVRyBpcyBub3Qgc2V0CgojCiMgUlRDIGlu
dGVyZmFjZXMKIwpDT05GSUdfUlRDX0lOVEZfU1lTRlM9eQpDT05GSUdfUlRDX0lOVEZfUFJPQz15
CkNPTkZJR19SVENfSU5URl9ERVY9eQojIENPTkZJR19SVENfSU5URl9ERVZfVUlFX0VNVUwgaXMg
bm90IHNldAojIENPTkZJR19SVENfRFJWX1RFU1QgaXMgbm90IHNldAoKIwojIEkyQyBSVEMgZHJp
dmVycwojCiMgQ09ORklHX1JUQ19EUlZfRFMxMzA3IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9EUzEzNzQgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTY3MiBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfTUFYNjkwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlM1QzM3
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfSVNMMTIwOCBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfWDEyMDUgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1BDRjg1NjMgaXMgbm90
IHNldAojIENPTkZJR19SVENfRFJWX1BDRjg1ODMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJW
X000MVQ4MCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfQlEzMksgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX1MzNTM5MEEgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0ZNMzEzMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlg4NTgxIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRD
X0RSVl9SWDgwMjUgaXMgbm90IHNldAoKIwojIFNQSSBSVEMgZHJpdmVycwojCgojCiMgUGxhdGZv
cm0gUlRDIGRyaXZlcnMKIwpDT05GSUdfUlRDX0RSVl9DTU9TPXkKIyBDT05GSUdfUlRDX0RSVl9E
UzEyODYgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTUxMSBpcyBub3Qgc2V0CiMgQ09O
RklHX1JUQ19EUlZfRFMxNTUzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE3NDIgaXMg
bm90IHNldAojIENPTkZJR19SVENfRFJWX1NUSzE3VEE4IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRD
X0RSVl9NNDhUODYgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000OFQzNSBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfTTQ4VDU5IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NU002
MjQyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9CUTQ4MDIgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX1JQNUMwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfVjMwMjAgaXMgbm90
IHNldAoKIwojIG9uLUNQVSBSVEMgZHJpdmVycwojCiMgQ09ORklHX0RNQURFVklDRVMgaXMgbm90
IHNldAojIENPTkZJR19BVVhESVNQTEFZIGlzIG5vdCBzZXQKIyBDT05GSUdfVUlPIGlzIG5vdCBz
ZXQKCiMKIyBUSSBWTFlOUQojCiMgQ09ORklHX1NUQUdJTkcgaXMgbm90IHNldAojIENPTkZJR19Y
ODZfUExBVEZPUk1fREVWSUNFUyBpcyBub3Qgc2V0CgojCiMgRmlybXdhcmUgRHJpdmVycwojCiMg
Q09ORklHX0VERCBpcyBub3Qgc2V0CkNPTkZJR19GSVJNV0FSRV9NRU1NQVA9eQojIENPTkZJR19E
RUxMX1JCVSBpcyBub3Qgc2V0CiMgQ09ORklHX0RDREJBUyBpcyBub3Qgc2V0CkNPTkZJR19ETUlJ
RD15CiMgQ09ORklHX0lTQ1NJX0lCRlRfRklORCBpcyBub3Qgc2V0CgojCiMgRmlsZSBzeXN0ZW1z
CiMKIyBDT05GSUdfRVhUMl9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX0VYVDNfRlMgaXMgbm90IHNl
dAojIENPTkZJR19FWFQ0X0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVJU0VSRlNfRlMgaXMgbm90
IHNldAojIENPTkZJR19KRlNfRlMgaXMgbm90IHNldApDT05GSUdfRlNfUE9TSVhfQUNMPXkKQ09O
RklHX1hGU19GUz15CiMgQ09ORklHX1hGU19RVU9UQSBpcyBub3Qgc2V0CkNPTkZJR19YRlNfUE9T
SVhfQUNMPXkKIyBDT05GSUdfWEZTX1JUIGlzIG5vdCBzZXQKIyBDT05GSUdfWEZTX0RFQlVHIGlz
IG5vdCBzZXQKIyBDT05GSUdfR0ZTMl9GUyBpcyBub3Qgc2V0CiMgQ09ORklHX09DRlMyX0ZTIGlz
IG5vdCBzZXQKIyBDT05GSUdfQlRSRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19OSUxGUzJfRlMg
aXMgbm90IHNldApDT05GSUdfRklMRV9MT0NLSU5HPXkKQ09ORklHX0ZTTk9USUZZPXkKQ09ORklH
X0ROT1RJRlk9eQpDT05GSUdfSU5PVElGWT15CkNPTkZJR19JTk9USUZZX1VTRVI9eQojIENPTkZJ
R19RVU9UQSBpcyBub3Qgc2V0CiMgQ09ORklHX0FVVE9GU19GUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FVVE9GUzRfRlMgaXMgbm90IHNldAojIENPTkZJR19GVVNFX0ZTIGlzIG5vdCBzZXQKQ09ORklH
X0dFTkVSSUNfQUNMPXkKCiMKIyBDYWNoZXMKIwojIENPTkZJR19GU0NBQ0hFIGlzIG5vdCBzZXQK
CiMKIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0lTTzk2NjBfRlM9bQpDT05GSUdf
Sk9MSUVUPXkKIyBDT05GSUdfWklTT0ZTIGlzIG5vdCBzZXQKQ09ORklHX1VERl9GUz1tCkNPTkZJ
R19VREZfTkxTPXkKCiMKIyBET1MvRkFUL05UIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0ZBVF9GUz1t
CiMgQ09ORklHX01TRE9TX0ZTIGlzIG5vdCBzZXQKQ09ORklHX1ZGQVRfRlM9bQpDT05GSUdfRkFU
X0RFRkFVTFRfQ09ERVBBR0U9ODUwCkNPTkZJR19GQVRfREVGQVVMVF9JT0NIQVJTRVQ9InV0Zjgi
CkNPTkZJR19OVEZTX0ZTPW0KIyBDT05GSUdfTlRGU19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklH
X05URlNfUlcgaXMgbm90IHNldAoKIwojIFBzZXVkbyBmaWxlc3lzdGVtcwojCkNPTkZJR19QUk9D
X0ZTPXkKIyBDT05GSUdfUFJPQ19LQ09SRSBpcyBub3Qgc2V0CkNPTkZJR19QUk9DX1NZU0NUTD15
CkNPTkZJR19QUk9DX1BBR0VfTU9OSVRPUj15CkNPTkZJR19TWVNGUz15CkNPTkZJR19UTVBGUz15
CkNPTkZJR19UTVBGU19QT1NJWF9BQ0w9eQojIENPTkZJR19IVUdFVExCRlMgaXMgbm90IHNldAoj
IENPTkZJR19IVUdFVExCX1BBR0UgaXMgbm90IHNldAojIENPTkZJR19DT05GSUdGU19GUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX01JU0NfRklMRVNZU1RFTVMgaXMgbm90IHNldAojIENPTkZJR19ORVRX
T1JLX0ZJTEVTWVNURU1TIGlzIG5vdCBzZXQKQ09ORklHX0VYUE9SVEZTPXkKCiMKIyBQYXJ0aXRp
b24gVHlwZXMKIwojIENPTkZJR19QQVJUSVRJT05fQURWQU5DRUQgaXMgbm90IHNldApDT05GSUdf
TVNET1NfUEFSVElUSU9OPXkKQ09ORklHX05MUz15CkNPTkZJR19OTFNfREVGQVVMVD0idXRmOCIK
Q09ORklHX05MU19DT0RFUEFHRV80Mzc9bQojIENPTkZJR19OTFNfQ09ERVBBR0VfNzM3IGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzc3NSBpcyBub3Qgc2V0CkNPTkZJR19OTFNfQ09E
RVBBR0VfODUwPW0KIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1MiBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19DT0RFUEFHRV84NTUgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODU3IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MCBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19DT0RFUEFHRV84NjEgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYyIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2MyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19D
T0RFUEFHRV84NjQgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY1IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0NPREVQQUdFXzg2NiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RF
UEFHRV84NjkgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTM2IGlzIG5vdCBzZXQK
IyBDT05GSUdfTkxTX0NPREVQQUdFXzk1MCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFH
RV85MzIgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTQ5IGlzIG5vdCBzZXQKIyBD
T05GSUdfTkxTX0NPREVQQUdFXzg3NCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5Xzgg
aXMgbm90IHNldApDT05GSUdfTkxTX0NPREVQQUdFXzEyNTA9bQojIENPTkZJR19OTFNfQ09ERVBB
R0VfMTI1MSBpcyBub3Qgc2V0CkNPTkZJR19OTFNfQVNDSUk9bQpDT05GSUdfTkxTX0lTTzg4NTlf
MT1tCiMgQ09ORklHX05MU19JU084ODU5XzIgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1
OV8zIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNCBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19JU084ODU5XzUgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV82IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084ODU5
XzkgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV8xMyBpcyBub3Qgc2V0CiMgQ09ORklH
X05MU19JU084ODU5XzE0IGlzIG5vdCBzZXQKQ09ORklHX05MU19JU084ODU5XzE1PW0KIyBDT05G
SUdfTkxTX0tPSThfUiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19LT0k4X1UgaXMgbm90IHNldApD
T05GSUdfTkxTX1VURjg9bQojIENPTkZJR19ETE0gaXMgbm90IHNldAoKIwojIEtlcm5lbCBoYWNr
aW5nCiMKQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQ9eQpDT05GSUdfUFJJTlRLX1RJTUU9
eQpDT05GSUdfRU5BQkxFX1dBUk5fREVQUkVDQVRFRD15CkNPTkZJR19FTkFCTEVfTVVTVF9DSEVD
Sz15CkNPTkZJR19GUkFNRV9XQVJOPTIwNDgKQ09ORklHX01BR0lDX1NZU1JRPXkKIyBDT05GSUdf
U1RSSVBfQVNNX1NZTVMgaXMgbm90IHNldAojIENPTkZJR19VTlVTRURfU1lNQk9MUyBpcyBub3Qg
c2V0CiMgQ09ORklHX0RFQlVHX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfSEVBREVSU19DSEVDSyBp
cyBub3Qgc2V0CkNPTkZJR19ERUJVR19LRVJORUw9eQojIENPTkZJR19ERUJVR19TSElSUSBpcyBu
b3Qgc2V0CkNPTkZJR19ERVRFQ1RfU09GVExPQ0tVUD15CiMgQ09ORklHX0JPT1RQQVJBTV9TT0ZU
TE9DS1VQX1BBTklDIGlzIG5vdCBzZXQKQ09ORklHX0JPT1RQQVJBTV9TT0ZUTE9DS1VQX1BBTklD
X1ZBTFVFPTAKQ09ORklHX0RFVEVDVF9IVU5HX1RBU0s9eQojIENPTkZJR19CT09UUEFSQU1fSFVO
R19UQVNLX1BBTklDIGlzIG5vdCBzZXQKQ09ORklHX0JPT1RQQVJBTV9IVU5HX1RBU0tfUEFOSUNf
VkFMVUU9MAojIENPTkZJR19TQ0hFRF9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1NDSEVEU1RB
VFMgaXMgbm90IHNldAojIENPTkZJR19USU1FUl9TVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX09CSkVDVFMgaXMgbm90IHNldAojIENPTkZJR19TTFVCX0RFQlVHX09OIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0xVQl9TVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0tNRU1MRUFLIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfUlRfTVVURVhFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
X01VVEVYX1RFU1RFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NQSU5MT0NLIGlzIG5vdCBz
ZXQKIyBDT05GSUdfREVCVUdfTVVURVhFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0xPQ0tf
QUxMT0MgaXMgbm90IHNldAojIENPTkZJR19QUk9WRV9MT0NLSU5HIGlzIG5vdCBzZXQKIyBDT05G
SUdfTE9DS19TVEFUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU1BJTkxPQ0tfU0xFRVAgaXMg
bm90IHNldAojIENPTkZJR19ERUJVR19MT0NLSU5HX0FQSV9TRUxGVEVTVFMgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX0JVR1ZFUkJPU0U9
eQpDT05GSUdfREVCVUdfSU5GTz15CiMgQ09ORklHX0RFQlVHX1ZNIGlzIG5vdCBzZXQKIyBDT05G
SUdfREVCVUdfVklSVFVBTCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1dSSVRFQ09VTlQgaXMg
bm90IHNldApDT05GSUdfREVCVUdfTUVNT1JZX0lOSVQ9eQojIENPTkZJR19ERUJVR19MSVNUIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU0cgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19OT1RJ
RklFUlMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19DUkVERU5USUFMUyBpcyBub3Qgc2V0CkNP
TkZJR19BUkNIX1dBTlRfRlJBTUVfUE9JTlRFUlM9eQojIENPTkZJR19GUkFNRV9QT0lOVEVSIGlz
IG5vdCBzZXQKIyBDT05GSUdfQk9PVF9QUklOVEtfREVMQVkgaXMgbm90IHNldAojIENPTkZJR19S
Q1VfVE9SVFVSRV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX0NQVV9TVEFMTF9ERVRFQ1RP
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tUUkFDRV9TRUxGX1RFU1QgaXMgbm90IHNldAojIENP
TkZJR19ERUJVR19CTE9DS19FWFRfREVWVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0ZPUkNF
X1dFQUtfUEVSX0NQVSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZBVUxUX0lOSkVDVElPTiBpcyBub3Qg
c2V0CiMgQ09ORklHX0xBVEVOQ1lUT1AgaXMgbm90IHNldApDT05GSUdfU1lTQ1RMX1NZU0NBTExf
Q0hFQ0s9eQojIENPTkZJR19ERUJVR19QQUdFQUxMT0MgaXMgbm90IHNldApDT05GSUdfVVNFUl9T
VEFDS1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9UUkFDRVI9eQpDT05GSUdf
SEFWRV9GVU5DVElPTl9HUkFQSF9UUkFDRVI9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9HUkFQSF9G
UF9URVNUPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VfTUNPVU5UX1RFU1Q9eQpDT05GSUdf
SEFWRV9EWU5BTUlDX0ZUUkFDRT15CkNPTkZJR19IQVZFX0ZUUkFDRV9NQ09VTlRfUkVDT1JEPXkK
Q09ORklHX0hBVkVfU1lTQ0FMTF9UUkFDRVBPSU5UUz15CkNPTkZJR19UUkFDSU5HX1NVUFBPUlQ9
eQojIENPTkZJR19GVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19QUk9WSURFX09IQ0kxMzk0X0RN
QV9JTklUIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BX0FQSV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NBTVBMRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tHREI9eQojIENPTkZJR19L
R0RCIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LTUVNQ0hFQ0s9eQojIENPTkZJR19TVFJJ
Q1RfREVWTUVNIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9WRVJCT1NFX0JPT1RVUD15CkNPTkZJR19F
QVJMWV9QUklOVEs9eQojIENPTkZJR19FQVJMWV9QUklOVEtfREJHUCBpcyBub3Qgc2V0CkNPTkZJ
R19ERUJVR19TVEFDS09WRVJGTE9XPXkKIyBDT05GSUdfREVCVUdfU1RBQ0tfVVNBR0UgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19QRVJfQ1BVX01BUFMgaXMgbm90IHNldAojIENPTkZJR19YODZf
UFREVU1QIGlzIG5vdCBzZXQKQ09ORklHX0RFQlVHX1JPREFUQT15CiMgQ09ORklHX0RFQlVHX1JP
REFUQV9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTlhfVEVTVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lPTU1VX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfSU9NTVVfU1RSRVNTIGlzIG5v
dCBzZXQKQ09ORklHX0hBVkVfTU1JT1RSQUNFX1NVUFBPUlQ9eQpDT05GSUdfSU9fREVMQVlfVFlQ
RV8wWDgwPTAKQ09ORklHX0lPX0RFTEFZX1RZUEVfMFhFRD0xCkNPTkZJR19JT19ERUxBWV9UWVBF
X1VERUxBWT0yCkNPTkZJR19JT19ERUxBWV9UWVBFX05PTkU9MwpDT05GSUdfSU9fREVMQVlfMFg4
MD15CiMgQ09ORklHX0lPX0RFTEFZXzBYRUQgaXMgbm90IHNldAojIENPTkZJR19JT19ERUxBWV9V
REVMQVkgaXMgbm90IHNldAojIENPTkZJR19JT19ERUxBWV9OT05FIGlzIG5vdCBzZXQKQ09ORklH
X0RFRkFVTFRfSU9fREVMQVlfVFlQRT0wCiMgQ09ORklHX0NQQV9ERUJVRyBpcyBub3Qgc2V0CkNP
TkZJR19PUFRJTUlaRV9JTkxJTklORz15CiMgQ09ORklHX0RFQlVHX1NUUklDVF9VU0VSX0NPUFlf
Q0hFQ0tTIGlzIG5vdCBzZXQKCiMKIyBTZWN1cml0eSBvcHRpb25zCiMKIyBDT05GSUdfS0VZUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFQ1VSSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VDVVJJVFlG
UyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU0VMSU5VWCBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU01BQ0sgaXMgbm90IHNldAojIENPTkZJR19ERUZB
VUxUX1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX0RB
Qz15CkNPTkZJR19ERUZBVUxUX1NFQ1VSSVRZPSIiCiMgQ09ORklHX0NSWVBUTyBpcyBub3Qgc2V0
CkNPTkZJR19IQVZFX0tWTT15CiMgQ09ORklHX1ZJUlRVQUxJWkFUSU9OIGlzIG5vdCBzZXQKIyBD
T05GSUdfQklOQVJZX1BSSU5URiBpcyBub3Qgc2V0CgojCiMgTGlicmFyeSByb3V0aW5lcwojCkNP
TkZJR19CSVRSRVZFUlNFPXkKQ09ORklHX0dFTkVSSUNfRklORF9GSVJTVF9CSVQ9eQpDT05GSUdf
R0VORVJJQ19GSU5EX05FWFRfQklUPXkKQ09ORklHX0dFTkVSSUNfRklORF9MQVNUX0JJVD15CiMg
Q09ORklHX0NSQ19DQ0lUVCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSQzE2IGlzIG5vdCBzZXQKQ09O
RklHX0NSQ19UMTBESUY9eQpDT05GSUdfQ1JDX0lUVV9UPXkKQ09ORklHX0NSQzMyPXkKIyBDT05G
SUdfQ1JDNyBpcyBub3Qgc2V0CiMgQ09ORklHX0xJQkNSQzMyQyBpcyBub3Qgc2V0CkNPTkZJR19I
QVNfSU9NRU09eQpDT05GSUdfSEFTX0lPUE9SVD15CkNPTkZJR19IQVNfRE1BPXkKQ09ORklHX05M
QVRUUj15Cg==

--MP_/u_SV8xq8+sr1ZS8=B1Xu=eF--
