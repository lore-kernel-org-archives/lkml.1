Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZESUg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZESUg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 16:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZESUgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 16:36:49 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:58737 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbZESUgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 16:36:39 -0400
X-Loopcount0: from 10.9.160.254
Message-ID: <4A131858.3080805@dell.com>
Date: Tue, 19 May 2009 15:36:40 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
References: <4A11C126.1000704@dell.com> <20090519163333.GA17189@srcf.ucam.org> <4A12E3DF.3070402@dell.com> <200905192158.12784.oliver@neukum.org>
In-Reply-To: <200905192158.12784.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEA742C9E650A076826A4467F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEA742C9E650A076826A4467F
Content-Type: multipart/mixed;
 boundary="------------000800000405080602040301"

This is a multi-part message in MIME format.
--------------000800000405080602040301
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Oliver:

Oliver Neukum wrote:
> Am Dienstag, 19. Mai 2009 18:52:47 schrieb Mario Limonciello:
>  =20
>
> If the drivers support reset_resume(), no udev event is generated, but =
the
> devices have to be present for that. Please post dmesg.
>
> 	Regards
> 		Oliver
>  =20
Sure, attaching.=20
--=20
Mario Limonciello
*Dell | Linux Engineering*
mario_limonciello@dell.com

--------------000800000405080602040301
Content-Type: text/plain;
 name="dmesg_postsuspend.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dmesg_postsuspend.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-5-generic (buildd@rothera) (gcc versi=
on 4.4.1 (Ubuntu 4.4.0-3ubuntu3) ) #6-Ubuntu SMP Mon May 11 19:56:30 UTC =
2009 (Ubuntu 2.6.30-5.6-generic)
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000006fec0000 (usable)
[    0.000000]  BIOS-e820: 000000006fec0000 - 000000006fecf000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000006fecf000 - 000000006fee5000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000006fee5000 - 0000000080000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)=

[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x6fec0 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-DBFFF uncachable
[    0.000000]   DC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (us=
able) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000006fec0000 (usable)
[    0.000000]  modified: 000000006fec0000 - 000000006fecf000 (ACPI data)=

[    0.000000]  modified: 000000006fecf000 - 000000006fee5000 (ACPI NVS)
[    0.000000]  modified: 000000006fee5000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000] Using x86 segment limits to approximate NX protection
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 3787e000 - 37fef6d5
[    0.000000] Allocated new RAMDISK: 00859000 - 00fca6d5
[    0.000000] Move RAMDISK from 000000003787e000 - 0000000037fef6d4 to 0=
0859000 - 00fca6d4
[    0.000000] ACPI: RSDP 000f7b20 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 6fec3b2f 000A4 (v01 DELL    QA09    06040000  L=
TP 00000000)
[    0.000000] ACPI: FACP 6fecec04 000F4 (v03 NVIDIA MCP79    06040000 PT=
L_ 000F4240)
[    0.000000] ACPI: DSDT 6fec56c1 094CF (v01 NVIDIA    MCP79 06040000 MS=
FT 03000001)
[    0.000000] ACPI: FACS 6fee4fc0 00040
[    0.000000] ACPI: MCFG 6fececf8 0003C (v01 PTLTD    MCFG   06040000  L=
TP 00000000)
[    0.000000] ACPI: HPET 6feced34 00038 (v01 PTLTD  HPETTBL  06040000  L=
TP 00000001)
[    0.000000] ACPI: APIC 6feced6c 00072 (v01 PTLTD  	 APIC   06040000  L=
TP 00000000)
[    0.000000] ACPI: BOOT 6fecedde 00028 (v01 PTLTD  $SBFTBL$ 06040000  L=
TP 00000001)
[    0.000000] ACPI: SLIC 6fecee06 00176 (v01 DELL    QA09    06040000  L=
TP 00000000)
[    0.000000] ACPI: OSFR 6fecef7c 00084 (v01 DELL   DELL     06040000 AS=
L  00000061)
[    0.000000] ACPI: SSDT 6fec5462 0025F (v01  PmRef  Cpu0Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec53bc 000A6 (v01  PmRef  Cpu7Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec5316 000A6 (v01  PmRef  Cpu6Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec5270 000A6 (v01  PmRef  Cpu5Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec51ca 000A6 (v01  PmRef  Cpu4Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec5124 000A6 (v01  PmRef  Cpu3Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec507e 000A6 (v01  PmRef  Cpu2Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec4fd8 000A6 (v01  PmRef  Cpu1Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec3bd3 01405 (v01  PmRef    CpuPm 00003000 IN=
TL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 902MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 00377=
fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0=
000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [0=
000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [0=
000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00008544b4]    TEXT DATA BSS =3D=3D> [0=
000100000 - 00008544b4]
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved =3D=3D> [0=
00009dc00 - 0000100000]
[    0.000000]   #5 [0000855000 - 0000858130]              BRK =3D=3D> [0=
000855000 - 0000858130]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE =3D=3D> [0=
000007000 - 0000008000]
[    0.000000]   #7 [0000859000 - 0000fca6d5]      NEW RAMDISK =3D=3D> [0=
000859000 - 0000fca6d5]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP =3D=3D> [0=
000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00f7b50] f7b50
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0006fec0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0006fec0
[    0.000000] On node 0 totalpages: 458329
[    0.000000] free_area_init_node: node 0, pgdat c0725d40, node_mem_map =
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3961 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1806 pages used for memmap
[    0.000000]   HighMem zone: 229300 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)=

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)=

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10dea301 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 000000000=
0006000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000=
009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000=
00a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 000000000=
00e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 000000000=
0100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 800000=
00:60000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c1e07000, static data 25628 b=
ytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 454747
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-5-g=
eneric root=3DUUID=3D43180eb4-fa9a-4157-95c2-3bf4eabb45aa ro quiet splash=

[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2399.932 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[    0.004000] allocated 9168640 bytes of page_cgroup
[    0.004000] please try cgroup_disable=3Dmemory option if you don't wan=
t
[    0.004000] Initializing HighMem for node 0 (000377fe:0006fec0)
[    0.004000] Memory: 1793068k/1833728k available (4351k kernel code, 39=
392k reserved, 1994k data, 516k init, 924424k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.004000]       .init : 0xc073b000 - 0xc07bc000   ( 516 kB)
[    0.004000]       .data : 0xc053fcce - 0xc0732708   (1994 kB)
[    0.004000]       .text : 0xc0100000 - 0xc053fcce   (4351 kB)
[    0.004000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.004000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.004000] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 4799.86 BogoMIPS (lpj=3D9599728)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys net_cls
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] Checking 'hlt' instruction... OK.
[    0.018165] ACPI: Core revision 20090320
[    0.032429] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.072558] CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz step=
ping 06
[    0.076001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4799.98 B=
ogoMIPS (lpj=3D9599973)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.160583] CPU1: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz step=
ping 06
[    0.160600] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.164018] Brought up 2 CPUs
[    0.164020] Total of 2 processors activated (9599.85 BogoMIPS).
[    0.164087] CPU0 attaching sched-domain:
[    0.164089]  domain 0: span 0-1 level MC
[    0.164091]   groups: 0 1
[    0.164096] CPU1 attaching sched-domain:
[    0.164098]  domain 0: span 0-1 level MC
[    0.164100]   groups: 1 0
[    0.164162] net_namespace: 1056 bytes
[    0.164162] Booting paravirtualized kernel on bare hardware
[    0.164162] regulator: core version 0.5
[    0.164162] Time: 20:31:08  Date: 05/19/09
[    0.164162] NET: Registered protocol family 16
[    0.164162] EISA bus registered
[    0.164162] ACPI: bus type pci registered
[    0.164162] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0=
 - 7
[    0.164162] PCI: MCFG area at e0000000 reserved in E820
[    0.164162] PCI: Using MMCONFIG for extended config space
[    0.164162] PCI: Using configuration type 1 for base access
[    0.168030] bio: create slab <bio-0> at 0
[    0.169076] ACPI: EC: Look up EC in DSDT
[    0.175055] ACPI: Interpreter enabled
[    0.175059] ACPI: (supports S0 S3 S4 S5)
[    0.175075] ACPI: Using IOAPIC for interrupt routing
[    0.177165] ACPI: EC: non-query interrupt received, switching to inter=
rupt mode
[    0.192128] ACPI: EC: GPE =3D 0x47, I/O: command/status =3D 0x66, data=
 =3D 0x62
[    0.192128] ACPI: EC: driver started in interrupt mode
[    0.192317] ACPI: No dock devices found.
[    0.192444] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.192467] pci 0000:00:03.0: reg 10 io port: [0x1c00-0x1cff]
[    0.192467] pci 0000:00:03.2: reg 10 io port: [0x3080-0x30bf]
[    0.192467] pci 0000:00:03.2: reg 20 io port: [0x3040-0x307f]
[    0.192467] pci 0000:00:03.2: reg 24 io port: [0x2000-0x203f]
[    0.192467] pci 0000:00:03.2: PME# supported from D3hot D3cold
[    0.192467] pci 0000:00:03.2: PME# disabled
[    0.192481] pci 0000:00:03.5: reg 10 32bit mmio: [0xf0600000-0xf067fff=
f]
[    0.192570] pci 0000:00:04.0: reg 10 32bit mmio: [0xf0886000-0xf0886ff=
f]
[    0.192600] pci 0000:00:04.0: supports D1 D2
[    0.192602] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192605] pci 0000:00:04.0: PME# disabled
[    0.192632] pci 0000:00:04.1: reg 10 32bit mmio: [0xf0889000-0xf08890f=
f]
[    0.192667] pci 0000:00:04.1: supports D1 D2
[    0.192668] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192672] pci 0000:00:04.1: PME# disabled
[    0.192703] pci 0000:00:06.0: reg 10 32bit mmio: [0xf0887000-0xf0887ff=
f]
[    0.192732] pci 0000:00:06.0: supports D1 D2
[    0.192734] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192737] pci 0000:00:06.0: PME# disabled
[    0.192765] pci 0000:00:06.1: reg 10 32bit mmio: [0xf0889400-0xf08894f=
f]
[    0.192800] pci 0000:00:06.1: supports D1 D2
[    0.192801] pci 0000:00:06.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192805] pci 0000:00:06.1: PME# disabled
[    0.192836] pci 0000:00:08.0: reg 10 32bit mmio: [0xf0880000-0xf0883ff=
f]
[    0.192865] pci 0000:00:08.0: PME# supported from D3hot D3cold
[    0.192869] pci 0000:00:08.0: PME# disabled
[    0.192923] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf0888000-0xf0888ff=
f]
[    0.192927] pci 0000:00:0a.0: reg 14 io port: [0x30d0-0x30d7]
[    0.192932] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf0889c00-0xf0889cf=
f]
[    0.192936] pci 0000:00:0a.0: reg 1c 32bit mmio: [0xf0889800-0xf088980=
f]
[    0.192957] pci 0000:00:0a.0: supports D1 D2
[    0.192959] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192963] pci 0000:00:0a.0: PME# disabled
[    0.192989] pci 0000:00:0b.0: reg 10 io port: [0x30e8-0x30ef]
[    0.192994] pci 0000:00:0b.0: reg 14 io port: [0x30dc-0x30df]
[    0.192998] pci 0000:00:0b.0: reg 18 io port: [0x30e0-0x30e7]
[    0.193002] pci 0000:00:0b.0: reg 1c io port: [0x30d8-0x30db]
[    0.193006] pci 0000:00:0b.0: reg 20 io port: [0x30c0-0x30cf]
[    0.193011] pci 0000:00:0b.0: reg 24 32bit mmio: [0xf0884000-0xf0885ff=
f]
[    0.193218] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193225] pci 0000:00:0c.0: PME# disabled
[    0.193293] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193296] pci 0000:00:10.0: PME# disabled
[    0.193491] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193499] pci 0000:00:15.0: PME# disabled
[    0.193715] pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193722] pci 0000:00:16.0: PME# disabled
[    0.193938] pci 0000:00:17.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193946] pci 0000:00:17.0: PME# disabled
[    0.196211] pci 0000:00:18.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196219] pci 0000:00:18.0: PME# disabled
[    0.196292] pci 0000:01:07.0: reg 10 32bit mmio: [0xf0500000-0xf05007f=
f]
[    0.196331] pci 0000:01:07.0: supports D1 D2
[    0.196332] pci 0000:01:07.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196336] pci 0000:01:07.0: PME# disabled
[    0.196364] pci 0000:01:07.1: reg 10 32bit mmio: [0xf0500800-0xf05008f=
f]
[    0.196403] pci 0000:01:07.1: supports D1 D2
[    0.196404] pci 0000:01:07.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196408] pci 0000:01:07.1: PME# disabled
[    0.196436] pci 0000:01:07.2: reg 10 32bit mmio: [0xf0500c00-0xf0500cf=
f]
[    0.196475] pci 0000:01:07.2: supports D1 D2
[    0.196476] pci 0000:01:07.2: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196480] pci 0000:01:07.2: PME# disabled
[    0.196508] pci 0000:01:07.3: reg 10 32bit mmio: [0xf0501000-0xf05010f=
f]
[    0.196547] pci 0000:01:07.3: supports D1 D2
[    0.196548] pci 0000:01:07.3: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196552] pci 0000:01:07.3: PME# disabled
[    0.196580] pci 0000:01:07.4: reg 10 32bit mmio: [0xf0501400-0xf05014f=
f]
[    0.196619] pci 0000:01:07.4: supports D1 D2
[    0.196620] pci 0000:01:07.4: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196624] pci 0000:01:07.4: PME# disabled
[    0.196660] pci 0000:00:09.0: transparent bridge
[    0.196664] pci 0000:00:09.0: bridge 32bit mmio: [0xf0500000-0xf05ffff=
f]
[    0.196722] pci 0000:02:00.0: reg 10 32bit mmio: [0xae000000-0xaefffff=
f]
[    0.196738] pci 0000:02:00.0: reg 14 64bit mmio: [0xd0000000-0xdffffff=
f]
[    0.196755] pci 0000:02:00.0: reg 1c 64bit mmio: [0xac000000-0xadfffff=
f]
[    0.196767] pci 0000:02:00.0: reg 24 io port: [0x4000-0x407f]
[    0.196778] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.196873] pci 0000:00:0c.0: bridge io port: [0x4000-0x4fff]
[    0.196881] pci 0000:00:0c.0: bridge 32bit mmio: [0xac000000-0xaefffff=
f]
[    0.196895] pci 0000:00:0c.0: bridge 64bit mmio pref: [0xd0000000-0xdf=
ffffff]
[    0.196930] pci 0000:03:00.0: reg 10 32bit mmio: [0xaa000000-0xaafffff=
f]
[    0.196939] pci 0000:03:00.0: reg 14 64bit mmio: [0xb0000000-0xbffffff=
f]
[    0.196947] pci 0000:03:00.0: reg 1c 64bit mmio: [0xcc000000-0xcdfffff=
f]
[    0.196952] pci 0000:03:00.0: reg 24 io port: [0x5000-0x507f]
[    0.196958] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.197010] pci 0000:00:10.0: bridge io port: [0x5000-0x5fff]
[    0.197013] pci 0000:00:10.0: bridge 32bit mmio: [0xaa000000-0xaafffff=
f]
[    0.197017] pci 0000:00:10.0: bridge 64bit mmio pref: [0xb0000000-0xcd=
ffffff]
[    0.197076] pci 0000:00:15.0: bridge io port: [0x6000-0x6fff]
[    0.197084] pci 0000:00:15.0: bridge 32bit mmio: [0xf0200000-0xf03ffff=
f]
[    0.197098] pci 0000:00:15.0: bridge 64bit mmio pref: [0xf0000000-0xf0=
1fffff]
[    0.197173] pci 0000:06:00.0: reg 10 64bit mmio: [0xf0400000-0xf0403ff=
f]
[    0.197251] pci 0000:06:00.0: supports D1 D2
[    0.197253] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.197258] pci 0000:06:00.0: PME# disabled
[    0.197336] pci 0000:00:16.0: bridge 32bit mmio: [0xf0400000-0xf04ffff=
f]
[    0.197571] pci_bus 0000:00: on NUMA node 0
[    0.197576] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.197754] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.197768] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    0.260469] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 *10 11 14 15)
[    0.260469] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 10 *11 14 15)
[    0.260655] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15) *0,=
 disabled.
