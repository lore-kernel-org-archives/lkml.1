Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZIKSdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZIKSdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZIKSdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:33:41 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64622 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZIKSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :message-id;
        b=soABXQ//2rpMAeTqhPMVaGnTFh5Vr3trvsU38kVhDjEtGf3MJ7hjZQ4VLLgiZNDvPj
         j6egJOUFxW879NKuvPIVMV5TTckM8Zcm2q2kJ6Pz4ZLja5ieeLQTeiVUAp0jsZ5e5mWD
         nf56Ah6wu6Ed1kyImmwQQ1mh+aVrYWl2s4FO4=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Fri, 11 Sep 2009 20:33:34 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+fpqKqdL+aBp3Yt"
Message-Id: <200909112033.34445.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_+fpqKqdL+aBp3Yt
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

this is with 2.6.31+reiser4+fglrx
Phenom II X4 955

KDE 4.3.1, composite temporary disabled.
tvtime running.

load:=20
fat emerge with make -j5 running in one konsole tab (xulrunner being=20
compiled).

without NO_NEW_FAIR_SLEEPERS:

tvtime is smooth most of the time

with NO_NEW_FAIR_SLEEPERS:

tvtime is more jerky. Very visible in scenes with movement.

without background load:

both settings act the same. tvtime is smooth, video is smooth, games are ni=
ce.=20
No real difference.

config is attached.

Gl=FCck Auf,
Volker

dmesg:

