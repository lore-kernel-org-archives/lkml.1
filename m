Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZLZSwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZLZSwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 13:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZLZSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 13:52:06 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35991 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZLZSwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 13:52:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jEfgveN9xMRqTqsP9dEcPfTsUUQBvLmjqa9fgqIoV3jTIwaV+0GiURdP5L4gHa4vaL
         Hrf1PCK/QaR3cAVe4BpT22Um8RY+0fTnpR2b/iz3bkVQ1Y12Xo9nLLolg9HhOny5Utrb
         91hWLnsKsVnf/VY+wiaf4oDliqwz6G3iTC0O8=
MIME-Version: 1.0
In-Reply-To: <c2673ca60912261049i6539b54ci6663bc60dde8d096@mail.gmail.com>
References: <c2673ca60912261049i6539b54ci6663bc60dde8d096@mail.gmail.com>
Date: Sat, 26 Dec 2009 19:51:57 +0100
Message-ID: <c2673ca60912261051q40049708j7e9de0b34f7a1a13@mail.gmail.com>
Subject: Re: 2.6.33-rc2 allergic to amanda?
From: okias <d.okias@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same problem after "sync" on /boot partition ext2 mounted by ext4 (new
option in Kconfig)

/dev/sda1 on /boot type ext2 (rw,noatime)