[    0.260883] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0,=
 disabled.
[    0.261114] ACPI: PCI Interrupt Link [Z00Q] (IRQs 18 19 20 21 22 23) *=
11
[    0.261343] ACPI: PCI Interrupt Link [Z00R] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.261571] ACPI: PCI Interrupt Link [Z00S] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.261800] ACPI: PCI Interrupt Link [Z00T] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262028] ACPI: PCI Interrupt Link [Z00U] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262256] ACPI: PCI Interrupt Link [Z00V] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262484] ACPI: PCI Interrupt Link [Z00W] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262712] ACPI: PCI Interrupt Link [Z00X] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262941] ACPI: PCI Interrupt Link [Z00Y] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264230] ACPI: PCI Interrupt Link [Z00Z] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264458] ACPI: PCI Interrupt Link [Z010] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264687] ACPI: PCI Interrupt Link [Z011] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264914] ACPI: PCI Interrupt Link [Z012] (IRQs 18 19 20 21 22 23) *=
10
[    0.265142] ACPI: PCI Interrupt Link [Z013] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.265370] ACPI: PCI Interrupt Link [Z014] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.265598] ACPI: PCI Interrupt Link [Z015] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.265827] ACPI: PCI Interrupt Link [Z016] (IRQs 18 19 20 21 22 23) *=
11
[    0.266054] ACPI: PCI Interrupt Link [Z017] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.266283] ACPI: PCI Interrupt Link [Z018] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.266511] ACPI: PCI Interrupt Link [Z019] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.266739] ACPI: PCI Interrupt Link [Z01A] (IRQs 18 19 20 21 22 23) *=
10
[    0.266967] ACPI: PCI Interrupt Link [Z01B] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.267195] ACPI: PCI Interrupt Link [Z01C] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.267423] ACPI: PCI Interrupt Link [Z01D] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.267652] ACPI: PCI Interrupt Link [Z01E] (IRQs 18 19 20 21 22 23) *=
11
[    0.267880] ACPI: PCI Interrupt Link [Z01F] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.268119] ACPI: PCI Interrupt Link [Z01G] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.268348] ACPI: PCI Interrupt Link [Z01H] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.268576] ACPI: PCI Interrupt Link [LSMB] (IRQs 18 19 20 21 22 23) *=
10
[    0.268802] ACPI: PCI Interrupt Link [LUS0] (IRQs 18 19 20 21 22 23) *=
7
[    0.269032] ACPI: PCI Interrupt Link [LUS2] (IRQs 18 19 20 21 22 23) *=
11
[    0.269260] ACPI: PCI Interrupt Link [LMAC] (IRQs 18 19 20 21 22 23) *=
10
[    0.269487] ACPI: PCI Interrupt Link [LAZA] (IRQs 17) *11
[    0.269712] ACPI: PCI Interrupt Link [LGPU] (IRQs 18 19 20 21 22 23) *=
5
[    0.269939] ACPI: PCI Interrupt Link [LPID] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.270167] ACPI: PCI Interrupt Link [LSI0] (IRQs 18 19 20 21 22 23) *=
11
[    0.270396] ACPI: PCI Interrupt Link [LSI1] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.270625] ACPI: PCI Interrupt Link [Z00O] (IRQs 18 19 20 21 22 23) *=
5
[    0.270855] ACPI: PCI Interrupt Link [Z00P] (IRQs 18 19 20 21 22 23) *=
10
[    0.271083] ACPI: PCI Interrupt Link [LPMU] (IRQs 18 19 20 21 22 23) *=
10
[    0.271145] SCSI subsystem initialized
[    0.271145] libata version 3.00 loaded.
[    0.271145] usbcore: registered new interface driver usbfs
[    0.271145] usbcore: registered new interface driver hub
[    0.271145] usbcore: registered new device driver usb
[    0.272026] ACPI: WMI: Mapper loaded
[    0.272026] PCI: Using ACPI for IRQ routing
[    0.292006] Bluetooth: Core ver 2.15
[    0.292019] NET: Registered protocol family 31
[    0.292019] Bluetooth: HCI device and connection manager initialized
[    0.292019] Bluetooth: HCI socket layer initialized
[    0.292021] NET: Registered protocol family 8
[    0.292023] NET: Registered protocol family 20
[    0.292036] NetLabel: Initializing
[    0.292036] NetLabel:  domain hash size =3D 128
[    0.292036] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.292036] NetLabel:  unlabeled traffic allowed by default
[    0.292036] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31, 31
[    0.292036] hpet0: 4 comparators, 64-bit 25.000000 MHz counter
[    0.316007] pnp: PnP ACPI init
[    0.316014] ACPI: bus type pnp registered
[    0.317130] pnp 00:03: mem resource (0xf0600000-0xf0607fff) overlaps 0=
000:00:03.5 BAR 0 (0xf0600000-0xf067ffff), disabling
[    0.321690] pnp: PnP ACPI: found 13 devices
[    0.321692] ACPI: ACPI bus type pnp unregistered
[    0.321695] PnPBIOS: Disabled by ACPI PNP
[    0.321703] system 00:00: iomem range 0xffc00000-0xffffffff could not =
be reserved
[    0.321706] system 00:00: iomem range 0xfec00000-0xfec00fff has been r=
eserved
[    0.321709] system 00:00: iomem range 0xfee00000-0xfeefffff could not =
be reserved
[    0.321711] system 00:00: iomem range 0xfed00000-0xfed00fff has been r=
eserved
[    0.321719] system 00:04: ioport range 0x1000-0x107f has been reserved=

[    0.321721] system 00:04: ioport range 0x1080-0x10ff has been reserved=

[    0.321723] system 00:04: ioport range 0x1400-0x147f has been reserved=

[    0.321726] system 00:04: ioport range 0x1480-0x14ff has been reserved=

[    0.321728] system 00:04: ioport range 0x1800-0x187f has been reserved=

[    0.321730] system 00:04: ioport range 0x1880-0x18ff has been reserved=

[    0.321736] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.321738] system 00:07: ioport range 0x910-0x911 has been reserved
[    0.321741] system 00:07: ioport range 0x295-0x296 has been reserved
[    0.356640] pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
[    0.356642] pci 0000:00:09.0:   IO window: disabled
[    0.356646] pci 0000:00:09.0:   MEM window: 0xf0500000-0xf05fffff
[    0.356649] pci 0000:00:09.0:   PREFETCH window: disabled
[    0.356656] pci 0000:02:00.0: BAR 6: can't allocate mem resource [0xe0=
000000-0xdfffffff]
[    0.356658] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:02
[    0.356663] pci 0000:00:0c.0:   IO window: 0x4000-0x4fff
[    0.356673] pci 0000:00:0c.0:   MEM window: 0xac000000-0xaeffffff
[    0.356680] pci 0000:00:0c.0:   PREFETCH window: 0x000000d0000000-0x00=
0000dfffffff
[    0.356694] pci 0000:00:10.0: PCI bridge, secondary bus 0000:03
[    0.356696] pci 0000:00:10.0:   IO window: 0x5000-0x5fff
[    0.356699] pci 0000:00:10.0:   MEM window: 0xaa000000-0xaaffffff
[    0.356702] pci 0000:00:10.0:   PREFETCH window: 0x000000b0000000-0x00=
0000cdffffff
[    0.356706] pci 0000:00:15.0: PCI bridge, secondary bus 0000:04
[    0.356711] pci 0000:00:15.0:   IO window: 0x6000-0x6fff
[    0.356721] pci 0000:00:15.0:   MEM window: 0xf0200000-0xf03fffff
[    0.356728] pci 0000:00:15.0:   PREFETCH window: 0x000000f0000000-0x00=
0000f01fffff
[    0.356741] pci 0000:00:16.0: PCI bridge, secondary bus 0000:06
[    0.356743] pci 0000:00:16.0:   IO window: disabled
[    0.356752] pci 0000:00:16.0:   MEM window: 0xf0400000-0xf04fffff
[    0.356760] pci 0000:00:16.0:   PREFETCH window: disabled
[    0.356772] pci 0000:00:17.0: PCI bridge, secondary bus 0000:07
[    0.356774] pci 0000:00:17.0:   IO window: disabled
[    0.356783] pci 0000:00:17.0:   MEM window: disabled
[    0.356790] pci 0000:00:17.0:   PREFETCH window: disabled
[    0.356803] pci 0000:00:18.0: PCI bridge, secondary bus 0000:08
[    0.356804] pci 0000:00:18.0:   IO window: disabled
[    0.356814] pci 0000:00:18.0:   MEM window: disabled
[    0.356821] pci 0000:00:18.0:   PREFETCH window: disabled
[    0.356838] pci 0000:00:09.0: setting latency timer to 64
[    0.357173] ACPI: PCI Interrupt Link [Z00Q] enabled at IRQ 23
[    0.357176]   alloc irq_desc for 23 on cpu 0 node 0
[    0.357178]   alloc kstat_irqs on cpu 0 node 0
[    0.357182] pci 0000:00:0c.0: PCI INT A -> Link[Z00Q] -> GSI 23 (level=
, low) -> IRQ 23
[    0.357191] pci 0000:00:0c.0: setting latency timer to 64
[    0.357198] pci 0000:00:10.0: setting latency timer to 64
[    0.357524] ACPI: PCI Interrupt Link [Z012] enabled at IRQ 22
[    0.357527]   alloc irq_desc for 22 on cpu 0 node 0
[    0.357528]   alloc kstat_irqs on cpu 0 node 0
[    0.357532] pci 0000:00:15.0: PCI INT A -> Link[Z012] -> GSI 22 (level=
, low) -> IRQ 22
[    0.357540] pci 0000:00:15.0: setting latency timer to 64
[    0.357869] ACPI: PCI Interrupt Link [Z016] enabled at IRQ 21
[    0.357872]   alloc irq_desc for 21 on cpu 0 node 0
[    0.357873]   alloc kstat_irqs on cpu 0 node 0
[    0.357877] pci 0000:00:16.0: PCI INT A -> Link[Z016] -> GSI 21 (level=
, low) -> IRQ 21
[    0.357885] pci 0000:00:16.0: setting latency timer to 64
[    0.358214] ACPI: PCI Interrupt Link [Z01A] enabled at IRQ 20
[    0.358216]   alloc irq_desc for 20 on cpu 0 node 0
[    0.358218]   alloc kstat_irqs on cpu 0 node 0
[    0.358221] pci 0000:00:17.0: PCI INT A -> Link[Z01A] -> GSI 20 (level=
, low) -> IRQ 20
[    0.358229] pci 0000:00:17.0: setting latency timer to 64
[    0.358559] ACPI: PCI Interrupt Link [Z01E] enabled at IRQ 19
[    0.358561]   alloc irq_desc for 19 on cpu 0 node 0
[    0.358563]   alloc kstat_irqs on cpu 0 node 0
[    0.358566] pci 0000:00:18.0: PCI INT A -> Link[Z01E] -> GSI 19 (level=
, low) -> IRQ 19
[    0.358574] pci 0000:00:18.0: setting latency timer to 64
[    0.358580] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.358582] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.358585] pci_bus 0000:01: resource 1 mem: [0xf0500000-0xf05fffff]
[    0.358587] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.358589] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
[    0.358591] pci_bus 0000:02: resource 0 io:  [0x4000-0x4fff]
[    0.358593] pci_bus 0000:02: resource 1 mem: [0xac000000-0xaeffffff]
[    0.358595] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdffffff=
f]
[    0.358598] pci_bus 0000:03: resource 0 io:  [0x5000-0x5fff]
[    0.358600] pci_bus 0000:03: resource 1 mem: [0xaa000000-0xaaffffff]
[    0.358602] pci_bus 0000:03: resource 2 pref mem [0xb0000000-0xcdfffff=
f]
[    0.358604] pci_bus 0000:04: resource 0 io:  [0x6000-0x6fff]
[    0.358606] pci_bus 0000:04: resource 1 mem: [0xf0200000-0xf03fffff]
[    0.358608] pci_bus 0000:04: resource 2 pref mem [0xf0000000-0xf01ffff=
f]
[    0.358611] pci_bus 0000:06: resource 1 mem: [0xf0400000-0xf04fffff]
[    0.358636] NET: Registered protocol family 2
[    0.404051] IP route cache hash table entries: 32768 (order: 5, 131072=
 bytes)