[    0.000000] Linux version 2.6.31r4 (root@energy) (gcc version 4.4.1 (Gen=
too=20
4.4.1 p1.0) ) #1 SMP Thu Sep 10 10:48:07 CEST 2009
[    0.000000] Command line: root=3D/dev/md1 md=3D3,/dev/sda3,/dev/sdb3,/de=
v/sdc3=20
nmi_watchdog=3D0 mtrr_spare_reg_nr=3D1
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)
[    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around =
it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le)=20
=3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x238000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000238000000 aka 9088M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new=20
0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usab=
le)=20
=3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xc7eb0 max_arch_pfn =3D 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7eb0000 (usable)
[    0.000000]  modified: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
[    0.000000]  modified: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
[    0.000000]  modified: 00000000c7ef0000 - 00000000c7f00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00c7e00000 page 2M
[    0.000000]  00c7e00000 - 00c7eb0000 page 4k
[    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0238000000 page 2M
[    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000
[    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090=
506=20
MSFT 00000097)
[    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000=
601=20
MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000=
121=20
INTL 20051117)
[    0.000000] ACPI: FACS 00000000c7ec0000 00040
[    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090=
506=20
MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090=
506=20
MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090=
506=20
MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090=
506=20
MSFT 00000097)
[    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090=
506=20
MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000=
001=20
AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 0238000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000=20
=2D 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000=20
=2D 0000008000]
[    0.000000]   #2 [0001000000 - 00015fb8c0]    TEXT DATA BSS =3D=3D> [000=
1000000=20
=2D 00015fb8c0]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009fc00=20
=2D 0000100000]
[    0.000000]   #4 [00015fc000 - 00015fc133]              BRK =3D=3D> [000=
15fc000=20
=2D 00015fc133]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE =3D=3D> [000=
0010000=20
=2D 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE =3D=3D> [000=
0012000=20
=2D 0000013000]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff88002860000=
0-
ffff88002f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00238000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000c7eb0
[    0.000000]     0: 0x00100000 -> 0x00238000
[    0.000000] On node 0 totalpages: 2096703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31
[    0.000000]   Normal zone: 17472 pages used for memmap
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 -=20
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -=20
00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 -=20
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7eb0000 -=20
00000000c7ec0000
[    0.000000] PM: Registered nosave memory: 00000000c7ec0000 -=20
00000000c7ef0000
[    0.000000] PM: Registered nosave memory: 00000000c7ef0000 -=20
00000000c7f00000
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 -=20
00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 -=20
0000000100000000
[    0.000000] Allocating PCI resources starting at c7f00000 (gap:=20
c7f00000:38000000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028034000, static data 7=
2160=20
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l=20
pages: 2064793
[    0.000000] Kernel command line: root=3D/dev/md1=20
md=3D3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=3D0 mtrr_spare_reg_nr=3D1
[    0.000000] md: Will configure md3 (super-block) from=20
/dev/sda3,/dev/sdb3,/dev/sdc3, below.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
=20
bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304=20
bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 2a42000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 -=20
0000000024000000
[    0.000000] Memory: 8184476k/9306112k available (3500k kernel code, 9193=
00k=20
absent, 201380k reserved, 1751k data, 376k init)
[    0.000000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D4,=20
Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3200.214 MHz processor.
[    0.000609] Console: colour VGA+ 80x25
[    0.000611] console [tty0] enabled
[    0.003333] hpet clockevent registered
[    0.003333]   alloc irq_desc for 24 on node 0
[    0.003333]   alloc kstat_irqs on node 0
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu=20
timer
[    0.003339] Calibrating delay loop (skipped), value calculated using tim=
er=20
frequency.. 6402.10 BogoMIPS (lpj=3D10667366)
[    0.003421] Mount-cache hash table entries: 256
[    0.003543] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[    0.003578] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003613] tseg: 0000000000
[    0.003618] CPU: Physical Processor ID: 0
[    0.003652] CPU: Processor Core ID: 0
[    0.003686] mce: CPU supports 6 MCE banks
[    0.003725] using C1E aware idle routine
[    0.003768] ACPI: Core revision 20090521
[    0.016704] Setting APIC routing to flat
[    0.017026] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1
[    0.050860] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.053333] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6402.85=20
BogoMIPS (lpj=3D10666966)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new=20
0x7010600070106
[    0.144161] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.144507] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.146699] Booting processor 2 APIC 0x2 ip 0x6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 6402.85=20
BogoMIPS (lpj=3D10666970)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new=20
0x7010600070106
[    0.240822] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.241168] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.243373] Booting processor 3 APIC 0x3 ip 0x6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 6402.85=20
BogoMIPS (lpj=3D10666972)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new=20
0x7010600070106
[    0.337491] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02
[    0.337836] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.340006] Brought up 4 CPUs
[    0.340040] Total of 4 processors activated (25611.67 BogoMIPS).
[    0.340109] CPU0 attaching sched-domain:
[    0.340111]  domain 0: span 0-3 level MC
[    0.340112]   groups: 0 1 2 3
[    0.340116] CPU1 attaching sched-domain:
[    0.340117]  domain 0: span 0-3 level MC
[    0.340118]   groups: 1 2 3 0
[    0.340120] CPU2 attaching sched-domain:
[    0.340121]  domain 0: span 0-3 level MC
[    0.340122]   groups: 2 3 0 1
[    0.340125] CPU3 attaching sched-domain:
[    0.340126]  domain 0: span 0-3 level MC
[    0.340127]   groups: 3 0 1 2
[    0.340162] xor: automatically using best checksumming function:=20
generic_sse
[    0.356667]    generic_sse: 12835.200 MB/sec
[    0.356700] xor: using function: generic_sse (12835.200 MB/sec)
[    0.356754] Time:  7:07:42  Date: 09/11/09
[    0.356802] NET: Registered protocol family 16
[    0.356851] node 0 link 0: io port [1000, ffffff]
[    0.356851] TOM: 00000000c8000000 aka 3200M
[    0.356851] Fam 10h mmconf [e0000000, efffffff]
[    0.356851] node 0 link 0: mmio [e0000000, efffffff] =3D=3D> none
[    0.356851] node 0 link 0: mmio [f0000000, ffffffff]
[    0.356851] node 0 link 0: mmio [a0000, bffff]
[    0.356851] node 0 link 0: mmio [c8000000, dfffffff]
[    0.356851] TOM2: 0000000238000000 aka 9088M
[    0.356851] bus: [00,07] on node 0 link 0
[    0.356851] bus: 00 index 0 io port: [0, ffff]
[    0.356851] bus: 00 index 1 mmio: [f0000000, ffffffff]
[    0.356851] bus: 00 index 2 mmio: [a0000, bffff]
[    0.356851] bus: 00 index 3 mmio: [c8000000, dfffffff]
[    0.356851] bus: 00 index 4 mmio: [238000000, fcffffffff]
[    0.356851] ACPI: bus type pci registered
[    0.356851] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.356851] PCI: Not using MMCONFIG.
[    0.356851] PCI: Using configuration type 1 for base access
[    0.356851] PCI: Using configuration type 1 for extended access
[    0.356851] bio: create slab <bio-0> at 0
[    0.356978] ACPI: EC: Look up EC in DSDT
[    0.367031] ACPI: Interpreter enabled
[    0.367538] ACPI: (supports S0 S1 S3 S4 S5)
[    0.367652] ACPI: Using IOAPIC for interrupt routing
[    0.367725] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.370531] PCI: MCFG area at e0000000 reserved in ACPI motherboard=20
resources
[    0.375947] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.380367] ACPI: No dock devices found.
[    0.380451] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.380520] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.380520] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.380520] pci 0000:00:02.0: PME# disabled
[    0.380520] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.380520] pci 0000:00:09.0: PME# disabled
[    0.380520] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.380520] pci 0000:00:0a.0: PME# disabled
[    0.380520] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]
[    0.380520] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]
[    0.380520] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]
[    0.380520] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]
[    0.380520] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]
[    0.380520] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]
[    0.380520] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]
[    0.380520] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]
[    0.380576] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]
[    0.380625] pci 0000:00:12.2: supports D1 D2
[    0.380626] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.380663] pci 0000:00:12.2: PME# disabled
[    0.380724] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]
[    0.380775] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]
[    0.380843] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]
[    0.380893] pci 0000:00:13.2: supports D1 D2
[    0.380894] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.380930] pci 0000:00:13.2: PME# disabled
[    0.381072] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.381078] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.381084] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.381089] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.381095] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.381219] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]
[    0.381353] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.381360] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]
[    0.381365] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]
[    0.381372] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]
[    0.381387] pci 0000:02:00.0: supports D1 D2
[    0.381415] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]
[    0.381445] pci 0000:02:00.1: supports D1 D2
[    0.381495] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
[    0.381497] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
[    0.381500] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfff=
ffff]
[    0.381543] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]
[    0.381545] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]
[    0.381548] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcef=
ffff]
[    0.383347] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]
[    0.383360] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]
[    0.383370] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]
[    0.383375] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]
[    0.383402] pci 0000:01:00.0: supports D1 D2
[    0.383403] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.383440] pci 0000:01:00.0: PME# disabled
[    0.383525] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]
[    0.383527] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.383530] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfff=
ffff]
[    0.383565] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]
[    0.383644] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]
[    0.383701] pci 0000:05:08.0: supports D1 D2
[    0.383743] pci 0000:00:14.4: transparent bridge
[    0.383779] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
[    0.383785] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcff=
ffff]
[    0.383797] pci_bus 0000:00: on NUMA node 0
[    0.383800] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.383936] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.383981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.384025] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.384091] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.386726] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.386953] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    0.387183] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.387408] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.387643] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0=
,=20
disabled.
[    0.387914] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)
[    0.388140] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)
[    0.388352] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
[    0.388538] SCSI subsystem initialized
[    0.388538] libata version 3.00 loaded.
[    0.388538] usbcore: registered new interface driver usbfs
[    0.388538] usbcore: registered new interface driver hub
[    0.388538] usbcore: registered new device driver usb
[    0.443347] raid6: int64x1   2755 MB/s
[    0.500010] raid6: int64x2   3858 MB/s
[    0.556669] raid6: int64x4   2850 MB/s
[    0.613353] raid6: int64x8   2537 MB/s
[    0.670007] raid6: sse2x1    3999 MB/s
[    0.726666] raid6: sse2x2    7012 MB/s
[    0.783343] raid6: sse2x4    7975 MB/s
[    0.783377] raid6: using algorithm sse2x4 (7975 MB/s)
[    0.783423] PCI: Using ACPI for IRQ routing
[    0.783423] pci 0000:00:00.0: BAR 3: address space collision on of devic=
e=20
[0xe0000000-0xffffffff]
[    0.783425] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.793433] PCI-DMA: Disabling AGP.
[    0.793518] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.793518] PCI-DMA: using GART IOMMU.
[    0.793518] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.795205] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.795312] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.800030] hpet: hpet2 irq 24 for MSI
[    0.810015] Switched to high resolution mode on CPU 0
[    0.811193] Switched to high resolution mode on CPU 2
[    0.811196] Switched to high resolution mode on CPU 1
[    0.811200] Switched to high resolution mode on CPU 3
[    0.820035] pnp: PnP ACPI init
[    0.820085] ACPI: bus type pnp registered
[    0.822351] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 =
BAR 3=20
(0x0-0x1fffffff), disabling
[    0.822406] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:0=
0.0=20
BAR 3 (0x0-0x1fffffff), disabling
[    0.822461] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:0=
0.0=20
BAR 3 (0x0-0x1fffffff), disabling
[    0.822515] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps=20
0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.822837] pnp: PnP ACPI: found 12 devices
[    0.822871] ACPI: ACPI bus type pnp unregistered
[    0.822911] system 00:06: iomem range 0xfec00000-0xfec00fff could not be=
=20
reserved
[    0.822965] system 00:06: iomem range 0xfee00000-0xfee00fff has been=20
reserved
[    0.823002] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.823037] system 00:07: ioport range 0x40b-0x40b has been reserved
[    0.823072] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
[    0.823106] system 00:07: ioport range 0xc00-0xc01 has been reserved
[    0.823141] system 00:07: ioport range 0xc14-0xc14 has been reserved
[    0.823176] system 00:07: ioport range 0xc50-0xc51 has been reserved
[    0.823211] system 00:07: ioport range 0xc52-0xc52 has been reserved
[    0.823245] system 00:07: ioport range 0xc6c-0xc6c has been reserved
[    0.823280] system 00:07: ioport range 0xc6f-0xc6f has been reserved
[    0.823315] system 00:07: ioport range 0xcd0-0xcd1 has been reserved
[    0.823359] system 00:07: ioport range 0xcd2-0xcd3 has been reserved
[    0.823394] system 00:07: ioport range 0xcd4-0xcd5 has been reserved
[    0.823429] system 00:07: ioport range 0xcd6-0xcd7 has been reserved
[    0.823464] system 00:07: ioport range 0xcd8-0xcdf has been reserved
[    0.823499] system 00:07: ioport range 0x800-0x89f has been reserved
[    0.823533] system 00:07: ioport range 0xb00-0xb0f has been reserved
[    0.823568] system 00:07: ioport range 0xb20-0xb3f has been reserved
[    0.823603] system 00:07: ioport range 0x900-0x90f has been reserved
[    0.823638] system 00:07: ioport range 0x910-0x91f has been reserved
[    0.823673] system 00:07: ioport range 0xfe00-0xfefe has been reserved
[    0.823708] system 00:07: iomem range 0xffb80000-0xffbfffff has been res=
erved
[    0.823743] system 00:07: iomem range 0xfec10000-0xfec1001f has been=20
reserved
[    0.823780] system 00:09: ioport range 0x290-0x29f has been reserved
[    0.823816] system 00:0a: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.823852] system 00:0b: iomem range 0xfec00000-0xffffffff could not be=
=20
reserved
[    0.828757] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.828792] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.828828] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.828863] pci 0000:00:02.0:   PREFETCH window:=20
0x000000d0000000-0x000000dfffffff
[    0.828918] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.828953] pci 0000:00:09.0:   IO window: 0xd000-0xdfff
[    0.828988] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff
[    0.829023] pci 0000:00:09.0:   PREFETCH window:=20
0x000000fa000000-0x000000fcefffff
[    0.829078] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01
[    0.829112] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff
[    0.829148] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
[    0.829183] pci 0000:00:0a.0:   PREFETCH window:=20
0x000000cff00000-0x000000cfffffff
[    0.829237] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.829273] pci 0000:00:14.4:   IO window: 0xe000-0xefff
[    0.829310] pci 0000:00:14.4:   MEM window: disabled
[    0.829346] pci 0000:00:14.4:   PREFETCH window: 0xfcf00000-0xfcffffff
[    0.829387]   alloc irq_desc for 18 on node -1
[    0.829388]   alloc kstat_irqs on node -1
[    0.829392] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.829428] pci 0000:00:02.0: setting latency timer to 64
[    0.829432]   alloc irq_desc for 17 on node -1
[    0.829433]   alloc kstat_irqs on node -1
[    0.829435] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.829471] pci 0000:00:09.0: setting latency timer to 64
[    0.829474] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.829509] pci 0000:00:0a.0: setting latency timer to 64
[    0.829516] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.829517] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.829519] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.829521] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]
[    0.829522] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.829523] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.829525] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]
[    0.829526] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]
[    0.829527] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.829529] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.829530] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]
[    0.829531] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.829533] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]
[    0.829534] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.829535] pci_bus 0000:05: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.829547] NET: Registered protocol family 2
[    0.829602] IP route cache hash table entries: 262144 (order: 9, 2097152=
=20
bytes)
[    0.830084] TCP established hash table entries: 262144 (order: 10, 41943=
04=20
bytes)
[    0.831067] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.831468] TCP: Hash tables configured (established 262144 bind 65536)
[    0.831504] TCP reno registered
[    0.831582] NET: Registered protocol family 1
[    0.832803] Scanning for low memory corruption every 60 seconds
[    0.833572] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.833696] Loading Reiser4. See www.namesys.com for a description of=20
Reiser4.
[    0.833781] msgmni has been set to 15987
[    0.834082] alg: No test for stdrng (krng)
[    0.834123] async_tx: api initialized (sync-only)
[    0.834227] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor=20
253)
[    0.834280] io scheduler noop registered
[    0.834315] io scheduler cfq registered (default)
[    0.834448] pci 0000:02:00.0: Boot video device
[    0.834538]   alloc irq_desc for 25 on node -1
[    0.834540]   alloc kstat_irqs on node -1
[    0.834545] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    0.834550] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.834642]   alloc irq_desc for 26 on node -1
[    0.834643]   alloc kstat_irqs on node -1
[    0.834646] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X
[    0.834650] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.834741]   alloc irq_desc for 27 on node -1
[    0.834742]   alloc kstat_irqs on node -1
[    0.834744] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X
[    0.834748] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.834953] input: Power Button as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.835007] ACPI: Power Button [PWRF]
[    0.835098] input: Power Button as=20
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.835152] ACPI: Power Button [PWRB]
[    0.835302] processor LNXCPU:00: registered as cooling_device0
[    0.835337] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.835434] processor LNXCPU:01: registered as cooling_device1
[    0.835504] processor LNXCPU:02: registered as cooling_device2
[    0.835577] processor LNXCPU:03: registered as cooling_device3
[    0.839315] Linux agpgart interface v0.103
[    0.839511] ahci 0000:00:11.0: version 3.0
[    0.839521]   alloc irq_desc for 22 on node -1
[    0.839522]   alloc kstat_irqs on node -1
[    0.839525] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.839673] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x=
3f=20
impl SATA mode
[    0.839727] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp=
 pio=20
