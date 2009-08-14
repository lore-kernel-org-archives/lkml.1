Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbZHNTiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbZHNTiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932218AbZHNTiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:38:15 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:55961 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbZHNTiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:38:08 -0400
To: Len Brown <lenb@kernel.org>
Subject: Re: Regression in ACPI in 2.6.31-rc5
From: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Date: Fri, 14 Aug 2009 20:36:01 +0100
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hybhKKjtPmkRqve"
Message-Id: <200908142036.01784.storm@sys49152.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hybhKKjtPmkRqve
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Resending with the lists CCed.

On Thursday 13 August 2009, you wrote:
> > I had two drivers stop working in 2.6.31 that were working fine in
> > 2.6.30. They are iwlagn and sky2. If i pass acpi=off to the kernel, they
> > work as expected.
>
> the bug report for this issue is here:
> http://bugzilla.kernel.org/show_bug.cgi?id=13940
>
> is it possible to bisect which commit between 2.6.30 and 2.6.31-rc5
> caused this regression?
>
> Please attach the dmesg from the working 2.6.30
> and the acpi=off 2.6.31 to the bug report so i can compare
> them to the failing 2.6.31

All dmesgs are attached. I also checked and 2.6.31-rc1 already has the bug. 
2.6.30.4 doesn't have the bug.

I'll have to look at some documentation on how to use git bisect. If you have 
some links, please send.

Thanks

--Boundary-00=_hybhKKjtPmkRqve
Content-Type: text/x-log;
  charset="utf-8";
  name="dmesg-working-2.6.31_acpi=off.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-working-2.6.31_acpi=off.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc5-git3-10-default (geeko@buildhost) (=
gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 20=
09-08-05 22:36:33 +0200
[    0.000000] Command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z=
86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z8=
6CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317 acpi=3Doff
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  BIOS-e820: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  BIOS-e820: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0B8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0B7E00000 mask FFFE00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000b7e00000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xb6000 max_arch_pfn =3D 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usab=
le) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  modified: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  modified: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  modified: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  modified: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  modified: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  modified: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  modified: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  modified: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  modified: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  modified: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  modified: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  modified: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000b6000000
[    0.000000]  0000000000 - 00b6000000 page 2M
[    0.000000] kernel direct mapping tables up to b6000000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ a000-10000
[    0.000000] RAMDISK: 37a98000 - 37fef362
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000022fff]
[    0.000000]   bootmap [0000000000023000 -  000000000004afff] pages 28
[    0.000000] (8 early reservations) =3D=3D> bootmem [0000000000 - 0140000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001c76630]    TEXT DATA BSS =3D=3D> [000=
1000000 - 0001c76630]
[    0.000000]   #3 [0037a98000 - 0037fef362]          RAMDISK =3D=3D> [003=
7a98000 - 0037fef362]
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000=
009f400 - 0000100000]
[    0.000000]   #5 [0001c77000 - 0001c771e4]              BRK =3D=3D> [000=
1c77000 - 0001c771e4]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f6f20] f6f20
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880001e0000=
0-ffff8800055fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[10] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000b5aa1
[    0.000000]     0: 0x000b5aa7 -> 0x000b5bba
[    0.000000]     0: 0x000b5c0f -> 0x000b5d08
[    0.000000]     0: 0x000b5f0f -> 0x000b5f18
[    0.000000]     0: 0x000b5f1f -> 0x000b5f65
[    0.000000]     0: 0x000b5f9f -> 0x000b5fe1
[    0.000000]     0: 0x000b5fff -> 0x000b6000
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1006809
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 726391 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: INTEL  =20
[    0.000000] MPTABLE: Product ID: MontavinaCRB
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] I/O APIC #2 Version 32 at 0xFEC00000.
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 00000000000=
06000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000=
d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000b5aa1000 - 00000000b5a=
a7000
[    0.000000] PM: Registered nosave memory: 00000000b5bba000 - 00000000b5c=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5d08000 - 00000000b5f=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5f18000 - 00000000b5f=
1f000
[    0.000000] PM: Registered nosave memory: 00000000b5f65000 - 00000000b5f=
9f000
[    0.000000] PM: Registered nosave memory: 00000000b5fe1000 - 00000000b5f=
ff000
[    0.000000] PM: Registered nosave memory: 00000000b6000000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at b6000000 (gap: b6000000=
:4a000000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff88000564b000, static data 8=
2912 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 988787
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK32=
52GSX_Z86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK325=
2GSX_Z86CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317 acpi=3Doff
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff88000568c000 - ffff=
88000968c000
[    0.000000] software IO TLB at phys 0x568c000 - 0x968c000
[    0.000000] Memory: 3884988k/5242880k available (5578k kernel code, 1215=
644k absent, 142248k reserved, 4455k data, 1048k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.720 MHz processor.
[    0.000084] Console: colour dummy device 80x25
[    0.000086] console [tty0] enabled
[    0.004010] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5053.44 BogoMIPS (lpj=3D10106880)
[    0.011367] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI=
, All Rights Reserved
[    0.011486] Security Framework initialized
[    0.011508] AppArmor: AppArmor initialized
[    0.011810] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.013827] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.015311] Mount-cache hash table entries: 256
[    0.015476] Initializing cgroup subsys ns
[    0.015483] Initializing cgroup subsys cpuacct
[    0.015488] Initializing cgroup subsys memory
[    0.015505] Initializing cgroup subsys devices
[    0.015509] Initializing cgroup subsys freezer
[    0.015512] Initializing cgroup subsys net_cls
[    0.015541] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.015545] CPU: L2 cache: 3072K
[    0.015550] CPU 0/0x0 -> Node 0
[    0.015553] CPU: Physical Processor ID: 0
[    0.015555] CPU: Processor Core ID: 0
[    0.015560] mce: CPU supports 6 MCE banks
[    0.015569] CPU0: Thermal monitoring enabled (TM2)
[    0.015575] using mwait in idle threads.
[    0.015577] Performance Counters: Core2 events, Intel PMU driver.
[    0.015585] ... version:                 2
[    0.015588] ... bit width:               40
[    0.015590] ... generic counters:        2
[    0.015593] ... value mask:              000000ffffffffff
[    0.015596] ... max period:              000000007fffffff
[    0.015599] ... fixed-purpose counters:  3
[    0.015601] ... counter mask:            0000000700000003
[    0.017812] Setting APIC routing to flat
[    0.017888] ExtINT not setup in hardware but reported by MP table
[    0.018013]   alloc irq_desc for 16 on node 0
[    0.018015]   alloc kstat_irqs on node 0
[    0.018021]   alloc irq_desc for 17 on node 0
[    0.018022]   alloc kstat_irqs on node 0
[    0.018026]   alloc irq_desc for 18 on node 0
[    0.018027]   alloc kstat_irqs on node 0
[    0.018030]   alloc irq_desc for 19 on node 0
[    0.018031]   alloc kstat_irqs on node 0
[    0.018034]   alloc irq_desc for 21 on node 0
[    0.018036]   alloc kstat_irqs on node 0
[    0.018038]   alloc irq_desc for 22 on node 0
[    0.018039]   alloc kstat_irqs on node 0
[    0.018043]   alloc irq_desc for 23 on node 0
[    0.018044]   alloc kstat_irqs on node 0
[    0.018185] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
[    0.057882] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.164227] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5054.25 Bog=
oMIPS (lpj=3D10108515)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.253537] CPU1: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.253564] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.256028] Brought up 2 CPUs
[    0.256028] Total of 2 processors activated (10107.69 BogoMIPS).
[    0.256093] CPU0 attaching sched-domain:
[    0.256096]  domain 0: span 0-1 level MC
[    0.256098]   groups: 0 1
[    0.256103] CPU1 attaching sched-domain:
[    0.256104]  domain 0: span 0-1 level MC
[    0.256106]   groups: 1 0
[    0.256160] devtmpfs: initialized
[    0.261248] Booting paravirtualized kernel on bare hardware
[    0.261249] regulator: core version 0.5
[    0.261249] Time: 20:25:32  Date: 08/14/09
[    0.261249] NET: Registered protocol family 16
[    0.261249] PCI: Using configuration type 1 for base access
[    0.261249] bio: create slab <bio-0> at 0
[    0.261249] ACPI: Interpreter disabled.
[    0.261249] SCSI subsystem initialized
[    0.261249] libata version 3.00 loaded.
[    0.261249] usbcore: registered new interface driver usbfs
[    0.261249] usbcore: registered new interface driver hub
[    0.261249] usbcore: registered new device driver usb
[    0.261249] PCI: Probing PCI hardware
[    0.261249] PCI: Probing PCI hardware (bus 00)
[    0.261249] pci 0000:00:02.0: reg 10 64bit mmio: [0xf4000000-0xf43fffff]
[    0.261249] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.261249] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.261249] pci 0000:00:02.1: reg 10 64bit mmio: [0xf4400000-0xf44fffff]
[    0.261249] pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
[    0.261249] pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
[    0.261249] pci 0000:00:1a.2: reg 20 io port: [0x1860-0x187f]
[    0.261249] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf4a04800-0xf4a04bff]
[    0.261249] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.261249] pci 0000:00:1a.7: PME# disabled
[    0.261249] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4800000-0xf4803fff]
[    0.261249] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.261249] pci 0000:00:1b.0: PME# disabled
[    0.261249] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.261249] pci 0000:00:1c.0: PME# disabled
[    0.261249] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.261249] pci 0000:00:1c.4: PME# disabled
[    0.261249] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.261249] pci 0000:00:1c.5: PME# disabled
[    0.261249] pci 0000:00:1d.0: reg 20 io port: [0x1880-0x189f]
[    0.261249] pci 0000:00:1d.1: reg 20 io port: [0x18a0-0x18bf]
[    0.261252] pci 0000:00:1d.2: reg 20 io port: [0x18c0-0x18df]
[    0.261343] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4a04c00-0xf4a04fff]
[    0.261408] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.261415] pci 0000:00:1d.7: PME# disabled
[    0.261656] pci 0000:00:1f.2: reg 10 io port: [0x1818-0x181f]
[    0.261663] pci 0000:00:1f.2: reg 14 io port: [0x180c-0x180f]
[    0.261669] pci 0000:00:1f.2: reg 18 io port: [0x1810-0x1817]
[    0.261677] pci 0000:00:1f.2: reg 1c io port: [0x1808-0x180b]
[    0.261683] pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
[    0.261690] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf4a04000-0xf4a047ff]
[    0.261735] pci 0000:00:1f.2: PME# supported from D3hot
[    0.261741] pci 0000:00:1f.2: PME# disabled
[    0.261780] pci 0000:00:1f.3: reg 10 64bit mmio: [0x000000-0x0000ff]
[    0.261797] pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
[    0.261878] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.261882] pci 0000:00:1c.0: bridge 32bit mmio: [0xf2000000-0xf3ffffff]
[    0.261890] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf0000000-0xf1ff=
ffff]
[    0.261960] pci 0000:07:00.0: reg 10 64bit mmio: [0xf4500000-0xf4503fff]
[    0.261970] pci 0000:07:00.0: reg 18 io port: [0x3000-0x30ff]
[    0.262049] pci 0000:07:00.0: supports D1 D2
[    0.262051] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.262058] pci 0000:07:00.0: PME# disabled
[    0.272117] pci 0000:00:1c.4: bridge io port: [0x3000-0x3fff]
[    0.272122] pci 0000:00:1c.4: bridge 32bit mmio: [0xf4500000-0xf45fffff]
[    0.272212] pci 0000:08:00.0: reg 10 64bit mmio: [0xf4600000-0xf4601fff]
[    0.272321] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.272330] pci 0000:08:00.0: PME# disabled
[    0.280128] pci 0000:00:1c.5: bridge 32bit mmio: [0xf4600000-0xf46fffff]
[    0.280176] pci 0000:0a:01.0: reg 10 32bit mmio: [0xff501000-0xff501fff]
[    0.280184] pci 0000:0a:01.0: reg 14 32bit mmio: [0xf4700000-0xf47007ff]
[    0.280235] pci 0000:0a:01.0: supports D1 D2
[    0.280236] pci 0000:0a:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.280243] pci 0000:0a:01.0: PME# disabled
[    0.280290] pci 0000:0a:01.2: reg 10 32bit mmio: [0xf4700800-0xf47008ff]
[    0.280355] pci 0000:0a:01.2: supports D1 D2
[    0.280356] pci 0000:0a:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.280362] pci 0000:0a:01.2: PME# disabled
[    0.280410] pci 0000:0a:01.3: reg 10 32bit mmio: [0xf4702000-0xf4702fff]
[    0.280474] pci 0000:0a:01.3: supports D1 D2
[    0.280476] pci 0000:0a:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.280482] pci 0000:0a:01.3: PME# disabled
[    0.280548] pci 0000:00:1e.0: transparent bridge
[    0.280557] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4700000-0xf47fffff]
[    0.289085] AppArmor: AppArmor Filesystem Enabled
[    0.289090] pnp: PnP ACPI: disabled
[    0.290854] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.290854] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.290854] pci 0000:00:1c.0:   MEM window: 0xf2000000-0xf3ffffff
[    0.290854] pci 0000:00:1c.0:   PREFETCH window: 0x000000f0000000-0x0000=
00f1ffffff
[    0.290854] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
[    0.290854] pci 0000:00:1c.4:   IO window: 0x3000-0x3fff
[    0.290854] pci 0000:00:1c.4:   MEM window: 0xf4500000-0xf45fffff
[    0.290854] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.290854] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
[    0.290854] pci 0000:00:1c.5:   IO window: disabled
[    0.290854] pci 0000:00:1c.5:   MEM window: 0xf4600000-0xf46fffff
[    0.290854] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.290854] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0a
[    0.290854] pci 0000:00:1e.0:   IO window: disabled
[    0.290854] pci 0000:00:1e.0:   MEM window: 0xf4700000-0xf47fffff
[    0.290854] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.290854] pci 0000:00:1c.0: PCI->APIC IRQ transform: INT A -> IRQ 17
[    0.290854] pci 0000:00:1c.0: setting latency timer to 64
[    0.290854] pci 0000:00:1c.4: PCI->APIC IRQ transform: INT A -> IRQ 17
[    0.290854] pci 0000:00:1c.4: setting latency timer to 64
[    0.290854] pci 0000:00:1c.5: PCI->APIC IRQ transform: INT B -> IRQ 16
[    0.290854] pci 0000:00:1c.5: setting latency timer to 64
[    0.290854] pci 0000:00:1e.0: setting latency timer to 64
[    0.290854] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.290854] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.290854] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.290854] pci_bus 0000:02: resource 1 mem: [0xf2000000-0xf3ffffff]
[    0.290854] pci_bus 0000:02: resource 2 pref mem [0xf0000000-0xf1ffffff]
[    0.290854] pci_bus 0000:07: resource 0 io:  [0x3000-0x3fff]
[    0.290854] pci_bus 0000:07: resource 1 mem: [0xf4500000-0xf45fffff]
[    0.290854] pci_bus 0000:08: resource 1 mem: [0xf4600000-0xf46fffff]
[    0.290854] pci_bus 0000:0a: resource 1 mem: [0xf4700000-0xf47fffff]
[    0.290854] pci_bus 0000:0a: resource 3 io:  [0x00-0xffff]
[    0.290854] pci_bus 0000:0a: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.290854] NET: Registered protocol family 2
[    0.290854] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.290854] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.296040] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.296536] TCP: Hash tables configured (established 524288 bind 65536)
[    0.296541] TCP reno registered
[    0.296698] NET: Registered protocol family 1
[    0.296765] Unpacking initramfs...
[    0.381220] Freeing initrd memory: 5468k freed
[    0.383275] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)
[    0.383555] Scanning for low memory corruption every 60 seconds
[    0.383751] audit: initializing netlink socket (disabled)
[    0.383769] type=3D2000 audit(1250281532.380:1): initialized
[    0.390761] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.390886] VFS: Disk quotas dquot_6.5.2
[    0.390921] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.391056] msgmni has been set to 1899
[    0.391272] alg: No test for stdrng (krng)
[    0.391301] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.391307] io scheduler noop registered
[    0.391309] io scheduler anticipatory registered
[    0.391313] io scheduler deadline registered
[    0.391331] io scheduler cfq registered (default)
[    0.391399] pci 0000:00:02.0: Boot video device
[    0.413827]   alloc irq_desc for 24 on node 0
[    0.413829]   alloc kstat_irqs on node 0
[    0.413841] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.413852] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.414004]   alloc irq_desc for 25 on node 0
[    0.414006]   alloc kstat_irqs on node 0
[    0.414014] pcieport-driver 0000:00:1c.4: irq 25 for MSI/MSI-X
[    0.414025] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.414172]   alloc irq_desc for 26 on node 0
[    0.414173]   alloc kstat_irqs on node 0
[    0.414182] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.414192] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.414583] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90001080=
000, using 6144k, total 131008k
[    0.414589] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D84
[    0.414593] vesafb: scrolling: redraw
[    0.414596] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    0.414755] bootsplash 3.1.6-2004/03/31: looking for picture...
[    0.423710] bootsplash: silentjpeg size 100719 bytes
[    0.434575] bootsplash: ...found (1024x768, 38691 bytes, v3).
[    0.466387] Console: switching to colour frame buffer device 124x44
[    0.509984] fb0: VESA VGA frame buffer device
[    0.511270] Non-volatile memory driver v1.3
[    0.511368] Linux agpgart interface v0.103
[    0.511462] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.511808] Platform driver 'serial8250' needs updating - please use dev=
_pm_ops
[    0.512117] ahci 0000:00:1f.2: version 3.0
[    0.512138] ahci 0000:00:1f.2: PCI->APIC IRQ transform: INT B -> IRQ 19
[    0.512351]   alloc irq_desc for 27 on node 0
[    0.512353]   alloc kstat_irqs on node 0
[    0.512363] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    0.512441] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
33 impl SATA mode
[    0.512628] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum pa=
rt ems=20
[    0.512797] ahci 0000:00:1f.2: setting latency timer to 64
[    0.536087] scsi0 : ahci
[    0.536246] scsi1 : ahci
[    0.536348] scsi2 : ahci
[    0.536451] scsi3 : ahci
[    0.536554] scsi4 : ahci
[    0.536657] scsi5 : ahci
[    0.536746] ata1: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0410=
0 irq 27
[    0.536917] ata2: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0418=
0 irq 27
[    0.537085] ata3: DUMMY
[    0.537142] ata4: DUMMY
[    0.537200] ata5: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0430=
0 irq 27
[    0.539097] ata6: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0438=
0 irq 27
[    0.541075] Fixed MDIO Bus: probed
[    0.543020] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.545193] ehci_hcd 0000:00:1a.7: PCI->APIC IRQ transform: INT C -> IRQ=
 19