[    0.404290] TCP established hash table entries: 131072 (order: 8, 1048=
576 bytes)
[    0.404622] TCP bind hash table entries: 65536 (order: 7, 524288 bytes=
)
[    0.404792] TCP: Hash tables configured (established 131072 bind 65536=
)
[    0.404794] TCP reno registered
[    0.416057] NET: Registered protocol family 1
[    0.416098] Trying to unpack rootfs image as initramfs...
[    0.500628] Switched to high resolution mode on CPU 1
[    0.504008] Switched to high resolution mode on CPU 0
[    0.574794] Freeing initrd memory: 7621k freed
[    0.578196] Simple Boot Flag at 0x36 set to 0x1
[    0.578516] cpufreq-nforce2: No nForce2 chipset.
[    0.578607] Scanning for low memory corruption every 60 seconds
[    0.578802] audit: initializing netlink socket (disabled)
[    0.578815] type=3D2000 audit(1242765067.577:1): initialized
[    0.585449] highmem bounce pool size: 64 pages
[    0.585454] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.587682] VFS: Disk quotas dquot_6.5.2
[    0.587754] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    0.588549] fuse init (API version 7.11)
[    0.588691] msgmni has been set to 1713
[    0.588878] alg: No test for stdrng (krng)
[    0.588886] io scheduler noop registered
[    0.588888] io scheduler anticipatory registered
[    0.588890] io scheduler deadline registered
[    0.588949] io scheduler cfq registered (default)
[    0.589227] pci 0000:03:00.0: Boot video device
[    0.589549]   alloc irq_desc for 24 on cpu 0 node 0
[    0.589552]   alloc kstat_irqs on cpu 0 node 0
[    0.589571] pcieport-driver 0000:00:0c.0: irq 24 for MSI/MSI-X
[    0.589612] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    0.590013]   alloc irq_desc for 25 on cpu 0 node 0
[    0.590015]   alloc kstat_irqs on cpu 0 node 0
[    0.590032] pcieport-driver 0000:00:15.0: irq 25 for MSI/MSI-X
[    0.590072] pcieport-driver 0000:00:15.0: setting latency timer to 64
[    0.590462]   alloc irq_desc for 26 on cpu 0 node 0
[    0.590463]   alloc kstat_irqs on cpu 0 node 0
[    0.590480] pcieport-driver 0000:00:16.0: irq 26 for MSI/MSI-X
[    0.590520] pcieport-driver 0000:00:16.0: setting latency timer to 64
[    0.590911]   alloc irq_desc for 27 on cpu 0 node 0
[    0.590912]   alloc kstat_irqs on cpu 0 node 0
[    0.590929] pcieport-driver 0000:00:17.0: irq 27 for MSI/MSI-X
[    0.590969] pcieport-driver 0000:00:17.0: setting latency timer to 64
[    0.591359]   alloc irq_desc for 28 on cpu 0 node 0
[    0.591360]   alloc kstat_irqs on cpu 0 node 0
[    0.591377] pcieport-driver 0000:00:18.0: irq 28 for MSI/MSI-X
[    0.591417] pcieport-driver 0000:00:18.0: setting latency timer to 64
[    0.591639] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.591722] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    0.592983] ACPI: AC Adapter [ADP0] (on-line)
[    0.593334] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    0.593337] ACPI: Power Button [PWRF]
[    0.593400] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input1
[    0.593402] ACPI: Power Button [PWRB]
[    0.593700] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0=
A08:00/device:2a/PNP0C0E:00/input/input2
[    0.593702] ACPI: Sleep Button [SLPB]
[    0.593768] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0=
D:00/input/input3
[    0.595193] ACPI: Lid Switch [LID]
[    0.596198] ACPI: SSDT 6fee1086 0021F (v01  PmRef  Cpu0Ist 00003000 IN=
TL 20050228)
[    0.596990] ACPI: SSDT 6fee1648 0067D (v01  PmRef  Cpu0Cst 00003001 IN=
TL 20050228)
[    0.598765] Monitor-Mwait will be used to enter C-1 state
[    0.598791] Monitor-Mwait will be used to enter C-2 state
[    0.598810] Monitor-Mwait will be used to enter C-3 state
[    0.598817] Marking TSC unstable due to TSC halts in idle
[    0.598856] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.598896] processor ACPI_CPU:00: registered as cooling_device0
[    0.598899] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.599257] ACPI: SSDT 6fee0ed6 001B0 (v01  PmRef  Cpu1Ist 00003000 IN=
TL 20050228)
[    0.599640] ACPI: SSDT 6fee15c3 00085 (v01  PmRef  Cpu1Cst 00003000 IN=
TL 20050228)
[    0.600456] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.600495] processor ACPI_CPU:01: registered as cooling_device1
[    0.600499] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.608280] thermal LNXTHERM:01: registered as thermal_zone0
[    0.608287] ACPI: Thermal Zone [THRM] (59 C)
[    0.608677] isapnp: Scanning for PnP cards...
[    0.961613] isapnp: No Plug & Play device found
[    0.965894] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.967878] brd: module loaded
[    0.968610] loop: module loaded
[    0.968783] input: Macintosh mouse button emulation as /devices/virtua=
l/input/input4
[    0.968834] Driver 'sd' needs updating - please use bus_type methods
[    0.968871] Driver 'sr' needs updating - please use bus_type methods
[    0.968959] ahci 0000:00:0b.0: version 3.0
[    0.969304] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 18
[    0.969307]   alloc irq_desc for 18 on cpu 0 node 0
[    0.969309]   alloc kstat_irqs on cpu 0 node 0
[    0.969314] ahci 0000:00:0b.0: PCI INT A -> Link[LSI0] -> GSI 18 (leve=
l, low) -> IRQ 18
[    0.969344]   alloc irq_desc for 29 on cpu 0 node 0
[    0.969346]   alloc kstat_irqs on cpu 0 node 0
[    0.969352] ahci 0000:00:0b.0: irq 29 for MSI/MSI-X
[    0.969414] ahci 0000:00:0b.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps =
0x3f impl SATA mode
[    0.969417] ahci 0000:00:0b.0: flags: 64bit ncq sntf led pmp pio slum =
part=20
[    0.969420] ahci 0000:00:0b.0: setting latency timer to 64
[    0.969762] scsi0 : ahci
[    0.969898] scsi1 : ahci
[    0.970002] scsi2 : ahci
[    0.970109] scsi3 : ahci
[    0.970210] scsi4 : ahci
[    0.970312] scsi5 : ahci
[    0.970471] ata1: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
100 irq 29
[    0.970473] ata2: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
180 irq 29
[    0.970476] ata3: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
200 irq 29
[    0.970478] ata4: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
280 irq 29
[    0.970480] ata5: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
300 irq 29
[    0.970482] ata6: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
380 irq 29
[    0.973293] Fixed MDIO Bus: probed
[    0.973298] PPP generic driver version 2.4.2
[    0.973481] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    0.974016] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
[    0.974019] ehci_hcd 0000:00:04.1: PCI INT B -> Link[LUS2] -> GSI 23 (=
level, low) -> IRQ 23
[    0.974030] ehci_hcd 0000:00:04.1: setting latency timer to 64
[    0.974032] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    0.974138] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bu=
s number 1
[    0.974161] ehci_hcd 0000:00:04.1: debug port 1
[    0.974165] ehci_hcd 0000:00:04.1: cache line size of 32 is not suppor=
ted
[    0.974178] ehci_hcd 0000:00:04.1: irq 23, io mem 0xf0889000
[    0.988010] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    0.988100] usb usb1: configuration #1 chosen from 1 choice
[    0.988153] hub 1-0:1.0: USB hub found
[    0.988160] hub 1-0:1.0: 4 ports detected
[    0.988641] ACPI: PCI Interrupt Link [Z00P] enabled at IRQ 22
[    0.988645] ehci_hcd 0000:00:06.1: PCI INT B -> Link[Z00P] -> GSI 22 (=
level, low) -> IRQ 22
[    0.988652] ehci_hcd 0000:00:06.1: setting latency timer to 64
[    0.988654] ehci_hcd 0000:00:06.1: EHCI Host Controller
[    0.988745] ehci_hcd 0000:00:06.1: new USB bus registered, assigned bu=
s number 2
[    0.988764] ehci_hcd 0000:00:06.1: debug port 1
[    0.988768] ehci_hcd 0000:00:06.1: cache line size of 32 is not suppor=
ted
[    0.988780] ehci_hcd 0000:00:06.1: irq 22, io mem 0xf0889400
[    1.000016] ehci_hcd 0000:00:06.1: USB 2.0 started, EHCI 1.00
[    1.000095] usb usb2: configuration #1 chosen from 1 choice
[    1.000144] hub 2-0:1.0: USB hub found
[    1.000150] hub 2-0:1.0: 3 ports detected
[    1.000303] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.000645] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 21
[    1.000648] ohci_hcd 0000:00:04.0: PCI INT A -> Link[LUS0] -> GSI 21 (=
level, low) -> IRQ 21
[    1.000655] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    1.000658] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    1.000749] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bu=
s number 3
[    1.000767] ohci_hcd 0000:00:04.0: irq 21, io mem 0xf0886000
[    1.054079] usb usb3: configuration #1 chosen from 1 choice
[    1.054128] hub 3-0:1.0: USB hub found
[    1.054136] hub 3-0:1.0: 4 ports detected
[    1.054581] ACPI: PCI Interrupt Link [Z00O] enabled at IRQ 20
[    1.054585] ohci_hcd 0000:00:06.0: PCI INT A -> Link[Z00O] -> GSI 20 (=
level, low) -> IRQ 20
[    1.054592] ohci_hcd 0000:00:06.0: setting latency timer to 64
[    1.054595] ohci_hcd 0000:00:06.0: OHCI Host Controller
[    1.054685] ohci_hcd 0000:00:06.0: new USB bus registered, assigned bu=
s number 4
[    1.054702] ohci_hcd 0000:00:06.0: irq 20, io mem 0xf0887000
[    1.093840] ACPI: Battery Slot [BAT0] (battery present)
[    1.110073] usb usb4: configuration #1 chosen from 1 choice
[    1.110122] hub 4-0:1.0: USB hub found
[    1.110129] hub 4-0:1.0: 3 ports detected
[    1.110272] uhci_hcd: USB Universal Host Controller Interface driver
[    1.110406] usbcore: registered new interface driver usbserial
[    1.110446] USB Serial support registered for generic
[    1.110487] usbcore: registered new interface driver usbserial_generic=

[    1.110489] usbserial: USB Serial Driver core
[    1.110585] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0=
x64 irq 1,12
[    1.116090] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.116095] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.116233] mice: PS/2 mouse device common for all mice
[    1.116496] rtc_cmos 00:0a: RTC can wake from S4
[    1.116548] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
[    1.116595] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet ir=
qs
[    1.116752] device-mapper: uevent: version 1.0.3
[    1.116874] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialise=
d: dm-devel@redhat.com
[    1.116944] device-mapper: multipath: version 1.0.5 loaded
[    1.116946] device-mapper: multipath round-robin: version 1.0.0 loaded=

[    1.117073] EISA: Probing bus 0 at eisa.0
[    1.117078] Cannot allocate resource for EISA slot 1
[    1.117080] Cannot allocate resource for EISA slot 2
[    1.117082] Cannot allocate resource for EISA slot 3
[    1.117084] Cannot allocate resource for EISA slot 4
[    1.117085] Cannot allocate resource for EISA slot 5
[    1.117087] Cannot allocate resource for EISA slot 6
[    1.117093] EISA: Detected 0 cards.
[    1.117459] cpuidle: using governor ladder
[    1.117975] cpuidle: using governor menu
[    1.118535] TCP cubic registered
[    1.118848] NET: Registered protocol family 10
[    1.119214] lo: Disabled Privacy Extensions
[    1.119268] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input5
[    1.119482] NET: Registered protocol family 17
[    1.119531] Bluetooth: L2CAP ver 2.13
[    1.119533] Bluetooth: L2CAP socket layer initialized
[    1.119535] Bluetooth: SCO (Voice Link) ver 0.6
[    1.119536] Bluetooth: SCO socket layer initialized
[    1.119567] Bluetooth: RFCOMM socket layer initialized
[    1.119571] Bluetooth: RFCOMM TTY layer initialized
[    1.119572] Bluetooth: RFCOMM ver 1.11
[    1.120060] Using IPI No-Shortcut mode
[    1.120211] PM: Resume from disk failed.
[    1.120222] registered taskstats version 1
[    1.120333]   Magic number: 9:22:549
[    1.120368] pci_link PNP0C0F:00: hash matches
[    1.120379] processor ACPI_CPU:04: hash matches
[    1.120443] rtc_cmos 00:0a: setting system clock to 2009-05-19 20:31:0=
9 UTC (1242765069)
[    1.120446] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.120447] EDD information not available.
[    1.288119] ata5: SATA link down (SStatus 0 SControl 300)
[    1.288151] ata3: SATA link down (SStatus 0 SControl 300)
[    1.288167] ata6: SATA link down (SStatus 0 SControl 300)
[    1.288191] ata4: SATA link down (SStatus 0 SControl 300)
[    1.428052] usb 2-3: new high speed USB device using ehci_hcd and addr=
ess 2
[    1.452059] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.452072] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.456544] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GS20N, A106, max UDMA/13=
3
[    1.461354] ata2.00: configured for UDMA/133
[    1.495270] ata1.00: ATA-8: TOSHIBA MK3252GSX, LV011D, max UDMA/100
[    1.495274] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/=
32)
[    1.496182] ata1.00: configured for UDMA/100
[    1.496272] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3252GS =
LV01 PQ: 0 ANSI: 5
[    1.496667] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (32=
0 GB/298 GiB)
[    1.496681] sd 0:0:0:0: [sda] Write Protect is off
[    1.496683] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.496702] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.496785]  sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.499842] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GS20N    =
A106 PQ: 0 ANSI: 5
[    1.504039] Clocksource tsc unstable (delta =3D -157210374 ns)
[    1.510969] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form=
2 cdda caddy
[    1.510973] Uniform CD-ROM driver Revision: 3.20
[    1.511278] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.511410] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.545953]  sda1 sda2 sda3 sda4 <<6>usb 2-3: configuration #1 chosen =
from 1 choice
[    1.573354]  sda5 >
[    1.574127] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.574153] Freeing unused kernel memory: 516k freed
[    1.574420] Write protecting the kernel text: 4352k
[    1.574455] Write protecting the kernel read-only data: 1720k
[    1.830288] forcedeth: Reverse Engineered nForce ethernet driver. Vers=
ion 0.64.
[    1.830673] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 19
[    1.830678] forcedeth 0000:00:0a.0: PCI INT A -> Link[LMAC] -> GSI 19 =
(level, low) -> IRQ 19
[    1.830684] forcedeth 0000:00:0a.0: setting latency timer to 64
[    1.949177] usb 3-4: new full speed USB device using ohci_hcd and addr=
ess 2
[    1.951784] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
[    1.951794] ohci1394 0000:01:07.0: PCI INT A -> Link[LNK1] -> GSI 11 (=
level, low) -> IRQ 11
[    1.985956] b43-pci-bridge 0000:06:00.0: PCI INT A -> Link[Z016] -> GS=
I 21 (level, low) -> IRQ 21
[    1.985966] b43-pci-bridge 0000:06:00.0: setting latency timer to 64
[    2.006034] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[11]  MMIO=3D=
[f0500000-f05007ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/4]
[    2.033085] ssb: ERROR: PLL init unknown for device 4322
[    2.033089] ssb: ERROR: PMU resource config unknown for device 4322
[    2.061103] ssb: Sonics Silicon Backplane found on PCI device 0000:06:=
00.0
[    2.169091] usb 3-4: configuration #1 chosen from 1 choice
[    2.172047] hub 3-4:1.0: USB hub found
[    2.175019] hub 3-4:1.0: 3 ports detected
[    2.353885] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x50ef @ 0, a=
ddr 00:21:70:8f:69:67
[    2.353889] forcedeth 0000:00:0a.0: highdma csum pwrctl gbit lnktim ms=
i desc-v3
[    2.419378] PM: Starting manual resume from disk
[    2.419381] PM: Resume from partition 8:5
[    2.419382] PM: Checking hibernation image.
[    2.419510] PM: Resume from disk failed.
[    2.475523] kjournald starting.  Commit interval 5 seconds
[    2.475534] EXT3-fs: mounted filesystem with writeback data mode.
[    2.494034] usb 3-4.1: new full speed USB device using ohci_hcd and ad=
dress 3
[    2.605121] usb 3-4.1: configuration #1 chosen from 1 choice
[    2.686042] usb 3-4.2: new full speed USB device using ohci_hcd and ad=
dress 4
[    2.798109] usb 3-4.2: configuration #1 chosen from 1 choice
[    3.280460] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[6d4fc0004b76=
deff]
[    8.361389] udev: starting version 142
[    8.526272] usbcore: registered new interface driver hiddev
[    8.531262] input: HID 413c:8157 as /devices/pci0000:00/0000:00:04.0/u=
sb3/3-4/3-4.1/3-4.1:1.0/input/input6
[    8.531328] generic-usb 0003:413C:8157.0001: input,hidraw0: USB HID v1=
=2E11 Keyboard [HID 413c:8157] on usb-0000:00:04.0-4.1/input0
[    8.537332] input: HID 413c:8158 as /devices/pci0000:00/0000:00:04.0/u=
sb3/3-4/3-4.2/3-4.2:1.0/input/input7
[    8.537408] generic-usb 0003:413C:8158.0002: input,hidraw1: USB HID v1=
=2E11 Mouse [HID 413c:8158] on usb-0000:00:04.0-4.2/input0
[    8.537429] usbcore: registered new interface driver usbhid
[    8.537432] usbhid: v2.6:USB HID core driver
[    8.596511] Linux agpgart interface v0.103
[    8.637255] Linux video capture interface: v2.00
[    8.658613] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[    8.669151] input: PC Speaker as /devices/platform/pcspkr/input/input8=

