Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZL3JE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZL3JE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZL3JE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:04:57 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:37291 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZL3JEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:04:54 -0500
Message-ID: <4B3B177E.60103@pardus.org.tr>
Date: Wed, 30 Dec 2009 11:03:58 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Disabling IRQ #20 problem with JMicron SATA-PATA Controller
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I have a new box with Asus P6T-SE board and Intel i7-920 nehalem cpu. The board has a JMicron® JMB363 PATA and SATA controller. When the controller is enabled and set to AHCI mode in BIOS, the system slows down dramatically after disabling IRQ #20.

I'm using 2.6.30.9.

I'm posting full dmesg, thanks:

Dec 28 11:32:07 redd kernel: klogd 1.5.0, log source = /proc/kmsg started.
Dec 28 11:32:07 redd kernel: Cannot find map file.
Dec 28 11:32:07 redd kernel: Loaded 55968 symbols from 40 modules.
Dec 28 11:32:07 redd kernel: [    0.000000] Initializing cgroup subsys cpuset
Dec 28 11:32:07 redd kernel: [    0.000000] Initializing cgroup subsys cpu
Dec 28 11:32:07 redd kernel: [    0.000000] Linux version 2.6.30.9-128 (pardus@buildfarm) (gcc version 4.3.3 (Pardus Linux) ) #1 SMP Fri Dec 11 10:08:05 EET 2009
Dec 28 11:32:07 redd kernel: [    0.000000] KERNEL supported cpus:
Dec 28 11:32:07 redd kernel: [    0.000000]   Intel GenuineIntel
Dec 28 11:32:07 redd kernel: [    0.000000]   AMD AuthenticAMD
Dec 28 11:32:07 redd kernel: [    0.000000]   NSC Geode by NSC
Dec 28 11:32:07 redd kernel: [    0.000000]   Cyrix CyrixInstead
Dec 28 11:32:07 redd kernel: [    0.000000]   Centaur CentaurHauls
Dec 28 11:32:07 redd kernel: [    0.000000]   Transmeta GenuineTMx86
Dec 28 11:32:07 redd kernel: [    0.000000]   Transmeta TransmetaCPU
Dec 28 11:32:07 redd kernel: [    0.000000]   UMC UMC UMC UMC
Dec 28 11:32:07 redd kernel: [    0.000000] BIOS-provided physical RAM map:
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 00000000000e4c00 - 0000000000100000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007f780000 (usable)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 000000007f780000 - 000000007f798000 (ACPI data)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 000000007f798000 - 000000007f7dc000 (ACPI NVS)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 000000007f7dc000 - 0000000080000000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000] DMI 2.5 present.
Dec 28 11:32:07 redd kernel: [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
Dec 28 11:32:07 redd kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000] last_pfn = 0x7f780 max_arch_pfn = 0x100000
Dec 28 11:32:07 redd kernel: [    0.000000] MTRR default type: uncachable
Dec 28 11:32:07 redd kernel: [    0.000000] MTRR fixed ranges enabled:
Dec 28 11:32:07 redd kernel: [    0.000000]   00000-9FFFF write-back
Dec 28 11:32:07 redd kernel: [    0.000000]   A0000-BFFFF uncachable
Dec 28 11:32:07 redd kernel: [    0.000000]   C0000-E3FFF write-protect
Dec 28 11:32:07 redd kernel: [    0.000000]   E4000-EBFFF write-through
Dec 28 11:32:07 redd kernel: [    0.000000]   EC000-FFFFF write-protect
Dec 28 11:32:07 redd kernel: [    0.000000] MTRR variable ranges enabled:
Dec 28 11:32:07 redd kernel: [    0.000000]   0 base 000000000 mask F80000000 write-back
Dec 28 11:32:07 redd kernel: [    0.000000]   1 base 07F800000 mask FFF800000 uncachable
Dec 28 11:32:07 redd kernel: [    0.000000]   2 disabled
Dec 28 11:32:07 redd kernel: [    0.000000]   3 disabled
Dec 28 11:32:07 redd kernel: [    0.000000]   4 disabled
Dec 28 11:32:07 redd kernel: [    0.000000]   5 disabled
Dec 28 11:32:07 redd kernel: [    0.000000]   6 disabled
Dec 28 11:32:07 redd kernel: [    0.000000]   7 disabled
Dec 28 11:32:07 redd kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [    0.000000] Scanning 0 areas for low memory corruption
Dec 28 11:32:07 redd kernel: [    0.000000] modified physical RAM map:
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 00000000000e4c00 - 0000000000100000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 0000000000100000 - 000000007f780000 (usable)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 000000007f780000 - 000000007f798000 (ACPI data)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 000000007f798000 - 000000007f7dc000 (ACPI NVS)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 000000007f7dc000 - 0000000080000000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
Dec 28 11:32:07 redd kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
Dec 28 11:32:07 redd kernel: [    0.000000]  0000000000 - 0000400000 page 4k
Dec 28 11:32:07 redd kernel: [    0.000000]  0000400000 - 0037400000 page 2M
Dec 28 11:32:07 redd kernel: [    0.000000]  0037400000 - 00377fe000 page 4k
Dec 28 11:32:07 redd kernel: [    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
Dec 28 11:32:07 redd kernel: [    0.000000] RAMDISK: 37b18000 - 37fef34e
Dec 28 11:32:07 redd kernel: [    0.000000] Allocated new RAMDISK: 0070b000 - 00be234e
Dec 28 11:32:07 redd kernel: [    0.000000] Move RAMDISK from 0000000037b18000 - 0000000037fef34d to 0070b000 - 00be234d
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: RSDP 000fb250 00014 (v00 ACPIAM)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: RSDT 7f780000 00044 (v01 071409 RSDT1603 20090714 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: FACP 7f780200 00084 (v01 071409 FACP1603 20090714 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: DSDT 7f7804b0 0C31A (v01  A1279 A1279001 00000001 INTL 20060113)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: FACS 7f798000 00040
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: APIC 7f780390 000D8 (v01 071409 APIC1603 20090714 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: MCFG 7f780470 0003C (v01 071409 OEMMCFG  20090714 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: OEMB 7f798040 00072 (v01 071409 OEMB1603 20090714 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: HPET 7f78f4b0 00038 (v01 071409 OEMHPET  20090714 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: DMAR 7f7980c0 00138 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: OSFR 7f78f4f0 000B0 (v01 071409 OEMOSFR  20090714 MSFT 00000097)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: SSDT 7f79a280 0249F (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Dec 28 11:32:07 redd kernel: [    0.000000] 1151MB HIGHMEM available.
Dec 28 11:32:07 redd kernel: [    0.000000] 887MB LOWMEM available.
Dec 28 11:32:07 redd kernel: [    0.000000]   mapped low ram: 0 - 377fe000
Dec 28 11:32:07 redd kernel: [    0.000000]   low ram: 0 - 377fe000
Dec 28 11:32:07 redd kernel: [    0.000000]   node 0 low ram: 00000000 - 377fe000
Dec 28 11:32:07 redd kernel: [    0.000000]   node 0 bootmap 00011000 - 00017f00
Dec 28 11:32:07 redd kernel: [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
Dec 28 11:32:07 redd kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Dec 28 11:32:07 redd kernel: [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Dec 28 11:32:07 redd kernel: [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
Dec 28 11:32:07 redd kernel: [    0.000000]   #3 [0000100000 - 0000706fc4]    TEXT DATA BSS ==> [0000100000 - 0000706fc4]
Dec 28 11:32:07 redd kernel: [    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
Dec 28 11:32:07 redd kernel: [    0.000000]   #5 [0000707000 - 000070a228]              BRK ==> [0000707000 - 000070a228]
Dec 28 11:32:07 redd kernel: [    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
Dec 28 11:32:07 redd kernel: [    0.000000]   #7 [000070b000 - 0000be234e]      NEW RAMDISK ==> [000070b000 - 0000be234e]
Dec 28 11:32:07 redd kernel: [    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
Dec 28 11:32:07 redd kernel: [    0.000000] found SMP MP-table at [c00ff780] ff780
Dec 28 11:32:07 redd kernel: [    0.000000] Zone PFN ranges:
Dec 28 11:32:07 redd kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Dec 28 11:32:07 redd kernel: [    0.000000]   Normal   0x00001000 -> 0x000377fe
Dec 28 11:32:07 redd kernel: [    0.000000]   HighMem  0x000377fe -> 0x0007f780
Dec 28 11:32:07 redd kernel: [    0.000000] Movable zone start PFN for each node
Dec 28 11:32:07 redd kernel: [    0.000000] early_node_map[2] active PFN ranges
Dec 28 11:32:07 redd kernel: [    0.000000]     0: 0x00000010 -> 0x0000009e
Dec 28 11:32:07 redd kernel: [    0.000000]     0: 0x00000100 -> 0x0007f780
Dec 28 11:32:07 redd kernel: [    0.000000] On node 0 totalpages: 521998
Dec 28 11:32:07 redd kernel: [    0.000000] free_area_init_node: node 0, pgdat c059e6a0, node_mem_map c1000200
Dec 28 11:32:07 redd kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Dec 28 11:32:07 redd kernel: [    0.000000]   DMA zone: 0 pages reserved
Dec 28 11:32:07 redd kernel: [    0.000000]   DMA zone: 3950 pages, LIFO batch:0
Dec 28 11:32:07 redd kernel: [    0.000000]   Normal zone: 1744 pages used for memmap
Dec 28 11:32:07 redd kernel: [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
Dec 28 11:32:07 redd kernel: [    0.000000]   HighMem zone: 2304 pages used for memmap
Dec 28 11:32:07 redd kernel: [    0.000000]   HighMem zone: 292482 pages, LIFO batch:31
Dec 28 11:32:07 redd kernel: [    0.000000] Using APIC driver default
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x808
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
Dec 28 11:32:07 redd kernel: [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
Dec 28 11:32:07 redd kernel: [    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: IRQ0 used by override.
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: IRQ2 used by override.
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: IRQ9 used by override.
Dec 28 11:32:07 redd kernel: [    0.000000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
Dec 28 11:32:07 redd kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Dec 28 11:32:07 redd kernel: [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
Dec 28 11:32:07 redd kernel: [    0.000000] SMP: Allowing 16 CPUs, 8 hotplug CPUs
Dec 28 11:32:07 redd kernel: [    0.000000] nr_irqs_gsi: 48
Dec 28 11:32:07 redd kernel: [    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
Dec 28 11:32:07 redd kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Dec 28 11:32:07 redd kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e5000
Dec 28 11:32:07 redd kernel: [    0.000000] PM: Registered nosave memory: 00000000000e5000 - 0000000000100000
Dec 28 11:32:07 redd kernel: [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
Dec 28 11:32:07 redd kernel: [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:16 nr_node_ids:1
Dec 28 11:32:07 redd kernel: [    0.000000] PERCPU: Embedded 12 pages at c1ffa000, static data 26972 bytes
Dec 28 11:32:07 redd kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517918
Dec 28 11:32:07 redd kernel: [    0.000000] Kernel command line: root=LABEL=PARDUS_ROOT splash=silent quiet vga=0x317 resume=/dev/sda6
Dec 28 11:32:07 redd kernel: [    0.000000] bootsplash: silent mode.
Dec 28 11:32:07 redd kernel: [    0.000000] Enabling fast FPU save and restore... done.
Dec 28 11:32:07 redd kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Dec 28 11:32:07 redd kernel: [    0.000000] Initializing CPU#0
Dec 28 11:32:07 redd kernel: [    0.000000] NR_IRQS:1280
Dec 28 11:32:07 redd kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Dec 28 11:32:07 redd kernel: [    0.000000] Fast TSC calibration using PIT
Dec 28 11:32:07 redd kernel: [    0.000000] Detected 2672.198 MHz processor.
Dec 28 11:32:07 redd kernel: [   51.260525] Console: colour dummy device 80x25
Dec 28 11:32:07 redd kernel: [   51.260527] console [tty0] enabled
Dec 28 11:32:07 redd kernel: [   51.260609] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Dec 28 11:32:07 redd kernel: [   51.260793] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Dec 28 11:32:07 redd kernel: [   51.264788] allocated 10441920 bytes of page_cgroup
Dec 28 11:32:07 redd kernel: [   51.264790] please try cgroup_disable=memory option if you don't want
Dec 28 11:32:07 redd kernel: [   51.273552] Initializing HighMem for node 0 (000377fe:0007f780)
Dec 28 11:32:07 redd kernel: [   51.314052] Memory: 2047636k/2088448k available (3093k kernel code, 39296k reserved, 1849k data, 448k init, 1179144k highmem)
Dec 28 11:32:07 redd kernel: [   51.314057] virtual kernel memory layout:
Dec 28 11:32:07 redd kernel: [   51.314058]     fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
Dec 28 11:32:07 redd kernel: [   51.314058]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Dec 28 11:32:07 redd kernel: [   51.314059]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Dec 28 11:32:07 redd kernel: [   51.314060]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Dec 28 11:32:07 redd kernel: [   51.314061]       .init : 0xc05db000 - 0xc064b000   ( 448 kB)
Dec 28 11:32:07 redd kernel: [   51.314061]       .data : 0xc04055c3 - 0xc05d3c6c   (1849 kB)
Dec 28 11:32:07 redd kernel: [   51.314062]       .text : 0xc0100000 - 0xc04055c3   (3093 kB)
Dec 28 11:32:07 redd kernel: [   51.314064] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Dec 28 11:32:07 redd kernel: [   51.314096] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
Dec 28 11:32:07 redd kernel: [   51.314193] hpet clockevent registered
Dec 28 11:32:07 redd kernel: [   51.314197] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Dec 28 11:32:07 redd kernel: [   51.314201] Calibrating delay loop (skipped), value calculated using timer frequency.. 5344.39 BogoMIPS (lpj=2672198)
Dec 28 11:32:07 redd kernel: [   51.314212] Security Framework initialized
Dec 28 11:32:07 redd kernel: [   51.314218] Mount-cache hash table entries: 512
Dec 28 11:32:07 redd kernel: [   51.314304] Initializing cgroup subsys ns
Dec 28 11:32:07 redd kernel: [   51.314306] Initializing cgroup subsys cpuacct
Dec 28 11:32:07 redd kernel: [   51.314310] Initializing cgroup subsys memory
Dec 28 11:32:07 redd kernel: [   51.314313] Initializing cgroup subsys devices
Dec 28 11:32:07 redd kernel: [   51.314315] Initializing cgroup subsys freezer
Dec 28 11:32:07 redd kernel: [   51.314326] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.314327] CPU: Processor Core ID: 0
Dec 28 11:32:07 redd kernel: [   51.314330] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.314331] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.314332] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.314335] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.314340] Intel machine check reporting enabled on CPU#0.
Dec 28 11:32:07 redd kernel: [   51.314341] using mwait in idle threads.
Dec 28 11:32:07 redd kernel: [   51.314346] Checking 'hlt' instruction... OK.
Dec 28 11:32:07 redd kernel: [   51.318995] ACPI: Core revision 20090320
Dec 28 11:32:07 redd kernel: [   51.334983] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Dec 28 11:32:07 redd kernel: [   51.344980] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.446238] Booting processor 1 APIC 0x2 ip 0x6000
Dec 28 11:32:07 redd kernel: [   51.456608] Initializing CPU#1
Dec 28 11:32:07 redd kernel: [   51.517120] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672338)
Dec 28 11:32:07 redd kernel: [   51.517126] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.517127] CPU: Processor Core ID: 1
Dec 28 11:32:07 redd kernel: [   51.517129] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.517130] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.517131] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.517134] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.517138] Intel machine check reporting enabled on CPU#1.
Dec 28 11:32:07 redd kernel: [   51.517841] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [   51.518533] CPU1: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.518543] Skipping synchronization checks as TSC is reliable.
Dec 28 11:32:07 redd kernel: [   51.518629] Booting processor 2 APIC 0x4 ip 0x6000
Dec 28 11:32:07 redd kernel: [   51.528983] Initializing CPU#2
Dec 28 11:32:07 redd kernel: [   51.589084] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337)
Dec 28 11:32:07 redd kernel: [   51.589091] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.589092] CPU: Processor Core ID: 2
Dec 28 11:32:07 redd kernel: [   51.589093] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.589095] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.589096] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.589098] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.589102] Intel machine check reporting enabled on CPU#2.
Dec 28 11:32:07 redd kernel: [   51.589806] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [   51.590423] CPU2: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.590436] Skipping synchronization checks as TSC is reliable.
Dec 28 11:32:07 redd kernel: [   51.590522] Booting processor 3 APIC 0x6 ip 0x6000
Dec 28 11:32:07 redd kernel: [   51.600875] Initializing CPU#3
Dec 28 11:32:07 redd kernel: [   51.661049] Calibrating delay using timer specific routine.. 5344.68 BogoMIPS (lpj=2672340)
Dec 28 11:32:07 redd kernel: [   51.661055] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.661056] CPU: Processor Core ID: 3
Dec 28 11:32:07 redd kernel: [   51.661058] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.661059] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.661060] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.661063] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.661067] Intel machine check reporting enabled on CPU#3.
Dec 28 11:32:07 redd kernel: [   51.661772] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [   51.662416] CPU3: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.662429] Skipping synchronization checks as TSC is reliable.
Dec 28 11:32:07 redd kernel: [   51.662520] Booting processor 4 APIC 0x1 ip 0x6000
Dec 28 11:32:07 redd kernel: [   51.672873] Initializing CPU#4
Dec 28 11:32:07 redd kernel: [   51.733014] Calibrating delay using timer specific routine.. 5344.66 BogoMIPS (lpj=2672332)
Dec 28 11:32:07 redd kernel: [   51.733021] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.733022] CPU: Processor Core ID: 0
Dec 28 11:32:07 redd kernel: [   51.733024] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.733026] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.733027] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.733030] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.733035] Intel machine check reporting enabled on CPU#4.
Dec 28 11:32:07 redd kernel: [   51.733874] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [   51.734789] CPU4: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.734805] Skipping synchronization checks as TSC is reliable.
Dec 28 11:32:07 redd kernel: [   51.734906] Booting processor 5 APIC 0x3 ip 0x6000
Dec 28 11:32:07 redd kernel: [   51.745259] Initializing CPU#5
Dec 28 11:32:07 redd kernel: [   51.805978] Calibrating delay using timer specific routine.. 5344.68 BogoMIPS (lpj=2672344)
Dec 28 11:32:07 redd kernel: [   51.805984] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.805985] CPU: Processor Core ID: 1
Dec 28 11:32:07 redd kernel: [   51.805987] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.805988] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.805989] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.805992] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.805996] Intel machine check reporting enabled on CPU#5.
Dec 28 11:32:07 redd kernel: [   51.806920] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [   51.807802] CPU5: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.807817] Skipping synchronization checks as TSC is reliable.
Dec 28 11:32:07 redd kernel: [   51.807905] Booting processor 6 APIC 0x5 ip 0x6000
Dec 28 11:32:07 redd kernel: [   51.818259] Initializing CPU#6
Dec 28 11:32:07 redd kernel: [   51.878943] Calibrating delay using timer specific routine.. 5344.68 BogoMIPS (lpj=2672340)
Dec 28 11:32:07 redd kernel: [   51.878949] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.878950] CPU: Processor Core ID: 2
Dec 28 11:32:07 redd kernel: [   51.878951] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.878953] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.878954] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.878956] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.878960] Intel machine check reporting enabled on CPU#6.
Dec 28 11:32:07 redd kernel: [   51.879878] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [   51.880800] CPU6: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.880814] Skipping synchronization checks as TSC is reliable.
Dec 28 11:32:07 redd kernel: [   51.880902] Booting processor 7 APIC 0x7 ip 0x6000
Dec 28 11:32:07 redd kernel: [   51.891256] Initializing CPU#7
Dec 28 11:32:07 redd kernel: [   51.951907] Calibrating delay using timer specific routine.. 5344.68 BogoMIPS (lpj=2672341)
Dec 28 11:32:07 redd kernel: [   51.951913] CPU: Physical Processor ID: 0
Dec 28 11:32:07 redd kernel: [   51.951914] CPU: Processor Core ID: 3
Dec 28 11:32:07 redd kernel: [   51.951916] CPU: L1 I cache: 32K, L1 D cache: 32K
Dec 28 11:32:07 redd kernel: [   51.951917] CPU: L2 cache: 256K
Dec 28 11:32:07 redd kernel: [   51.951918] CPU: L3 cache: 8192K
Dec 28 11:32:07 redd kernel: [   51.951920] Intel machine check architecture supported.
Dec 28 11:32:07 redd kernel: [   51.951924] Intel machine check reporting enabled on CPU#7.
Dec 28 11:32:07 redd kernel: [   51.952831] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
Dec 28 11:32:07 redd kernel: [   51.953697] CPU7: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
Dec 28 11:32:07 redd kernel: [   51.953713] Skipping synchronization checks as TSC is reliable.
Dec 28 11:32:07 redd kernel: [   51.953751] Brought up 8 CPUs
Dec 28 11:32:07 redd kernel: [   51.953753] Total of 8 processors activated (42757.14 BogoMIPS).
Dec 28 11:32:07 redd kernel: [   51.953770] CPU0 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953772]  domain 0: span 0,4 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953774]   groups: 0 4
Dec 28 11:32:07 redd kernel: [   51.953777]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953778]    groups: 0,4 1,5 2,6 3,7
Dec 28 11:32:07 redd kernel: [   51.953782] CPU1 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953784]  domain 0: span 1,5 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953785]   groups: 1 5
Dec 28 11:32:07 redd kernel: [   51.953787]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953789]    groups: 1,5 2,6 3,7 0,4
Dec 28 11:32:07 redd kernel: [   51.953792] CPU2 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953794]  domain 0: span 2,6 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953795]   groups: 2 6
Dec 28 11:32:07 redd kernel: [   51.953797]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953799]    groups: 2,6 3,7 0,4 1,5
Dec 28 11:32:07 redd kernel: [   51.953802] CPU3 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953804]  domain 0: span 3,7 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953805]   groups: 3 7
Dec 28 11:32:07 redd kernel: [   51.953807]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953809]    groups: 3,7 0,4 1,5 2,6
Dec 28 11:32:07 redd kernel: [   51.953812] CPU4 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953814]  domain 0: span 0,4 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953815]   groups: 4 0
Dec 28 11:32:07 redd kernel: [   51.953818]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953819]    groups: 0,4 1,5 2,6 3,7
Dec 28 11:32:07 redd kernel: [   51.953823] CPU5 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953824]  domain 0: span 1,5 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953825]   groups: 5 1
Dec 28 11:32:07 redd kernel: [   51.953828]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953829]    groups: 1,5 2,6 3,7 0,4
Dec 28 11:32:07 redd kernel: [   51.953833] CPU6 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953834]  domain 0: span 2,6 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953835]   groups: 6 2
Dec 28 11:32:07 redd kernel: [   51.953838]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953839]    groups: 2,6 3,7 0,4 1,5
Dec 28 11:32:07 redd kernel: [   51.953843] CPU7 attaching sched-domain:
Dec 28 11:32:07 redd kernel: [   51.953844]  domain 0: span 3,7 level SIBLING
Dec 28 11:32:07 redd kernel: [   51.953845]   groups: 7 3
Dec 28 11:32:07 redd kernel: [   51.953848]   domain 1: span 0-7 level MC
Dec 28 11:32:07 redd kernel: [   51.953849]    groups: 3,7 0,4 1,5 2,6
Dec 28 11:32:07 redd kernel: [   51.954169] net_namespace: 1088 bytes
Dec 28 11:32:07 redd kernel: [   51.954206] Booting paravirtualized kernel on bare hardware
Dec 28 11:32:07 redd kernel: [   51.954333] regulator: core version 0.5
Dec 28 11:32:07 redd kernel: [   51.954373] NET: Registered protocol family 16
Dec 28 11:32:07 redd kernel: [   51.954442] EISA bus registered
Dec 28 11:32:07 redd kernel: [   51.954451] ACPI: bus type pci registered
Dec 28 11:32:07 redd kernel: [   51.954498] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Dec 28 11:32:07 redd kernel: [   51.954500] PCI: Not using MMCONFIG.
Dec 28 11:32:07 redd kernel: [   51.954592] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=8
Dec 28 11:32:07 redd kernel: [   51.954594] PCI: Using configuration type 1 for base access
Dec 28 11:32:07 redd kernel: [   51.955074] bio: create slab <bio-0> at 0
Dec 28 11:32:07 redd kernel: [   51.955910] ACPI: EC: Look up EC in DSDT
Dec 28 11:32:07 redd kernel: [   51.988144] ACPI: Interpreter enabled
Dec 28 11:32:07 redd kernel: [   51.988150] ACPI: (supports S0 S1 S3 S4 S5)
Dec 28 11:32:07 redd kernel: [   51.988168] ACPI: Using IOAPIC for interrupt routing
Dec 28 11:32:07 redd kernel: [   51.988221] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Dec 28 11:32:07 redd kernel: [   51.990647] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
Dec 28 11:32:07 redd kernel: [   51.990649] PCI: Using MMCONFIG for extended config space
Dec 28 11:32:07 redd kernel: [   51.999109] ACPI: No dock devices found.
Dec 28 11:32:07 redd kernel: [   51.999178] ACPI: PCI Root Bridge [PCI0] (0000:00)
Dec 28 11:32:07 redd kernel: [   51.999241] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   51.999244] pci 0000:00:00.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   51.999296] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   51.999299] pci 0000:00:01.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   51.999349] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   51.999352] pci 0000:00:03.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   51.999403] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   51.999406] pci 0000:00:07.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   51.999612] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
Dec 28 11:32:07 redd kernel: [   51.999674] pci 0000:00:1a.1: reg 20 io port: [0xa880-0xa89f]
Dec 28 11:32:07 redd kernel: [   51.999735] pci 0000:00:1a.2: reg 20 io port: [0xac00-0xac1f]
Dec 28 11:32:07 redd kernel: [   51.999800] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf7fff000-0xf7fff3ff]
Dec 28 11:32:07 redd kernel: [   51.999849] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   51.999852] pci 0000:00:1a.7: PME# disabled
Dec 28 11:32:07 redd kernel: [   51.999890] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7ff8000-0xf7ffbfff]
Dec 28 11:32:07 redd kernel: [   51.999927] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   51.999930] pci 0000:00:1b.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   51.999979] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   51.999982] pci 0000:00:1c.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.000034] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   52.000037] pci 0000:00:1c.2: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.000088] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   52.000091] pci 0000:00:1c.3: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.000141] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   52.000144] pci 0000:00:1c.4: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.000192] pci 0000:00:1d.0: reg 20 io port: [0xa080-0xa09f]
Dec 28 11:32:07 redd kernel: [   52.000253] pci 0000:00:1d.1: reg 20 io port: [0xa400-0xa41f]
Dec 28 11:32:07 redd kernel: [   52.000314] pci 0000:00:1d.2: reg 20 io port: [0xa480-0xa49f]
Dec 28 11:32:07 redd kernel: [   52.000378] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7ffe000-0xf7ffe3ff]
Dec 28 11:32:07 redd kernel: [   52.000427] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   52.000431] pci 0000:00:1d.7: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.000536] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
Dec 28 11:32:07 redd kernel: [   52.000540] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
Dec 28 11:32:07 redd kernel: [   52.000543] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
Dec 28 11:32:07 redd kernel: [   52.000547] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
Dec 28 11:32:07 redd kernel: [   52.000603] pci 0000:00:1f.2: reg 10 io port: [0x9c00-0x9c07]
Dec 28 11:32:07 redd kernel: [   52.000608] pci 0000:00:1f.2: reg 14 io port: [0x9880-0x9883]
Dec 28 11:32:07 redd kernel: [   52.000612] pci 0000:00:1f.2: reg 18 io port: [0x9800-0x9807]
Dec 28 11:32:07 redd kernel: [   52.000617] pci 0000:00:1f.2: reg 1c io port: [0x9480-0x9483]
Dec 28 11:32:07 redd kernel: [   52.000622] pci 0000:00:1f.2: reg 20 io port: [0x9400-0x941f]
Dec 28 11:32:07 redd kernel: [   52.000627] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf7ffc000-0xf7ffc7ff]
Dec 28 11:32:07 redd kernel: [   52.000655] pci 0000:00:1f.2: PME# supported from D3hot
Dec 28 11:32:07 redd kernel: [   52.000658] pci 0000:00:1f.2: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.000682] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf7ffd000-0xf7ffd0ff]
Dec 28 11:32:07 redd kernel: [   52.000694] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
Dec 28 11:32:07 redd kernel: [   52.000768] pci 0000:02:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
Dec 28 11:32:07 redd kernel: [   52.000779] pci 0000:02:00.0: reg 14 64bit mmio: [0xc0000000-0xdfffffff]
Dec 28 11:32:07 redd kernel: [   52.000789] pci 0000:02:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
Dec 28 11:32:07 redd kernel: [   52.000795] pci 0000:02:00.0: reg 24 io port: [0xbc00-0xbc7f]
Dec 28 11:32:07 redd kernel: [   52.000801] pci 0000:02:00.0: reg 30 32bit mmio: [0xfbb80000-0xfbbfffff]
Dec 28 11:32:07 redd kernel: [   52.001964] pci 0000:00:03.0: bridge io port: [0xb000-0xbfff]
Dec 28 11:32:07 redd kernel: [   52.001968] pci 0000:00:03.0: bridge 32bit mmio: [0xf8000000-0xfbbfffff]
Dec 28 11:32:07 redd kernel: [   52.001975] pci 0000:00:03.0: bridge 64bit mmio pref: [0xc0000000-0xdfffffff]
Dec 28 11:32:07 redd kernel: [   52.002040] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf6f00000-0xf6ffffff]
Dec 28 11:32:07 redd kernel: [   52.002082] pci 0000:06:00.0: reg 10 io port: [0xe800-0xe8ff]
Dec 28 11:32:07 redd kernel: [   52.002100] pci 0000:06:00.0: reg 18 64bit mmio: [0xfbeff000-0xfbefffff]
Dec 28 11:32:07 redd kernel: [   52.002113] pci 0000:06:00.0: reg 20 64bit mmio: [0xf6ef0000-0xf6efffff]
Dec 28 11:32:07 redd kernel: [   52.002120] pci 0000:06:00.0: reg 30 32bit mmio: [0xfbec0000-0xfbedffff]
Dec 28 11:32:07 redd kernel: [   52.002157] pci 0000:06:00.0: supports D1 D2
Dec 28 11:32:07 redd kernel: [   52.002158] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   52.002163] pci 0000:06:00.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.003990] pci 0000:00:1c.2: bridge io port: [0xe000-0xefff]
Dec 28 11:32:07 redd kernel: [   52.003993] pci 0000:00:1c.2: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
Dec 28 11:32:07 redd kernel: [   52.003999] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf6e00000-0xf6efffff]
Dec 28 11:32:07 redd kernel: [   52.004047] pci 0000:05:00.0: reg 10 64bit mmio: [0xfbdff000-0xfbdff7ff]
Dec 28 11:32:07 redd kernel: [   52.004054] pci 0000:05:00.0: reg 18 io port: [0xd800-0xd8ff]
Dec 28 11:32:07 redd kernel: [   52.004108] pci 0000:05:00.0: supports D2
Dec 28 11:32:07 redd kernel: [   52.004109] pci 0000:05:00.0: PME# supported from D2 D3hot D3cold
Dec 28 11:32:07 redd kernel: [   52.004114] pci 0000:05:00.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.005993] pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
Dec 28 11:32:07 redd kernel: [   52.005997] pci 0000:00:1c.3: bridge 32bit mmio: [0xfbd00000-0xfbdfffff]
Dec 28 11:32:07 redd kernel: [   52.006084] pci 0000:04:00.0: reg 24 32bit mmio: [0xfbcfe000-0xfbcfffff]
Dec 28 11:32:07 redd kernel: [   52.006092] pci 0000:04:00.0: reg 30 32bit mmio: [0xfbce0000-0xfbceffff]
Dec 28 11:32:07 redd kernel: [   52.006122] pci 0000:04:00.0: PME# supported from D3hot
Dec 28 11:32:07 redd kernel: [   52.006126] pci 0000:04:00.0: PME# disabled
Dec 28 11:32:07 redd kernel: [   52.006175] pci 0000:04:00.1: reg 10 io port: [0xcc00-0xcc07]
Dec 28 11:32:07 redd kernel: [   52.006183] pci 0000:04:00.1: reg 14 io port: [0xc880-0xc883]
Dec 28 11:32:07 redd kernel: [   52.006191] pci 0000:04:00.1: reg 18 io port: [0xc800-0xc807]
Dec 28 11:32:07 redd kernel: [   52.006199] pci 0000:04:00.1: reg 1c io port: [0xc480-0xc483]
Dec 28 11:32:07 redd kernel: [   52.006208] pci 0000:04:00.1: reg 20 io port: [0xc400-0xc40f]
Dec 28 11:32:07 redd kernel: [   52.006273] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
Dec 28 11:32:07 redd kernel: [   52.006354] pci 0000:00:1c.4: bridge io port: [0xc000-0xcfff]
Dec 28 11:32:07 redd kernel: [   52.006358] pci 0000:00:1c.4: bridge 32bit mmio: [0xfbc00000-0xfbcfffff]
Dec 28 11:32:07 redd kernel: [   52.006403] pci 0000:00:1e.0: transparent bridge
Dec 28 11:32:07 redd kernel: [   52.006436] pci_bus 0000:00: on NUMA node 0
Dec 28 11:32:07 redd kernel: [   52.006442] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Dec 28 11:32:07 redd kernel: [   52.006693] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Dec 28 11:32:07 redd kernel: [   52.006782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
Dec 28 11:32:07 redd kernel: [   52.006839] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
Dec 28 11:32:07 redd kernel: [   52.006895] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
Dec 28 11:32:07 redd kernel: [   52.006952] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
Dec 28 11:32:07 redd kernel: [   52.007013] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
Dec 28 11:32:07 redd kernel: [   52.007068] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
Dec 28 11:32:07 redd kernel: [   52.007123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
Dec 28 11:32:07 redd kernel: [   52.032496] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12 14 *15)
Dec 28 11:32:07 redd kernel: [   52.032622] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
Dec 28 11:32:07 redd kernel: [   52.032747] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
Dec 28 11:32:07 redd kernel: [   52.032873] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 *10 11 12 14 15)
Dec 28 11:32:07 redd kernel: [   52.033000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 *14 15)
Dec 28 11:32:07 redd kernel: [   52.033126] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
Dec 28 11:32:07 redd kernel: [   52.033250] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
Dec 28 11:32:07 redd kernel: [   52.033375] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
Dec 28 11:32:07 redd kernel: [   52.033499] SCSI subsystem initialized
Dec 28 11:32:07 redd kernel: [   52.033558] usbcore: registered new interface driver usbfs
Dec 28 11:32:07 redd kernel: [   52.033568] usbcore: registered new interface driver hub
Dec 28 11:32:07 redd kernel: [   52.033586] usbcore: registered new device driver usb
Dec 28 11:32:07 redd kernel: [   52.033626] PCI: Using ACPI for IRQ routing
Dec 28 11:32:07 redd kernel: [   52.035913] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Dec 28 11:32:07 redd kernel: [   52.035919] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Dec 28 11:32:07 redd kernel: [   52.041913] Switched to high resolution mode on CPU 0
Dec 28 11:32:07 redd kernel: [   52.042286] Switched to high resolution mode on CPU 2
Dec 28 11:32:07 redd kernel: [   52.042315] Switched to high resolution mode on CPU 3
Dec 28 11:32:07 redd kernel: [   52.042357] Switched to high resolution mode on CPU 1
Dec 28 11:32:07 redd kernel: [   52.042736] Switched to high resolution mode on CPU 4
Dec 28 11:32:07 redd kernel: [   52.042744] Switched to high resolution mode on CPU 7
Dec 28 11:32:07 redd kernel: [   52.042776] Switched to high resolution mode on CPU 5
Dec 28 11:32:07 redd kernel: [   52.042808] Switched to high resolution mode on CPU 6
Dec 28 11:32:07 redd kernel: [   52.043911] pnp: PnP ACPI init
Dec 28 11:32:07 redd kernel: [   52.043920] ACPI: bus type pnp registered
Dec 28 11:32:07 redd kernel: [   52.046311] pnp: PnP ACPI: found 16 devices
Dec 28 11:32:07 redd kernel: [   52.046312] ACPI: ACPI bus type pnp unregistered
Dec 28 11:32:07 redd kernel: [   52.046314] PnPBIOS: Disabled by ACPI PNP
Dec 28 11:32:07 redd kernel: [   52.046322] system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046325] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046327] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046329] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046331] system 00:01: iomem range 0xfec8a000-0xfec8afff could not be reserved
Dec 28 11:32:07 redd kernel: [   52.046333] system 00:01: iomem range 0xfed10000-0xfed10fff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046338] system 00:06: ioport range 0x290-0x29f has been reserved
Dec 28 11:32:07 redd kernel: [   52.046341] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
Dec 28 11:32:07 redd kernel: [   52.046343] system 00:07: ioport range 0x800-0x87f has been reserved
Dec 28 11:32:07 redd kernel: [   52.046346] system 00:07: ioport range 0x500-0x57f could not be reserved
Dec 28 11:32:07 redd kernel: [   52.046348] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046350] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046352] system 00:07: iomem range 0xfed40000-0xfed8ffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046356] system 00:0a: iomem range 0xffc00000-0xffdfffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046359] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
Dec 28 11:32:07 redd kernel: [   52.046362] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046365] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
Dec 28 11:32:07 redd kernel: [   52.046369] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
Dec 28 11:32:07 redd kernel: [   52.046371] system 00:0f: iomem range 0xc0000-0xcffff could not be reserved
Dec 28 11:32:07 redd kernel: [   52.046373] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
Dec 28 11:32:07 redd kernel: [   52.046375] system 00:0f: iomem range 0x100000-0x7fffffff could not be reserved
Dec 28 11:32:07 redd kernel: [   52.046377] system 00:0f: iomem range 0xfed90000-0xffffffff could not be reserved
Dec 28 11:32:07 redd kernel: [   52.081087] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Dec 28 11:32:07 redd kernel: [   52.081089] pci 0000:00:01.0:   IO window: disabled
Dec 28 11:32:07 redd kernel: [   52.081092] pci 0000:00:01.0:   MEM window: disabled
Dec 28 11:32:07 redd kernel: [   52.081095] pci 0000:00:01.0:   PREFETCH window: disabled
Dec 28 11:32:07 redd kernel: [   52.081099] pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
Dec 28 11:32:07 redd kernel: [   52.081101] pci 0000:00:03.0:   IO window: 0xb000-0xbfff
Dec 28 11:32:07 redd kernel: [   52.081105] pci 0000:00:03.0:   MEM window: 0xf8000000-0xfbbfffff
Dec 28 11:32:07 redd kernel: [   52.081108] pci 0000:00:03.0:   PREFETCH window: 0x000000c0000000-0x000000dfffffff
Dec 28 11:32:07 redd kernel: [   52.081112] pci 0000:00:07.0: PCI bridge, secondary bus 0000:03
Dec 28 11:32:07 redd kernel: [   52.081114] pci 0000:00:07.0:   IO window: disabled
Dec 28 11:32:07 redd kernel: [   52.081117] pci 0000:00:07.0:   MEM window: disabled
Dec 28 11:32:07 redd kernel: [   52.081120] pci 0000:00:07.0:   PREFETCH window: disabled
Dec 28 11:32:07 redd kernel: [   52.081124] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:07
Dec 28 11:32:07 redd kernel: [   52.081125] pci 0000:00:1c.0:   IO window: disabled
Dec 28 11:32:07 redd kernel: [   52.081129] pci 0000:00:1c.0:   MEM window: disabled
Dec 28 11:32:07 redd kernel: [   52.081132] pci 0000:00:1c.0:   PREFETCH window: 0x000000f6f00000-0x000000f6ffffff
Dec 28 11:32:07 redd kernel: [   52.081137] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:06
Dec 28 11:32:07 redd kernel: [   52.081140] pci 0000:00:1c.2:   IO window: 0xe000-0xefff
Dec 28 11:32:07 redd kernel: [   52.081143] pci 0000:00:1c.2:   MEM window: 0xfbe00000-0xfbefffff
Dec 28 11:32:07 redd kernel: [   52.081147] pci 0000:00:1c.2:   PREFETCH window: 0x000000f6e00000-0x000000f6efffff
Dec 28 11:32:07 redd kernel: [   52.081152] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
Dec 28 11:32:07 redd kernel: [   52.081154] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
Dec 28 11:32:07 redd kernel: [   52.081158] pci 0000:00:1c.3:   MEM window: 0xfbd00000-0xfbdfffff
Dec 28 11:32:07 redd kernel: [   52.081161] pci 0000:00:1c.3:   PREFETCH window: disabled
Dec 28 11:32:07 redd kernel: [   52.081166] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
Dec 28 11:32:07 redd kernel: [   52.081168] pci 0000:00:1c.4:   IO window: 0xc000-0xcfff
Dec 28 11:32:07 redd kernel: [   52.081172] pci 0000:00:1c.4:   MEM window: 0xfbc00000-0xfbcfffff
Dec 28 11:32:07 redd kernel: [   52.081175] pci 0000:00:1c.4:   PREFETCH window: disabled
Dec 28 11:32:07 redd kernel: [   52.081180] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:08
Dec 28 11:32:07 redd kernel: [   52.081181] pci 0000:00:1e.0:   IO window: disabled
Dec 28 11:32:07 redd kernel: [   52.081185] pci 0000:00:1e.0:   MEM window: disabled
Dec 28 11:32:07 redd kernel: [   52.081188] pci 0000:00:1e.0:   PREFETCH window: disabled
Dec 28 11:32:07 redd kernel: [   52.081198] pci 0000:00:01.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081204] pci 0000:00:03.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081209] pci 0000:00:07.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081218] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Dec 28 11:32:07 redd kernel: [   52.081221] pci 0000:00:1c.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081228] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Dec 28 11:32:07 redd kernel: [   52.081231] pci 0000:00:1c.2: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081238] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Dec 28 11:32:07 redd kernel: [   52.081241] pci 0000:00:1c.3: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081246] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Dec 28 11:32:07 redd kernel: [   52.081249] pci 0000:00:1c.4: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081254] pci 0000:00:1e.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.081257] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
Dec 28 11:32:07 redd kernel: [   52.081259] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
Dec 28 11:32:07 redd kernel: [   52.081261] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
Dec 28 11:32:07 redd kernel: [   52.081263] pci_bus 0000:02: resource 1 mem: [0xf8000000-0xfbbfffff]
Dec 28 11:32:07 redd kernel: [   52.081265] pci_bus 0000:02: resource 2 pref mem [0xc0000000-0xdfffffff]
Dec 28 11:32:07 redd kernel: [   52.081267] pci_bus 0000:07: resource 2 pref mem [0xf6f00000-0xf6ffffff]
Dec 28 11:32:07 redd kernel: [   52.081268] pci_bus 0000:06: resource 0 io:  [0xe000-0xefff]
Dec 28 11:32:07 redd kernel: [   52.081270] pci_bus 0000:06: resource 1 mem: [0xfbe00000-0xfbefffff]
Dec 28 11:32:07 redd kernel: [   52.081272] pci_bus 0000:06: resource 2 pref mem [0xf6e00000-0xf6efffff]
Dec 28 11:32:07 redd kernel: [   52.081274] pci_bus 0000:05: resource 0 io:  [0xd000-0xdfff]
Dec 28 11:32:07 redd kernel: [   52.081276] pci_bus 0000:05: resource 1 mem: [0xfbd00000-0xfbdfffff]
Dec 28 11:32:07 redd kernel: [   52.081277] pci_bus 0000:04: resource 0 io:  [0xc000-0xcfff]
Dec 28 11:32:07 redd kernel: [   52.081279] pci_bus 0000:04: resource 1 mem: [0xfbc00000-0xfbcfffff]
Dec 28 11:32:07 redd kernel: [   52.081281] pci_bus 0000:08: resource 3 io:  [0x00-0xffff]
Dec 28 11:32:07 redd kernel: [   52.081283] pci_bus 0000:08: resource 4 mem: [0x000000-0xffffffff]
Dec 28 11:32:07 redd kernel: [   52.081301] NET: Registered protocol family 2
Dec 28 11:32:07 redd kernel: [   52.089944] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Dec 28 11:32:07 redd kernel: [   52.090118] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Dec 28 11:32:07 redd kernel: [   52.090335] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Dec 28 11:32:07 redd kernel: [   52.090441] TCP: Hash tables configured (established 131072 bind 65536)
Dec 28 11:32:07 redd kernel: [   52.090442] TCP reno registered
Dec 28 11:32:07 redd kernel: [   52.092973] NET: Registered protocol family 1
Dec 28 11:32:07 redd kernel: [   52.093003] Unpacking initramfs...
Dec 28 11:32:07 redd kernel: [   52.205198] Freeing initrd memory: 4956k freed
Dec 28 11:32:07 redd kernel: [   52.206258] cpu0(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206268] cpu1(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206280] cpu2(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206290] cpu3(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206300] cpu4(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206311] cpu5(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206322] cpu6(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206339] cpu7(16) debug files 3
Dec 28 11:32:07 redd kernel: [   52.206342] Machine check exception polling timer started.
Dec 28 11:32:07 redd kernel: [   52.206348] cpufreq-nforce2: No nForce2 chipset.
Dec 28 11:32:07 redd kernel: [   52.206492] Scanning for low memory corruption every 60 seconds
Dec 28 11:32:07 redd kernel: [   52.206561] audit: initializing netlink socket (disabled)
Dec 28 11:32:07 redd kernel: [   52.206570] type=2000 audit(1261999826.779:1): initialized
Dec 28 11:32:07 redd kernel: [   52.212495] highmem bounce pool size: 64 pages
Dec 28 11:32:07 redd kernel: [   52.212499] HugeTLB registered 4 MB page size, pre-allocated 0 pages
Dec 28 11:32:07 redd kernel: [   52.213395] VFS: Disk quotas dquot_6.5.2
Dec 28 11:32:07 redd kernel: [   52.213431] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Dec 28 11:32:07 redd kernel: [   52.213700] fuse init (API version 7.11)
Dec 28 11:32:07 redd kernel: [   52.213857] aufs 2-29
Dec 28 11:32:07 redd kernel: [   52.213861] msgmni has been set to 1708
Dec 28 11:32:07 redd kernel: [   52.214129] alg: No test for stdrng (krng)
Dec 28 11:32:07 redd kernel: [   52.214162] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Dec 28 11:32:07 redd kernel: [   52.214164] io scheduler noop registered
Dec 28 11:32:07 redd kernel: [   52.214166] io scheduler anticipatory registered
Dec 28 11:32:07 redd kernel: [   52.214167] io scheduler deadline registered
Dec 28 11:32:07 redd kernel: [   52.214190] io scheduler cfq registered (default)
Dec 28 11:32:07 redd kernel: [   52.214322] pci 0000:02:00.0: Boot video device
Dec 28 11:32:07 redd kernel: [   52.214501] pcieport-driver 0000:00:1c.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.214580] pcieport-driver 0000:00:1c.2: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.214661] pcieport-driver 0000:00:1c.3: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.214739] pcieport-driver 0000:00:1c.4: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   52.214800] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Dec 28 11:32:07 redd kernel: [   52.215023] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Dec 28 11:32:07 redd kernel: [   52.215141] vesafb: framebuffer at 0xf9000000, mapped to 0xf8080000, using 6144k, total 14336k
Dec 28 11:32:07 redd kernel: [   52.215143] vesafb: mode is 1024x768x16, linelength=2048, pages=1
Dec 28 11:32:07 redd kernel: [   52.215145] vesafb: protected mode interface info at c000:ca90
Dec 28 11:32:07 redd kernel: [   52.215146] vesafb: pmi: set display start = c00ccaf3, set palette = c00ccb4e
Dec 28 11:32:07 redd kernel: [   52.215148] vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
Dec 28 11:32:07 redd kernel: [   52.215155] vesafb: scrolling: redraw
Dec 28 11:32:07 redd kernel: [   52.215157] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Dec 28 11:32:07 redd kernel: [   52.215459] bootsplash 3.1.6-2004/03/31: looking for picture...
Dec 28 11:32:07 redd kernel: [   52.222589] bootsplash: silentjpeg size 48668 bytes
Dec 28 11:32:07 redd kernel: [   52.229821] bootsplash: ...found (1024x768, 37132 bytes, v3).
Dec 28 11:32:07 redd kernel: [   52.304441] Console: switching to colour frame buffer device 128x45
Dec 28 11:32:07 redd kernel: [   52.440488] fb0: VESA VGA frame buffer device
Dec 28 11:32:07 redd kernel: [   52.440546] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Dec 28 11:32:07 redd kernel: [   52.440548] ACPI: Power Button [PWRF]
Dec 28 11:32:07 redd kernel: [   52.440587] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
Dec 28 11:32:07 redd kernel: [   52.440589] ACPI: Power Button [PWRB]
Dec 28 11:32:07 redd kernel: [   52.441186] ACPI: SSDT 7f798200 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.441428] processor ACPI_CPU:00: registered as cooling_device0
Dec 28 11:32:07 redd kernel: [   52.441697] ACPI: SSDT 7f798610 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.441930] processor ACPI_CPU:01: registered as cooling_device1
Dec 28 11:32:07 redd kernel: [   52.442210] ACPI: SSDT 7f798a20 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.442442] processor ACPI_CPU:02: registered as cooling_device2
Dec 28 11:32:07 redd kernel: [   52.442724] ACPI: SSDT 7f798e30 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.442957] processor ACPI_CPU:03: registered as cooling_device3
Dec 28 11:32:07 redd kernel: [   52.443234] ACPI: SSDT 7f799240 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.443467] processor ACPI_CPU:04: registered as cooling_device4
Dec 28 11:32:07 redd kernel: [   52.443739] ACPI: SSDT 7f799650 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.443974] processor ACPI_CPU:05: registered as cooling_device5
Dec 28 11:32:07 redd kernel: [   52.444239] ACPI: SSDT 7f799a60 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.444473] processor ACPI_CPU:06: registered as cooling_device6
Dec 28 11:32:07 redd kernel: [   52.444754] ACPI: SSDT 7f799e70 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
Dec 28 11:32:07 redd kernel: [   52.444992] processor ACPI_CPU:07: registered as cooling_device7
Dec 28 11:32:07 redd kernel: [   52.447373] isapnp: Scanning for PnP cards...
Dec 28 11:32:07 redd kernel: [   52.759389] isapnp: No Plug & Play device found
Dec 28 11:32:07 redd kernel: [   52.760058] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Dec 28 11:32:07 redd kernel: [   55.768939] floppy0: no floppy controllers found
Dec 28 11:32:07 redd kernel: [   55.769189] loop: module loaded
Dec 28 11:32:07 redd kernel: [   55.769213] input: Macintosh mouse button emulation as /devices/virtual/input/input2
Dec 28 11:32:07 redd kernel: [   55.769231] Driver 'sd' needs updating - please use bus_type methods
Dec 28 11:32:07 redd kernel: [   55.769237] Driver 'sr' needs updating - please use bus_type methods
Dec 28 11:32:07 redd kernel: [   55.769268] Fixed MDIO Bus: probed
Dec 28 11:32:07 redd kernel: [   55.769283] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Dec 28 11:32:07 redd kernel: [   55.769296] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Dec 28 11:32:07 redd kernel: [   55.769304] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.769307] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.769326] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
Dec 28 11:32:07 redd kernel: [   55.773212] ehci_hcd 0000:00:1a.7: debug port 1
Dec 28 11:32:07 redd kernel: [   55.773217] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
Dec 28 11:32:07 redd kernel: [   55.773228] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7fff000
Dec 28 11:32:07 redd kernel: [   55.782909] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
Dec 28 11:32:07 redd kernel: [   55.782929] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Dec 28 11:32:07 redd kernel: [   55.782932] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.782935] usb usb1: Product: EHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.782938] usb usb1: Manufacturer: Linux 2.6.30.9-128 ehci_hcd
Dec 28 11:32:07 redd kernel: [   55.782940] usb usb1: SerialNumber: 0000:00:1a.7
Dec 28 11:32:07 redd kernel: [   55.782986] usb usb1: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.783009] hub 1-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.783014] hub 1-0:1.0: 6 ports detected
Dec 28 11:32:07 redd kernel: [   55.783078] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Dec 28 11:32:07 redd kernel: [   55.783086] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.783089] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.783102] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
Dec 28 11:32:07 redd kernel: [   55.787000] ehci_hcd 0000:00:1d.7: debug port 1
Dec 28 11:32:07 redd kernel: [   55.787004] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Dec 28 11:32:07 redd kernel: [   55.787013] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7ffe000
Dec 28 11:32:07 redd kernel: [   55.796904] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Dec 28 11:32:07 redd kernel: [   55.796919] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Dec 28 11:32:07 redd kernel: [   55.796922] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.796925] usb usb2: Product: EHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.796927] usb usb2: Manufacturer: Linux 2.6.30.9-128 ehci_hcd
Dec 28 11:32:07 redd kernel: [   55.796930] usb usb2: SerialNumber: 0000:00:1d.7
Dec 28 11:32:07 redd kernel: [   55.796973] usb usb2: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.797001] hub 2-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.797005] hub 2-0:1.0: 6 ports detected
Dec 28 11:32:07 redd kernel: [   55.797058] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Dec 28 11:32:07 redd kernel: [   55.797067] uhci_hcd: USB Universal Host Controller Interface driver
Dec 28 11:32:07 redd kernel: [   55.797081] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 28 11:32:07 redd kernel: [   55.797086] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.797088] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797100] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
Dec 28 11:32:07 redd kernel: [   55.797125] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
Dec 28 11:32:07 redd kernel: [   55.797146] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Dec 28 11:32:07 redd kernel: [   55.797147] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.797149] usb usb3: Product: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797151] usb usb3: Manufacturer: Linux 2.6.30.9-128 uhci_hcd
Dec 28 11:32:07 redd kernel: [   55.797152] usb usb3: SerialNumber: 0000:00:1a.0
Dec 28 11:32:07 redd kernel: [   55.797180] usb usb3: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.797195] hub 3-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.797199] hub 3-0:1.0: 2 ports detected
Dec 28 11:32:07 redd kernel: [   55.797249] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Dec 28 11:32:07 redd kernel: [   55.797253] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.797256] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797267] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
Dec 28 11:32:07 redd kernel: [   55.797292] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
Dec 28 11:32:07 redd kernel: [   55.797314] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Dec 28 11:32:07 redd kernel: [   55.797316] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.797317] usb usb4: Product: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797319] usb usb4: Manufacturer: Linux 2.6.30.9-128 uhci_hcd
Dec 28 11:32:07 redd kernel: [   55.797320] usb usb4: SerialNumber: 0000:00:1a.1
Dec 28 11:32:07 redd kernel: [   55.797347] usb usb4: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.797362] hub 4-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.797366] hub 4-0:1.0: 2 ports detected
Dec 28 11:32:07 redd kernel: [   55.797412] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Dec 28 11:32:07 redd kernel: [   55.797416] uhci_hcd 0000:00:1a.2: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.797418] uhci_hcd 0000:00:1a.2: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797431] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
Dec 28 11:32:07 redd kernel: [   55.797455] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000ac00
Dec 28 11:32:07 redd kernel: [   55.797474] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Dec 28 11:32:07 redd kernel: [   55.797476] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.797478] usb usb5: Product: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797479] usb usb5: Manufacturer: Linux 2.6.30.9-128 uhci_hcd
Dec 28 11:32:07 redd kernel: [   55.797481] usb usb5: SerialNumber: 0000:00:1a.2
Dec 28 11:32:07 redd kernel: [   55.797509] usb usb5: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.797524] hub 5-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.797529] hub 5-0:1.0: 2 ports detected
Dec 28 11:32:07 redd kernel: [   55.797575] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Dec 28 11:32:07 redd kernel: [   55.797579] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.797581] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797592] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
Dec 28 11:32:07 redd kernel: [   55.797613] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
Dec 28 11:32:07 redd kernel: [   55.797633] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Dec 28 11:32:07 redd kernel: [   55.797635] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.797636] usb usb6: Product: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797638] usb usb6: Manufacturer: Linux 2.6.30.9-128 uhci_hcd
Dec 28 11:32:07 redd kernel: [   55.797639] usb usb6: SerialNumber: 0000:00:1d.0
Dec 28 11:32:07 redd kernel: [   55.797666] usb usb6: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.797681] hub 6-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.797685] hub 6-0:1.0: 2 ports detected
Dec 28 11:32:07 redd kernel: [   55.797729] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Dec 28 11:32:07 redd kernel: [   55.797733] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.797736] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797747] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
Dec 28 11:32:07 redd kernel: [   55.797768] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
Dec 28 11:32:07 redd kernel: [   55.797787] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Dec 28 11:32:07 redd kernel: [   55.797789] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.797791] usb usb7: Product: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797792] usb usb7: Manufacturer: Linux 2.6.30.9-128 uhci_hcd
Dec 28 11:32:07 redd kernel: [   55.797794] usb usb7: SerialNumber: 0000:00:1d.1
Dec 28 11:32:07 redd kernel: [   55.797821] usb usb7: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.797836] hub 7-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.797839] hub 7-0:1.0: 2 ports detected
Dec 28 11:32:07 redd kernel: [   55.797884] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Dec 28 11:32:07 redd kernel: [   55.797888] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   55.797891] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797908] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
Dec 28 11:32:07 redd kernel: [   55.797929] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
Dec 28 11:32:07 redd kernel: [   55.797949] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
Dec 28 11:32:07 redd kernel: [   55.797951] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Dec 28 11:32:07 redd kernel: [   55.797952] usb usb8: Product: UHCI Host Controller
Dec 28 11:32:07 redd kernel: [   55.797954] usb usb8: Manufacturer: Linux 2.6.30.9-128 uhci_hcd
Dec 28 11:32:07 redd kernel: [   55.797955] usb usb8: SerialNumber: 0000:00:1d.2
Dec 28 11:32:07 redd kernel: [   55.797981] usb usb8: configuration #1 chosen from 1 choice
Dec 28 11:32:07 redd kernel: [   55.797997] hub 8-0:1.0: USB hub found
Dec 28 11:32:07 redd kernel: [   55.798000] hub 8-0:1.0: 2 ports detected
Dec 28 11:32:07 redd kernel: [   55.798077] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Dec 28 11:32:07 redd kernel: [   55.800880] serio: i8042 KBD port at 0x60,0x64 irq 1
Dec 28 11:32:07 redd kernel: [   55.800889] serio: i8042 AUX port at 0x60,0x64 irq 12
Dec 28 11:32:07 redd kernel: [   55.800934] mice: PS/2 mouse device common for all mice
Dec 28 11:32:07 redd kernel: [   55.801020] rtc_cmos 00:03: RTC can wake from S4
Dec 28 11:32:07 redd kernel: [   55.801041] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Dec 28 11:32:07 redd kernel: [   55.801061] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Dec 28 11:32:07 redd kernel: [   55.801084] EISA: Probing bus 0 at eisa.0
Dec 28 11:32:07 redd kernel: [   55.801107] EISA: Detected 0 cards.
Dec 28 11:32:07 redd kernel: [   55.801206] cpuidle: using governor ladder
Dec 28 11:32:07 redd kernel: [   55.801208] cpuidle: using governor menu
Dec 28 11:32:07 redd kernel: [   55.801343] usbcore: registered new interface driver hiddev
Dec 28 11:32:07 redd kernel: [   55.801356] usbcore: registered new interface driver usbhid
Dec 28 11:32:07 redd kernel: [   55.801359] usbhid: v2.6:USB HID core driver
Dec 28 11:32:07 redd kernel: [   55.801599] NET: Registered protocol family 17
Dec 28 11:32:07 redd kernel: [   55.803838] Using IPI No-Shortcut mode
Dec 28 11:32:07 redd kernel: [   55.803879] TuxOnIce 3.0.1 (http://tuxonice.net)
Dec 28 11:32:07 redd kernel: [   55.803910] TuxOnIce: Ignoring late initcall, as requested.
Dec 28 11:32:07 redd kernel: [   55.818705] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Dec 28 11:32:07 redd kernel: [   55.956557] psmouse serio1: ID: 10 00 64
Dec 28 11:32:07 redd kernel: [   56.760614] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
Dec 28 11:32:07 redd kernel: [   56.763234] registered taskstats version 1
Dec 28 11:32:07 redd kernel: [   56.763464] rtc_cmos 00:03: setting system clock to 2009-12-28 11:30:32 UTC (1261999832)
Dec 28 11:32:07 redd kernel: [   56.763542] Freeing unused kernel memory: 448k freed
Dec 28 11:32:07 redd kernel: [   56.763715] Write protecting the kernel text: 3096k
Dec 28 11:32:07 redd kernel: [   56.763746] Write protecting the kernel read-only data: 1444k
Dec 28 11:32:07 redd kernel: [   56.831099] libata version 3.00 loaded.
Dec 28 11:32:07 redd kernel: [   56.833649] ahci 0000:00:1f.2: version 3.0
Dec 28 11:32:07 redd kernel: [   56.833658] ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
Dec 28 11:32:07 redd kernel: [   56.833691] ahci: SSS flag set, parallel bus scan disabled
Dec 28 11:32:07 redd kernel: [   56.833728] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
Dec 28 11:32:07 redd kernel: [   56.833730] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
Dec 28 11:32:07 redd kernel: [   56.833734] ahci 0000:00:1f.2: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   56.839192] scsi0 : ahci
Dec 28 11:32:07 redd kernel: [   56.839263] scsi1 : ahci
Dec 28 11:32:07 redd kernel: [   56.839310] scsi2 : ahci
Dec 28 11:32:07 redd kernel: [   56.839353] scsi3 : ahci
Dec 28 11:32:07 redd kernel: [   56.839396] scsi4 : ahci
Dec 28 11:32:07 redd kernel: [   56.839447] scsi5 : ahci
Dec 28 11:32:07 redd kernel: [   56.839583] ata1: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc100 irq 20
Dec 28 11:32:07 redd kernel: [   56.839586] ata2: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc180 irq 20
Dec 28 11:32:07 redd kernel: [   56.839590] ata3: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc200 irq 20
Dec 28 11:32:07 redd kernel: [   56.839593] ata4: SATA max UDMA/133 abar m2048@0xf7ffc000 port 0xf7ffc280 irq 20
Dec 28 11:32:07 redd kernel: [   56.839596] ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 20
Dec 28 11:32:07 redd kernel: [   56.839600] ata6: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 20
Dec 28 11:32:07 redd kernel: [   56.839623] ahci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 28 11:32:07 redd kernel: [   56.839717] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
Dec 28 11:32:07 redd kernel: [   56.839721] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
Dec 28 11:32:07 redd kernel: [   56.839728] ahci 0000:04:00.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   56.839861] scsi6 : ahci
Dec 28 11:32:07 redd kernel: [   56.839912] scsi7 : ahci
Dec 28 11:32:07 redd kernel: [   56.839978] ata7: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe100 irq 16
Dec 28 11:32:07 redd kernel: [   56.839983] ata8: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe180 irq 16
Dec 28 11:32:07 redd kernel: [   57.147188] ata1: SATA link down (SStatus 0 SControl 300)
Dec 28 11:32:07 redd kernel: [   57.147218] ata7: SATA link down (SStatus 0 SControl 300)
Dec 28 11:32:07 redd kernel: [   57.147249] ata8: SATA link down (SStatus 0 SControl 300)
Dec 28 11:32:07 redd kernel: [   57.201093] irq 20: nobody cared (try booting with the "irqpoll" option)
Dec 28 11:32:07 redd kernel: [   57.201098] Pid: 0, comm: swapper Not tainted 2.6.30.9-128 #1