[    0.547438] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.547441] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.549745] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    0.556057] ehci_hcd 0000:00:1a.7: debug port 1
[    0.558482] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.558497] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf4a04800
[    0.576050] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.578626] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.581333] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.584135] usb usb1: Product: EHCI Host Controller
[    0.586989] usb usb1: Manufacturer: Linux 2.6.31-rc5-git3-10-default ehc=
i_hcd
[    0.590010] usb usb1: SerialNumber: 0000:00:1a.7
[    0.593148] usb usb1: configuration #1 chosen from 1 choice
[    0.596343] hub 1-0:1.0: USB hub found
[    0.599555] hub 1-0:1.0: 6 ports detected
[    0.602900] ehci_hcd 0000:00:1d.7: PCI->APIC IRQ transform: INT A -> IRQ=
 23
[    0.606350] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.606353] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.609832] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    0.617341] ehci_hcd 0000:00:1d.7: debug port 1
[    0.620975] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.620990] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf4a04c00
[    0.640061] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.643839] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    0.647634] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.651409] usb usb2: Product: EHCI Host Controller
[    0.655178] usb usb2: Manufacturer: Linux 2.6.31-rc5-git3-10-default ehc=
i_hcd
[    0.659044] usb usb2: SerialNumber: 0000:00:1d.7
[    0.662911] usb usb2: configuration #1 chosen from 1 choice
[    0.666715] hub 2-0:1.0: USB hub found
[    0.670418] hub 2-0:1.0: 6 ports detected
[    0.674116] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.677810] uhci_hcd: USB Universal Host Controller Interface driver
[    0.681516] uhci_hcd 0000:00:1a.0: PCI->APIC IRQ transform: INT A -> IRQ=
 16
[    0.685290] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.685293] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.689094] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    0.693045] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    0.697038] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.701140] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.705217] usb usb3: Product: UHCI Host Controller
[    0.709342] usb usb3: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    0.713512] usb usb3: SerialNumber: 0000:00:1a.0
[    0.717775] usb usb3: configuration #1 chosen from 1 choice
[    0.721989] hub 3-0:1.0: USB hub found
[    0.726226] hub 3-0:1.0: 2 ports detected
[    0.730455] uhci_hcd 0000:00:1a.1: PCI->APIC IRQ transform: INT B -> IRQ=
 21
[    0.734682] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.734685] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.738837] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[    0.743074] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    0.747279] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.751510] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.755787] usb usb4: Product: UHCI Host Controller
[    0.760069] usb usb4: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    0.764389] usb usb4: SerialNumber: 0000:00:1a.1
[    0.768717] usb usb4: configuration #1 chosen from 1 choice
[    0.773002] hub 4-0:1.0: USB hub found
[    0.777211] hub 4-0:1.0: 2 ports detected
[    0.781424] uhci_hcd 0000:00:1a.2: PCI->APIC IRQ transform: INT C -> IRQ=
 19
[    0.785680] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.785683] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.789884] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[    0.794198] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001860
[    0.798452] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.802747] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.807056] usb usb5: Product: UHCI Host Controller
[    0.811338] usb usb5: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    0.815729] usb usb5: SerialNumber: 0000:00:1a.2
[    0.820178] usb usb5: configuration #1 chosen from 1 choice
[    0.824566] hub 5-0:1.0: USB hub found
[    0.828897] hub 5-0:1.0: 2 ports detected
[    0.833217] uhci_hcd 0000:00:1d.0: PCI->APIC IRQ transform: INT A -> IRQ=
 23
[    0.837552] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.837555] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.841819] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[    0.846160] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
[    0.850469] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.854856] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.859234] usb usb6: Product: UHCI Host Controller
[    0.863583] usb usb6: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    0.867989] usb usb6: SerialNumber: 0000:00:1d.0
[    0.872416] usb usb6: configuration #1 chosen from 1 choice
[    0.876831] hub 6-0:1.0: USB hub found
[    0.877703] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.885593] hub 6-0:1.0: 2 ports detected
[    0.890042] uhci_hcd 0000:00:1d.1: PCI->APIC IRQ transform: INT B -> IRQ=
 19
[    0.894484] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.894487] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.898847] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[    0.903253] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018a0
[    0.905692] ata5: SATA link down (SStatus 0 SControl 300)
[    0.905717] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.905735] ata6: SATA link down (SStatus 0 SControl 300)
[    0.907385] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.50, max UDMA/33
[    0.925177] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    0.926136] ata1.00: ATA-8: TOSHIBA MK3252GSX, LV010M, max UDMA/100
[    0.926138] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.926824] ata2.00: configured for UDMA/33
[    0.928145] ata1.00: configured for UDMA/100
[    0.928248] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3252GS LV=
01 PQ: 0 ANSI: 5
[    0.928403] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB=
/298 GiB)
[    0.928443] sd 0:0:0:0: [sda] Write Protect is off
[    0.928445] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.928466] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.928581]  sda:
[    0.965153] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    0.965162] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[    0.965164] ata2: irq_stat 0x40000001
[    0.965168] ata2: hard resetting link
[    0.975873]  sda1 sda2
[    0.992282] usb usb7: Product: UHCI Host Controller
[    0.996782] usb usb7: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    0.996876] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.005742] usb usb7: SerialNumber: 0000:00:1d.1
[    1.010234] usb usb7: configuration #1 chosen from 1 choice
[    1.014717] hub 7-0:1.0: USB hub found
[    1.019139] hub 7-0:1.0: 2 ports detected
[    1.023647] uhci_hcd 0000:00:1d.2: PCI->APIC IRQ transform: INT C -> IRQ=
 18
[    1.028150] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.028154] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.032613] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[    1.037147] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
[    1.041641] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.046128] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.050622] usb usb8: Product: UHCI Host Controller
[    1.055065] usb usb8: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    1.059555] usb usb8: SerialNumber: 0000:00:1d.2
[    1.064041] usb usb8: configuration #1 chosen from 1 choice
[    1.068523] hub 8-0:1.0: USB hub found
[    1.072948] hub 8-0:1.0: 2 ports detected
[    1.077358] Initializing USB Mass Storage driver...
[    1.081746] usbcore: registered new interface driver usb-storage
[    1.086105] USB Mass Storage support registered.
[    1.090491] usbcore: registered new interface driver libusual
[    1.094894] usbcore: registered new interface driver ums-alauda
[    1.099237] usbcore: registered new interface driver ums-cypress
[    1.103505] usbcore: registered new interface driver ums-datafab
[    1.107721] usbcore: registered new interface driver ums-freecom
[    1.111885] usbcore: registered new interface driver ums-isd200
[    1.115967] usbcore: registered new interface driver ums-jumpshot
[    1.119957] usbcore: registered new interface driver ums-karma
[    1.123839] usbcore: registered new interface driver ums-onetouch
[    1.127650] usbcore: registered new interface driver ums-sddr09
[    1.131381] usbcore: registered new interface driver ums-sddr55
[    1.132140] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[    1.138858] usbcore: registered new interface driver ums-usbat
[    1.142571] PNP: No PS/2 controller found. Probing ports directly.
[    1.146288] Platform driver 'i8042' needs updating - please use dev_pm_o=
ps
[    1.152366] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.157532] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.161187] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.164786] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.168307] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.171799] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.175313] mice: PS/2 mouse device common for all mice
[    1.178888] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    1.182417] rtc0: alarms up to one day, 114 bytes nvram
[    1.185869] cpuidle: using governor ladder
[    1.189284] cpuidle: using governor menu
[    1.192885] usbcore: registered new interface driver hiddev
[    1.196295] usbcore: registered new interface driver usbhid
[    1.199677] usbhid: v2.6:USB HID core driver
[    1.208031] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    1.269354] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0606
[    1.272913] usb 1-1: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    1.276477] usb 1-1: Product: USB2.0 Hub
[    1.280001] usb 1-1: configuration #1 chosen from 1 choice
[    1.283776] TCP cubic registered
[    1.284225] hub 1-1:1.0: USB hub found
[    1.284486] hub 1-1:1.0: 4 ports detected
[    1.293937] NET: Registered protocol family 10
[    1.297634] lo: Disabled Privacy Extensions
[    1.301212] lib80211: common routines for IEEE802.11 drivers
[    1.304630] lib80211_crypt: registered algorithm 'NULL'
[    1.304718] PM: Checking image partition /dev/disk/by-id/ata-TOSHIBA_MK3=
252GSX_Z86CSPDUS-part1
[    1.373750] Clocksource tsc unstable (delta =3D 105053647 ns)
[    1.468179] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 2
[    1.744920] usb 2-1: New USB device found, idVendor=3D07d1, idProduct=3D=
3c03
[    1.748174] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    1.751629] usb 2-1: Product: 802.11 bg WLAN
[    1.752222] usb 2-1: Manufacturer: Ralink
[    1.756229] usb 2-1: configuration #1 chosen from 1 choice
[    1.816191] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.825145] ata2.00: configured for UDMA/33
[    1.828490] ata2: EH complete
[    1.849188] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.=
50 PQ: 0 ANSI: 5
[    1.872180] usb 2-4: new high speed USB device using ehci_hcd and addres=
s 3
[    2.020659] usb 2-4: New USB device found, idVendor=3D04f2, idProduct=3D=
b008
[    2.024179] usb 2-4: New USB device strings: Mfr=3D2, Product=3D1, Seria=
lNumber=3D3
[    2.028174] usb 2-4: Product: Chicony USB 2.0 Camera
[    2.032186] usb 2-4: Manufacturer: Chicony Electronics Co., Ltd.
[    2.036179] usb 2-4: SerialNumber: SN0001
[    2.040227] usb 2-4: configuration #1 chosen from 1 choice
[    2.061781] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1e0b1, caps: 0x=
d04711/0xa00000
[    2.100172] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio4/input/input1
[    2.107764] PM: Resume from disk failed.
[    2.107764] registered taskstats version 1
[    2.108284]   Magic number: 5:560:447
[    2.116240] rtc_cmos rtc_cmos: setting system clock to 2009-08-14 20:25:=
34 UTC (1250281534)
[    2.120250] Freeing unused kernel memory: 1048k freed
[    2.124417] Write protecting the kernel read-only data: 8880k
[    2.172834] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    2.200730] udevd version 128 started
[    2.304751] usb 3-2: new low speed USB device using uhci_hcd and address=
 2
[    2.488063] usb 3-2: New USB device found, idVendor=3D046d, idProduct=3D=
c50a
[    2.488180] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.492175] usb 3-2: Product: USB Receiver
[    2.496184] usb 3-2: Manufacturer: Logitech
[    2.500267] usb 3-2: configuration #1 chosen from 1 choice
[    2.526352] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1a.0/usb3/3-2/3-2:1.0/input/input2
[    2.532292] generic-usb 0003:046D:C50A.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-2/input0
[    2.582500] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[    2.582504] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.582508] PM: Marking nosave pages: 00000000b5aa1000 - 00000000b5aa7000
[    2.582510] PM: Marking nosave pages: 00000000b5bba000 - 00000000b5c0f000
[    2.582514] PM: Marking nosave pages: 00000000b5d08000 - 00000000b5f0f000
[    2.582528] PM: Marking nosave pages: 00000000b5f18000 - 00000000b5f1f000
[    2.582530] PM: Marking nosave pages: 00000000b5f65000 - 00000000b5f9f000
[    2.582533] PM: Marking nosave pages: 00000000b5fe1000 - 00000000b5fff000
[    2.582536] PM: Marking nosave pages: 00000000b6000000 - 0000000100000000
[    2.584130] PM: Basic memory bitmaps created
[    2.601201] PM: Basic memory bitmaps freed
[    2.612893] PM: Starting manual resume from disk
[    2.612893] usb 1-1.1: new high speed USB device using ehci_hcd and addr=
ess 4
[    2.616210] PM: Resume from partition 8:1
[    2.616212] PM: Checking hibernation image.
[    2.622678] PM: Resume from disk failed.
[    2.728487] usb 1-1.1: New USB device found, idVendor=3D059b, idProduct=
=3D0370
[    2.735255] usb 1-1.1: New USB device strings: Mfr=3D2, Product=3D3, Ser=
ialNumber=3D1
[    2.740181] usb 1-1.1: Product: External HD
[    2.744181] usb 1-1.1: Manufacturer: Iomega
[    2.752174] usb 1-1.1: SerialNumber: 152000000733
[    2.756280] usb 1-1.1: configuration #1 chosen from 1 choice
[    2.764820] scsi6 : SCSI emulation for USB Mass Storage devices
[    2.772239] usb-storage: device found at 4
[    2.772239] usb-storage: waiting for device to settle before scanning
[    2.844189] usb 1-1.2: new high speed USB device using ehci_hcd and addr=
ess 5
[    2.940200] usb 1-1.2: New USB device found, idVendor=3D1058, idProduct=
=3D1001
[    2.944175] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    2.952181] usb 1-1.2: Product: External HDD   =20
[    2.956180] usb 1-1.2: Manufacturer: Western Digital=20
[    2.960174] usb 1-1.2: SerialNumber: 574341505732323139323037
[    2.968266] usb 1-1.2: configuration #1 chosen from 1 choice
[    2.975185] scsi7 : SCSI emulation for USB Mass Storage devices
[    2.976247] usb-storage: device found at 5
[    2.976247] usb-storage: waiting for device to settle before scanning
[    3.048468] usb 1-1.4: new high speed USB device using ehci_hcd and addr=
ess 6
[    3.109563] kjournald starting.  Commit interval 15 seconds
[    3.112242] EXT3 FS on sda2, internal journal
[    3.116176] EXT3-fs: mounted filesystem with ordered data mode.
[    3.148191] usb 1-1.4: New USB device found, idVendor=3D05e3, idProduct=
=3D0606
[    3.152177] usb 1-1.4: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    3.156174] usb 1-1.4: Product: USB2.0 Hub
[    3.160281] usb 1-1.4: configuration #1 chosen from 1 choice
[    3.164230] hub 1-1.4:1.0: USB hub found
[    3.168324] hub 1-1.4:1.0: 4 ports detected
[    3.448190] usb 1-1.4.2: new high speed USB device using ehci_hcd and ad=
dress 7
[    3.549027] usb 1-1.4.2: New USB device found, idVendor=3D05e3, idProduc=
t=3D070e
[    3.552178] usb 1-1.4.2: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    3.560182] usb 1-1.4.2: Product: USB Storage
[    3.564174] usb 1-1.4.2: SerialNumber: 000000009601
[    3.568265] usb 1-1.4.2: configuration #1 chosen from 1 choice
[    3.577704] scsi8 : SCSI emulation for USB Mass Storage devices
[    3.582932] usb-storage: device found at 7
[    3.582932] usb-storage: waiting for device to settle before scanning
[    3.654024] usb 1-1.4.3: new high speed USB device using ehci_hcd and ad=
dress 8
[    3.749897] usb 1-1.4.3: New USB device found, idVendor=3D03f0, idProduc=
t=3D5611
[    3.752186] usb 1-1.4.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    3.756175] usb 1-1.4.3: Product: Photosmart C3100 series
[    3.760182] usb 1-1.4.3: Manufacturer: HP
[    3.764174] usb 1-1.4.3: SerialNumber: MY68SC52KM04P9
[    3.768243] usb 1-1.4.3: configuration #1 chosen from 1 choice
[    3.772350] scsi9 : SCSI emulation for USB Mass Storage devices
[    3.776227] usb-storage: device found at 8
[    3.776227] usb-storage: waiting for device to settle before scanning
[    3.776227] scsi 6:0:0:0: Direct-Access     ST336032 0AS                =
   PQ: 0 ANSI: 2