here is log:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.33-rc2 (okias@rs55a) (gcc version
4.4.2 (Gentoo 4.4.2 p1.0) ) #1 SMP Fri Dec 25 16:58:53 CET 2009
[    0.000000] Command line: ro root=/dev/sda2 quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099000 (usable)
[    0.000000]  BIOS-e820: 0000000000099000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff90000 (usable)
[    0.000000]  BIOS-e820: 00000000bff90000 - 00000000bff9e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bff9e000 - 00000000bffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bffe0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xbff90 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff90000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bff90000 page 4k
[    0.000000] kernel direct mapping tables up to bff90000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ 19000-1f000
[    0.000000] ACPI: RSDP 00000000000f94e0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bff90000 00048 (v01 MSI_NB MEGABOOK
20090812 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bff90200 00084 (v01 081209 FACP1422
20090812 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bff905c0 07FC2 (v01  1ADTS 1ADTS008
00000008 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bff9e000 00040
[    0.000000] ACPI: APIC 00000000bff90390 0006C (v01 081209 APIC1422
20090812 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bff90400 0003C (v01 081209 OEMMCFG
20090812 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bff90440 00176 (v01 MSI_NB MEGABOOK
20090812 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bff9e040 00072 (v01 081209 OEMB1422
20090812 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bff985c0 00038 (v01 081209 OEMHPET
20090812 MSFT 00000097)
[    0.000000] ACPI: ASF! 00000000bff98600 00099 (v32 LEGEND I865PASF
00000001 INTL 20051117)
[    0.000000] ACPI: GSCI 00000000bff9e0c0 02024 (v01 081209 GMCHSCI
20090812 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bffa0a50 004F0 (v01  PmRef    CpuPm
00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [000000000001a000 - 000000000001efff]
[    0.000000]   bootmap [000000000001f000 -  0000000000046fff] pages 28
[    0.000000] (12 early reservations) ==> bootmem [0000000000 - 0140000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0001c39374]    TEXT DATA BSS ==>
[0001000000 - 0001c39374]
[    0.000000]   #2 [0001c3a000 - 0001c3a14f]              BRK ==>
[0001c3a000 - 0001c3a14f]
[    0.000000]   #3 [00000ff790 - 0000100000]    BIOS reserved ==>
[00000ff790 - 0000100000]
[    0.000000]   #4 [00000ff780 - 00000ff790]     MP-table mpf ==>
[00000ff780 - 00000ff790]
[    0.000000]   #5 [0000099000 - 00000fbbc0]    BIOS reserved ==>
[0000099000 - 00000fbbc0]
[    0.000000]   #6 [00000fbd5c - 00000ff780]    BIOS reserved ==>
[00000fbd5c - 00000ff780]
[    0.000000]   #7 [00000fbbc0 - 00000fbd5c]     MP-table mpc ==>
[00000fbbc0 - 00000fbd5c]
[    0.000000]   #8 [0000010000 - 0000012000]       TRAMPOLINE ==>
[0000010000 - 0000012000]
[    0.000000]   #9 [0000012000 - 0000016000]      ACPI WAKEUP ==>
[0000012000 - 0000016000]
[    0.000000]   #10 [0000016000 - 0000019000]          PGTABLE ==>
[0000016000 - 0000019000]
[    0.000000]   #11 [0000019000 - 000001a000]          PGTABLE ==>
[0000019000 - 000001a000]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD ->
[ffff880028600000-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000bff90
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1048345
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 112 pages reserved
[    0.000000]   DMA zone: 3809 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767944 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bff90000 - 00000000bff9e000
[    0.000000] PM: Registered nosave memory: 00000000bff9e000 - 00000000bffe0000
[    0.000000] PM: Registered nosave memory: 00000000bffe0000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:3ee00000)
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880028200000 s76888
r8192 d21416 u1048576
[    0.000000] pcpu-alloc: s76888 r8192 d21416 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 1030313
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ro root=/dev/sda2 quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4057100k/5242880k available (6339k kernel code,
1049500k absent, 136280k reserved, 4791k data, 544k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2261.062 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4522.12 BogoMIPS (lpj=2261062)
[    0.001306] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.003742] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004768] Mount-cache hash table entries: 256
[    0.004897] Initializing cgroup subsys ns
[    0.004902] Initializing cgroup subsys cpuacct
[    0.004927] CPU: Physical Processor ID: 0
[    0.004928] CPU: Processor Core ID: 0
[    0.004931] using mwait in idle threads.
[    0.004932] Performance Events: Core2 events, Intel PMU driver.
[    0.004937] ... version:                2
[    0.004938] ... bit width:              40
[    0.004940] ... generic registers:      2
[    0.004941] ... value mask:             000000ffffffffff
[    0.004942] ... max period:             000000007fffffff
[    0.004943] ... fixed-purpose events:   3
[    0.004944] ... event mask:             0000000700000003
[    0.004964] ACPI: Core revision 20091214
[    0.016058] Setting APIC routing to flat
[    0.016386] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026545] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 06
[    0.026999] Booting Node   0, Processors  #1 Ok.
[    0.098027] Brought up 2 CPUs
[    0.098030] Total of 2 processors activated (9043.88 BogoMIPS).
[    0.098584] PM: Adding info for No Bus:platform
[    0.098584] Time: 12:02:22  Date: 12/26/09
[    0.099012] NET: Registered protocol family 16
[    0.099028] PM: Adding info for No Bus:vtcon0
[    0.099028] ACPI: bus type pci registered
[    0.099028] PM: Adding info for No Bus:id
[    0.099037] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.099038] PCI: not using MMCONFIG
[    0.099039] PCI: Using configuration type 1 for base access
[    0.106072] PM: Adding info for No Bus:default
[    0.106072] bio: create slab <bio-0> at 0
[    0.107673] ACPI: EC: Detected MSI hardware, enabling workarounds.
[    0.107675] ACPI: EC: Look up EC in DSDT
[    0.110271] ACPI: Executed 1 blocks of module-level executable AML code
[    0.116308] ACPI: SSDT 00000000bffa01c0 00259 (v01  PmRef  Cpu0Ist
00003000 INTL 20051117)
[    0.116844] ACPI: SSDT 00000000bffa04b0 00594 (v01  PmRef  Cpu0Cst
00003001 INTL 20051117)
[    0.117467] ACPI: SSDT 00000000bffa00f0 000CC (v01  PmRef  Cpu1Ist
00003000 INTL 20051117)
[    0.117864] ACPI: SSDT 00000000bffa0420 00085 (v01  PmRef  Cpu1Cst
00003000 INTL 20051117)
[    0.118389] ACPI: Interpreter enabled
[    0.118393] ACPI: (supports S0 S3 S4 S5)
[    0.118409] ACPI: Using IOAPIC for interrupt routing
[    0.118457] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.128557] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved
in ACPI motherboard resources
[    0.134500] PM: Adding info for acpi:LNXSYSTM:00
[    0.134500] PM: Adding info for acpi:LNXCPU:00
[    0.134500] PM: Adding info for acpi:LNXCPU:01
[    0.134500] PM: Adding info for acpi:LNXCPU:02
[    0.134500] PM: Adding info for acpi:LNXCPU:03
[    0.134500] PM: Adding info for acpi:LNXSYBUS:00
[    0.134500] PM: Adding info for acpi:PNP0A08:00
[    0.134500] PM: Adding info for acpi:PNP0C02:00
[    0.135128] PM: Adding info for acpi:device:00
[    0.135136] PM: Adding info for acpi:LNXVIDEO:00
[    0.135136] PM: Adding info for acpi:device:01
[    0.135136] PM: Adding info for acpi:device:02
[    0.135136] PM: Adding info for acpi:device:03
[    0.135136] PM: Adding info for acpi:device:04
[    0.135136] PM: Adding info for acpi:pnp0c14:00
[    0.135154] PM: Adding info for acpi:device:05
[    0.135163] PM: Adding info for acpi:device:06
[    0.135163] PM: Adding info for acpi:PNP0000:00
[    0.135163] PM: Adding info for acpi:PNP0200:00
[    0.135163] PM: Adding info for acpi:PNP0100:00
[    0.135163] PM: Adding info for acpi:PNP0B00:00
[    0.136024] PM: Adding info for acpi:PNP0303:00
[    0.136112] PM: Adding info for acpi:PNP0F03:00
[    0.136121] PM: Adding info for acpi:PNP0800:00
[    0.136121] PM: Adding info for acpi:PNP0C04:00
[    0.136121] PM: Adding info for acpi:PNP0C02:01
[    0.136168] PM: Adding info for acpi:PNP0103:00
[    0.136177] PM: Adding info for acpi:INT0800:00
[    0.136177] PM: Adding info for acpi:PNP0C02:02
[    0.136177] PM: Adding info for acpi:PNP0C02:03
[    0.136177] PM: Adding info for acpi:PNP0C09:00
[    0.136177] PM: Adding info for acpi:ACPI0003:00
[    0.144699] PM: Adding info for acpi:PNP0C0A:00
[    0.144707] PM: Adding info for acpi:PNP0C0D:00
[    0.144707] PM: Adding info for acpi:pnp0c14:01
[    0.144707] PM: Adding info for acpi:ENE0100:00
[    0.145044] PM: Adding info for acpi:PNP0C02:04
[    0.145052] PM: Adding info for acpi:device:07
[    0.145052] PM: Adding info for acpi:device:08
[    0.145052] PM: Adding info for acpi:device:09
[    0.145052] PM: Adding info for acpi:device:0a
[    0.145055] PM: Adding info for acpi:device:0b
[    0.145055] PM: Adding info for acpi:device:0c
[    0.145055] PM: Adding info for acpi:device:0d
[    0.145055] PM: Adding info for acpi:device:0e
[    0.145055] PM: Adding info for acpi:device:0f
[    0.145055] PM: Adding info for acpi:device:10
[    0.145055] PM: Adding info for acpi:device:11
[    0.145055] PM: Adding info for acpi:device:12
[    0.145055] PM: Adding info for acpi:device:13
[    0.145055] PM: Adding info for acpi:device:14
[    0.145055] PM: Adding info for acpi:device:15
[    0.145055] PM: Adding info for acpi:device:16
[    0.146213] PM: Adding info for acpi:device:17
[    0.146331] PM: Adding info for acpi:device:18
[    0.146340] PM: Adding info for acpi:device:19
[    0.146340] PM: Adding info for acpi:device:1a
[    0.147014] PM: Adding info for acpi:device:1b
[    0.147331] PM: Adding info for acpi:device:1c
[    0.147340] PM: Adding info for acpi:device:1d
[    0.147340] PM: Adding info for acpi:device:1e
[    0.147340] PM: Adding info for acpi:device:1f
[    0.147340] PM: Adding info for acpi:device:20
[    0.148326] PM: Adding info for acpi:device:21
[    0.148334] PM: Adding info for acpi:device:22
[    0.148343] PM: Adding info for acpi:device:23
[    0.148343] PM: Adding info for acpi:device:24
[    0.148343] PM: Adding info for acpi:device:25
[    0.149143] PM: Adding info for acpi:device:26
[    0.149153] PM: Adding info for acpi:device:27
[    0.149161] PM: Adding info for acpi:device:28
[    0.149161] PM: Adding info for acpi:device:29
[    0.149164] PM: Adding info for acpi:device:2a
[    0.149164] PM: Adding info for acpi:device:2b
[    0.150107] PM: Adding info for acpi:device:2c
[    0.150119] PM: Adding info for acpi:device:2d
[    0.150127] PM: Adding info for acpi:device:2e
[    0.150127] PM: Adding info for acpi:device:2f
[    0.150127] PM: Adding info for acpi:device:30
[    0.150156] PM: Adding info for acpi:device:31
[    0.150164] PM: Adding info for acpi:device:32
[    0.151035] PM: Adding info for acpi:device:33
[    0.151113] PM: Adding info for acpi:PNP0C01:00
[    0.151121] PM: Adding info for acpi:PNP0C0C:00
[    0.151121] PM: Adding info for acpi:PNP0C0F:00
[    0.151121] PM: Adding info for acpi:PNP0C0F:01
[    0.151121] PM: Adding info for acpi:PNP0C0F:02
[    0.151121] PM: Adding info for acpi:PNP0C0F:03
[    0.151123] PM: Adding info for acpi:PNP0C0F:04
[    0.151123] PM: Adding info for acpi:PNP0C0F:05
[    0.152086] PM: Adding info for acpi:PNP0C0F:06
[    0.152113] PM: Adding info for acpi:PNP0C0F:07
[    0.152121] PM: Adding info for acpi:LNXTHERM:00
[    0.152121] PM: Adding info for acpi:LNXPWRBN:00
[    0.152121] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.152182] ACPI: No dock devices found.
[    0.152460] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.152473] PM: Adding info for No Bus:pci0000:00
[    0.152480] PM: Adding info for No Bus:0000:00
[    0.152488] pci_root PNP0A08:00: ignoring host bridge windows from
ACPI; boot with "pci=use_crs" to use them
[    0.153231] pci_root PNP0A08:00: host bridge window [io
0x0000-0x0cf7] (ignored)
[    0.153233] pci_root PNP0A08:00: host bridge window [io
0x0d00-0xffff] (ignored)
[    0.153236] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.153238] pci_root PNP0A08:00: host bridge window [mem
0x000d0000-0x000dffff] (ignored)
[    0.153240] pci_root PNP0A08:00: host bridge window [mem
0xc0000000-0xdfffffff] (ignored)
[    0.153242] pci_root PNP0A08:00: host bridge window [mem
0xf0000000-0xfed8ffff] (ignored)
[    0.153269] DMAR: Forcing write-buffer flush capability
[    0.153311] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.153314] pci 0000:00:01.0: PME# disabled
[    0.153376] pci 0000:00:1a.0: reg 20: [io  0xa800-0xa81f]
[    0.153436] pci 0000:00:1a.1: reg 20: [io  0xa480-0xa49f]
[    0.153496] pci 0000:00:1a.2: reg 20: [io  0xa400-0xa41f]
[    0.153555] pci 0000:00:1a.7: reg 10: [mem 0xf8efec00-0xf8efefff]
[    0.153606] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.153610] pci 0000:00:1a.7: PME# disabled
[    0.153641] pci 0000:00:1b.0: reg 10: [mem 0xf8ef8000-0xf8efbfff 64bit]
[    0.153679] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.153682] pci 0000:00:1b.0: PME# disabled
[    0.153741] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.153744] pci 0000:00:1c.0: PME# disabled
[    0.153804] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.153807] pci 0000:00:1c.1: PME# disabled
[    0.153867] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.153870] pci 0000:00:1c.2: PME# disabled
[    0.153930] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.153934] pci 0000:00:1c.3: PME# disabled
[    0.153994] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.154002] pci 0000:00:1c.5: PME# disabled
[    0.154049] pci 0000:00:1d.0: reg 20: [io  0xb000-0xb01f]
[    0.154112] pci 0000:00:1d.1: reg 20: [io  0xac00-0xac1f]
[    0.154172] pci 0000:00:1d.2: reg 20: [io  0xa880-0xa89f]
[    0.154231] pci 0000:00:1d.7: reg 10: [mem 0xf8eff000-0xf8eff3ff]
[    0.154282] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.154286] pci 0000:00:1d.7: PME# disabled
[    0.154438] pci 0000:00:1f.2: reg 10: [io  0xbc00-0xbc07]
[    0.154443] pci 0000:00:1f.2: reg 14: [io  0xb880-0xb883]
[    0.154448] pci 0000:00:1f.2: reg 18: [io  0xb800-0xb807]
[    0.154453] pci 0000:00:1f.2: reg 1c: [io  0xb480-0xb483]
[    0.154458] pci 0000:00:1f.2: reg 20: [io  0xb400-0xb41f]
[    0.154463] pci 0000:00:1f.2: reg 24: [mem 0xf8eff800-0xf8efffff]
[    0.154492] pci 0000:00:1f.2: PME# supported from D3hot
[    0.154495] pci 0000:00:1f.2: PME# disabled
[    0.154520] pci 0000:00:1f.3: reg 10: [mem 0xf8eff400-0xf8eff4ff 64bit]
[    0.154532] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.154577] pci 0000:08:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.154588] pci 0000:08:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.154599] pci 0000:08:00.0: reg 1c: [mem 0xfa000000-0xfbffffff 64bit]
[    0.154605] pci 0000:08:00.0: reg 24: [io  0xec00-0xec7f]
[    0.154611] pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[    0.156038] pci 0000:00:01.0: PCI bridge to [bus 08-08]
[    0.156041] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.156044] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfebfffff]
[    0.156048] pci 0000:00:01.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.156088] pci 0000:02:00.0: reg 10: [io  0xc800-0xc8ff]
[    0.156109] pci 0000:02:00.0: reg 18: [mem 0xf8fff000-0xf8ffffff 64bit]
[    0.156130] pci 0000:02:00.0: reg 30: [mem 0xf8fe0000-0xf8fe1fff pref]
[    0.156176] pci 0000:02:00.0: supports D1 D2
[    0.156177] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.156182] pci 0000:02:00.0: PME# disabled
[    0.156199] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.156236] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.156240] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.156243] pci 0000:00:1c.0:   bridge window [mem 0xf8f00000-0xf8ffffff]
[    0.156282] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.156286] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.156289] pci 0000:00:1c.1:   bridge window [mem 0xf9000000-0xf9dfffff]
[    0.156295] pci 0000:00:1c.1:   bridge window [mem
0xce000000-0xcfffffff 64bit pref]
[    0.156330] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.156392] pci 0000:06:00.0: reg 10: [mem 0xf9efe000-0xf9efffff 64bit]
[    0.156482] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.156488] pci 0000:06:00.0: PME# disabled
[    0.158045] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.158050] pci 0000:00:1c.3:   bridge window [mem 0xf9e00000-0xf9efffff]
[    0.158093] pci 0000:07:00.0: reg 10: [mem 0xf9fff800-0xf9ffffff]
[    0.158103] pci 0000:07:00.0: reg 14: [mem 0xf9fff400-0xf9fff47f]
[    0.158129] pci 0000:07:00.0: reg 20: [mem 0xf9fff000-0xf9fff07f]
[    0.158139] pci 0000:07:00.0: reg 24: [mem 0xf9ffec00-0xf9ffec7f]
[    0.158230] pci 0000:07:00.1: reg 10: [mem 0xf9ffe800-0xf9ffe8ff]
[    0.158344] pci 0000:07:00.2: reg 10: [mem 0xf9ffe400-0xf9ffe4ff]
[    0.158459] pci 0000:07:00.3: reg 10: [mem 0xf9ffe000-0xf9ffe0ff]
[    0.158574] pci 0000:07:00.4: reg 10: [mem 0xf9ffdc00-0xf9ffdcff]
[    0.160047] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    0.160053] pci 0000:00:1c.5:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    0.160103] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.160137] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.160310] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.160361] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.160412] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.160464] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.160543] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.161607] PM: Adding info for pci:0000:00:00.0
[    0.162518] PM: Adding info for pci:0000:00:01.0
[    0.163428] PM: Adding info for pci:0000:00:1a.0
[    0.164334] PM: Adding info for pci:0000:00:1a.1
[    0.165242] PM: Adding info for pci:0000:00:1a.2
[    0.166152] PM: Adding info for pci:0000:00:1a.7
[    0.167062] PM: Adding info for pci:0000:00:1b.0
[    0.167884] PM: Adding info for pci:0000:00:1c.0
[    0.168871] PM: Adding info for pci:0000:00:1c.1
[    0.169777] PM: Adding info for pci:0000:00:1c.2
[    0.170689] PM: Adding info for pci:0000:00:1c.3
[    0.171595] PM: Adding info for pci:0000:00:1c.5
[    0.172508] PM: Adding info for pci:0000:00:1d.0
[    0.173416] PM: Adding info for pci:0000:00:1d.1
[    0.174327] PM: Adding info for pci:0000:00:1d.2
[    0.175236] PM: Adding info for pci:0000:00:1d.7
[    0.176148] PM: Adding info for pci:0000:00:1e.0
[    0.177052] PM: Adding info for pci:0000:00:1f.0
[    0.177888] PM: Adding info for pci:0000:00:1f.2
[    0.178861] PM: Adding info for pci:0000:00:1f.3
[    0.178871] PM: Adding info for pci:0000:08:00.0
[    0.178871] PM: Adding info for No Bus:0000:08
[    0.178871] PM: Adding info for pci:0000:02:00.0
[    0.179018] PM: Adding info for No Bus:0000:02
[    0.179025] PM: Adding info for No Bus:0000:03
[    0.179025] PM: Adding info for No Bus:0000:05
[    0.179028] PM: Adding info for pci:0000:06:00.0
[    0.179037] PM: Adding info for No Bus:0000:06
[    0.179251] PM: Adding info for pci:0000:07:00.0
[    0.179261] PM: Adding info for pci:0000:07:00.1
[    0.179262] PM: Adding info for pci:0000:07:00.2
[    0.180215] PM: Adding info for pci:0000:07:00.3
[    0.180249] PM: Adding info for pci:0000:07:00.4
[    0.180259] PM: Adding info for No Bus:0000:07
[    0.180259] PM: Adding info for No Bus:0000:01
[    0.180259] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.180259] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.180313] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.181011] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.181121] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12
14 15) *0, disabled.
[    0.181229] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.181338] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.181445] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.181493] SCSI subsystem initialized
[    0.181493] libata version 3.00 loaded.
[    0.181493] usbcore: registered new interface driver usbfs
[    0.181493] usbcore: registered new interface driver hub
[    0.181493] usbcore: registered new device driver usb
[    0.182022] PCI: Using ACPI for IRQ routing
[    0.182022] PCI: pci_cache_line_size set to 64 bytes
[    0.182130] PM: Adding info for No Bus:lo
[    0.182130] Bluetooth: Core ver 2.15
[    0.182130] NET: Registered protocol family 31
[    0.182130] Bluetooth: HCI device and connection manager initialized
[    0.182130] Bluetooth: HCI socket layer initialized
[    0.182130] PM: Adding info for platform:regulatory.0
[    0.182130] cfg80211: Calling CRDA to update world regulatory domain
[    0.182130] PM: Adding info for No Bus:rfkill
[    0.182130] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.183004] Switching to clocksource tsc
[    0.183026] Slow work thread pool: Starting up
[    0.183048] Slow work thread pool: Ready
[    0.183055] FS-Cache: Loaded
[    0.183061] PM: Adding info for No Bus:cachefiles
[    0.183089] CacheFiles: Loaded
[    0.183094] pnp: PnP ACPI init
[    0.183100] PM: Adding info for No Bus:pnp0
[    0.183102] ACPI: bus type pnp registered
[    0.183283] PM: Adding info for pnp:00:00
[    0.183349] PM: Adding info for pnp:00:01
[    0.183446] PM: Adding info for pnp:00:02
[    0.183498] PM: Adding info for pnp:00:03
[    0.183588] PM: Adding info for pnp:00:04
[    0.183713] PM: Adding info for pnp:00:05
[    0.183764] PM: Adding info for pnp:00:06
[    0.183815] PM: Adding info for pnp:00:07
[    0.184116] PM: Adding info for pnp:00:08
[    0.184275] PM: Adding info for pnp:00:09
[    0.184397] PM: Adding info for pnp:00:0a
[    0.184534] PM: Adding info for pnp:00:0b
[    0.184725] PM: Adding info for pnp:00:0c
[    0.188747] PM: Adding info for pnp:00:0d
[    0.188898] PM: Adding info for pnp:00:0e
[    0.189437] PM: Adding info for pnp:00:0f
[    0.189745] pnp: PnP ACPI: found 16 devices
[    0.189746] ACPI: ACPI bus type pnp unregistered
[    0.189754] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.189761] system 00:08: [io  0x04c0-0x04cf] has been reserved
[    0.189763] system 00:08: [io  0x04d2-0x04ff] has been reserved
[    0.189765] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.189768] system 00:08: [io  0x0800-0x087f] has been reserved
[    0.189770] system 00:08: [io  0x0480-0x04bf] has been reserved
[    0.189772] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.189774] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.189777] system 00:08: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.189782] system 00:0b: [mem 0xffc00000-0xffefffff] has been reserved
[    0.189786] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.189788] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.189793] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    0.189797] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.189799] system 00:0f: [mem 0x000c0000-0x000cffff] has been reserved
[    0.189802] system 00:0f: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.189804] system 00:0f: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.189807] system 00:0f: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.189866] PM: Adding info for No Bus:mem
[    0.189898] PM: Adding info for No Bus:null
[    0.189927] PM: Adding info for No Bus:port
[    0.189957] PM: Adding info for No Bus:zero
[    0.189986] PM: Adding info for No Bus:full
[    0.190015] PM: Adding info for No Bus:random
[    0.190043] PM: Adding info for No Bus:urandom
[    0.190073] PM: Adding info for No Bus:kmsg
[    0.190101] PM: Adding info for No Bus:oldmem
[    0.194724] pci 0000:00:1c.0: BAR 9: assigned [mem
0xc0000000-0xc01fffff 64bit pref]
[    0.194727] pci 0000:00:1c.2: BAR 8: assigned [mem 0xc0200000-0xc03fffff]
[    0.194729] pci 0000:00:1c.2: BAR 9: assigned [mem
0xc0400000-0xc05fffff 64bit pref]
[    0.194732] pci 0000:00:1c.3: BAR 9: assigned [mem
0xc0600000-0xc07fffff 64bit pref]
[    0.194734] pci 0000:00:1c.5: BAR 9: assigned [mem
0xc0800000-0xc09fffff 64bit pref]
[    0.194736] pci 0000:00:1c.2: BAR 7: assigned [io  0x1000-0x1fff]
[    0.194739] pci 0000:00:1c.3: BAR 7: assigned [io  0x2000-0x2fff]
[    0.194741] pci 0000:00:1c.5: BAR 7: assigned [io  0x3000-0x3fff]
[    0.194744] pci 0000:08:00.0: BAR 6: assigned [mem
0xfc000000-0xfc07ffff pref]
[    0.194746] pci 0000:00:01.0: PCI bridge to [bus 08-08]
[    0.194748] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.194752] pci 0000:00:01.0:   bridge window [mem 0xfa000000-0xfebfffff]
[    0.194755] pci 0000:00:01.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.194759] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.194761] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.194765] pci 0000:00:1c.0:   bridge window [mem 0xf8f00000-0xf8ffffff]
[    0.194769] pci 0000:00:1c.0:   bridge window [mem
0xc0000000-0xc01fffff 64bit pref]
[    0.194775] pci 0000:00:1c.1: PCI bridge to [bus 03-04]
[    0.194777] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.194781] pci 0000:00:1c.1:   bridge window [mem 0xf9000000-0xf9dfffff]
[    0.194785] pci 0000:00:1c.1:   bridge window [mem
0xce000000-0xcfffffff 64bit pref]
[    0.194790] pci 0000:00:1c.2: PCI bridge to [bus 05-05]
[    0.194792] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.194797] pci 0000:00:1c.2:   bridge window [mem 0xc0200000-0xc03fffff]
[    0.194800] pci 0000:00:1c.2:   bridge window [mem
0xc0400000-0xc05fffff 64bit pref]
[    0.194806] pci 0000:00:1c.3: PCI bridge to [bus 06-06]
[    0.194808] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.194812] pci 0000:00:1c.3:   bridge window [mem 0xf9e00000-0xf9efffff]
[    0.194816] pci 0000:00:1c.3:   bridge window [mem
0xc0600000-0xc07fffff 64bit pref]
[    0.194821] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    0.194824] pci 0000:00:1c.5:   bridge window [io  0x3000-0x3fff]
[    0.194828] pci 0000:00:1c.5:   bridge window [mem 0xf9f00000-0xf9ffffff]
[    0.194832] pci 0000:00:1c.5:   bridge window [mem
0xc0800000-0xc09fffff 64bit pref]
[    0.194837] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.194838] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.194842] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.194845] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.194857] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.194860] pci 0000:00:01.0: setting latency timer to 64
[    0.194868] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.194871] pci 0000:00:1c.0: setting latency timer to 64
[    0.194882] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.194885] pci 0000:00:1c.1: setting latency timer to 64
[    0.194892] pci 0000:00:1c.2: enabling device (0104 -> 0107)
[    0.194896] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.194899] pci 0000:00:1c.2: setting latency timer to 64
[    0.194905] pci 0000:00:1c.3: enabling device (0106 -> 0107)
[    0.194909] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.194912] pci 0000:00:1c.3: setting latency timer to 64
[    0.194918] pci 0000:00:1c.5: enabling device (0106 -> 0107)
[    0.194921] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.194924] pci 0000:00:1c.5: setting latency timer to 64
[    0.194930] pci 0000:00:1e.0: setting latency timer to 64
[    0.194933] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.194935] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.194937] pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
[    0.194938] pci_bus 0000:08: resource 1 [mem 0xfa000000-0xfebfffff]
[    0.194941] pci_bus 0000:08: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.194943] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.194944] pci_bus 0000:02: resource 1 [mem 0xf8f00000-0xf8ffffff]
[    0.194946] pci_bus 0000:02: resource 2 [mem 0xc0000000-0xc01fffff
64bit pref]
[    0.194948] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.194950] pci_bus 0000:03: resource 1 [mem 0xf9000000-0xf9dfffff]
[    0.194952] pci_bus 0000:03: resource 2 [mem 0xce000000-0xcfffffff
64bit pref]
[    0.194954] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    0.194956] pci_bus 0000:05: resource 1 [mem 0xc0200000-0xc03fffff]
[    0.194958] pci_bus 0000:05: resource 2 [mem 0xc0400000-0xc05fffff
64bit pref]
[    0.194960] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
[    0.194961] pci_bus 0000:06: resource 1 [mem 0xf9e00000-0xf9efffff]
[    0.194963] pci_bus 0000:06: resource 2 [mem 0xc0600000-0xc07fffff
64bit pref]
[    0.194965] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
[    0.194967] pci_bus 0000:07: resource 1 [mem 0xf9f00000-0xf9ffffff]
[    0.194969] pci_bus 0000:07: resource 2 [mem 0xc0800000-0xc09fffff
64bit pref]
[    0.194971] pci_bus 0000:01: resource 3 [io  0x0000-0xffff]
[    0.194973] pci_bus 0000:01: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.194983] NET: Registered protocol family 2
[    0.195078] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.195917] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.199867] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.200393] TCP: Hash tables configured (established 524288 bind 65536)
[    0.200395] TCP reno registered
[    0.200404] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.200445] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.200554] NET: Registered protocol family 1
[    0.200668] RPC: Registered udp transport module.
[    0.200670] RPC: Registered tcp transport module.
[    0.200671] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.200692] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.200693] pci 0000:00:1a.0: Performing full reset
[    0.200709] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.200711] pci 0000:00:1a.1: Performing full reset
[    0.200726] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.200728] pci 0000:00:1a.2: Performing full reset
[    0.200781] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.200783] pci 0000:00:1d.0: Performing full reset
[    0.200798] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.200799] pci 0000:00:1d.1: Performing full reset
[    0.200815] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.200816] pci 0000:00:1d.2: Performing full reset
[    0.200870] pci 0000:08:00.0: Boot video device
[    0.200933] PCI: CLS 32 bytes, default 64
[    0.200961] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.200964] Placing 64MB software IO TLB between ffff880020000000 -
ffff880024000000
[    0.200966] software IO TLB at phys 0x20000000 - 0x24000000
[    0.201363] PM: Adding info for No Bus:msr0
[    0.201394] PM: Adding info for No Bus:msr1
[    0.201452] PM: Adding info for No Bus:cpu0
[    0.201487] PM: Adding info for No Bus:cpu1
[    0.201572] PM: Adding info for platform:microcode
[    0.201604] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
[    0.201609] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
[    0.201619] PM: Adding info for No Bus:microcode
[    0.201646] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.201793] PM: Adding info for No Bus:snapshot
[    0.201843] audit: initializing netlink socket (disabled)
[    0.201851] type=2000 audit(1261828941.200:1): initialized
[    0.205138] PM: Adding info for No Bus:autofs
[    0.205162] fuse init (API version 7.13)
[    0.205250] PM: Adding info for No Bus:fuse
[    0.205317] msgmni has been set to 7924
[    0.205601] alg: No test for stdrng (krng)
[    0.205672] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.205675] io scheduler noop registered
[    0.205676] io scheduler deadline registered
[    0.205759] io scheduler cfq registered (default)
[    0.205851] pcieport 0000:00:01.0: setting latency timer to 64
[    0.205877] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.205886] PM: Adding info for pci_express:0000:00:01.0:pcie01
[    0.205936] PM: Adding info for pci_express:0000:00:01.0:pcie04
[    0.205967] PM: Adding info for pci_express:0000:00:01.0:pcie08
[    0.206015] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.206047] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.206056] PM: Adding info for pci_express:0000:00:1c.0:pcie01
[    0.206083] PM: Adding info for pci_express:0000:00:1c.0:pcie04
[    0.206110] PM: Adding info for pci_express:0000:00:1c.0:pcie08
[    0.206168] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.206201] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
[    0.206210] PM: Adding info for pci_express:0000:00:1c.1:pcie01
[    0.206242] PM: Adding info for pci_express:0000:00:1c.1:pcie04
[    0.206269] PM: Adding info for pci_express:0000:00:1c.1:pcie08
[    0.206326] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.206357] pcieport 0000:00:1c.2: irq 27 for MSI/MSI-X
[    0.206367] PM: Adding info for pci_express:0000:00:1c.2:pcie01
[    0.206394] PM: Adding info for pci_express:0000:00:1c.2:pcie04
[    0.206420] PM: Adding info for pci_express:0000:00:1c.2:pcie08
[    0.206477] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.206509] pcieport 0000:00:1c.3: irq 28 for MSI/MSI-X
[    0.206521] PM: Adding info for pci_express:0000:00:1c.3:pcie01
[    0.206549] PM: Adding info for pci_express:0000:00:1c.3:pcie04
[    0.206576] PM: Adding info for pci_express:0000:00:1c.3:pcie08
[    0.206633] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.206665] pcieport 0000:00:1c.5: irq 29 for MSI/MSI-X
[    0.206678] PM: Adding info for pci_express:0000:00:1c.5:pcie01
[    0.206706] PM: Adding info for pci_express:0000:00:1c.5:pcie04
[    0.206733] PM: Adding info for pci_express:0000:00:1c.5:pcie08
[    0.206861] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.207154] pciehp: Using ACPI for slot detection.
[    0.207229] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086
device_id 294a ss_vid 1462 ss_did 6510
[    0.207276] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
[    0.207298] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.207310] PM: Adding info for No Bus:fbcon
[    0.211296] PM: Adding info for No Bus:ADP1
[    0.211324] ACPI: AC Adapter [ADP1] (on-line)
[    0.211420] PM: Adding info for No Bus:input0
[    0.211451] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:06/PNP0C09:00/PNP0C0D:00/input/input0
[    0.215357] ACPI: Lid Switch [LID0]
[    0.215385] PM: Adding info for No Bus:input1
[    0.215417] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.215419] ACPI: Power Button [PWRB]
[    0.215444] PM: Adding info for No Bus:input2
[    0.215472] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.215475] ACPI: Power Button [PWRF]
[    0.224928] PM: Adding info for No Bus:acpi_video0
[    0.224968] PM: Adding info for No Bus:cooling_device0
[    0.224991] acpi device:02: registered as cooling_device0
[    0.225000] PM: Adding info for No Bus:acpi_video0
[    0.225093] PM: Adding info for No Bus:input3
[    0.225125] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input3
[    0.225128] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    0.225548] Monitor-Mwait will be used to enter C-1 state
[    0.225563] Monitor-Mwait will be used to enter C-2 state
[    0.225578] Monitor-Mwait will be used to enter C-3 state
[    0.225582] Marking TSC unstable due to TSC halts in idle
[    0.225632] Switching to clocksource hpet
[    0.225638] PM: Adding info for No Bus:cooling_device1
[    0.226165] PM: Adding info for No Bus:cooling_device2
[    0.233011] PM: Adding info for No Bus:tty
[    0.236924] PM: Adding info for No Bus:console
[    0.236961] PM: Adding info for No Bus:tty0
[    0.237023] PM: Adding info for No Bus:vcs
[    0.237054] PM: Adding info for No Bus:vcsa
[    0.237084] PM: Adding info for No Bus:vcs1
[    0.237114] PM: Adding info for No Bus:vcsa1
[    0.237148] PM: Adding info for No Bus:tty1
[    0.237180] PM: Adding info for No Bus:tty2
[    0.237213] PM: Adding info for No Bus:tty3
[    0.237243] PM: Adding info for No Bus:tty4
[    0.237281] PM: Adding info for No Bus:tty5
[    0.237311] PM: Adding info for No Bus:tty6
[    0.237341] PM: Adding info for No Bus:tty7
[    0.237371] PM: Adding info for No Bus:tty8
[    0.237402] PM: Adding info for No Bus:tty9
[    0.237435] PM: Adding info for No Bus:tty10
[    0.237466] PM: Adding info for No Bus:tty11
[    0.237497] PM: Adding info for No Bus:tty12
[    0.237531] PM: Adding info for No Bus:tty13
[    0.237562] PM: Adding info for No Bus:tty14
[    0.237593] PM: Adding info for No Bus:tty15
[    0.237627] PM: Adding info for No Bus:tty16
[    0.237683] PM: Adding info for No Bus:tty17
[    0.237737] PM: Adding info for No Bus:tty18
[    0.237790] PM: Adding info for No Bus:tty19
[    0.237821] PM: Adding info for No Bus:tty20
[    0.237852] PM: Adding info for No Bus:tty21
[    0.237885] PM: Adding info for No Bus:tty22
[    0.237918] PM: Adding info for No Bus:tty23
[    0.237950] PM: Adding info for No Bus:tty24
[    0.237981] PM: Adding info for No Bus:tty25
[    0.238012] PM: Adding info for No Bus:tty26
[    0.238043] PM: Adding info for No Bus:tty27
[    0.238074] PM: Adding info for No Bus:tty28
[    0.238110] PM: Adding info for No Bus:tty29
[    0.238145] PM: Adding info for No Bus:tty30
[    0.238176] PM: Adding info for No Bus:tty31
[    0.238209] PM: Adding info for No Bus:tty32
[    0.238240] PM: Adding info for No Bus:tty33
[    0.238285] PM: Adding info for No Bus:tty34
[    0.238320] PM: Adding info for No Bus:tty35
[    0.238352] PM: Adding info for No Bus:tty36
[    0.238384] PM: Adding info for No Bus:tty37
[    0.238416] PM: Adding info for No Bus:tty38
[    0.238448] PM: Adding info for No Bus:tty39
[    0.238480] PM: Adding info for No Bus:tty40
[    0.238515] PM: Adding info for No Bus:tty41
[    0.238547] PM: Adding info for No Bus:tty42
[    0.238579] PM: Adding info for No Bus:tty43
[    0.238613] PM: Adding info for No Bus:tty44
[    0.238646] PM: Adding info for No Bus:tty45
[    0.238678] PM: Adding info for No Bus:tty46
[    0.238711] PM: Adding info for No Bus:tty47
[    0.238771] PM: Adding info for No Bus:tty48
[    0.238829] PM: Adding info for No Bus:tty49
[    0.238884] PM: Adding info for No Bus:tty50
[    0.238917] PM: Adding info for No Bus:tty51
[    0.238950] PM: Adding info for No Bus:tty52
[    0.238985] PM: Adding info for No Bus:tty53
[    0.239021] PM: Adding info for No Bus:tty54
[    0.239055] PM: Adding info for No Bus:tty55
[    0.239089] PM: Adding info for No Bus:tty56
[    0.239122] PM: Adding info for No Bus:tty57
[    0.239155] PM: Adding info for No Bus:tty58
[    0.239188] PM: Adding info for No Bus:tty59
[    0.239221] PM: Adding info for No Bus:tty60
[    0.239264] PM: Adding info for No Bus:tty61
[    0.239300] PM: Adding info for No Bus:tty62
[    0.239334] PM: Adding info for No Bus:tty63
[    0.239409] PM: Adding info for No Bus:ptmx
[    0.239453] PM: Adding info for No Bus:nvram
[    0.239483] Non-volatile memory driver v1.3
[    0.239561] Linux agpgart interface v0.103
[    0.239598] [drm] Initialized drm 1.1.0 20060810
[    0.239606] PM: Adding info for No Bus:ttm
[    0.239659] nouveau 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.239663] nouveau 0000:08:00.0: setting latency timer to 64
[    0.241791] PM: Adding info for No Bus:controlD64
[    0.241926] PM: Adding info for No Bus:card0
[    0.242146] [drm] nouveau 0000:08:00.0: failed to evaluate _DSM: 5
[    0.242416] [drm] nouveau 0000:08:00.0: Detected an NV50 generation
card (0x096480a1)
[    0.243245] [drm] nouveau 0000:08:00.0: Attempting to load BIOS
image from PRAMIN
[    0.260635] PM: Adding info for No Bus:BAT1
[    0.331653] [drm] nouveau 0000:08:00.0: ... appears to be valid
[    0.331656] [drm] nouveau 0000:08:00.0: BIT BIOS found
[    0.331659] [drm] nouveau 0000:08:00.0: Bios version 62.94.3c.00
[    0.331662] [drm] nouveau 0000:08:00.0: TMDS table revision 2.0 not
currently supported
[    0.331664] [drm] nouveau 0000:08:00.0: Found Display Configuration
Block version 4.0
[    0.331668] [drm] nouveau 0000:08:00.0: DCB connector table: VHER 0x40 5 16 4
[    0.331670] [drm] nouveau 0000:08:00.0:   0: 0x00000040: type 0x40
idx 0 tag 0xff
[    0.331672] [drm] nouveau 0000:08:00.0:   1: 0x00001131: type 0x31
idx 1 tag 0x07
[    0.331674] [drm] nouveau 0000:08:00.0:   2: 0x00002231: type 0x31
idx 2 tag 0x08
[    0.331677] [drm] nouveau 0000:08:00.0:   3: 0x00110346: type 0x46
idx 3 tag 0x51
[    0.331679] [drm] nouveau 0000:08:00.0:   4: 0x00000400: type 0x00
idx 4 tag 0xff
[    0.331681] [drm] nouveau 0000:08:00.0:   5: 0x00000510: type 0x10
idx 5 tag 0xff
[    0.331683] [drm] nouveau 0000:08:00.0:   6: 0x00000511: type 0x11
idx 5 tag 0xff
[    0.331685] [drm] nouveau 0000:08:00.0:   7: 0x00000513: type 0x13
idx 5 tag 0xff
[    0.331688] [drm] nouveau 0000:08:00.0:   8: 0x00002631: type 0x31
idx 6 tag 0x08
[    0.331690] [drm] nouveau 0000:08:00.0:   9: 0x00001731: type 0x31
idx 7 tag 0x07
[    0.331692] [drm] nouveau 0000:08:00.0:   10: 0x00002831: type 0x31
idx 8 tag 0x08
[    0.331694] [drm] nouveau 0000:08:00.0:   11: 0x00110946: type 0x46
idx 9 tag 0x51
[    0.331697] [drm] nouveau 0000:08:00.0:   12: 0x00000a00: type 0x00
idx 10 tag 0xff
[    0.331699] [drm] nouveau 0000:08:00.0:   13: 0x00000b10: type 0x10
idx 11 tag 0xff
[    0.331701] [drm] nouveau 0000:08:00.0:   14: 0x00000b11: type 0x11
idx 11 tag 0xff
[    0.331703] [drm] nouveau 0000:08:00.0:   15: 0x00000b13: type 0x13
idx 11 tag 0xff
[    0.331705] [drm] nouveau 0000:08:00.0: Raw DCB entry 0: 01000323 00010034
[    0.331708] [drm] nouveau 0000:08:00.0: Raw DCB entry 1: 04011312 00020010
[    0.331710] [drm] nouveau 0000:08:00.0: Raw DCB entry 2: 02044300 00000028
[    0.331718] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 0
at offset 0xD51F
[    0.360121] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 1
at offset 0xD910
[    0.365009] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 2
at offset 0xE8D9
[    0.365017] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 3
at offset 0xEA22
[    0.367091] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 4
at offset 0xEC8A
[    0.367093] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table at
offset 0xECEF
[    0.388013] [drm] nouveau 0000:08:00.0: 0xECEF: Condition still not
met after 20ms, skipping following opcodes
[    0.388020] [drm] nouveau 0000:08:00.0: 0xB9B8: parsing output script 0
[    0.388022] [drm] nouveau 0000:08:00.0: 0xBD90: parsing output script 0
[    0.397066] ACPI: Battery Slot [BAT1] (battery present)
[    0.519486] [TTM] Zone  kernel: Available graphics memory: 2028550 kiB.
[    0.519499] [drm] nouveau 0000:08:00.0: 512 MiB VRAM
[    0.544437] [drm] nouveau 0000:08:00.0: 512 MiB GART (aperture)
[    0.544444] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[    0.544649] [drm] nouveau 0000:08:00.0: Allocating FIFO number 1
[    0.550311] [drm] nouveau 0000:08:00.0: nouveau_channel_alloc:
initialised FIFO 1
[    0.550940] [drm] nouveau 0000:08:00.0: Detected a LVDS output
[    0.550944] [drm] nouveau 0000:08:00.0: Detected a TMDS output
[    0.550946] [drm] nouveau 0000:08:00.0: Detected a DAC output
[    0.550949] [drm] nouveau 0000:08:00.0: Detected a LVDS connector
[    0.550959] PM: Adding info for No Bus:card0-LVDS-1
[    0.551042] PM: Adding info for i2c:i2c-0
[    0.649111] [drm] nouveau 0000:08:00.0: Detected a DVI-D connector
[    0.649120] PM: Adding info for No Bus:card0-DVI-D-1
[    0.649179] [drm] nouveau 0000:08:00.0: Detected a VGA connector
[    0.649187] PM: Adding info for No Bus:card0-VGA-1
[    1.700846] PM: Adding info for i2c:i2c-1
[    1.704656] PM: Adding info for i2c:i2c-2
[    1.753753] [drm] nouveau 0000:08:00.0: allocated 1680x1050 fb:
0x40210000, bo ffff88013eba3800
[    1.753771] PM: Adding info for No Bus:fb0
[    1.753822] PM: Adding info for No Bus:vtcon1
[    1.755060] [drm] LVDS-7: set mode 1680x1050 1d
[    1.755696] [drm] nouveau 0000:08:00.0: 0xB9BC: parsing output script 1
[    1.760471] Console: switching to colour frame buffer device 210x65
[    1.760496] [drm] nouveau 0000:08:00.0: 0xB873: parsing clock script 0
[    1.763674] fb0: nouveaufb frame buffer device
[    1.763675] registered panic notifier
[    1.763679] [drm] Initialized nouveau 0.0.15 20090420 for
0000:08:00.0 on minor 0
[    1.763724] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.763743] PM: Adding info for platform:serial8250
[    1.763798] PM: Adding info for No Bus:ttyS0
[    1.763841] PM: Adding info for No Bus:ttyS1
[    1.763882] PM: Adding info for No Bus:ttyS2
[    1.763922] PM: Adding info for No Bus:ttyS3
[    1.764359] PM: Adding info for No Bus:ram0
[    1.764405] PM: Adding info for No Bus:1:0
[    1.764447] PM: Adding info for No Bus:ram1
[    1.764489] PM: Adding info for No Bus:1:1
[    1.764532] PM: Adding info for No Bus:ram2
[    1.764574] PM: Adding info for No Bus:1:2
[    1.764616] PM: Adding info for No Bus:ram3
[    1.764660] PM: Adding info for No Bus:1:3
[    1.764699] PM: Adding info for No Bus:ram4
[    1.764741] PM: Adding info for No Bus:1:4
[    1.764781] PM: Adding info for No Bus:ram5
[    1.764823] PM: Adding info for No Bus:1:5
[    1.764863] PM: Adding info for No Bus:ram6
[    1.764904] PM: Adding info for No Bus:1:6
[    1.764944] PM: Adding info for No Bus:ram7
[    1.764986] PM: Adding info for No Bus:1:7
[    1.765026] PM: Adding info for No Bus:ram8
[    1.765070] PM: Adding info for No Bus:1:8
[    1.765114] PM: Adding info for No Bus:ram9
[    1.765155] PM: Adding info for No Bus:1:9
[    1.765194] PM: Adding info for No Bus:ram10
[    1.765239] PM: Adding info for No Bus:1:10
[    1.765285] PM: Adding info for No Bus:ram11
[    1.765331] PM: Adding info for No Bus:1:11
[    1.765371] PM: Adding info for No Bus:ram12
[    1.765417] PM: Adding info for No Bus:1:12
[    1.765456] PM: Adding info for No Bus:ram13
[    1.765501] PM: Adding info for No Bus:1:13
[    1.765539] PM: Adding info for No Bus:ram14
[    1.765589] PM: Adding info for No Bus:1:14
[    1.765627] PM: Adding info for No Bus:ram15
[    1.765672] PM: Adding info for No Bus:1:15
[    1.765705] brd: module loaded
[    1.765762] PM: Adding info for No Bus:loop0
[    1.765809] PM: Adding info for No Bus:7:0
[    1.765848] PM: Adding info for No Bus:loop1
[    1.765894] PM: Adding info for No Bus:7:1
[    1.765932] PM: Adding info for No Bus:loop2
[    1.765977] PM: Adding info for No Bus:7:2
[    1.766016] PM: Adding info for No Bus:loop3
[    1.766063] PM: Adding info for No Bus:7:3
[    1.766104] PM: Adding info for No Bus:loop4
[    1.766150] PM: Adding info for No Bus:7:4
[    1.766188] PM: Adding info for No Bus:loop5
[    1.766233] PM: Adding info for No Bus:7:5
[    1.766291] PM: Adding info for No Bus:loop6
[    1.766338] PM: Adding info for No Bus:7:6
[    1.766381] PM: Adding info for No Bus:loop7
[    1.766426] PM: Adding info for No Bus:7:7
[    1.766455] loop: module loaded
[    1.766511] Loading iSCSI transport class v2.0-870.
[    1.766819] ahci 0000:00:1f.2: version 3.0
[    1.766832] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.766865] ahci 0000:00:1f.2: irq 30 for MSI/MSI-X
[    1.766907] ahci: SSS flag set, parallel bus scan disabled
[    1.766934] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3
Gbps 0x33 impl SATA mode
[    1.766937] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag led clo
pio slum part ccc ems sxs
[    1.766941] ahci 0000:00:1f.2: setting latency timer to 64
[    1.772297] scsi0 : ahci
[    1.772315] PM: Adding info for scsi:host0
[    1.772360] PM: Adding info for No Bus:host0
[    1.772408] scsi1 : ahci
[    1.772413] PM: Adding info for scsi:host1
[    1.772450] PM: Adding info for No Bus:host1
[    1.772496] scsi2 : ahci
[    1.772506] PM: Adding info for scsi:host2
[    1.772545] PM: Adding info for No Bus:host2
[    1.772591] scsi3 : ahci
[    1.772596] PM: Adding info for scsi:host3
[    1.772635] PM: Adding info for No Bus:host3
[    1.772680] scsi4 : ahci
[    1.772686] PM: Adding info for scsi:host4
[    1.772723] PM: Adding info for No Bus:host4
[    1.772768] scsi5 : ahci
[    1.772774] PM: Adding info for scsi:host5
[    1.772813] PM: Adding info for No Bus:host5
[    1.772950] ata1: SATA max UDMA/133 abar m2048@0xf8eff800 port
0xf8eff900 irq 30
[    1.772952] ata2: SATA max UDMA/133 abar m2048@0xf8eff800 port
0xf8eff980 irq 30
[    1.772954] ata3: DUMMY
[    1.772955] ata4: DUMMY
[    1.772957] ata5: SATA max UDMA/133 abar m2048@0xf8eff800 port
0xf8effb00 irq 30
[    1.772959] ata6: SATA max UDMA/133 abar m2048@0xf8eff800 port
0xf8effb80 irq 30
[    1.773051] PPP generic driver version 2.4.2
[    1.773100] PM: Adding info for No Bus:ppp
[    1.773138] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.773155] r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.773162] r8169 0000:02:00.0: region #1 not an MMIO resource, aborting
[    1.773180] r8169 0000:02:00.0: PCI INT A disabled
[    1.773242] usbcore: registered new interface driver cdc_ether
[    1.773281] usbcore: registered new interface driver cdc_subset
[    1.773286] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
Linux, 2.6.33-rc2-kd
[    1.773288] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    1.773331] iwlagn 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.773337] iwlagn 0000:06:00.0: setting latency timer to 64
[    1.773355] iwlagn 0000:06:00.0: Detected Intel Wireless WiFi Link
5100AGN REV=0x54
[    2.078018] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.078447] ata1.00: ATA-8: FUJITSU MHZ2320BH G2, 00000009, max UDMA/100
[    2.078449] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.078954] ata1.00: configured for UDMA/100
[    2.079047] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU
MHZ2320B 0000 PQ: 0 ANSI: 5
[    2.079056] PM: Adding info for scsi:target0:0:0
[    2.079094] PM: Adding info for scsi:0:0:0:0
[    2.079139] PM: Adding info for No Bus:0:0:0:0
[    2.079173] PM: Adding info for No Bus:0:0:0:0
[    2.079222] PM: Adding info for No Bus:sg0
[    2.079268] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks:
(320 GB/298 GiB)
[    2.079310] sd 0:0:0:0: [sda] Write Protect is off
[    2.079312] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.079331] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.079351] PM: Adding info for No Bus:sda
[    4.423719] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.423736] PM: Adding info for No Bus:0:0:0:0
[    4.423740] iwlagn 0000:06:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[    4.423811] iwlagn 0000:06:00.0: irq 31 for MSI/MSI-X
[    4.423888] PM: Adding info for No Bus:phy0
[    4.423924] PM: Adding info for No Bus:rfkill0
[    4.424015]  sda:
[    4.424194] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    4.424231] PM: Adding info for No Bus:wlan0
[    4.424433] PM: Adding info for No Bus:usbmon0
[    4.424460] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.424462] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.424480] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.424491] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.424494] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.424511] PM: Adding info for No Bus:usbmon1
[    4.424538] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    4.424545] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1
cc=3 pcc=2 ordered !ppc ports=6
[    4.424548] ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7
uframes 1024 64 bit addr
[    4.424569] ehci_hcd 0000:00:1a.7: debug port 1
[    4.424573] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0
ithresh=8 period=1024 Reset HALT
[    4.428442] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    4.428444] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.428455] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8efec00
[    4.428458] ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0
ithresh=8 period=1024 Reset HALT
[    4.432345] ehci_hcd 0000:00:1a.7: init command 010001 (park)=0
ithresh=1 period=1024 RUN
[    4.438259] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.438284] usb usb1: default language 0x0409
[    4.438290] usb usb1: udev 1, busnum 1, minor = 0
[    4.438291] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.438293] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.438295] usb usb1: Product: EHCI Host Controller
[    4.438297] usb usb1: Manufacturer: Linux 2.6.33-rc2 ehci_hcd
[    4.438298] usb usb1: SerialNumber: 0000:00:1a.7
[    4.438321] PM: Adding info for usb:usb1
[    4.438329] usb usb1: uevent
[    4.438359] usb usb1: usb_probe_device
[    4.438361] usb usb1: configuration #1 chosen from 1 choice
[    4.438368] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.438376] PM: Adding info for usb:1-0:1.0
[    4.438379] usb 1-0:1.0: uevent
[    4.438407] hub 1-0:1.0: usb_probe_interface
[    4.438408] hub 1-0:1.0: usb_probe_interface - got id
[    4.438410] hub 1-0:1.0: USB hub found
[    4.438414] hub 1-0:1.0: 6 ports detected
[    4.438415] hub 1-0:1.0: standalone hub
[    4.438417] hub 1-0:1.0: no power switching (usb 1.0)
[    4.438418] hub 1-0:1.0: individual port over-current protection
[    4.438420] hub 1-0:1.0: power on to power good time: 20ms
[    4.438423] hub 1-0:1.0: local power source is good
[    4.438425] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.438450] PM: Adding info for No Bus:ep_81
[    4.438459] PM: Adding info for No Bus:ep_00
[    4.438474] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.438484] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.438486] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.438502] PM: Adding info for No Bus:usbmon2
[    4.438529] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    4.438535] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1
cc=3 pcc=2 ordered !ppc ports=6
[    4.438538] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7
uframes 1024 64 bit addr
[    4.438558] ehci_hcd 0000:00:1d.7: debug port 1
[    4.438562] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0
ithresh=8 period=1024 Reset HALT
[    4.442449] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.442451] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.442461] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8eff000
[    4.442465] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0
ithresh=8 period=1024 Reset HALT
[    4.446353] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0
ithresh=1 period=1024 RUN
[    4.448129]  sda1 sda2 sda3 sda4
[    4.448148] PM: Adding info for No Bus:sda1
[    4.448163] PM: Adding info for No Bus:sda2
[    4.448175] PM: Adding info for No Bus:sda3
[    4.448187] PM: Adding info for No Bus:sda4
[    4.448362] PM: Adding info for No Bus:8:0
[    4.448473] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.452259] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.452280] usb usb2: default language 0x0409
[    4.452285] usb usb2: udev 1, busnum 2, minor = 128
[    4.452287] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.452289] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.452291] usb usb2: Product: EHCI Host Controller
[    4.452292] usb usb2: Manufacturer: Linux 2.6.33-rc2 ehci_hcd
[    4.452294] usb usb2: SerialNumber: 0000:00:1d.7
[    4.452316] PM: Adding info for usb:usb2
[    4.452324] usb usb2: uevent
[    4.452353] usb usb2: usb_probe_device
[    4.452355] usb usb2: configuration #1 chosen from 1 choice
[    4.452360] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.452368] PM: Adding info for usb:2-0:1.0
[    4.452372] usb 2-0:1.0: uevent
[    4.452398] hub 2-0:1.0: usb_probe_interface
[    4.452400] hub 2-0:1.0: usb_probe_interface - got id
[    4.452402] hub 2-0:1.0: USB hub found
[    4.452405] hub 2-0:1.0: 6 ports detected
[    4.452406] hub 2-0:1.0: standalone hub
[    4.452407] hub 2-0:1.0: no power switching (usb 1.0)
[    4.452408] hub 2-0:1.0: individual port over-current protection
[    4.452410] hub 2-0:1.0: power on to power good time: 20ms
[    4.452413] hub 2-0:1.0: local power source is good
[    4.452415] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.452440] PM: Adding info for No Bus:ep_81
[    4.452449] PM: Adding info for No Bus:ep_00
[    4.452480] uhci_hcd: USB Universal Host Controller Interface driver
[    4.452548] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.452554] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.452557] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.452573] PM: Adding info for No Bus:usbmon3
[    4.452598] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    4.452604] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.452608] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.452609] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.452622] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[    4.452626] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
[    4.452652] usb usb3: default language 0x0409
[    4.452657] usb usb3: udev 1, busnum 3, minor = 256
[    4.452659] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.452661] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.452662] usb usb3: Product: UHCI Host Controller
[    4.452664] usb usb3: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
[    4.452665] usb usb3: SerialNumber: 0000:00:1a.0
[    4.452685] PM: Adding info for usb:usb3
[    4.452695] usb usb3: uevent
[    4.452721] usb usb3: usb_probe_device
[    4.452723] usb usb3: configuration #1 chosen from 1 choice
[    4.452728] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.452736] PM: Adding info for usb:3-0:1.0
[    4.452740] usb 3-0:1.0: uevent
[    4.452766] hub 3-0:1.0: usb_probe_interface
[    4.452767] hub 3-0:1.0: usb_probe_interface - got id
[    4.452769] hub 3-0:1.0: USB hub found
[    4.452772] hub 3-0:1.0: 2 ports detected
[    4.452774] hub 3-0:1.0: standalone hub
[    4.452775] hub 3-0:1.0: no power switching (usb 1.0)
[    4.452776] hub 3-0:1.0: individual port over-current protection
[    4.452778] hub 3-0:1.0: power on to power good time: 2ms
[    4.452781] hub 3-0:1.0: local power source is good
[    4.452783] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.452793] PM: Adding info for No Bus:ep_81
[    4.452805] PM: Adding info for No Bus:ep_00
[    4.452823] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.452827] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.452830] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.452853] PM: Adding info for No Bus:usbmon4
[    4.452879] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    4.452885] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.452889] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.452890] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.452903] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[    4.452914] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a480
[    4.452940] usb usb4: default language 0x0409
[    4.452945] usb usb4: udev 1, busnum 4, minor = 384
[    4.452947] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.452949] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.452951] usb usb4: Product: UHCI Host Controller
[    4.452952] usb usb4: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
[    4.452954] usb usb4: SerialNumber: 0000:00:1a.1
[    4.452973] PM: Adding info for usb:usb4
[    4.452980] usb usb4: uevent
[    4.453007] usb usb4: usb_probe_device
[    4.453009] usb usb4: configuration #1 chosen from 1 choice
[    4.453013] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.453024] PM: Adding info for usb:4-0:1.0
[    4.453027] usb 4-0:1.0: uevent
[    4.453054] hub 4-0:1.0: usb_probe_interface
[    4.453055] hub 4-0:1.0: usb_probe_interface - got id
[    4.453057] hub 4-0:1.0: USB hub found
[    4.453060] hub 4-0:1.0: 2 ports detected
[    4.453061] hub 4-0:1.0: standalone hub
[    4.453062] hub 4-0:1.0: no power switching (usb 1.0)
[    4.453064] hub 4-0:1.0: individual port over-current protection
[    4.453065] hub 4-0:1.0: power on to power good time: 2ms
[    4.453068] hub 4-0:1.0: local power source is good
[    4.453070] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.453080] PM: Adding info for No Bus:ep_81
[    4.453089] PM: Adding info for No Bus:ep_00
[    4.453104] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.453108] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.453111] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.453129] PM: Adding info for No Bus:usbmon5
[    4.453155] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[    4.453160] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.453164] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.453165] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.453178] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[    4.453187] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000a400
[    4.453212] usb usb5: default language 0x0409
[    4.453217] usb usb5: udev 1, busnum 5, minor = 512
[    4.453219] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.453221] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.453222] usb usb5: Product: UHCI Host Controller
[    4.453224] usb usb5: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
[    4.453225] usb usb5: SerialNumber: 0000:00:1a.2
[    4.453245] PM: Adding info for usb:usb5
[    4.453258] usb usb5: uevent
[    4.453284] usb usb5: usb_probe_device
[    4.453286] usb usb5: configuration #1 chosen from 1 choice
[    4.453291] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.453303] PM: Adding info for usb:5-0:1.0
[    4.453306] usb 5-0:1.0: uevent
[    4.453333] hub 5-0:1.0: usb_probe_interface
[    4.453335] hub 5-0:1.0: usb_probe_interface - got id
[    4.453336] hub 5-0:1.0: USB hub found
[    4.453339] hub 5-0:1.0: 2 ports detected
[    4.453340] hub 5-0:1.0: standalone hub
[    4.453342] hub 5-0:1.0: no power switching (usb 1.0)
[    4.453343] hub 5-0:1.0: individual port over-current protection
[    4.453344] hub 5-0:1.0: power on to power good time: 2ms
[    4.453348] hub 5-0:1.0: local power source is good
[    4.453349] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.453359] PM: Adding info for No Bus:ep_81
[    4.453367] PM: Adding info for No Bus:ep_00
[    4.453383] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    4.453388] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.453391] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.453407] PM: Adding info for No Bus:usbmon6
[    4.453433] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[    4.453439] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.453442] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.453444] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.453456] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.453460] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b000
[    4.453487] usb usb6: default language 0x0409
[    4.453492] usb usb6: udev 1, busnum 6, minor = 640
[    4.453494] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.453496] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.453497] usb usb6: Product: UHCI Host Controller
[    4.453499] usb usb6: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
[    4.453501] usb usb6: SerialNumber: 0000:00:1d.0
[    4.453522] PM: Adding info for usb:usb6
[    4.453531] usb usb6: uevent
[    4.453557] usb usb6: usb_probe_device
[    4.453559] usb usb6: configuration #1 chosen from 1 choice
[    4.453564] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.453572] PM: Adding info for usb:6-0:1.0
[    4.453576] usb 6-0:1.0: uevent
[    4.453604] hub 6-0:1.0: usb_probe_interface
[    4.453606] hub 6-0:1.0: usb_probe_interface - got id
[    4.453608] hub 6-0:1.0: USB hub found
[    4.453611] hub 6-0:1.0: 2 ports detected
[    4.453612] hub 6-0:1.0: standalone hub
[    4.453613] hub 6-0:1.0: no power switching (usb 1.0)
[    4.453614] hub 6-0:1.0: individual port over-current protection
[    4.453616] hub 6-0:1.0: power on to power good time: 2ms
[    4.453619] hub 6-0:1.0: local power source is good
[    4.453621] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.453634] PM: Adding info for No Bus:ep_81
[    4.453643] PM: Adding info for No Bus:ep_00
[    4.453658] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.453662] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.453665] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.453681] PM: Adding info for No Bus:usbmon7
[    4.453707] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[    4.453713] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.453716] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.453718] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.453730] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    4.453734] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ac00
[    4.453763] usb usb7: default language 0x0409
[    4.453768] usb usb7: udev 1, busnum 7, minor = 768
[    4.453770] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.453772] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.453773] usb usb7: Product: UHCI Host Controller
[    4.453775] usb usb7: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
[    4.453776] usb usb7: SerialNumber: 0000:00:1d.1
[    4.453798] PM: Adding info for usb:usb7
[    4.453806] usb usb7: uevent
[    4.453834] usb usb7: usb_probe_device
[    4.453836] usb usb7: configuration #1 chosen from 1 choice
[    4.453841] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.453849] PM: Adding info for usb:7-0:1.0
[    4.453852] usb 7-0:1.0: uevent
[    4.453878] hub 7-0:1.0: usb_probe_interface
[    4.453880] hub 7-0:1.0: usb_probe_interface - got id
[    4.453881] hub 7-0:1.0: USB hub found
[    4.453884] hub 7-0:1.0: 2 ports detected
[    4.453886] hub 7-0:1.0: standalone hub
[    4.453887] hub 7-0:1.0: no power switching (usb 1.0)
[    4.453888] hub 7-0:1.0: individual port over-current protection
[    4.453890] hub 7-0:1.0: power on to power good time: 2ms
[    4.453893] hub 7-0:1.0: local power source is good
[    4.453894] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.453907] PM: Adding info for No Bus:ep_81
[    4.453915] PM: Adding info for No Bus:ep_00
[    4.453930] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.453935] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.453937] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.453954] PM: Adding info for No Bus:usbmon8
[    4.453982] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[    4.453988] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.453991] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.453993] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.454007] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    4.454011] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a880
[    4.454037] usb usb8: default language 0x0409
[    4.454042] usb usb8: udev 1, busnum 8, minor = 896
[    4.454044] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    4.454046] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.454048] usb usb8: Product: UHCI Host Controller
[    4.454049] usb usb8: Manufacturer: Linux 2.6.33-rc2 uhci_hcd
[    4.454051] usb usb8: SerialNumber: 0000:00:1d.2
[    4.454073] PM: Adding info for usb:usb8
[    4.454080] usb usb8: uevent
[    4.454136] usb usb8: usb_probe_device
[    4.454138] usb usb8: configuration #1 chosen from 1 choice
[    4.454142] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.454151] PM: Adding info for usb:8-0:1.0
[    4.454154] usb 8-0:1.0: uevent
[    4.454181] hub 8-0:1.0: usb_probe_interface
[    4.454183] hub 8-0:1.0: usb_probe_interface - got id
[    4.454184] hub 8-0:1.0: USB hub found
[    4.454187] hub 8-0:1.0: 2 ports detected
[    4.454188] hub 8-0:1.0: standalone hub
[    4.454190] hub 8-0:1.0: no power switching (usb 1.0)
[    4.454191] hub 8-0:1.0: individual port over-current protection
[    4.454192] hub 8-0:1.0: power on to power good time: 2ms
[    4.454196] hub 8-0:1.0: local power source is good
[    4.454197] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.454207] PM: Adding info for No Bus:ep_81
[    4.454218] PM: Adding info for No Bus:ep_00
[    4.454292] usbcore: registered new interface driver usblp
[    4.454293] Initializing USB Mass Storage driver...
[    4.454341] usbcore: registered new interface driver usb-storage
[    4.454343] USB Mass Storage support registered.
[    4.454393] usbcore: registered new interface driver libusual
[    4.454458] usbcore: registered new interface driver usbserial
[    4.454459] usbserial: USB Serial Driver core
[    4.454487] USB Serial support registered for IPWireless converter
[    4.454518] usbcore: registered new interface driver ipwtty
[    4.454519] ipw: v0.3:IPWireless tty driver
[    4.454596] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[    4.454615] PM: Adding info for platform:i8042
[    4.473880] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.473884] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.473896] PM: Adding info for serio:serio0
[    4.473936] PM: Adding info for serio:serio1
[    4.473957] PM: Adding info for No Bus:mice
[    4.473992] mice: PS/2 mouse device common for all mice
[    4.474003] PM: Adding info for No Bus:event0
[    4.474045] PM: Adding info for No Bus:event1
[    4.474081] PM: Adding info for No Bus:event2
[    4.474117] PM: Adding info for No Bus:event3
[    4.475061] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    4.475080] rtc_cmos 00:03: RTC can wake from S4
[    4.475098] PM: Adding info for No Bus:rtc0
[    4.475133] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    4.475155] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.475199] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[    4.475218] PM: Adding info for i2c:i2c-3
[    4.475282] Linux video capture interface: v2.00
[    4.475392] usbcore: registered new interface driver uvcvideo
[    4.475394] USB Video Class driver (v0.1.0)
[    4.475457] PM: Adding info for platform:coretemp.0
[    4.475508] PM: Adding info for No Bus:hwmon0
[    4.475541] PM: Adding info for platform:coretemp.1
[    4.475578] PM: Adding info for No Bus:hwmon1
[    4.475606] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.475641] usbcore: registered new interface driver btusb
[    4.475902] cpuidle: using governor ladder
[    4.476375] cpuidle: using governor menu
[    4.476432] sdhci: Secure Digital Host Controller Interface driver
[    4.476433] sdhci: Copyright(c) Pierre Ossman
[    4.476446] sdhci-pci 0000:07:00.1: SDHCI controller found
[197b:2382] (rev 0)
[    4.476462] sdhci-pci 0000:07:00.1: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[    4.476496] sdhci-pci 0000:07:00.1: setting latency timer to 64
[    4.476518] PM: Adding info for No Bus:mmc0::
[    4.476558] Registered led device: mmc0::
[    4.476565] PM: Adding info for No Bus:mmc0
[    4.476615] mmc0: SDHCI controller on PCI [0000:07:00.1] using DMA
[    4.476624] sdhci-pci 0000:07:00.2: SDHCI controller found
[197b:2381] (rev 0)
[    4.476638] sdhci-pci 0000:07:00.2: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[    4.476643] sdhci-pci 0000:07:00.2: Refusing to bind to secondary interface.
[    4.476648] sdhci-pci 0000:07:00.2: PCI INT A disabled
[    4.476884] jmb38x_ms 0000:07:00.3: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[    4.476889] jmb38x_ms 0000:07:00.3: setting latency timer to 64
[    4.476914] PM: Adding info for No Bus:memstick0
[    4.478288] usbcore: registered new interface driver hiddev
[    4.478339] usbcore: registered new interface driver usbhid
[    4.478341] usbhid: USB HID core driver
[    4.478424] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    4.478440] PM: Adding info for No Bus:timer
[    4.478524] PM: Adding info for No Bus:seq
[    4.478615] PM: Adding info for No Bus:sequencer
[    4.478698] PM: Adding info for No Bus:sequencer2
[    4.478863] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    4.478896] HDA Intel 0000:00:1b.0: irq 32 for MSI/MSI-X
[    4.478916] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.491123] PM: Adding info for No Bus:input4
[    4.491208] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input4
[    4.491222] PM: Adding info for No Bus:event4
[    4.538274] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[    4.552032] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803
POWER sig=j CSC CONNECT
[    4.552035] hub 2-0:1.0: port 4: status 0501 change 0001
[    4.552054] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.553294] uhci_hcd 0000:00:1d.1: port 2 portsc 008a,00
[    4.553302] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.553305] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.553307] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.554292] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.564281] PM: Adding info for No Bus:card0
[    4.564363] PM: Adding info for No Bus:pcmC0D3p
[    4.564431] PM: Adding info for No Bus:pcmC0D2c
[    4.564497] PM: Adding info for No Bus:pcmC0D1p
[    4.564565] PM: Adding info for No Bus:pcmC0D1c
[    4.564633] PM: Adding info for No Bus:adsp
[    4.564700] PM: Adding info for No Bus:pcmC0D0p
[    4.564748] PM: Adding info for No Bus:pcmC0D0c
[    4.564797] PM: Adding info for No Bus:dsp
[    4.564847] PM: Adding info for No Bus:audio
[    4.564897] PM: Adding info for No Bus:hwC0D2
[    4.564944] PM: Adding info for No Bus:hwC0D1
[    4.564991] PM: Adding info for No Bus:hwC0D0
[    4.565048] PM: Adding info for No Bus:controlC0
[    4.565098] PM: Adding info for No Bus:mixer
[    4.565649] ALSA device list:
[    4.565650]   #0: HDA Intel at 0xf8ef8000 irq 32
[    4.565680] Netfilter messages via NETLINK v0.30.
[    4.565693] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.565876] ctnetlink v0.93: registering with nfnetlink.
[    4.565947] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.565970] TCP cubic registered
[    4.565972] Initializing XFRM netlink socket
[    4.566267] NET: Registered protocol family 10
[    4.566424] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.566445] IPv6 over IPv4 tunneling driver
[    4.566480] PM: Adding info for No Bus:sit0
[    4.566556] NET: Registered protocol family 17
[    4.566561] Bluetooth: L2CAP ver 2.14
[    4.566563] Bluetooth: L2CAP socket layer initialized
[    4.566587] Bluetooth: RFCOMM TTY layer initialized
[    4.566589] Bluetooth: RFCOMM socket layer initialized
[    4.566591] Bluetooth: RFCOMM ver 1.11
[    4.566601] lib80211: common routines for IEEE802.11 drivers
[    4.566603] lib80211_crypt: registered algorithm 'NULL'
[    4.567027] PM: Adding info for No Bus:cpu_dma_latency
[    4.567096] PM: Adding info for No Bus:network_latency
[    4.567160] PM: Adding info for No Bus:network_throughput
[    4.567216] PM: Checking image partition /dev/sda3
[    4.567231] PM: Resume from partition 8:3
[    4.567232] PM: Checking hibernation image.
[    4.599664] PM: Error -22 checking image file
[    4.599666] PM: Resume from disk failed.
[    4.599671] registered taskstats version 1
[    4.600058]   Magic number: 5:225:27
[    4.652321] hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
[    4.652330] hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
[    4.661988] [drm] nouveau 0000:08:00.0: 0xB9B3: parsing clock script 1
[    4.703257] ehci_hcd 0000:00:1d.7: port 4 full speed --> companion
[    4.703261] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003801
POWER OWNER sig=j CONNECT
[    4.703269] hub 2-0:1.0: port 4 not reset yet, waiting 50ms
[    4.730038] ata2: SATA link down (SStatus 0 SControl 300)
[    4.754297] ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003002
POWER OWNER sig=se0 CSC
[    4.754315] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0004
[    4.754321] uhci_hcd 0000:00:1d.1: port 2 portsc 0093,00
[    4.754327] hub 7-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[    4.858035] hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms
status 0x101
[    4.960033] usb 7-2: new full speed USB device using uhci_hcd and address 2
[    5.081030] usb 7-2: ep0 maxpacket = 32
[    5.103808] usb 7-2: skipped 1 descriptor after interface
[    5.103811] usb 7-2: skipped 1 descriptor after interface
[    5.108806] usb 7-2: default language 0x0409
[    5.120797] usb 7-2: udev 2, busnum 7, minor = 769
[    5.120799] usb 7-2: New USB device found, idVendor=ffc0, idProduct=001f
[    5.120802] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.120804] usb 7-2: Product: Gaming II
[    5.120806] usb 7-2: Manufacturer: Areson
[    5.120844] PM: Adding info for usb:7-2
[    5.120856] usb 7-2: uevent
[    5.120951] usb 7-2: usb_probe_device
[    5.120954] usb 7-2: configuration #1 chosen from 1 choice
[    5.123808] usb 7-2: adding 7-2:1.0 (config #1, interface 0)
[    5.123822] PM: Adding info for usb:7-2:1.0
[    5.123827] usb 7-2:1.0: uevent
[    5.123901] usbhid 7-2:1.0: usb_probe_interface
[    5.123903] usbhid 7-2:1.0: usb_probe_interface - got id
[    5.123922] PM: Adding info for hid:0003:FFC0:001F.0001
[    5.128014] PM: Adding info for No Bus:input5
[    5.128084] input: Areson Gaming II as
/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input5
[    5.128098] PM: Adding info for No Bus:mouse0
[    5.128165] PM: Adding info for No Bus:event5
[    5.128234] PM: Adding info for No Bus:hidraw0
[    5.128305] generic-usb 0003:FFC0:001F.0001: input,hidraw0: USB HID
v10.01 Mouse [Areson Gaming II] on usb-0000:00:1d.1-2/input0
[    5.128322] PM: Adding info for No Bus:ep_81
[    5.128324] usb 7-2: adding 7-2:1.1 (config #1, interface 1)
[    5.128333] PM: Adding info for usb:7-2:1.1
[    5.128336] usb 7-2:1.1: uevent
[    5.128418] usbhid 7-2:1.1: usb_probe_interface
[    5.128420] usbhid 7-2:1.1: usb_probe_interface - got id
[    5.128432] PM: Adding info for hid:0003:FFC0:001F.0002
[    5.135898] PM: Adding info for No Bus:input6
[    5.135963] input: Areson Gaming II as
/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.1/input/input6
[    5.135970] uhci_hcd 0000:00:1d.1: reserve dev 2 ep82-INT, period
1, phase 0, 23 us
[    5.135982] PM: Adding info for No Bus:mouse1
[    5.136037] PM: Adding info for No Bus:event6
[    5.136084] PM: Adding info for No Bus:hidraw1
[    5.136123] generic-usb 0003:FFC0:001F.0002: input,hidraw1: USB HID
v10.01 Mouse [Areson Gaming II] on usb-0000:00:1d.1-2/input1
[    5.136143] PM: Adding info for No Bus:ep_82
[    5.136152] PM: Adding info for No Bus:ep_00
[    5.136155] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0010
[    5.385121] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1,
caps: 0xa04711/0x200000
[    5.454079] usb usb3: suspend_rh (auto-stop)
[    5.454086] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.454101] usb usb4: suspend_rh (auto-stop)
[    5.454118] usb usb5: suspend_rh (auto-stop)
[    5.454135] usb usb6: suspend_rh (auto-stop)
[    5.454152] usb usb8: suspend_rh (auto-stop)
[    5.458777] PM: Adding info for No Bus:input7
[    5.458859] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input7
[    5.458874] PM: Adding info for No Bus:mouse2
[    5.458922] PM: Adding info for No Bus:event7
[    5.467763] ata5.00: ATAPI: Optiarc DVD RW AD-7560S, SX01, max
UDMA/100, ATAPI AN
[    5.481882] ata5.00: configured for UDMA/100
[    5.484739] scsi 4:0:0:0: CD-ROM            Optiarc  DVD RW
AD-7560S  SX01 PQ: 0 ANSI: 5
[    5.484753] PM: Adding info for scsi:target4:0:0
[    5.484831] PM: Adding info for scsi:4:0:0:0
[    5.490464] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    5.490467] Uniform CD-ROM driver Revision: 3.20
[    5.490495] PM: Adding info for No Bus:sr0
[    5.490599] PM: Adding info for No Bus:11:0
[    5.490650] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    5.490658] PM: Adding info for No Bus:4:0:0:0
[    5.490721] PM: Adding info for No Bus:sg1
[    5.490762] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    5.490775] PM: Adding info for No Bus:4:0:0:0
[    5.795098] ata6: SATA link down (SStatus 0 SControl 300)
[    5.845963] EXT4-fs (sda2): mounted filesystem with ordered data mode
[    5.845972] VFS: Mounted root (ext2 filesystem) readonly on device 8:2.
[    5.846001] Freeing unused kernel memory: 544k freed
[    5.846151] Write protecting the kernel read-only data: 10240k
[    5.846417] Freeing unused kernel memory: 1832k freed
[    5.846991] Freeing unused kernel memory: 184k freed
[    6.701111] hub 1-0:1.0: hub_suspend
[    6.701120] usb usb1: bus auto-suspend
[    6.701123] ehci_hcd 0000:00:1a.7: suspend root hub
[    6.701143] hub 3-0:1.0: hub_suspend
[    6.701147] usb usb3: bus auto-suspend
[    6.701150] usb usb3: suspend_rh
[    6.701170] hub 4-0:1.0: hub_suspend
[    6.701173] usb usb4: bus auto-suspend
[    6.701175] usb usb4: suspend_rh
[    6.701188] hub 5-0:1.0: hub_suspend
[    6.701191] usb usb5: bus auto-suspend
[    6.701192] usb usb5: suspend_rh
[    6.701205] hub 6-0:1.0: hub_suspend
[    6.701208] usb usb6: bus auto-suspend
[    6.701209] usb usb6: suspend_rh
[    6.701222] hub 8-0:1.0: hub_suspend
[    6.701225] usb usb8: bus auto-suspend
[    6.701226] usb usb8: suspend_rh
[    7.701287] hub 2-0:1.0: hub_suspend
[    7.701296] usb usb2: bus auto-suspend
[    7.701299] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.116686] udev: starting version 149
[    8.303365] usb usb3: uevent
[    8.303385] usb 3-0:1.0: uevent
[    8.303438] usb usb4: uevent
[    8.303455] usb 4-0:1.0: uevent
[    8.303507] usb usb5: uevent
[    8.303524] usb 5-0:1.0: uevent
[    8.303573] usb usb1: uevent
[    8.303590] usb 1-0:1.0: uevent
[    8.315495] usb usb6: uevent
[    8.315514] usb 6-0:1.0: uevent
[    8.315564] usb usb7: uevent
[    8.315581] usb 7-0:1.0: uevent
[    8.315600] usb 7-2: uevent
[    8.315618] usb 7-2:1.0: uevent
[    8.315734] usb 7-2:1.1: uevent
[    8.315891] usb usb8: uevent
[    8.315908] usb 8-0:1.0: uevent
[    8.315957] usb usb2: uevent
[    8.315973] usb 2-0:1.0: uevent
[    8.336969] usb usb1: uevent
[    8.337688] usb usb6: uevent
[    8.338367] usb usb7: uevent
[    8.339614] usb usb3: uevent
[    8.340769] usb usb2: uevent
[    8.343896] usb usb5: uevent
[    8.365359] usb usb4: uevent
[    8.366214] usb usb8: uevent
[    8.373765] usb 7-2: uevent
[    8.390914] usb 7-2:1.1: uevent
[    8.391029] usb 7-2: uevent
[    8.391681] usb 7-2:1.1: uevent
[    8.391767] usb 7-2: uevent
[    8.397592] usb 7-2:1.0: uevent
[    8.397688] usb 7-2: uevent
[    8.398596] usb 7-2:1.1: uevent
[    8.398755] usb 7-2:1.0: uevent
[    8.399303] usb 7-2:1.1: uevent
[    8.400408] usb 7-2:1.0: uevent
[    8.400496] usb 7-2: uevent
[    8.401385] usb 7-2:1.0: uevent
[   28.124895] EXT4-fs (sda4): mounted filesystem with ordered data mode
[   29.212479] PM: Adding info for No Bus:vcs2
[   29.212503] PM: Adding info for No Bus:vcsa2
[   29.212610] PM: Adding info for No Bus:vcs3
[   29.212623] PM: Adding info for No Bus:vcsa3
[   29.212722] PM: Adding info for No Bus:vcs4
[   29.212734] PM: Adding info for No Bus:vcsa4
[   29.212833] PM: Adding info for No Bus:vcs5
[   29.212847] PM: Adding info for No Bus:vcsa5
[   29.212944] PM: Adding info for No Bus:vcs6
[   29.212957] PM: Adding info for No Bus:vcsa6
[   29.213056] PM: Adding info for No Bus:vcs7
[   29.213069] PM: Adding info for No Bus:vcsa7
[   29.213166] PM: Adding info for No Bus:vcs8
[   29.213180] PM: Adding info for No Bus:vcsa8
[   29.213287] PM: Adding info for No Bus:vcs9
[   29.213301] PM: Adding info for No Bus:vcsa9
[   29.213400] PM: Adding info for No Bus:vcs10
[   29.213415] PM: Adding info for No Bus:vcsa10
[   29.213514] PM: Adding info for No Bus:vcs11
[   29.213532] PM: Adding info for No Bus:vcsa11
[   29.213632] PM: Adding info for No Bus:vcs12
[   29.213647] PM: Adding info for No Bus:vcsa12
[   30.210484] usb usb3: uevent
[   30.210559] usb 3-0:1.0: uevent
[   30.210695] usb usb4: uevent
[   30.210766] usb 4-0:1.0: uevent
[   30.210902] usb usb5: uevent
[   30.210975] usb 5-0:1.0: uevent
[   30.211117] usb usb1: uevent
[   30.211189] usb 1-0:1.0: uevent
[   30.213398] usb usb6: uevent
[   30.213471] usb 6-0:1.0: uevent
[   30.213607] usb usb7: uevent
[   30.213679] usb 7-0:1.0: uevent
[   30.213728] usb 7-2: uevent
[   30.213801] usb 7-2:1.0: uevent
[   30.214179] usb 7-2:1.1: uevent
[   30.214657] usb usb8: uevent
[   30.214729] usb 8-0:1.0: uevent
[   30.214863] usb usb2: uevent
[   30.214934] usb 2-0:1.0: uevent
[   31.185320] Adding 2000084k swap on /dev/sda3.  Priority:-1
extents:1 across:2000084k
[  157.691175] [drm] nouveau 0000:08:00.0: Allocating FIFO number 2
[  157.696919] [drm] nouveau 0000:08:00.0: nouveau_channel_alloc:
initialised FIFO 2
[  157.881312] [drm] nouveau 0000:08:00.0: Allocating FIFO number 3
[  157.887019] [drm] nouveau 0000:08:00.0: nouveau_channel_alloc:
initialised FIFO 3
[  158.461345] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period
1, phase 0, 17 us
[  218.689742] iwlagn 0000:06:00.0: firmware: requesting iwlwifi-5000-2.ucode
[  218.689763] PM: Adding info for No Bus:0000:06:00.0
[  218.725001] PM: Removing info for No Bus:0000:06:00.0
[  218.725040] iwlagn 0000:06:00.0: loaded firmware version 8.24.2.12
[  218.869016] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  222.034010] wlan0: direct probe to AP 00:4f:62:01:e3:ee (try 1)
[  222.035889] wlan0: direct probe responded
[  222.035892] wlan0: authenticate with AP 00:4f:62:01:e3:ee (try 1)
[  222.037793] wlan0: authenticated
[  222.037807] wlan0: associate with AP 00:4f:62:01:e3:ee (try 1)
[  222.039722] wlan0: RX AssocResp from 00:4f:62:01:e3:ee (capab=0x1
status=0 aid=1)
[  222.039725] wlan0: associated
[  222.041166] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  232.302079] wlan0: no IPv6 routers present
[  513.000282] CE: hpet increasing min_delta_ns to 15000 nsec
[ 1604.679872] atkbd.c: Unknown key pressed (translated set 2, code
0xee on isa0060/serio0).
[ 1604.679877] atkbd.c: Use 'setkeycodes e06e <keycode>' to make it known.
[ 1604.684809] atkbd.c: Unknown key released (translated set 2, code
0xee on isa0060/serio0).
[ 1604.684812] atkbd.c: Use 'setkeycodes e06e <keycode>' to make it known.
[ 1604.696699] usb usb2: usb resume
[ 1604.696703] ehci_hcd 0000:00:1d.7: resume root hub
[ 1604.737088] hub 2-0:1.0: hub_resume
[ 1604.737098] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803
POWER sig=j CSC CONNECT
[ 1604.737103] hub 2-0:1.0: port 1: status 0501 change 0001
[ 1604.838077] hub 2-0:1.0: state 7 ports 6 chg 0002 evt 0000
[ 1604.838085] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[ 1604.889236] ehci_hcd 0000:00:1d.7: port 1 high speed
[ 1604.889239] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005
POWER sig=se0 PE CONNECT
[ 1604.940121] usb 2-1: new high speed USB device using ehci_hcd and address 3
[ 1604.992237] ehci_hcd 0000:00:1d.7: port 1 high speed
[ 1604.992240] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005
POWER sig=se0 PE CONNECT
[ 1605.110140] usb 2-1: skipped 1 descriptor after configuration
[ 1605.110144] usb 2-1: skipped 6 descriptors after interface
[ 1605.110148] usb 2-1: skipped 1 descriptor after endpoint
[ 1605.110150] usb 2-1: skipped 20 descriptors after interface
[ 1605.111012] usb 2-1: default language 0x0409
[ 1605.115768] usb 2-1: udev 3, busnum 2, minor = 130
[ 1605.115771] usb 2-1: New USB device found, idVendor=04f2, idProduct=b073
[ 1605.115774] usb 2-1: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[ 1605.115776] usb 2-1: Product: CNF7231
[ 1605.115779] usb 2-1: Manufacturer: Chicony Electronics Co., Ltd.
[ 1605.115837] PM: Adding info for usb:2-1
[ 1605.115857] usb 2-1: uevent
[ 1605.115871] usb 2-1: usb_probe_device
[ 1605.115874] usb 2-1: configuration #1 chosen from 1 choice
[ 1605.116234] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[ 1605.116252] PM: Adding info for usb:2-1:1.0
[ 1605.116786] usb 2-1: uevent
[ 1605.118272] usb 2-1:1.0: uevent
[ 1605.118302] uvcvideo 2-1:1.0: usb_probe_interface
[ 1605.118305] uvcvideo 2-1:1.0: usb_probe_interface - got id
[ 1605.118321] uvcvideo: Found UVC 1.00 device CNF7231 (04f2:b073)
[ 1605.129935] PM: Adding info for No Bus:video0
[ 1605.129970] PM: Adding info for No Bus:input8
[ 1605.129987] input: CNF7231 as
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:1.0/input/input8
[ 1605.130004] PM: Adding info for No Bus:event8
[ 1605.130025] PM: Adding info for No Bus:ep_83
[ 1605.130028] usb 2-1: adding 2-1:1.1 (config #1, interface 1)
[ 1605.130043] PM: Adding info for usb:2-1:1.1
[ 1605.130046] usb 2-1:1.1: uevent
[ 1605.130067] PM: Adding info for No Bus:ep_00
[ 1605.137055] usb 2-1:1.0: uevent
[ 1605.137149] usb 2-1: uevent
[ 1605.138784] usb 2-1:1.0: uevent
[ 1605.169083] usb 2-1: link qh4-0001/ffff880104985e00 start 1 [1/0 us]
[ 1605.169127] usb 2-1: unlink qh4-0001/ffff880104985e00 start 1 [1/0 us]
[ 1605.170023] usb 2-1:1.0: uevent
[ 1605.170116] usb 2-1: uevent
[ 1605.171128] usb 2-1:1.0: uevent
[ 1605.192625] ehci_hcd 0000:00:1d.7: reused qh ffff880104985e00 schedule
[ 1605.192630] usb 2-1: link qh4-0001/ffff880104985e00 start 1 [1/0 us]
[ 1605.193148] usb 2-1: unlink qh4-0001/ffff880104985e00 start 1 [1/0 us]
[ 1605.379509] atkbd.c: Unknown key pressed (translated set 2, code
0xe2 on isa0060/serio0).
[ 1605.379513] atkbd.c: Use 'setkeycodes e062 <keycode>' to make it known.
[ 1605.384769] atkbd.c: Unknown key released (translated set 2, code
0xe2 on isa0060/serio0).
[ 1605.384772] atkbd.c: Use 'setkeycodes e062 <keycode>' to make it known.
[ 1605.545522] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[ 1605.545533] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 001803
POWER sig=j CSC CONNECT
[ 1605.545541] hub 2-0:1.0: port 3, status 0501, change 0001, 480 Mb/s
[ 1605.649095] hub 2-0:1.0: debounce: port 3: total 100ms stable 100ms
status 0x501
[ 1605.700495] ehci_hcd 0000:00:1d.7: port 3 full speed --> companion
[ 1605.700500] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003801
POWER OWNER sig=j CONNECT
[ 1605.700504] hub 2-0:1.0: port 3 not reset yet, waiting 50ms
[ 1605.751341] ehci_hcd 0000:00:1d.7: GetStatus port 3 status 003002
POWER OWNER sig=se0 CSC
[ 1605.751365] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0002
[ 1605.751373] uhci_hcd 0000:00:1d.1: port 1 portsc 0093,00
[ 1605.751380] hub 7-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[ 1605.855289] hub 7-0:1.0: debounce: port 1: total 100ms stable 100ms
status 0x101
[ 1605.957091] usb 7-1: new full speed USB device using uhci_hcd and address 3
[ 1606.294150] usb 7-1: udev 3, busnum 7, minor = 770
[ 1606.294154] usb 7-1: New USB device found, idVendor=0db0, idProduct=a97a
[ 1606.294157] usb 7-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 1606.294220] PM: Adding info for usb:7-1
[ 1606.294231] usb 7-1: uevent
[ 1606.294244] usb 7-1: usb_probe_device
[ 1606.294247] usb 7-1: configuration #1 chosen from 1 choice
[ 1606.294938] usb 7-1: uevent
[ 1606.297173] usb 7-1: adding 7-1:1.0 (config #1, interface 0)
[ 1606.297191] PM: Adding info for usb:7-1:1.0
[ 1606.297196] usb 7-1:1.0: uevent
[ 1606.297218] btusb 7-1:1.0: usb_probe_interface
[ 1606.297220] btusb 7-1:1.0: usb_probe_interface - got id
[ 1606.297246] PM: Adding info for No Bus:hci0
[ 1606.297278] PM: Adding info for No Bus:rfkill1
[ 1606.297301] PM: Adding info for No Bus:ep_81
[ 1606.297311] PM: Adding info for No Bus:ep_02
[ 1606.297319] PM: Adding info for No Bus:ep_82
[ 1606.297321] usb 7-1: adding 7-1:1.1 (config #1, interface 1)
[ 1606.297329] PM: Adding info for usb:7-1:1.1
[ 1606.297333] usb 7-1:1.1: uevent
[ 1606.297347] PM: Adding info for No Bus:ep_03
[ 1606.297356] PM: Adding info for No Bus:ep_83
[ 1606.297367] PM: Adding info for No Bus:ep_00
[ 1606.297372] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[ 1606.299980] uhci_hcd 0000:00:1d.1: reserve dev 3 ep81-INT, period
1, phase 0, 23 us
[ 1607.781748] atkbd.c: Unknown key pressed (translated set 2, code
0xe2 on isa0060/serio0).
[ 1607.781752] atkbd.c: Use 'setkeycodes e062 <keycode>' to make it known.
[ 1607.782141] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.782155] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.784139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.785143] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.786134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.786139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.786498] atkbd.c: Unknown key released (translated set 2, code
0xe2 on isa0060/serio0).
[ 1607.786501] atkbd.c: Use 'setkeycodes e062 <keycode>' to make it known.
[ 1607.787135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.788139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.789134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.789139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.790123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.791134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.792134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.792139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.793144] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.794123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.795134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.795138] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.796123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.797139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.798123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.798128] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.799135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.800135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.801135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.801139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.802123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.803141] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.804135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.804139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.805124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.806139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.807134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.807138] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.808123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.809139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.810123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.810127] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.811135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.812135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.813125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.813129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.814139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.815124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.816134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.816138] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.817124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.818135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.819129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.819134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.820123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.821139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.822123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.822127] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.823139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.824124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.825135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.825139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.826123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.827139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.828123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.828127] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.829135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.830135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.831134] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.831138] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.832123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.833139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.834135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.834140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.835123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.836139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.837126] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.837130] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.838123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.839139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.840135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.840139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.841124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.842140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.843138] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.843144] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.844139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.845124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.846135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.847135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.847139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.848124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.849139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.850123] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.850127] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.851135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.852135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.853135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.853139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.854124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.855135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.856135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.856139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.857124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.858139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.859124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.859128] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.860135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.861135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.862135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.862139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.863137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.864124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.865135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.865139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.866124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.867139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.868124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.868128] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.869136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.870135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.871135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.871139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.872124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.873139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.874135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.874139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.875124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.876140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.877124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.877129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.878136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.879136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.880135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.880140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.881124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.882140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.883135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.883139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.884140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.885125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.886135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.886139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.887124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.888140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.889124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.889129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.890136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.891135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.892136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.892140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.893136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.894125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.895136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.895140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.896125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.897140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.898124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.898128] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.899136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.900136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.901136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.901140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.902124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.903140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.904136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.904140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.905124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.906140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.907124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.907128] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.908139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.909125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.910135] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.910139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.911124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.912140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.913127] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.913133] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.914139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.915139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.916139] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.916144] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.917140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.918137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.919136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.920137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.920141] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.921124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.922140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.923124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.923129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.924140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.925137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.926136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.926140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.927124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.928140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.929124] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.929129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.930136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.931136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.932137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.932141] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.933125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.934140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.935125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.935130] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.936136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.937137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.938136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.938140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.939125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.940140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.941125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.941129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.942137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.943136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.944125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.944130] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.945136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.946136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.947136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.947140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.948125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.949140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.950125] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.950129] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.951136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.952137] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.953136] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.953140] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.954047] usb 7-1: uhci_result_common: failed with status 440000
[ 1607.954074] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0002
[ 1607.954084] uhci_hcd 0000:00:1d.1: port 1 portsc 008a,00
[ 1607.954095] hub 7-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
[ 1607.954098] usb 7-1: USB disconnect, address 3
[ 1607.954100] usb 7-1: unregistering device
[ 1607.954103] usb 7-1: usb_disable_device nuking all URBs
[ 1607.954109] uhci_hcd 0000:00:1d.1: shutdown urb ffff8800bcf346c0 ep1in-intr
[ 1607.954128] btusb_intr_complete: hci0 urb ffff8800bcf346c0 failed
to resubmit (19)
[ 1607.954133] uhci_hcd 0000:00:1d.1: release dev 3 ep81-INT, period
1, phase 0, 23 us
[ 1607.954140] uhci_hcd 0000:00:1d.1: shutdown urb ffff8800bcf34d80 ep2in-bulk
[ 1607.954142] uhci_hcd 0000:00:1d.1: shutdown urb ffff8800bcf34840 ep2in-bulk
[ 1607.955145] btusb_bulk_complete: hci0 urb ffff8800bcf34d80 failed
to resubmit (19)
[ 1607.955152] btusb_bulk_complete: hci0 urb ffff8800bcf34840 failed
to resubmit (19)
[ 1607.955175] usb 7-1: unregistering interface 7-1:1.0
[ 1607.955179] PM: Removing info for No Bus:ep_81
[ 1607.955195] PM: Removing info for No Bus:ep_02
[ 1607.955204] PM: Removing info for No Bus:ep_82
[ 1607.955215] PM: Removing info for usb:7-1:1.0
[ 1607.955260] btusb_send_frame: hci0 urb ffff88010af64540 submission failed
[ 1608.057379] atkbd.c: Unknown key pressed (translated set 2, code
0xee on isa0060/serio0).
[ 1608.057383] atkbd.c: Use 'setkeycodes e06e <keycode>' to make it known.
[ 1608.062252] atkbd.c: Unknown key released (translated set 2, code
0xee on isa0060/serio0).
[ 1608.062256] atkbd.c: Use 'setkeycodes e06e <keycode>' to make it known.
[ 1608.205142] PM: Removing info for No Bus:rfkill1
[ 1608.205180] PM: Removing info for No Bus:hci0
[ 1608.205208] usb 7-1:1.0: uevent
[ 1608.205217] usb 7-1: unregistering interface 7-1:1.1
[ 1608.205218] PM: Removing info for No Bus:ep_03
[ 1608.205225] PM: Removing info for No Bus:ep_83
[ 1608.205232] PM: Removing info for usb:7-1:1.1
[ 1608.205242] usb 7-1:1.1: uevent
[ 1608.205249] PM: Removing info for No Bus:ep_00
[ 1608.205267] PM: Removing info for usb:7-1
[ 1608.205304] usb 7-1: uevent
[ 1608.309096] hub 7-0:1.0: debounce: port 1: total 100ms stable 100ms
status 0x100
[ 1608.309103] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0002
[ 1608.309113] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001002
POWER sig=se0 CSC
[ 1608.309120] hub 2-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[ 1608.309124] usb 2-1: USB disconnect, address 3
[ 1608.309126] usb 2-1: unregistering device
[ 1608.309129] usb 2-1: usb_disable_device nuking all URBs
[ 1608.309136] usb 2-1: unregistering interface 2-1:1.0
[ 1608.309139] PM: Removing info for No Bus:ep_83
[ 1608.309159] PM: Removing info for usb:2-1:1.0
[ 1608.309183] PM: Removing info for No Bus:video0
[ 1608.310503] PM: Removing info for No Bus:event8
[ 1608.313104] PM: Removing info for No Bus:input8
[ 1608.313174] usb 2-1:1.0: uevent
[ 1608.313184] usb 2-1: unregistering interface 2-1:1.1
[ 1608.313186] PM: Removing info for usb:2-1:1.1
[ 1608.313198] usb 2-1:1.1: uevent
[ 1608.313206] PM: Removing info for No Bus:ep_00
[ 1608.313217] PM: Removing info for usb:2-1
[ 1608.313245] usb 2-1: uevent
[ 1608.417020] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms
status 0x100
[ 1610.704093] hub 2-0:1.0: hub_suspend
[ 1610.704103] usb usb2: bus auto-suspend
[ 1610.704106] ehci_hcd 0000:00:1d.7: suspend root hub
[19721.086872] [drm] nouveau 0000:08:00.0: Allocating FIFO number 4
[19721.092831] [drm] nouveau 0000:08:00.0: nouveau_channel_alloc:
initialised FIFO 4
[19734.449250] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[19734.449253] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19734.455953] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[19734.455955] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19734.660978] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[19734.660981] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19734.667635] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[19734.667637] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19734.836207] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[19734.836210] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19734.842551] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[19734.842554] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19734.976724] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[19734.976727] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19734.983398] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[19734.983401] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19735.153034] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[19735.153037] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19735.160393] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[19735.160396] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19735.293130] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[19735.293133] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[19735.299759] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[19735.299762] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[20007.575708] [drm] nouveau 0000:08:00.0: nouveau_channel_free: freeing fifo 4
[20015.046481] atkbd.c: Unknown key pressed (translated set 2, code
0xf7 on isa0060/serio0).
[20015.046484] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[20015.052994] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[20015.052996] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[20015.222197] atkbd.c: Unknown key pressed (translated set 2, code
0xf7 on isa0060/serio0).
[20015.222200] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[20015.228941] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[20015.228943] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[20015.363114] atkbd.c: Unknown key pressed (translated set 2, code
0xf7 on isa0060/serio0).
[20015.363117] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[20015.369584] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[20015.369587] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[20242.940509] PM: Adding info for No Bus:vcs15
[20242.940531] PM: Adding info for No Bus:vcsa15
[20242.966786] uhci_hcd 0000:00:1d.1: release dev 2 ep81-INT, period
1, phase 0, 17 us
[20242.996918] PM: Syncing filesystems ... done.
[20243.052679] PM: Preparing system for mem sleep
[20243.052744] PM: Adding info for No Bus:vcs63
[20243.052767] PM: Adding info for No Bus:vcsa63
[20243.055261] Freezing user space processes ... (elapsed 0.01 seconds) done.
[20243.066099] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[20243.077099] PM: Entering mem sleep
[20243.077110] Suspending console(s) (use no_console_suspend to debug)
[20243.077202] pci 0000:00:00.0: preparing suspend
[20243.077205] pcieport 0000:00:01.0: preparing suspend
[20243.077207] uhci_hcd 0000:00:1a.0: preparing suspend
[20243.077209] uhci_hcd 0000:00:1a.1: preparing suspend
[20243.077211] uhci_hcd 0000:00:1a.2: preparing suspend
[20243.077214] ehci_hcd 0000:00:1a.7: preparing suspend
[20243.077216] HDA Intel 0000:00:1b.0: preparing suspend
[20243.077218] pcieport 0000:00:1c.0: preparing suspend
[20243.077220] pcieport 0000:00:1c.1: preparing suspend
[20243.077222] pcieport 0000:00:1c.2: preparing suspend
[20243.077224] pcieport 0000:00:1c.3: preparing suspend
[20243.077226] pcieport 0000:00:1c.5: preparing suspend
[20243.077228] uhci_hcd 0000:00:1d.0: preparing suspend
[20243.077230] uhci_hcd 0000:00:1d.1: preparing suspend
[20243.077232] uhci_hcd 0000:00:1d.2: preparing suspend
[20243.077234] ehci_hcd 0000:00:1d.7: preparing suspend
[20243.077236] pci 0000:00:1e.0: preparing suspend
[20243.077238] pci 0000:00:1f.0: preparing suspend
[20243.077240] ahci 0000:00:1f.2: preparing suspend
[20243.077242] i801_smbus 0000:00:1f.3: preparing suspend
[20243.077244] nouveau 0000:08:00.0: preparing suspend
[20243.077247] pci 0000:02:00.0: preparing suspend
[20243.077251] iwlagn 0000:06:00.0: preparing suspend
[20243.077254] pci 0000:07:00.0: preparing suspend
[20243.077256] sdhci-pci 0000:07:00.1: preparing suspend
[20243.077258] pci 0000:07:00.2: preparing suspend
[20243.077260] jmb38x_ms 0000:07:00.3: preparing suspend
[20243.077262] pci 0000:07:00.4: preparing suspend
[20243.077267] platform regulatory.0: preparing suspend
[20243.077290] platform microcode: preparing suspend
[20243.077364] serial8250 serial8250: preparing suspend
[20243.077418] usb usb1: preparing type suspend, may wakeup
[20243.077426] usb usb2: preparing type suspend, may wakeup
[20243.077431] usb usb3: preparing type suspend, may wakeup
[20243.077436] usb usb4: preparing type suspend, may wakeup
[20243.077440] usb usb5: preparing type suspend, may wakeup
[20243.077445] usb usb6: preparing type suspend, may wakeup
[20243.077450] usb usb7: preparing type suspend, may wakeup
[20243.077454] usb usb8: preparing type suspend, may wakeup
[20243.077458] i8042 i8042: preparing suspend
[20243.077467] coretemp coretemp.0: preparing suspend
[20243.077470] coretemp coretemp.1: preparing suspend
[20243.077491] usb 7-2: preparing type suspend
[20243.077531] sr 4:0:0:0: legacy suspend
[20243.077533] scsi target4:0:0: legacy suspend
[20243.077535] input input7: type suspend
[20243.077538] input input6: type suspend
[20243.077541] input input5: type suspend
[20243.077543] usb 7-2: type suspend
[20243.078785] uhci_hcd 0000:00:1d.1: release dev 2 ep82-INT, period
1, phase 0, 23 us
[20243.078800] usb 7-2: usb suspend
[20243.089092] input input4: type suspend
[20243.089097] leds mmc0::: legacy class suspend
[20243.089100] coretemp coretemp.1: suspend
[20243.089103] coretemp coretemp.0: suspend
[20243.089105] i2c i2c-3: suspend
[20243.089109] psmouse serio1: suspend
[20243.495729] atkbd serio0: suspend
[20243.599118] i8042 i8042: suspend
[20243.601576] usb usb8: type suspend, may wakeup
[20243.601579] usb usb7: type suspend, may wakeup
[20243.601581] hub 7-0:1.0: hub_suspend
[20243.601584] usb usb7: bus suspend
[20243.601585] usb usb7: suspend_rh
[20243.601600] usb usb6: type suspend, may wakeup
[20243.601603] usb usb5: type suspend, may wakeup
[20243.601605] usb usb4: type suspend, may wakeup
[20243.601607] usb usb3: type suspend, may wakeup
[20243.601610] usb usb2: type suspend, may wakeup
[20243.601613] usb usb1: type suspend, may wakeup
[20243.601615] rfkill rfkill0: legacy class suspend
[20243.601617] ieee80211 phy0: legacy class suspend
[20243.617106] sd 0:0:0:0: legacy suspend
[20243.617110] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[20243.617278] sd 0:0:0:0: [sda] Stopping disk
[20244.700471] scsi target0:0:0: legacy suspend
[20244.700474] scsi host5: legacy suspend
[20244.700477] scsi host4: legacy suspend
[20244.700479] scsi host3: legacy suspend
[20244.700482] scsi host2: legacy suspend
[20244.700484] scsi host1: legacy suspend
[20244.700487] scsi host0: legacy suspend
[20244.700504] serial8250 serial8250: suspend
[20244.700508] i2c i2c-2: suspend
[20244.700510] i2c i2c-1: suspend
[20244.700513] drm card0-VGA-1: legacy class suspend
[20244.700521] drm card0-DVI-D-1: legacy class suspend
[20244.700522] i2c i2c-0: suspend
[20244.700524] drm card0-LVDS-1: legacy class suspend
[20244.700526] drm card0: legacy class suspend
[20244.700527] drm controlD64: legacy class suspend
[20244.700529] drm ttm: legacy class suspend
[20244.700544] input input3: type suspend
[20244.700547] backlight acpi_video0: legacy class suspend
[20244.700549] input input2: type suspend
[20244.700550] input input1: type suspend
[20244.700552] input input0: type suspend
[20244.700558] platform microcode: suspend
[20244.700562] system 00:0f: legacy suspend
[20244.700567] system 00:0e: legacy suspend
[20244.700569] ACPI handle has no context!
[20244.700571] pnp 00:0d: legacy suspend
[20244.700573] system 00:0c: legacy suspend
[20244.700576] system 00:0b: legacy suspend
[20244.700578] pnp 00:0a: legacy suspend
[20244.700580] pnp 00:09: legacy suspend
[20244.700581] system 00:08: legacy suspend
[20244.700584] pnp 00:07: legacy suspend
[20244.700586] pnp 00:06: legacy suspend
[20244.700587] i8042 aux 00:05: legacy suspend
[20244.700590] i8042 kbd 00:04: legacy suspend
[20244.700594] rtc_cmos 00:03: legacy suspend, may wakeup
[20244.700599] pnp 00:02: legacy suspend
[20244.700601] system 00:01: legacy suspend
[20244.700603] pnp 00:00: legacy suspend
[20244.700606] platform regulatory.0: suspend
[20244.700608] pci 0000:07:00.4: suspend
[20244.700611] jmb38x_ms 0000:07:00.3: suspend
[20244.700673] jmb38x_ms 0000:07:00.3: PCI INT A disabled
[20244.711137] pci 0000:07:00.2: suspend
[20244.711140] sdhci-pci 0000:07:00.1: suspend
[20244.711218] sdhci-pci 0000:07:00.1: PCI INT A disabled
[20244.722089] pci 0000:07:00.0: suspend
[20244.722092] iwlagn 0000:06:00.0: suspend
[20244.733151] pci 0000:02:00.0: suspend
[20244.733154] nouveau 0000:08:00.0: suspend
[20244.733157] [drm] nouveau 0000:08:00.0: Evicting buffers...
[20245.289425] [drm] nouveau 0000:08:00.0: Idling channels...
[20245.289687] [drm] nouveau 0000:08:00.0: Suspending GPU objects...
[20246.226436] [drm] nouveau 0000:08:00.0: And we're gone!
[20246.226482] nouveau 0000:08:00.0: PCI INT A disabled
[20246.237118] i801_smbus 0000:00:1f.3: suspend
[20246.237142] ahci 0000:00:1f.2: suspend
[20246.292119] pci 0000:00:1f.0: suspend
[20246.292122] pci 0000:00:1e.0: suspend
[20246.292125] ehci_hcd 0000:00:1d.7: suspend
[20246.292133] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[20246.292136] uhci_hcd 0000:00:1d.2: suspend
[20246.292139] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[20246.292144] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[20246.292147] uhci_hcd 0000:00:1d.1: suspend
[20246.292149] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[20246.292155] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[20246.292157] uhci_hcd 0000:00:1d.0: suspend
[20246.292159] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[20246.292170] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[20246.292172] pcieport 0000:00:1c.5: suspend
[20246.292178] pciehp 0000:00:1c.5:pcie04: pciehp_suspend ENTRY
[20246.292181] pcieport 0000:00:1c.3: suspend
[20246.292184] pcieport 0000:00:1c.2: suspend
[20246.292188] pcieport 0000:00:1c.1: suspend
[20246.292191] pcieport 0000:00:1c.0: suspend
[20246.292195] HDA Intel 0000:00:1b.0: suspend
[20246.595172] HDA Intel 0000:00:1b.0: PCI INT A disabled
[20246.606084] ehci_hcd 0000:00:1a.7: suspend
[20246.606091] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[20246.606093] uhci_hcd 0000:00:1a.2: suspend
[20246.606096] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[20246.606101] uhci_hcd 0000:00:1a.2: PCI INT D disabled
[20246.606104] uhci_hcd 0000:00:1a.1: suspend
[20246.606106] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[20246.606112] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[20246.606114] uhci_hcd 0000:00:1a.0: suspend
[20246.606116] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[20246.606122] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[20246.606124] pcieport 0000:00:01.0: suspend
[20246.606128] pci 0000:00:00.0: suspend
[20246.606133] button LNXPWRBN:00: legacy suspend
[20246.606136] acpi LNXTHERM:00: legacy suspend
[20246.606138] pci_link PNP0C0F:07: legacy suspend
[20246.606141] pci_link PNP0C0F:06: legacy suspend
[20246.606143] pci_link PNP0C0F:05: legacy suspend
[20246.606145] pci_link PNP0C0F:04: legacy suspend
[20246.606148] pci_link PNP0C0F:03: legacy suspend
[20246.606150] pci_link PNP0C0F:02: legacy suspend
[20246.606153] pci_link PNP0C0F:01: legacy suspend
[20246.606155] pci_link PNP0C0F:00: legacy suspend
[20246.606157] button PNP0C0C:00: legacy suspend
[20246.606160] acpi PNP0C01:00: legacy suspend
[20246.606162] acpi device:33: legacy suspend
[20246.606170] acpi device:32: legacy suspend
[20246.606172] acpi device:31: legacy suspend
[20246.606173] acpi device:30: legacy suspend
[20246.606175] acpi device:2f: legacy suspend
[20246.606177] acpi device:2e: legacy suspend
[20246.606178] acpi device:2d: legacy suspend
[20246.606180] acpi device:2c: legacy suspend
[20246.606182] acpi device:2b: legacy suspend
[20246.606184] acpi device:2a: legacy suspend
[20246.606185] acpi device:29: legacy suspend
[20246.606187] acpi device:28: legacy suspend
[20246.606189] acpi device:27: legacy suspend
[20246.606190] acpi device:26: legacy suspend
[20246.606192] acpi device:25: legacy suspend
[20246.606194] acpi device:24: legacy suspend
[20246.606195] acpi device:23: legacy suspend
[20246.606197] acpi device:22: legacy suspend
[20246.606199] acpi device:21: legacy suspend
[20246.606200] acpi device:20: legacy suspend
[20246.606202] acpi device:1f: legacy suspend
[20246.606204] acpi device:1e: legacy suspend
[20246.606205] acpi device:1d: legacy suspend
[20246.606207] acpi device:1c: legacy suspend
[20246.606209] acpi device:1b: legacy suspend
[20246.606211] acpi device:1a: legacy suspend
[20246.606213] acpi device:19: legacy suspend
[20246.606214] acpi device:18: legacy suspend
[20246.606216] acpi device:17: legacy suspend
[20246.606218] acpi device:16: legacy suspend
[20246.606219] acpi device:15: legacy suspend
[20246.606221] acpi device:14: legacy suspend
[20246.606223] acpi device:13: legacy suspend
[20246.606224] acpi device:12: legacy suspend
[20246.606226] acpi device:11: legacy suspend
[20246.606228] acpi device:10: legacy suspend
[20246.606230] acpi device:0f: legacy suspend
[20246.606231] acpi device:0e: legacy suspend
[20246.606233] acpi device:0d: legacy suspend
[20246.606235] acpi device:0c: legacy suspend
[20246.606236] acpi device:0b: legacy suspend
[20246.606238] acpi device:0a: legacy suspend
[20246.606240] acpi device:09: legacy suspend
[20246.606242] acpi device:08: legacy suspend
[20246.606243] acpi device:07: legacy suspend
[20246.606245] acpi PNP0C02:04: legacy suspend
[20246.606247] acpi ENE0100:00: legacy suspend
[20246.606248] acpi pnp0c14:01: legacy suspend
[20246.606250] button PNP0C0D:00: legacy suspend
[20246.606252] battery PNP0C0A:00: legacy suspend
[20246.606254] ac ACPI0003:00: legacy suspend
[20246.606256] ec PNP0C09:00: legacy suspend
[20246.606261] acpi PNP0C02:03: legacy suspend
[20246.606263] acpi PNP0C02:02: legacy suspend
[20246.606265] acpi INT0800:00: legacy suspend
[20246.606267] acpi PNP0103:00: legacy suspend
[20246.606268] acpi PNP0C02:01: legacy suspend
[20246.606270] acpi PNP0C04:00: legacy suspend
[20246.606272] acpi PNP0800:00: legacy suspend
[20246.606273] acpi PNP0F03:00: legacy suspend
[20246.606275] acpi PNP0303:00: legacy suspend
[20246.606277] acpi PNP0B00:00: legacy suspend
[20246.606278] acpi PNP0100:00: legacy suspend
[20246.606280] acpi PNP0200:00: legacy suspend
[20246.606282] acpi PNP0000:00: legacy suspend
[20246.606283] acpi device:06: legacy suspend
[20246.606285] acpi device:05: legacy suspend
[20246.606287] acpi pnp0c14:00: legacy suspend
[20246.606288] acpi device:04: legacy suspend
[20246.606290] acpi device:03: legacy suspend
[20246.606292] acpi device:02: legacy suspend
[20246.606293] acpi device:01: legacy suspend
[20246.606295] video LNXVIDEO:00: legacy suspend
[20246.606297] acpi device:00: legacy suspend
[20246.606299] acpi PNP0C02:00: legacy suspend
[20246.606301] pci_root PNP0A08:00: legacy suspend
[20246.606303] acpi LNXSYBUS:00: legacy suspend
[20246.606305] processor LNXCPU:03: legacy suspend
[20246.606308] processor LNXCPU:02: legacy suspend
[20246.606310] processor LNXCPU:01: legacy suspend
[20246.606312] processor LNXCPU:00: legacy suspend
[20246.606313] acpi LNXSYSTM:00: legacy suspend
[20246.606318] PM: suspend of devices complete after 3528.792 msecs
[20246.606374] coretemp coretemp.1: LATE suspend
[20246.606376] coretemp coretemp.0: LATE suspend
[20246.606378] i2c i2c-3: LATE suspend
[20246.606381] psmouse serio1: LATE suspend
[20246.606382] atkbd serio0: LATE suspend
[20246.606384] i8042 i8042: LATE suspend
[20246.606405] serial8250 serial8250: LATE suspend
[20246.606407] i2c i2c-2: LATE suspend
[20246.606409] i2c i2c-1: LATE suspend
[20246.606410] i2c i2c-0: LATE suspend
[20246.606426] platform microcode: LATE suspend
[20246.606433] platform regulatory.0: LATE suspend
[20246.606435] pci 0000:07:00.4: LATE suspend
[20246.606481] jmb38x_ms 0000:07:00.3: LATE suspend
[20246.606483] pci 0000:07:00.2: LATE suspend
[20246.606529] sdhci-pci 0000:07:00.1: LATE suspend
[20246.606531] pci 0000:07:00.0: LATE suspend
[20246.606584] iwlagn 0000:06:00.0: LATE suspend
[20246.606586] pci 0000:02:00.0: LATE suspend
[20246.606637] nouveau 0000:08:00.0: LATE suspend
[20246.606639] i801_smbus 0000:00:1f.3: LATE suspend
[20246.606640] ahci 0000:00:1f.2: LATE suspend
[20246.606641] pci 0000:00:1f.0: LATE suspend
[20246.606667] pci 0000:00:1e.0: LATE suspend
[20246.606685] ehci_hcd 0000:00:1d.7: LATE suspend
[20246.606712] ehci_hcd 0000:00:1d.7: wakeup: 0
[20246.617011] ehci_hcd 0000:00:1d.7: --> PCI D3hot
[20246.617013] uhci_hcd 0000:00:1d.2: LATE suspend
[20246.617033] uhci_hcd 0000:00:1d.2: wakeup: 0
[20246.617035] uhci_hcd 0000:00:1d.2: --> PCI D0
[20246.617036] uhci_hcd 0000:00:1d.1: LATE suspend
[20246.617056] uhci_hcd 0000:00:1d.1: wakeup: 0
[20246.617058] uhci_hcd 0000:00:1d.1: --> PCI D0
[20246.617059] uhci_hcd 0000:00:1d.0: LATE suspend
[20246.617079] uhci_hcd 0000:00:1d.0: wakeup: 0
[20246.617081] uhci_hcd 0000:00:1d.0: --> PCI D0
[20246.617082] pcieport 0000:00:1c.5: LATE suspend
[20246.617084] pcieport 0000:00:1c.3: LATE suspend
[20246.617085] pcieport 0000:00:1c.2: LATE suspend
[20246.617086] pcieport 0000:00:1c.1: LATE suspend
[20246.617088] pcieport 0000:00:1c.0: LATE suspend
[20246.617089] HDA Intel 0000:00:1b.0: LATE suspend
[20246.617090] ehci_hcd 0000:00:1a.7: LATE suspend
[20246.617117] ehci_hcd 0000:00:1a.7: wakeup: 0
[20246.628011] ehci_hcd 0000:00:1a.7: --> PCI D3hot
[20246.628012] uhci_hcd 0000:00:1a.2: LATE suspend
[20246.628033] uhci_hcd 0000:00:1a.2: wakeup: 0
[20246.628034] uhci_hcd 0000:00:1a.2: --> PCI D0
[20246.628036] uhci_hcd 0000:00:1a.1: LATE suspend
[20246.628056] uhci_hcd 0000:00:1a.1: wakeup: 0
[20246.628058] uhci_hcd 0000:00:1a.1: --> PCI D0
[20246.628059] uhci_hcd 0000:00:1a.0: LATE suspend
[20246.628079] uhci_hcd 0000:00:1a.0: wakeup: 0
[20246.628081] uhci_hcd 0000:00:1a.0: --> PCI D0
[20246.628082] pcieport 0000:00:01.0: LATE suspend
[20246.628083] pci 0000:00:00.0: LATE suspend
[20246.628099] PM: late suspend of devices complete after 21.777 msecs
[20246.628677] ACPI: Preparing to enter system sleep state S3
[20246.629417] Disabling non-boot CPUs ...
[20246.642210] CPU 1 is now offline
[20246.642212] SMP alternatives: switching to UP code
[20246.648734] Task events/1 (pid = 10) is on cpu 1
         (state = 1,
flags = 84208040)
[20246.648737] Task bdi-default (pid = 313) is on cpu 1
         (state = 2,
flags = 80a15040)
[20246.648739] Task kblockd/1 (pid = 316) is on cpu 1
         (state = 1,
flags = 84208040)
[20246.648741] Task kmmcd (pid = 478) is on cpu 1
         (state = 1, flags
= 80208040)
[20246.648744] Task phy0 (pid = 914) is on cpu 1
         (state = 1, flags
= 80208040)
[20246.648746] Task jbd2/sda2-8 (pid = 1127) is on cpu 1
                 (state =
1, flags = 80208040)
[20246.648748] Task udevd (pid = 1230) is on cpu 1
         (state = 2,
flags = 416140)
[20246.648750] Task hald (pid = 1848) is on cpu 1
         (state = 2, flags
= 416140)
[20246.648752] Task syslog-ng (pid = 2153) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648754] Task syslog-ng (pid = 2154) is on cpu 1
         (state = 2,
flags = 416140)
[20246.648756] Task udevd (pid = 2212) is on cpu 1
         (state = 2,
flags = 416140)
[20246.648758] Task login (pid = 2231) is on cpu 1
         (state = 2,
flags = 416100)
[20246.648760] Task agetty (pid = 2232) is on cpu 1
         (state = 2,
flags = 416000)
[20246.648762] Task agetty (pid = 2233) is on cpu 1
         (state = 2,
flags = 416000)
[20246.648764] Task startx (pid = 4256) is on cpu 1
         (state = 2,
flags = 416000)
[20246.648766] Task X (pid = 4273) is on cpu 1
 (state = 2, flags = 416100)