[    8.682152] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x3040
[    8.682167] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2000
[    8.818019] dcdbas dcdbas: Dell Systems Management Base Driver (versio=
n 5.6.0-3.2)
[    8.819372] sdhci: Secure Digital Host Controller Interface driver
[    8.819374] sdhci: Copyright(c) Pierre Ossman
[    8.820673] sdhci-pci 0000:01:07.1: SDHCI controller found [1180:0822]=
 (rev 22)
[    8.821047] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 11
[    8.821052] sdhci-pci 0000:01:07.1: PCI INT B -> Link[LNK2] -> GSI 11 =
(level, low) -> IRQ 11
[    8.821071] sdhci-pci 0000:01:07.1: Will use DMA mode even though HW d=
oesn't fully claim to support it.
[    8.821101] Registered led device: mmc0::
[    8.821137] mmc0: SDHCI controller on PCI [0000:01:07.1] using DMA
[    8.821797] ricoh-mmc: Ricoh MMC Controller disabling driver
[    8.821799] ricoh-mmc: Copyright(c) Philip Langdale
[    8.821815] ricoh-mmc: Ricoh MMC controller found at 0000:01:07.2 [118=
0:0843] (rev 12)
[    8.821829] ricoh-mmc: Controller is now disabled.
[    8.825688] uvcvideo: Found UVC 1.00 device Integrated Webcam (05ca:18=
a3)
[    8.827260] input: Integrated Webcam as /devices/pci0000:00/0000:00:06=
=2E1/usb2/2-3/2-3:1.0/input/input9
[    8.827303] usbcore: registered new interface driver uvcvideo
[    8.827306] USB Video Class driver (v0.1.0)
[    9.046045] usb 3-4.3: new full speed USB device using ohci_hcd and ad=
dress 5
[    9.123951] nvidia: module license 'NVIDIA' taints kernel.
[    9.123955] Disabling lock debugging due to kernel taint
[    9.207182] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08=
:00/device:11/device:12/input/input10
[    9.207221] ACPI: Video Device [Z01I] (multi-head: no  rom: yes  post:=
 no)
[    9.388796] nvidia 0000:02:00.0: enabling device (0004 -> 0007)
[    9.388811] nvidia 0000:02:00.0: PCI INT A -> Link[Z00Q] -> GSI 23 (le=
vel, low) -> IRQ 23
[    9.388823] nvidia 0000:02:00.0: setting latency timer to 64
[    9.389544] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 18
[    9.389547] nvidia 0000:03:00.0: PCI INT A -> Link[LGPU] -> GSI 18 (le=
vel, low) -> IRQ 18
[    9.389552] nvidia 0000:03:00.0: setting latency timer to 64
[    9.389666] NVRM: loading NVIDIA UNIX x86 Kernel Module  180.44  Mon M=
ar 23 14:59:10 PST 2009
[    9.418142] usb 3-4.3: configuration #1 chosen from 1 choice
[    9.441121] cfg80211: Calling CRDA to update world regulatory domain
[    9.458734] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    9.458811] usbcore: registered new interface driver btusb
[    9.628808] cfg80211: World regulatory domain updated:
[    9.628811] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, m=
ax_eirp)
[    9.628813] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628816] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628818] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628820] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628822] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 m=
Bm)
[    9.667752] HDA Intel 0000:00:08.0: power state changed by ACPI to D0
[    9.668107] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 17
[    9.668111]   alloc irq_desc for 17 on cpu 0 node 0
[    9.668113]   alloc kstat_irqs on cpu 0 node 0
[    9.668118] HDA Intel 0000:00:08.0: PCI INT A -> Link[LAZA] -> GSI 17 =
(level, low) -> IRQ 17
[    9.668122] hda_intel: probe_mask set to 0x9 for device 1028:0271
[    9.668150] HDA Intel 0000:00:08.0: setting latency timer to 64
[    9.785554] b43-phy0: Broadcom 4322 WLAN found (core revision 16)
[    9.828120] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 8, Type 4, R=
evision 4)
[    9.828148] b43: probe of ssb0:0 failed with error -95
[    9.828186] Broadcom 43xx driver loaded [ Features: PLR, Firmware-ID: =
FW13 ]
[    9.943856] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: =
0xd04731/0xa40000
[    9.991400] input: SynPS/2 Synaptics TouchPad as /devices/platform/i80=
42/serio1/input/input11
[   10.332107] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:0=
8.0/input/input12
[   10.812124] input: HDA NVidia Mic at Ext Left Jack as /devices/pci0000=
:00/0000:00:08.0/input/input13
[   10.812209] input: HDA NVidia HP Out at Ext Left Jack as /devices/pci0=
000:00/0000:00:08.0/input/input14
[   10.812255] input: HDA NVidia HP Out at Ext Left Jack as /devices/pci0=
000:00/0000:00:08.0/input/input15
[   11.097536] lp: driver loaded but no devices found
[   11.167418] Adding 1759076k swap on /dev/sda5.  Priority:-1 extents:1 =
across:1759076k=20
[   11.697224] EXT3 FS on sda3, internal journal
[   15.113042] CE: hpet increasing min_delta_ns to 15000 nsec
[   15.517366] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.517369] Bluetooth: BNEP filters: protocol multicast
[   15.534986] Bridge firewalling registered
[   17.163342] ppdev: user-space parallel port driver
[   19.057870] IRQ 18/nvidia: IRQF_DISABLED is not guaranteed on shared I=
RQs
[   20.625966] eth0: no link during initialization.
[   20.626420] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.732733] IRQ 23/nvidia: IRQF_DISABLED is not guaranteed on shared I=
RQs
[   20.739709] NVRM: RmInitAdapter failed! (0x31:0xffffffff:1018)
[   20.739716] NVRM: rm_init_adapter(0) failed
[   22.450065] eth0: link up.
[   22.450857] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.832040] eth0: no IPv6 routers present
[   35.112810] Too big adjustment 32
[   35.161636] Too big adjustment 32
[   35.186721] Too big adjustment 32
[   35.201658] Too big adjustment 32
[   35.226097] Too big adjustment 32
[   35.273620] Too big adjustment 32
[   35.305855] Too big adjustment 32
[   43.455139] gvfs-gdu-volume[4462]: segfault at c ip 001e6fda sp bfdd78=
60 error 4 in libgdu.so.0.0.0[1de000+22000]
[   45.199507] gvfs-gdu-volume[4479]: segfault at c ip 005b5fda sp bfce82=
b0 error 4 in libgdu.so.0.0.0[5ad000+22000]
[  107.504482] PM: Syncing filesystems ... done.
[  107.506244] PM: Preparing system for mem sleep
[  107.506248] Freezing user space processes ... (elapsed 0.00 seconds) d=
one.
[  107.506733] Freezing remaining freezable tasks ... (elapsed 0.00 secon=
ds) done.
[  107.506763] PM: Entering mem sleep
[  107.506773] Suspending console(s) (use no_console_suspend to debug)
[  107.507040] btusb_bulk_complete: hci0 urb f6b2a480 failed to resubmit =
(1)
[  107.508091] btusb_bulk_complete: hci0 urb f6b2a200 failed to resubmit =
(1)
[  107.509091] btusb_intr_complete: hci0 urb f6b2a280 failed to resubmit =
(1)
[  107.596045] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  107.691561] sd 0:0:0:0: [sda] Stopping disk
[  108.720443] b43-pci-bridge 0000:06:00.0: PCI INT A disabled
[  108.736138] NVRM: RmPowerManagement: 4
[  108.738308] ACPI handle has no context!
[  108.738315] sdhci-pci 0000:01:07.1: PME# disabled
[  108.738322] sdhci-pci 0000:01:07.1: PCI INT B disabled
[  108.738327] ACPI handle has no context!
[  108.756112] ACPI handle has no context!
[  108.884426] forcedeth 0000:00:0a.0: wake-up capability disabled by ACP=
I
[  108.884431] forcedeth 0000:00:0a.0: PME# disabled
[  108.884434] forcedeth 0000:00:0a.0: PCI INT A disabled
[  108.988050] HDA Intel 0000:00:08.0: PCI INT A disabled
[  109.004225] HDA Intel 0000:00:08.0: power state changed by ACPI to D3
[  109.004240] ehci_hcd 0000:00:06.1: PCI INT B disabled
[  109.004265] ehci_hcd 0000:00:06.1: PME# disabled
[  109.020114] ohci_hcd 0000:00:06.0: PCI INT A disabled
[  109.020141] ohci_hcd 0000:00:06.0: PME# disabled
[  109.036113] ehci_hcd 0000:00:04.1: PCI INT B disabled
[  109.036144] ehci_hcd 0000:00:04.1: PME# disabled
[  109.052114] ohci_hcd 0000:00:04.0: PCI INT A disabled
[  109.052141] ohci_hcd 0000:00:04.0: PME# disabled
[  109.068189] PM: suspend devices took 1.564 seconds
[  109.068383] ricoh-mmc: Suspending.
[  109.068389] ricoh-mmc: Controller is now re-enabled.
[  109.069624] ACPI: Preparing to enter system sleep state S3
[  109.069985] Disabling non-boot CPUs ...
[  109.072236] CPU 1 is now offline
[  109.072237] SMP alternatives: switching to UP code
[  109.077233] CPU0 attaching NULL sched-domain.
[  109.077236] CPU1 attaching NULL sched-domain.
[  109.077241] CPU0 attaching NULL sched-domain.
[  109.077365] CPU1 is down
[  109.077434] Extended CMOS year: 2000
[  109.077434] Back to C!
[  109.077434] Extended CMOS year: 2000
[  109.084299] Enabling non-boot CPUs ...
[  109.084491] SMP alternatives: switching to SMP code
[  109.089179] Booting processor 1 APIC 0x1 ip 0x6000
[  109.077130] Initializing CPU#1
[  109.077130] Calibrating delay using timer specific routine.. 4800.00 B=
ogoMIPS (lpj=3D9600013)
[  109.077130] CPU: L1 I cache: 32K, L1 D cache: 32K
[  109.077130] CPU: L2 cache: 3072K
[  109.077130] CPU: Physical Processor ID: 0
[  109.077130] CPU: Processor Core ID: 1
[  109.180590] CPU1: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz step=
ping 06
[  109.180657] CPU0 attaching NULL sched-domain.
[  109.181016] Switched to high resolution mode on CPU 1
[  109.196023] CPU0 attaching sched-domain:
[  109.196026]  domain 0: span 0-1 level MC
[  109.196029]   groups: 0 1
[  109.196034] CPU1 attaching sched-domain:
[  109.196036]  domain 0: span 0-1 level MC
[  109.196039]   groups: 1 0
[  109.197019] CPU1 is up
[  109.197023] ACPI: Waking up from system sleep state S3
[  109.197577] ohci_hcd 0000:00:04.0: restoring config space at offset 0x=
1 (was 0xb00007, writing 0xb00003)
[  109.197601] ehci_hcd 0000:00:04.1: restoring config space at offset 0x=
1 (was 0xb00006, writing 0xb00002)
[  109.197624] ohci_hcd 0000:00:06.0: restoring config space at offset 0x=
1 (was 0xb00007, writing 0xb00003)
[  109.197647] ehci_hcd 0000:00:06.1: restoring config space at offset 0x=
1 (was 0xb00006, writing 0xb00002)
[  109.197671] HDA Intel 0000:00:08.0: restoring config space at offset 0=
x1 (was 0xb00006, writing 0xb00002)
[  109.197728] ahci 0000:00:0b.0: restoring config space at offset 0x1 (w=
as 0xb00007, writing 0xb00407)
[  109.197843] pcieport-driver 0000:00:0c.0: restoring config space at of=
fset 0x1 (was 0x100007, writing 0x100407)
[  109.198043] pcieport-driver 0000:00:15.0: restoring config space at of=
fset 0x1 (was 0x100007, writing 0x100407)
[  109.198209] pcieport-driver 0000:00:16.0: restoring config space at of=
fset 0x7 (was 0x1f1, writing 0x200001f1)
[  109.198232] pcieport-driver 0000:00:16.0: restoring config space at of=
fset 0x1 (was 0x100007, writing 0x100407)
[  109.198415] pcieport-driver 0000:00:17.0: restoring config space at of=
fset 0x1 (was 0x100007, writing 0x100407)
[  109.198598] pcieport-driver 0000:00:18.0: restoring config space at of=
fset 0x1 (was 0x100007, writing 0x100407)
[  109.198692] ohci1394 0000:01:07.0: restoring config space at offset 0x=
f (was 0x4020100, writing 0x402010a)
[  109.198705] ohci1394 0000:01:07.0: restoring config space at offset 0x=
4 (was 0x0, writing 0xf0500000)
[  109.198709] ohci1394 0000:01:07.0: restoring config space at offset 0x=
3 (was 0x800000, writing 0x804010)
[  109.198714] ohci1394 0000:01:07.0: restoring config space at offset 0x=
1 (was 0x2100000, writing 0x2100006)
[  109.198729] sdhci-pci 0000:01:07.1: restoring config space at offset 0=
xf (was 0x200, writing 0x20b)
[  109.198742] sdhci-pci 0000:01:07.1: restoring config space at offset 0=
x4 (was 0x0, writing 0xf0500800)
[  109.198746] sdhci-pci 0000:01:07.1: restoring config space at offset 0=
x3 (was 0x800000, writing 0x804010)
[  109.198751] sdhci-pci 0000:01:07.1: restoring config space at offset 0=
x1 (was 0x2100000, writing 0x2100006)
[  109.198765] ricoh-mmc 0000:01:07.2: restoring config space at offset 0=
xf (was 0x200, writing 0x20b)
[  109.198779] ricoh-mmc 0000:01:07.2: restoring config space at offset 0=
x4 (was 0x0, writing 0xf0500c00)
[  109.198783] ricoh-mmc 0000:01:07.2: restoring config space at offset 0=
x3 (was 0x800000, writing 0x804010)
[  109.198788] ricoh-mmc 0000:01:07.2: restoring config space at offset 0=
x1 (was 0x2100000, writing 0x2100006)
[  109.198795] ricoh-mmc: Resuming.
[  109.198801] ricoh-mmc: Controller is now disabled.
[  109.198809] pci 0000:01:07.3: restoring config space at offset 0xf (wa=
s 0x200, writing 0x20b)
[  109.198822] pci 0000:01:07.3: restoring config space at offset 0x4 (wa=
s 0x0, writing 0xf0501400)
[  109.198826] pci 0000:01:07.3: restoring config space at offset 0x3 (wa=
s 0x800000, writing 0x804010)
[  109.198831] pci 0000:01:07.3: restoring config space at offset 0x1 (wa=
s 0x2100000, writing 0x2100006)
[  109.212111] nvidia 0000:02:00.0: restoring config space at offset 0x1 =
(was 0x100004, writing 0x100007)
[  109.212155] nvidia 0000:03:00.0: restoring config space at offset 0x3 =
(was 0x10, writing 0x0)
[  109.212191] b43-pci-bridge 0000:06:00.0: restoring config space at off=
set 0xf (was 0x100, writing 0x10b)
[  109.212214] b43-pci-bridge 0000:06:00.0: restoring config space at off=
set 0x4 (was 0x4, writing 0xf0400004)
[  109.212220] b43-pci-bridge 0000:06:00.0: restoring config space at off=
set 0x3 (was 0x0, writing 0x10)
[  109.212228] b43-pci-bridge 0000:06:00.0: restoring config space at off=
set 0x1 (was 0x100000, writing 0x100006)
[  109.442070] nForce2_smbus 0000:00:03.2: PME# disabled
[  109.442092] ohci_hcd 0000:00:04.0: PME# disabled
[  109.442098] ohci_hcd 0000:00:04.0: PCI INT A -> Link[LUS0] -> GSI 21 (=
level, low) -> IRQ 21
[  109.442102] ohci_hcd 0000:00:04.0: setting latency timer to 64
[  109.442106] ohci_hcd 0000:00:04.0: PME# disabled
[  109.464139] ehci_hcd 0000:00:04.1: PME# disabled
[  109.464145] ehci_hcd 0000:00:04.1: PCI INT B -> Link[LUS2] -> GSI 23 (=
level, low) -> IRQ 23
[  109.464151] ehci_hcd 0000:00:04.1: setting latency timer to 64
[  109.464156] ehci_hcd 0000:00:04.1: PME# disabled
[  109.464190] ohci_hcd 0000:00:06.0: PME# disabled
[  109.464196] ohci_hcd 0000:00:06.0: PCI INT A -> Link[Z00O] -> GSI 20 (=
level, low) -> IRQ 20
[  109.464201] ohci_hcd 0000:00:06.0: setting latency timer to 64
[  109.464206] ohci_hcd 0000:00:06.0: PME# disabled
[  109.488139] ehci_hcd 0000:00:06.1: PME# disabled
[  109.488145] ehci_hcd 0000:00:06.1: PCI INT B -> Link[Z00P] -> GSI 22 (=
level, low) -> IRQ 22
[  109.488150] ehci_hcd 0000:00:06.1: setting latency timer to 64
[  109.488156] ehci_hcd 0000:00:06.1: PME# disabled
[  109.488189] HDA Intel 0000:00:08.0: PCI INT A -> Link[LAZA] -> GSI 17 =
(level, low) -> IRQ 17
[  109.488195] HDA Intel 0000:00:08.0: setting latency timer to 64
[  109.488223] pci 0000:00:09.0: setting latency timer to 64
[  109.488253] forcedeth 0000:00:0a.0: wake-up capability disabled by ACP=
I
[  109.488257] forcedeth 0000:00:0a.0: PME# disabled
[  110.008371] ahci 0000:00:0b.0: setting latency timer to 64
[  110.008450] pci 0000:00:10.0: setting latency timer to 64
[  110.066070] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[11]  MMIO=3D=
[f0500000-f05007ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/4]
[  110.072128] sdhci-pci 0000:01:07.1: PCI INT B -> Link[LNK2] -> GSI 11 =
(level, low) -> IRQ 11
[  110.072131] sdhci-pci 0000:01:07.1: Will use DMA mode even though HW d=
oesn't fully claim to support it.
[  110.072143] pci 0000:01:07.3: PME# disabled
[  110.072146] pci 0000:01:07.4: PME# disabled
[  110.073631] NVRM: RmPowerManagement: 5
[  110.569066] ata3: SATA link down (SStatus 0 SControl 300)
[  110.569105] ata4: SATA link down (SStatus 0 SControl 300)
[  110.573041] ata6: SATA link down (SStatus 0 SControl 300)
[  110.705065] ata5: SATA link down (SStatus 0 SControl 300)
[  110.733060] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  110.742400] ata2.00: configured for UDMA/133
[  110.747750] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4=