[    3.780491] usb-storage: device scan complete
[    3.782182] sd 6:0:0:0: [sdb] 703282608 512-byte logical blocks: (360 GB=
/335 GiB)
[    3.790137] sd 6:0:0:0: [sdb] Write Protect is off
[    3.792175] sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00
[    3.792178] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    3.800687] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    3.804177]  sdb:
[    3.852193] usb 1-1.4.4: new high speed USB device using ehci_hcd and ad=
dress 9
[    3.977912] scsi 7:0:0:0: Direct-Access     WD       5000AAJ External 1.=
06 PQ: 0 ANSI: 0
[    3.980427] sd 7:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[    3.988814] sd 7:0:0:0: [sdc] Write Protect is off
[    3.988814] usb-storage: device scan complete
[    3.992176] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[    3.992178] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    4.000250] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    4.004178]  sdc: sdc1
[    4.010152] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    4.014879] usb 1-1.4.4: New USB device found, idVendor=3D0402, idProduc=
t=3D5621
[    4.014882] usb 1-1.4.4: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    4.014884] usb 1-1.4.4: Product: USB 2.0 Storage Device
[    4.014885] usb 1-1.4.4: SerialNumber: 00042222200000014305
[    4.014958] usb 1-1.4.4: configuration #1 chosen from 1 choice
[    4.036224] scsi10 : SCSI emulation for USB Mass Storage devices
[    4.036325] usb-storage: device found at 9
[    4.036326] usb-storage: waiting for device to settle before scanning
[    4.040206] sd 7:0:0:0: [sdc] Attached SCSI disk
[    4.580189] scsi 8:0:0:0: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.585929] scsi 8:0:0:1: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.592185] scsi 8:0:0:2: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.596316] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[    4.600397] scsi 8:0:0:3: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.608200] sd 8:0:0:1: [sde] Attached SCSI removable disk
[    4.612858] sd 8:0:0:2: [sdf] Attached SCSI removable disk
[    4.616552] sd 8:0:0:3: [sdg] Attached SCSI removable disk
[    4.620291] usb-storage: device scan complete
[    4.777878] scsi 9:0:0:0: Direct-Access     HP       Photosmart C3180 1.=
00 PQ: 0 ANSI: 2
[    4.784189] sd 9:0:0:0: [sdh] Attached SCSI removable disk
[    4.784311] usb-storage: device scan complete
[    5.036229] scsi 10:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-W162C T=
S09 PQ: 0 ANSI: 0
[    5.040319] usb-storage: device scan complete
[    5.349962]  sdb1
[    5.356821] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    5.360177] sd 6:0:0:0: [sdb] Attached SCSI disk
[    6.471968] udevd version 128 started
[    6.901429] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.904222] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    6.908210] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    6.912206] sd 7:0:0:0: Attached scsi generic sg3 type 0
[    6.916217] sd 8:0:0:0: Attached scsi generic sg4 type 0
[    6.920210] sd 8:0:0:1: Attached scsi generic sg5 type 0
[    6.924237] sd 8:0:0:2: Attached scsi generic sg6 type 0
[    6.928239] sd 8:0:0:3: Attached scsi generic sg7 type 0
[    6.932226] sd 9:0:0:0: Attached scsi generic sg8 type 0
[    6.936265] scsi 10:0:0:0: Attached scsi generic sg9 type 5
[    6.956491] usblp0: USB Bidirectional printer dev 8 if 1 alt 0 proto 2 v=
id 0x03F0 pid 0x5611
[    6.960212] usbcore: registered new interface driver usblp
[    7.025117] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    7.028189] Uniform CD-ROM driver Revision: 3.20
[    7.032282] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    7.054136] sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    7.056312] sr 10:0:0:0: Attached scsi CD-ROM sr1
[    7.087638] agpgart-intel 0000:00:00.0: Intel Mobile Intel=C2=AE GM45 Ex=
press Chipset
[    7.092838] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    7.098186] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    7.144451] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    7.370234] sky2 driver version 1.23
[    7.370234] iTCO_vendor_support: vendor-support=3D0
[    7.372279] sky2 0000:07:00.0: using bridge 0000:00:1c.4 INT A to get IR=
Q 17
[    7.376179] sky2 0000:07:00.0: PCI->APIC IRQ transform: INT A -> IRQ 17
[    7.380202] sky2 0000:07:00.0: setting latency timer to 64
[    7.380241] sky2 0000:07:00.0: Yukon-2 FE+ chip revision 0
[    7.384273]   alloc irq_desc for 28 on node 0
[    7.384276]   alloc kstat_irqs on node 0
[    7.384293] sky2 0000:07:00.0: irq 28 for MSI/MSI-X
[    7.388499] sky2 eth0: addr 00:23:8b:67:11:3b
[    7.409544] i801_smbus 0000:00:1f.3: PCI->APIC IRQ transform: INT C -> I=
RQ 19
[    7.425413] ohci1394 0000:0a:01.0: can't find IRQ for PCI INT B; probabl=
y buggy MP table
[    7.448599] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    7.452266] iTCO_wdt: Found a ICH9M TCO device (Version=3D2, TCOBASE=3D0=
x0460)
[    7.456239] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[    7.467508] sdhci: Secure Digital Host Controller Interface driver
[    7.472201] sdhci: Copyright(c) Pierre Ossman
[    7.486896] ohci1394: Failed to allocate interrupt 0
[    7.488274] ohci1394: probe of 0000:0a:01.0 failed with error -16
[    7.494261] sdhci-pci 0000:0a:01.2: SDHCI controller found [1217:7120] (=
rev 2)
[    7.496203] sdhci-pci 0000:0a:01.2: can't find IRQ for PCI INT B; probab=
ly buggy MP table
[    7.500218] mmc0: Unknown controller version (2). You may experience pro=
blems.
[    7.508203] sdhci-pci: probe of 0000:0a:01.2 failed with error -16
[    7.532236] cfg80211: Calling CRDA to update world regulatory domain
[    7.776185] Linux video capture interface: v2.00
[    7.857465] uvcvideo: Found UVC 1.00 device Chicony USB 2.0 Camera (04f2=
:b008)
[    7.865363] input: Chicony USB 2.0 Camera as /devices/pci0000:00/0000:00=
:1d.7/usb2/2-4/2-4:1.0/input/input4
[    7.868257] usbcore: registered new interface driver uvcvideo
[    7.872176] USB Video Class driver (v0.1.0)
[    8.205251] cfg80211: World regulatory domain updated:
[    8.208177] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max=
_eirp)
[    8.216176] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.387470] HDA Intel 0000:00:1b.0: PCI->APIC IRQ transform: INT A -> IR=
Q 22
[    8.388227] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.513011] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27kds
[    8.516188] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    8.525018] iwlagn 0000:08:00.0: using bridge 0000:00:1c.5 INT A to get =
IRQ 17
[    8.528203] iwlagn 0000:08:00.0: PCI->APIC IRQ transform: INT A -> IRQ 17
[    8.532185] iwlagn 0000:08:00.0: setting latency timer to 64
[    8.532231] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100A=
GN REV=3D0x54
[    8.576463] iwlagn 0000:08:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[    8.580233]   alloc irq_desc for 29 on node 0
[    8.580235]   alloc kstat_irqs on node 0
[    8.580255] iwlagn 0000:08:00.0: irq 29 for MSI/MSI-X
[    8.602336] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input5
[    8.604260] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input6
[    8.608233] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/sound/card0/input7
[    8.620143] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    8.841785] phy1: Selected rate control algorithm 'minstrel'
[    8.844392] Registered led device: rt73usb-phy1::radio
[    8.848199] Registered led device: rt73usb-phy1::assoc
[    8.855139] Registered led device: rt73usb-phy1::quality
[    8.860273] usbcore: registered new interface driver rt73usb
[    9.228173] Adding 4200956k swap on /dev/sda1.  Priority:-1 extents:1 ac=
ross:4200956k=20
[   10.388173] device-mapper: uevent: version 1.0.3
[   10.393726] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:=
 dm-devel@redhat.com
[   10.772888] loop: module loaded
[   10.975572] fuse init (API version 7.12)
[   14.486654] type=3D1505 audit(1250277947.220:2): operation=3D"profile_lo=
ad" pid=3D1903 name=3D/bin/ping
[   14.511501] type=3D1505 audit(1250277947.240:3): operation=3D"profile_lo=
ad" pid=3D1904 name=3D/sbin/klogd
[   14.554315] type=3D1505 audit(1250277947.284:4): operation=3D"profile_lo=
ad" pid=3D1905 name=3D/sbin/syslog-ng
[   14.598044] type=3D1505 audit(1250277947.328:5): operation=3D"profile_lo=
ad" pid=3D1906 name=3D/sbin/syslogd
[   14.644290] type=3D1505 audit(1250277947.376:6): operation=3D"profile_lo=
ad" pid=3D1907 name=3D/usr/sbin/avahi-daemon
[   14.683338] type=3D1505 audit(1250277947.416:7): operation=3D"profile_lo=
ad" pid=3D1908 name=3D/usr/sbin/identd
[   14.726178] type=3D1505 audit(1250277947.456:8): operation=3D"profile_lo=
ad" pid=3D1909 name=3D/usr/sbin/mdnsd
[   14.773905] type=3D1505 audit(1250277947.504:9): operation=3D"profile_lo=
ad" pid=3D1910 name=3D/usr/sbin/nscd
[   14.835516] type=3D1505 audit(1250277947.568:10): operation=3D"profile_l=
oad" pid=3D1918 name=3D/usr/sbin/ntpd
[   14.877561] type=3D1505 audit(1250277947.608:11): operation=3D"profile_l=
oad" pid=3D1924 name=3D/usr/sbin/traceroute
[   17.664895] powernow_k8: Unknown symbol acpi_processor_notify_smm
[   17.664895] powernow_k8: Unknown symbol acpi_processor_unregister_perfor=
mance
[   17.664946] powernow_k8: Unknown symbol acpi_processor_register_performa=
nce
[   17.716685] acpi_cpufreq: Unknown symbol acpi_processor_notify_smm
[   17.716764] acpi_cpufreq: Unknown symbol acpi_processor_unregister_perfo=
rmance
[   17.716976] acpi_cpufreq: Unknown symbol acpi_processor_preregister_perf=
ormance
[   17.717053] acpi_cpufreq: Unknown symbol acpi_processor_register_perform=
ance
[   32.018349] [drm] Initialized drm 1.1.0 20060810
[   32.084264] pci 0000:00:02.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[   32.084269] pci 0000:00:02.0: setting latency timer to 64
[   32.098357]   alloc irq_desc for 30 on node 0
[   32.098361]   alloc kstat_irqs on node 0
[   32.098371] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[   32.098433] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   34.926521] Bluetooth: Core ver 2.15
[   34.927421] NET: Registered protocol family 31
[   34.927423] Bluetooth: HCI device and connection manager initialized
[   34.927426] Bluetooth: HCI socket layer initialized
[   35.861081] Bluetooth: L2CAP ver 2.13
[   35.861084] Bluetooth: L2CAP socket layer initialized
[   35.961444] Bluetooth: RFCOMM TTY layer initialized
[   35.961448] Bluetooth: RFCOMM socket layer initialized
[   35.961450] Bluetooth: RFCOMM ver 1.11
[   36.570360] Bluetooth: SCO (Voice Link) ver 0.6
[   36.570362] Bluetooth: SCO socket layer initialized
[   36.978073] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   36.978076] Bluetooth: BNEP filters: protocol multicast
[   37.254615] Bridge firewalling registered
[   43.619183] bootsplash: status on console 0 changed to on
[   45.010967] sky2 eth0: enabling interface
[   45.011587] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   45.012065] rt73usb 2-1:1.0: firmware: requesting rt73.bin
[   45.213123] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   45.213547] iwlagn 0000:08:00.0: firmware: requesting iwlwifi-5000-2.uco=
de
[   45.284955] iwlagn 0000:08:00.0: loaded firmware version 8.24.2.12
[   45.420346] Registered led device: iwl-phy0::radio
[   45.420363] Registered led device: iwl-phy0::assoc
[   45.420377] Registered led device: iwl-phy0::RX
[   45.420390] Registered led device: iwl-phy0::TX
[   45.436813] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   45.525796] NET: Registered protocol family 17
[   47.368165] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control=
 both
[   47.368797] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   58.108177] eth0: no IPv6 routers present
[   86.750185] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank c=
ount for disabled pipe 0

--Boundary-00=_hybhKKjtPmkRqve
Content-Type: text/x-log;
  charset="utf-8";
  name="dmesg-not-working-2.6.31.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-not-working-2.6.31.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-rc5-git3-10-default (geeko@buildhost) (=
gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP 20=
09-08-05 22:36:33 +0200
[    0.000000] Command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z=
86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z8=
6CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  BIOS-e820: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  BIOS-e820: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0B8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0B7E00000 mask FFFE00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000b7e00000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xb6000 max_arch_pfn =3D 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usab=
le) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  modified: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  modified: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  modified: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  modified: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  modified: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  modified: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  modified: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  modified: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  modified: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  modified: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  modified: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  modified: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000b6000000
[    0.000000]  0000000000 - 00b6000000 page 2M
[    0.000000] kernel direct mapping tables up to b6000000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ a000-10000
[    0.000000] RAMDISK: 37a98000 - 37fef362
[    0.000000] ACPI: RSDP 00000000000f6e60 00024 (v02 TOSQCI)
[    0.000000] ACPI: XSDT 00000000b5ff4a00 0007C (v01 TOSQCI TOSQCI00 06040=
000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000b5fe5000 000F4 (v03 T0SQCI TOSQCI00 06040=
000 ALAN 00000001)
[    0.000000] ACPI: DSDT 00000000b5fe6000 09F7C (v02 TOSQCI CANTIGA  06040=
000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000b5f9efc0 00040
[    0.000000] ACPI: APIC 00000000b5ffed1e 00068 (v01 INTEL  CRESTLNE 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: HPET 00000000b5ffed86 00038 (v01 TOSQCI TOSQCI00 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 00000000b5ffedbe 0003C (v01 TOSQCI TOSQCI00 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: APIC 00000000b5ffedfa 00068 (v01 PTLTD  	 APIC   06040=
000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000b5ffee62 00028 (v01 PTLTD  $SBFTBL$ 06040=
000  LTP 00000001)
[    0.000000] ACPI: SLIC 00000000b5ffee8a 00176 (v01 TOSQCI TOSQCI00 06040=
000  LTP 00000000)
[    0.000000] ACPI: SSDT 00000000b5ff4aa4 00196 (v01 SataRe SataAhci 00001=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe4000 00655 (v01  PmRef    CpuPm 00003=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe3000 00259 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe2000 0020F (v01  PmRef    ApTst 00003=
000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=3D2" works better, notify linux=
=2Dacpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000022fff]
[    0.000000]   bootmap [0000000000023000 -  000000000004afff] pages 28
[    0.000000] (8 early reservations) =3D=3D> bootmem [0000000000 - 0140000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001c76630]    TEXT DATA BSS =3D=3D> [000=
1000000 - 0001c76630]
[    0.000000]   #3 [0037a98000 - 0037fef362]          RAMDISK =3D=3D> [003=
7a98000 - 0037fef362]
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000=
009f400 - 0000100000]
[    0.000000]   #5 [0001c77000 - 0001c771e4]              BRK =3D=3D> [000=
1c77000 - 0001c771e4]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f6f20] f6f20
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880001e0000=
0-ffff8800055fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[10] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000b5aa1
[    0.000000]     0: 0x000b5aa7 -> 0x000b5bba
[    0.000000]     0: 0x000b5c0f -> 0x000b5d08
[    0.000000]     0: 0x000b5f0f -> 0x000b5f18
[    0.000000]     0: 0x000b5f1f -> 0x000b5f65
[    0.000000]     0: 0x000b5f9f -> 0x000b5fe1
[    0.000000]     0: 0x000b5fff -> 0x000b6000
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1006809
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 726391 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 00000000000=
06000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000=
d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000b5aa1000 - 00000000b5a=
a7000
[    0.000000] PM: Registered nosave memory: 00000000b5bba000 - 00000000b5c=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5d08000 - 00000000b5f=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5f18000 - 00000000b5f=
1f000
[    0.000000] PM: Registered nosave memory: 00000000b5f65000 - 00000000b5f=
9f000
[    0.000000] PM: Registered nosave memory: 00000000b5fe1000 - 00000000b5f=
ff000
[    0.000000] PM: Registered nosave memory: 00000000b6000000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at b6000000 (gap: b6000000=
:4a000000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff88000564b000, static data 8=
2912 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 988787
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK32=
52GSX_Z86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK325=
2GSX_Z86CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff88000568c000 - ffff=
88000968c000
[    0.000000] software IO TLB at phys 0x568c000 - 0x968c000
[    0.000000] Memory: 3884988k/5242880k available (5578k kernel code, 1215=
644k absent, 142248k reserved, 4455k data, 1048k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.834 MHz processor.
[    0.000084] Console: colour dummy device 80x25
[    0.000087] console [tty0] enabled
[    0.000509] hpet clockevent registered
[    0.000515] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.000523] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5053.66 BogoMIPS (lpj=3D10107336)
[    0.007517] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI=
, All Rights Reserved
[    0.007625] Security Framework initialized
[    0.007647] AppArmor: AppArmor initialized
[    0.007948] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.009964] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.011452] Mount-cache hash table entries: 256
[    0.011619] Initializing cgroup subsys ns
[    0.011626] Initializing cgroup subsys cpuacct
[    0.011631] Initializing cgroup subsys memory
[    0.011648] Initializing cgroup subsys devices
[    0.011652] Initializing cgroup subsys freezer
[    0.011655] Initializing cgroup subsys net_cls
[    0.011683] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.011687] CPU: L2 cache: 3072K
[    0.011692] CPU 0/0x0 -> Node 0
[    0.011695] CPU: Physical Processor ID: 0
[    0.011697] CPU: Processor Core ID: 0
[    0.011702] mce: CPU supports 6 MCE banks
[    0.011711] CPU0: Thermal monitoring enabled (TM2)
[    0.011716] using mwait in idle threads.
[    0.011719] Performance Counters: Core2 events, Intel PMU driver.
[    0.011727] ... version:                 2
[    0.011729] ... bit width:               40
[    0.011732] ... generic counters:        2
[    0.011734] ... value mask:              000000ffffffffff
[    0.011737] ... max period:              000000007fffffff
[    0.011740] ... fixed-purpose counters:  3
[    0.011743] ... counter mask:            0000000700000003
[    0.013898] ACPI: Core revision 20090521
[    0.032069] Setting APIC routing to flat
[    0.032413] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1
[    0.074973] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.076001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5053.97 Bog=
oMIPS (lpj=3D10107954)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.161539] CPU1: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.161567] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.164027] Brought up 2 CPUs
[    0.164027] Total of 2 processors activated (10107.64 BogoMIPS).
[    0.164086] CPU0 attaching sched-domain:
[    0.164088]  domain 0: span 0-1 level MC
[    0.164091]   groups: 0 1
[    0.164096] CPU1 attaching sched-domain:
[    0.164097]  domain 0: span 0-1 level MC
[    0.164099]   groups: 1 0
[    0.164152] devtmpfs: initialized
[    0.169228] Booting paravirtualized kernel on bare hardware
[    0.169230] regulator: core version 0.5
[    0.169230] Time: 19:09:39  Date: 08/14/09
[    0.169230] NET: Registered protocol family 16
[    0.169230] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.169230] ACPI: bus type pci registered
[    0.169230] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.169230] PCI: Not using MMCONFIG.
[    0.169230] PCI: Using configuration type 1 for base access
[    0.169230] bio: create slab <bio-0> at 0
[    0.169321] ACPI: EC: Look up EC in DSDT
[    0.176414] ACPI: BIOS _OSI(Linux) query ignored
[    0.180020] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.692004] ACPI: EC: missing confirmations, switch off interrupt mode.
[    1.336113] ACPI: Interpreter enabled
[    1.336118] ACPI: (supports S0 S3 S4 S5)
[    1.336144] ACPI: Using IOAPIC for interrupt routing
[    1.336198] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    1.340177] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    1.351152] PCI: Using MMCONFIG at e0000000 - efffffff
[    1.357550] ACPI: EC: GPE =3D 0x18, I/O: command/status =3D 0x66, data =
=3D 0x62
[    1.357555] ACPI: EC: driver started in poll mode
[    1.357979] ACPI: No dock devices found.
[    1.358648] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.358738] pci 0000:00:02.0: reg 10 64bit mmio: [0xf4000000-0xf43fffff]
[    1.358744] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    1.358748] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    1.358781] pci 0000:00:02.1: reg 10 64bit mmio: [0xf4400000-0xf44fffff]
[    1.358900] pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
[    1.358991] pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
[    1.359082] pci 0000:00:1a.2: reg 20 io port: [0x1860-0x187f]
[    1.359175] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf4a04800-0xf4a04bff]
[    1.359242] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.359250] pci 0000:00:1a.7: PME# disabled
[    1.359306] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4800000-0xf4803fff]
[    1.359364] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.359370] pci 0000:00:1b.0: PME# disabled
[    1.359453] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.359459] pci 0000:00:1c.0: PME# disabled
[    1.359551] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.359556] pci 0000:00:1c.4: PME# disabled
[    1.359642] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.359648] pci 0000:00:1c.5: PME# disabled
[    1.359721] pci 0000:00:1d.0: reg 20 io port: [0x1880-0x189f]
[    1.359811] pci 0000:00:1d.1: reg 20 io port: [0x18a0-0x18bf]
[    1.359902] pci 0000:00:1d.2: reg 20 io port: [0x18c0-0x18df]
[    1.359995] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4a04c00-0xf4a04fff]
[    1.360067] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.360074] pci 0000:00:1d.7: PME# disabled
[    1.360318] pci 0000:00:1f.2: reg 10 io port: [0x1818-0x181f]
[    1.360324] pci 0000:00:1f.2: reg 14 io port: [0x180c-0x180f]
[    1.360332] pci 0000:00:1f.2: reg 18 io port: [0x1810-0x1817]
[    1.360339] pci 0000:00:1f.2: reg 1c io port: [0x1808-0x180b]
[    1.360346] pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
[    1.360353] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf4a04000-0xf4a047ff]
[    1.360399] pci 0000:00:1f.2: PME# supported from D3hot
[    1.360405] pci 0000:00:1f.2: PME# disabled
[    1.360444] pci 0000:00:1f.3: reg 10 64bit mmio: [0x000000-0x0000ff]
[    1.360462] pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
[    1.360549] pci 0000:00:1c.0: bridge io port: [0x00-0xfff]
[    1.360553] pci 0000:00:1c.0: bridge 32bit mmio: [0x000000-0x0fffff]
[    1.360561] pci 0000:00:1c.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    1.360631] pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    1.360642] pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
[    1.360725] pci 0000:07:00.0: supports D1 D2
[    1.360726] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.360735] pci 0000:07:00.0: PME# disabled
[    1.360811] pci 0000:00:1c.4: bridge io port: [0x00-0xfff]
[    1.360816] pci 0000:00:1c.4: bridge 32bit mmio: [0x000000-0x0fffff]
[    1.360823] pci 0000:00:1c.4: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    1.360910] pci 0000:08:00.0: reg 10 64bit mmio: [0x000000-0x001fff]
[    1.361023] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    1.361031] pci 0000:08:00.0: PME# disabled
[    1.361115] pci 0000:00:1c.5: bridge io port: [0x00-0xfff]
[    1.361119] pci 0000:00:1c.5: bridge 32bit mmio: [0x000000-0x0fffff]
[    1.361126] pci 0000:00:1c.5: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    1.361169] pci 0000:0a:01.0: reg 10 32bit mmio: [0xff501000-0xff501fff]
[    1.361176] pci 0000:0a:01.0: reg 14 32bit mmio: [0xf4700000-0xf47007ff]
[    1.361226] pci 0000:0a:01.0: supports D1 D2
[    1.361228] pci 0000:0a:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.361234] pci 0000:0a:01.0: PME# disabled
[    1.361282] pci 0000:0a:01.2: reg 10 32bit mmio: [0xf4700800-0xf47008ff]
[    1.361347] pci 0000:0a:01.2: supports D1 D2
[    1.361349] pci 0000:0a:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    1.361355] pci 0000:0a:01.2: PME# disabled
[    1.361403] pci 0000:0a:01.3: reg 10 32bit mmio: [0xf4702000-0xf4702fff]
[    1.361469] pci 0000:0a:01.3: supports D1 D2
[    1.361471] pci 0000:0a:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.361477] pci 0000:0a:01.3: PME# disabled
[    1.361544] pci 0000:00:1e.0: transparent bridge
[    1.361552] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4700000-0xf47fffff]
[    1.361587] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.361746] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    1.361857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.361942] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    1.375708] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *11
[    1.375834] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 =
15)
[    1.375957] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 *6 7 10 12 14 =
15)
[    1.376085] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    1.376209] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    1.376333] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 =
15)
[    1.376457] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 =
15)
[    1.376579] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 =
15)
[    1.376768] SCSI subsystem initialized
[    1.378382] libata version 3.00 loaded.
[    1.378382] usbcore: registered new interface driver usbfs
[    1.378382] usbcore: registered new interface driver hub
[    1.378382] usbcore: registered new device driver usb
[    1.378382] PCI: Using ACPI for IRQ routing
[    1.378382] pci 0000:00:1c.0: BAR 13: can't allocate resource
[    1.378382] pci 0000:00:1c.0: BAR 14: can't allocate resource
[    1.378382] pci 0000:00:1c.0: BAR 15: can't allocate resource
[    1.378382] pci 0000:00:1c.4: BAR 13: can't allocate resource
[    1.378382] pci 0000:00:1c.4: BAR 14: can't allocate resource
[    1.378382] pci 0000:00:1c.4: BAR 15: can't allocate resource
[    1.378382] pci 0000:00:1c.5: BAR 13: can't allocate resource
[    1.378382] pci 0000:00:1c.5: BAR 14: can't allocate resource
[    1.378382] pci 0000:00:1c.5: BAR 15: can't allocate resource
[    1.388030] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.388038] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.393085] AppArmor: AppArmor Filesystem Enabled
[    1.396011] Switched to high resolution mode on CPU 0
[    1.397590] Switched to high resolution mode on CPU 1
[    1.401008] pnp: PnP ACPI init
[    1.401019] ACPI: bus type pnp registered
[    1.402250] pnp 00:04: io resource (0x2e-0x2f) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402257] pnp 00:04: io resource (0x4e-0x4f) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402262] pnp 00:04: io resource (0x61-0x61) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402267] pnp 00:04: io resource (0x63-0x63) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402272] pnp 00:04: io resource (0x65-0x65) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402278] pnp 00:04: io resource (0x67-0x67) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402283] pnp 00:04: io resource (0x68-0x68) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402288] pnp 00:04: io resource (0x6c-0x6c) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402293] pnp 00:04: io resource (0x70-0x70) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402298] pnp 00:04: io resource (0x80-0x80) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402303] pnp 00:04: io resource (0x92-0x92) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.402308] pnp 00:04: io resource (0xb2-0xb3) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    1.403684] pnp: PnP ACPI: found 9 devices
[    1.403689] ACPI: ACPI bus type pnp unregistered
[    1.403700] system 00:02: iomem range 0xfed00000-0xfed003ff has been res=
erved
[    1.403708] system 00:04: ioport range 0x3e0-0x3e1 has been reserved
[    1.403712] system 00:04: ioport range 0x400-0x47f has been reserved
[    1.403716] system 00:04: ioport range 0x680-0x69f has been reserved
[    1.403720] system 00:04: ioport range 0x480-0x48f has been reserved
[    1.403724] system 00:04: ioport range 0xffff-0xffff has been reserved
[    1.403729] system 00:04: ioport range 0xffff-0xffff has been reserved
[    1.403733] system 00:04: ioport range 0x1180-0x11ff has been reserved
[    1.403737] system 00:04: ioport range 0x164e-0x164f has been reserved
[    1.403741] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    1.403749] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    1.403753] system 00:08: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    1.403758] system 00:08: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    1.403762] system 00:08: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    1.403766] system 00:08: iomem range 0xe0000000-0xefffffff has been res=
erved
[    1.403771] system 00:08: iomem range 0xfed20000-0xfed3ffff has been res=
erved
[    1.403775] system 00:08: iomem range 0xfed45000-0xfed8ffff has been res=
erved
[    1.408553] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    1.408557] pci 0000:00:1c.0:   IO window: disabled
[    1.408564] pci 0000:00:1c.0:   MEM window: disabled
[    1.408569] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.408588] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
[    1.408593] pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
[    1.408600] pci 0000:00:1c.4:   MEM window: 0xb6000000-0xb60fffff
[    1.408606] pci 0000:00:1c.4:   PREFETCH window: disabled
[    1.408623] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
[    1.408626] pci 0000:00:1c.5:   IO window: disabled
[    1.408633] pci 0000:00:1c.5:   MEM window: 0xb6100000-0xb61fffff
[    1.408639] pci 0000:00:1c.5:   PREFETCH window: disabled
[    1.408645] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0a
[    1.408648] pci 0000:00:1e.0:   IO window: disabled
[    1.408655] pci 0000:00:1e.0:   MEM window: 0xf4700000-0xf47fffff
[    1.408661] pci 0000:00:1e.0:   PREFETCH window: disabled
[    1.408676]   alloc irq_desc for 17 on node 0
[    1.408678]   alloc kstat_irqs on node 0
[    1.408683] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.408691] pci 0000:00:1c.0: setting latency timer to 64
[    1.408699] pci 0000:00:1c.4: enabling device (0000 -> 0003)
[    1.408704] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.408712] pci 0000:00:1c.4: setting latency timer to 64
[    1.408719] pci 0000:00:1c.5: enabling device (0000 -> 0002)
[    1.408724]   alloc irq_desc for 16 on node 0
[    1.408726]   alloc kstat_irqs on node 0
[    1.408729] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.408736] pci 0000:00:1c.5: setting latency timer to 64
[    1.408744] pci 0000:00:1e.0: setting latency timer to 64
[    1.408748] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.408751] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    1.408754] pci_bus 0000:02: resource 0 mem: [0x0-0xfff]
[    1.408756] pci_bus 0000:02: resource 1 mem: [0x0-0xfffff]
[    1.408758] pci_bus 0000:02: resource 2 mem: [0x0-0xfffff]
[    1.408760] pci_bus 0000:07: resource 0 io:  [0x2000-0x2fff]
[    1.408762] pci_bus 0000:07: resource 1 mem: [0xb6000000-0xb60fffff]
[    1.408764] pci_bus 0000:07: resource 2 mem: [0x0-0xfffff]
[    1.408766] pci_bus 0000:08: resource 0 mem: [0x0-0xfff]
[    1.408768] pci_bus 0000:08: resource 1 mem: [0xb6100000-0xb61fffff]
[    1.408770] pci_bus 0000:08: resource 2 mem: [0x0-0xfffff]
[    1.408772] pci_bus 0000:0a: resource 1 mem: [0xf4700000-0xf47fffff]
[    1.408774] pci_bus 0000:0a: resource 3 io:  [0x00-0xffff]
[    1.408776] pci_bus 0000:0a: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    1.408833] NET: Registered protocol family 2
[    1.408998] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    1.410088] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    1.413765] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.414243] TCP: Hash tables configured (established 524288 bind 65536)
[    1.414248] TCP reno registered
[    1.414402] NET: Registered protocol family 1
[    1.414470] Unpacking initramfs...
[    1.498885] Freeing initrd memory: 5468k freed
[    1.500909] Simple Boot Flag at 0x36 set to 0x1
[    1.501219] Scanning for low memory corruption every 60 seconds
[    1.501420] audit: initializing netlink socket (disabled)
[    1.501439] type=3D2000 audit(1250276980.501:1): initialized
[    1.508437] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.508567] VFS: Disk quotas dquot_6.5.2
[    1.508602] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.508736] msgmni has been set to 1899
[    1.508953] alg: No test for stdrng (krng)
[    1.508980] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    1.508986] io scheduler noop registered
[    1.508989] io scheduler anticipatory registered
[    1.508992] io scheduler deadline registered
[    1.509014] io scheduler cfq registered (default)
[    1.509080] pci 0000:00:02.0: Boot video device
[    1.509384]   alloc irq_desc for 24 on node 0
[    1.509387]   alloc kstat_irqs on node 0
[    1.509399] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    1.509410] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.509577]   alloc irq_desc for 25 on node 0
[    1.509579]   alloc kstat_irqs on node 0
[    1.509587] pcieport-driver 0000:00:1c.4: irq 25 for MSI/MSI-X
[    1.509597] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    1.509760]   alloc irq_desc for 26 on node 0
[    1.509762]   alloc kstat_irqs on node 0
[    1.509770] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    1.509780] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.510184] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90011100=
000, using 6144k, total 131008k
[    1.510190] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D84
[    1.510194] vesafb: scrolling: redraw
[    1.510197] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.510357] bootsplash 3.1.6-2004/03/31: looking for picture...
[    1.519317] bootsplash: silentjpeg size 100719 bytes
[    1.530201] bootsplash: ...found (1024x768, 38691 bytes, v3).
[    1.562026] Console: switching to colour frame buffer device 124x44
[    1.605621] fb0: VESA VGA frame buffer device
[    1.607228] Non-volatile memory driver v1.3
[    1.607326] Linux agpgart interface v0.103
[    1.607421] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    1.607780] Platform driver 'serial8250' needs updating - please use dev=
_pm_ops
[    1.608291] ahci 0000:00:1f.2: version 3.0
[    1.608308]   alloc irq_desc for 19 on node 0
[    1.608310]   alloc kstat_irqs on node 0
[    1.608317] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.608506]   alloc irq_desc for 27 on node 0
[    1.608508]   alloc kstat_irqs on node 0
[    1.608518] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    1.608599] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
33 impl SATA mode
[    1.608786] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum pa=
rt ems=20
[    1.608956] ahci 0000:00:1f.2: setting latency timer to 64
[    1.636049] scsi0 : ahci
[    1.636202] scsi1 : ahci
[    1.636307] scsi2 : ahci
[    1.636412] scsi3 : ahci
[    1.636514] scsi4 : ahci
[    1.636618] scsi5 : ahci
[    1.636819] ata1: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0410=
0 irq 27
[    1.636989] ata2: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0418=
0 irq 27
[    1.637157] ata3: DUMMY
[    1.637215] ata4: DUMMY
[    1.637272] ata5: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0430=
0 irq 27
[    1.639171] ata6: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0438=
0 irq 27
[    1.641168] Fixed MDIO Bus: probed
[    1.643108] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.645278] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 19 (level, low) -> I=
RQ 19
[    1.647529] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.647533] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.649850] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    1.656187] ehci_hcd 0000:00:1a.7: debug port 1
[    1.658622] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.658637] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf4a04800
[    1.676008] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.678602] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.681316] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.684125] usb usb1: Product: EHCI Host Controller
[    1.686989] usb usb1: Manufacturer: Linux 2.6.31-rc5-git3-10-default ehc=
i_hcd
[    1.690019] usb usb1: SerialNumber: 0000:00:1a.7
[    1.693163] usb usb1: configuration #1 chosen from 1 choice
[    1.696362] hub 1-0:1.0: USB hub found
[    1.699582] hub 1-0:1.0: 6 ports detected
[    1.702940]   alloc irq_desc for 23 on node 0
[    1.702942]   alloc kstat_irqs on node 0
[    1.702947] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    1.706412] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.706415] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.709908] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    1.717439] ehci_hcd 0000:00:1d.7: debug port 1
[    1.721084] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.721098] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf4a04c00
[    1.740008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.743788] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.747589] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.751370] usb usb2: Product: EHCI Host Controller
[    1.755151] usb usb2: Manufacturer: Linux 2.6.31-rc5-git3-10-default ehc=
i_hcd
[    1.759029] usb usb2: SerialNumber: 0000:00:1d.7
[    1.762916] usb usb2: configuration #1 chosen from 1 choice
[    1.766732] hub 2-0:1.0: USB hub found
[    1.770444] hub 2-0:1.0: 6 ports detected
[    1.774157] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.777860] uhci_hcd: USB Universal Host Controller Interface driver
[    1.781578] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    1.785374] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.785377] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.789200] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    1.793176] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    1.797192] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.801321] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.805425] usb usb3: Product: UHCI Host Controller
[    1.809579] usb usb3: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    1.813775] usb usb3: SerialNumber: 0000:00:1a.0
[    1.818067] usb usb3: configuration #1 chosen from 1 choice
[    1.822312] hub 3-0:1.0: USB hub found
[    1.826577] hub 3-0:1.0: 2 ports detected
[    1.830853]   alloc irq_desc for 21 on node 0
[    1.830855]   alloc kstat_irqs on node 0
[    1.830859] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    1.835124] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.835127] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.839316] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[    1.843581] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    1.847812] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.852073] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.856380] usb usb4: Product: UHCI Host Controller
[    1.860693] usb usb4: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    1.865045] usb usb4: SerialNumber: 0000:00:1a.1
[    1.869407] usb usb4: configuration #1 chosen from 1 choice
[    1.873725] hub 4-0:1.0: USB hub found
[    1.877963] hub 4-0:1.0: 2 ports detected
[    1.882230] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 19 (level, low) -> I=
RQ 19
[    1.886523] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.886526] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.890783] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[    1.895142] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001860
[    1.899438] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.903770] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.908117] usb usb5: Product: UHCI Host Controller
[    1.912436] usb usb5: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    1.916863] usb usb5: SerialNumber: 0000:00:1a.2
[    1.921338] usb usb5: configuration #1 chosen from 1 choice
[    1.925767] hub 5-0:1.0: USB hub found
[    1.930141] hub 5-0:1.0: 2 ports detected
[    1.934538] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    1.938917] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.938921] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.943229] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[    1.947616] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
[    1.951968] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.956399] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.960820] usb usb6: Product: UHCI Host Controller
[    1.965211] usb usb6: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    1.969650] usb usb6: SerialNumber: 0000:00:1d.0
[    1.973021] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.973044] ata5: SATA link down (SStatus 0 SControl 300)
[    1.973067] ata6: SATA link down (SStatus 0 SControl 300)
[    1.973086] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.973981] ACPI Warning: \_SB_.PCI0.SAT0.PRT0._GTF: Return type mismatc=
h - found Integer, expected Buffer 20090521 nspredef-940
[    1.973988] ata1.00: _GTF unexpected object type 0x1
[    2.005017] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.50, max UDMA/33
[    2.005064] usb usb6: configuration #1 chosen from 1 choice
[    2.005096] hub 6-0:1.0: USB hub found
[    2.005102] hub 6-0:1.0: 2 ports detected
[    2.023172] ata1.00: ATA-8: TOSHIBA MK3252GSX, LV010M, max UDMA/100
[    2.027731] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.027748] ata2.00: configured for UDMA/33
[    2.036896] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    2.041511] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.041514] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.041704] ata1.00: _GTF unexpected object type 0x1
[    2.041844] ata1.00: configured for UDMA/100
[    2.041947] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3252GS LV=
01 PQ: 0 ANSI: 5
[    2.042104] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB=
/298 GiB)
[    2.042144] sd 0:0:0:0: [sda] Write Protect is off
[    2.042146] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.042166] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    2.042279]  sda:
[    2.073516] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[    2.082854] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018a0
[    2.083678] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.=
50 PQ: 0 ANSI: 5
[    2.092402]  sda1
[    2.092442] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.092444] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.092446] usb usb7: Product: UHCI Host Controller
[    2.092447] usb usb7: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    2.092449] usb usb7: SerialNumber: 0000:00:1d.1
[    2.092509] usb usb7: configuration #1 chosen from 1 choice
[    2.092533] hub 7-0:1.0: USB hub found
[    2.092539] hub 7-0:1.0: 2 ports detected
[    2.104030] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[    2.139788]  sda2
[    2.144530]   alloc irq_desc for 18 on node 0
[    2.144532]   alloc kstat_irqs on node 0
[    2.144537] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    2.149386] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.149389] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.154138] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[    2.154272] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.163684] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
[    2.168460] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.173244] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.178017] usb usb8: Product: UHCI Host Controller
[    2.182774] usb usb8: Manufacturer: Linux 2.6.31-rc5-git3-10-default uhc=
i_hcd
[    2.187687] usb usb8: SerialNumber: 0000:00:1d.2
[    2.192628] usb usb8: configuration #1 chosen from 1 choice
[    2.197435] hub 8-0:1.0: USB hub found
[    2.202060] hub 8-0:1.0: 2 ports detected
[    2.206987] Initializing USB Mass Storage driver...
[    2.211592] usbcore: registered new interface driver usb-storage
[    2.216167] USB Mass Storage support registered.
[    2.220759] usbcore: registered new interface driver libusual
[    2.225417] usbcore: registered new interface driver ums-alauda
[    2.230001] usbcore: registered new interface driver ums-cypress
[    2.234503] usbcore: registered new interface driver ums-datafab
[    2.238926] usbcore: registered new interface driver ums-freecom
[    2.243255] usbcore: registered new interface driver ums-isd200
[    2.247524] usbcore: registered new interface driver ums-jumpshot
[    2.251736] usbcore: registered new interface driver ums-karma
[    2.255904] usbcore: registered new interface driver ums-onetouch
[    2.259980] usbcore: registered new interface driver ums-sddr09
[    2.263940] usbcore: registered new interface driver ums-sddr55
[    2.267815] usbcore: registered new interface driver ums-usbat
[    2.271627] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x6=
4 irq 1,12
[    2.275455] Platform driver 'i8042' needs updating - please use dev_pm_o=
ps
[    2.282572] i8042.c: Detected active multiplexing controller, rev 1.1.
[    2.288608] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.292387] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.296119] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.299761] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.303340] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.303608] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0606
[    2.303610] usb 1-1: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    2.303612] usb 1-1: Product: USB2.0 Hub
[    2.303662] usb 1-1: configuration #1 chosen from 1 choice
[    2.320827] hub 1-1:1.0: USB hub found
[    2.320867] mice: PS/2 mouse device common for all mice
[    2.327910] rtc_cmos 00:05: RTC can wake from S4
[    2.328111] hub 1-1:1.0: 4 ports detected
[    2.334845] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.338365] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.341906] cpuidle: using governor ladder
[    2.345375] cpuidle: using governor menu
[    2.348996] usbcore: registered new interface driver hiddev
[    2.352389] usbcore: registered new interface driver usbhid
[    2.355696] usbhid: v2.6:USB HID core driver
[    2.355745] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.441631] TCP cubic registered
[    2.445021] NET: Registered protocol family 10
[    2.448753] lo: Disabled Privacy Extensions
[    2.452349] lib80211: common routines for IEEE802.11 drivers
[    2.455770] lib80211_crypt: registered algorithm 'NULL'
[    2.455859] PM: Checking image partition /dev/disk/by-id/ata-TOSHIBA_MK3=
252GSX_Z86CSPDUS-part1
[    2.479468] PM: Resume from disk failed.
[    2.479483] registered taskstats version 1
[    2.483003]   Magic number: 5:695:192
[    2.486393] acpi device:1e: hash matches
[    2.489742] rtc_cmos 00:05: setting system clock to 2009-08-14 19:09:42 =
UTC (1250276982)
[    2.493262] Freeing unused kernel memory: 1048k freed
[    2.497001] Write protecting the kernel read-only data: 8880k
[    2.513025] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 2
[    2.546749] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    2.561088] udevd version 128 started
[    2.788178] usb 2-1: New USB device found, idVendor=3D07d1, idProduct=3D=
3c03
[    2.792567] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.796822] usb 2-1: Product: 802.11 bg WLAN
[    2.800987] usb 2-1: Manufacturer: Ralink
[    2.805164] usb 2-1: configuration #1 chosen from 1 choice
[    2.853599] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[    2.853602] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.853606] PM: Marking nosave pages: 00000000b5aa1000 - 00000000b5aa7000
[    2.853608] PM: Marking nosave pages: 00000000b5bba000 - 00000000b5c0f000
[    2.853611] PM: Marking nosave pages: 00000000b5d08000 - 00000000b5f0f000
[    2.853625] PM: Marking nosave pages: 00000000b5f18000 - 00000000b5f1f000
[    2.853626] PM: Marking nosave pages: 00000000b5f65000 - 00000000b5f9f000
[    2.853629] PM: Marking nosave pages: 00000000b5fe1000 - 00000000b5fff000
[    2.853632] PM: Marking nosave pages: 00000000b6000000 - 0000000100000000
[    2.855225] PM: Basic memory bitmaps created
[    2.920013] usb 2-4: new high speed USB device using ehci_hcd and addres=
s 3
[    3.066694] usb 2-4: New USB device found, idVendor=3D04f2, idProduct=3D=
b008
[    3.066697] usb 2-4: New USB device strings: Mfr=3D2, Product=3D1, Seria=
lNumber=3D3
[    3.066699] usb 2-4: Product: Chicony USB 2.0 Camera
[    3.066701] usb 2-4: Manufacturer: Chicony Electronics Co., Ltd.
[    3.066703] usb 2-4: SerialNumber: SN0001
[    3.066808] usb 2-4: configuration #1 chosen from 1 choice
[    3.188946] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1e0b1, caps: 0x=
d04711/0xa00000
[    3.222488] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio4/input/input1
[    3.284643] PM: Basic memory bitmaps freed
[    3.295065] PM: Starting manual resume from disk
[    3.299774] PM: Resume from partition 8:1
[    3.299776] PM: Checking hibernation image.
[    3.300007] PM: Resume from disk failed.
[    3.310059] usb 3-2: new low speed USB device using uhci_hcd and address=
 2