Dec 28 11:32:07 redd kernel: [   57.201100] Call Trace:
Dec 28 11:32:07 redd kernel: [   57.201108]  [<c01759cf>] __report_bad_irq+0x2e/0x6f
Dec 28 11:32:07 redd kernel: [   57.201113]  [<c0175b00>] note_interrupt+0xf0/0x148
Dec 28 11:32:07 redd kernel: [   57.201116]  [<c017601e>] handle_fasteoi_irq+0x7d/0x9b
Dec 28 11:32:07 redd kernel: [   57.201122]  [<c0104cdb>] handle_irq+0x3b/0x48
Dec 28 11:32:07 redd kernel: [   57.201126]  [<c0104648>] do_IRQ+0x40/0x83
Dec 28 11:32:07 redd kernel: [   57.201130]  [<c0103889>] common_interrupt+0x29/0x30
Dec 28 11:32:07 redd kernel: [   57.201135]  [<c0108662>] ? mwait_idle+0x6b/0x89
Dec 28 11:32:07 redd kernel: [   57.201139]  [<c01024b1>] cpu_idle+0x49/0x64
Dec 28 11:32:07 redd kernel: [   57.201145]  [<c03fde07>] start_secondary+0xc6/0xc8
Dec 28 11:32:07 redd kernel: [   57.201148] handlers:
Dec 28 11:32:07 redd kernel: [   57.201149] [<f8076414>] (ahci_interrupt+0x0/0xa8 [ahci])
Dec 28 11:32:07 redd kernel: [   57.201158] Disabling IRQ #20