[  110.747752] ata2: irq_stat 0x40000001
[  110.752236] b43-pci-bridge 0000:06:00.0: PCI INT A -> Link[Z016] -> GS=
I 21 (level, low) -> IRQ 21
[  110.756346] ata2.00: configured for UDMA/133
[  110.756349] ata2: EH complete
[  111.016116] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  111.017773] ata1.00: configured for UDMA/100
[  111.017779] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4=

[  111.017781] ata1: irq_stat 0x00400040, connection status changed
[  111.019396] ata1.00: configured for UDMA/100
[  111.019398] ata1: EH complete
[  111.236993] sd 0:0:0:0: [sda] Starting disk
[  111.356035] usb 2-3: reset high speed USB device using ehci_hcd and ad=
dress 2
[  111.668045] usb 3-4: reset full speed USB device using ohci_hcd and ad=
dress 2
[  112.177152] usb 3-4.1: reset full speed USB device using ohci_hcd and =
address 3
[  112.361151] usb 3-4.2: reset full speed USB device using ohci_hcd and =
address 4
[  112.471157] pm_op(): usb_dev_resume+0x0/0x10 returns -19
[  112.471160] PM: Device 3-4.3 failed to resume: error -19
[  112.471373] PM: resume devices took 3.256 seconds
[  112.471980] PM: Finishing wakeup.
[  112.471982] Restarting tasks ... <6>usb 3-4.3: USB disconnect, address=
 5
[  112.504314] btusb_send_frame: hci0 urb f4520700 submission failed
[  112.537026] done.
[  113.112944]   alloc irq_desc for 30 on cpu 0 node 0
[  113.112947]   alloc kstat_irqs on cpu 0 node 0
[  113.112959] forcedeth 0000:00:0a.0: irq 30 for MSI/MSI-X
[  113.113177] eth0: no link during initialization.
[  113.113635] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  114.902143] eth0: link up.
[  114.903012] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  125.072042] eth0: no IPv6 routers present

--------------000800000405080602040301
Content-Type: text/plain;
 name="dmesg_presuspend.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="dmesg_presuspend.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-5-generic (buildd@rothera) (gcc versi=
on 4.4.1 (Ubuntu 4.4.0-3ubuntu3) ) #6-Ubuntu SMP Mon May 11 19:56:30 UTC =
2009 (Ubuntu 2.6.30-5.6-generic)
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000006fec0000 (usable)
[    0.000000]  BIOS-e820: 000000006fec0000 - 000000006fecf000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000006fecf000 - 000000006fee5000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000006fee5000 - 0000000080000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)=