[    3.490304] usb 3-2: New USB device found, idVendor=3D046d, idProduct=3D=
c50a
[    3.495506] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    3.500679] usb 3-2: Product: USB Receiver
[    3.505783] usb 3-2: Manufacturer: Logitech
[    3.510919] usb 3-2: configuration #1 chosen from 1 choice
[    3.535577] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1a.0/usb3/3-2/3-2:1.0/input/input2
[    3.541107] generic-usb 0003:046D:C50A.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-2/input0
[    3.624331] usb 1-1.1: new high speed USB device using ehci_hcd and addr=
ess 4
[    3.744327] usb 1-1.1: New USB device found, idVendor=3D059b, idProduct=
=3D0370
[    3.749905] usb 1-1.1: New USB device strings: Mfr=3D2, Product=3D3, Ser=
ialNumber=3D1
[    3.755438] usb 1-1.1: Product: External HD
[    3.760937] usb 1-1.1: Manufacturer: Iomega
[    3.766383] usb 1-1.1: SerialNumber: 152000000733
[    3.771893] usb 1-1.1: configuration #1 chosen from 1 choice
[    3.778902] scsi6 : SCSI emulation for USB Mass Storage devices
[    3.784769] usb-storage: device found at 4
[    3.784771] usb-storage: waiting for device to settle before scanning
[    3.828232] kjournald starting.  Commit interval 15 seconds
[    3.834140] EXT3 FS on sda2, internal journal
[    3.839750] EXT3-fs: mounted filesystem with ordered data mode.
[    3.856348] usb 1-1.2: new high speed USB device using ehci_hcd and addr=
ess 5
[    3.954345] usb 1-1.2: New USB device found, idVendor=3D1058, idProduct=
=3D1001
[    3.960302] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    3.966084] usb 1-1.2: Product: External HDD   =20
[    3.971779] usb 1-1.2: Manufacturer: Western Digital=20
[    3.971781] usb 1-1.2: SerialNumber: 574341505732323139323037
[    3.971892] usb 1-1.2: configuration #1 chosen from 1 choice
[    3.989252] scsi7 : SCSI emulation for USB Mass Storage devices
[    3.994989] usb-storage: device found at 5
[    3.994991] usb-storage: waiting for device to settle before scanning
[    4.065230] usb 1-1.4: new high speed USB device using ehci_hcd and addr=
ess 6
[    4.161358] usb 1-1.4: New USB device found, idVendor=3D05e3, idProduct=
=3D0606
[    4.167126] usb 1-1.4: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    4.167128] usb 1-1.4: Product: USB2.0 Hub
[    4.167215] usb 1-1.4: configuration #1 chosen from 1 choice
[    4.172902] hub 1-1.4:1.0: USB hub found
[    4.173234] hub 1-1.4:1.0: 4 ports detected
[    4.464256] usb 1-1.4.2: new high speed USB device using ehci_hcd and ad=
dress 7
[    4.564012] usb 1-1.4.2: New USB device found, idVendor=3D05e3, idProduc=
t=3D070e
[    4.569328] usb 1-1.4.2: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    4.574569] usb 1-1.4.2: Product: USB Storage
[    4.579700] usb 1-1.4.2: SerialNumber: 000000009601
[    4.584849] usb 1-1.4.2: configuration #1 chosen from 1 choice
[    4.591049] scsi8 : SCSI emulation for USB Mass Storage devices
[    4.596108] usb-storage: device found at 7
[    4.596111] usb-storage: waiting for device to settle before scanning
[    4.668275] usb 1-1.4.3: new high speed USB device using ehci_hcd and ad=
dress 8
[    4.764899] usb 1-1.4.3: New USB device found, idVendor=3D03f0, idProduc=
t=3D5611
[    4.769869] usb 1-1.4.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    4.774873] usb 1-1.4.3: Product: Photosmart C3100 series
[    4.779885] usb 1-1.4.3: Manufacturer: HP
[    4.784723] usb 1-1.4.3: SerialNumber: MY68SC52KM04P9
[    4.789534] usb 1-1.4.3: configuration #1 chosen from 1 choice
[    4.794293] scsi 6:0:0:0: Direct-Access     ST336032 0AS                =
   PQ: 0 ANSI: 2
[    4.799324] scsi9 : SCSI emulation for USB Mass Storage devices
[    4.804038] sd 6:0:0:0: [sdb] 703282608 512-byte logical blocks: (360 GB=
/335 GiB)
[    4.808811] usb-storage: device found at 8
[    4.808813] usb-storage: waiting for device to settle before scanning
[    4.811031] sd 6:0:0:0: [sdb] Write Protect is off
[    4.811033] sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00
[    4.811035] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    4.823413] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    4.823418] usb-storage: device scan complete
[    4.828096]  sdb:
[    4.885285] usb 1-1.4.4: new high speed USB device using ehci_hcd and ad=
dress 9
[    4.992678] scsi 7:0:0:0: Direct-Access     WD       5000AAJ External 1.=
06 PQ: 0 ANSI: 0
[    4.998049] sd 7:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[    5.003418] sd 7:0:0:0: [sdc] Write Protect is off
[    5.003511] usb-storage: device scan complete
[    5.007951] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[    5.007953] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    5.014042] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    5.018485]  sdc: sdc1
[    5.024792] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    5.029191] sd 7:0:0:0: [sdc] Attached SCSI disk
[    5.054920] usb 1-1.4.4: New USB device found, idVendor=3D0402, idProduc=
t=3D5621
[    5.059345] usb 1-1.4.4: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    5.063785] usb 1-1.4.4: Product: USB 2.0 Storage Device
[    5.068219] usb 1-1.4.4: SerialNumber: 00042222200000014305
[    5.072734] usb 1-1.4.4: configuration #1 chosen from 1 choice
[    5.077375] scsi10 : SCSI emulation for USB Mass Storage devices
[    5.081817] usb-storage: device found at 9
[    5.081819] usb-storage: waiting for device to settle before scanning
[    5.597221] scsi 8:0:0:0: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    5.602715] scsi 8:0:0:1: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    5.608460] scsi 8:0:0:2: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    5.613334] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[    5.619714] scsi 8:0:0:3: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    5.624586] sd 8:0:0:1: [sde] Attached SCSI removable disk
[    5.630229] sd 8:0:0:2: [sdf] Attached SCSI removable disk
[    5.635210] sd 8:0:0:3: [sdg] Attached SCSI removable disk
[    5.639555] usb-storage: device scan complete
[    5.809608] scsi 9:0:0:0: Direct-Access     HP       Photosmart C3180 1.=
00 PQ: 0 ANSI: 2
[    5.815598] sd 9:0:0:0: [sdh] Attached SCSI removable disk
[    5.820127] usb-storage: device scan complete
[    6.082126] scsi 10:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-W162C T=
S09 PQ: 0 ANSI: 0
[    6.086964] usb-storage: device scan complete
[    7.359583] udevd version 128 started
[    7.680486]  sdb1
[    7.688356] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    7.692923] sd 6:0:0:0: [sdb] Attached SCSI disk
[    7.765648] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.770256] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    7.770286] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    7.770315] sd 7:0:0:0: Attached scsi generic sg3 type 0
[    7.770342] sd 8:0:0:0: Attached scsi generic sg4 type 0
[    7.770368] sd 8:0:0:1: Attached scsi generic sg5 type 0
[    7.770394] sd 8:0:0:2: Attached scsi generic sg6 type 0
[    7.770421] sd 8:0:0:3: Attached scsi generic sg7 type 0
[    7.770448] sd 9:0:0:0: Attached scsi generic sg8 type 0
[    7.770477] scsi 10:0:0:0: Attached scsi generic sg9 type 5
[    7.851051] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    7.855190] Uniform CD-ROM driver Revision: 3.20
[    7.859341] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    7.883237] sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    7.887551] sr 10:0:0:0: Attached scsi CD-ROM sr1
[    7.893133] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    7.918519] ACPI: SSDT 00000000b5f1ac20 00265 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20061109)
[    7.923372] iTCO_vendor_support: vendor-support=3D0
[    7.927782] ACPI: SSDT 00000000b5f18620 00594 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20061109)
[    7.934205] ACPI Warning: Invalid throttling state, reset 20090521 proce=
ssor_throttling-843
[    7.939510] Monitor-Mwait will be used to enter C-1 state
[    8.023521] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.028224] iTCO_wdt: Found a ICH9M TCO device (Version=3D2, TCOBASE=3D0=
x0460)
[    8.032886] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[    8.045859] Monitor-Mwait will be used to enter C-2 state
[    8.045893] Monitor-Mwait will be used to enter C-3 state
[    8.045901] Marking TSC unstable due to TSC halts in idle
[    8.050571] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    8.055292] processor LNXCPU:00: registered as cooling_device0
[    8.059868] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.064575] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input4
[    8.069655] ACPI: Power Button [PWRF]
[    8.075467] ACPI: SSDT 00000000b5f19ca0 001CF (v01  PmRef    ApIst 00003=
000 INTL 20061109)
[    8.081211] ACPI: SSDT 00000000b5f19f20 0008D (v01  PmRef    ApCst 00003=
000 INTL 20061109)
[    8.086826] ACPI Warning: Invalid throttling state, reset 20090521 proce=
ssor_throttling-843
[    8.092386] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    8.097155] processor LNXCPU:01: registered as cooling_device1
[    8.102059] ACPI: Processor [CPU1] (supports 8 throttling states)
[    8.113206] ACPI: AC Adapter [ACAD] (on-line)
[    8.118024] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input5
[    8.123149] ACPI: Power Button [PWRB]
[    8.128296] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input6
[    8.133536] ACPI: Lid Switch [LID]
[    8.295145] sky2 driver version 1.23
[    8.300025] sky2 0000:07:00.0: enabling device (0000 -> 0003)
[    8.304907] sky2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.309672] sky2 0000:07:00.0: setting latency timer to 64
[    8.309720] sky2 0000:07:00.0: unsupported chip type 0xff
[    8.314397] sky2 0000:07:00.0: PCI INT A disabled
[    8.319050] sky2: probe of 0000:07:00.0 failed with error -95
[    8.345870] agpgart-intel 0000:00:00.0: Intel Mobile Intel=C2=AE GM45 Ex=
press Chipset
[    8.351550] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    8.358497] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.366829] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) ->=
 IRQ 19