slum part=20
[    0.840272] scsi0 : ahci
[    0.840403] scsi1 : ahci
[    0.840501] scsi2 : ahci
[    0.840598] scsi3 : ahci
[    0.840697] scsi4 : ahci
[    0.840795] scsi5 : ahci
[    0.840926] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed
[    0.840962] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff98=
0 irq=20
22
[    0.841016] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa0=
0 irq=20
22
[    0.841070] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa8=
0 irq=20
22
[    0.841124] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb0=
0 irq=20
22
[    0.841178] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb8=
0 irq=20
22
[    0.841459] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.841493] PNP: PS/2 appears to have AUX port disabled, if this is=20
incorrect please boot with i8042.nopnp
[    0.841943] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.842074] mice: PS/2 mouse device common for all mice
[    0.842243] rtc_cmos 00:02: RTC can wake from S4
[    0.842313] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.842369] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.842428] md: raid1 personality registered for level 1
[    0.842462] md: raid6 personality registered for level 6
[    0.842496] md: raid5 personality registered for level 5
[    0.842530] md: raid4 personality registered for level 4
[    0.843117] cpuidle: using governor ladder
[    0.843151] cpuidle: using governor menu
[    0.843689] usbcore: registered new interface driver hiddev
[    0.843746] usbcore: registered new interface driver usbhid
[    0.843780] usbhid: v2.6:USB HID core driver
[    0.843843] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.843878] ALSA device list:
[    0.843911]   No soundcards found.
[    0.843979] TCP cubic registered
[    0.844019] NET: Registered protocol family 10
[    0.844148] IPv6 over IPv4 tunneling driver
[    0.844265] NET: Registered protocol family 17
[    0.844315] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor=20
processors (4 cpu cores) (version 2.20.00)
[    0.844391] powernow-k8:    0 : pstate 0 (3200 MHz)
[    0.844425] powernow-k8:    1 : pstate 1 (2500 MHz)
[    0.844459] powernow-k8:    2 : pstate 2 (2100 MHz)
[    0.844492] powernow-k8:    3 : pstate 3 (800 MHz)
[    0.844886] PM: Resume from disk failed.
[    0.844966]   Magic number: 9:648:116
[    0.866018] input: AT Translated Set 2 keyboard as=20
/devices/platform/i8042/serio0/input/input2
[    1.160036] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.160097] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.160150] ata6: SATA link down (SStatus 0 SControl 300)
[    1.160205] ata5: SATA link down (SStatus 0 SControl 300)
[    1.160259] ata3: SATA link down (SStatus 0 SControl 300)
[    1.166391] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7
[    1.166432] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.166480] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
[    1.166514] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.172888] ata4.00: configured for UDMA/133
[    1.172943] ata2.00: configured for UDMA/133
[    1.560035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.566394] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    1.566430] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.572855] ata1.00: configured for UDMA/133
[    1.583424] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1A=
A0=20
PQ: 0 ANSI: 5
[    1.583684] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500=20
GB/465 GiB)
[    1.583756] sd 0:0:0:0: [sda] Write Protect is off
[    1.583791] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.583800] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    1.583911]  sda:
[    1.583952] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.584094] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1A=
A0=20
PQ: 0 ANSI: 5
[    1.584283] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500=20
GB/465 GiB)
[    1.584354] sd 1:0:0:0: [sdb] Write Protect is off
[    1.584389] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.584398] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    1.584507]  sdb:
[    1.584577] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.584709] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1A=
A0=20
PQ: 0 ANSI: 5
[    1.584865] sd 3:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750=20
GB/698 GiB)
[    1.584934] sd 3:0:0:0: [sdc] Write Protect is off
[    1.584969] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.584977] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    1.585071]  sdc:
[    1.585123] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    1.588354]  sdc1 sdc2 sdc3 sdc4 < sdb1 sdb2 sdb3 sdb4 < sda1 sda2 sda3=
=20
sda4 < sdb5 sdc5 sda5 sdc6 sdb6 >
[    1.606850] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.610449]  sda6 >
[    1.610814] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.617957]  sdc7 >
[    1.618341] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.618382] md: Waiting for all devices to be available before autodetect
[    1.618417] md: If you don't use raid, use raid=3Dnoautodetect
[    1.618533] md: Autodetecting RAID arrays.
[    1.724723] md: Scanned 12 and added 12 devices.
[    1.724758] md: autorun ...
[    1.724792] md: considering sdc6 ...
[    1.724827] md:  adding sdc6 ...
[    1.724862] md: sdc5 has different UUID to sdc6
[    1.724897] md: sdc3 has different UUID to sdc6
[    1.724931] md: sdc1 has different UUID to sdc6
[    1.724967] md:  adding sda6 ...
[    1.725001] md: sda5 has different UUID to sdc6
[    1.725036] md: sda3 has different UUID to sdc6
[    1.725070] md: sda1 has different UUID to sdc6
[    1.725106] md:  adding sdb6 ...
[    1.725140] md: sdb5 has different UUID to sdc6
[    1.725175] md: sdb3 has different UUID to sdc6
[    1.725209] md: sdb1 has different UUID to sdc6
[    1.725349] md: created md3
[    1.725382] md: bind<sdb6>
[    1.725419] md: bind<sda6>
[    1.725456] md: bind<sdc6>
[    1.725492] md: running: <sdc6><sda6><sdb6>
[    1.725626] raid5: device sdc6 operational as raid disk 2
[    1.725661] raid5: device sda6 operational as raid disk 0
[    1.725695] raid5: device sdb6 operational as raid disk 1
[    1.725846] raid5: allocated 3220kB for md3
[    1.725910] raid5: raid level 5 set md3 active with 3 out of 3 devices,=
=20
algorithm 2
[    1.725963] RAID5 conf printout:
[    1.725996]  --- rd:3 wd:3
[    1.726029]  disk 0, o:1, dev:sda6
[    1.726062]  disk 1, o:1, dev:sdb6
[    1.726095]  disk 2, o:1, dev:sdc6
[    1.726142] md3: detected capacity change from 0 to 864065421312
[    1.726213] md: considering sdc5 ...
[    1.726249] md:  adding sdc5 ...
[    1.726283] md: sdc3 has different UUID to sdc5
[    1.726318] md: sdc1 has different UUID to sdc5
[    1.726353] md:  adding sda5 ...
[    1.726388] md: sda3 has different UUID to sdc5
[    1.726422] md: sda1 has different UUID to sdc5
[    1.726458] md:  adding sdb5 ...
[    1.726492] md: sdb3 has different UUID to sdc5
[    1.726526] md: sdb1 has different UUID to sdc5
[    1.726630] md: created md2
[    1.726663] md: bind<sdb5>
[    1.726700] md: bind<sda5>
[    1.726738] md: bind<sdc5>
[    1.726774] md: running: <sdc5><sda5><sdb5>
[    1.726901] raid5: device sdc5 operational as raid disk 2
[    1.726935] raid5: device sda5 operational as raid disk 0
[    1.726969] raid5: device sdb5 operational as raid disk 1
[    1.727126] raid5: allocated 3220kB for md2
[    1.727190] raid5: raid level 5 set md2 active with 3 out of 3 devices,=
=20
algorithm 2
[    1.727243] RAID5 conf printout:
[    1.727276]  --- rd:3 wd:3
[    1.727309]  disk 0, o:1, dev:sda5
[    1.727342]  disk 1, o:1, dev:sdb5
[    1.727376]  disk 2, o:1, dev:sdc5
[    1.727420] md2: detected capacity change from 0 to 40007499776
[    1.727490] md: considering sdc3 ...
[    1.727526] md:  adding sdc3 ...
[    1.727560] md: sdc1 has different UUID to sdc3
[    1.727595] md:  adding sda3 ...
[    1.727629] md: sda1 has different UUID to sdc3
[    1.727664] md:  adding sdb3 ...
[    1.727698] md: sdb1 has different UUID to sdc3
[    1.727799] md: created md1
[    1.727832] md: bind<sdb3>
[    1.727869] md: bind<sda3>
[    1.727905] md: bind<sdc3>
[    1.727945] md: running: <sdc3><sda3><sdb3>
[    1.728090] raid5: device sdc3 operational as raid disk 2
[    1.728125] raid5: device sda3 operational as raid disk 0
[    1.728159] raid5: device sdb3 operational as raid disk 1
[    1.728320] raid5: allocated 3220kB for md1
[    1.728370] raid5: raid level 5 set md1 active with 3 out of 3 devices,=
=20
algorithm 2
[    1.728423] RAID5 conf printout:
[    1.728455]  --- rd:3 wd:3
[    1.728488]  disk 0, o:1, dev:sda3
[    1.728522]  disk 1, o:1, dev:sdb3
[    1.728555]  disk 2, o:1, dev:sdc3
[    1.728604] md1: detected capacity change from 0 to 79998877696
[    1.728674] md: considering sdc1 ...
[    1.728710] md:  adding sdc1 ...
[    1.728745] md:  adding sda1 ...
[    1.728779] md:  adding sdb1 ...
[    1.728813] md: created md0
[    1.728846] md: bind<sdb1>
[    1.728882] md: bind<sda1>
[    1.728919] md: bind<sdc1>
[    1.728955] md: running: <sdc1><sda1><sdb1>
[    1.729133] raid1: raid set md0 active with 3 out of 3 mirrors
[    1.729176] md0: detected capacity change from 0 to 65667072
[    1.729232] md: ... autorun DONE.
[    1.729284] md: Loading md3: /dev/sda3
[    1.729322]  md3: unknown partition table
[    1.729481] md: couldn't update array info. -22
[    1.729518] md: could not bd_claim sda3.
[    1.729552] md: md_import_device returned -16
[    1.729588] md: could not bd_claim sdb3.
[    1.729621] md: md_import_device returned -16
[    1.729657] md: could not bd_claim sdc3.
[    1.729690] md: md_import_device returned -16
[    1.729725] md: starting md3 failed
[    1.729800]  md1: unknown partition table
[    1.767199] reiser4: md1: found disk format 4.0.0.
[    5.790318] VFS: Mounted root (reiser4 filesystem) readonly on device 9:=
1.
[    5.790370] Freeing unused kernel memory: 376k freed
[    9.037775] udev: starting version 145
[    9.217043]  md2:
[    9.217072]  md0: unknown partition table
[    9.282015]  unknown partition table
[   10.420576] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   10.420591] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ =
18
[   10.420840] r8169 0000:01:00.0: setting latency timer to 64
[   10.420871]   alloc irq_desc for 28 on node -1
[   10.420872]   alloc kstat_irqs on node -1
[   10.420882] r8169 0000:01:00.0: irq 28 for MSI/MSI-X
[   10.420988] eth0: RTL8168c/8111c at 0xffffc90012f18000, 00:19:66:86:ce:1=
2,=20
XID 3c4000c0 IRQ 28
[   10.440462] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.440465] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[   10.440491] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> I=
RQ=20
17
[   10.440518] ehci_hcd 0000:00:12.2: EHCI Host Controller
[   10.440532] drivers/usb/core/inode.c: creating file 'devices'
[   10.440534] drivers/usb/core/inode.c: creating file '001'
[   10.440566] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus=
=20
number 1
[   10.440572] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=3D1 cc=
=3D2=20
pcc=3D3 ordered !ppc ports=3D6
[   10.440575] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframe=
s=20
256/512/1024
[   10.440596] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze=20
workaround
[   10.440602] ehci_hcd 0000:00:12.2: reset command 080002 (park)=3D0 ithre=
sh=3D8=20
period=3D1024 Reset HALT
[   10.440615] ehci_hcd 0000:00:12.2: debug port 1
[   10.440619] ehci_hcd 0000:00:12.2: MWI active
[   10.440620] ehci_hcd 0000:00:12.2: supports USB remote wakeup
[   10.440633] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[   10.440637] ehci_hcd 0000:00:12.2: reset command 080002 (park)=3D0 ithre=
sh=3D8=20
period=3D1024 Reset HALT
[   10.440642] ehci_hcd 0000:00:12.2: init command 010009 (park)=3D0 ithres=
h=3D1=20
period=3D256 RUN
[   10.447931] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   10.447961] usb usb1: default language 0x0409
[   10.447965] usb usb1: udev 1, busnum 1, minor =3D 0
[   10.447967] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   10.447968] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[   10.447969] usb usb1: Product: EHCI Host Controller
[   10.447970] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd
[   10.447971] usb usb1: SerialNumber: 0000:00:12.2
[   10.447998] usb usb1: uevent
[   10.448007] usb usb1: usb_probe_device
[   10.448009] usb usb1: configuration #1 chosen from 1 choice
[   10.448014] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   10.448021] usb 1-0:1.0: uevent
[   10.448028] hub 1-0:1.0: usb_probe_interface
[   10.448029] hub 1-0:1.0: usb_probe_interface - got id
[   10.448031] hub 1-0:1.0: USB hub found
[   10.448035] hub 1-0:1.0: 6 ports detected
[   10.448036] hub 1-0:1.0: standalone hub
[   10.448037] hub 1-0:1.0: no power switching (usb 1.0)
[   10.448038] hub 1-0:1.0: individual port over-current protection
[   10.448039] hub 1-0:1.0: power on to power good time: 20ms
[   10.448042] hub 1-0:1.0: local power source is good
[   10.448043] hub 1-0:1.0: trying to enable port power on non-switchable h=
ub
[   10.448067] drivers/usb/core/inode.c: creating file '001'
[   10.448085]   alloc irq_desc for 19 on node -1
[   10.448087]   alloc kstat_irqs on node -1
[   10.448091] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ=20
19
[   10.448101] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   10.448105] drivers/usb/core/inode.c: creating file '002'
[   10.448122] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus=
=20
number 2
[   10.448127] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=3D1 cc=
=3D2=20
pcc=3D3 ordered !ppc ports=3D6
[   10.448130] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframe=
s=20
256/512/1024
[   10.448143] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze=20
workaround
[   10.448148] ehci_hcd 0000:00:13.2: reset command 080002 (park)=3D0 ithre=
sh=3D8=20
period=3D1024 Reset HALT
[   10.448161] ehci_hcd 0000:00:13.2: debug port 1
[   10.448164] ehci_hcd 0000:00:13.2: MWI active
[   10.448165] ehci_hcd 0000:00:13.2: supports USB remote wakeup
[   10.448173] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[   10.448176] ehci_hcd 0000:00:13.2: reset command 080002 (park)=3D0 ithre=
sh=3D8=20
period=3D1024 Reset HALT
[   10.448181] ehci_hcd 0000:00:13.2: init command 010009 (park)=3D0 ithres=
h=3D1=20
period=3D256 RUN
[   10.457930] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   10.457945] usb usb2: default language 0x0409
[   10.457949] usb usb2: udev 1, busnum 2, minor =3D 128
[   10.457950] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[   10.457952] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[   10.457953] usb usb2: Product: EHCI Host Controller
[   10.457954] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd
[   10.457955] usb usb2: SerialNumber: 0000:00:13.2
[   10.457977] usb usb2: uevent
[   10.457984] usb usb2: usb_probe_device
[   10.457986] usb usb2: configuration #1 chosen from 1 choice
[   10.457989] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   10.457997] usb 2-0:1.0: uevent
[   10.458003] hub 2-0:1.0: usb_probe_interface
[   10.458004] hub 2-0:1.0: usb_probe_interface - got id
[   10.458005] hub 2-0:1.0: USB hub found
[   10.458009] hub 2-0:1.0: 6 ports detected
[   10.458010] hub 2-0:1.0: standalone hub
[   10.458010] hub 2-0:1.0: no power switching (usb 1.0)
[   10.458011] hub 2-0:1.0: individual port over-current protection
[   10.458013] hub 2-0:1.0: power on to power good time: 20ms
[   10.458015] hub 2-0:1.0: local power source is good
[   10.458016] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[   10.458038] drivers/usb/core/inode.c: creating file '001'
[   10.474718] Linux video capture interface: v2.00
[   10.489875] bttv: driver version 0.9.18 loaded
[   10.489877] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   10.489914] bttv: Bt8xx card found (0).
[   10.489923]   alloc irq_desc for 21 on node -1
[   10.489924]   alloc kstat_irqs on node -1
[   10.489928] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   10.489938] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128=
,=20
mmio: 0xfcfff000
[   10.489971] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra=20
TValue Version 1.0/ Vobis TV-Boostar [card=3D25,insmod option]
[   10.489974] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.490007] bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffff [in=
it]
[   10.547936] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER=
=20
sig=3Dj CSC CONNECT
[   10.547939] hub 1-0:1.0: port 2: status 0501 change 0001
[   10.557954] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   10.647931] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
[   10.647940] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   10.700045] ehci_hcd 0000:00:12.2: port 2 high speed
[   10.700049] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER=
=20
sig=3Dse0 PE CONNECT
[   10.757104] usb 1-2: new high speed USB device using ehci_hcd and addres=
s 2
[   10.810036] ehci_hcd 0000:00:12.2: port 2 high speed
[   10.810039] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER=
=20
sig=3Dse0 PE CONNECT
[   10.881474] usb 1-2: default language 0x0409
[   10.881724] usb 1-2: udev 2, busnum 1, minor =3D 1
[   10.881725] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0608
[   10.881726] usb 1-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0
[   10.881728] usb 1-2: Product: USB2.0 Hub
[   10.881764] usb 1-2: uevent
[   10.881773] usb 1-2: usb_probe_device
[   10.881775] usb 1-2: configuration #1 chosen from 1 choice
[   10.882188] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
[   10.882199] usb 1-2:1.0: uevent
[   10.882206] hub 1-2:1.0: usb_probe_interface
[   10.882207] hub 1-2:1.0: usb_probe_interface - got id
[   10.882209] hub 1-2:1.0: USB hub found
[   10.882473] hub 1-2:1.0: 4 ports detected
[   10.882474] hub 1-2:1.0: standalone hub
[   10.882476] hub 1-2:1.0: individual port power switching
[   10.882477] hub 1-2:1.0: individual port over-current protection
[   10.882478] hub 1-2:1.0: Single TT
[   10.882479] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[   10.882480] hub 1-2:1.0: Port indicators are supported
[   10.882481] hub 1-2:1.0: power on to power good time: 100ms
[   10.882848] hub 1-2:1.0: local power source is good
[   10.882849] hub 1-2:1.0: enabling power on all ports
[   10.883860] drivers/usb/core/inode.c: creating file '002'
[   10.983961] hub 1-2:1.0: port 2: status 0301 change 0001
[   11.083356] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]
[   11.083364] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
[   11.083700] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
[   11.152198] usb 1-2.2: new low speed USB device using ehci_hcd and addre=
ss=20
3
[   11.241187] usb 1-2.2: skipped 1 descriptor after interface
[   11.241189] usb 1-2.2: skipped 1 descriptor after interface
[   11.241685] usb 1-2.2: default language 0x0409
[   11.243941] usb 1-2.2: udev 3, busnum 1, minor =3D 2
[   11.243943] usb 1-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc518
[   11.243944] usb 1-2.2: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0
[   11.243945] usb 1-2.2: Product: USB Receiver
[   11.243947] usb 1-2.2: Manufacturer: Logitech
[   11.243972] usb 1-2.2: uevent
[   11.243980] usb 1-2.2: usb_probe_device
[   11.243981] usb 1-2.2: configuration #1 chosen from 1 choice
[   11.251309] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
[   11.251324] usb 1-2.2:1.0: uevent
[   11.251334] usbhid 1-2.2:1.0: usb_probe_interface
[   11.251335] usbhid 1-2.2:1.0: usb_probe_interface - got id
[   11.251796] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[   11.254692] input: Logitech USB Receiver as=20
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3
[   11.254732] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.1=
1=20
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[   11.254740] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
[   11.254749] usb 1-2.2:1.1: uevent
[   11.254755] usbhid 1-2.2:1.1: usb_probe_interface
[   11.254757] usbhid 1-2.2:1.1: usb_probe_interface - got id
[   11.255046] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
[   11.260359] input: Logitech USB Receiver as=20
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4
[   11.260368] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[   11.260384] drivers/usb/core/file.c: looking for a minor, starting at 96
[   11.260414] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB=
=20
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[   11.260427] drivers/usb/core/inode.c: creating file '003'
[   11.260438] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
[   11.280770] usb 1-2.2:1.0: uevent
[   11.280827] usb 1-2.2: uevent
[   11.280844] usb 1-2.2:1.0: uevent
[   11.280903] usb 1-2.2: uevent
[   11.281405] usb 1-2.2:1.1: uevent
[   11.281467] usb 1-2.2: uevent
[   11.281517] usb 1-2.2:1.0: uevent
[   11.281529] usb 1-2.2:1.0: uevent
[   11.282164] usb 1-2.2:1.1: uevent
[   11.493831] bttv0: tea5757: read timeout
[   11.493832] bttv0: tuner type=3D5
[   11.505445] bttv0: audio absent, no audio device found!
[   11.525030] TUNER: Unable to find symbol tea5767_autodetection()
[   11.525033] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[   11.527843] tuner-simple 0-0060: creating new instance
[   11.527846] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 a=
nd=20
compatibles))
[   11.528664] bttv0: registered device video0
[   11.528695] bttv0: registered device vbi0
[   11.814508] reiser4: md2: found disk format 4.0.0.
[   13.337101] hub 2-0:1.0: hub_suspend
[   13.337107] usb usb2: bus auto-suspend
[   13.337109] ehci_hcd 0000:00:13.2: suspend root hub
[   13.591267] reiser4: md3: found disk format 4.0.0.
[   55.020583] reiser4: sdc7: found disk format 4.0.0.
[   67.386552] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1=20
across:7815612k=20
[   67.408915] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1=20
across:7815612k=20
[   67.501498] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1=20
across:7815612k=20
[   68.205087] w83627ehf: Found W83627EHG chip at 0x290
[   68.421646] r8169: eth0: link up
[   68.421650] r8169: eth0: link up
[   70.281241] usb usb1: uevent
[   70.281269] usb 1-0:1.0: uevent
[   70.281293] usb 1-2: uevent
[   70.281320] usb 1-2.2: uevent
[   70.281346] usb 1-2.2:1.0: uevent
[   70.281533] usb 1-2.2:1.1: uevent
[   70.281706] usb 1-2:1.0: uevent
[   70.281804] usb usb2: uevent
[   70.281830] usb 2-0:1.0: uevent
[   71.272886]   alloc irq_desc for 23 on node -1
[   71.272889]   alloc kstat_irqs on node -1
[   71.272895] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low=
) -
> IRQ 23
[   71.278891] Audigy2 value: Special config.
[   72.473408] fglrx: module license 'Proprietary. (C) 2002 - ATI=20
Technologies, Starnberg, GERMANY' taints kernel.
[   72.473417] Disabling lock debugging due to kernel taint
[   72.490481] [fglrx] Maximum main memory to use for locked dma buffers: 7=
760=20
MBytes.
[   72.490559] [fglrx]   vendor: 1002 device: 9501 count: 1
[   72.490739] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
[   72.490750] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   72.490754] pci 0000:02:00.0: setting latency timer to 64
[   72.490884] [fglrx] Kernel PAT support is enabled
[   72.490901] [fglrx] module loaded - fglrx 8.66.2 [Sep  1 2009] with 1=20
minors
[   72.668413]   alloc irq_desc for 29 on node -1
[   72.668416]   alloc kstat_irqs on node -1
[   72.668424] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X
[   72.668759] [fglrx] Firegl kernel thread PID: 3800
[   74.787429] [fglrx] Gart USWC size:1279 M.
[   74.787431] [fglrx] Gart cacheable size:508 M.
[   74.787435] [fglrx] Reserved FB block: Shared offset:0, size:1000000=20
[   74.787437] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401=
000=20
[   74.787438] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:40=
00=20
[   75.947153] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
[  616.849440] reiser4[ktxnmgrd:md1:ru(581)]: disable_write_barrier=20
(fs/reiser4/wander.c:235)[zam-1055]:
[  616.849445] NOTICE: md1 does not support write barriers, using synchrono=
us=20
write instead.
[  671.813536] reiser4[ktxnmgrd:md2:ru(2774)]: disable_write_barrier=20
(fs/reiser4/wander.c:235)[zam-1055]:
[  671.813541] NOTICE: md2 does not support write barriers, using synchrono=
us=20
write instead.
[  703.842289] reiser4[ktxnmgrd:md3:ru(2776)]: disable_write_barrier=20
(fs/reiser4/wander.c:235)[zam-1055]:
[  703.842293] NOTICE: md3 does not support write barriers, using synchrono=
us=20
write instead.