[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x6fec0 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-DBFFF uncachable
[    0.000000]   DC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07FF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (us=
able) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000006fec0000 (usable)
[    0.000000]  modified: 000000006fec0000 - 000000006fecf000 (ACPI data)=

[    0.000000]  modified: 000000006fecf000 - 000000006fee5000 (ACPI NVS)
[    0.000000]  modified: 000000006fee5000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000] Using x86 segment limits to approximate NX protection
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 3787e000 - 37fef6d5
[    0.000000] Allocated new RAMDISK: 00859000 - 00fca6d5
[    0.000000] Move RAMDISK from 000000003787e000 - 0000000037fef6d4 to 0=
0859000 - 00fca6d4
[    0.000000] ACPI: RSDP 000f7b20 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 6fec3b2f 000A4 (v01 DELL    QA09    06040000  L=
TP 00000000)
[    0.000000] ACPI: FACP 6fecec04 000F4 (v03 NVIDIA MCP79    06040000 PT=
L_ 000F4240)
[    0.000000] ACPI: DSDT 6fec56c1 094CF (v01 NVIDIA    MCP79 06040000 MS=
FT 03000001)
[    0.000000] ACPI: FACS 6fee4fc0 00040
[    0.000000] ACPI: MCFG 6fececf8 0003C (v01 PTLTD    MCFG   06040000  L=
TP 00000000)
[    0.000000] ACPI: HPET 6feced34 00038 (v01 PTLTD  HPETTBL  06040000  L=
TP 00000001)
[    0.000000] ACPI: APIC 6feced6c 00072 (v01 PTLTD  	 APIC   06040000  L=
TP 00000000)
[    0.000000] ACPI: BOOT 6fecedde 00028 (v01 PTLTD  $SBFTBL$ 06040000  L=
TP 00000001)
[    0.000000] ACPI: SLIC 6fecee06 00176 (v01 DELL    QA09    06040000  L=
TP 00000000)
[    0.000000] ACPI: OSFR 6fecef7c 00084 (v01 DELL   DELL     06040000 AS=
L  00000061)
[    0.000000] ACPI: SSDT 6fec5462 0025F (v01  PmRef  Cpu0Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec53bc 000A6 (v01  PmRef  Cpu7Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec5316 000A6 (v01  PmRef  Cpu6Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec5270 000A6 (v01  PmRef  Cpu5Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec51ca 000A6 (v01  PmRef  Cpu4Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec5124 000A6 (v01  PmRef  Cpu3Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec507e 000A6 (v01  PmRef  Cpu2Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec4fd8 000A6 (v01  PmRef  Cpu1Tst 00003000 IN=
TL 20050228)
[    0.000000] ACPI: SSDT 6fec3bd3 01405 (v01  PmRef    CpuPm 00003000 IN=
TL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 902MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 00377=
fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [0=
000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [0=
000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [0=
000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00008544b4]    TEXT DATA BSS =3D=3D> [0=
000100000 - 00008544b4]
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved =3D=3D> [0=
00009dc00 - 0000100000]
[    0.000000]   #5 [0000855000 - 0000858130]              BRK =3D=3D> [0=
000855000 - 0000858130]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE =3D=3D> [0=
000007000 - 0000008000]
[    0.000000]   #7 [0000859000 - 0000fca6d5]      NEW RAMDISK =3D=3D> [0=
000859000 - 0000fca6d5]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP =3D=3D> [0=
000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00f7b50] f7b50
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0006fec0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0006fec0
[    0.000000] On node 0 totalpages: 458329
[    0.000000] free_area_init_node: node 0, pgdat c0725d40, node_mem_map =
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3961 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1806 pages used for memmap
[    0.000000]   HighMem zone: 229300 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)=

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)=

[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10dea301 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 000000000=
0006000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000=
009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000=
00a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 000000000=
00e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 000000000=
0100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 800000=
00:60000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c1e07000, static data 25628 b=
ytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 454747
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-5-g=
eneric root=3DUUID=3D43180eb4-fa9a-4157-95c2-3bf4eabb45aa ro quiet splash=

[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2399.932 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[    0.004000] allocated 9168640 bytes of page_cgroup
[    0.004000] please try cgroup_disable=3Dmemory option if you don't wan=
t
[    0.004000] Initializing HighMem for node 0 (000377fe:0006fec0)
[    0.004000] Memory: 1793068k/1833728k available (4351k kernel code, 39=
392k reserved, 1994k data, 516k init, 924424k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.004000]       .init : 0xc073b000 - 0xc07bc000   ( 516 kB)
[    0.004000]       .data : 0xc053fcce - 0xc0732708   (1994 kB)
[    0.004000]       .text : 0xc0100000 - 0xc053fcce   (4351 kB)
[    0.004000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.004000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.004000] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 4799.86 BogoMIPS (lpj=3D9599728)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys net_cls
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] Checking 'hlt' instruction... OK.
[    0.018165] ACPI: Core revision 20090320
[    0.032429] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.072558] CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz step=
ping 06
[    0.076001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4799.98 B=
ogoMIPS (lpj=3D9599973)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.160583] CPU1: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz step=
ping 06
[    0.160600] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.164018] Brought up 2 CPUs
[    0.164020] Total of 2 processors activated (9599.85 BogoMIPS).
[    0.164087] CPU0 attaching sched-domain:
[    0.164089]  domain 0: span 0-1 level MC
[    0.164091]   groups: 0 1
[    0.164096] CPU1 attaching sched-domain:
[    0.164098]  domain 0: span 0-1 level MC
[    0.164100]   groups: 1 0
[    0.164162] net_namespace: 1056 bytes
[    0.164162] Booting paravirtualized kernel on bare hardware
[    0.164162] regulator: core version 0.5
[    0.164162] Time: 20:31:08  Date: 05/19/09
[    0.164162] NET: Registered protocol family 16
[    0.164162] EISA bus registered
[    0.164162] ACPI: bus type pci registered
[    0.164162] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0=
 - 7
[    0.164162] PCI: MCFG area at e0000000 reserved in E820
[    0.164162] PCI: Using MMCONFIG for extended config space
[    0.164162] PCI: Using configuration type 1 for base access
[    0.168030] bio: create slab <bio-0> at 0
[    0.169076] ACPI: EC: Look up EC in DSDT
[    0.175055] ACPI: Interpreter enabled
[    0.175059] ACPI: (supports S0 S3 S4 S5)
[    0.175075] ACPI: Using IOAPIC for interrupt routing
[    0.177165] ACPI: EC: non-query interrupt received, switching to inter=
rupt mode
[    0.192128] ACPI: EC: GPE =3D 0x47, I/O: command/status =3D 0x66, data=
 =3D 0x62
[    0.192128] ACPI: EC: driver started in interrupt mode
[    0.192317] ACPI: No dock devices found.
[    0.192444] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.192467] pci 0000:00:03.0: reg 10 io port: [0x1c00-0x1cff]
[    0.192467] pci 0000:00:03.2: reg 10 io port: [0x3080-0x30bf]
[    0.192467] pci 0000:00:03.2: reg 20 io port: [0x3040-0x307f]
[    0.192467] pci 0000:00:03.2: reg 24 io port: [0x2000-0x203f]
[    0.192467] pci 0000:00:03.2: PME# supported from D3hot D3cold
[    0.192467] pci 0000:00:03.2: PME# disabled
[    0.192481] pci 0000:00:03.5: reg 10 32bit mmio: [0xf0600000-0xf067fff=
f]
[    0.192570] pci 0000:00:04.0: reg 10 32bit mmio: [0xf0886000-0xf0886ff=
f]
[    0.192600] pci 0000:00:04.0: supports D1 D2
[    0.192602] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192605] pci 0000:00:04.0: PME# disabled
[    0.192632] pci 0000:00:04.1: reg 10 32bit mmio: [0xf0889000-0xf08890f=
f]
[    0.192667] pci 0000:00:04.1: supports D1 D2
[    0.192668] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192672] pci 0000:00:04.1: PME# disabled
[    0.192703] pci 0000:00:06.0: reg 10 32bit mmio: [0xf0887000-0xf0887ff=
f]
[    0.192732] pci 0000:00:06.0: supports D1 D2
[    0.192734] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192737] pci 0000:00:06.0: PME# disabled
[    0.192765] pci 0000:00:06.1: reg 10 32bit mmio: [0xf0889400-0xf08894f=
f]
[    0.192800] pci 0000:00:06.1: supports D1 D2
[    0.192801] pci 0000:00:06.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192805] pci 0000:00:06.1: PME# disabled
[    0.192836] pci 0000:00:08.0: reg 10 32bit mmio: [0xf0880000-0xf0883ff=
f]
[    0.192865] pci 0000:00:08.0: PME# supported from D3hot D3cold
[    0.192869] pci 0000:00:08.0: PME# disabled
[    0.192923] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf0888000-0xf0888ff=
f]
[    0.192927] pci 0000:00:0a.0: reg 14 io port: [0x30d0-0x30d7]
[    0.192932] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf0889c00-0xf0889cf=
f]
[    0.192936] pci 0000:00:0a.0: reg 1c 32bit mmio: [0xf0889800-0xf088980=
f]
[    0.192957] pci 0000:00:0a.0: supports D1 D2
[    0.192959] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.192963] pci 0000:00:0a.0: PME# disabled
[    0.192989] pci 0000:00:0b.0: reg 10 io port: [0x30e8-0x30ef]
[    0.192994] pci 0000:00:0b.0: reg 14 io port: [0x30dc-0x30df]
[    0.192998] pci 0000:00:0b.0: reg 18 io port: [0x30e0-0x30e7]
[    0.193002] pci 0000:00:0b.0: reg 1c io port: [0x30d8-0x30db]
[    0.193006] pci 0000:00:0b.0: reg 20 io port: [0x30c0-0x30cf]
[    0.193011] pci 0000:00:0b.0: reg 24 32bit mmio: [0xf0884000-0xf0885ff=
f]
[    0.193218] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193225] pci 0000:00:0c.0: PME# disabled
[    0.193293] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193296] pci 0000:00:10.0: PME# disabled
[    0.193491] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193499] pci 0000:00:15.0: PME# disabled
[    0.193715] pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193722] pci 0000:00:16.0: PME# disabled
[    0.193938] pci 0000:00:17.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.193946] pci 0000:00:17.0: PME# disabled
[    0.196211] pci 0000:00:18.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196219] pci 0000:00:18.0: PME# disabled
[    0.196292] pci 0000:01:07.0: reg 10 32bit mmio: [0xf0500000-0xf05007f=
f]
[    0.196331] pci 0000:01:07.0: supports D1 D2
[    0.196332] pci 0000:01:07.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196336] pci 0000:01:07.0: PME# disabled
[    0.196364] pci 0000:01:07.1: reg 10 32bit mmio: [0xf0500800-0xf05008f=
f]
[    0.196403] pci 0000:01:07.1: supports D1 D2
[    0.196404] pci 0000:01:07.1: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196408] pci 0000:01:07.1: PME# disabled
[    0.196436] pci 0000:01:07.2: reg 10 32bit mmio: [0xf0500c00-0xf0500cf=
f]
[    0.196475] pci 0000:01:07.2: supports D1 D2
[    0.196476] pci 0000:01:07.2: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196480] pci 0000:01:07.2: PME# disabled
[    0.196508] pci 0000:01:07.3: reg 10 32bit mmio: [0xf0501000-0xf05010f=
f]
[    0.196547] pci 0000:01:07.3: supports D1 D2
[    0.196548] pci 0000:01:07.3: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196552] pci 0000:01:07.3: PME# disabled
[    0.196580] pci 0000:01:07.4: reg 10 32bit mmio: [0xf0501400-0xf05014f=
f]
[    0.196619] pci 0000:01:07.4: supports D1 D2
[    0.196620] pci 0000:01:07.4: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.196624] pci 0000:01:07.4: PME# disabled
[    0.196660] pci 0000:00:09.0: transparent bridge
[    0.196664] pci 0000:00:09.0: bridge 32bit mmio: [0xf0500000-0xf05ffff=
f]
[    0.196722] pci 0000:02:00.0: reg 10 32bit mmio: [0xae000000-0xaefffff=
f]
[    0.196738] pci 0000:02:00.0: reg 14 64bit mmio: [0xd0000000-0xdffffff=
f]
[    0.196755] pci 0000:02:00.0: reg 1c 64bit mmio: [0xac000000-0xadfffff=
f]
[    0.196767] pci 0000:02:00.0: reg 24 io port: [0x4000-0x407f]
[    0.196778] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.196873] pci 0000:00:0c.0: bridge io port: [0x4000-0x4fff]
[    0.196881] pci 0000:00:0c.0: bridge 32bit mmio: [0xac000000-0xaefffff=
f]
[    0.196895] pci 0000:00:0c.0: bridge 64bit mmio pref: [0xd0000000-0xdf=
ffffff]
[    0.196930] pci 0000:03:00.0: reg 10 32bit mmio: [0xaa000000-0xaafffff=
f]
[    0.196939] pci 0000:03:00.0: reg 14 64bit mmio: [0xb0000000-0xbffffff=
f]
[    0.196947] pci 0000:03:00.0: reg 1c 64bit mmio: [0xcc000000-0xcdfffff=
f]
[    0.196952] pci 0000:03:00.0: reg 24 io port: [0x5000-0x507f]
[    0.196958] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.197010] pci 0000:00:10.0: bridge io port: [0x5000-0x5fff]
[    0.197013] pci 0000:00:10.0: bridge 32bit mmio: [0xaa000000-0xaafffff=
f]
[    0.197017] pci 0000:00:10.0: bridge 64bit mmio pref: [0xb0000000-0xcd=
ffffff]
[    0.197076] pci 0000:00:15.0: bridge io port: [0x6000-0x6fff]
[    0.197084] pci 0000:00:15.0: bridge 32bit mmio: [0xf0200000-0xf03ffff=
f]
[    0.197098] pci 0000:00:15.0: bridge 64bit mmio pref: [0xf0000000-0xf0=
1fffff]
[    0.197173] pci 0000:06:00.0: reg 10 64bit mmio: [0xf0400000-0xf0403ff=
f]
[    0.197251] pci 0000:06:00.0: supports D1 D2
[    0.197253] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.197258] pci 0000:06:00.0: PME# disabled
[    0.197336] pci 0000:00:16.0: bridge 32bit mmio: [0xf0400000-0xf04ffff=
f]
[    0.197571] pci_bus 0000:00: on NUMA node 0
[    0.197576] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.197754] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.197768] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
[    0.260469] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 *10 11 14 15)
[    0.260469] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 10 *11 14 15)
[    0.260655] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15) *0,=
 disabled.
[    0.260883] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15) *0,=
 disabled.
[    0.261114] ACPI: PCI Interrupt Link [Z00Q] (IRQs 18 19 20 21 22 23) *=
11
[    0.261343] ACPI: PCI Interrupt Link [Z00R] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.261571] ACPI: PCI Interrupt Link [Z00S] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.261800] ACPI: PCI Interrupt Link [Z00T] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262028] ACPI: PCI Interrupt Link [Z00U] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262256] ACPI: PCI Interrupt Link [Z00V] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262484] ACPI: PCI Interrupt Link [Z00W] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262712] ACPI: PCI Interrupt Link [Z00X] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.262941] ACPI: PCI Interrupt Link [Z00Y] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264230] ACPI: PCI Interrupt Link [Z00Z] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264458] ACPI: PCI Interrupt Link [Z010] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264687] ACPI: PCI Interrupt Link [Z011] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.264914] ACPI: PCI Interrupt Link [Z012] (IRQs 18 19 20 21 22 23) *=
10
[    0.265142] ACPI: PCI Interrupt Link [Z013] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.265370] ACPI: PCI Interrupt Link [Z014] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.265598] ACPI: PCI Interrupt Link [Z015] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.265827] ACPI: PCI Interrupt Link [Z016] (IRQs 18 19 20 21 22 23) *=
11
[    0.266054] ACPI: PCI Interrupt Link [Z017] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.266283] ACPI: PCI Interrupt Link [Z018] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.266511] ACPI: PCI Interrupt Link [Z019] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.266739] ACPI: PCI Interrupt Link [Z01A] (IRQs 18 19 20 21 22 23) *=
10
[    0.266967] ACPI: PCI Interrupt Link [Z01B] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.267195] ACPI: PCI Interrupt Link [Z01C] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.267423] ACPI: PCI Interrupt Link [Z01D] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.267652] ACPI: PCI Interrupt Link [Z01E] (IRQs 18 19 20 21 22 23) *=
11
[    0.267880] ACPI: PCI Interrupt Link [Z01F] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.268119] ACPI: PCI Interrupt Link [Z01G] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.268348] ACPI: PCI Interrupt Link [Z01H] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.268576] ACPI: PCI Interrupt Link [LSMB] (IRQs 18 19 20 21 22 23) *=
10
[    0.268802] ACPI: PCI Interrupt Link [LUS0] (IRQs 18 19 20 21 22 23) *=
7
[    0.269032] ACPI: PCI Interrupt Link [LUS2] (IRQs 18 19 20 21 22 23) *=
11
[    0.269260] ACPI: PCI Interrupt Link [LMAC] (IRQs 18 19 20 21 22 23) *=
10
[    0.269487] ACPI: PCI Interrupt Link [LAZA] (IRQs 17) *11
[    0.269712] ACPI: PCI Interrupt Link [LGPU] (IRQs 18 19 20 21 22 23) *=
5
[    0.269939] ACPI: PCI Interrupt Link [LPID] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.270167] ACPI: PCI Interrupt Link [LSI0] (IRQs 18 19 20 21 22 23) *=
11
[    0.270396] ACPI: PCI Interrupt Link [LSI1] (IRQs 18 19 20 21 22 23) *=
0, disabled.
[    0.270625] ACPI: PCI Interrupt Link [Z00O] (IRQs 18 19 20 21 22 23) *=
5
[    0.270855] ACPI: PCI Interrupt Link [Z00P] (IRQs 18 19 20 21 22 23) *=
10
[    0.271083] ACPI: PCI Interrupt Link [LPMU] (IRQs 18 19 20 21 22 23) *=
10
[    0.271145] SCSI subsystem initialized
[    0.271145] libata version 3.00 loaded.
[    0.271145] usbcore: registered new interface driver usbfs
[    0.271145] usbcore: registered new interface driver hub
[    0.271145] usbcore: registered new device driver usb
[    0.272026] ACPI: WMI: Mapper loaded
[    0.272026] PCI: Using ACPI for IRQ routing
[    0.292006] Bluetooth: Core ver 2.15
[    0.292019] NET: Registered protocol family 31
[    0.292019] Bluetooth: HCI device and connection manager initialized
[    0.292019] Bluetooth: HCI socket layer initialized
[    0.292021] NET: Registered protocol family 8
[    0.292023] NET: Registered protocol family 20
[    0.292036] NetLabel: Initializing
[    0.292036] NetLabel:  domain hash size =3D 128
[    0.292036] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.292036] NetLabel:  unlabeled traffic allowed by default
[    0.292036] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31, 31
[    0.292036] hpet0: 4 comparators, 64-bit 25.000000 MHz counter
[    0.316007] pnp: PnP ACPI init
[    0.316014] ACPI: bus type pnp registered
[    0.317130] pnp 00:03: mem resource (0xf0600000-0xf0607fff) overlaps 0=
000:00:03.5 BAR 0 (0xf0600000-0xf067ffff), disabling
[    0.321690] pnp: PnP ACPI: found 13 devices
[    0.321692] ACPI: ACPI bus type pnp unregistered
[    0.321695] PnPBIOS: Disabled by ACPI PNP
[    0.321703] system 00:00: iomem range 0xffc00000-0xffffffff could not =
be reserved
[    0.321706] system 00:00: iomem range 0xfec00000-0xfec00fff has been r=
eserved
[    0.321709] system 00:00: iomem range 0xfee00000-0xfeefffff could not =
be reserved
[    0.321711] system 00:00: iomem range 0xfed00000-0xfed00fff has been r=
eserved
[    0.321719] system 00:04: ioport range 0x1000-0x107f has been reserved=

[    0.321721] system 00:04: ioport range 0x1080-0x10ff has been reserved=

[    0.321723] system 00:04: ioport range 0x1400-0x147f has been reserved=

[    0.321726] system 00:04: ioport range 0x1480-0x14ff has been reserved=

[    0.321728] system 00:04: ioport range 0x1800-0x187f has been reserved=

[    0.321730] system 00:04: ioport range 0x1880-0x18ff has been reserved=