[    8.372061] ACPI: I/O resource 0000:00:1f.3 [0x1c00-0x1c1f] conflicts wi=
th ACPI region SMBI [0x1c00-0x1c0f]
[    8.377359] ACPI: Device needs an ACPI driver
[    8.382873] i801_smbus: probe of 0000:00:1f.3 failed with error -16
[    8.434266] cfg80211: Calling CRDA to update world regulatory domain
[    8.478588] usblp0: USB Bidirectional printer dev 8 if 1 alt 0 proto 2 v=
id 0x03F0 pid 0x5611
[    8.484326] usbcore: registered new interface driver usblp
[    8.500037] Clocksource tsc unstable (delta =3D -77775007 ns)
[    8.784303] cfg80211: World regulatory domain updated:
[    8.789823] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max=
_eirp)
[    8.795322] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    9.000366] thermal LNXTHERM:01: registered as thermal_zone0
[    9.005878] ACPI: Thermal Zone [THRM] (64 C)
[    9.824459] ACPI: Battery Slot [BAT1] (battery present)
[    9.829956] ACPI: WMI: Mapper loaded
[    9.928091] ohci1394 0000:0a:01.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    9.935834] Linux video capture interface: v2.00
[    9.957340] sdhci: Secure Digital Host Controller Interface driver
[    9.962871] sdhci: Copyright(c) Pierre Ossman
[    9.976166] uvcvideo: Found UVC 1.00 device Chicony USB 2.0 Camera (04f2=
:b008)
[    9.985071] input: Chicony USB 2.0 Camera as /devices/pci0000:00/0000:00=
:1d.7/usb2/2-4/2-4:1.0/input/input7
[    9.990712] usbcore: registered new interface driver uvcvideo
[    9.996138] USB Video Class driver (v0.1.0)
[   10.002656] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[16]  MMIO=3D=
[ff501000-ff5017ff]  Max Packet=3D[2048]  IR/IT contexts=3D[8/8]
[   10.018831] sdhci-pci 0000:0a:01.2: SDHCI controller found [1217:7120] (=
rev 2)
[   10.024679] sdhci-pci 0000:0a:01.2: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16
[   10.030607] mmc0: Unknown controller version (2). You may experience pro=
blems.
[   10.036549] Registered led device: mmc0::
[   10.042365] mmc0: SDHCI controller on PCI [0000:0a:01.2] using DMA
[   10.195751] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27kds
[   10.201482] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   10.207240] iwlagn 0000:08:00.0: enabling device (0000 -> 0002)
[   10.212776] iwlagn 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   10.218226] iwlagn 0000:08:00.0: setting latency timer to 64
[   10.218276] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100A=
GN REV=3D0xFDFFFFFF
[   10.375477] iwlagn 0000:08:00.0: Failed, HW not ready
[   10.381217] iwlagn 0000:08:00.0: PCI INT A disabled
[   10.390310]   alloc irq_desc for 22 on node 0
[   10.390313]   alloc kstat_irqs on node 0
[   10.390322] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[   10.396039] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.525462] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input8
[   10.531287] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input9
[   10.536920] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/sound/card0/input10
[   10.678554] phy1: Selected rate control algorithm 'minstrel'
[   10.679034] Registered led device: rt73usb-phy1::radio
[   10.684732] Registered led device: rt73usb-phy1::assoc
[   10.690496] Registered led device: rt73usb-phy1::quality
[   10.696491] usbcore: registered new interface driver rt73usb
[   10.704179] wlan0 renamed to wlan1 by udevd [1695]
[   10.710116] udev: renamed network interface wlan0 to wlan1
[   11.289448] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b240001542c=
7b]
[   11.496270] Adding 4200956k swap on /dev/sda1.  Priority:-1 extents:1 ac=
ross:4200956k=20
[   12.600376] device-mapper: uevent: version 1.0.3
[   12.605846] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:=
 dm-devel@redhat.com
[   12.986411] loop: module loaded
[   13.433601] fuse init (API version 7.12)
[   16.221086] type=3D1505 audit(1250273395.742:2): operation=3D"profile_lo=
ad" pid=3D2058 name=3D/bin/ping
[   16.243573] type=3D1505 audit(1250273395.761:3): operation=3D"profile_lo=
ad" pid=3D2059 name=3D/sbin/klogd
[   16.284620] type=3D1505 audit(1250273395.805:4): operation=3D"profile_lo=
ad" pid=3D2060 name=3D/sbin/syslog-ng
[   16.329822] type=3D1505 audit(1250273395.850:5): operation=3D"profile_lo=
ad" pid=3D2061 name=3D/sbin/syslogd
[   16.394165] type=3D1505 audit(1250273395.914:6): operation=3D"profile_lo=
ad" pid=3D2078 name=3D/usr/sbin/avahi-daemon
[   16.478233] type=3D1505 audit(1250273395.998:7): operation=3D"profile_lo=
ad" pid=3D2097 name=3D/usr/sbin/identd
[   16.557940] type=3D1505 audit(1250273396.077:8): operation=3D"profile_lo=
ad" pid=3D2098 name=3D/usr/sbin/mdnsd
[   16.604080] type=3D1505 audit(1250273396.125:9): operation=3D"profile_lo=
ad" pid=3D2100 name=3D/usr/sbin/nscd
[   16.667989] type=3D1505 audit(1250273396.185:10): operation=3D"profile_l=
oad" pid=3D2103 name=3D/usr/sbin/ntpd
[   16.707278] type=3D1505 audit(1250273396.225:11): operation=3D"profile_l=
oad" pid=3D2108 name=3D/usr/sbin/traceroute
[   33.553050] [drm] Initialized drm 1.1.0 20060810
[   33.848887] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   33.848900] pci 0000:00:02.0: setting latency timer to 64
[   33.870743]   alloc irq_desc for 28 on node 0
[   33.870746]   alloc kstat_irqs on node 0
[   33.870756] pci 0000:00:02.0: irq 28 for MSI/MSI-X
[   34.112329] acpi device:05: registered as cooling_device2
[   34.112893] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/device:01/input/input11
[   34.113023] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[   34.113105] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   36.696351] Bluetooth: Core ver 2.15
[   36.696523] NET: Registered protocol family 31
[   36.696529] Bluetooth: HCI device and connection manager initialized
[   36.696536] Bluetooth: HCI socket layer initialized
[   37.269452] Bluetooth: L2CAP ver 2.13
[   37.269459] Bluetooth: L2CAP socket layer initialized
[   37.348557] Bluetooth: RFCOMM TTY layer initialized
[   37.348574] Bluetooth: RFCOMM socket layer initialized
[   37.348579] Bluetooth: RFCOMM ver 1.11
[   38.200624] Bluetooth: SCO (Voice Link) ver 0.6
[   38.200632] Bluetooth: SCO socket layer initialized
[   38.953181] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   38.953189] Bluetooth: BNEP filters: protocol multicast
[   39.442504] Bridge firewalling registered
[   47.466590] rt73usb 2-1:1.0: firmware: requesting rt73.bin
[   48.672642] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   48.976492] NET: Registered protocol family 17
[   49.886651] bootsplash: status on console 0 changed to on
[ 3905.683606] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank c=
ount for disabled pipe 0

--Boundary-00=_hybhKKjtPmkRqve
Content-Type: text/x-log;
  charset="utf-8";
  name="dmesg-working-2.6.30.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-working-2.6.30.log"

