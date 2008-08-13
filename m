Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYHMX1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYHMX1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYHMX1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:27:36 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:12587 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbYHMX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:27:34 -0400
Message-ID: <48A36DDB.9040106@hp.com>
Date: Wed, 13 Aug 2008 19:27:23 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <48A36838.3050309@hp.com>
In-Reply-To: <48A36838.3050309@hp.com>
Content-Type: multipart/mixed;
 boundary="------------050809060402060002090504"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050809060402060002090504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sorry, full boot log attached...

--------------050809060402060002090504
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.27-rc2 (adb@cail) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #14 SMP Wed Aug 13 18:32:21 EDT 2008
[    0.000000] Command line: root=UUID=d3e6e98e-d461-447d-852a-692103795804 ro console=tty0 console=ttyS0,115200n8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffc2840 (usable)
[    0.000000]  BIOS-e820: 00000000cffc2840 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xcffc2 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: cffc2000 end: cffc2000
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: 230000000 end: 230000000
[    0.000000] RAMDISK: 3505d000 - 37fef80c
[    0.000000] DMI 2.5 present.
[    0.000000] ACPI: RSDP 000E9810, 0024 (r2 HPQOEM)
[    0.000000] ACPI: XSDT CFFC52EC, 005C (r1 HPQOEM SLIC-WKS 20080505             0)
[    0.000000] ACPI: FACP CFFC5494, 00F4 (r3 HPQOEM SEABURG         1             0)
[    0.000000] ACPI Error (tbfadt-0453): 32/64X address mismatch in "Gpe0Block": [0000F828] [000000000001F030], using 64X [20080609]
[    0.000000] ACPI: DSDT CFFC5A7A, 26A4 (r1 HPQOEM     DSDT        1 MSFT  100000E)
[    0.000000] ACPI: FACS CFFC5200, 0040
[    0.000000] ACPI: SSDT CFFC811E, 701D (r1 HPQOEM  PROJECT        1 MSFT  100000E)
[    0.000000] ACPI: APIC CFFC5588, 00D4 (r1 HPQOEM SEABURG         1             0)
[    0.000000] ACPI: ASF! CFFC565C, 006A (r32 HPQOEM SEABURG         1             0)
[    0.000000] ACPI: MCFG CFFC585E, 003C (r1 HPQOEM SEABURG         1             0)
[    0.000000] ACPI: HPET CFFC5A10, 0038 (r1 HPQOEM SEABURG         1             0)
[    0.000000] ACPI: TCPA CFFC5A48, 0032 (r1 HPQOEM SEABURG         1             0)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000230000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
[    0.000000]   NODE_DATA [0000000000011000 - 0000000000034fff]
[    0.000000]   bootmap [0000000000035000 -  000000000007afff] pages 46
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0230000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0001178b9c]    TEXT DATA BSS ==> [0000200000 - 0001178b9c]
[    0.000000]   #3 [003505d000 - 0037fef80c]          RAMDISK ==> [003505d000 - 0037fef80c]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #6 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 0000011000]
[    0.000000] found SMP MP-table at [ffff8800000fe700] 000fe700
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cffc2
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec89000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 0, address 0xfec89000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec88000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 0, address 0xfec88000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000[1;88r[88;1H
[1;89r[88;1H[    0.000000] Using ACPI (MADT) for SMP configuration information[1;88r[88;1H
[1;89r[88;1H[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000cffc2000 - 00000000cffc3000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000cffc3000 - 00000000d0000000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000[1;88r[88;1H
[1;89r[88;1H[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000[1;88r[88;1H
[1;89r[88;1H[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)[1;88r[88;1H
[1;89r[88;1H[    0.000000] PERCPU: Allocating 71080 bytes of per cpu data[1;88r[88;1H
[1;89r[88;1H[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065521[1;88r[88;1H
[1;89r[88;1H[    0.000000] Policy zone: Normal[1;88r[88;1H
[1;89r[88;1H[    0.000000] Kernel command line: root=UUID=d3e6e98e-d461-447d-852a-692103795804 ro console=tty0 console=ttyS0,115200n8[1;88r[88;1H
[1;89r[88;1H[    0.000000] Initializing CPU#0[1;88r[88;1H
[1;89r[88;1H[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)[1;88r[88;1H
[1;89r[88;1H[    0.000000] Extended CMOS year: 2000[1;88r[88;1H
[1;89r[88;1H[    0.000000] TSC calibrated against PM_TIMER[1;88r[88;1H
[1;89r[88;1H[    0.000000] Detected 3400.102 MHz processor.[1;88r[88;1H
[1;89r[88;1H[    0.010000] Console: colour VGA+ 80x25[1;88r[88;1H
[1;89r[88;1H[    0.010000] console [tty0] enabled[1;88r[88;1H
[1;89r[88;1H[    0.010000] console [ttyS0] enabled[1;88r[88;1H
[1;89r[88;1H[    0.010000] Checking aperture...[1;88r[88;1H
[1;89r[88;1H[    0.010000] No AGP bridge found[1;88r[88;1H
[1;89r[88;1H[    0.010000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)[1;88r[88;1H
[1;89r[88;1H[    0.010000] Placing software IO TLB between 0x20000000 - 0x24000000[1;88r[88;1H
[1;89r[88;1H[    0.010000] Memory: 8139676k/9175040k available (2652k kernel code, 248292k reserved, 1559k data, 504k init)[1;88r[88;1H
[1;89r[88;1H[    0.010000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1[1;88r[88;1H
[1;89r[88;1H[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6800.20 BogoMIPS (lpj=34001020)[1;88r[88;1H
[1;89r[88;1H[    0.020000] Security Framework initialized[1;88r[88;1H
[1;89r[88;1H[    0.020000] SELinux:  Disabled at boot.[1;88r[88;1H
[1;89r[88;1H[    0.020000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)[1;88r[88;1H
[1;89r[88;1H[    0.030000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)[1;88r[88;1H
[1;89r[88;1H[    0.040000] Mount-cache hash table entries: 256[1;88r[88;1H
[1;89r[88;1H[    0.046175] Initializing cgroup subsys ns[1;88r[88;1H
[1;89r[88;1H[    0.050000] Initializing cgroup subsys cpuacct[1;88r[88;1H
[1;89r[88;1H[    0.058645] CPU: L1 I cache: 32K, L1 D cache: 32K[1;88r[88;1H
[1;89r[88;1H[    0.060000] CPU: L2 cache: 6144K[1;88r[88;1H
[1;89r[88;1H[    0.060000] CPU 0/0 -> Node 0[1;88r[88;1H
[1;89r[88;1H[    0.070000] CPU: Physical Processor ID: 0[1;88r[88;1H
[1;89r[88;1H[    0.070000] CPU: Processor Core ID: 0[1;88r[88;1H
[1;89r[88;1H[    0.077722] CPU0: Thermal monitoring enabled (TM2)[1;88r[88;1H
[1;89r[88;1H[    0.080000] using mwait in idle threads.[1;88r[88;1H
[1;89r[88;1H[    0.080000] ACPI: Core revision 20080609[1;88r[88;1H
[1;89r[88;1H[    0.100000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1[1;88r[88;1H
[1;89r[88;1H[    0.209952] CPU0: Intel(R) Xeon(R) CPU           X5272  @ 3.40GHz stepping 06[1;88r[88;1H
[1;89r[88;1H[    0.220000] Using local APIC timer interrupts.[1;88r[88;1H
[1;89r[88;1H[    0.230000] Detected 25.000 MHz APIC timer.[1;88r[88;1H
[1;89r[88;1H[    0.237348] Booting processor 1/6 ip 6000[1;88r[88;1H
[1;89r[88;1H[    0.250000] Initializing CPU#1[1;88r[88;1H
[1;89r[88;1H[    0.250000] Calibrating delay using timer specific routine.. 6800.31 BogoMIPS (lpj=34001550)[1;88r[88;1H
[1;89r[88;1H[    0.250000] CPU: L1 I cache: 32K, L1 D cache: 32K[1;88r[88;1H
[1;89r[88;1H[    0.250000] CPU: L2 cache: 6144K[1;88r[88;1H
[1;89r[88;1H[    0.250000] CPU 1/6 -> Node 0[1;88r[88;1H
[1;89r[88;1H[    0.250000] CPU: Physical Processor ID: 3[1;88r[88;1H
[1;89r[88;1H[    0.250000] CPU: Processor Core ID: 0[1;88r[88;1H
[1;89r[88;1H[    0.250000] CPU1: Thermal monitoring enabled (TM2)[1;88r[88;1H
[1;89r[88;1H[    0.398166] CPU1: Intel(R) Xeon(R) CPU           X5272  @ 3.40GHz stepping 06[1;88r[88;1H
[1;89r[88;1H[    0.415380] checking TSC synchronization [CPU#0 -> CPU#1]: passed.[1;88r[88;1H
[1;89r[88;1H[    0.430000] Booting processor 2/1 ip 6000[1;88r[88;1H
[1;89r[88;1H[    0.450000] Initializing CPU#2[1;88r[88;1H
[1;89r[88;1H[    0.450000] Calibrating delay using timer specific routine.. 6800.31 BogoMIPS (lpj=34001584)[1;88r[88;1H
[1;89r[88;1H[    0.450000] CPU: L1 I cache: 32K, L1 D cache: 32K[1;88r[88;1H
[1;89r[88;1H[    0.450000] CPU: L2 cache: 6144K[1;88r[88;1H
[1;89r[88;1H[    0.450000] CPU 2/1 -> Node 0[1;88r[88;1H
[1;89r[88;1H[    0.450000] CPU: Physical Processor ID: 0[1;88r[88;1H
[1;89r[88;1H[    0.450000] CPU: Processor Core ID: 1[1;88r[88;1H
[1;89r[88;1H[    0.450000] CPU2: Thermal monitoring enabled (TM2)[1;88r[88;1H
[1;89r[88;1H[    0.591123] CPU2: Intel(R) Xeon(R) CPU           X5272  @ 3.40GHz stepping 06[1;88r[88;1H
[1;89r[88;1H[    0.615380] checking TSC synchronization [CPU#0 -> CPU#2]: passed.[1;88r[88;1H
[1;89r[88;1H[    0.630000] Booting processor 3/7 ip 6000[1;88r[88;1H
[1;89r[88;1H[    0.650000] Initializing CPU#3[1;88r[88;1H
[1;89r[88;1H[    0.650000] Calibrating delay using timer specific routine.. 6800.32 BogoMIPS (lpj=34001644)[1;88r[88;1H
[1;89r[88;1H[    0.650000] CPU: L1 I cache: 32K, L1 D cache: 32K[1;88r[88;1H
[1;89r[88;1H[    0.650000] CPU: L2 cache: 6144K[1;88r[88;1H
[1;89r[88;1H[    0.650000] CPU 3/7 -> Node 0[1;88r[88;1H
[1;89r[88;1H[    0.650000] CPU: Physical Processor ID: 3[1;88r[88;1H
[1;89r[88;1H[    0.650000] CPU: Processor Core ID: 1[1;88r[88;1H
[1;89r[88;1H[    0.650000] CPU3: Thermal monitoring enabled (TM2)[1;88r[88;1H
[1;89r[88;1H[    0.791619] CPU3: Intel(R) Xeon(R) CPU           X5272  @ 3.40GHz stepping 06[1;88r[88;1H
[1;89r[88;1H[    0.815380] checking TSC synchronization [CPU#0 -> CPU#3]: passed.[1;88r[88;1H
[1;89r[88;1H[    0.830000] Brought up 4 CPUs[1;88r[88;1H
[1;89r[88;1H[    0.833199] Total of 4 processors activated (27201.15 BogoMIPS).[1;88r[88;1H
[1;89r[88;1H[    0.840000] net_namespace: 1552 bytes[1;88r[88;1H
[1;89r[88;1H[    0.850000] NET: Registered protocol family 16[1;88r[88;1H
[1;89r[88;1H[    0.850000] ACPI: bus type pci registered[1;88r[88;1H
[1;89r[88;1H[    0.860000] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255[1;88r[88;1H
[1;89r[88;1H[    0.860000] PCI: MCFG area at e0000000 reserved in E820[1;88r[88;1H
[1;89r[88;1H[    0.870000] PCI: Using MMCONFIG at e0000000 - efffffff[1;88r[88;1H
[1;89r[88;1H[    0.877408] PCI: Using configuration type 1 for base access[1;88r[88;1H
[1;89r[88;1H[    0.890000] ACPI: Interpreter enabled[1;88r[88;1H
[1;89r[88;1H[    0.890000] ACPI: (supports S0 S3 S4 S5)[1;88r[88;1H
[1;89r[88;1H[    0.900000] ACPI: Using IOAPIC for interrupt routing[1;88r[88;1H
[1;89r[88;1H[    0.910000] ACPI: PCI Root Bridge [PCI0] (0000:00)[1;88r[88;1H
[1;89r[88;1H[    0.910000] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.920000] pci 0000:00:00.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.920000] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.930000] pci 0000:00:01.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.930000] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.940000] pci 0000:00:03.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.940000] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.950000] pci 0000:00:05.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.950000] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.960000] pci 0000:00:09.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.960000] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.970000] pci 0000:00:1b.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.970000] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.980000] pci 0000:00:1c.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.980000] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    0.990000] pci 0000:00:1c.1: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    0.990000] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    1.000000] pci 0000:00:1d.7: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.000000] pci 0000:00:1f.2: PME# supported from D3hot[1;88r[88;1H
[1;89r[88;1H[    1.009600] pci 0000:00:1f.2: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.014811] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    1.020000] pci 0000:10:00.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.030000] pci 0000:10:00.3: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    1.030000] pci 0000:10:00.3: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.040000] pci 0000:1e:00.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    1.040000] pci 0000:1e:00.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.050000] pci 0000:1e:01.0: PME# supported from D0 D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    1.057074] pci 0000:1e:01.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.070000] pci 0000:0e:00.0: PME# supported from D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    1.070000] pci 0000:0e:00.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.080000] pci 0000:0f:00.0: PME# supported from D3hot D3cold[1;88r[88;1H
[1;89r[88;1H[    1.080000] pci 0000:0f:00.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.090000] pci 0000:01:05.0: PME# supported from D0 D1 D2 D3hot[1;88r[88;1H
[1;89r[88;1H[    1.090000] pci 0000:01:05.0: PME# disabled[1;88r[88;1H
[1;89r[88;1H[    1.100000] pci 0000:00:1e.0: transparent bridge[1;88r[88;1H
[1;89r[88;1H[    1.120000] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 14 15)[1;88r[88;1H
[1;89r[88;1H[    1.130000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)[1;88r[88;1H
[1;89r[88;1H[    1.140000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15)[1;88r[88;1H
[1;89r[88;1H[    1.150000] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 14 15)[1;88r[88;1H
[1;89r[88;1H[    1.150000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.[1;88r[88;1H
[1;89r[88;1H[    1.160000] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 14 15)[1;88r[88;1H
[1;89r[88;1H[    1.170000] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)[1;88r[88;1H
[1;89r[88;1H[    1.180000] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.[1;88r[88;1H
[1;89r[88;1H[    1.180000] Linux Plug and Play Support v0.97 (c) Adam Belay[1;88r[88;1H
[1;89r[88;1H[    1.190000] pnp: PnP ACPI init[1;88r[88;1H
[1;89r[88;1H[    1.190000] ACPI: bus type pnp registered[1;88r[88;1H
[1;89r[88;1H[    1.200000] pnp 00:10: mem resource (0x0-0x9ffff) overlaps 0000:11:06.0 BAR 6 (0x0-0x1fffff), disabling[1;88r[88;1H
[1;89r[88;1H[    1.210000] pnp 00:10: mem resource (0xc0000-0xe7fff) overlaps 0000:11:06.0 BAR 6 (0x0-0x1fffff), disabling[1;88r[88;1H
[1;89r[88;1H[    1.219758] pnp 00:10: mem resource (0xe8000-0xeffff) overlaps 0000:11:06.0 BAR 6 (0x0-0x1fffff), disabling[1;88r[88;1H
[1;89r[88;1H[    1.229515] pnp 00:10: mem resource (0xf0000-0xfffff) overlaps 0000:11:06.0 BAR 6 (0x0-0x1fffff), disabling[1;88r[88;1H
[1;89r[88;1H[    1.239273] pnp 00:10: mem resource (0x100000-0xcfffffff) overlaps 0000:11:06.0 BAR 6 (0x0-0x1fffff), disabling[1;88r[88;1H
[1;89r[88;1H[    1.250000] pnp: PnP ACPI: found 18 devices[1;88r[88;1H
[1;89r[88;1H[    1.250000] ACPI: ACPI bus type pnp unregistered[1;88r[88;1H
[1;89r[88;1H[    1.260000] PCI: Using ACPI for IRQ routing[1;88r[88;1H
[1;89r[88;1H[    1.307254] NET: Registered protocol family 8[1;88r[88;1H
[1;89r[88;1H[    1.310000] NET: Registered protocol family 20[1;88r[88;1H
[1;89r[88;1H[    1.310000] NetLabel: Initializing[1;88r[88;1H
[1;89r[88;1H[    1.320000] NetLabel:  domain hash size = 128[1;88r[88;1H
[1;89r[88;1H[    1.320000] NetLabel:  protocols = UNLABELED CIPSOv4[1;88r[88;1H
[1;89r[88;1H[    1.329370] NetLabel:  unlabeled traffic allowed by default[1;88r[88;1H
[1;89r[88;1H[    1.330000] PCI-GART: No AMD northbridge found.[1;88r[88;1H
[1;89r[88;1H[    1.340000] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0[1;88r[88;1H
[1;89r[88;1H[    1.340000] hpet0: 3 64-bit timers, 14318180 Hz[1;88r[88;1H
[1;89r[88;1H[    1.388527] system 00:0d: ioport range 0x4d0-0x4d1 has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.390001] system 00:0e: ioport range 0x400-0x41f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.400003] system 00:0e: ioport range 0x420-0x43f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.402768] system 00:0e: ioport range 0x440-0x45f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.412769] system 00:0e: ioport range 0x460-0x47f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.419141] system 00:0e: ioport range 0x480-0x48f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.421891] system 00:0e: ioport range 0x490-0x49f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.431892] system 00:0e: ioport range 0xf800-0xf81f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.438438] system 00:0e: ioport range 0xf820-0xf83f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.441187] system 00:0e: ioport range 0xf840-0xf85f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.451188] system 00:0e: ioport range 0xf860-0xf87f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.457733] system 00:0e: ioport range 0xfa00-0xfa3f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.460827] system 00:0e: ioport range 0xfc00-0xfc7f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.470829] system 00:0e: ioport range 0xfc80-0xfcff has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.477374] system 00:0e: ioport range 0xfe00-0xfe7f has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.480470] system 00:0e: ioport range 0xfe80-0xfeff has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.490473] system 00:0f: iomem range 0xfed1c000-0xfed1ffff could not be reserved[1;88r[88;1H
[1;89r[88;1H[    1.497981] system 00:0f: iomem range 0xffe00000-0xffffffff could not be reserved[1;88r[88;1H
[1;89r[88;1H[    1.501076] system 00:0f: iomem range 0xfee00000-0xfeefffff could not be reserved[1;88r[88;1H
[1;89r[88;1H[    1.511077] system 00:0f: iomem range 0xfe700000-0xfe7003ff has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.518228] system 00:0f: iomem range 0xfe600000-0xfe6fffff has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.525379] system 00:0f: iomem range 0xfe000000-0xfe01ffff has been reserved[1;88r[88;1H
[1;89r[88;1H[    1.530400] system 00:10: iomem range 0xfeda0000-0xfedbffff could not be reserved[1;88r[88;1H
[1;89r[88;1H[    1.540403] system 00:11: iomem range 0xe0000000-0xefffffff could not be reserved[1;88r[88;1H
[1;89r[88;1H[    1.553225] pci 0000:00:01.0: PCI bridge, secondary bus 0000:80[1;88r[88;1H
[1;89r[88;1H[    1.553225] pci 0000:00:01.0:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.562576] pci 0000:00:01.0:   MEM window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.564311] pci 0000:00:01.0:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.574315] pci 0000:00:03.0: PCI bridge, secondary bus 0000:a0[1;88r[88;1H
[1;89r[88;1H[    1.580256] pci 0000:00:03.0:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.580662] pci 0000:00:03.0:   MEM window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.580664] pci 0000:00:03.0:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.590549] pci 0000:60:00.0: BAR 6: can't allocate mem resource [0xe0000000-0xdfffffff][1;88r[88;1H
[1;89r[88;1H[    1.600550] pci 0000:00:05.0: PCI bridge, secondary bus 0000:60[1;88r[88;1H
[1;89r[88;1H[    1.604088] pci 0000:00:05.0:   IO window: 0x1000-0x1fff[1;88r[88;1H
[1;89r[88;1H[    1.610027] pci 0000:00:05.0:   MEM window: 0xf0000000-0xf2ffffff[1;88r[88;1H
[1;89r[88;1H[    1.620029] pci 0000:00:05.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff[1;88r[88;1H
[1;89r[88;1H[    1.621475] pci 0000:1e:00.0: PCI bridge, secondary bus 0000:20[1;88r[88;1H
[1;89r[88;1H[    1.631476] pci 0000:1e:00.0:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.635013] pci 0000:1e:00.0:   MEM window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.644944] pci 0000:1e:00.0:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.644996] pci 0000:1e:01.0: PCI bridge, secondary bus 0000:40[1;88r[88;1H
[1;89r[88;1H[    1.650979] pci 0000:1e:01.0:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.660417] pci 0000:1e:01.0:   MEM window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.661256] pci 0000:1e:01.0:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.671305] pci 0000:10:00.0: PCI bridge, secondary bus 0000:1e[1;88r[88;1H
[1;89r[88;1H[    1.671711] pci 0000:10:00.0:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.681759] pci 0000:10:00.0:   MEM window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.682597] pci 0000:10:00.0:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.692645] pci 0000:10:00.3: PCI bridge, secondary bus 0000:11[1;88r[88;1H
[1;89r[88;1H[    1.693051] pci 0000:10:00.3:   IO window: 0x2000-0x2fff[1;88r[88;1H
[1;89r[88;1H[    1.703098] pci 0000:10:00.3:   MEM window: 0xf3000000-0xf30fffff[1;88r[88;1H
[1;89r[88;1H[    1.704374] pci 0000:10:00.3:   PREFETCH window: 0x000000f3600000-0x000000f37fffff[1;88r[88;1H
[1;89r[88;1H[    1.712014] pci 0000:00:09.0: PCI bridge, secondary bus 0000:10[1;88r[88;1H
[1;89r[88;1H[    1.720533] pci 0000:00:09.0:   IO window: 0x2000-0x2fff[1;88r[88;1H
[1;89r[88;1H[    1.724115] pci 0000:00:09.0:   MEM window: 0xf3000000-0xf31fffff[1;88r[88;1H
[1;89r[88;1H[    1.734117] pci 0000:00:09.0:   PREFETCH window: 0x000000f3600000-0x000000f37fffff[1;88r[88;1H
[1;89r[88;1H[    1.741711] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0e[1;88r[88;1H
[1;89r[88;1H[    1.743158] pci 0000:00:1c.0:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.753161] pci 0000:00:1c.0:   MEM window: 0xf3300000-0xf33fffff[1;88r[88;1H
[1;89r[88;1H[    1.754002] pci 0000:00:1c.0:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.760115] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0f[1;88r[88;1H
[1;89r[88;1H[    1.770117] pci 0000:00:1c.1:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.771478] pci 0000:00:1c.1:   MEM window: 0xf3200000-0xf32fffff[1;88r[88;1H
[1;89r[88;1H[    1.781480] pci 0000:00:1c.1:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.782493] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01[1;88r[88;1H
[1;89r[88;1H[    1.792494] pci 0000:00:1e.0:   IO window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.793856] pci 0000:00:1e.0:   MEM window: 0xf3400000-0xf34fffff[1;88r[88;1H
[1;89r[88;1H[    1.803858] pci 0000:00:1e.0:   PREFETCH window: disabled[1;88r[88;1H
[1;89r[88;1H[    1.804882] pci 0000:00:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24[1;88r[88;1H
[1;89r[88;1H[    1.811610] pci 0000:00:03.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26[1;88r[88;1H
[1;89r[88;1H[    1.820303] pci 0000:00:05.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28[1;88r[88;1H
[1;89r[88;1H[    1.823759] pci 0000:00:09.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32[1;88r[88;1H
[1;89r[88;1H[    1.830481] pci 0000:10:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32[1;88r[88;1H
[1;89r[88;1H[    1.840621] pci 0000:1e:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32[1;88r[88;1H
[1;89r[88;1H[    1.847578] pci 0000:1e:01.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46[1;88r[88;1H
[1;89r[88;1H[    1.850834] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16[1;88r[88;1H
[1;89r[88;1H[    1.860845] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17[1;88r[88;1H
[1;89r[88;1H[    1.867593] NET: Registered protocol family 2[1;88r[88;1H
[1;89r[88;1H[    1.961492] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)[1;88r[88;1H
[1;89r[88;1H[    1.970001] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)[1;88r[88;1H
[1;89r[88;1H[    1.982824] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)[1;88r[88;1H
[1;89r[88;1H[    1.992747] TCP: Hash tables configured (established 524288 bind 65536)[1;88r[88;1H
[1;89r[88;1H[    1.999753] TCP reno registered[1;88r[88;1H
[1;89r[88;1H[    2.020145] NET: Registered protocol family 1[1;88r[88;1H
[1;89r[88;1H[    2.030001] checking if image is initramfs... it is[1;88r[88;1H
[1;89r[88;1H[    5.870001] Freeing initrd memory: 48714k freed[1;88r[88;1H
[1;89r[88;1H[    5.893055] audit: initializing netlink socket (disabled)[1;88r[88;1H
[1;89r[88;1H[    5.901898] type=2000 audit(1218667667.896:1): initialized[1;88r[88;1H
[1;89r[88;1H[    5.918420] HugeTLB registered 2 MB page size, pre-allocated 0 pages[1;88r[88;1H
[1;89r[88;1H[    5.929327] VFS: Disk quotas dquot_6.5.1[1;88r[88;1H
[1;89r[88;1H[    5.929327] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)[1;88r[88;1H
[1;89r[88;1H[    5.938141] msgmni has been set to 15992[1;88r[88;1H
[1;89r[88;1H[    5.938141] io scheduler noop registered[1;88r[88;1H
[1;89r[88;1H[    5.946136] io scheduler anticipatory registered[1;88r[88;1H
[1;89r[88;1H[    5.946136] io scheduler deadline registered (default)[1;88r[88;1H
[1;89r[88;1H[    5.957085] io scheduler cfq registered[1;88r[88;1H
[1;89r[88;1H[    5.957085] pcieport-driver 0000:00:01.0: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    5.967072] pcieport-driver 0000:00:03.0: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    5.973153] pcieport-driver 0000:00:05.0: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    5.974528] pcieport-driver 0000:00:09.0: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    5.982203] pcieport-driver 0000:00:1c.0: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    5.982203] pcieport-driver 0000:00:1c.1: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    5.994261] pcieport-driver 0000:1e:00.0: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    6.003570] pcieport-driver 0000:1e:01.0: found MSI capability[1;88r[88;1H
[1;89r[88;1H[    6.012361] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.022364] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.032711] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error[1;88r[88;1H
[1;89r[88;1H[    6.042379] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.051728] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.059959] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.068340] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.080213] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.088580] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.101999] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.112002] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.122176] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.132178] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.142337] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.152341] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.162515] ACPI Error (dsfield-0139): [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.172517] ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88022f04afc0), AE_ALREADY_EXISTS[1;88r[88;1H
[1;89r[88;1H[    6.211876] Linux agpgart interface v0.103[1;88r[88;1H
[1;89r[88;1H[    6.211876] Serial: 8250/16550 driver4 ports, IRQ sharing enabled[1;88r[88;1H
[1;89r[88;1H[    6.222428] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A[1;88r[88;1H
[1;89r[88;1H[    6.231253] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A[1;88r[88;1H
[1;89r[88;1H[    6.236609] brd: module loaded[1;88r[88;1H
[1;89r[88;1H[    6.241601] input: Macintosh mouse button emulation as /class/input/input0[1;88r[88;1H
[1;89r[88;1H[    6.242769] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12[1;88r[88;1H
[1;89r[88;1H[    6.250003] serio: i8042 KBD port at 0x60,0x64 irq 1[1;88r[88;1H
[1;89r[88;1H[    6.253618] serio: i8042 AUX port at 0x60,0x64 irq 12[1;88r[88;1H
[1;89r[88;1H[    6.311936] mice: PS/2 mouse device common for all mice[1;88r[88;1H
[1;89r[88;1H[    6.311936] cpuidle: using governor ladder[1;88r[88;1H
[1;89r[88;1H[    6.311936] cpuidle: using governor menu[1;88r[88;1H
[1;89r[88;1H[    6.323498] registered taskstats version 1[1;88r[88;1H
[1;89r[88;1H[    6.323498] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)[1;88r[88;1H
[1;89r[88;1H[    6.333501] BIOS EDD facility v0.16 2004-Jun-25, 5 devices found[1;88r[88;1H
[1;89r[88;1H[    6.341941] Freeing unused kernel memory: 504k freed[1;88r[88;1H
[1;89r[88;1HLoading, please wait...[1;88r[88;1H
[1;89r[88;1HBegin: Loading essential drivers... ...[1;88r[88;1H
[1;89r[88;1H[    6.452574] fuse init (API version 7.9)[1;88r[88;1H
[1;89r[88;1H[    6.461876] ------------[ cut here ]------------[1;88r[88;1H
[1;89r[88;1H[    6.461876] kernel BUG at mm/vmalloc.c:217![1;88r[88;1H
[1;89r[88;1H[    6.461876] invalid opcode: 0000 [1] SMP [1;88r[88;1H
[1;89r[88;1H[    6.461876] CPU 1 [1;88r[88;1H
[1;89r[88;1H[    6.461876] Modules linked in: processor(+) fan thermal_sys fuse[1;88r[88;1H
[1;89r[88;1H[    6.461876] Pid: 1256, comm: modprobe Not tainted 2.6.27-rc2 #14[1;88r[88;1H
[1;89r[88;1H[    6.461876] RIP: 0010:[<ffffffff802a227e>]  [<ffffffff802a227e>] __get_vm_area_node+0x1fe/0x210[1;88r[88;1H
[1;89r[88;1H[    6.461876] RSP: 0018:ffff88021b157538  EFLAGS: 00010206[1;88r[88;1H
[1;89r[88;1H[    6.461876] RAX: ffffffff8022151a RBX: ffffc20000000000 RCX: ffffe1ffffffffff[1;88r[88;1H
[1;89r[88;1H[    6.461876] RDX: 00000000ffffffff RSI: 00000000000000d0 RDI: 0000000000002000[1;88r[88;1H
[1;89r[88;1H[    6.461876] RBP: ffff88021b157578 R08: 00000000ffffffff R09: 00000000000000d0[1;88r[88;1H
[1;89r[88;1H[    6.461876] R10: 0000000000001000 R11: 0000000000000000 R12: 0000000000000010[1;88r[88;1H
[1;89r[88;1H[    6.461876] R13: 00000000cffc3000 R14: 00000000cffc3b51 R15: 00000000cffc480a[1;88r[88;1H
[1;89r[88;1H[    6.461876] FS:  00007f13ac7606e0(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000[1;88r[88;1H
[1;89r[88;1H[    6.461876] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b[1;88r[88;1H
[1;89r[88;1H[    6.461876] CR2: 000000000044f360 CR3: 000000021ad66000 CR4: 00000000000006e0[1;88r[88;1H
[1;89r[88;1H[    6.461876] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000[1;88r[88;1H
[1;89r[88;1H[    6.461876] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400[1;88r[88;1H
[1;89r[88;1H[    6.461876] Process modprobe (pid: 1256, threadinfo ffff88021b156000, task ffff88021ac3c890)[1;88r[88;1H
[1;89r[88;1H[    6.461876] Stack:  ffffe1ffffffffff 0000000000000001 ffff88021b157558 0000000000002000[1;88r[88;1H
[1;89r[88;1H[    6.461876]  0000000000000010 00000000cffc3000 00000000cffc3b51 00000000cffc480a[1;88r[88;1H
[1;89r[88;1H[    6.461876]  ffff88021b157598 ffffffff802a2301 ffffffff8047f559 00000000cffc480a[1;88r[88;1H
[1;89r[88;1H[    6.461876] Call Trace:[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff802a2301>] get_vm_area_caller+0x31/0x40[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80225078>] __ioremap_caller+0x188/0x340[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80225342>] ioremap_nocache+0x12/0x20[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8047f559>] acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038f2a0>] acpi_ex_system_memory_space_handler+0xd2/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038805c>] acpi_ev_address_space_dispatch+0x172/0x1c1[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038c5e8>] acpi_ex_access_region+0x209/0x226[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038c6f4>] acpi_ex_field_datum_io+0xef/0x183[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038c814>] acpi_ex_extract_from_field+0x8c/0x1a1[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8039ac13>] ? acpi_ut_create_internal_object_dbg+0x26/0x90[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038b303>] acpi_ex_read_data_from_field+0x120/0x159[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8039018c>] acpi_ex_resolve_node_to_value+0x190/0x240[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038bda2>] acpi_ex_resolve_to_value+0x256/0x268[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80386586>] acpi_ds_evaluate_name_path+0x7a/0xff[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8038522e>] acpi_ds_exec_end_op+0x94/0x3ca[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80395395>] acpi_ps_parse_loop+0x6a3/0x876[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803945de>] acpi_ps_parse_aml+0x7e/0x2bb[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80395b87>] acpi_ps_execute_method+0x129/0x1d6[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803927a8>] acpi_ns_evaluate+0x150/0x1b4[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803922b8>] acpi_evaluate_object+0x140/0x1fc[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8021bf37>] ? arch_acpi_processor_init_pdc+0x97/0x160[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffffa01971bd>] ? acpi_processor_notify+0x0/0x108 [processor][1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffffa019b23e>] acpi_processor_start+0x612/0x774 [processor][1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8031234b>] ? __sysfs_add_one+0x6b/0xa0[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803133de>] ? sysfs_do_create_link+0xbe/0x140[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8039d01a>] acpi_start_single_object+0x2d/0x52[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8039e603>] acpi_device_probe+0x7e/0x92[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803d195b>] driver_probe_device+0x9b/0x1a0[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803d1ae6>] __driver_attach+0x86/0x90[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803d1a60>] ? __driver_attach+0x0/0x90[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803d0f84>] bus_for_each_dev+0x54/0x80[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80359f0a>] ? kobject_get+0x1a/0x30[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803d179c>] driver_attach+0x1c/0x20[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803d15b9>] bus_add_driver+0x1e9/0x260[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff803d1d7f>] driver_register+0x5f/0x140[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8039e913>] acpi_bus_register_driver+0x3e/0x40[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffffa0222094>] acpi_processor_init+0x94/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff802a2a8d>] ? __vunmap+0x8d/0xf0[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80209040>] _stext+0x40/0x180[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff80262902>] sys_init_module+0x142/0x1dc0[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8047e430>] ? cpu_down+0x0/0x70[1;88r[88;1H
[1;89r[88;1H[    6.461876]  [<ffffffff8020c34b>] system_call_fastpath+0x16/0x1b[1;88r[88;1H
[1;89r[88;1H[    6.461876] [1;88r[88;1H
[1;89r[88;1H[    6.461876] [1;88r[88;1H
[1;89r[88;1H[    6.461876] Code: f0 81 05 a2 3f 34 00 00 00 00 01 e9 78 ff ff ff 48 c7 c7 08 c7 58 80 31 c0 e8 ef a3 f9 ff 48 c7 45 d0 00 00 00 00 e9 5d ff ff [88;147Hf[88;147Hf[88;147H [88;147H<[88;147H0[88;147Hf[88;147H>[88;147H [88;147H0[88;147Hb[88;147H [88;147He[88;147Hb[88;147H [88;147Hf[88;147He[88;147H [88;147H6[88;147H6[88;147H [88;147H6[88;147H6[88;147H [88;147H6[88;147H6[88;147H [88;147H6[88;147H6[88;147H [88;147H6[88;147H6[88;147H [88;147H2[88;147He[88;147H [88;147H0[88;147Hf[88;147H [88;147H1[88;147Hf[88;147H [88;147H8[88;147H4[88;147H [88;147H0[88;147H0[88;147H [88;147H0[88;147H0[88;147H [88;147H0[88;147H0[88;147H [88;147H0[88;147H0[88;147H [88;147H0[88;147H0[88;147H [88;147H5[88;147H5[88;147H [88;147H4[88;147H1[88;147H [88;147H8[88;147H9[88;147H [88;147H[1;88r[88;1H
[1;89r[88;1H[    6.461876] RIP  [<ffffffff802a227e>] __get_vm_area_node+0x1fe/0x210[1;88r[88;1H
[1;89r[88;1H[    6.461876]  RSP <ffff88021b157538>[1;88r[88;1H
[1;89r[88;1H[    6.940630] BUG: unable to handle kernel paging request at ffff880827ff7990[1;88r[88;1H
[1;89r[88;1H[    6.947687] IP: [<ffffffff80237360>] task_tick_fair+0x40/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823] PGD 202063 PUD 0 [1;88r[88;1H
[1;89r[88;1H[    6.947823] Oops: 0000 [2] SMP [1;88r[88;1H
[1;89r[88;1H[    6.947823] CPU 1 [1;88r[88;1H
[1;89r[88;1H[    6.947823] Modules linked in: processor(+) fan thermal_sys fuse[1;88r[88;1H
[1;89r[88;1H[    6.947823] Pid: 1256, comm: modprobe Tainted: G      D   2.6.27-rc2 #14[1;88r[88;1H
[1;89r[88;1H[    6.947823] RIP: 0010:[<ffffffff80237360>]  [<ffffffff80237360>] task_tick_fair+0x40/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823] RSP: 0018:ffff88022f0a3e38  EFLAGS: 00010082[1;88r[88;1H
[1;89r[88;1H[    6.947823] RAX: ffff880028033980 RBX: ffffffff81024c80 RCX: 0000000000000004[1;88r[88;1H
[1;89r[88;1H[    6.947823] RDX: 00000000ffff8802 RSI: ffff88021ac3c890 RDI: ffff880028054c80[1;88r[88;1H
[1;89r[88;1H[    6.947823] RBP: ffff88022f0a3e68 R08: 0000000000000400 R09: 0000000000000010[1;88r[88;1H
[1;89r[88;1H[    6.947823] R10: ffff8800a7030000 R11: 0000000000000000 R12: ffff88021ac3c890[1;88r[88;1H
[1;89r[88;1H[    6.947823] R13: 0000000000000000 R14: ffff880028050aa0 R15: ffff88021ac3c8c8[1;88r[88;1H
[1;89r[88;1H[    6.947823] FS:  00007f13ac7606e0(0000) GS:ffff88022fc02980(0000) knlGS:0000000000000000[1;88r[88;1H
[1;89r[88;1H[    6.947823] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b[1;88r[88;1H
[1;89r[88;1H[    6.947823] CR2: ffff880827ff7990 CR3: 000000021ad66000 CR4: 00000000000006e0[1;88r[88;1H
[1;89r[88;1H[    6.947823] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000[1;88r[88;1H
[1;89r[88;1H[    6.947823] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400[1;88r[88;1H
[1;89r[88;1H[    6.947823] Process modprobe (pid: 1256, threadinfo ffff88021b156000, task ffff88021ac3c890)[1;88r[88;1H
[1;89r[88;1H[    6.947823] Stack:  ffff88022f0a3e68 ffff880028054c80 0000000000000001 ffff88021ac3c890[1;88r[88;1H
[1;89r[88;1H[    6.947823]  ffff880028050aa0 7fffffffffffffff ffff88022f0a3e98 ffffffff802386a3[1;88r[88;1H
[1;89r[88;1H[    6.947823]  ffff88022f0a3e98 0000000000000001 0000000000000000 ffff88021ac3c890[1;88r[88;1H
[1;89r[88;1H[    6.947823] Call Trace:[1;88r[88;1H
[1;89r[88;1H[    6.947823]  <IRQ>  [<ffffffff802386a3>] scheduler_tick+0xc3/0x210[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80245f01>] update_process_times+0x51/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8025bb4d>] tick_sched_timer+0x6d/0xe0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80253c6f>] __run_hrtimer+0x8f/0xa0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80254918>] hrtimer_interrupt+0x118/0x180[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8021d433>] smp_apic_timer_interrupt+0x83/0xc0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020d046>] apic_timer_interrupt+0x66/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  <EOI>  [<ffffffff80490b6a>] ? oops_end+0x4a/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020dfee>] ? die+0x5e/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff804910b0>] ? do_trap+0x130/0x150[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020e5c2>] ? do_invalid_op+0x92/0xb0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a227e>] ? __get_vm_area_node+0x1fe/0x210[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff804907c9>] ? error_exit+0x0/0x51[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8022151a>] ? flat_send_IPI_allbutself+0x6a/0x80[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a227e>] ? __get_vm_area_node+0x1fe/0x210[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a2301>] ? get_vm_area_caller+0x31/0x40[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80225078>] ? __ioremap_caller+0x188/0x340[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80225342>] ? ioremap_nocache+0x12/0x20[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038f2a0>] ? acpi_ex_system_memory_space_handler+0xd2/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038805c>] ? acpi_ev_address_space_dispatch+0x172/0x1c1[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038c5e8>] ? acpi_ex_access_region+0x209/0x226[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038c6f4>] ? acpi_ex_field_datum_io+0xef/0x183[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038c814>] ? acpi_ex_extract_from_field+0x8c/0x1a1[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039ac13>] ? acpi_ut_create_internal_object_dbg+0x26/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038b303>] ? acpi_ex_read_data_from_field+0x120/0x159[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039018c>] ? acpi_ex_resolve_node_to_value+0x190/0x240[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038bda2>] ? acpi_ex_resolve_to_value+0x256/0x268[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80386586>] ? acpi_ds_evaluate_name_path+0x7a/0xff[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038522e>] ? acpi_ds_exec_end_op+0x94/0x3ca[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80395395>] ? acpi_ps_parse_loop+0x6a3/0x876[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803945de>] ? acpi_ps_parse_aml+0x7e/0x2bb[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80395b87>] ? acpi_ps_execute_method+0x129/0x1d6[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803927a8>] ? acpi_ns_evaluate+0x150/0x1b4[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803922b8>] ? acpi_evaluate_object+0x140/0x1fc[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8021bf37>] ? arch_acpi_processor_init_pdc+0x97/0x160[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa01971bd>] ? acpi_processor_notify+0x0/0x108 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa019b23e>] ? acpi_processor_start+0x612/0x774 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8031234b>] ? __sysfs_add_one+0x6b/0xa0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803133de>] ? sysfs_do_create_link+0xbe/0x140[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039d01a>] ? acpi_start_single_object+0x2d/0x52[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039e603>] ? acpi_device_probe+0x7e/0x92[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d195b>] ? driver_probe_device+0x9b/0x1a0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d1ae6>] ? __driver_attach+0x86/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d1a60>] ? __driver_attach+0x0/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d0f84>] ? bus_for_each_dev+0x54/0x80[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80359f0a>] ? kobject_get+0x1a/0x30[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d179c>] ? driver_attach+0x1c/0x20[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d15b9>] ? bus_add_driver+0x1e9/0x260[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d1d7f>] ? driver_register+0x5f/0x140[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039e913>] ? acpi_bus_register_driver+0x3e/0x40[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a2a8d>] ? __vunmap+0x8d/0xf0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80209040>] ? _stext+0x40/0x180[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80262902>] ? sys_init_module+0x142/0x1dc0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047e430>] ? cpu_down+0x0/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b[1;88r[88;1H
[1;89r[88;1H[    6.947823] [1;88r[88;1H
[1;89r[88;1H[    6.947823] [1;88r[88;1H
[1;89r[88;1H[    6.947823] Code: c7 38 4c 89 6d e8 48 89 5d d8 4c 89 75 f0 49 89 f4 41 89 d5 74 65 48 8b 46 08 48 c7 c3 80 4c 02 81 8b 50 1c 48 8b 05 68 a3 91 [88;147H0[88;147H0[88;147H [88;147H<[88;147H4[88;147H8[88;147H>[88;147H [88;147H8[88;147Hb[88;147H [88;147H0[88;147H4[88;147H [88;147Hd[88;147H0[88;147H [88;147H4[88;147H8[88;147H [88;147H0[88;147H3[88;147H [88;147H5[88;147H8[88;147H [88;147H0[88;147H8[88;147H [88;147H4[88;147Hc[88;147H [88;147H8[88;147Hd[88;147H [88;147H7[88;147H3[88;147H [88;147H7[88;147H0[88;147H [88;147H4[88;147Hc[88;147H [88;147H8[88;147H9[88;147H [88;147Hf[88;147H7[88;147H [88;147He[88;147H8[88;147H [88;147H7[88;147Hc[88;147H [88;147H5[88;147H3[88;147H [88;147Hf[88;147Hf[88;147H [88;147Hf[88;147Hf[88;147H [88;147H4[88;147H5[88;147H [88;147H[1;88r[88;1H
[1;89r[88;1H[    6.947823] RIP  [<ffffffff80237360>] task_tick_fair+0x40/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  RSP <ffff88022f0a3e38>[1;88r[88;1H
[1;89r[88;1H[    6.947823] CR2: ffff880827ff7990[1;88r[88;1H
[1;89r[88;1H[    6.947823] ---[ end trace 01cb030c995eed4a ]---[1;88r[88;1H
[1;89r[88;1H[    6.947823] Kernel panic - not syncing: Aiee, killing interrupt handler![1;88r[88;1H
[1;89r[88;1H[    6.947823] ------------[ cut here ]------------[1;88r[88;1H
[1;89r[88;1H[    6.947823] WARNING: at kernel/smp.c:326 smp_call_function_mask+0x25e/0x270()[1;88r[88;1H
[1;89r[88;1H[    6.947823] Modules linked in: processor(+) fan thermal_sys fuse[1;88r[88;1H
[1;89r[88;1H[    6.947823] Pid: 1256, comm: modprobe Tainted: G      D   2.6.27-rc2 #14[1;88r[88;1H
[1;89r[88;1H[    6.947823] [1;88r[88;1H
[1;89r[88;1H[    6.947823] Call Trace:[1;88r[88;1H
[1;89r[88;1H[    6.947823]  <IRQ>  [<ffffffff8023b5cf>] warn_on_slowpath+0x5f/0x80[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8026040e>] smp_call_function_mask+0x25e/0x270[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8021c270>] ? stop_this_cpu+0x0/0x30[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f1fd>] ? string+0x3d/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f6cb>] ? vsnprintf+0x43b/0x720[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f1fd>] ? string+0x3d/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f1fd>] ? string+0x3d/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f6cb>] ? vsnprintf+0x43b/0x720[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035e99e>] ? number+0x2ae/0x2d0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035e99e>] ? number+0x2ae/0x2d0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802650fd>] ? kallsyms_lookup+0x5d/0xa0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035e99e>] ? number+0x2ae/0x2d0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f6cb>] ? vsnprintf+0x43b/0x720[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035fa18>] ? sprintf+0x68/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f1fd>] ? string+0x3d/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8035f5f0>] ? vsnprintf+0x360/0x720[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803606c7>] ? delay_tsc+0x37/0x60[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8037d261>] ? vgacon_set_cursor_size+0xb1/0x130[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8049307d>] ? __atomic_notifier_call_chain+0xd/0x10[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80493091>] ? atomic_notifier_call_chain+0x11/0x20[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8021c270>] ? stop_this_cpu+0x0/0x30[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80260460>] smp_call_function+0x40/0x50[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8021c2f3>] native_smp_send_stop+0x23/0x40[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8023b90f>] panic+0xaf/0x190[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8023c6c7>] ? printk+0x67/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802557e1>] ? blocking_notifier_call_chain+0x11/0x20[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8023f389>] do_exit+0x8f9/0x9a0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803bc8a9>] ? do_unblank_screen+0x19/0x130[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80490ba7>] oops_end+0x87/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80492e63>] do_page_fault+0x663/0x800[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff804907c9>] error_exit+0x0/0x51[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80237360>] ? task_tick_fair+0x40/0xd0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802386a3>] scheduler_tick+0xc3/0x210[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80245f01>] update_process_times+0x51/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8025bb4d>] tick_sched_timer+0x6d/0xe0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80253c6f>] __run_hrtimer+0x8f/0xa0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80254918>] hrtimer_interrupt+0x118/0x180[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8021d433>] smp_apic_timer_interrupt+0x83/0xc0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020d046>] apic_timer_interrupt+0x66/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  <EOI>  [<ffffffff80490b6a>] ? oops_end+0x4a/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020dfee>] ? die+0x5e/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff804910b0>] ? do_trap+0x130/0x150[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020e5c2>] ? do_invalid_op+0x92/0xb0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a227e>] ? __get_vm_area_node+0x1fe/0x210[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff804907c9>] ? error_exit+0x0/0x51[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8022151a>] ? flat_send_IPI_allbutself+0x6a/0x80[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a227e>] ? __get_vm_area_node+0x1fe/0x210[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a2301>] ? get_vm_area_caller+0x31/0x40[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80225078>] ? __ioremap_caller+0x188/0x340[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80225342>] ? ioremap_nocache+0x12/0x20[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047f559>] ? acpi_os_map_memory+0x12/0x29[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038f2a0>] ? acpi_ex_system_memory_space_handler+0xd2/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038f1ce>] ? acpi_ex_system_memory_space_handler+0x0/0x1be[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038805c>] ? acpi_ev_address_space_dispatch+0x172/0x1c1[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038c5e8>] ? acpi_ex_access_region+0x209/0x226[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038c6f4>] ? acpi_ex_field_datum_io+0xef/0x183[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038c814>] ? acpi_ex_extract_from_field+0x8c/0x1a1[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039ac13>] ? acpi_ut_create_internal_object_dbg+0x26/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038b303>] ? acpi_ex_read_data_from_field+0x120/0x159[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039018c>] ? acpi_ex_resolve_node_to_value+0x190/0x240[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038bda2>] ? acpi_ex_resolve_to_value+0x256/0x268[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80386586>] ? acpi_ds_evaluate_name_path+0x7a/0xff[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8038522e>] ? acpi_ds_exec_end_op+0x94/0x3ca[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80395395>] ? acpi_ps_parse_loop+0x6a3/0x876[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803945de>] ? acpi_ps_parse_aml+0x7e/0x2bb[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80395b87>] ? acpi_ps_execute_method+0x129/0x1d6[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803927a8>] ? acpi_ns_evaluate+0x150/0x1b4[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803922b8>] ? acpi_evaluate_object+0x140/0x1fc[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8021bf37>] ? arch_acpi_processor_init_pdc+0x97/0x160[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa01971bd>] ? acpi_processor_notify+0x0/0x108 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa019b23e>] ? acpi_processor_start+0x612/0x774 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8031234b>] ? __sysfs_add_one+0x6b/0xa0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803133de>] ? sysfs_do_create_link+0xbe/0x140[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039d01a>] ? acpi_start_single_object+0x2d/0x52[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039e603>] ? acpi_device_probe+0x7e/0x92[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d195b>] ? driver_probe_device+0x9b/0x1a0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d1ae6>] ? __driver_attach+0x86/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d1a60>] ? __driver_attach+0x0/0x90[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d0f84>] ? bus_for_each_dev+0x54/0x80[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80359f0a>] ? kobject_get+0x1a/0x30[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d179c>] ? driver_attach+0x1c/0x20[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d15b9>] ? bus_add_driver+0x1e9/0x260[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff803d1d7f>] ? driver_register+0x5f/0x140[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa0222000>] ? acpi_processor_init+0x0/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8039e913>] ? acpi_bus_register_driver+0x3e/0x40[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffffa0222094>] ? acpi_processor_init+0x94/0x107 [processor][1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff802a2a8d>] ? __vunmap+0x8d/0xf0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80209040>] ? _stext+0x40/0x180[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff80262902>] ? sys_init_module+0x142/0x1dc0[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8047e430>] ? cpu_down+0x0/0x70[1;88r[88;1H
[1;89r[88;1H[    6.947823]  [<ffffffff8020c34b>] ? system_call_fastpath+0x16/0x1b[1;88r[88;1H
[1;89r[88;1H[    6.947823] [1;88r[88;1H
[1;89r[88;1H[    6.947823] ---[ end trace 01cb030c995eed4a ]---[1;88r[88;1H

--------------050809060402060002090504--