[    0.321736] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.321738] system 00:07: ioport range 0x910-0x911 has been reserved
[    0.321741] system 00:07: ioport range 0x295-0x296 has been reserved
[    0.356640] pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
[    0.356642] pci 0000:00:09.0:   IO window: disabled
[    0.356646] pci 0000:00:09.0:   MEM window: 0xf0500000-0xf05fffff
[    0.356649] pci 0000:00:09.0:   PREFETCH window: disabled
[    0.356656] pci 0000:02:00.0: BAR 6: can't allocate mem resource [0xe0=
000000-0xdfffffff]
[    0.356658] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:02
[    0.356663] pci 0000:00:0c.0:   IO window: 0x4000-0x4fff
[    0.356673] pci 0000:00:0c.0:   MEM window: 0xac000000-0xaeffffff
[    0.356680] pci 0000:00:0c.0:   PREFETCH window: 0x000000d0000000-0x00=
0000dfffffff
[    0.356694] pci 0000:00:10.0: PCI bridge, secondary bus 0000:03
[    0.356696] pci 0000:00:10.0:   IO window: 0x5000-0x5fff
[    0.356699] pci 0000:00:10.0:   MEM window: 0xaa000000-0xaaffffff
[    0.356702] pci 0000:00:10.0:   PREFETCH window: 0x000000b0000000-0x00=
0000cdffffff
[    0.356706] pci 0000:00:15.0: PCI bridge, secondary bus 0000:04
[    0.356711] pci 0000:00:15.0:   IO window: 0x6000-0x6fff
[    0.356721] pci 0000:00:15.0:   MEM window: 0xf0200000-0xf03fffff
[    0.356728] pci 0000:00:15.0:   PREFETCH window: 0x000000f0000000-0x00=
0000f01fffff
[    0.356741] pci 0000:00:16.0: PCI bridge, secondary bus 0000:06
[    0.356743] pci 0000:00:16.0:   IO window: disabled
[    0.356752] pci 0000:00:16.0:   MEM window: 0xf0400000-0xf04fffff
[    0.356760] pci 0000:00:16.0:   PREFETCH window: disabled
[    0.356772] pci 0000:00:17.0: PCI bridge, secondary bus 0000:07
[    0.356774] pci 0000:00:17.0:   IO window: disabled
[    0.356783] pci 0000:00:17.0:   MEM window: disabled
[    0.356790] pci 0000:00:17.0:   PREFETCH window: disabled
[    0.356803] pci 0000:00:18.0: PCI bridge, secondary bus 0000:08
[    0.356804] pci 0000:00:18.0:   IO window: disabled
[    0.356814] pci 0000:00:18.0:   MEM window: disabled
[    0.356821] pci 0000:00:18.0:   PREFETCH window: disabled
[    0.356838] pci 0000:00:09.0: setting latency timer to 64
[    0.357173] ACPI: PCI Interrupt Link [Z00Q] enabled at IRQ 23
[    0.357176]   alloc irq_desc for 23 on cpu 0 node 0
[    0.357178]   alloc kstat_irqs on cpu 0 node 0
[    0.357182] pci 0000:00:0c.0: PCI INT A -> Link[Z00Q] -> GSI 23 (level=
, low) -> IRQ 23
[    0.357191] pci 0000:00:0c.0: setting latency timer to 64
[    0.357198] pci 0000:00:10.0: setting latency timer to 64
[    0.357524] ACPI: PCI Interrupt Link [Z012] enabled at IRQ 22
[    0.357527]   alloc irq_desc for 22 on cpu 0 node 0
[    0.357528]   alloc kstat_irqs on cpu 0 node 0
[    0.357532] pci 0000:00:15.0: PCI INT A -> Link[Z012] -> GSI 22 (level=
, low) -> IRQ 22
[    0.357540] pci 0000:00:15.0: setting latency timer to 64
[    0.357869] ACPI: PCI Interrupt Link [Z016] enabled at IRQ 21
[    0.357872]   alloc irq_desc for 21 on cpu 0 node 0
[    0.357873]   alloc kstat_irqs on cpu 0 node 0
[    0.357877] pci 0000:00:16.0: PCI INT A -> Link[Z016] -> GSI 21 (level=
, low) -> IRQ 21
[    0.357885] pci 0000:00:16.0: setting latency timer to 64
[    0.358214] ACPI: PCI Interrupt Link [Z01A] enabled at IRQ 20
[    0.358216]   alloc irq_desc for 20 on cpu 0 node 0
[    0.358218]   alloc kstat_irqs on cpu 0 node 0
[    0.358221] pci 0000:00:17.0: PCI INT A -> Link[Z01A] -> GSI 20 (level=
, low) -> IRQ 20
[    0.358229] pci 0000:00:17.0: setting latency timer to 64
[    0.358559] ACPI: PCI Interrupt Link [Z01E] enabled at IRQ 19
[    0.358561]   alloc irq_desc for 19 on cpu 0 node 0
[    0.358563]   alloc kstat_irqs on cpu 0 node 0
[    0.358566] pci 0000:00:18.0: PCI INT A -> Link[Z01E] -> GSI 19 (level=
, low) -> IRQ 19
[    0.358574] pci 0000:00:18.0: setting latency timer to 64
[    0.358580] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.358582] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.358585] pci_bus 0000:01: resource 1 mem: [0xf0500000-0xf05fffff]
[    0.358587] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.358589] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
[    0.358591] pci_bus 0000:02: resource 0 io:  [0x4000-0x4fff]
[    0.358593] pci_bus 0000:02: resource 1 mem: [0xac000000-0xaeffffff]
[    0.358595] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdffffff=
f]
[    0.358598] pci_bus 0000:03: resource 0 io:  [0x5000-0x5fff]
[    0.358600] pci_bus 0000:03: resource 1 mem: [0xaa000000-0xaaffffff]
[    0.358602] pci_bus 0000:03: resource 2 pref mem [0xb0000000-0xcdfffff=
f]
[    0.358604] pci_bus 0000:04: resource 0 io:  [0x6000-0x6fff]
[    0.358606] pci_bus 0000:04: resource 1 mem: [0xf0200000-0xf03fffff]
[    0.358608] pci_bus 0000:04: resource 2 pref mem [0xf0000000-0xf01ffff=
f]
[    0.358611] pci_bus 0000:06: resource 1 mem: [0xf0400000-0xf04fffff]
[    0.358636] NET: Registered protocol family 2
[    0.404051] IP route cache hash table entries: 32768 (order: 5, 131072=
 bytes)
[    0.404290] TCP established hash table entries: 131072 (order: 8, 1048=
576 bytes)
[    0.404622] TCP bind hash table entries: 65536 (order: 7, 524288 bytes=
)
[    0.404792] TCP: Hash tables configured (established 131072 bind 65536=
)
[    0.404794] TCP reno registered
[    0.416057] NET: Registered protocol family 1
[    0.416098] Trying to unpack rootfs image as initramfs...
[    0.500628] Switched to high resolution mode on CPU 1
[    0.504008] Switched to high resolution mode on CPU 0
[    0.574794] Freeing initrd memory: 7621k freed
[    0.578196] Simple Boot Flag at 0x36 set to 0x1
[    0.578516] cpufreq-nforce2: No nForce2 chipset.
[    0.578607] Scanning for low memory corruption every 60 seconds
[    0.578802] audit: initializing netlink socket (disabled)
[    0.578815] type=3D2000 audit(1242765067.577:1): initialized
[    0.585449] highmem bounce pool size: 64 pages
[    0.585454] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.587682] VFS: Disk quotas dquot_6.5.2
[    0.587754] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    0.588549] fuse init (API version 7.11)
[    0.588691] msgmni has been set to 1713
[    0.588878] alg: No test for stdrng (krng)
[    0.588886] io scheduler noop registered
[    0.588888] io scheduler anticipatory registered
[    0.588890] io scheduler deadline registered
[    0.588949] io scheduler cfq registered (default)
[    0.589227] pci 0000:03:00.0: Boot video device
[    0.589549]   alloc irq_desc for 24 on cpu 0 node 0
[    0.589552]   alloc kstat_irqs on cpu 0 node 0
[    0.589571] pcieport-driver 0000:00:0c.0: irq 24 for MSI/MSI-X
[    0.589612] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    0.590013]   alloc irq_desc for 25 on cpu 0 node 0
[    0.590015]   alloc kstat_irqs on cpu 0 node 0
[    0.590032] pcieport-driver 0000:00:15.0: irq 25 for MSI/MSI-X
[    0.590072] pcieport-driver 0000:00:15.0: setting latency timer to 64
[    0.590462]   alloc irq_desc for 26 on cpu 0 node 0
[    0.590463]   alloc kstat_irqs on cpu 0 node 0
[    0.590480] pcieport-driver 0000:00:16.0: irq 26 for MSI/MSI-X
[    0.590520] pcieport-driver 0000:00:16.0: setting latency timer to 64
[    0.590911]   alloc irq_desc for 27 on cpu 0 node 0
[    0.590912]   alloc kstat_irqs on cpu 0 node 0
[    0.590929] pcieport-driver 0000:00:17.0: irq 27 for MSI/MSI-X
[    0.590969] pcieport-driver 0000:00:17.0: setting latency timer to 64
[    0.591359]   alloc irq_desc for 28 on cpu 0 node 0
[    0.591360]   alloc kstat_irqs on cpu 0 node 0
[    0.591377] pcieport-driver 0000:00:18.0: irq 28 for MSI/MSI-X
[    0.591417] pcieport-driver 0000:00:18.0: setting latency timer to 64
[    0.591639] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.591722] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    0.592983] ACPI: AC Adapter [ADP0] (on-line)
[    0.593334] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    0.593337] ACPI: Power Button [PWRF]
[    0.593400] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input1
[    0.593402] ACPI: Power Button [PWRB]
[    0.593700] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0=
A08:00/device:2a/PNP0C0E:00/input/input2
[    0.593702] ACPI: Sleep Button [SLPB]
[    0.593768] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0=
D:00/input/input3
[    0.595193] ACPI: Lid Switch [LID]
[    0.596198] ACPI: SSDT 6fee1086 0021F (v01  PmRef  Cpu0Ist 00003000 IN=
TL 20050228)
[    0.596990] ACPI: SSDT 6fee1648 0067D (v01  PmRef  Cpu0Cst 00003001 IN=
TL 20050228)
[    0.598765] Monitor-Mwait will be used to enter C-1 state
[    0.598791] Monitor-Mwait will be used to enter C-2 state
[    0.598810] Monitor-Mwait will be used to enter C-3 state
[    0.598817] Marking TSC unstable due to TSC halts in idle
[    0.598856] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.598896] processor ACPI_CPU:00: registered as cooling_device0
[    0.598899] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.599257] ACPI: SSDT 6fee0ed6 001B0 (v01  PmRef  Cpu1Ist 00003000 IN=
TL 20050228)
[    0.599640] ACPI: SSDT 6fee15c3 00085 (v01  PmRef  Cpu1Cst 00003000 IN=
TL 20050228)
[    0.600456] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.600495] processor ACPI_CPU:01: registered as cooling_device1
[    0.600499] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.608280] thermal LNXTHERM:01: registered as thermal_zone0
[    0.608287] ACPI: Thermal Zone [THRM] (59 C)
[    0.608677] isapnp: Scanning for PnP cards...
[    0.961613] isapnp: No Plug & Play device found
[    0.965894] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.967878] brd: module loaded
[    0.968610] loop: module loaded
[    0.968783] input: Macintosh mouse button emulation as /devices/virtua=
l/input/input4
[    0.968834] Driver 'sd' needs updating - please use bus_type methods
[    0.968871] Driver 'sr' needs updating - please use bus_type methods
[    0.968959] ahci 0000:00:0b.0: version 3.0
[    0.969304] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 18
[    0.969307]   alloc irq_desc for 18 on cpu 0 node 0
[    0.969309]   alloc kstat_irqs on cpu 0 node 0
[    0.969314] ahci 0000:00:0b.0: PCI INT A -> Link[LSI0] -> GSI 18 (leve=
l, low) -> IRQ 18
[    0.969344]   alloc irq_desc for 29 on cpu 0 node 0
[    0.969346]   alloc kstat_irqs on cpu 0 node 0
[    0.969352] ahci 0000:00:0b.0: irq 29 for MSI/MSI-X
[    0.969414] ahci 0000:00:0b.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps =
0x3f impl SATA mode
[    0.969417] ahci 0000:00:0b.0: flags: 64bit ncq sntf led pmp pio slum =
part=20
[    0.969420] ahci 0000:00:0b.0: setting latency timer to 64
[    0.969762] scsi0 : ahci
[    0.969898] scsi1 : ahci
[    0.970002] scsi2 : ahci
[    0.970109] scsi3 : ahci
[    0.970210] scsi4 : ahci
[    0.970312] scsi5 : ahci
[    0.970471] ata1: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
100 irq 29
[    0.970473] ata2: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
180 irq 29
[    0.970476] ata3: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
200 irq 29
[    0.970478] ata4: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
280 irq 29
[    0.970480] ata5: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
300 irq 29
[    0.970482] ata6: SATA max UDMA/133 abar m8192@0xf0884000 port 0xf0884=
380 irq 29
[    0.973293] Fixed MDIO Bus: probed
[    0.973298] PPP generic driver version 2.4.2
[    0.973481] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    0.974016] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 23
[    0.974019] ehci_hcd 0000:00:04.1: PCI INT B -> Link[LUS2] -> GSI 23 (=
level, low) -> IRQ 23
[    0.974030] ehci_hcd 0000:00:04.1: setting latency timer to 64
[    0.974032] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    0.974138] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bu=
s number 1
[    0.974161] ehci_hcd 0000:00:04.1: debug port 1
[    0.974165] ehci_hcd 0000:00:04.1: cache line size of 32 is not suppor=
ted
[    0.974178] ehci_hcd 0000:00:04.1: irq 23, io mem 0xf0889000
[    0.988010] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    0.988100] usb usb1: configuration #1 chosen from 1 choice
[    0.988153] hub 1-0:1.0: USB hub found
[    0.988160] hub 1-0:1.0: 4 ports detected
[    0.988641] ACPI: PCI Interrupt Link [Z00P] enabled at IRQ 22
[    0.988645] ehci_hcd 0000:00:06.1: PCI INT B -> Link[Z00P] -> GSI 22 (=
level, low) -> IRQ 22
[    0.988652] ehci_hcd 0000:00:06.1: setting latency timer to 64
[    0.988654] ehci_hcd 0000:00:06.1: EHCI Host Controller
[    0.988745] ehci_hcd 0000:00:06.1: new USB bus registered, assigned bu=
s number 2
[    0.988764] ehci_hcd 0000:00:06.1: debug port 1
[    0.988768] ehci_hcd 0000:00:06.1: cache line size of 32 is not suppor=
ted
[    0.988780] ehci_hcd 0000:00:06.1: irq 22, io mem 0xf0889400
[    1.000016] ehci_hcd 0000:00:06.1: USB 2.0 started, EHCI 1.00
[    1.000095] usb usb2: configuration #1 chosen from 1 choice
[    1.000144] hub 2-0:1.0: USB hub found
[    1.000150] hub 2-0:1.0: 3 ports detected
[    1.000303] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.000645] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 21
[    1.000648] ohci_hcd 0000:00:04.0: PCI INT A -> Link[LUS0] -> GSI 21 (=
level, low) -> IRQ 21
[    1.000655] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    1.000658] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    1.000749] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bu=
s number 3
[    1.000767] ohci_hcd 0000:00:04.0: irq 21, io mem 0xf0886000
[    1.054079] usb usb3: configuration #1 chosen from 1 choice
[    1.054128] hub 3-0:1.0: USB hub found
[    1.054136] hub 3-0:1.0: 4 ports detected
[    1.054581] ACPI: PCI Interrupt Link [Z00O] enabled at IRQ 20
[    1.054585] ohci_hcd 0000:00:06.0: PCI INT A -> Link[Z00O] -> GSI 20 (=
level, low) -> IRQ 20
[    1.054592] ohci_hcd 0000:00:06.0: setting latency timer to 64
[    1.054595] ohci_hcd 0000:00:06.0: OHCI Host Controller
[    1.054685] ohci_hcd 0000:00:06.0: new USB bus registered, assigned bu=
s number 4
[    1.054702] ohci_hcd 0000:00:06.0: irq 20, io mem 0xf0887000
[    1.093840] ACPI: Battery Slot [BAT0] (battery present)
[    1.110073] usb usb4: configuration #1 chosen from 1 choice
[    1.110122] hub 4-0:1.0: USB hub found
[    1.110129] hub 4-0:1.0: 3 ports detected
[    1.110272] uhci_hcd: USB Universal Host Controller Interface driver
[    1.110406] usbcore: registered new interface driver usbserial
[    1.110446] USB Serial support registered for generic
[    1.110487] usbcore: registered new interface driver usbserial_generic=