[    0.000000] Linux version 2.6.30.4-15-desktop (root@flash) (gcc version =
4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP PREEMPT Fri Au=
g 14 16:13:45 WEST 2009
[    0.000000] Command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z=
86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z8=
6CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  BIOS-e820: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  BIOS-e820: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x140000 max_arch_pfn =3D 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0B8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0B7E00000 mask FFFE00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000b7e00000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xb6000 max_arch_pfn =3D 0x100000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usab=
le) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  modified: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  modified: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  modified: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  modified: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  modified: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  modified: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  modified: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  modified: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  modified: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  modified: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  modified: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  modified: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000b6000000
[    0.000000]  0000000000 - 00b6000000 page 2M
[    0.000000] kernel direct mapping tables up to b6000000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ a000-10000
[    0.000000] RAMDISK: 37a6a000 - 37fefd98
[    0.000000] ACPI: RSDP 00000000000f6e60 00024 (v02 TOSQCI)
[    0.000000] ACPI: XSDT 00000000b5ff4a00 0007C (v01 TOSQCI TOSQCI00 06040=
000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000b5fe5000 000F4 (v03 T0SQCI TOSQCI00 06040=
000 ALAN 00000001)
[    0.000000] ACPI: DSDT 00000000b5fe6000 09F7C (v02 TOSQCI CANTIGA  06040=
000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000b5f9efc0 00040
[    0.000000] ACPI: APIC 00000000b5ffed1e 00068 (v01 INTEL  CRESTLNE 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: HPET 00000000b5ffed86 00038 (v01 TOSQCI TOSQCI00 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 00000000b5ffedbe 0003C (v01 TOSQCI TOSQCI00 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: APIC 00000000b5ffedfa 00068 (v01 PTLTD  	 APIC   06040=
000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000b5ffee62 00028 (v01 PTLTD  $SBFTBL$ 06040=
000  LTP 00000001)
[    0.000000] ACPI: SLIC 00000000b5ffee8a 00176 (v01 TOSQCI TOSQCI00 06040=
000  LTP 00000000)
[    0.000000] ACPI: SSDT 00000000b5ff4aa4 00196 (v01 SataRe SataAhci 00001=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe4000 00655 (v01  PmRef    CpuPm 00003=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe3000 00259 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe2000 0020F (v01  PmRef    ApTst 00003=
000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=3D2" works better, notify linux=
=2Dacpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000022fff]
[    0.000000]   bootmap [0000000000023000 -  000000000004afff] pages 28
[    0.000000] (8 early reservations) =3D=3D> bootmem [0000000000 - 0140000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000c06870]    TEXT DATA BSS =3D=3D> [000=
0200000 - 0000c06870]
[    0.000000]   #3 [0037a6a000 - 0037fefd98]          RAMDISK =3D=3D> [003=
7a6a000 - 0037fefd98]
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000=
009f400 - 0000100000]
[    0.000000]   #5 [0000c07000 - 0000c071e4]              BRK =3D=3D> [000=
0c07000 - 0000c071e4]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f6f20] f6f20
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff88002820000=
0-ffff88002b9fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[10] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000b5aa1
[    0.000000]     0: 0x000b5aa7 -> 0x000b5bba
[    0.000000]     0: 0x000b5c0f -> 0x000b5d08
[    0.000000]     0: 0x000b5f0f -> 0x000b5f18
[    0.000000]     0: 0x000b5f1f -> 0x000b5f65
[    0.000000]     0: 0x000b5f9f -> 0x000b5fe1
[    0.000000]     0: 0x000b5fff -> 0x000b6000
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1006809
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2668 pages reserved
[    0.000000]   DMA zone: 1270 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 726391 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 00000000000=
06000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000=
d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000b5aa1000 - 00000000b5a=
a7000
[    0.000000] PM: Registered nosave memory: 00000000b5bba000 - 00000000b5c=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5d08000 - 00000000b5f=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5f18000 - 00000000b5f=
1f000
[    0.000000] PM: Registered nosave memory: 00000000b5f65000 - 00000000b5f=
9f000
[    0.000000] PM: Registered nosave memory: 00000000b5fe1000 - 00000000b5f=
ff000
[    0.000000] PM: Registered nosave memory: 00000000b6000000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at b8000000 (gap: b6000000=
:4a000000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028023000, static data 7=
2544 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 986221
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK32=
52GSX_Z86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK325=
2GSX_Z86CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2527.285 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Calgary: detecting Calgary via BIOS EBDA area
[    0.000999] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000999] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000999] Placing 64MB software IO TLB between ffff880020000000 - ffff=
880024000000
[    0.000999] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000999] Memory: 3887480k/5242880k available (5000k kernel code, 1215=
644k absent, 139756k reserved, 2428k data, 1580k init)
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.000999] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5054.57 BogoMIPS (lpj=3D2527285)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Disabled at boot.
[    0.000999] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.002581] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.003583] Mount-cache hash table entries: 256
[    0.003770] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003775] CPU: L2 cache: 3072K
[    0.003779] CPU 0/0x0 -> Node 0
[    0.003782] CPU: Physical Processor ID: 0
[    0.003785] CPU: Processor Core ID: 0
[    0.003794] CPU0: Thermal monitoring enabled (TM2)
[    0.003800] using mwait in idle threads.
[    0.004658] ACPI: Core revision 20090320
[    0.020064] Setting APIC routing to flat
[    0.020409] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1
[    0.030788] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.030995] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 5053.73 Bog=
oMIPS (lpj=3D2526869)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 3072K
[    0.000999] CPU 1/0x1 -> Node 0
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.102562] CPU1: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.102603] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.103003] Brought up 2 CPUs
[    0.103009] Total of 2 processors activated (10108.30 BogoMIPS).
[    0.103076] CPU0 attaching sched-domain:
[    0.103079]  domain 0: span 0-1 level MC
[    0.103081]   groups: 0 1
[    0.103086] CPU1 attaching sched-domain:
[    0.103088]  domain 0: span 0-1 level MC
[    0.103090]   groups: 1 0
[    0.103154] net_namespace: 1888 bytes
[    0.103154] Booting paravirtualized kernel on bare hardware
[    0.104097] regulator: core version 0.5
[    0.104097] Time: 19:06:56  Date: 08/14/09
[    0.104097] NET: Registered protocol family 16
[    0.104218] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.104224] ACPI: bus type pci registered
[    0.104293] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.104298] PCI: Not using MMCONFIG.
[    0.104301] PCI: Using configuration type 1 for base access
[    0.105052] bio: create slab <bio-0> at 0
[    0.106647] ACPI: EC: Look up EC in DSDT
[    0.112835] ACPI: BIOS _OSI(Linux) query ignored
[    0.114218] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.620003] ACPI: EC: missing confirmations, switch off interrupt mode.
[    0.781142] ACPI: Interpreter enabled
[    0.781147] ACPI: (supports S0 S3 S4 S5)
[    0.781172] ACPI: Using IOAPIC for interrupt routing
[    0.781240] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.784597] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.795143] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.802807] ACPI: EC: GPE =3D 0x18, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.802812] ACPI: EC: driver started in poll mode
[    0.803280] ACPI: No dock devices found.
[    0.803379] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.803476] pci 0000:00:02.0: reg 10 64bit mmio: [0xf4000000-0xf43fffff]
[    0.803482] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.803487] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.803521] pci 0000:00:02.1: reg 10 64bit mmio: [0xf4400000-0xf44fffff]
[    0.803641] pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
[    0.803732] pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
[    0.803823] pci 0000:00:1a.2: reg 20 io port: [0x1860-0x187f]
[    0.803917] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf4a04800-0xf4a04bff]
[    0.803984] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.803992] pci 0000:00:1a.7: PME# disabled
[    0.804051] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4800000-0xf4803fff]
[    0.804110] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.804117] pci 0000:00:1b.0: PME# disabled
[    0.804202] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.804209] pci 0000:00:1c.0: PME# disabled
[    0.804299] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.804306] pci 0000:00:1c.4: PME# disabled
[    0.804395] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.804401] pci 0000:00:1c.5: PME# disabled
[    0.804477] pci 0000:00:1d.0: reg 20 io port: [0x1880-0x189f]
[    0.804569] pci 0000:00:1d.1: reg 20 io port: [0x18a0-0x18bf]
[    0.804659] pci 0000:00:1d.2: reg 20 io port: [0x18c0-0x18df]
[    0.804752] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4a04c00-0xf4a04fff]
[    0.804820] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.804827] pci 0000:00:1d.7: PME# disabled
[    0.805081] pci 0000:00:1f.2: reg 10 io port: [0x1818-0x181f]
[    0.805088] pci 0000:00:1f.2: reg 14 io port: [0x180c-0x180f]
[    0.805095] pci 0000:00:1f.2: reg 18 io port: [0x1810-0x1817]
[    0.805102] pci 0000:00:1f.2: reg 1c io port: [0x1808-0x180b]
[    0.805110] pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
[    0.805117] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf4a04000-0xf4a047ff]
[    0.805163] pci 0000:00:1f.2: PME# supported from D3hot
[    0.805170] pci 0000:00:1f.2: PME# disabled
[    0.805213] pci 0000:00:1f.3: reg 10 64bit mmio: [0x000000-0x0000ff]
[    0.805231] pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
[    0.805317] pci 0000:00:1c.0: bridge io port: [0x00-0xfff]
[    0.805321] pci 0000:00:1c.0: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.805328] pci 0000:00:1c.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.805400] pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    0.805410] pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
[    0.805490] pci 0000:07:00.0: supports D1 D2
[    0.805492] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.805500] pci 0000:07:00.0: PME# disabled
[    0.805579] pci 0000:00:1c.4: bridge io port: [0x00-0xfff]
[    0.805583] pci 0000:00:1c.4: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.805591] pci 0000:00:1c.4: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.805680] pci 0000:08:00.0: reg 10 64bit mmio: [0x000000-0x001fff]
[    0.805794] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.805804] pci 0000:08:00.0: PME# disabled
[    0.805887] pci 0000:00:1c.5: bridge io port: [0x00-0xfff]
[    0.805892] pci 0000:00:1c.5: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.805899] pci 0000:00:1c.5: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.805942] pci 0000:0a:01.0: reg 10 32bit mmio: [0xff501000-0xff501fff]
[    0.805949] pci 0000:0a:01.0: reg 14 32bit mmio: [0xf4700000-0xf47007ff]
[    0.806002] pci 0000:0a:01.0: supports D1 D2
[    0.806004] pci 0000:0a:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.806011] pci 0000:0a:01.0: PME# disabled
[    0.806061] pci 0000:0a:01.2: reg 10 32bit mmio: [0xf4700800-0xf47008ff]
[    0.806127] pci 0000:0a:01.2: supports D1 D2
[    0.806128] pci 0000:0a:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.806136] pci 0000:0a:01.2: PME# disabled
[    0.806184] pci 0000:0a:01.3: reg 10 32bit mmio: [0xf4702000-0xf4702fff]
[    0.806249] pci 0000:0a:01.3: supports D1 D2
[    0.806251] pci 0000:0a:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.806259] pci 0000:0a:01.3: PME# disabled
[    0.806326] pci 0000:00:1e.0: transparent bridge
[    0.806335] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4700000-0xf47fffff]
[    0.806372] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.806538] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.806640] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.806727] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.824805] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *11
[    0.824960] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 =
15)
[    0.825119] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 *6 7 10 12 14 =
15)
[    0.825270] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    0.825422] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.825575] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 =
15)
[    0.825727] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 =
15)
[    0.825878] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 =
15)
[    0.826082] SCSI subsystem initialized
[    0.826109] libata version 3.00 loaded.
[    0.826109] usbcore: registered new interface driver usbfs
[    0.826109] usbcore: registered new interface driver hub
[    0.826109] usbcore: registered new device driver usb
[    0.826109] PCI: Using ACPI for IRQ routing
[    0.826109] pci 0000:00:1c.0: BAR 13: can't allocate resource
[    0.826109] pci 0000:00:1c.0: BAR 14: can't allocate resource
[    0.826109] pci 0000:00:1c.0: BAR 15: can't allocate resource
[    0.826109] pci 0000:00:1c.4: BAR 13: can't allocate resource
[    0.826109] pci 0000:00:1c.4: BAR 14: can't allocate resource
[    0.826109] pci 0000:00:1c.4: BAR 15: can't allocate resource
[    0.826109] pci 0000:00:1c.5: BAR 13: can't allocate resource
[    0.826109] pci 0000:00:1c.5: BAR 14: can't allocate resource
[    0.826109] pci 0000:00:1c.5: BAR 15: can't allocate resource
[    0.829029] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.829037] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.833008] Switched to high resolution mode on CPU 0
[    0.833644] Switched to high resolution mode on CPU 1
[    0.835007] pnp: PnP ACPI init
[    0.835016] ACPI: bus type pnp registered
[    0.836324] pnp 00:04: io resource (0x2e-0x2f) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836330] pnp 00:04: io resource (0x4e-0x4f) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836336] pnp 00:04: io resource (0x61-0x61) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836342] pnp 00:04: io resource (0x63-0x63) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836347] pnp 00:04: io resource (0x65-0x65) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836353] pnp 00:04: io resource (0x67-0x67) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836359] pnp 00:04: io resource (0x68-0x68) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836364] pnp 00:04: io resource (0x6c-0x6c) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836370] pnp 00:04: io resource (0x70-0x70) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836375] pnp 00:04: io resource (0x80-0x80) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836381] pnp 00:04: io resource (0x92-0x92) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.836386] pnp 00:04: io resource (0xb2-0xb3) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.838090] pnp: PnP ACPI: found 9 devices
[    0.838095] ACPI: ACPI bus type pnp unregistered
[    0.838105] system 00:02: iomem range 0xfed00000-0xfed003ff has been res=
erved
[    0.838114] system 00:04: ioport range 0x3e0-0x3e1 has been reserved
[    0.838119] system 00:04: ioport range 0x400-0x47f has been reserved
[    0.838123] system 00:04: ioport range 0x680-0x69f has been reserved
[    0.838127] system 00:04: ioport range 0x480-0x48f has been reserved
[    0.838132] system 00:04: ioport range 0xffff-0xffff has been reserved
[    0.838137] system 00:04: ioport range 0xffff-0xffff has been reserved
[    0.838141] system 00:04: ioport range 0x1180-0x11ff has been reserved
[    0.838146] system 00:04: ioport range 0x164e-0x164f has been reserved
[    0.838150] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    0.838158] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.838165] system 00:08: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.838169] system 00:08: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.838174] system 00:08: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.838179] system 00:08: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.838184] system 00:08: iomem range 0xfed20000-0xfed3ffff has been res=
erved
[    0.838188] system 00:08: iomem range 0xfed45000-0xfed8ffff has been res=
erved
[    0.842931] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.842935] pci 0000:00:1c.0:   IO window: disabled
[    0.842942] pci 0000:00:1c.0:   MEM window: disabled
[    0.842948] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.842970] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
[    0.842975] pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
[    0.842983] pci 0000:00:1c.4:   MEM window: 0xb8000000-0xb80fffff
[    0.842989] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.843012] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
[    0.843016] pci 0000:00:1c.5:   IO window: disabled
[    0.843023] pci 0000:00:1c.5:   MEM window: 0xb8100000-0xb81fffff
[    0.843029] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.843038] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0a
[    0.843042] pci 0000:00:1e.0:   IO window: disabled
[    0.843049] pci 0000:00:1e.0:   MEM window: 0xf4700000-0xf47fffff
[    0.843055] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.843071]   alloc irq_desc for 17 on cpu 0 node 0
[    0.843073]   alloc kstat_irqs on cpu 0 node 0
[    0.843078] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.843087] pci 0000:00:1c.0: setting latency timer to 64
[    0.843094] pci 0000:00:1c.4: enabling device (0000 -> 0003)
[    0.843100] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.843107] pci 0000:00:1c.4: setting latency timer to 64
[    0.843115] pci 0000:00:1c.5: enabling device (0000 -> 0002)
[    0.843120]   alloc irq_desc for 16 on cpu 0 node 0
[    0.843122]   alloc kstat_irqs on cpu 0 node 0
[    0.843125] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.843133] pci 0000:00:1c.5: setting latency timer to 64
[    0.843141] pci 0000:00:1e.0: setting latency timer to 64
[    0.843145] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.843147] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.843149] pci_bus 0000:02: resource 0 mem: [0x0-0xfff]
[    0.843151] pci_bus 0000:02: resource 1 mem: [0x0-0xfffff]
[    0.843153] pci_bus 0000:02: resource 2 mem: [0x0-0xfffff]
[    0.843155] pci_bus 0000:07: resource 0 io:  [0x2000-0x2fff]
[    0.843157] pci_bus 0000:07: resource 1 mem: [0xb8000000-0xb80fffff]
[    0.843159] pci_bus 0000:07: resource 2 mem: [0x0-0xfffff]
[    0.843162] pci_bus 0000:08: resource 0 mem: [0x0-0xfff]
[    0.843164] pci_bus 0000:08: resource 1 mem: [0xb8100000-0xb81fffff]
[    0.843166] pci_bus 0000:08: resource 2 mem: [0x0-0xfffff]
[    0.843168] pci_bus 0000:0a: resource 1 mem: [0xf4700000-0xf47fffff]
[    0.843170] pci_bus 0000:0a: resource 3 io:  [0x00-0xffff]
[    0.843172] pci_bus 0000:0a: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.843227] NET: Registered protocol family 2
[    0.850146] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.851291] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.854937] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.855432] TCP: Hash tables configured (established 524288 bind 65536)
[    0.855437] TCP reno registered
[    0.858112] NET: Registered protocol family 1
[    0.858178] Unpacking initramfs...
[    0.947595] Freeing initrd memory: 5655k freed
[    0.949764] Simple Boot Flag at 0x36 set to 0x1
[    0.950030] Scanning for low memory corruption every 60 seconds
[    0.950217] audit: initializing netlink socket (disabled)
[    0.950237] type=3D2000 audit(1250276816.950:1): initialized
[    0.952888] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.953008] VFS: Disk quotas dquot_6.5.2
[    0.953045] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.953178] msgmni has been set to 7603
[    0.953391] alg: No test for stdrng (krng)
[    0.953423] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.953429] io scheduler noop registered
[    0.953432] io scheduler anticipatory registered
[    0.953435] io scheduler deadline registered
[    0.953454] io scheduler cfq registered (default)
[    0.953513] pci 0000:00:02.0: Boot video device
[    0.953817]   alloc irq_desc for 24 on cpu 0 node 0
[    0.953820]   alloc kstat_irqs on cpu 0 node 0
[    0.953833] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.953851] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.954027]   alloc irq_desc for 25 on cpu 0 node 0
[    0.954029]   alloc kstat_irqs on cpu 0 node 0
[    0.954038] pcieport-driver 0000:00:1c.4: irq 25 for MSI/MSI-X
[    0.954055] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.954229]   alloc irq_desc for 26 on cpu 0 node 0
[    0.954231]   alloc kstat_irqs on cpu 0 node 0
[    0.954239] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.954256] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.954527] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20011100=
000, using 3072k, total 131008k
[    0.954534] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D84
[    0.954537] vesafb: scrolling: redraw
[    0.954541] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    0.966712] Console: switching to colour frame buffer device 128x48
[    0.978863] fb0: VESA VGA frame buffer device
[    0.980115] Non-volatile memory driver v1.3
[    0.980213] Linux agpgart interface v0.103
[    0.980308] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.980801] Driver 'sd' needs updating - please use bus_type methods
[    0.980989] ahci 0000:00:1f.2: version 3.0
[    0.981007]   alloc irq_desc for 19 on cpu 0 node 0
[    0.981009]   alloc kstat_irqs on cpu 0 node 0
[    0.981014] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.981204]   alloc irq_desc for 27 on cpu 0 node 0
[    0.981205]   alloc kstat_irqs on cpu 0 node 0
[    0.981215] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    0.981300] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
33 impl SATA mode
[    0.981489] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum pa=
rt ems=20
[    0.981660] ahci 0000:00:1f.2: setting latency timer to 64
[    0.984829] scsi0 : ahci
[    0.984970] scsi1 : ahci
[    0.985079] scsi2 : ahci
[    0.985181] scsi3 : ahci
[    0.985286] scsi4 : ahci
[    0.985389] scsi5 : ahci
[    0.985587] ata1: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0410=
0 irq 27
[    0.985759] ata2: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0418=
0 irq 27
[    0.985929] ata3: DUMMY
[    0.985986] ata4: DUMMY
[    0.986048] ata5: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0430=
0 irq 27
[    0.986219] ata6: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0438=
0 irq 27
[    0.986471] Fixed MDIO Bus: probed
[    0.986555] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.986747] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 19 (level, low) -> I=
RQ 19
[    0.988875] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.988878] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.991064] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    0.997257] ehci_hcd 0000:00:1a.7: debug port 1
[    0.999570] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.999582] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf4a04800
[    1.011006] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.013470] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.016065] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.018756] usb usb1: Product: EHCI Host Controller
[    1.021507] usb usb1: Manufacturer: Linux 2.6.30.4-15-desktop ehci_hcd
[    1.024395] usb usb1: SerialNumber: 0000:00:1a.7
[    1.027372] usb usb1: configuration #1 chosen from 1 choice
[    1.030429] hub 1-0:1.0: USB hub found
[    1.033518] hub 1-0:1.0: 6 ports detected
[    1.036760]   alloc irq_desc for 23 on cpu 0 node 0
[    1.036762]   alloc kstat_irqs on cpu 0 node 0
[    1.036767] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    1.040088] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.040092] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.043459] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    1.050838] ehci_hcd 0000:00:1d.7: debug port 1
[    1.054352] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.054365] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf4a04c00
[    1.067008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.070670] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.074459] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.078345] usb usb2: Product: EHCI Host Controller
[    1.082291] usb usb2: Manufacturer: Linux 2.6.30.4-15-desktop ehci_hcd
[    1.086375] usb usb2: SerialNumber: 0000:00:1d.7
[    1.090426] usb usb2: configuration #1 chosen from 1 choice
[    1.094453] hub 2-0:1.0: USB hub found
[    1.098443] hub 2-0:1.0: 6 ports detected
[    1.102483] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.106502] uhci_hcd: USB Universal Host Controller Interface driver
[    1.110542] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    1.114557] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.114560] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.118510] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    1.122498] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    1.126419] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.130451] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.134575] usb usb3: Product: UHCI Host Controller
[    1.138775] usb usb3: Manufacturer: Linux 2.6.30.4-15-desktop uhci_hcd
[    1.143075] usb usb3: SerialNumber: 0000:00:1a.0
[    1.147446] usb usb3: configuration #1 chosen from 1 choice
[    1.151780] hub 3-0:1.0: USB hub found
[    1.156142] hub 3-0:1.0: 2 ports detected
[    1.160510]   alloc irq_desc for 21 on cpu 0 node 0
[    1.160512]   alloc kstat_irqs on cpu 0 node 0
[    1.160516] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    1.164982] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.164985] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.169384] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[    1.173918] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    1.178377] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.182848] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.187303] usb usb4: Product: UHCI Host Controller
[    1.191735] usb usb4: Manufacturer: Linux 2.6.30.4-15-desktop uhci_hcd
[    1.196218] usb usb4: SerialNumber: 0000:00:1a.1
[    1.200700] usb usb4: configuration #1 chosen from 1 choice
[    1.205247] hub 4-0:1.0: USB hub found
[    1.209734] hub 4-0:1.0: 2 ports detected
[    1.214218] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 19 (level, low) -> I=
RQ 19
[    1.218724] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.218727] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.223168] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[    1.227653] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001860
[    1.232099] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.236599] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.241103] usb usb5: Product: UHCI Host Controller
[    1.245630] usb usb5: Manufacturer: Linux 2.6.30.4-15-desktop uhci_hcd
[    1.250172] usb usb5: SerialNumber: 0000:00:1a.2
[    1.254717] usb usb5: configuration #1 chosen from 1 choice
[    1.259266] hub 5-0:1.0: USB hub found
[    1.263775] hub 5-0:1.0: 2 ports detected
[    1.268333] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    1.272944] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.272948] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.277485] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[    1.282076] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
[    1.286608] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.291166] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.295727] usb usb6: Product: UHCI Host Controller
[    1.300272] usb usb6: Manufacturer: Linux 2.6.30.4-15-desktop uhci_hcd
[    1.301283] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.309541] usb usb6: SerialNumber: 0000:00:1d.0
[    1.309783] ACPI Warning (nspredef-0943): \_SB_.PCI0.SAT0.PRT0._GTF: Ret=
urn type mismatch - found Integer, expected Buffer [20090320]
[    1.309789] ata1.00: _GTF unexpected object type 0x1
[    1.328775] usb usb6: configuration #1 chosen from 1 choice
[    1.329267] ata6: SATA link down (SStatus 0 SControl 300)
[    1.329286] ata5: SATA link down (SStatus 0 SControl 300)
[    1.329305] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.331039] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.50, max UDMA/33
[    1.341031] ata1.00: ATA-8: TOSHIBA MK3252GSX, LV010M, max UDMA/100
[    1.341033] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.342702] ata2.00: configured for UDMA/33
[    1.343563] ata1.00: _GTF unexpected object type 0x1
[    1.343960] ata1.00: configured for UDMA/100
[    1.344068] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3252GS LV=
01 PQ: 0 ANSI: 5
[    1.344199] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 =
GB/298 GiB)
[    1.344213] sd 0:0:0:0: [sda] Write Protect is off
[    1.344215] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.344235] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.344323]  sda:<3>ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action =
0xf t4
[    1.390695] ata2: irq_stat 0x40000001
[    1.390698] ata2: hard resetting link
[    1.390710]  sda1 sda2
[    1.416539] hub 6-0:1.0: USB hub found
[    1.416588] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.417267] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[    1.431104] hub 6-0:1.0: 2 ports detected
[    1.436113] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    1.441103] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.441107] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.446065] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[    1.451073] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018a0
[    1.456079] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.461041] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.466015] usb usb7: Product: UHCI Host Controller
[    1.470931] usb usb7: Manufacturer: Linux 2.6.30.4-15-desktop uhci_hcd
[    1.475889] usb usb7: SerialNumber: 0000:00:1d.1
[    1.480837] usb usb7: configuration #1 chosen from 1 choice
[    1.485791] hub 7-0:1.0: USB hub found
[    1.490689] hub 7-0:1.0: 2 ports detected
[    1.495673]   alloc irq_desc for 18 on cpu 0 node 0
[    1.495675]   alloc kstat_irqs on cpu 0 node 0
[    1.495679] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    1.500648] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.500651] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.505587] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[    1.510587] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
[    1.515540] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.520492] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.525448] usb usb8: Product: UHCI Host Controller
[    1.530359] usb usb8: Manufacturer: Linux 2.6.30.4-15-desktop uhci_hcd
[    1.535297] usb usb8: SerialNumber: 0000:00:1d.2
[    1.540220] usb usb8: configuration #1 chosen from 1 choice
[    1.545106] hub 8-0:1.0: USB hub found
[    1.549838] hub 8-0:1.0: 2 ports detected
[    1.554458] Initializing USB Mass Storage driver...
[    1.554703] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0606
[    1.554705] usb 1-1: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    1.554707] usb 1-1: Product: USB2.0 Hub
[    1.554744] usb 1-1: configuration #1 chosen from 1 choice
[    1.577372] hub 1-1:1.0: USB hub found
[    1.577387] usbcore: registered new interface driver usb-storage
[    1.577389] USB Mass Storage support registered.
[    1.577420] usbcore: registered new interface driver libusual
[    1.577431] usbcore: registered new interface driver ums-alauda
[    1.577442] usbcore: registered new interface driver ums-cypress
[    1.577453] usbcore: registered new interface driver ums-datafab
[    1.577463] usbcore: registered new interface driver ums-freecom
[    1.577476] usbcore: registered new interface driver ums-isd200
[    1.577487] usbcore: registered new interface driver ums-jumpshot
[    1.577497] usbcore: registered new interface driver ums-karma
[    1.577508] usbcore: registered new interface driver ums-onetouch
[    1.577519] usbcore: registered new interface driver ums-sddr09
[    1.577529] usbcore: registered new interface driver ums-sddr55
[    1.577540] usbcore: registered new interface driver ums-usbat
[    1.577582] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x6=
4 irq 1,12
[    1.645193] hub 1-1:1.0: 4 ports detected
[    1.645536] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.647860] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.647865] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.647868] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.647870] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.647872] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.647909] mice: PS/2 mouse device common for all mice
[    1.648007] rtc_cmos 00:05: RTC can wake from S4
[    1.648043] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.648074] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.648084] cpuidle: using governor ladder
[    1.648085] cpuidle: using governor menu
[    1.648311] usbcore: registered new interface driver hiddev
[    1.648323] usbcore: registered new interface driver usbhid
[    1.648325] usbhid: v2.6:USB HID core driver
[    1.702943] TCP cubic registered
[    1.706406] NET: Registered protocol family 10
[    1.710162] lo: Disabled Privacy Extensions
[    1.713770] lib80211: common routines for IEEE802.11 drivers
[    1.717123] lib80211_crypt: registered algorithm 'NULL'
[    1.717180] PM: Checking image partition /dev/disk/by-id/ata-TOSHIBA_MK3=
252GSX_Z86CSPDUS-part1
[    1.731279] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    1.863010] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 2
[    2.122138] usb 2-1: New USB device found, idVendor=3D07d1, idProduct=3D=
3c03
[    2.125645] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.129176] usb 2-1: Product: 802.11 bg WLAN
[    2.132659] usb 2-1: Manufacturer: Ralink
[    2.136193] usb 2-1: configuration #1 chosen from 1 choice
[    2.170018] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.177253] ata2.00: configured for UDMA/33
[    2.182304] ata2: EH complete
[    2.197757] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.=
50 PQ: 0 ANSI: 5
[    2.201430] PM: Resume from disk failed.
[    2.201446] registered taskstats version 1
[    2.205162]   Magic number: 5:145:142
[    2.208715] acpi device:13: hash matches
[    2.212235] rtc_cmos 00:05: setting system clock to 2009-08-14 19:06:58 =
UTC (1250276818)
[    2.215935] Freeing unused kernel memory: 1580k freed
[    2.220103] Write protecting the kernel read-only data: 6960k
[    2.241276] usb 2-4: new high speed USB device using ehci_hcd and addres=
s 3
[    2.269522] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    2.284283] udevd version 128 started
[    2.373113] usb 2-4: New USB device found, idVendor=3D04f2, idProduct=3D=
b008
[    2.377803] usb 2-4: New USB device strings: Mfr=3D2, Product=3D1, Seria=
lNumber=3D3
[    2.382390] usb 2-4: Product: Chicony USB 2.0 Camera
[    2.386852] usb 2-4: Manufacturer: Chicony Electronics Co., Ltd.
[    2.391336] usb 2-4: SerialNumber: SN0001
[    2.396037] usb 2-4: configuration #1 chosen from 1 choice
[    2.540835] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1e0b1, caps: 0x=
d04711/0xa00000
[    2.579131] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio4/input/input1
[    2.595499] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[    2.595502] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.595506] PM: Marking nosave pages: 00000000b5aa1000 - 00000000b5aa7000
[    2.595508] PM: Marking nosave pages: 00000000b5bba000 - 00000000b5c0f000
[    2.595512] PM: Marking nosave pages: 00000000b5d08000 - 00000000b5f0f000
[    2.595525] PM: Marking nosave pages: 00000000b5f18000 - 00000000b5f1f000
[    2.595527] PM: Marking nosave pages: 00000000b5f65000 - 00000000b5f9f000
[    2.595530] PM: Marking nosave pages: 00000000b5fe1000 - 00000000b5fff000
[    2.595533] PM: Marking nosave pages: 00000000b6000000 - 0000000100000000
[    2.596471] PM: Basic memory bitmaps created
[    2.608023] usb 3-2: new low speed USB device using uhci_hcd and address=
 2