Dec 28 11:32:07 redd kernel: [   57.463017] ata2: SATA link down (SStatus 0 SControl 300)
Dec 28 11:32:07 redd kernel: [   57.778848] ata3: SATA link down (SStatus 0 SControl 300)
Dec 28 11:32:07 redd kernel: [   58.094678] ata4: SATA link down (SStatus 0 SControl 300)
Dec 28 11:32:07 redd kernel: [   58.981252] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec 28 11:32:07 redd kernel: [   59.099172] ata5.00: ATA-8: ST3750528AS, CC37, max UDMA/133
Dec 28 11:32:07 redd kernel: [   59.099175] ata5.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
Dec 28 11:32:07 redd kernel: [   59.399031] ata5.00: configured for UDMA/133
Dec 28 11:32:07 redd kernel: [   59.410064] scsi 4:0:0:0: Direct-Access     ATA      ST3750528AS      CC37 PQ: 0 ANSI: 5
Dec 28 11:32:07 redd kernel: [   59.410185] sd 4:0:0:0: Attached scsi generic sg0 type 0
Dec 28 11:32:07 redd kernel: [   59.410206] sd 4:0:0:0: [sda] 1465149168 512-byte hardware sectors: (750 GB/698 GiB)
Dec 28 11:32:07 redd kernel: [   59.410222] sd 4:0:0:0: [sda] Write Protect is off
Dec 28 11:32:07 redd kernel: [   59.410226] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
Dec 28 11:32:07 redd kernel: [   59.410246] sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 28 11:32:07 redd kernel: [   59.410331]  sda: sda1 sda2 < sda5 sda6 >
Dec 28 11:32:07 redd kernel: [   59.699037] sd 4:0:0:0: [sda] Attached SCSI disk
Dec 28 11:32:07 redd kernel: [   60.285554] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Dec 28 11:32:07 redd kernel: [   60.398475] ata6.00: ATAPI: HL-DT-ST DVDRAM GH22NS50, TN01, max UDMA/100, ATAPI AN
Dec 28 11:32:07 redd kernel: [   60.698335] ata6.00: configured for UDMA/100
Dec 28 11:32:07 redd kernel: [   60.998180] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH22NS50  TN01 PQ: 0 ANSI: 5
Dec 28 11:32:07 redd kernel: [   61.198059] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Dec 28 11:32:07 redd kernel: [   61.198062] Uniform CD-ROM driver Revision: 3.20
Dec 28 11:32:07 redd kernel: [   61.198137] sr 5:0:0:0: Attached scsi CD-ROM sr0
Dec 28 11:32:07 redd kernel: [   61.198177] sr 5:0:0:0: Attached scsi generic sg1 type 5
Dec 28 11:32:07 redd kernel: [   61.200276] pata_jmicron 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Dec 28 11:32:07 redd kernel: [   61.200302] pata_jmicron 0000:04:00.1: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   61.200359] scsi8 : pata_jmicron
Dec 28 11:32:07 redd kernel: [   61.200414] scsi9 : pata_jmicron
Dec 28 11:32:07 redd kernel: [   61.201338] ata9: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 17
Dec 28 11:32:07 redd kernel: [   61.201341] ata10: PATA max UDMA/100 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 17
Dec 28 11:32:07 redd kernel: [   61.522915] firewire_ohci 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Dec 28 11:32:07 redd kernel: [   61.522922] firewire_ohci 0000:05:00.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [   61.580803] firewire_ohci: Added fw-ohci device 0000:05:00.0, OHCI version 1.10
Dec 28 11:32:07 redd kernel: [   61.639718] PM: Starting manual resume from disk
Dec 28 11:32:07 redd kernel: [   61.697773] TuxOnIce: Normal swapspace found.
Dec 28 11:32:07 redd kernel: [   62.080605] firewire_core: created device fw0: GUID 001e8c0000a27a06, S400
Dec 28 11:32:07 redd kernel: [   65.101714] brd: module loaded
Dec 28 11:32:07 redd kernel: [   67.195732] EXT4-fs: INFO: recovery required on readonly filesystem.
Dec 28 11:32:07 redd kernel: [   67.195735] EXT4-fs: write access will be enabled during recovery.
Dec 28 11:32:07 redd kernel: [   67.294808] EXT4-fs: barriers enabled
Dec 28 11:32:07 redd kernel: [   79.088512] kjournald2 starting: pid 183, dev sda1:8, commit interval 5 seconds
Dec 28 11:32:07 redd kernel: [   79.088521] EXT4-fs: delayed allocation enabled
Dec 28 11:32:07 redd kernel: [   79.088524] EXT4-fs: file extents enabled
Dec 28 11:32:07 redd kernel: [   79.101956] EXT4-fs: mballoc enabled
Dec 28 11:32:07 redd kernel: [   79.101965] EXT4-fs: recovery complete.
Dec 28 11:32:07 redd kernel: [   79.288369] EXT4-fs: mounted filesystem sda1 with ordered data mode
Dec 28 11:32:07 redd kernel: [  112.670747] udev: starting version 146
Dec 28 11:32:07 redd kernel: [  117.468781] input: PC Speaker as /devices/platform/pcspkr/input/input5
Dec 28 11:32:07 redd kernel: [  117.469261] iTCO_vendor_support: vendor-support=0
Dec 28 11:32:07 redd kernel: [  117.770873] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Dec 28 11:32:07 redd kernel: [  117.770972] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
Dec 28 11:32:07 redd kernel: [  117.771028] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Dec 28 11:32:07 redd kernel: [  118.170484] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Dec 28 11:32:07 redd kernel: [  118.174825] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Dec 28 11:32:07 redd kernel: [  118.174844] r8169 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Dec 28 11:32:07 redd kernel: [  118.174862] r8169 0000:06:00.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [  118.174909] r8169 0000:06:00.0: no MSI. Back to INTx.
Dec 28 11:32:07 redd kernel: [  118.175241] eth0: RTL8168c/8111c at 0xf88ca000, 00:26:18:fc:96:d3, XID 3c4000c0 IRQ 18
Dec 28 11:32:07 redd kernel: [  119.772062] Linux agpgart interface v0.103
Dec 28 11:32:07 redd kernel: [  120.386513] [drm] Initialized drm 1.1.0 20060810
Dec 28 11:32:07 redd kernel: [  122.878235] pci 0000:02:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
Dec 28 11:32:07 redd kernel: [  122.878242] pci 0000:02:00.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [  122.879030] [drm] nouveau 0000:02:00.0: Detected an NV50 generation card (0x096c80c1)
Dec 28 11:32:07 redd kernel: [  122.879452] [drm] Initialized nouveau 0.0.15 20090420 for 0000:02:00.0 on minor 0
Dec 28 11:32:07 redd kernel: [  123.569507] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Dec 28 11:32:07 redd kernel: [  123.569559] HDA Intel 0000:00:1b.0: setting latency timer to 64
Dec 28 11:32:07 redd kernel: [  123.871596] hda_codec: ALC1200: BIOS auto-probing.
Dec 28 11:32:07 redd kernel: [  128.661939] EXT4 FS on sda1, internal journal on sda1:8
Dec 28 11:32:07 redd kernel: [  133.659272] EXT4-fs: barriers enabled
Dec 28 11:32:07 redd kernel: [  133.759232] kjournald2 starting: pid 455, dev sda5:8, commit interval 5 seconds
Dec 28 11:32:07 redd kernel: [  133.859149] EXT4 FS on sda5, internal journal on sda5:8
Dec 28 11:32:07 redd kernel: [  133.859151] EXT4-fs: delayed allocation enabled
Dec 28 11:32:07 redd kernel: [  133.859154] EXT4-fs: file extents enabled
Dec 28 11:32:07 redd kernel: [  133.868389] EXT4-fs: mballoc enabled
Dec 28 11:32:07 redd kernel: [  133.868398] EXT4-fs: mounted filesystem sda5 with ordered data mode
Dec 28 11:32:07 redd kernel: [  134.160458] Adding 4192924k swap on /dev/sda6.  Priority:-1 extents:1 across:4192924k 
Dec 28 11:32:09 redd kernel: [  153.350524] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.452249] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.456534] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.460709] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.465477] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.470226] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.474295] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.477998] platform microcode: firmware: requesting intel-ucode/06-1a-05
Dec 28 11:32:10 redd kernel: [  154.480567] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Dec 28 11:32:26 redd kernel: [  170.866361] NET: Registered protocol family 10
Dec 28 11:32:26 redd kernel: [  170.866900] lo: Disabled Privacy Extensions
Dec 28 11:32:30 redd kernel: [  174.464113] [TTM] Zone  kernel: Available graphics memory: 437480 kiB.
Dec 28 11:32:30 redd kernel: [  174.464117] [TTM] Zone highmem: Available graphics memory: 1027052 kiB.
Dec 28 11:32:30 redd kernel: [  174.555455] [drm] nouveau 0000:02:00.0: Allocating FIFO number 1