[20246.648768] Task dbus-daemon (pid = 4375) is on cpu 1
                 (state =
2, flags = 416040)
[20246.648770] Task kded4 (pid = 4639) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648772] Task ksmserver (pid = 5388) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648774] Task kglobalaccel (pid = 5428) is on cpu 1
                 (state =
2, flags = 416040)
[20246.648776] Task plasma-desktop (pid = 5440) is on cpu 1
                 (state
= 2, flags = 416040)
[20246.648778] Task ksysguardd (pid = 5633) is on cpu 1
         (state = 2,
flags = 416000)
[20246.648780] Task konsole (pid = 5850) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648782] Task konsole (pid = 5856) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648784] Task kmix (pid = 5865) is on cpu 1
         (state = 2, flags
= 416040)
[20246.648786] Task kate (pid = 5867) is on cpu 1
         (state = 2, flags
= 416040)
[20246.648788] Task bash (pid = 5915) is on cpu 1
         (state = 2, flags
= 416000)
[20246.648790] Task bash (pid = 5957) is on cpu 1
         (state = 2, flags
= 416000)
[20246.648792] Task klipper (pid = 6441) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648794] Task akregator (pid = 6523) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648796] Task kwalletd (pid = 6592) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648798] Task udevd (pid = 7302) is on cpu 1
         (state = 2,
flags = 416140)
[20246.648800] Task kio_http (pid = 15386) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648802] Task kio_http (pid = 15387) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648804] Task kio_http (pid = 15388) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648806] Task kio_http (pid = 15389) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648807] Task kio_http (pid = 15390) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648809] Task kio_http (pid = 15391) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648811] Task nspluginviewer (pid = 22959) is on cpu 1
                 (state
= 2, flags = 416000)
[20246.648813] Task firefox (pid = 17573) is on cpu 1
         (state = 2,
flags = 416000)
[20246.648815] Task run-mozilla.sh (pid = 17576) is on cpu 1
                 (state
= 2, flags = 416000)
[20246.648817] Task firefox-bin (pid = 17580) is on cpu 1
                 (state =
2, flags = 416000)
[20246.648819] Task kopete (pid = 14334) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648821] Task kio_http (pid = 26714) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648823] Task kio_http (pid = 26715) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648825] Task kio_http (pid = 26718) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648827] Task kio_http (pid = 29973) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648829] Task kio_http (pid = 29974) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648831] Task kio_file (pid = 31487) is on cpu 1
         (state = 2,
flags = 416040)
[20246.648833] Task sleep (pid = 3013) is on cpu 1
         (state = 2,
flags = 416000)
[20246.648835] Task hibernate-ram (pid = 3286) is on cpu 1
                 (state =
2, flags = 416000)
[20246.648837] Task hibernate-ram (pid = 3392) is on cpu 1
                 (state =
2, flags = 416040)
[20246.648839] Task tee (pid = 3393) is on cpu 1
         (state = 2, flags = 416000)