[    2.723203] PM: Basic memory bitmaps freed
[    2.730306] PM: Starting manual resume from disk
[    2.730309] PM: Resume from partition 259:0
[    2.730310] PM: Checking hibernation image.
[    2.735672] PM: Resume from disk failed.
[    2.802232] usb 3-2: New USB device found, idVendor=3D046d, idProduct=3D=
c50a
[    2.808083] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.813947] usb 3-2: Product: USB Receiver
[    2.819774] usb 3-2: Manufacturer: Logitech
[    2.825550] usb 3-2: configuration #1 chosen from 1 choice
[    2.851493] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1a.0/usb3/3-2/3-2:1.0/input/input2
[    2.857381] generic-usb 0003:046D:C50A.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-2/input0
[    2.931307] usb 1-1.1: new high speed USB device using ehci_hcd and addr=
ess 4
[    3.044289] usb 1-1.1: New USB device found, idVendor=3D059b, idProduct=
=3D0370
[    3.050417] usb 1-1.1: New USB device strings: Mfr=3D2, Product=3D3, Ser=
ialNumber=3D1
[    3.056529] usb 1-1.1: Product: External HD
[    3.062575] usb 1-1.1: Manufacturer: Iomega
[    3.068625] usb 1-1.1: SerialNumber: 152000000733
[    3.074818] usb 1-1.1: configuration #1 chosen from 1 choice
[    3.082424] scsi6 : SCSI emulation for USB Mass Storage devices
[    3.088547] usb-storage: device found at 4
[    3.088549] usb-storage: waiting for device to settle before scanning
[    3.162529] usb 1-1.2: new high speed USB device using ehci_hcd and addr=
ess 5
[    3.229160] kjournald starting.  Commit interval 5 seconds
[    3.229298] EXT3 FS on sda2, internal journal
[    3.229303] EXT3-fs: mounted filesystem with ordered data mode.
[    3.261389] usb 1-1.2: New USB device found, idVendor=3D1058, idProduct=
=3D1001
[    3.267660] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    3.274004] usb 1-1.2: Product: External HDD   =20
[    3.280273] usb 1-1.2: Manufacturer: Western Digital=20
[    3.286491] usb 1-1.2: SerialNumber: 574341505732323139323037
[    3.292805] usb 1-1.2: configuration #1 chosen from 1 choice
[    3.299445] scsi7 : SCSI emulation for USB Mass Storage devices
[    3.306171] usb-storage: device found at 5
[    3.306173] usb-storage: waiting for device to settle before scanning
[    3.368266] usb 1-1.4: new high speed USB device using ehci_hcd and addr=
ess 6
[    3.450368] usb 1-1.4: New USB device found, idVendor=3D05e3, idProduct=
=3D0606
[    3.456648] usb 1-1.4: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    3.462933] usb 1-1.4: Product: USB2.0 Hub
[    3.469264] usb 1-1.4: configuration #1 chosen from 1 choice
[    3.475766] hub 1-1.4:1.0: USB hub found
[    3.482239] hub 1-1.4:1.0: 4 ports detected
[    3.763335] usb 1-1.4.2: new high speed USB device using ehci_hcd and ad=
dress 7
[    3.858946] usb 1-1.4.2: New USB device found, idVendor=3D05e3, idProduc=
t=3D070e
[    3.864872] usb 1-1.4.2: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    3.870795] usb 1-1.4.2: Product: USB Storage
[    3.876529] usb 1-1.4.2: SerialNumber: 000000009601
[    3.882216] usb 1-1.4.2: configuration #1 chosen from 1 choice
[    3.888384] scsi8 : SCSI emulation for USB Mass Storage devices
[    3.893978] usb-storage: device found at 7
[    3.893980] usb-storage: waiting for device to settle before scanning
[    3.968315] usb 1-1.4.3: new high speed USB device using ehci_hcd and ad=
dress 8
[    4.048926] usb 1-1.4.3: New USB device found, idVendor=3D03f0, idProduc=
t=3D5611
[    4.054478] usb 1-1.4.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    4.059923] usb 1-1.4.3: Product: Photosmart C3100 series
[    4.065257] usb 1-1.4.3: Manufacturer: HP
[    4.070523] usb 1-1.4.3: SerialNumber: MY68SC52KM04P9
[    4.075826] usb 1-1.4.3: configuration #1 chosen from 1 choice
[    4.081614] scsi9 : SCSI emulation for USB Mass Storage devices
[    4.087001] usb-storage: device found at 8
[    4.087003] usb-storage: waiting for device to settle before scanning
[    4.160291] usb 1-1.4.4: new high speed USB device using ehci_hcd and ad=
dress 9
[    4.315395] usb 1-1.4.4: New USB device found, idVendor=3D0402, idProduc=
t=3D5621
[    4.320496] usb 1-1.4.4: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    4.325563] usb 1-1.4.4: Product: USB 2.0 Storage Device
[    4.330583] usb 1-1.4.4: SerialNumber: 00042222200000014305
[    4.335645] usb 1-1.4.4: configuration #1 chosen from 1 choice
[    4.340832] scsi10 : SCSI emulation for USB Mass Storage devices
[    4.346037] usb-storage: device found at 9
[    4.346039] usb-storage: waiting for device to settle before scanning
[    6.337596] udevd version 128 started
[    7.052486] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.057065] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    7.251650] agpgart-intel 0000:00:00.0: Intel Mobile Intel=C2=AE GM45 Ex=
press Chipset
[    7.257297] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    7.263993] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    7.336681] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    7.627296] cfg80211: Calling CRDA to update world regulatory domain
[    7.644422] ACPI: AC Adapter [ACAD] (on-line)
[    8.039228] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input4
[    8.044073] ACPI: Power Button [PWRF]
[    8.091994] scsi 6:0:0:0: Direct-Access     ST336032 0AS                =
   PQ: 0 ANSI: 2
[    8.096983] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    8.102854] sd 6:0:0:0: [sdb] 703282608 512-byte hardware sectors: (360 =
GB/335 GiB)
[    8.110229] sd 6:0:0:0: [sdb] Write Protect is off
[    8.115274] sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00
[    8.115276] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.120604] usb-storage: device scan complete
[    8.123470] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.128285]  sdb:<6>cfg80211: World regulatory domain updated:
[    8.222368] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max=
_eirp)
[    8.227241] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.306591] scsi 7:0:0:0: Direct-Access     WD       5000AAJ External 1.=
06 PQ: 0 ANSI: 0
[    8.311774] sd 7:0:0:0: Attached scsi generic sg3 type 0
[    8.317460] sd 7:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 =
GB/465 GiB)
[    8.324089] sd 7:0:0:0: [sdc] Write Protect is off
[    8.329156] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[    8.329158] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    8.335581] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    8.335587] usb-storage: device scan complete
[    8.340555]  sdc: sdc1
[    8.346134] sd 7:0:0:0: [sdc] Attached SCSI disk
[    8.365280] sky2 driver version 1.22
[    8.370406] sky2 0000:07:00.0: enabling device (0000 -> 0003)
[    8.375324] sky2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.380277] sky2 0000:07:00.0: setting latency timer to 64
[    8.380359] sky2 0000:07:00.0: Yukon-2 FE+ chip revision 0
[    8.385425]   alloc irq_desc for 28 on cpu 0 node 0
[    8.385427]   alloc kstat_irqs on cpu 0 node 0
[    8.385444] sky2 0000:07:00.0: irq 28 for MSI/MSI-X
[    8.385674] iTCO_vendor_support: vendor-support=3D0
[    8.386877] sky2 eth0: addr 00:23:8b:67:11:3b
[    8.420965] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) ->=
 IRQ 19
[    8.458203] ACPI: Battery Slot [BAT1] (battery present)
[    8.463232] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input5
[    8.468404] ACPI: Power Button [PWRB]
[    8.473869] ACPI: WMI: Mapper loaded
[    8.476325] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input6
[    8.476569] ACPI: Lid Switch [LID]
[    8.528090] thermal LNXTHERM:01: registered as thermal_zone0
[    8.533208] ACPI: Thermal Zone [THRM] (56 C)
[    8.590225] usblp0: USB Bidirectional printer dev 8 if 1 alt 0 proto 2 v=
id 0x03F0 pid 0x5611
[    8.595611] usbcore: registered new interface driver usblp
[    8.625339] ACPI: SSDT 00000000b5f1ac20 00265 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20061109)
[    8.631509] ACPI: SSDT 00000000b5f18620 00594 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20061109)
[    8.639093] ACPI Warning (processor_throttling-0843): Invalid throttling=
 state, reset [20090320]
[    8.644984] Monitor-Mwait will be used to enter C-1 state
[    8.645010] Monitor-Mwait will be used to enter C-2 state
[    8.645048] Monitor-Mwait will be used to enter C-3 state
[    8.645051] Marking TSC unstable due to TSC halts in idle
[    8.650588] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    8.656190] processor ACPI_CPU:00: registered as cooling_device0
[    8.661567] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.667554] ACPI: SSDT 00000000b5f19ca0 001CF (v01  PmRef    ApIst 00003=
000 INTL 20061109)
[    8.673621] ACPI: SSDT 00000000b5f19f20 0008D (v01  PmRef    ApCst 00003=
000 INTL 20061109)
[    8.679893] ACPI Warning (processor_throttling-0843): Invalid throttling=
 state, reset [20090320]
[    8.685859] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    8.692147] processor ACPI_CPU:01: registered as cooling_device1
[    8.697693] ACPI: Processor [CPU1] (supports 8 throttling states)
[    8.894372] scsi 8:0:0:0: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    8.899948] sd 8:0:0:0: Attached scsi generic sg4 type 0
[    8.905866] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[    8.911701] scsi 8:0:0:1: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    8.917255] sd 8:0:0:1: Attached scsi generic sg5 type 0
[    8.923352] sd 8:0:0:1: [sde] Attached SCSI removable disk
[    8.929306] scsi 8:0:0:2: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    8.935147] sd 8:0:0:2: Attached scsi generic sg6 type 0
[    8.941752] sd 8:0:0:2: [sdf] Attached SCSI removable disk
[    8.947806] scsi 8:0:0:3: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    8.953540] sd 8:0:0:3: Attached scsi generic sg7 type 0
[    8.960106] sd 8:0:0:3: [sdg] Attached SCSI removable disk
[    8.965736] usb-storage: device scan complete
[    9.087868] scsi 9:0:0:0: Direct-Access     HP       Photosmart C3180 1.=
00 PQ: 0 ANSI: 2
[    9.093510] sd 9:0:0:0: Attached scsi generic sg8 type 0
[    9.099741] sd 9:0:0:0: [sdh] Attached SCSI removable disk
[    9.105532] usb-storage: device scan complete
[    9.347368] scsi 10:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-W162C T=
S09 PQ: 0 ANSI: 0
[    9.353167] scsi 10:0:0:0: Attached scsi generic sg9 type 5
[    9.359665] usb-storage: device scan complete
[    9.500062] Clocksource tsc unstable (delta =3D -366423927 ns)
[   12.440114]  sdb1
[   12.445837] sd 6:0:0:0: [sdb] Attached SCSI disk
[   12.622105] ohci1394 0000:0a:01.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   12.679308] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[16]  MMIO=3D=
[ff501000-ff5017ff]  Max Packet=3D[2048]  IR/IT contexts=3D[8/8]
[   13.004508] Driver 'sr' needs updating - please use bus_type methods
[   13.014032] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[   13.020090] Uniform CD-ROM driver Revision: 3.20
[   13.026304] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   13.035971] sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   13.042218] sr 10:0:0:0: Attached scsi CD-ROM sr1
[   13.043779] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   13.049930] iTCO_wdt: Found a ICH9M TCO device (Version=3D2, TCOBASE=3D0=
x0460)
[   13.056096] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   13.201543] sdhci: Secure Digital Host Controller Interface driver
[   13.207411] sdhci: Copyright(c) Pierre Ossman
[   13.360376] Linux video capture interface: v2.00
[   13.617390] sdhci-pci 0000:0a:01.2: SDHCI controller found [1217:7120] (=
rev 2)
[   13.623457] sdhci-pci 0000:0a:01.2: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16
[   13.629432] mmc0: Unknown controller version (2). You may experience pro=
blems.
[   13.635375] Registered led device: mmc0::
[   13.641203] mmc0: SDHCI controller on PCI [0000:0a:01.2] using DMA
[   13.800135] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27kds
[   13.805978] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   13.811871] iwlagn 0000:08:00.0: enabling device (0000 -> 0002)
[   13.817688] iwlagn 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   13.823437] iwlagn 0000:08:00.0: setting latency timer to 64
[   13.823518] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100A=
GN REV=3D0x54
[   13.851383] iwlagn 0000:08:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[   13.857255]   alloc irq_desc for 29 on cpu 0 node 0
[   13.857258]   alloc kstat_irqs on cpu 0 node 0
[   13.857281] iwlagn 0000:08:00.0: irq 29 for MSI/MSI-X
[   13.874056] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   13.938234] uvcvideo: Found UVC 1.00 device Chicony USB 2.0 Camera (04f2=
:b008)
[   13.947323] input: Chicony USB 2.0 Camera as /devices/pci0000:00/0000:00=
:1d.7/usb2/2-4/2-4:1.0/input/input7
[   13.953346] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b240001542c=
7b]
[   13.953431] usbcore: registered new interface driver uvcvideo
[   13.959370] USB Video Class driver (v0.1.0)
[   13.986181]   alloc irq_desc for 22 on cpu 0 node 0
[   13.986185]   alloc kstat_irqs on cpu 0 node 0
[   13.986193] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[   13.992269] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.101647] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/inp=
ut/input8
[   14.107668] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/inp=
ut/input9
[   14.113555] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/input/input10
[   14.231292] phy1: Selected rate control algorithm 'minstrel'
[   14.231873] Registered led device: rt73usb-phy1::radio
[   14.237774] Registered led device: rt73usb-phy1::assoc
[   14.243513] Registered led device: rt73usb-phy1::quality
[   14.249870] usbcore: registered new interface driver rt73usb
[   14.765800] Adding 4200956k swap on /dev/sda1.  Priority:-1 extents:1 ac=
ross:4200956k=20
[   15.798788] device-mapper: uevent: version 1.0.3
[   15.804720] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   16.230998] loop: module loaded
[   17.183110] fuse init (API version 7.11)
[   35.530624] [drm] Initialized drm 1.1.0 20060810
[   36.292178] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   36.292191] pci 0000:00:02.0: setting latency timer to 64
[   36.318192]   alloc irq_desc for 30 on cpu 0 node 0
[   36.318196]   alloc kstat_irqs on cpu 0 node 0
[   36.318206] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[   36.378925] acpi device:05: registered as cooling_device2
[   36.380238] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/device:01/input/input11
[   36.380351] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[   36.380436] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   38.844509] Bluetooth: Core ver 2.15
[   38.844554] NET: Registered protocol family 31
[   38.844556] Bluetooth: HCI device and connection manager initialized
[   38.844559] Bluetooth: HCI socket layer initialized
[   40.322730] Bluetooth: L2CAP ver 2.13
[   40.322737] Bluetooth: L2CAP socket layer initialized
[   43.583448] Bluetooth: RFCOMM socket layer initialized
[   43.583465] Bluetooth: RFCOMM TTY layer initialized
[   43.583470] Bluetooth: RFCOMM ver 1.11
[   43.686585] Bluetooth: SCO (Voice Link) ver 0.6
[   43.686592] Bluetooth: SCO socket layer initialized
[   44.554090] sky2 eth0: enabling interface
[   44.554675] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   44.592500] rt73usb 2-1:1.0: firmware: requesting rt73.bin
[   45.031727] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   45.034407] iwlagn 0000:08:00.0: firmware: requesting iwlwifi-5000-2.uco=
de
[   45.138666] iwlagn 0000:08:00.0: loaded firmware version 8.24.2.12
[   45.275467] Registered led device: iwl-phy0::radio
[   45.275998] Registered led device: iwl-phy0::assoc
[   45.278984] Registered led device: iwl-phy0::RX
[   45.279048] Registered led device: iwl-phy0::TX
[   45.285366] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   45.574810] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   45.574818] Bluetooth: BNEP filters: protocol multicast
[   45.875977] NET: Registered protocol family 17
[   46.787576] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control=
 both
[   46.789359] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   47.916094] Bridge firewalling registered
[   54.250106] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank c=
ount for disabled pipe 0
[   57.213542] eth0: no IPv6 routers present

--Boundary-00=_hybhKKjtPmkRqve--