ps. I have to disable c1e in bios, or video is very jerky - unless somethin=
g=20
cpu heavy runs on at least one core...




--Boundary-00=_+fpqKqdL+aBp3Yt
Content-Type: text/plain;
  charset="us-ascii";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31
# Thu Sep 10 10:45:50 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="r4"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
# CONFIG_DMAR_DEFAULT_ON is not set
# CONFIG_DMAR_BROKEN_GFX_WA is not set
CONFIG_DMAR_FLOPPY_WA=y
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=32
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MD_RAID6_PQ=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
CONFIG_MACVLAN=m
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=m
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
# CONFIG_VIDEO_BT848_DVB is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_CX231XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_PWC_INPUT_EVDEV is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_SMS_SIANO_MDTV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
# CONFIG_DVB_BT8XX is not set

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set
CONFIG_DVB_ZL10353=m
CONFIG_DVB_LGDT330X=m
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_ATIHDMI=y
# CONFIG_SND_HDA_CODEC_NVHDMI is not set
# CONFIG_SND_HDA_CODEC_INTELHDMI is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KYE is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_ZEROPLUS is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISER4_FS=y
# CONFIG_REISER4_DEBUG is not set
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_IMA is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_TRACE is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--Boundary-00=_+fpqKqdL+aBp3Yt--