[    1.110489] usbserial: USB Serial Driver core
[    1.110585] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0=
x64 irq 1,12
[    1.116090] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.116095] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.116233] mice: PS/2 mouse device common for all mice
[    1.116496] rtc_cmos 00:0a: RTC can wake from S4
[    1.116548] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
[    1.116595] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet ir=
qs
[    1.116752] device-mapper: uevent: version 1.0.3
[    1.116874] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialise=
d: dm-devel@redhat.com
[    1.116944] device-mapper: multipath: version 1.0.5 loaded
[    1.116946] device-mapper: multipath round-robin: version 1.0.0 loaded=

[    1.117073] EISA: Probing bus 0 at eisa.0
[    1.117078] Cannot allocate resource for EISA slot 1
[    1.117080] Cannot allocate resource for EISA slot 2
[    1.117082] Cannot allocate resource for EISA slot 3
[    1.117084] Cannot allocate resource for EISA slot 4
[    1.117085] Cannot allocate resource for EISA slot 5
[    1.117087] Cannot allocate resource for EISA slot 6
[    1.117093] EISA: Detected 0 cards.
[    1.117459] cpuidle: using governor ladder
[    1.117975] cpuidle: using governor menu
[    1.118535] TCP cubic registered
[    1.118848] NET: Registered protocol family 10
[    1.119214] lo: Disabled Privacy Extensions
[    1.119268] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input5
[    1.119482] NET: Registered protocol family 17
[    1.119531] Bluetooth: L2CAP ver 2.13
[    1.119533] Bluetooth: L2CAP socket layer initialized
[    1.119535] Bluetooth: SCO (Voice Link) ver 0.6
[    1.119536] Bluetooth: SCO socket layer initialized
[    1.119567] Bluetooth: RFCOMM socket layer initialized
[    1.119571] Bluetooth: RFCOMM TTY layer initialized
[    1.119572] Bluetooth: RFCOMM ver 1.11
[    1.120060] Using IPI No-Shortcut mode
[    1.120211] PM: Resume from disk failed.
[    1.120222] registered taskstats version 1
[    1.120333]   Magic number: 9:22:549
[    1.120368] pci_link PNP0C0F:00: hash matches
[    1.120379] processor ACPI_CPU:04: hash matches
[    1.120443] rtc_cmos 00:0a: setting system clock to 2009-05-19 20:31:0=
9 UTC (1242765069)
[    1.120446] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.120447] EDD information not available.
[    1.288119] ata5: SATA link down (SStatus 0 SControl 300)
[    1.288151] ata3: SATA link down (SStatus 0 SControl 300)
[    1.288167] ata6: SATA link down (SStatus 0 SControl 300)
[    1.288191] ata4: SATA link down (SStatus 0 SControl 300)
[    1.428052] usb 2-3: new high speed USB device using ehci_hcd and addr=
ess 2
[    1.452059] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.452072] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.456544] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GS20N, A106, max UDMA/13=
3
[    1.461354] ata2.00: configured for UDMA/133
[    1.495270] ata1.00: ATA-8: TOSHIBA MK3252GSX, LV011D, max UDMA/100
[    1.495274] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/=
32)
[    1.496182] ata1.00: configured for UDMA/100
[    1.496272] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3252GS =
LV01 PQ: 0 ANSI: 5
[    1.496667] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (32=
0 GB/298 GiB)
[    1.496681] sd 0:0:0:0: [sda] Write Protect is off
[    1.496683] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.496702] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.496785]  sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.499842] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GS20N    =
A106 PQ: 0 ANSI: 5
[    1.504039] Clocksource tsc unstable (delta =3D -157210374 ns)
[    1.510969] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form=
2 cdda caddy
[    1.510973] Uniform CD-ROM driver Revision: 3.20
[    1.511278] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.511410] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.545953]  sda1 sda2 sda3 sda4 <<6>usb 2-3: configuration #1 chosen =
from 1 choice
[    1.573354]  sda5 >
[    1.574127] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.574153] Freeing unused kernel memory: 516k freed
[    1.574420] Write protecting the kernel text: 4352k
[    1.574455] Write protecting the kernel read-only data: 1720k
[    1.830288] forcedeth: Reverse Engineered nForce ethernet driver. Vers=
ion 0.64.
[    1.830673] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 19
[    1.830678] forcedeth 0000:00:0a.0: PCI INT A -> Link[LMAC] -> GSI 19 =
(level, low) -> IRQ 19
[    1.830684] forcedeth 0000:00:0a.0: setting latency timer to 64
[    1.949177] usb 3-4: new full speed USB device using ohci_hcd and addr=
ess 2
[    1.951784] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
[    1.951794] ohci1394 0000:01:07.0: PCI INT A -> Link[LNK1] -> GSI 11 (=
level, low) -> IRQ 11
[    1.985956] b43-pci-bridge 0000:06:00.0: PCI INT A -> Link[Z016] -> GS=
I 21 (level, low) -> IRQ 21
[    1.985966] b43-pci-bridge 0000:06:00.0: setting latency timer to 64
[    2.006034] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[11]  MMIO=3D=
[f0500000-f05007ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/4]
[    2.033085] ssb: ERROR: PLL init unknown for device 4322
[    2.033089] ssb: ERROR: PMU resource config unknown for device 4322
[    2.061103] ssb: Sonics Silicon Backplane found on PCI device 0000:06:=
00.0
[    2.169091] usb 3-4: configuration #1 chosen from 1 choice
[    2.172047] hub 3-4:1.0: USB hub found
[    2.175019] hub 3-4:1.0: 3 ports detected
[    2.353885] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x50ef @ 0, a=
ddr 00:21:70:8f:69:67
[    2.353889] forcedeth 0000:00:0a.0: highdma csum pwrctl gbit lnktim ms=
i desc-v3
[    2.419378] PM: Starting manual resume from disk
[    2.419381] PM: Resume from partition 8:5
[    2.419382] PM: Checking hibernation image.
[    2.419510] PM: Resume from disk failed.
[    2.475523] kjournald starting.  Commit interval 5 seconds
[    2.475534] EXT3-fs: mounted filesystem with writeback data mode.
[    2.494034] usb 3-4.1: new full speed USB device using ohci_hcd and ad=
dress 3
[    2.605121] usb 3-4.1: configuration #1 chosen from 1 choice
[    2.686042] usb 3-4.2: new full speed USB device using ohci_hcd and ad=
dress 4
[    2.798109] usb 3-4.2: configuration #1 chosen from 1 choice
[    3.280460] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[6d4fc0004b76=
deff]
[    8.361389] udev: starting version 142
[    8.526272] usbcore: registered new interface driver hiddev
[    8.531262] input: HID 413c:8157 as /devices/pci0000:00/0000:00:04.0/u=
sb3/3-4/3-4.1/3-4.1:1.0/input/input6
[    8.531328] generic-usb 0003:413C:8157.0001: input,hidraw0: USB HID v1=
=2E11 Keyboard [HID 413c:8157] on usb-0000:00:04.0-4.1/input0
[    8.537332] input: HID 413c:8158 as /devices/pci0000:00/0000:00:04.0/u=
sb3/3-4/3-4.2/3-4.2:1.0/input/input7
[    8.537408] generic-usb 0003:413C:8158.0002: input,hidraw1: USB HID v1=
=2E11 Mouse [HID 413c:8158] on usb-0000:00:04.0-4.2/input0
[    8.537429] usbcore: registered new interface driver usbhid
[    8.537432] usbhid: v2.6:USB HID core driver
[    8.596511] Linux agpgart interface v0.103
[    8.637255] Linux video capture interface: v2.00
[    8.658613] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[    8.669151] input: PC Speaker as /devices/platform/pcspkr/input/input8=

[    8.682152] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x3040
[    8.682167] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2000
[    8.818019] dcdbas dcdbas: Dell Systems Management Base Driver (versio=
n 5.6.0-3.2)
[    8.819372] sdhci: Secure Digital Host Controller Interface driver
[    8.819374] sdhci: Copyright(c) Pierre Ossman
[    8.820673] sdhci-pci 0000:01:07.1: SDHCI controller found [1180:0822]=
 (rev 22)
[    8.821047] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 11
[    8.821052] sdhci-pci 0000:01:07.1: PCI INT B -> Link[LNK2] -> GSI 11 =
(level, low) -> IRQ 11
[    8.821071] sdhci-pci 0000:01:07.1: Will use DMA mode even though HW d=
oesn't fully claim to support it.
[    8.821101] Registered led device: mmc0::
[    8.821137] mmc0: SDHCI controller on PCI [0000:01:07.1] using DMA
[    8.821797] ricoh-mmc: Ricoh MMC Controller disabling driver
[    8.821799] ricoh-mmc: Copyright(c) Philip Langdale
[    8.821815] ricoh-mmc: Ricoh MMC controller found at 0000:01:07.2 [118=
0:0843] (rev 12)
[    8.821829] ricoh-mmc: Controller is now disabled.
[    8.825688] uvcvideo: Found UVC 1.00 device Integrated Webcam (05ca:18=
a3)
[    8.827260] input: Integrated Webcam as /devices/pci0000:00/0000:00:06=
=2E1/usb2/2-3/2-3:1.0/input/input9
[    8.827303] usbcore: registered new interface driver uvcvideo
[    8.827306] USB Video Class driver (v0.1.0)
[    9.046045] usb 3-4.3: new full speed USB device using ohci_hcd and ad=
dress 5
[    9.123951] nvidia: module license 'NVIDIA' taints kernel.
[    9.123955] Disabling lock debugging due to kernel taint
[    9.207182] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08=
:00/device:11/device:12/input/input10
[    9.207221] ACPI: Video Device [Z01I] (multi-head: no  rom: yes  post:=
 no)
[    9.388796] nvidia 0000:02:00.0: enabling device (0004 -> 0007)
[    9.388811] nvidia 0000:02:00.0: PCI INT A -> Link[Z00Q] -> GSI 23 (le=
vel, low) -> IRQ 23
[    9.388823] nvidia 0000:02:00.0: setting latency timer to 64
[    9.389544] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 18
[    9.389547] nvidia 0000:03:00.0: PCI INT A -> Link[LGPU] -> GSI 18 (le=
vel, low) -> IRQ 18
[    9.389552] nvidia 0000:03:00.0: setting latency timer to 64
[    9.389666] NVRM: loading NVIDIA UNIX x86 Kernel Module  180.44  Mon M=
ar 23 14:59:10 PST 2009
[    9.418142] usb 3-4.3: configuration #1 chosen from 1 choice
[    9.441121] cfg80211: Calling CRDA to update world regulatory domain
[    9.458734] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    9.458811] usbcore: registered new interface driver btusb
[    9.628808] cfg80211: World regulatory domain updated:
[    9.628811] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, m=
ax_eirp)
[    9.628813] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628816] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628818] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628820] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 m=
Bm)
[    9.628822] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 m=
Bm)
[    9.667752] HDA Intel 0000:00:08.0: power state changed by ACPI to D0
[    9.668107] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 17
[    9.668111]   alloc irq_desc for 17 on cpu 0 node 0
[    9.668113]   alloc kstat_irqs on cpu 0 node 0
[    9.668118] HDA Intel 0000:00:08.0: PCI INT A -> Link[LAZA] -> GSI 17 =
(level, low) -> IRQ 17
[    9.668122] hda_intel: probe_mask set to 0x9 for device 1028:0271
[    9.668150] HDA Intel 0000:00:08.0: setting latency timer to 64
[    9.785554] b43-phy0: Broadcom 4322 WLAN found (core revision 16)
[    9.828120] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 8, Type 4, R=
evision 4)
[    9.828148] b43: probe of ssb0:0 failed with error -95
[    9.828186] Broadcom 43xx driver loaded [ Features: PLR, Firmware-ID: =
FW13 ]
[    9.943856] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: =
0xd04731/0xa40000
[    9.991400] input: SynPS/2 Synaptics TouchPad as /devices/platform/i80=
42/serio1/input/input11
[   10.332107] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:0=
8.0/input/input12
[   10.812124] input: HDA NVidia Mic at Ext Left Jack as /devices/pci0000=
:00/0000:00:08.0/input/input13
[   10.812209] input: HDA NVidia HP Out at Ext Left Jack as /devices/pci0=
000:00/0000:00:08.0/input/input14
[   10.812255] input: HDA NVidia HP Out at Ext Left Jack as /devices/pci0=
000:00/0000:00:08.0/input/input15
[   11.097536] lp: driver loaded but no devices found
[   11.167418] Adding 1759076k swap on /dev/sda5.  Priority:-1 extents:1 =
across:1759076k=20
[   11.697224] EXT3 FS on sda3, internal journal
[   15.113042] CE: hpet increasing min_delta_ns to 15000 nsec
[   15.517366] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.517369] Bluetooth: BNEP filters: protocol multicast
[   15.534986] Bridge firewalling registered
[   17.163342] ppdev: user-space parallel port driver
[   19.057870] IRQ 18/nvidia: IRQF_DISABLED is not guaranteed on shared I=
RQs
[   20.625966] eth0: no link during initialization.
[   20.626420] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.732733] IRQ 23/nvidia: IRQF_DISABLED is not guaranteed on shared I=
RQs
[   20.739709] NVRM: RmInitAdapter failed! (0x31:0xffffffff:1018)
[   20.739716] NVRM: rm_init_adapter(0) failed
[   22.450065] eth0: link up.
[   22.450857] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   32.832040] eth0: no IPv6 routers present
[   35.112810] Too big adjustment 32
[   35.161636] Too big adjustment 32
[   35.186721] Too big adjustment 32
[   35.201658] Too big adjustment 32
[   35.226097] Too big adjustment 32
[   35.273620] Too big adjustment 32
[   35.305855] Too big adjustment 32
[   43.455139] gvfs-gdu-volume[4462]: segfault at c ip 001e6fda sp bfdd78=
60 error 4 in libgdu.so.0.0.0[1de000+22000]
[   45.199507] gvfs-gdu-volume[4479]: segfault at c ip 005b5fda sp bfce82=
b0 error 4 in libgdu.so.0.0.0[5ad000+22000]

--------------000800000405080602040301--

--------------enigEA742C9E650A076826A4467F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoTGFgACgkQ2CrZjkA73YtwuQCbBi5gmYYOTCy+SkGTK7Noj6ah
9iUAoIxuJfG1oei9H8J7aLEplIBlb9kR
=bm4I
-----END PGP SIGNATURE-----

--------------enigEA742C9E650A076826A4467F--