[20246.648991] Back to C!
[20246.649057] Enabling non-boot CPUs ...
[20246.649207] SMP alternatives: switching to SMP code
[20246.655185] Booting Node 0 Processor 1 APIC 0x1
[20246.733223] CPU1 is up
[20246.733690] ACPI: Waking up from system sleep state S3
[20246.734143] pci 0000:00:00.0: EARLY resume
[20246.734161] pcieport 0000:00:01.0: EARLY resume
[20246.734174] pcieport 0000:00:01.0: restoring config space at offset
0xa (was 0xf, writing 0x0)
[20246.734179] pcieport 0000:00:01.0: restoring config space at offset
0x6 (was 0x80000, writing 0x80800)
[20246.734183] pcieport 0000:00:01.0: restoring config space at offset
0x1 (was 0x100107, writing 0x100507)
[20246.734197] uhci_hcd 0000:00:1a.0: EARLY resume
[20246.734217] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[20246.734225] uhci_hcd 0000:00:1a.1: EARLY resume
[20246.734245] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[20246.734255] uhci_hcd 0000:00:1a.2: EARLY resume
[20246.734275] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[20246.734283] ehci_hcd 0000:00:1a.7: EARLY resume
[20246.734310] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900006, writing 0x2900002)
[20246.734323] HDA Intel 0000:00:1b.0: EARLY resume
[20246.734345] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x3 (was 0x0, writing 0x8)
[20246.734349] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100006, writing 0x100002)
[20246.734360] pcieport 0000:00:1c.0: EARLY resume
[20246.734375] pcieport 0000:00:1c.0: restoring config space at offset
0xf (was 0x20100, writing 0x20105)
[20246.734383] pcieport 0000:00:1c.0: restoring config space at offset
0x9 (was 0x1fff1, writing 0xc011c001)
[20246.734391] pcieport 0000:00:1c.0: restoring config space at offset
0x3 (was 0x810000, writing 0x810008)
[20246.734396] pcieport 0000:00:1c.0: restoring config space at offset
0x1 (was 0x180107, writing 0x100507)
[20246.734416] pcieport 0000:00:1c.1: EARLY resume
[20246.734427] pcieport 0000:00:1c.1: restoring config space at offset
0xf (was 0x20200, writing 0x2020a)
[20246.734436] pcieport 0000:00:1c.1: restoring config space at offset
0x7 (was 0x2000d0d0, writing 0xd0d0)
[20246.734442] pcieport 0000:00:1c.1: restoring config space at offset
0x3 (was 0x810000, writing 0x810008)
[20246.734447] pcieport 0000:00:1c.1: restoring config space at offset
0x1 (was 0x100107, writing 0x100507)
[20246.734467] pcieport 0000:00:1c.2: EARLY resume
[20246.734477] pcieport 0000:00:1c.2: restoring config space at offset
0xf (was 0x20300, writing 0x2030b)
[20246.734485] pcieport 0000:00:1c.2: restoring config space at offset
0x9 (was 0x1fff1, writing 0xc051c041)
[20246.734489] pcieport 0000:00:1c.2: restoring config space at offset
0x8 (was 0xfff0, writing 0xc030c020)
[20246.734493] pcieport 0000:00:1c.2: restoring config space at offset
0x7 (was 0x200000f0, writing 0x1010)
[20246.734499] pcieport 0000:00:1c.2: restoring config space at offset
0x3 (was 0x810000, writing 0x810008)
[20246.734503] pcieport 0000:00:1c.2: restoring config space at offset
0x1 (was 0x100104, writing 0x100507)
[20246.734524] pcieport 0000:00:1c.3: EARLY resume
[20246.734534] pcieport 0000:00:1c.3: restoring config space at offset
0xf (was 0x20400, writing 0x2040f)
[20246.734542] pcieport 0000:00:1c.3: restoring config space at offset
0x9 (was 0x1fff1, writing 0xc071c061)
[20246.734546] pcieport 0000:00:1c.3: restoring config space at offset
0x7 (was 0xf0, writing 0x2020)
[20246.734553] pcieport 0000:00:1c.3: restoring config space at offset
0x3 (was 0x810000, writing 0x810008)
[20246.734557] pcieport 0000:00:1c.3: restoring config space at offset
0x1 (was 0x100106, writing 0x100507)
[20246.734577] pcieport 0000:00:1c.5: EARLY resume
[20246.734588] pcieport 0000:00:1c.5: restoring config space at offset
0xf (was 0x20200, writing 0x2020a)
[20246.734596] pcieport 0000:00:1c.5: restoring config space at offset
0x9 (was 0x1fff1, writing 0xc091c081)
[20246.734600] pcieport 0000:00:1c.5: restoring config space at offset
0x7 (was 0x200000f0, writing 0x3030)
[20246.734606] pcieport 0000:00:1c.5: restoring config space at offset
0x3 (was 0x810000, writing 0x810008)
[20246.734611] pcieport 0000:00:1c.5: restoring config space at offset
0x1 (was 0x100106, writing 0x100507)
[20246.734631] uhci_hcd 0000:00:1d.0: EARLY resume
[20246.734651] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[20246.734659] uhci_hcd 0000:00:1d.1: EARLY resume
[20246.734680] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[20246.734687] uhci_hcd 0000:00:1d.2: EARLY resume
[20246.734707] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[20246.734715] ehci_hcd 0000:00:1d.7: EARLY resume
[20246.734742] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900006, writing 0x2900002)
[20246.734755] pci 0000:00:1e.0: EARLY resume
[20246.734761] pci 0000:00:1e.0: restoring config space at offset 0xf
(was 0x20000, writing 0x200ff)
[20246.734780] pci 0000:00:1f.0: EARLY resume
[20246.734812] ahci 0000:00:1f.2: EARLY resume
[20246.734835] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[20246.734855] i801_smbus 0000:00:1f.3: EARLY resume
[20246.734873] nouveau 0000:08:00.0: EARLY resume
[20246.734888] nouveau 0000:08:00.0: restoring config space at offset
0x9 (was 0x1, writing 0xec01)
[20246.734893] nouveau 0000:08:00.0: restoring config space at offset
0x7 (was 0x4, writing 0xfa000004)
[20246.734897] nouveau 0000:08:00.0: restoring config space at offset
0x5 (was 0xc, writing 0xd000000c)
[20246.734900] nouveau 0000:08:00.0: restoring config space at offset
0x4 (was 0x0, writing 0xfd000000)
[20246.734903] nouveau 0000:08:00.0: restoring config space at offset
0x3 (was 0x0, writing 0x8)
[20246.734925] pci 0000:02:00.0: EARLY resume
[20246.734949] pci 0000:02:00.0: restoring config space at offset 0xf
(was 0x100, writing 0x10a)
[20246.734957] pci 0000:02:00.0: restoring config space at offset 0xc
(was 0x0, writing 0xf8fe0000)
[20246.734970] pci 0000:02:00.0: restoring config space at offset 0x6
(was 0x4, writing 0xf8fff004)
[20246.734976] pci 0000:02:00.0: restoring config space at offset 0x4
(was 0x1, writing 0xc801)
[20246.734981] pci 0000:02:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x8)
[20246.734988] pci 0000:02:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100003)
[20246.735020] iwlagn 0000:06:00.0: EARLY resume
[20246.735048] iwlagn 0000:06:00.0: restoring config space at offset
0xf (was 0x100, writing 0x10f)
[20246.735075] iwlagn 0000:06:00.0: restoring config space at offset
0x4 (was 0x4, writing 0xf9efe004)
[20246.735081] iwlagn 0000:06:00.0: restoring config space at offset
0x3 (was 0x0, writing 0x8)
[20246.735090] iwlagn 0000:06:00.0: restoring config space at offset
0x1 (was 0x100000, writing 0x100006)
[20246.735137] pci 0000:07:00.0: EARLY resume
[20246.735158] pci 0000:07:00.0: restoring config space at offset 0xf
(was 0x109, writing 0x105)
[20246.735174] pci 0000:07:00.0: restoring config space at offset 0x9
(was 0x0, writing 0xf9ffec00)
[20246.735180] pci 0000:07:00.0: restoring config space at offset 0x8
(was 0x0, writing 0xf9fff000)
[20246.735194] pci 0000:07:00.0: restoring config space at offset 0x3
(was 0x800000, writing 0x800008)
[20246.735202] pci 0000:07:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[20246.735222] sdhci-pci 0000:07:00.1: EARLY resume
[20246.735241] sdhci-pci 0000:07:00.1: restoring config space at
offset 0xf (was 0x1ff, writing 0x105)
[20246.735265] sdhci-pci 0000:07:00.1: restoring config space at
offset 0x4 (was 0x0, writing 0xf9ffe800)
[20246.735270] sdhci-pci 0000:07:00.1: restoring config space at
offset 0x3 (was 0x800000, writing 0x800008)
[20246.735277] sdhci-pci 0000:07:00.1: restoring config space at
offset 0x1 (was 0x100000, writing 0x100007)
[20246.735296] pci 0000:07:00.2: EARLY resume
[20246.735314] pci 0000:07:00.2: restoring config space at offset 0xf
(was 0x1ff, writing 0x105)
[20246.735336] pci 0000:07:00.2: restoring config space at offset 0x4
(was 0x0, writing 0xf9ffe400)
[20246.735341] pci 0000:07:00.2: restoring config space at offset 0x3
(was 0x800000, writing 0x800008)
[20246.735348] pci 0000:07:00.2: restoring config space at offset 0x1
(was 0x100000, writing 0x100003)
[20246.735367] jmb38x_ms 0000:07:00.3: EARLY resume
[20246.735385] jmb38x_ms 0000:07:00.3: restoring config space at
offset 0xf (was 0x1ff, writing 0x105)
[20246.735407] jmb38x_ms 0000:07:00.3: restoring config space at
offset 0x4 (was 0x0, writing 0xf9ffe000)
[20246.735412] jmb38x_ms 0000:07:00.3: restoring config space at
offset 0x3 (was 0x800000, writing 0x800008)
[20246.735419] jmb38x_ms 0000:07:00.3: restoring config space at
offset 0x1 (was 0x100000, writing 0x100007)
[20246.735438] pci 0000:07:00.4: EARLY resume
[20246.735456] pci 0000:07:00.4: restoring config space at offset 0xf
(was 0x1ff, writing 0x105)
[20246.735478] pci 0000:07:00.4: restoring config space at offset 0x4
(was 0x0, writing 0xf9ffdc00)
[20246.735483] pci 0000:07:00.4: restoring config space at offset 0x3
(was 0x800000, writing 0x800008)
[20246.735490] pci 0000:07:00.4: restoring config space at offset 0x1
(was 0x100000, writing 0x100007)
[20246.735509] platform regulatory.0: EARLY resume
[20246.735513] platform microcode: EARLY resume
[20246.735523] i2c i2c-0: EARLY resume
[20246.735525] i2c i2c-1: EARLY resume
[20246.735526] i2c i2c-2: EARLY resume
[20246.735528] serial8250 serial8250: EARLY resume
[20246.735542] i8042 i8042: EARLY resume
[20246.735544] atkbd serio0: EARLY resume
[20246.735545] psmouse serio1: EARLY resume
[20246.735547] i2c i2c-3: EARLY resume
[20246.735549] coretemp coretemp.0: EARLY resume
[20246.735550] coretemp coretemp.1: EARLY resume
[20246.735562] PM: early resume of devices complete after 1.432 msecs
[20246.735589] acpi LNXSYSTM:00: legacy resume
[20246.735591] processor LNXCPU:00: legacy resume
[20246.735598] processor LNXCPU:01: legacy resume
[20246.735600] processor LNXCPU:02: legacy resume
[20246.735601] processor LNXCPU:03: legacy resume
[20246.735603] acpi LNXSYBUS:00: legacy resume
[20246.735604] pci_root PNP0A08:00: legacy resume
[20246.735606] acpi PNP0C02:00: legacy resume
[20246.735608] acpi device:00: legacy resume
[20246.735609] video LNXVIDEO:00: legacy resume
[20246.742374] acpi device:01: legacy resume
[20246.742376] acpi device:02: legacy resume
[20246.742377] acpi device:03: legacy resume
[20246.742379] acpi device:04: legacy resume
[20246.742380] acpi pnp0c14:00: legacy resume
[20246.742382] acpi device:05: legacy resume
[20246.742384] acpi device:06: legacy resume
[20246.742385] acpi PNP0000:00: legacy resume
[20246.742387] acpi PNP0200:00: legacy resume
[20246.742388] acpi PNP0100:00: legacy resume
[20246.742390] acpi PNP0B00:00: legacy resume
[20246.742392] acpi PNP0303:00: legacy resume
[20246.742393] acpi PNP0F03:00: legacy resume
[20246.742395] acpi PNP0800:00: legacy resume
[20246.742397] acpi PNP0C04:00: legacy resume
[20246.742398] acpi PNP0C02:01: legacy resume
[20246.742400] acpi PNP0103:00: legacy resume
[20246.742401] acpi INT0800:00: legacy resume
[20246.742403] acpi PNP0C02:02: legacy resume
[20246.742405] acpi PNP0C02:03: legacy resume
[20246.742406] ec PNP0C09:00: legacy resume
[20246.742411] ac ACPI0003:00: legacy resume
[20246.746344] battery PNP0C0A:00: legacy resume
[20246.909159] button PNP0C0D:00: legacy resume
[20246.913079] acpi pnp0c14:01: legacy resume
[20246.913081] acpi ENE0100:00: legacy resume
[20246.913082] acpi PNP0C02:04: legacy resume
[20246.913084] acpi device:07: legacy resume
[20246.913085] acpi device:08: legacy resume
[20246.913087] acpi device:09: legacy resume
[20246.913088] acpi device:0a: legacy resume
[20246.913090] acpi device:0b: legacy resume
[20246.913092] acpi device:0c: legacy resume
[20246.913093] acpi device:0d: legacy resume
[20246.913095] acpi device:0e: legacy resume
[20246.913097] acpi device:0f: legacy resume
[20246.913098] acpi device:10: legacy resume
[20246.913100] acpi device:11: legacy resume
[20246.913102] acpi device:12: legacy resume
[20246.913103] acpi device:13: legacy resume
[20246.913105] acpi device:14: legacy resume
[20246.913106] acpi device:15: legacy resume
[20246.913108] acpi device:16: legacy resume
[20246.913110] acpi device:17: legacy resume
[20246.913111] acpi device:18: legacy resume
[20246.913113] acpi device:19: legacy resume
[20246.913114] acpi device:1a: legacy resume
[20246.913116] acpi device:1b: legacy resume
[20246.913118] acpi device:1c: legacy resume
[20246.913119] acpi device:1d: legacy resume
[20246.913121] acpi device:1e: legacy resume
[20246.913122] acpi device:1f: legacy resume
[20246.913124] acpi device:20: legacy resume
[20246.913126] acpi device:21: legacy resume
[20246.913127] acpi device:22: legacy resume
[20246.913129] acpi device:23: legacy resume
[20246.913130] acpi device:24: legacy resume
[20246.913132] acpi device:25: legacy resume
[20246.913133] acpi device:26: legacy resume
[20246.913135] acpi device:27: legacy resume
[20246.913137] acpi device:28: legacy resume
[20246.913138] acpi device:29: legacy resume
[20246.913140] acpi device:2a: legacy resume
[20246.913141] acpi device:2b: legacy resume
[20246.913143] acpi device:2c: legacy resume
[20246.913145] acpi device:2d: legacy resume
[20246.913146] acpi device:2e: legacy resume
[20246.913148] acpi device:2f: legacy resume
[20246.913149] acpi device:30: legacy resume
[20246.913151] acpi device:31: legacy resume
[20246.913152] acpi device:32: legacy resume
[20246.913154] acpi device:33: legacy resume
[20246.913156] acpi PNP0C01:00: legacy resume
[20246.913157] button PNP0C0C:00: legacy resume
[20246.913159] pci_link PNP0C0F:00: legacy resume
[20246.913161] pci_link PNP0C0F:01: legacy resume
[20246.913162] pci_link PNP0C0F:02: legacy resume
[20246.913164] pci_link PNP0C0F:03: legacy resume
[20246.913166] pci_link PNP0C0F:04: legacy resume
[20246.913167] pci_link PNP0C0F:05: legacy resume
[20246.913169] pci_link PNP0C0F:06: legacy resume
[20246.913171] pci_link PNP0C0F:07: legacy resume
[20246.913172] acpi LNXTHERM:00: legacy resume
[20246.913174] button LNXPWRBN:00: legacy resume
[20246.913176] pci 0000:00:00.0: resume
[20246.913179] pcieport 0000:00:01.0: resume
[20246.913182] uhci_hcd 0000:00:1a.0: resume
[20246.913189] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[20246.913194] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[20246.913197] uhci_hcd 0000:00:1a.0: uhci_pci_resume
[20246.913200] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x2f00
[20246.913201] uhci_hcd 0000:00:1a.0: Performing full reset
[20246.913217] usb usb3: root hub lost power or was reset
[20246.913219] usb usb3: suspend_rh
[20246.913231] uhci_hcd 0000:00:1a.1: resume
[20246.913235] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[20246.913239] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[20246.913242] uhci_hcd 0000:00:1a.1: uhci_pci_resume
[20246.913244] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x2000
[20246.913245] uhci_hcd 0000:00:1a.1: Performing full reset
[20246.913261] usb usb4: root hub lost power or was reset
[20246.913262] usb usb4: suspend_rh
[20246.913276] uhci_hcd 0000:00:1a.2: resume
[20246.913279] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[20246.913283] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[20246.913286] uhci_hcd 0000:00:1a.2: uhci_pci_resume
[20246.913289] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x2000
[20246.913291] uhci_hcd 0000:00:1a.2: Performing full reset
[20246.913307] usb usb5: root hub lost power or was reset
[20246.913309] usb usb5: suspend_rh
[20246.913321] ehci_hcd 0000:00:1a.7: resume
[20246.913324] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[20246.913329] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[20246.913334] HDA Intel 0000:00:1b.0: resume
[20246.913337] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[20246.913342] HDA Intel 0000:00:1b.0: setting latency timer to 64
[20246.913368] HDA Intel 0000:00:1b.0: irq 32 for MSI/MSI-X
[20246.991155] pcieport 0000:00:1c.0: resume
[20246.991159] pcieport 0000:00:1c.1: resume
[20246.991162] pcieport 0000:00:1c.2: resume
[20246.991171] pcieport 0000:00:1c.3: resume
[20246.991173] pcieport 0000:00:1c.5: resume
[20246.991179] pciehp 0000:00:1c.5:pcie04: pciehp_resume ENTRY
[20246.991181] uhci_hcd 0000:00:1d.0: resume
[20246.991185] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[20246.991189] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[20246.991192] uhci_hcd 0000:00:1d.0: uhci_pci_resume
[20246.991195] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2f00
[20246.991196] uhci_hcd 0000:00:1d.0: Performing full reset
[20246.991214] usb usb6: root hub lost power or was reset
[20246.991216] usb usb6: suspend_rh
[20246.991230] uhci_hcd 0000:00:1d.1: resume
[20246.991234] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[20246.991238] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[20246.991241] uhci_hcd 0000:00:1d.1: uhci_pci_resume
[20246.991243] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[20246.991244] uhci_hcd 0000:00:1d.1: Performing full reset
[20246.991261] usb usb7: root hub lost power or was reset
[20246.991263] usb usb7: suspend_rh
[20246.991285] uhci_hcd 0000:00:1d.2: resume
[20246.991288] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[20246.991293] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[20246.991295] uhci_hcd 0000:00:1d.2: uhci_pci_resume
[20246.991297] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[20246.991299] uhci_hcd 0000:00:1d.2: Performing full reset
[20246.991317] usb usb8: root hub lost power or was reset
[20246.991318] usb usb8: suspend_rh
[20246.991333] ehci_hcd 0000:00:1d.7: resume
[20246.991336] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[20246.991341] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[20246.991346] pci 0000:00:1e.0: resume
[20246.991350] pci 0000:00:1e.0: setting latency timer to 64
[20246.991353] pci 0000:00:1f.0: resume
[20246.991354] ahci 0000:00:1f.2: resume
[20246.991361] ahci 0000:00:1f.2: setting latency timer to 64
[20246.991445] i801_smbus 0000:00:1f.3: resume
[20246.991449] nouveau 0000:08:00.0: resume
[20246.991451] [drm] nouveau 0000:08:00.0: We're back, enabling device...
[20246.991455] nouveau 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[20246.991458] nouveau 0000:08:00.0: setting latency timer to 64
[20246.991460] [drm] nouveau 0000:08:00.0: POSTing device...
[20246.991465] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 0
at offset 0xD51F
[20247.020209] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 1
at offset 0xD910
[20247.086084] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 2
at offset 0xE8D9
[20247.086123] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 3
at offset 0xEA22
[20247.089156] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table 4
at offset 0xEC8A
[20247.089158] [drm] nouveau 0000:08:00.0: Parsing VBIOS init table at
offset 0xECEF
[20247.110086] [drm] nouveau 0000:08:00.0: 0xB9B8: parsing output script 0
[20247.110090] [drm] nouveau 0000:08:00.0: 0xBD90: parsing output script 0
[20247.110136] [drm] nouveau 0000:08:00.0: Reinitialising engines...
[20247.112459] [drm] nouveau 0000:08:00.0: Restoring GPU objects...
[20247.143059] [drm] nouveau 0000:08:00.0: Restoring mode...
[20247.150207] [drm] LVDS-7: set mode 1680x1050 1d
[20247.150254] pci 0000:02:00.0: resume
[20247.150259] iwlagn 0000:06:00.0: resume
[20247.150266] pci 0000:07:00.0: resume
[20247.150279] iwlagn 0000:06:00.0: RF_KILL bit toggled to disable radio.
[20247.150315] sdhci-pci 0000:07:00.1: resume
[20247.150323] sdhci-pci 0000:07:00.1: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[20247.150335] sdhci-pci 0000:07:00.1: setting latency timer to 64
[20247.150349] pci 0000:07:00.2: resume
[20247.150351] jmb38x_ms 0000:07:00.3: resume
[20247.150355] jmb38x_ms 0000:07:00.3: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[20247.150360] jmb38x_ms 0000:07:00.3: setting latency timer to 64
[20247.150368] pci 0000:07:00.4: resume
[20247.150372] platform regulatory.0: resume
[20247.150376] pnp 00:00: legacy resume
[20247.150378] system 00:01: legacy resume
[20247.150381] pnp 00:02: legacy resume
[20247.150383] rtc_cmos 00:03: legacy resume
[20247.150386] i8042 kbd 00:04: legacy resume
[20247.150389] i8042 aux 00:05: legacy resume
[20247.150391] pnp 00:06: legacy resume
[20247.150393] pnp 00:07: legacy resume
[20247.150394] system 00:08: legacy resume
[20247.150397] pnp 00:09: legacy resume
[20247.150398] pnp 00:0a: legacy resume
[20247.150400] system 00:0b: legacy resume
[20247.150402] system 00:0c: legacy resume
[20247.150404] pnp 00:0d: legacy resume
[20247.150406] system 00:0e: legacy resume
[20247.150408] system 00:0f: legacy resume
[20247.150416] platform microcode: resume
[20247.150429] input input0: type resume
[20247.150431] input input1: type resume
[20247.150433] input input2: type resume
[20247.150435] backlight acpi_video0: legacy class resume
[20247.150438] input input3: type resume
[20247.150468] drm ttm: legacy class resume
[20247.150470] drm controlD64: legacy class resume
[20247.150472] drm card0: legacy class resume
[20247.150474] drm card0-LVDS-1: legacy class resume
[20247.150476] i2c i2c-0: resume
[20247.150478] drm card0-DVI-D-1: legacy class resume
[20247.150479] drm card0-VGA-1: legacy class resume
[20247.150481] i2c i2c-1: resume
[20247.150483] i2c i2c-2: resume
[20247.150486] serial8250 serial8250: resume
[20247.150513] scsi host0: legacy resume
[20247.150515] scsi host1: legacy resume
[20247.150517] scsi host2: legacy resume
[20247.150519] scsi host3: legacy resume
[20247.150522] scsi host4: legacy resume
[20247.150524] scsi host5: legacy resume
[20247.150527] scsi target0:0:0: legacy resume
[20247.150529] sd 0:0:0:0: legacy resume
[20247.150532] sd 0:0:0:0: [sda] Starting disk
[20247.150808] [drm] nouveau 0000:08:00.0: 0xB9BC: parsing output script 1
[20247.150837] [drm] nouveau 0000:08:00.0: 0xB873: parsing clock script 0
[20247.153090] wlan0: deauthenticating from 00:4f:62:01:e3:ee by local
choice (reason=3)
[20247.316090] ata2: SATA link down (SStatus 0 SControl 300)
[20247.318088] ata6: SATA link down (SStatus 0 SControl 300)
[20247.320091] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[20247.359151] ata5.00: configured for UDMA/100
[20247.405412] [drm] nouveau 0000:08:00.0: 0xB9B3: parsing clock script 1
[20249.099089] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[20249.172100] ata1.00: configured for UDMA/100
[20249.186076] ieee80211 phy0: legacy class resume
[20249.186083] rfkill rfkill0: legacy class resume
[20249.186098] usb usb1: type resume
[20249.186101] usb usb1: usb resume
[20249.186105] ehci_hcd 0000:00:1a.7: resume root hub
[20249.206084] hub 1-0:1.0: hub_resume
[20249.206111] usb usb2: type resume
[20249.206113] usb usb2: usb resume
[20249.206116] ehci_hcd 0000:00:1d.7: resume root hub
[20249.247083] hub 2-0:1.0: hub_resume
[20249.247102] usb usb3: type resume
[20249.247107] usb usb4: type resume
[20249.247112] usb usb5: type resume
[20249.247116] usb usb6: type resume
[20249.247121] usb usb7: type resume
[20249.247123] usb usb7: usb resume
[20249.247126] usb usb7: wakeup_rh
[20249.279077] hub 7-0:1.0: hub_reset_resume
[20249.279080] hub 7-0:1.0: trying to enable port power on non-switchable hub
[20249.380086] uhci_hcd 0000:00:1d.1: port 2 portsc 009b,00
[20249.380089] hub 7-0:1.0: port 2: status 0101 change 0003
[20249.481087] usb usb8: type resume
[20249.481092] i8042 i8042: resume
[20249.485335] atkbd serio0: resume
[20249.485337] psmouse serio1: resume
[20249.485342] i2c i2c-3: resume
[20249.485344] coretemp coretemp.0: resume
[20249.485347] coretemp coretemp.1: resume
[20249.485349] leds mmc0::: legacy class resume
[20249.485354] input input4: type resume
[20249.485370] usb 7-2: type resume
[20249.485376] usb 7-2: finish reset-resume
[20249.536103] hub 7-0:1.0: port 2 not reset yet, waiting 50ms
[20249.638086] usb 7-2: reset full speed USB device using uhci_hcd and address 2
[20249.693102] hub 7-0:1.0: port 2 not reset yet, waiting 50ms
[20249.810082] usb 7-2: ep0 maxpacket = 32
[20249.826131] uhci_hcd 0000:00:1d.1: reserve dev 2 ep82-INT, period
1, phase 0, 23 us
[20249.826136] input input5: type resume
[20249.826143] input input6: type resume
[20249.826149] input input7: type resume
[20249.826153] scsi target4:0:0: legacy resume
[20249.826156] sr 4:0:0:0: legacy resume
[20249.826177] PM: resume of devices complete after 3090.588 msecs
[20249.826202] usb 7-2: completing type resume
[20249.826220] coretemp coretemp.1: completing resume
[20249.826222] coretemp coretemp.0: completing resume
[20249.826227] i8042 i8042: completing resume
[20249.826230] usb usb8: completing type resume
[20249.826233] usb usb7: completing type resume
[20249.826236] usb usb6: completing type resume
[20249.826239] usb usb5: completing type resume
[20249.826242] usb usb4: completing type resume
[20249.826244] usb usb3: completing type resume
[20249.826247] usb usb2: completing type resume
[20249.826252] usb usb1: completing type resume
[20249.826283] serial8250 serial8250: completing resume
[20249.826334] platform microcode: completing resume
[20249.826351] platform regulatory.0: completing resume
[20249.826355] pci 0000:07:00.4: completing resume
[20249.826357] jmb38x_ms 0000:07:00.3: completing resume
[20249.826359] pci 0000:07:00.2: completing resume
[20249.826361] sdhci-pci 0000:07:00.1: completing resume
[20249.826363] pci 0000:07:00.0: completing resume
[20249.826366] iwlagn 0000:06:00.0: completing resume
[20249.826369] pci 0000:02:00.0: completing resume
[20249.826372] nouveau 0000:08:00.0: completing resume
[20249.826374] i801_smbus 0000:00:1f.3: completing resume
[20249.826376] ahci 0000:00:1f.2: completing resume
[20249.826378] pci 0000:00:1f.0: completing resume
[20249.826380] pci 0000:00:1e.0: completing resume
[20249.826382] ehci_hcd 0000:00:1d.7: completing resume
[20249.826384] uhci_hcd 0000:00:1d.2: completing resume
[20249.826386] uhci_hcd 0000:00:1d.1: completing resume
[20249.826388] uhci_hcd 0000:00:1d.0: completing resume
[20249.826390] pcieport 0000:00:1c.5: completing resume
[20249.826392] pcieport 0000:00:1c.3: completing resume
[20249.826394] pcieport 0000:00:1c.2: completing resume
[20249.826396] pcieport 0000:00:1c.1: completing resume
[20249.826398] pcieport 0000:00:1c.0: completing resume
[20249.826400] HDA Intel 0000:00:1b.0: completing resume
[20249.826402] ehci_hcd 0000:00:1a.7: completing resume
[20249.826404] uhci_hcd 0000:00:1a.2: completing resume
[20249.826406] uhci_hcd 0000:00:1a.1: completing resume
[20249.826408] uhci_hcd 0000:00:1a.0: completing resume
[20249.826410] pcieport 0000:00:01.0: completing resume
[20249.826412] pci 0000:00:00.0: completing resume
[20249.826581] PM: Finishing wakeup.
[20249.826583] Restarting tasks ...
[20249.829289] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[20249.829300] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[20249.829305] hub 7-0:1.0: state 7 ports 2 chg 0004 evt 0000
[20249.829327] hub 7-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[20249.830537] done.
[20249.848363] [drm] nouveau 0000:08:00.0: PGRAPH_ERROR - nSource:
PROTECTION_ERROR DMA_R_PROTECTION, nStatus:
[20249.848369] [drm] nouveau 0000:08:00.0: PGRAPH_ERROR - Ch 1/2 Class
0x5039 Mthd 0x0328 Data 0x00000000:0x00000000
[20249.848371] [drm] nouveau 0000:08:00.0: magic set 1:
[20249.848375] [drm] nouveau 0000:08:00.0:      0x00408900: 0x00000034
[20249.848378] [drm] nouveau 0000:08:00.0:      0x00408904: 0x7fef7c3f
[20249.848384] [drm] nouveau 0000:08:00.0:      0x00408908: 0xf8ff5e9f
[20249.848389] [drm] nouveau 0000:08:00.0:      0x0040890c: 0x00003ff7
[20249.848393] [drm] nouveau 0000:08:00.0:      0x00408910: 0x7fbf3fee
[20249.848402] [drm] nouveau 0000:08:00.0:      0x00408e08: 0x800c37ac
[20249.848407] [drm] nouveau 0000:08:00.0:      0x00408e0c: 0x00000000
[20249.848411] [drm] nouveau 0000:08:00.0:      0x00408e10: 0x53f6d060
[20249.848416] [drm] nouveau 0000:08:00.0:      0x00408e14: 0x000000fb
[20249.848420] [drm] nouveau 0000:08:00.0:      0x00408e18: 0xc6454102
[20249.848425] [drm] nouveau 0000:08:00.0:      0x00408e1c: 0x877def72
[20249.848431] [drm] nouveau 0000:08:00.0:      0x00408e20: 0x05210f20
[20249.848435] [drm] nouveau 0000:08:00.0:      0x00408e24: 0x0d31006e
[20249.848439] [drm] nouveau 0000:08:00.0: magic set 2:
[20249.848442] [drm] nouveau 0000:08:00.0:      0x00409900: 0x0000006a
[20249.848446] [drm] nouveau 0000:08:00.0:      0x00409904: 0xd7fd4fd3
[20249.848450] [drm] nouveau 0000:08:00.0:      0x00409908: 0xefefde7e
[20249.848453] [drm] nouveau 0000:08:00.0:      0x0040990c: 0xc000fd7e
[20249.848457] [drm] nouveau 0000:08:00.0:      0x00409910: 0xd57b376d
[20249.848463] [drm] nouveau 0000:08:00.0:      0x00409e08: 0x800a2f5e
[20249.848467] [drm] nouveau 0000:08:00.0:      0x00409e0c: 0x00000000
[20249.848471] [drm] nouveau 0000:08:00.0:      0x00409e10: 0x424d8500
[20249.848474] [drm] nouveau 0000:08:00.0:      0x00409e14: 0x0000002d
[20249.848478] [drm] nouveau 0000:08:00.0:      0x00409e18: 0x851bbba2
[20249.848482] [drm] nouveau 0000:08:00.0:      0x00409e1c: 0x9cff8fd3
[20249.848485] [drm] nouveau 0000:08:00.0:      0x00409e20: 0x043c7232
[20249.848489] [drm] nouveau 0000:08:00.0:      0x00409e24: 0x0d22014c
[20250.149033] uhci_hcd 0000:00:1d.1: reserve dev 2 ep81-INT, period
1, phase 0, 17 us
[20252.701278] hub 1-0:1.0: hub_suspend
[20252.701284] usb usb1: bus auto-suspend
[20252.701286] ehci_hcd 0000:00:1a.7: suspend root hub
[20252.701308] hub 2-0:1.0: hub_suspend
[20252.701311] usb usb2: bus auto-suspend
[20252.701312] ehci_hcd 0000:00:1d.7: suspend root hub
[20263.933872] atkbd.c: Unknown key pressed (translated set 2, code
0xf6 on isa0060/serio0).
[20263.933876] atkbd.c: Use 'setkeycodes e076 <keycode>' to make it known.
[20263.938767] atkbd.c: Unknown key released (translated set 2, code
0xf6 on isa0060/serio0).
[20263.938771] atkbd.c: Use 'setkeycodes e076 <keycode>' to make it known.
[20265.053047] iwlagn 0000:06:00.0: RF_KILL bit toggled to enable radio.
[20265.057092] atkbd.c: Unknown key pressed (translated set 2, code
0xf6 on isa0060/serio0).
[20265.057095] atkbd.c: Use 'setkeycodes e076 <keycode>' to make it known.
[20265.062472] atkbd.c: Unknown key released (translated set 2, code
0xf6 on isa0060/serio0).
[20265.062476] atkbd.c: Use 'setkeycodes e076 <keycode>' to make it known.
[20266.015445] wlan0: direct probe to AP 00:4f:62:01:e3:ee (try 1)
[20266.015861] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[20266.017434] wlan0: direct probe responded
[20266.017438] wlan0: authenticate with AP 00:4f:62:01:e3:ee (try 1)
[20266.019268] wlan0: authenticated
[20266.019280] wlan0: associate with AP 00:4f:62:01:e3:ee (try 1)
[20266.021453] wlan0: RX ReassocResp from 00:4f:62:01:e3:ee (capab=0x1
status=0 aid=1)
[20266.021456] wlan0: associated
[20266.022725] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[20276.185031] wlan0: no IPv6 routers present
[20438.114103] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[20438.114106] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[20438.120730] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[20438.120732] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[20438.395532] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[20438.395535] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[20438.403253] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[20438.403255] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[20438.500948] atkbd.c: Unknown key pressed (translated set 2, code
0xf8 on isa0060/serio0).
[20438.500951] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[20438.507395] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[20438.507397] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[21187.052260] atkbd.c: Unknown key pressed (translated set 2, code
0xf7 on isa0060/serio0).
[21187.052263] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[21187.058774] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[21187.058777] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[23044.683391] EXT4-fs (sda1): mounted filesystem without journal
[23076.055742] ------------[ cut here ]------------
[23076.055747] kernel BUG at fs/ext4/inode.c:1063!
[23076.055750] invalid opcode: 0000 [#1] SMP
[23076.055752] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host4/target4:0:0/4:0:0:0/block/sr0/uevent
[23076.055754] CPU 0
[23076.055757] Pid: 1627, comm: flush-8:0 Not tainted 2.6.33-rc2 #1
MS-1651/GX620
[23076.055759] RIP: 0010:[<ffffffff81136cfb>]  [<ffffffff81136cfb>]
ext4_get_blocks+0x34b/0x350
[23076.055767] RSP: 0018:ffff880139d498c0  EFLAGS: 00010297
[23076.055768] RAX: 0000000000000011 RBX: ffff880139d49970 RCX: 0000000000000002
[23076.055770] RDX: ffff88009f761800 RSI: 0000000000000001 RDI: 00000000000000ff
[23076.055772] RBP: ffff880139d49930 R08: ffff88009f761940 R09: 0000000000000004
[23076.055774] R10: 0000000000000003 R11: 0000000000000000 R12: ffff88013a519220
[23076.055776] R13: 0000000000000040 R14: ffff88013a519208 R15: ffff88013a519180
[23076.055778] FS:  0000000000000000(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
[23076.055780] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[23076.055782] CR2: 00007f7b385500d0 CR3: 0000000080546000 CR4: 00000000000006b0
[23076.055784] DR0: 0000000000000008 DR1: 0000000000000088 DR2: 000000000000001c
[23076.055786] DR3: 000000000000001d DR6: 00000000ffff0ff0 DR7: 0000000000000400
[23076.055788] Process flush-8:0 (pid: 1627, threadinfo
ffff880139d48000, task ffff88013c6cbba0)
[23076.055790] Stack:
[23076.055791]  ffff880139d498d0 ffffea0001a953b0 ffff880139d49920
ffff88009f761800
[23076.055794] <0> 0000004000000004 0000000000000001 000000000000014c
00000eee00000003
[23076.055797] <0> ffff880139d49920 ffff880139d49bf0 ffff8800abbe17e0
000000000000014c
[23076.055800] Call Trace:
[23076.055804]  [<ffffffff81136e77>] mpage_da_map_blocks+0xa7/0x430
[23076.055809]  [<ffffffff8109566b>] ? find_get_pages_tag+0x3b/0x130
[23076.055811]  [<ffffffff811377b6>] mpage_add_bh_to_extent+0x36/0xd0
[23076.055814]  [<ffffffff810a9419>] ? __dec_zone_page_state+0x29/0x30
[23076.055817]  [<ffffffff8113797c>] __mpage_da_writepage+0x12c/0x1a0
[23076.055820]  [<ffffffff8109d5a7>] write_cache_pages+0x1d7/0x3e0
[23076.055822]  [<ffffffff81137850>] ? __mpage_da_writepage+0x0/0x1a0
[23076.055825]  [<ffffffff811374a9>] ext4_da_writepages+0x2a9/0x580
[23076.055828]  [<ffffffff8109d7fc>] do_writepages+0x1c/0x40
[23076.055831]  [<ffffffff810ee362>] writeback_single_inode+0xe2/0x3a0
[23076.055834]  [<ffffffff810ef10a>] writeback_inodes_wb+0x31a/0x4c0
[23076.055837]  [<ffffffff810ef3c2>] wb_writeback+0x112/0x1d0
[23076.055841]  [<ffffffff81088e50>] ? call_rcu_sched+0x10/0x20
[23076.055844]  [<ffffffff81088e69>] ? call_rcu+0x9/0x10
[23076.055847]  [<ffffffff810ef681>] wb_do_writeback+0x131/0x1a0
[23076.055849]  [<ffffffff810ef73b>] bdi_writeback_task+0x4b/0xd0
[23076.055852]  [<ffffffff810aa870>] ? bdi_start_fn+0x0/0xd0
[23076.055855]  [<ffffffff810aa8dc>] bdi_start_fn+0x6c/0xd0
[23076.055857]  [<ffffffff810aa870>] ? bdi_start_fn+0x0/0xd0
[23076.055860]  [<ffffffff8104fb3e>] kthread+0x8e/0xa0
[23076.055864]  [<ffffffff81003ab4>] kernel_thread_helper+0x4/0x10
[23076.055866]  [<ffffffff8104fab0>] ? kthread+0x0/0xa0
[23076.055869]  [<ffffffff81003ab0>] ? kernel_thread_helper+0x0/0x10
[23076.055870] Code: 0f 00 41 c7 87 48 03 00 00 00 00 00 00 8b 45 a8
41 89 87 44 03 00 00 4c 8b 45 98 8b 4d a0 e9 17 ff ff ff 0f 0b eb fe
0f 0b eb fe <0f> 0b eb fe 90 55 48 89 e5 48 83 ec 30 48 89 5d d8 4c 89
65 e0
[23076.055895] RIP  [<ffffffff81136cfb>] ext4_get_blocks+0x34b/0x350
[23076.055898]  RSP <ffff880139d498c0>
[23076.055901] ---[ end trace db559022af5a8e60 ]---
