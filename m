Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYK1Gzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYK1Gzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 01:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYK1Gzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 01:55:41 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:52946 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYK1Gze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 01:55:34 -0500
Date: Fri, 28 Nov 2008 07:33:55 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: next-20081125: crypto hard disk gets unaccessable
Message-ID: <20081128063355.GA4700@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc6-next-20081125-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

After about four suspend & resume operations in the midst of editing
a file, the system beeped twice and issued this error:

[69186.618730] note: kcryptd[2848] exited with preempt_count 2

[full call trace attached]

/dev/sda3 was mapped via cryptsetup luksOpen to /dev/mapper/home
and also mounted an home.

After that error, all accesses to /home hung. Access to /
(provided by sda1) were still working.

System is again the Lenovo X200, including sierra loaded and used.

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="calltrace-2.6.28-next-20081125"
Content-Transfer-Encoding: quoted-printable


[    0.000000] BIOS EBDA/lowmem at: 0009ec00/0009ec00
[    0.000000] Linux version 2.6.28-rc6-next-20081125-denkbrett (compiler@i=
kn) (gcc version 4.3.2 (Debian 4.3.2-1) ) #15 SMP PREEMPT Tue Nov 25 13:41:=
17 CET 2008
[    0.000000] Command line: root=3D/dev/sda1 ro=20
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007c4a1000 (usable)
[    0.000000]  BIOS-e820: 000000007c4a1000 - 000000007c4a7000 (reserved)
[    0.000000]  BIOS-e820: 000000007c4a7000 - 000000007c5b7000 (usable)
[    0.000000]  BIOS-e820: 000000007c5b7000 - 000000007c60f000 (reserved)
[    0.000000]  BIOS-e820: 000000007c60f000 - 000000007c6c6000 (usable)
[    0.000000]  BIOS-e820: 000000007c6c6000 - 000000007c6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c6d1000 - 000000007c6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c6d4000 - 000000007c6d8000 (reserved)
[    0.000000]  BIOS-e820: 000000007c6d8000 - 000000007c6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c6dc000 - 000000007c6df000 (reserved)
[    0.000000]  BIOS-e820: 000000007c6df000 - 000000007c706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c706000 - 000000007c708000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c708000 - 000000007c90f000 (reserved)
[    0.000000]  BIOS-e820: 000000007c90f000 - 000000007c99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c99f000 - 000000007c9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c9ff000 - 000000007ca00000 (usable)
[    0.000000]  BIOS-e820: 000000007cc00000 - 000000007f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x7ca00 max_arch_pfn =3D 0x3ffffffff
[    0.000000] init_memory_mapping: 0000000000000000-000000007ca00000
[    0.000000]  0000000000 - 007ca00000 page 2M
[    0.000000] kernel direct mapping tables up to 7ca00000 @ 8000-b000
[    0.000000] last_map_addr: 7ca00000 end: 7ca00000
[    0.000000] ACPI: RSDP 000F73A0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 7C97BD45, 009C (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: FACP 7C97BF00, 00F4 (r3 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: DSDT 7C97C2F4, D910 (r1 LENOVO TP-6D        1050 MSFT =
 3000000)
[    0.000000] ACPI: FACS 7C98E000, 0040
[    0.000000] ACPI: SSDT 7C97C0B4, 0240 (r1 LENOVO TP-6D        1050 MSFT =
 3000000)
[    0.000000] ACPI: ECDT 7C989C04, 0052 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: APIC 7C989C56, 0078 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: MCFG 7C989CCE, 003C (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: HPET 7C989D0A, 0038 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: SLIC 7C989DC2, 0176 (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: BOOT 7C989F38, 0028 (r1 LENOVO TP-6D        1050  LTP =
       1)
[    0.000000] ACPI: ASF! 7C989F60, 00A0 (r16 LENOVO TP-6D        1050 PTL =
        1)
[    0.000000] ACPI: SSDT 7C98D203, 055F (r1 LENOVO TP-6D        1050 INTL =
20050513)
[    0.000000] ACPI: TCPA 7C707000, 0032 (r0                        0      =
       0)
[    0.000000] ACPI: DMAR 7C706000, 0120 (r1               =01        1    =
         0)
[    0.000000] ACPI: SSDT 7C6D3000, 0655 (r1  PmRef    CpuPm     3000 INTL =
20050624)
[    0.000000] ACPI: SSDT 7C6D2000, 0274 (r1  PmRef  Cpu0Tst     3000 INTL =
20050624)
[    0.000000] ACPI: SSDT 7C6D1000, 0242 (r1  PmRef    ApTst     3000 INTL =
20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) =3D=3D> bootmem [0000000000 - 007ca00=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00006cc60c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 00006cc60c]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #4 [0000008000 - 0000009000]          PGTABLE =3D=3D> [000=
0008000 - 0000009000]
[    0.000000] found SMP MP-table at [ffff8800000f73e0] 000f73e0
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff88000120000=
0-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007c4a1
[    0.000000]     0: 0x0007c4a7 -> 0x0007c5b7
[    0.000000]     0: 0x0007c60f -> 0x0007c6c6
[    0.000000]     0: 0x0007c9ff -> 0x0007ca00
[    0.000000] On node 0 totalpages: 509447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1331 pages reserved
[    0.000000]   DMA zone: 2611 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6923 pages used for memmap
[    0.000000]   DMA32 zone: 498526 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000=
:61000000)
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 501137
[    0.000000] Kernel command line: root=3D/dev/sda1 ro=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.866 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[    0.004000] Memory: 2000024k/2041856k available (2698k kernel code, 4068=
k absent, 37036k reserved, 1306k data, 336k init)
[    0.004000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4521.73 BogoMIPS (lpj=3D9043464)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.048087] Setting APIC routing to flat
[    0.048612] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.090145] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.092001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4522.06 Bog=
oMIPS (lpj=3D9044130)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.177246] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.178477] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.180025] Brought up 2 CPUs
[    0.180155] Total of 2 processors activated (9043.79 BogoMIPS).
[    0.180409] net_namespace: 1328 bytes
[    0.184030] regulator: core version 0.5
[    0.184180] NET: Registered protocol family 16
[    0.184219] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.184224] ACPI: bus type pci registered
[    0.184375] PCI: Using configuration type 1 for base access
[    0.194968] ACPI: EC: EC description table is found, configuring boot EC
[    0.214969] ACPI: BIOS _OSI(Linux) query ignored
[    0.212021] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.235233] ACPI: Interpreter enabled
[    0.235365] ACPI: (supports S0 S3 S5)
[    0.235670] ACPI: Using IOAPIC for interrupt routing
[    0.276453] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.276591] ACPI: EC: driver started in interrupt mode
[    0.281545] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.284332] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.284543] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.284543] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.284543] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.284543] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.284543] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.284543] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.284543] pci 0000:00:03.0: PME# disabled
[    0.284746] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.284758] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.284770] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.284816] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.284951] pci 0000:00:19.0: PME# disabled
[    0.285168] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.285280] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.285392] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.285507] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.285572] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.285708] pci 0000:00:1a.7: PME# disabled
[    0.285907] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.285960] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.286096] pci 0000:00:1b.0: PME# disabled
[    0.286307] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.286443] pci 0000:00:1c.0: PME# disabled
[    0.286656] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.286791] pci 0000:00:1c.1: PME# disabled
[    0.287010] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.288010] pci 0000:00:1c.3: PME# disabled
[    0.288239] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.288351] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.288463] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.288577] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.288643] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.288779] pci 0000:00:1d.7: PME# disabled
[    0.289187] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.289198] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.289210] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.289221] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.289232] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.289243] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.289271] pci 0000:00:1f.2: PME# supported from D3hot
[    0.289405] pci 0000:00:1f.2: PME# disabled
[    0.289585] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.289612] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.289830] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.289916] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.290056] pci 0000:03:00.0: PME# disabled
[    0.292112] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.292196] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.292204] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.292216] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.292304] pci 0000:00:1e.0: transparent bridge
[    0.292480] bus 00 -> node 0
[    0.292500] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.293406] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.293814] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.294227] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.304462] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.308187] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.309374] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.310558] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.311742] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.312917] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.314100] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.315281] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316200] ACPI: Power Resource [PUBS] (on)
[    0.317486] SCSI subsystem initialized
[    0.317694] libata version 3.00 loaded.
[    0.318074] PCI: Using ACPI for IRQ routing
[    0.328082] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.328442] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.354698] pnp: PnP ACPI init
[    0.354840] ACPI: bus type pnp registered
[    0.424807] pnp: PnP ACPI: found 10 devices
[    0.424939] ACPI: ACPI bus type pnp unregistered
[    0.425086] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.425222] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.425357] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.425491] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.425626] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.425761] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.425896] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.426031] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.426167] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.426302] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.426438] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.426573] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.426722] system 00:00: iomem range 0x100000-0x7effffff could not be r=
eserved
[    0.426935] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.427148] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.427370] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.427505] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.427640] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.427775] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.427909] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.428044] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.428179] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.428315] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.428452] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.428587] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.428724] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.428860] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.428996] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.434601] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.434748] pci 0000:00:1c.0:   IO window: disabled
[    0.434884] pci 0000:00:1c.0:   MEM window: disabled
[    0.435017] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.435156] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.435288] pci 0000:00:1c.1:   IO window: disabled
[    0.435425] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.435561] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.435699] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.435834] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.435971] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.436108] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.436326] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.436458] pci 0000:00:1e.0:   IO window: disabled
[    0.436593] pci 0000:00:1e.0:   MEM window: disabled
[    0.436727] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.436882] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.437020] pci 0000:00:1c.0: setting latency timer to 64
[    0.437036] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.437173] pci 0000:00:1c.1: setting latency timer to 64
[    0.437189] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.437326] pci 0000:00:1c.3: setting latency timer to 64
[    0.437338] pci 0000:00:1e.0: setting latency timer to 64
[    0.437345] bus: 00 index 0 io port: [0x00-0xffff]
[    0.437477] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.437611] bus: 02 index 0 mmio: [0x0-0x0]
[    0.437740] bus: 02 index 1 mmio: [0x0-0x0]
[    0.437869] bus: 02 index 2 mmio: [0x0-0x0]
[    0.437998] bus: 02 index 3 mmio: [0x0-0x0]
[    0.438128] bus: 03 index 0 mmio: [0x0-0x0]
[    0.438257] bus: 03 index 1 mmio: [0xf2500000-0xf25fffff]
[    0.438389] bus: 03 index 2 mmio: [0x0-0x0]
[    0.438518] bus: 03 index 3 mmio: [0x0-0x0]
[    0.438648] bus: 05 index 0 io port: [0x2000-0x2fff]
[    0.438793] bus: 05 index 1 mmio: [0xf0000000-0xf1ffffff]
[    0.438925] bus: 05 index 2 mmio: [0xf2900000-0xf29fffff]
[    0.439056] bus: 05 index 3 mmio: [0x0-0x0]
[    0.439185] bus: 0d index 0 mmio: [0x0-0x0]
[    0.439315] bus: 0d index 1 mmio: [0x0-0x0]
[    0.439444] bus: 0d index 2 mmio: [0x0-0x0]
[    0.439574] bus: 0d index 3 io port: [0x00-0xffff]
[    0.439705] bus: 0d index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.439851] NET: Registered protocol family 2
[    0.486792] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.488015] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.490954] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.491937] TCP: Hash tables configured (established 262144 bind 65536)
[    0.492071] TCP reno registered
[    0.502859] NET: Registered protocol family 1
[    0.503440] Simple Boot Flag at 0x35 set to 0x1
[    0.505726] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
[    0.511620] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.516989] VFS: Disk quotas dquot_6.5.2
[    0.517284] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.518511] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.523648] msgmni has been set to 3907
[    0.524220] io scheduler noop registered
[    0.524351] io scheduler anticipatory registered (default)
[    0.524483] io scheduler deadline registered
[    0.524759] io scheduler cfq registered
[    0.524910] pci 0000:00:02.0: Boot video device
[    0.525345] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.525402] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.525580] pcieport-driver 0000:00:1c.0: irq 319 for MSI/MSI-X
[    0.525603] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.525690] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.525848] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.525904] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.526075] pcieport-driver 0000:00:1c.1: irq 318 for MSI/MSI-X
[    0.526097] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.526185] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.526348] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.526403] pcieport-driver 0000:00:1c.3: found MSI capability
[    0.526574] pcieport-driver 0000:00:1c.3: irq 317 for MSI/MSI-X
[    0.526597] pci_express 0000:00:1c.3:pcie00: allocate port service
[    0.526678] pci_express 0000:00:1c.3:pcie02: allocate port service
[    0.527890] ACPI: AC Adapter [AC] (off-line)
[    0.550720] Switched to high resolution mode on CPU 1
[    0.552017] Switched to high resolution mode on CPU 0
[    0.560413] ACPI Warning (nspredef-0858): \_SB_.PCI0.LPC_.EC__.BAT0._BIF=
: Return Package type mismatch at index 9 - found Buffer, expected String [=
20080926]
[    0.570012] ACPI: Battery Slot [BAT0] (battery present)
[    0.570425] input: Power Button (FF) as /class/input/input0
[    0.570624] ACPI: Power Button (FF) [PWRF]
[    0.571013] input: Lid Switch as /class/input/input1
[    0.572746] ACPI: Lid Switch [LID]
[    0.573052] input: Sleep Button (CM) as /class/input/input2
[    0.573190] ACPI: Sleep Button (CM) [SLPB]
[    0.575272] ACPI: SSDT 7C6D6C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL =
20050624)
[    0.577174] ACPI: SSDT 7C6D4020, 087A (r1  PmRef  Cpu0Cst     3001 INTL =
20050624)
[    0.586956] Monitor-Mwait will be used to enter C-1 state
[    0.586964] Monitor-Mwait will be used to enter C-2 state
[    0.586969] Monitor-Mwait will be used to enter C-3 state
[    0.586978] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.587448] processor ACPI_CPU:00: registered as cooling_device0
[    0.587608] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.589290] ACPI: SSDT 7C6D5CA0, 01CF (r1  PmRef    ApIst     3000 INTL =
20050624)
[    0.591008] ACPI: SSDT 7C6D5F20, 008D (r1  PmRef    ApCst     3000 INTL =
20050624)
[    0.595996] Marking TSC unstable due to possible TSC halt in C2
[    0.596234] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.596815] processor ACPI_CPU:01: registered as cooling_device1
[    0.596954] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.649207] thermal LNXTHERM:01: registered as thermal_zone0
[    0.654034] ACPI: Thermal Zone [THM0] (22 C)
[    0.656752] thermal LNXTHERM:02: registered as thermal_zone1
[    0.659802] ACPI: Thermal Zone [THM1] (31 C)
[    0.777734] Linux agpgart interface v0.103
[    1.000230] Clocksource tsc unstable (delta =3D -241799693 ns)
[    3.792273] floppy0: no floppy controllers found
[    3.797798] brd: module loaded
[    3.798225] Uniform Multi-Platform E-IDE driver
[    3.798756] ide-gd driver 1.18
[    3.799476] Driver 'sd' needs updating - please use bus_type methods
[    3.799786] ahci 0000:00:1f.2: version 3.0
[    3.799817] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.800035] ahci 0000:00:1f.2: irq 316 for MSI/MSI-X
[    3.800131] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.800346] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.800562] ahci 0000:00:1f.2: setting latency timer to 64
[    3.800876] scsi0 : ahci
[    3.801345] scsi1 : ahci
[    3.801706] scsi2 : ahci
[    3.802100] scsi3 : ahci
[    3.803813] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 316
[    3.804038] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 316
[    3.804249] ata3: DUMMY
[    3.804376] ata4: DUMMY
[    4.120263] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.166382] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.166391] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.166662] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.166670] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.167606] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    4.167740] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.177447] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.177453] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.177712] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.177719] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.178703] ata1.00: configured for UDMA/100
[    4.206081] ata1.00: configured for UDMA/100
[    4.206220] ata1: EH complete
[    4.524264] ata2: SATA link down (SStatus 0 SControl 300)
[    4.540536] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    4.541348] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.541590] sd 0:0:0:0: [sda] Write Protect is off
[    4.541722] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.541768] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.542101] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.542337] sd 0:0:0:0: [sda] Write Protect is off
[    4.542469] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.542514] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.542730]  sda: sda1 sda2 sda3
[    4.600067] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.600670] Fusion MPT base driver 3.04.07
[    4.600800] Copyright (c) 1999-2008 LSI Corporation
[    4.600947] Fusion MPT SPI Host driver 3.04.07
[    4.602624] ieee1394: raw1394: /dev/raw1394 device initialized
[    4.603214] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    4.613933] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.614089] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.614646] mice: PS/2 mouse device common for all mice
[    4.666263] oprofile: using NMI interrupt.
[    4.667084] TCP cubic registered
[    4.667215] NET: Registered protocol family 17
[    4.669608] registered taskstats version 1
[    4.670898] input: AT Translated Set 2 keyboard as /class/input/input3
[    4.927745] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[    5.245918] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    5.265211] input: TPPS/2 IBM TrackPoint as /class/input/input4
[    5.467864] VFS: Mounted root (jfs filesystem) readonly.
[    5.468058] Freeing unused kernel memory: 336k freed
[    8.411176] Non-volatile memory driver v1.2
[    8.633114] thinkpad_acpi: ThinkPad ACPI Extras v0.21
[    8.633219] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.633319] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[    8.633423] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[    8.634040] thinkpad_acpi: radio switch found; radios are enabled
[    8.634262] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    8.634429] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    8.642597] Registered led device: tpacpi::thinklight
[    8.642729] Registered led device: tpacpi::power
[    8.642844] Registered led device: tpacpi:orange:batt
[    8.642963] Registered led device: tpacpi:green:batt
[    8.643079] Registered led device: tpacpi::dock_active
[    8.643194] Registered led device: tpacpi::bay_active
[    8.643308] Registered led device: tpacpi::dock_batt
[    8.643422] Registered led device: tpacpi::unknown_led
[    8.643535] Registered led device: tpacpi::standby
[    8.645631] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[    8.646007] input: ThinkPad Extra Buttons as /class/input/input5
[    8.672807] agpgart-intel 0000:00:00.0: Intel Mobile Intel? GM45 Express=
 Chipset
[    8.673866] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    8.676959] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.766075] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    8.766181] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    8.766318] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    8.766428] e1000e 0000:00:19.0: setting latency timer to 64
[    8.766521] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[    8.852063] usbcore: registered new interface driver usbfs
[    8.852190] usbcore: registered new interface driver hub
[    8.855386] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[    8.855549] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.855674] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1008ff-0ff
[    8.885225] ACPI: WMI: Mapper loaded
[    8.892039] usbcore: registered new device driver usb
[    8.900060] uhci_hcd: USB Universal Host Controller Interface driver
[    8.900659] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    8.900767] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    8.900877] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    8.900880] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    8.901017] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    8.901212] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    8.901420] usb usb1: configuration #1 chosen from 1 choice
[    8.901544] hub 1-0:1.0: USB hub found
[    8.901647] hub 1-0:1.0: 2 ports detected
[    8.901840] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    8.901948] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    8.901951] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    8.902069] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 2
[    8.902257] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    8.902423] usb usb2: configuration #1 chosen from 1 choice
[    8.902546] hub 2-0:1.0: USB hub found
[    8.902649] hub 2-0:1.0: 2 ports detected
[    8.903373] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    8.903481] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[    8.903589] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    8.903591] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    8.903714] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 3
[    8.903902] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    8.904079] usb usb3: configuration #1 chosen from 1 choice
[    8.904201] hub 3-0:1.0: USB hub found
[    8.904305] hub 3-0:1.0: 2 ports detected
[    8.905053] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    8.905159] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    8.905267] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.905269] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    8.905394] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 4
[    8.905583] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    8.905755] usb usb4: configuration #1 chosen from 1 choice
[    8.905878] hub 4-0:1.0: USB hub found
[    8.905984] hub 4-0:1.0: 2 ports detected
[    8.906165] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[    8.906273] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    8.906276] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    8.906396] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 5
[    8.906584] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    8.906752] usb usb5: configuration #1 chosen from 1 choice
[    8.906874] hub 5-0:1.0: USB hub found
[    8.906977] hub 5-0:1.0: 2 ports detected
[    8.907157] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    8.907265] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    8.907268] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    8.907389] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 6
[    8.907576] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    8.907744] usb usb6: configuration #1 chosen from 1 choice
[    8.907866] hub 6-0:1.0: USB hub found
[    8.907969] hub 6-0:1.0: 2 ports detected
[    8.994725] acpi device:03: registered as cooling_device2
[    8.995079] input: Video Bus as /class/input/input6
[    9.028096] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    9.126010] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.126126] Warning! ehci_hcd should always be loaded before uhci_hcd an=
d ohci_hcd, not after
[    9.127099] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    9.127218] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    9.127357] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    9.127360] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    9.127507] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 7
[    9.131600] ehci_hcd 0000:00:1a.7: debug port 1
[    9.131705] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    9.131721] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    9.213019] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 2
[    9.224017] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.224233] usb usb7: configuration #1 chosen from 1 choice
[    9.224360] hub 7-0:1.0: USB hub found
[    9.224474] hub 7-0:1.0: 6 ports detected
[    9.225013] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    9.225127] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    9.225249] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    9.225252] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.225376] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 8
[    9.229440] ehci_hcd 0000:00:1d.7: debug port 1
[    9.229557] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    9.229575] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    9.256042] cfg80211: Calling CRDA to update world regulatory domain
[    9.280450] hub 2-0:1.0: unable to enumerate USB device on port 1
[    9.292014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.292226] usb usb8: configuration #1 chosen from 1 choice
[    9.292351] hub 8-0:1.0: USB hub found
[    9.292455] hub 8-0:1.0: 6 ports detected
[    9.418087] input: PC Speaker as /class/input/input7
[    9.554849] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[    9.555015] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.555187] vendor=3D8086 device=3D2942
[    9.555287] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    9.555397] iwlagn 0000:03:00.0: setting latency timer to 64
[    9.555433] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[    9.584424] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    9.613644] rtc_cmos 00:07: RTC can wake from S4
[    9.613837] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    9.613964] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    9.621878] vendor=3D8086 device=3D2942
[    9.621981] iwlagn 0000:03:00.0: PCI INT A disabled
[    9.622131] wmaster0 (iwlagn): not using net_device_ops yet
[    9.622412] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.626504] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    9.795660] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[    9.795905] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.876254] usb 7-6: new high speed USB device using ehci_hcd and addres=
s 4
[    9.902146] wlan0 (iwlagn): not using net_device_ops yet
[   10.017092] usb 7-6: configuration #1 chosen from 1 choice
[   10.257092] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 3
[   10.427664] usb 2-1: configuration #1 chosen from 1 choice
[   10.669257] usb 2-2: new full speed USB device using uhci_hcd and addres=
s 4
[   10.838641] usb 2-2: configuration #1 chosen from 1 choice
[   11.009360] Bluetooth: Core ver 2.13
[   11.018740] NET: Registered protocol family 31
[   11.018852] Bluetooth: HCI device and connection manager initialized
[   11.018967] Bluetooth: HCI socket layer initialized
[   11.086549] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   11.086739] usbcore: registered new interface driver btusb
[   13.612854] loop: module loaded
[   14.205133] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   20.255989] alg: No test for stdrng (krng)
[   20.278719] alg: No test for stdrng (ansi_cprng)
[   34.021658] Adding 4982032k swap on /dev/mapper/swap.  Priority:-1 exten=
ts:1 across:4982032k
[   36.349598] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[   36.405317] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[   41.128632] NET: Registered protocol family 10
[   41.130107] lo: Disabled Privacy Extensions
[   41.131313] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   44.002435] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[   44.002659] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[   44.068569] input: /usr/sbin/thinkpad-keys as /class/input/input8
[   50.280071] warning: `avahi-daemon' uses 32-bit capabilities (legacy sup=
port in use)
[   52.189090] Bluetooth: L2CAP ver 2.11
[   52.189243] Bluetooth: L2CAP socket layer initialized
[   52.211628] Bluetooth: RFCOMM socket layer initialized
[   52.211817] Bluetooth: RFCOMM TTY layer initialized
[   52.211982] Bluetooth: RFCOMM ver 1.10
[   52.637419] vendor=3D8086 device=3D2942
[   52.637637] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   52.637855] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100102, writing 0x100106)
[   52.637964] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[   52.638044] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[   54.991303] Registered led device: iwl-phy0:radio
[   54.991446] Registered led device: iwl-phy0:assoc
[   54.991581] Registered led device: iwl-phy0:RX
[   54.991721] Registered led device: iwl-phy0:TX
[   55.509252] iwlagn: Error sending REPLY_ADD_STA: time out after 500ms.
[   55.510310] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   70.824192] [drm] Initialized drm 1.1.0 20060810
[   70.854786] pci 0000:00:02.0: power state changed by ACPI to D0
[   70.854804] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   70.854813] pci 0000:00:02.0: setting latency timer to 64
[   70.855326] pci 0000:00:02.0: irq 313 for MSI/MSI-X
[   70.855552] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   71.694831] set status page addr 0x08da0000
[ 2841.533757] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0x=
e frozen
[ 2841.533765] ata2: irq_stat 0x00000040, connection status changed
[ 2841.533772] ata2: SError: { CommWake DevExch }
[ 2841.533789] ata2: hard resetting link
[ 2842.256287] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2842.402744] Monitor-Mwait will be used to enter C-3 state
[ 2842.422003] thinkpad_acpi: unhandled HKEY event 0x6030
[ 2842.424278] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[ 2842.427750] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x100)
[ 2842.496906] ACPI: \_SB_.GDCK - docking
[ 2842.518162] ata2: hard resetting link
[ 2842.660122] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 5
[ 2842.792616] usb 7-5: configuration #1 chosen from 1 choice
[ 2842.792823] hub 7-5:1.0: USB hub found
[ 2842.792887] hub 7-5:1.0: 4 ports detected
[ 2842.836076] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2842.843020] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[ 2842.843862] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[ 2842.847537] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[ 2842.855260] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[ 2842.856200] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[ 2842.859837] ata2.00: configured for UDMA/133
[ 2842.961849] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX/TX
[ 2842.961852] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[ 2842.962142] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 2842.996920] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[ 2842.996928] ata2: irq_stat 0x40000001
[ 2843.005463] ata2.00: configured for UDMA/133
[ 2843.005472] ata2: EH complete
[ 2843.009098] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[ 2843.068165] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 6
[ 2843.168614] Driver 'sr' needs updating - please use bus_type methods
[ 2843.174862] usb 7-5.4: configuration #1 chosen from 1 choice
[ 2843.325884] usblp0: USB Bidirectional printer dev 6 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[ 2843.326546] usbcore: registered new interface driver usblp
[ 2843.504294] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[ 2843.504305] Uniform CD-ROM driver Revision: 3.20
[ 2843.504501] sr 1:0:0:0: Attached scsi CD-ROM sr0
[ 2843.580303] sd 0:0:0:0: Attached scsi generic sg0 type 0
[ 2843.580395] sr 1:0:0:0: Attached scsi generic sg1 type 5
[ 2852.560863] hal_lpadmin[6955] general protection ip:44c404 sp:7fff75efa4=
00 error:0 in python2.5[400000+125000]
[ 2860.241104] eth0: no IPv6 routers present
[15305.222227] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[15305.224440] wlan0 direct probe responded
[15305.224447] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[15305.420189] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[15305.421958] wlan0: authenticated
[15305.421962] wlan0: associate with AP 00:03:52:4d:bd:c1
[15305.424042] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[15305.424048] wlan0: associated
[15305.429931] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[15315.896040] wlan0: no IPv6 routers present
[15393.079122] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[15393.277127] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[15393.278920] wlan0: authenticated
[15393.278926] wlan0: associate with AP 00:03:52:4d:bd:c1
[15393.283895] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[15393.283902] wlan0: associated
[15410.161450] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[15410.217225] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[15410.218148] ADDRCONF(NETDEV_UP): eth0: link is not ready
[15411.828833] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX/TX
[15411.828841] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[15411.829588] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[15418.034813] tun: Universal TUN/TAP device driver, 1.6
[15418.034819] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[15418.039539] tun0: Disabled Privacy Extensions
[15425.232108] eth0: no IPv6 routers present
[15430.435475] tun0: Disabled Privacy Extensions
[15453.056477] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[15453.112119] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[15453.113028] ADDRCONF(NETDEV_UP): eth0: link is not ready
[15454.660921] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX/TX
[15454.660930] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[15454.661695] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[15470.125102] eth0: no IPv6 routers present
[15484.652287] e1000e: eth0 NIC Link is Down
[15484.661790] usb 7-5: USB disconnect, address 5
[15484.661796] usb 7-5.4: USB disconnect, address 6
[15484.661992] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x=
e frozen
[15484.661998] ata2: irq_stat 0x00400040, connection status changed
[15484.662005] ata2: SError: { PHYRdyChg DevExch }
[15484.662074] ata2: hard resetting link
[15484.666858] usblp0: removed
[15485.334052] thinkpad_acpi: unhandled HKEY event 0x6030
[15485.385280] ata2: SATA link down (SStatus 0 SControl 300)
[15490.384290] ata2: hard resetting link
[15490.704284] ata2: SATA link down (SStatus 0 SControl 300)
[15495.704076] ata2: hard resetting link
[15496.024290] ata2: SATA link down (SStatus 0 SControl 300)
[15496.024303] ata2.00: disabled
[15496.024335] ata2: EH complete
[15496.024379] ata2.00: detaching (SCSI 1:0:0:0)
[15496.028120] ACPI: \_SB_.GDCK - undocking
[15496.040895] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[15496.041219] ACPI: Unable to dock!
[15598.130592] wlan0: deauthenticated (Reason: 6)
[15599.128084] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[15599.328282] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 2
[15599.528276] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 3
[15599.728279] wlan0: direct probe to AP 00:03:52:4d:bd:c1 timed out
[15635.262530] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[15635.460299] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[15635.660265] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[15635.860241] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[15643.220187] wlan0: direct probe to AP 00:11:5c:d4:a3:50 try 1
[15643.420302] wlan0: direct probe to AP 00:11:5c:d4:a3:50 try 2
[15643.620321] wlan0: direct probe to AP 00:11:5c:d4:a3:50 try 3
[15643.820310] wlan0: direct probe to AP 00:11:5c:d4:a3:50 timed out
[15647.939300] wlan0: direct probe to AP 00:11:5c:d4:a3:50 try 1
[15648.136307] wlan0: direct probe to AP 00:11:5c:d4:a3:50 try 2
[15648.336323] wlan0: direct probe to AP 00:11:5c:d4:a3:50 try 3
[15648.536273] wlan0: direct probe to AP 00:11:5c:d4:a3:50 timed out
[15654.517102] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[15654.716278] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[15654.718580] wlan0 direct probe responded
[15654.718587] wlan0: authenticate with AP 00:03:52:1b:f4:e1
[15654.916276] wlan0: authenticate with AP 00:03:52:1b:f4:e1
[15655.116355] wlan0: authenticate with AP 00:03:52:1b:f4:e1
[15655.316294] wlan0: authentication with AP 00:03:52:1b:f4:e1 timed out
[15666.557180] vendor=3D8086 device=3D2942
[15666.557183] iwlagn 0000:03:00.0: PCI INT A disabled
[15671.557618] vendor=3D8086 device=3D2942
[15671.557629] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[15671.557718] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100102, writing 0x100106)
[15671.557827] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[15671.584261] Registered led device: iwl-phy0:radio
[15671.584323] Registered led device: iwl-phy0:assoc
[15671.584371] Registered led device: iwl-phy0:RX
[15671.584416] Registered led device: iwl-phy0:TX
[15671.603284] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[15671.605681] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[15671.804281] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[15672.004280] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[15672.204280] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[15681.069378] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[15681.268268] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[15681.468128] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[15681.668284] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[15701.859196] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[15702.057271] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 2
[15702.059561] wlan0 direct probe responded
[15702.059568] wlan0: authenticate with AP 00:03:52:4d:de:d1
[15702.061994] wlan0: authenticated
[15702.062001] wlan0: associate with AP 00:03:52:4d:de:d1
[15702.260180] wlan0: associate with AP 00:03:52:4d:de:d1
[15702.262789] wlan0: RX AssocResp from 00:03:52:4d:de:d1 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[15702.262797] wlan0: associated
[15702.267428] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[15712.580120] wlan0: no IPv6 routers present
[15837.147730] tun0: Disabled Privacy Extensions
[16158.185047] tun0: Disabled Privacy Extensions
[16800.685275] CE: hpet increasing min_delta_ns to 15000 nsec
[16907.487594] wlan0: deauthenticated (Reason: 2)
[16908.484273] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[16908.684268] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 2
[16908.884269] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 3
[16909.084269] wlan0: direct probe to AP 00:03:52:4d:de:d1 timed out
[16913.346601] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[16913.349078] wlan0 direct probe responded
[16913.349087] wlan0: authenticate with AP 00:03:52:1b:f4:e1
[16913.548326] wlan0: authenticate with AP 00:03:52:1b:f4:e1
[16913.550415] wlan0: authenticated
[16913.550424] wlan0: associate with AP 00:03:52:1b:f4:e1
[16913.553924] wlan0: RX ReassocResp from 00:03:52:1b:f4:e1 (capab=3D0x21 s=
tatus=3D0 aid=3D8)
[16913.553932] wlan0: associated
[17459.689363] wlan0: direct probe to AP 00:03:52:29:41:12 try 1
[17459.888266] wlan0: direct probe to AP 00:03:52:29:41:12 try 2
[17460.088331] wlan0: direct probe to AP 00:03:52:29:41:12 try 3
[17460.289046] wlan0: direct probe to AP 00:03:52:29:41:12 timed out
[17464.046046] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[17464.244077] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[17464.444279] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[17464.644265] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[17477.209800] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[17477.408300] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[17477.608336] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[17477.808271] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[17481.919537] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[17482.116302] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[17482.316328] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[17482.516266] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[17510.820330] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[17510.820820] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[17511.016060] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[17511.216065] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[17511.416265] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[17530.855119] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 1
[17531.052302] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 2
[17531.252268] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 3
[17531.452081] wlan0: direct probe to AP 00:03:52:4d:c1:f1 timed out
[17535.695381] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 1
[17535.696516] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 1
[17535.892270] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 2
[17536.092274] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 3
[17536.292274] wlan0: direct probe to AP 00:03:52:4d:c1:f1 timed out
[17541.664743] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 1
[17541.666071] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 1
[17541.864311] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 2
[17542.064301] wlan0: direct probe to AP 00:03:52:4d:c1:f1 try 3
[17542.264275] wlan0: direct probe to AP 00:03:52:4d:c1:f1 timed out
[17629.421889] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[17629.422353] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[17629.620306] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[17629.821267] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[17630.021266] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[18179.742897] vendor=3D8086 device=3D2942
[18179.742900] iwlagn 0000:03:00.0: PCI INT A disabled
[18193.030147] vendor=3D8086 device=3D2942
[18193.030159] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[18193.030248] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100102, writing 0x100106)
[18193.030357] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[18193.056855] Registered led device: iwl-phy0:radio
[18193.056910] Registered led device: iwl-phy0:assoc
[18193.056956] Registered led device: iwl-phy0:RX
[18193.059056] Registered led device: iwl-phy0:TX
[18193.075476] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[18193.077752] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[18193.276276] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 2
[18193.476312] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 3
[18193.676300] wlan0: direct probe to AP 00:03:52:4d:bd:c1 timed out
[18304.966370] psmouse.c: TrackPoint at isa0060/serio1/input0 lost synchron=
ization, throwing 1 bytes away.
[18304.967665] vendor=3D8086 device=3D2942
[18304.967668] iwlagn 0000:03:00.0: PCI INT A disabled
[18313.513145] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[18313.513153] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[18313.513329] vendor=3D8086 device=3D2942
[18313.513337] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[18313.513386] iwlagn 0000:03:00.0: setting latency timer to 64
[18313.513496] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[18313.543349] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[18313.546075] wmaster0 (iwlagn): not using net_device_ops yet
[18313.547593] phy1: Selected rate control algorithm 'iwl-agn-rs'
[18313.547644] wlan0 (iwlagn): not using net_device_ops yet
[18313.568716] vendor=3D8086 device=3D2942
[18313.572654] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[18313.572849] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[18313.572921] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[18315.784739] Registered led device: iwl-phy1:radio
[18315.784985] Registered led device: iwl-phy1:assoc
[18315.785225] Registered led device: iwl-phy1:RX
[18315.785968] Registered led device: iwl-phy1:TX
[18315.806220] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[18335.966763] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[18335.969035] wlan0 direct probe responded
[18335.969042] wlan0: authenticate with AP 00:03:52:4d:de:d1
[18336.168271] wlan0: authenticate with AP 00:03:52:4d:de:d1
[18336.170239] wlan0: authenticated
[18336.170247] wlan0: associate with AP 00:03:52:4d:de:d1
[18336.172563] wlan0: RX AssocResp from 00:03:52:4d:de:d1 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[18336.172571] wlan0: associated
[18336.177204] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[18346.232256] wlan0: no IPv6 routers present
[18347.759910] tun0: Disabled Privacy Extensions
[20268.634544] tun0: Disabled Privacy Extensions
[20289.040251] tun0: Disabled Privacy Extensions
[21217.789498] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0x=
e frozen
[21217.789506] ata2: irq_stat 0x00000040, connection status changed
[21217.789513] ata2: SError: { CommWake DevExch }
[21217.789530] ata2: hard resetting link
[21218.512143] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[21218.670250] thinkpad_acpi: unhandled HKEY event 0x6030
[21218.673750] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[21218.675459] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x100)
[21218.744731] ACPI: \_SB_.GDCK - docking
[21218.765828] ata2: hard resetting link
[21218.904153] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 7
[21219.037376] usb 7-5: configuration #1 chosen from 1 choice
[21219.037619] hub 7-5:1.0: USB hub found
[21219.037920] hub 7-5:1.0: 4 ports detected
[21219.088071] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[21219.094748] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[21219.095592] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[21219.099346] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[21219.106993] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[21219.107834] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[21219.111551] ata2.00: configured for UDMA/133
[21219.149795] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX/TX
[21219.149798] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[21219.150114] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[21219.252515] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[21219.252519] ata2: irq_stat 0x40000001
[21219.261041] ata2.00: configured for UDMA/133
[21219.261046] ata2: EH complete
[21219.264686] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[21219.308163] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 8
[21219.402055] usb 7-5.4: configuration #1 chosen from 1 choice
[21219.403287] usblp0: USB Bidirectional printer dev 8 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[21219.618168] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[21219.618246] sr 1:0:0:0: Attached scsi CD-ROM sr0
[21219.618340] sr 1:0:0:0: Attached scsi generic sg1 type 5
[21226.151216] hal_lpadmin[32664] general protection ip:44c404 sp:7fff85c16=
120 error:0 in python2.5[400000+125000]
[21233.980055] eth0: no IPv6 routers present
[21243.909124] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[21244.108132] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[21244.308202] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[21244.508131] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[21264.494910] psmouse.c: TrackPoint at isa0060/serio1/input0 lost synchron=
ization, throwing 1 bytes away.
[21296.648349] vendor=3D8086 device=3D2942
[21296.648361] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[21296.648548] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[21296.675772] Registered led device: iwl-phy1:radio
[21296.675835] Registered led device: iwl-phy1:assoc
[21296.675883] Registered led device: iwl-phy1:RX
[21296.675928] Registered led device: iwl-phy1:TX
[21296.695131] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[32144.786555] PM: Syncing filesystems ... done.
[32146.166548] Freezing user space processes ... (elapsed 0.02 seconds) don=
e.
[32146.188164] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[32146.188442] Suspending console(s) (use no_console_suspend to debug)
[32146.204192] pci 0000:00:02.0: power state changed by ACPI to D3
[32146.205313] btusb_intr_complete: hci0 urb ffff880076050a80 failed to res=
ubmit (2)
[32147.128390] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[32147.128490] sd 0:0:0:0: [sda] Stopping disk
[32149.560300] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[32149.579158] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[32149.579229] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[32149.579291] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[32149.579353] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[32149.592859] HDA Intel 0000:00:1b.0: PCI INT B disabled
[32149.608130] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[32149.626762] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[32149.626830] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[32149.626894] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[32149.626956] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[32149.682920] e1000e 0000:00:19.0: PME# enabled
[32149.682939] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[32149.682946] e1000e 0000:00:19.0: PME# enabled
[32149.682950] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[32149.682959] e1000e 0000:00:19.0: PCI INT A disabled
[32149.701901] ACPI: Preparing to enter system sleep state S3
[32149.722419] Disabling non-boot CPUs ...
[32149.724661] CPU 1 is now offline
[32149.724665] SMP alternatives: switching to UP code
[32149.860398] CPU1 is down
[32149.860491] Extended CMOS year: 2000
[32149.860491] Back to C!
[32149.860491] Extended CMOS year: 2000
[32149.860491] Enabling non-boot CPUs ...
[32149.860491] SMP alternatives: switching to SMP code
[32149.966371] Booting processor 1 APIC 0x1 ip 0x6000
[32149.853824] Initializing CPU#1
[32149.853824] Calibrating delay using timer specific routine.. 4521.73 Bog=
oMIPS (lpj=3D9043467)
[32149.853824] CPU: L1 I cache: 32K, L1 D cache: 32K
[32149.853824] CPU: L2 cache: 3072K
[32149.853824] CPU: Physical Processor ID: 0
[32149.853824] CPU: Processor Core ID: 1
[32150.056509] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[32150.057012] Switched to high resolution mode on CPU 1
[32150.068312] CPU1 is up
[32150.068314] ACPI: Waking up from system sleep state S3
[32150.110797] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[32150.159596] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900003)
[32150.163455] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900403, writing 0x900003)
[32150.163483] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[32150.163495] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[32150.163507] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[32150.176153] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[32150.176162] e1000e 0000:00:19.0: setting latency timer to 64
[32150.176171] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[32150.176178] e1000e 0000:00:19.0: PME# disabled
[32150.176182] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[32150.176189] e1000e 0000:00:19.0: PME# disabled
[32150.176239] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[32150.237278] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[32150.237289] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[32150.237297] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[32150.237373] usb usb1: root hub lost power or was reset
[32150.237400] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[32150.237408] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[32150.237481] usb usb2: root hub lost power or was reset
[32150.238459] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[32150.238468] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[32150.238476] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[32150.238550] usb usb3: root hub lost power or was reset
[32150.239491] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[32150.239502] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[32150.239510] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[32150.252163] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[32150.252191] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[32150.252201] HDA Intel 0000:00:1b.0: setting latency timer to 64
[32150.252252] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x7 (was 0xf0, writing 0x200000f0)
[32150.252270] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[32150.252320] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[32150.252359] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x7 (was 0xf0, writing 0x200000f0)
[32150.252377] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[32150.252428] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[32150.252476] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[32150.252527] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[32150.253409] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[32150.253418] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[32150.253426] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[32150.253500] usb usb4: root hub lost power or was reset
[32150.253524] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[32150.253532] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[32150.253605] usb usb5: root hub lost power or was reset
[32150.253629] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[32150.253637] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[32150.253710] usb usb6: root hub lost power or was reset
[32150.254581] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[32150.254592] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[32150.254600] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[32150.254684] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[32150.254701] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[32150.254710] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[32150.254718] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[32150.254736] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[32150.254757] pci 0000:00:1e.0: setting latency timer to 64
[32150.268135] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[32150.268189] ahci 0000:00:1f.2: setting latency timer to 64
[32150.284121] vendor=3D8086 device=3D2942
[32150.284126] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[32150.284305] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[32150.303976] sd 0:0:0:0: [sda] Starting disk
[32150.322551] Registered led device: iwl-phy1:radio
[32150.322595] Registered led device: iwl-phy1:assoc
[32150.322638] Registered led device: iwl-phy1:RX
[32150.322680] Registered led device: iwl-phy1:TX
[32150.592127] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[32150.598890] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32150.599737] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32150.611434] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32150.612279] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32150.616078] ata2.00: configured for UDMA/133
[32151.654217] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[32151.741724] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[32151.741730] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[32151.741905] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[32151.741910] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[32151.752810] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[32151.752816] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[32151.752992] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[32151.752997] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[32151.753893] ata1.00: configured for UDMA/100
[32151.755820] ata1.00: configured for UDMA/100
[32151.772115] ata1: EH complete
[32151.772185] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[32151.772216] sd 0:0:0:0: [sda] Write Protect is off
[32151.772221] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[32151.772266] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[32151.772313] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[32151.772340] sd 0:0:0:0: [sda] Write Protect is off
[32151.772344] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[32151.772387] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[32151.880900] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX/TX
[32151.880905] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[32153.148094] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 4
[32153.396075] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 3
[32153.656076] usb 2-2: reset full speed USB device using uhci_hcd and addr=
ess 4
[32153.805340] pci 0000:00:02.0: power state changed by ACPI to D0
[32153.805373] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900403, writing 0x900003)
[32153.805534] pci 0000:00:02.0: power state changed by ACPI to D0
[32153.805545] pci 0000:00:02.0: setting latency timer to 64
[32153.807884] pm_op(): usb_dev_resume+0x0/0x5 [usbcore] returns -19
[32153.807888] PM: Device 7-5 failed to resume: error -19
[32153.807928] pm_op(): usb_dev_resume+0x0/0x5 [usbcore] returns -19
[32153.807932] PM: Device 7-5.4 failed to resume: error -19
[32153.822623] Restarting tasks ... <6>usb 7-5: USB disconnect, address 7
[32153.822955] usb 7-5.4: USB disconnect, address 8
[32153.823489] usblp0: removed
[32153.897558] done.
[32157.884231] e1000e: eth0 NIC Link is Down
[32159.608936] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: None
[32159.608945] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[32159.609725] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[32176.216139] eth0: no IPv6 routers present
[32182.827568] iwlagn: Radio Frequency Kill Switch is On:
[32182.827571] Kill switch must be turned off for wireless networking to wo=
rk.
[32182.864230] usb 2-2: USB disconnect, address 4
[32182.866153] btusb_intr_complete: hci0 urb ffff880053c173c0 failed to res=
ubmit (19)
[32182.866979] btusb_send_frame: hci0 urb ffff8800214b6f00 submission failed
[32199.232280] e1000e: eth0 NIC Link is Down
[32199.237689] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x=
e frozen
[32199.237695] ata2: irq_stat 0x00400040, connection status changed
[32199.237702] ata2: SError: { PHYRdyChg DevExch }
[32199.237716] ata2: hard resetting link
[32199.914073] thinkpad_acpi: unhandled HKEY event 0x6030
[32199.960067] ata2: SATA link down (SStatus 0 SControl 300)
[32202.308532] ata2: hard resetting link
[32202.324993] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: None
[32202.325022] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[32202.325787] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[32202.628289] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[32202.635517] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32202.636519] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32202.649810] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32202.650804] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32202.655367] ata2.00: configured for UDMA/133
[32202.766112] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[32202.766120] ata2: irq_stat 0x40000001
[32202.766132] ata2.00: disabled
[32202.766142] ata2: hard resetting link
[32203.185801] thinkpad_acpi: unhandled HKEY event 0x6030
[32203.416120] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 9
[32203.488074] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[32203.495633] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32203.496565] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32203.500585] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[32203.508565] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32203.509489] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32203.513298] ata2.00: configured for UDMA/133
[32203.548711] usb 7-5: configuration #1 chosen from 1 choice
[32203.548921] hub 7-5:1.0: USB hub found
[32203.548981] hub 7-5:1.0: 4 ports detected
[32203.625857] ata2: EH complete
[32203.626100] ata2.00: detaching (SCSI 1:0:0:0)
[32203.629388] ACPI: \_SB_.GDCK - undocking
[32203.634172] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action=
 0xe frozen
[32203.634180] ata2.00: irq_stat 0x00400040, connection status changed
[32203.634187] ata2: SError: { PHYRdyChg DevExch }
[32203.634200] ata2.00: cmd a0/00:00:00:02:00/00:00:00:00:00/a0 tag 0 pio 1=
6388 in
[32203.634203]          cdb 51 00 00 00 00 00 00 00  02 00 00 00 00 00 00 00
[32203.634206]          res 51/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x10 =
(ATA bus error)
[32203.634212] ata2.00: status: { DRDY ERR }
[32203.634226] ata2: hard resetting link
[32203.670815] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[32203.671137] ACPI: Unable to dock!
[32203.671476] ACPI: \_SB_.GDCK - docking
[32203.671762] usb 7-5: USB disconnect, address 9
[32204.209379] ACPI: Unable to dock!
[32204.492133] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[32204.499107] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32204.499998] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32204.511381] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[32204.512241] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[32204.516137] ata2.00: configured for UDMA/133
[32204.627765] ata2: EH complete
[32219.500153] eth0: no IPv6 routers present
[32221.534208] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[32221.538468] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 =
cdda tray
[32221.538641] sr 1:0:0:0: Attached scsi CD-ROM sr0
[32221.538837] sr 1:0:0:0: Attached scsi generic sg1 type 5
[39624.096057] usb 2-2: new full speed USB device using uhci_hcd and addres=
s 5
[39624.263961] usb 2-2: configuration #1 chosen from 1 choice
[39625.524475] Registered led device: iwl-phy1:radio
[39625.524507] Registered led device: iwl-phy1:assoc
[39625.524525] Registered led device: iwl-phy1:RX
[39625.524544] Registered led device: iwl-phy1:TX
[39631.401640] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[39631.406110] wlan0 direct probe responded
[39631.406116] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[39631.604163] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[39631.605962] wlan0: authenticated
[39631.605967] wlan0: associate with AP 00:03:52:4d:bd:c1
[39631.608147] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x21 sta=
tus=3D0 aid=3D10)
[39631.608153] wlan0: associated
[39631.612065] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[39642.380094] wlan0: no IPv6 routers present
[39645.060396] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[39645.116179] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[39645.117085] ADDRCONF(NETDEV_UP): eth0: link is not ready
[39646.688938] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX/TX
[39646.688946] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[39646.689714] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[39651.510635] tun0: Disabled Privacy Extensions
[39660.393107] eth0: no IPv6 routers present
[39664.256789] tun0: Disabled Privacy Extensions
[39668.808229] e1000e: eth0 NIC Link is Down
[39668.815689] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x=
e frozen
[39668.815696] ata2: irq_stat 0x00400040, connection status changed
[39668.815702] ata2: SError: { PHYRdyChg DevExch }
[39668.815716] ata2: hard resetting link
[39669.485695] thinkpad_acpi: unhandled HKEY event 0x6030
[39669.536320] ata2: SATA link down (SStatus 0 SControl 300)
[39674.536272] ata2: hard resetting link
[39674.856285] ata2: SATA link down (SStatus 0 SControl 300)
[39679.856290] ata2: hard resetting link
[39680.176283] ata2: SATA link down (SStatus 0 SControl 300)
[39680.176297] ata2.00: disabled
[39680.176327] ata2: EH complete
[39680.176350] ata2.00: detaching (SCSI 1:0:0:0)
[39680.176395] ACPI: \_SB_.GDCK - undocking
[39680.206243] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[39680.206568] ACPI: Unable to dock!
[39780.682764] wlan0: deauthenticated (Reason: 2)
[39781.680275] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[39781.880276] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 2
[39782.080276] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 3
[39782.280271] wlan0: direct probe to AP 00:03:52:4d:bd:c1 timed out
[39960.639480] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[39960.836074] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[39961.036289] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[39961.038602] wlan0 direct probe responded
[39961.038610] wlan0: authenticate with AP 00:03:52:1c:12:11
[39961.236097] wlan0: authenticate with AP 00:03:52:1c:12:11
[39961.436297] wlan0: authenticate with AP 00:03:52:1c:12:11
[39961.439835] wlan0: authenticated
[39961.439843] wlan0: associate with AP 00:03:52:1c:12:11
[39961.636269] wlan0: associate with AP 00:03:52:1c:12:11
[39961.638592] wlan0: RX ReassocResp from 00:03:52:1c:12:11 (capab=3D0x421 =
status=3D0 aid=3D1)
[39961.638599] wlan0: associated
[41912.884264] wlan0: No ProbeResp from current AP 00:03:52:1c:12:11 - assu=
me out of range
[42102.439437] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0x=
e frozen
[42102.439445] ata2: irq_stat 0x00000040, connection status changed
[42102.439452] ata2: SError: { CommWake DevExch }
[42102.439469] ata2: hard resetting link
[42102.721044] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: RX/TX
[42102.721054] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[42102.721838] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[42103.160287] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[42103.309644] thinkpad_acpi: unhandled HKEY event 0x6030
[42103.311923] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[42103.314824] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 failed (Emask=3D0x100=
 Stat=3D0x00 Err=3D0x01)
[42103.406914] ACPI: \_SB_.GDCK - docking
[42103.441089] ata2: hard resetting link
[42103.548102] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 11
[42103.681139] usb 7-5: configuration #1 chosen from 1 choice
[42103.681338] hub 7-5:1.0: USB hub found
[42103.681635] hub 7-5:1.0: 4 ports detected
[42103.760039] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[42103.766328] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[42103.767167] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[42103.778192] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[42103.779034] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[42103.782723] ata2.00: configured for UDMA/133
[42103.906079] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[42103.906086] ata2: irq_stat 0x40000001
[42103.914541] ata2.00: configured for UDMA/133
[42103.914548] ata2: EH complete
[42103.952194] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 12
[42104.046152] usb 7-5.4: configuration #1 chosen from 1 choice
[42104.048388] usblp0: USB Bidirectional printer dev 12 if 0 alt 1 proto 2 =
vid 0x03F0 pid 0x0B17
[42118.356101] eth0: no IPv6 routers present
[42120.858107] hal_lpadmin[29319] general protection ip:44c404 sp:7fffa0a4b=
f60 error:0 in python2.5[400000+125000]
[42163.900878] vendor=3D8086 device=3D2942
[42163.900891] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[42163.901104] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[42163.927714] Registered led device: iwl-phy1:radio
[42163.927777] Registered led device: iwl-phy1:assoc
[42163.927825] Registered led device: iwl-phy1:RX
[42163.927869] Registered led device: iwl-phy1:TX
[42163.950262] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[50490.469268] RPC: Registered udp transport module.
[50490.469275] RPC: Registered tcp transport module.
[65537.060989] PM: Syncing filesystems ... done.
[65537.993057] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[65538.013249] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[65538.017376] Suspending console(s) (use no_console_suspend to debug)
[65538.019994] btusb_intr_complete: hci0 urb ffff880074cf5900 failed to res=
ubmit (2)
[65538.288272] pci 0000:00:02.0: power state changed by ACPI to D3
[65538.964468] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[65538.964561] sd 0:0:0:0: [sda] Stopping disk
[65541.372223] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[65541.388714] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[65541.388784] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[65541.388847] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[65541.388909] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[65541.404671] HDA Intel 0000:00:1b.0: PCI INT B disabled
[65541.420190] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[65541.436953] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[65541.437021] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[65541.437083] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[65541.437146] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[65541.494921] e1000e 0000:00:19.0: PME# enabled
[65541.494940] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[65541.494947] e1000e 0000:00:19.0: PME# enabled
[65541.494951] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[65541.494961] e1000e 0000:00:19.0: PCI INT A disabled
[65541.513401] ACPI: Preparing to enter system sleep state S3
[65541.533572] Disabling non-boot CPUs ...
[65541.636023] CPU 1 is now offline
[65541.636027] SMP alternatives: switching to UP code
[65541.848316] CPU1 is down
[65541.848409] Extended CMOS year: 2000
[65541.848409] Back to C!
[65541.848409] Extended CMOS year: 2000
[65541.848409] Enabling non-boot CPUs ...
[65541.848409] SMP alternatives: switching to SMP code
[65541.973387] Booting processor 1 APIC 0x1 ip 0x6000
[65541.840152] Initializing CPU#1
[65541.840152] Calibrating delay using timer specific routine.. 4522.38 Bog=
oMIPS (lpj=3D9044779)
[65541.840152] CPU: L1 I cache: 32K, L1 D cache: 32K
[65541.840152] CPU: L2 cache: 3072K
[65541.840152] CPU: Physical Processor ID: 0
[65541.840152] CPU: Processor Core ID: 1
[65542.064488] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[65542.065011] Switched to high resolution mode on CPU 1
[65542.076304] CPU1 is up
[65542.076305] ACPI: Waking up from system sleep state S3
[65542.124445] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[65542.129115] thinkpad_acpi: unhandled HKEY event 0x6030
[65542.199762] ACPI: \_SB_.GDCK - undocking
[65542.224677] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[65542.224840] ACPI: Unable to dock!
[65542.234395] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[65542.238743] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[65542.238755] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[65542.238767] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[65542.252291] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[65542.252297] e1000e 0000:00:19.0: setting latency timer to 64
[65542.252302] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[65542.252306] e1000e 0000:00:19.0: PME# disabled
[65542.252309] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[65542.252313] e1000e 0000:00:19.0: PME# disabled
[65542.252346] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[65542.308784] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[65542.308790] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[65542.308795] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[65542.308849] usb usb1: root hub lost power or was reset
[65542.308869] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[65542.308873] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[65542.308926] usb usb2: root hub lost power or was reset
[65542.309749] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[65542.309754] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[65542.309759] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[65542.309812] usb usb3: root hub lost power or was reset
[65542.310554] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[65542.310562] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[65542.310567] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[65542.324094] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[65542.324117] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[65542.324123] HDA Intel 0000:00:1b.0: setting latency timer to 64
[65542.324169] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[65542.324204] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[65542.324236] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[65542.324270] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[65542.324303] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[65542.324337] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[65542.324819] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[65542.324824] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[65542.324828] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[65542.324882] usb usb4: root hub lost power or was reset
[65542.324901] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[65542.324906] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[65542.324959] usb usb5: root hub lost power or was reset
[65542.324977] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[65542.324981] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[65542.325035] usb usb6: root hub lost power or was reset
[65542.325707] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[65542.325715] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[65542.325721] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[65542.325781] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[65542.325792] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[65542.325797] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[65542.325802] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[65542.325813] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[65542.325826] pci 0000:00:1e.0: setting latency timer to 64
[65542.340095] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[65542.340161] ahci 0000:00:1f.2: setting latency timer to 64
[65542.340236] ata2.00: disabled
[65542.356274] vendor=3D8086 device=3D2942
[65542.356283] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[65542.356468] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[65542.376156] sd 0:0:0:0: [sda] Starting disk
[65542.392692] Registered led device: iwl-phy1:radio
[65542.392736] Registered led device: iwl-phy1:assoc
[65542.392778] Registered led device: iwl-phy1:RX
[65542.392819] Registered led device: iwl-phy1:TX
[65542.661289] ata2: SATA link down (SStatus 0 SControl 300)
[65544.229272] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[65544.300655] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[65544.300662] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[65544.300797] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[65544.300803] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[65544.311615] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[65544.311622] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[65544.311731] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[65544.311738] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[65544.312734] ata1.00: configured for UDMA/100
[65544.314566] ata1.00: configured for UDMA/100
[65544.328278] ata1: EH complete
[65544.328370] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[65544.328402] sd 0:0:0:0: [sda] Write Protect is off
[65544.328407] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[65544.328452] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[65544.328504] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[65544.328531] sd 0:0:0:0: [sda] Write Protect is off
[65544.328535] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[65544.328580] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[65545.720316] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 4
[65545.968318] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 3
[65546.120765] pci 0000:00:02.0: power state changed by ACPI to D0
[65546.120955] pci 0000:00:02.0: power state changed by ACPI to D0
[65546.120967] pci 0000:00:02.0: setting latency timer to 64
[65546.232288] usb 2-2: reset full speed USB device using uhci_hcd and addr=
ess 5
[65546.385627] pm_op(): usb_dev_resume+0x0/0x5 [usbcore] returns -19
[65546.385634] PM: Device 7-5 failed to resume: error -19
[65546.385671] pm_op(): usb_dev_resume+0x0/0x5 [usbcore] returns -19
[65546.385675] PM: Device 7-5.4 failed to resume: error -19
[65546.403084] Restarting tasks ... <6>usb 7-5: USB disconnect, address 11
[65546.403422] usb 7-5.4: USB disconnect, address 12
[65546.403940] usblp0: removed
[65546.439663] done.
[66165.586797] PM: Syncing filesystems ... done.
[66166.898139] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[66166.917241] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[66166.922344] Suspending console(s) (use no_console_suspend to debug)
[66166.924394] btusb_intr_complete: hci0 urb ffff8800165f6180 failed to res=
ubmit (2)
[66167.188438] pci 0000:00:02.0: power state changed by ACPI to D3
[66167.864647] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[66167.865279] sd 0:0:0:0: [sda] Stopping disk
[66170.312458] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[66170.329442] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[66170.329522] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[66170.329586] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[66170.329649] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[66170.329855] HDA Intel 0000:00:1b.0: PCI INT B disabled
[66170.344259] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[66170.361480] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[66170.361558] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[66170.361622] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[66170.361685] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[66170.419151] e1000e 0000:00:19.0: PME# enabled
[66170.419183] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[66170.419191] e1000e 0000:00:19.0: PME# enabled
[66170.419195] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[66170.419206] e1000e 0000:00:19.0: PCI INT A disabled
[66170.437915] ACPI: Preparing to enter system sleep state S3
[66170.456987] Disabling non-boot CPUs ...
[66170.560023] CPU 1 is now offline
[66170.560027] SMP alternatives: switching to UP code
[66170.748183] CPU1 is down
[66170.748278] Extended CMOS year: 2000
[66170.748278] Back to C!
[66170.748278] Extended CMOS year: 2000
[66170.748278] Enabling non-boot CPUs ...
[66170.748278] SMP alternatives: switching to SMP code
[66170.872893] Booting processor 1 APIC 0x1 ip 0x6000
[66170.735904] Initializing CPU#1
[66170.735904] Calibrating delay using timer specific routine.. 4522.04 Bog=
oMIPS (lpj=3D9044099)
[66170.735904] CPU: L1 I cache: 32K, L1 D cache: 32K
[66170.735904] CPU: L2 cache: 3072K
[66170.735904] CPU: Physical Processor ID: 0
[66170.735904] CPU: Processor Core ID: 1
[66170.960471] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[66170.961011] Switched to high resolution mode on CPU 1
[66170.972302] CPU1 is up
[66170.972304] ACPI: Waking up from system sleep state S3
[66171.009731] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[66171.061037] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[66171.064932] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[66171.064944] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[66171.064956] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[66171.080089] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[66171.080094] e1000e 0000:00:19.0: setting latency timer to 64
[66171.080099] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[66171.080103] e1000e 0000:00:19.0: PME# disabled
[66171.080105] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[66171.080109] e1000e 0000:00:19.0: PME# disabled
[66171.080142] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[66171.137262] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[66171.137277] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[66171.137286] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[66171.137363] usb usb1: root hub lost power or was reset
[66171.137391] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[66171.137399] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[66171.137472] usb usb2: root hub lost power or was reset
[66171.138160] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[66171.138169] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[66171.138177] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[66171.138251] usb usb3: root hub lost power or was reset
[66171.139157] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[66171.139169] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[66171.139177] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[66171.152317] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[66171.152352] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[66171.152363] HDA Intel 0000:00:1b.0: setting latency timer to 64
[66171.152434] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[66171.152485] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[66171.152535] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[66171.152586] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[66171.152635] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[66171.152685] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[66171.153649] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[66171.153659] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[66171.153667] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[66171.153741] usb usb4: root hub lost power or was reset
[66171.153767] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[66171.153775] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[66171.153848] usb usb5: root hub lost power or was reset
[66171.153872] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[66171.153879] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[66171.153952] usb usb6: root hub lost power or was reset
[66171.154650] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[66171.154661] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[66171.154669] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[66171.154753] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[66171.154771] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[66171.154779] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[66171.154788] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[66171.154805] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[66171.154827] pci 0000:00:1e.0: setting latency timer to 64
[66171.168089] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[66171.168142] ahci 0000:00:1f.2: setting latency timer to 64
[66171.184273] vendor=3D8086 device=3D2942
[66171.184282] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[66171.184467] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[66171.204190] sd 0:0:0:0: [sda] Starting disk
[66171.220669] Registered led device: iwl-phy1:radio
[66171.220713] Registered led device: iwl-phy1:assoc
[66171.220756] Registered led device: iwl-phy1:RX
[66171.220797] Registered led device: iwl-phy1:TX
[66171.492275] ata2: SATA link down (SStatus 0 SControl 300)
[66172.833275] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[66172.889638] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[66172.889646] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[66172.889766] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[66172.889772] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[66172.900716] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[66172.900723] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[66172.900827] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[66172.900832] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[66172.901656] ata1.00: configured for UDMA/100
[66172.903758] ata1.00: configured for UDMA/100
[66172.917276] ata1: EH complete
[66172.917365] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[66172.917398] sd 0:0:0:0: [sda] Write Protect is off
[66172.917402] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[66172.917448] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[66172.917500] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[66172.917528] sd 0:0:0:0: [sda] Write Protect is off
[66172.917532] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[66172.917576] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[66174.308316] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 4
[66174.556282] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 3
[66174.708768] pci 0000:00:02.0: power state changed by ACPI to D0
[66174.708958] pci 0000:00:02.0: power state changed by ACPI to D0
[66174.708970] pci 0000:00:02.0: setting latency timer to 64
[66174.820278] usb 2-2: reset full speed USB device using uhci_hcd and addr=
ess 5
[66174.989915] Restarting tasks ... done.
[66176.050070] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[66176.356927] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[66176.377059] input: TPPS/2 IBM TrackPoint as /class/input/input9
[66736.533760] PM: Syncing filesystems ... done.
[66737.214084] Freezing user space processes ... (elapsed 0.02 seconds) don=
e.
[66737.237242] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[66737.240522] Suspending console(s) (use no_console_suspend to debug)
[66737.243373] btusb_intr_complete: hci0 urb ffff8800179fc180 failed to res=
ubmit (2)
[66737.508438] pci 0000:00:02.0: power state changed by ACPI to D3
[66738.184493] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[66738.185056] sd 0:0:0:0: [sda] Stopping disk
[66740.584450] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[66740.601376] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[66740.601456] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[66740.601519] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[66740.601582] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[66740.601788] HDA Intel 0000:00:1b.0: PCI INT B disabled
[66740.616255] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[66740.633451] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[66740.633530] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[66740.633594] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[66740.633658] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[66740.691103] e1000e 0000:00:19.0: PME# enabled
[66740.691136] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[66740.691144] e1000e 0000:00:19.0: PME# enabled
[66740.691148] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[66740.691159] e1000e 0000:00:19.0: PCI INT A disabled
[66740.709628] ACPI: Preparing to enter system sleep state S3
[66740.727907] Disabling non-boot CPUs ...
[66740.730031] CPU 1 is now offline
[66740.730035] SMP alternatives: switching to UP code
[66740.904336] CPU1 is down
[66740.904429] Extended CMOS year: 2000
[66740.904429] Back to C!
[66740.904429] Extended CMOS year: 2000
[66740.904429] Enabling non-boot CPUs ...
[66740.904429] SMP alternatives: switching to SMP code
[66741.029228] Booting processor 1 APIC 0x1 ip 0x6000
[66740.899814] Initializing CPU#1
[66740.899814] Calibrating delay using timer specific routine.. 4522.04 Bog=
oMIPS (lpj=3D9044083)
[66740.899814] CPU: L1 I cache: 32K, L1 D cache: 32K
[66740.899814] CPU: L2 cache: 3072K
[66740.899814] CPU: Physical Processor ID: 0
[66740.899814] CPU: Processor Core ID: 1
[66741.120471] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[66741.121011] Switched to high resolution mode on CPU 1
[66741.132302] CPU1 is up
[66741.132304] ACPI: Waking up from system sleep state S3
[66741.171018] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[66741.222873] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[66741.226778] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[66741.226791] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[66741.226803] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[66741.240290] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[66741.240296] e1000e 0000:00:19.0: setting latency timer to 64
[66741.240301] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[66741.240306] e1000e 0000:00:19.0: PME# disabled
[66741.240308] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[66741.240312] e1000e 0000:00:19.0: PME# disabled
[66741.240345] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[66741.297714] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[66741.297730] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[66741.297739] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[66741.297817] usb usb1: root hub lost power or was reset
[66741.297847] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[66741.297854] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[66741.297927] usb usb2: root hub lost power or was reset
[66741.298709] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[66741.298718] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[66741.298726] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[66741.298800] usb usb3: root hub lost power or was reset
[66741.299624] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[66741.299635] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[66741.299643] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[66741.312173] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[66741.312202] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[66741.312212] HDA Intel 0000:00:1b.0: setting latency timer to 64
[66741.312279] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[66741.312331] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[66741.312381] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[66741.312431] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[66741.312480] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[66741.312530] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[66741.313501] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[66741.313510] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[66741.313518] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[66741.313592] usb usb4: root hub lost power or was reset
[66741.313617] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[66741.313625] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[66741.313698] usb usb5: root hub lost power or was reset
[66741.313722] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[66741.313730] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[66741.313803] usb usb6: root hub lost power or was reset
[66741.314602] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[66741.314613] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[66741.314622] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[66741.314706] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[66741.314723] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[66741.314732] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[66741.314740] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[66741.314758] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[66741.314779] pci 0000:00:1e.0: setting latency timer to 64
[66741.328088] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[66741.328142] ahci 0000:00:1f.2: setting latency timer to 64
[66741.344118] vendor=3D8086 device=3D2942
[66741.344123] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[66741.344307] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[66741.364031] sd 0:0:0:0: [sda] Starting disk
[66741.380815] Registered led device: iwl-phy1:radio
[66741.380860] Registered led device: iwl-phy1:assoc
[66741.380904] Registered led device: iwl-phy1:RX
[66741.380947] Registered led device: iwl-phy1:TX
[66741.649282] ata2: SATA link down (SStatus 0 SControl 300)
[66743.273280] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[66743.325955] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[66743.325963] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[66743.326108] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[66743.326115] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[66743.336900] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[66743.336907] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[66743.337013] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[66743.337019] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[66743.338044] ata1.00: configured for UDMA/100
[66743.340367] ata1.00: configured for UDMA/100
[66743.356126] ata1: EH complete
[66743.356216] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[66743.356248] sd 0:0:0:0: [sda] Write Protect is off
[66743.356253] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[66743.356298] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[66743.356349] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[66743.356376] sd 0:0:0:0: [sda] Write Protect is off
[66743.356380] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[66743.356425] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[66744.732287] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 4
[66744.980316] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 3
[66745.131798] pci 0000:00:02.0: power state changed by ACPI to D0
[66745.131988] pci 0000:00:02.0: power state changed by ACPI to D0
[66745.132000] pci 0000:00:02.0: setting latency timer to 64
[66745.244317] usb 2-2: reset full speed USB device using uhci_hcd and addr=
ess 5
[66745.412876] Restarting tasks ... done.
[66746.491041] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[66746.798380] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[66746.817598] input: TPPS/2 IBM TrackPoint as /class/input/input10
[68335.237787] PM: Syncing filesystems ... done.
[68336.034302] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[68336.053181] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[68336.057257] Suspending console(s) (use no_console_suspend to debug)
[68336.059536] btusb_intr_complete: hci0 urb ffff880065c7e480 failed to res=
ubmit (2)
[68336.324438] pci 0000:00:02.0: power state changed by ACPI to D3
[68336.996457] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[68336.996955] sd 0:0:0:0: [sda] Stopping disk
[68339.384271] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[68339.402071] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[68339.402150] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[68339.402214] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[68339.402277] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[68339.402483] HDA Intel 0000:00:1b.0: PCI INT B disabled
[68339.416208] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[68339.432962] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[68339.433034] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[68339.433098] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[68339.433160] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[68339.491101] e1000e 0000:00:19.0: PME# enabled
[68339.491133] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[68339.491141] e1000e 0000:00:19.0: PME# enabled
[68339.491145] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[68339.491156] e1000e 0000:00:19.0: PCI INT A disabled
[68339.510331] ACPI: Preparing to enter system sleep state S3
[68339.530635] Disabling non-boot CPUs ...
[68339.532750] CPU 1 is now offline
[68339.532753] SMP alternatives: switching to UP code
[68339.704335] CPU1 is down
[68339.704429] Extended CMOS year: 2000
[68339.704429] Back to C!
[68339.704429] Extended CMOS year: 2000
[68339.704429] Enabling non-boot CPUs ...
[68339.704429] SMP alternatives: switching to SMP code
[68339.829550] Booting processor 1 APIC 0x1 ip 0x6000
[68339.701654] Initializing CPU#1
[68339.701654] Calibrating delay using timer specific routine.. 4522.01 Bog=
oMIPS (lpj=3D9044037)
[68339.701654] CPU: L1 I cache: 32K, L1 D cache: 32K
[68339.701654] CPU: L2 cache: 3072K
[68339.701654] CPU: Physical Processor ID: 0
[68339.701654] CPU: Processor Core ID: 1
[68339.920475] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[68339.921011] Switched to high resolution mode on CPU 1
[68339.932304] CPU1 is up
[68339.932306] ACPI: Waking up from system sleep state S3
[68339.971004] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[68340.022346] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[68340.025772] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[68340.025785] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[68340.025797] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[68340.040080] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[68340.040085] e1000e 0000:00:19.0: setting latency timer to 64
[68340.040090] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[68340.040095] e1000e 0000:00:19.0: PME# disabled
[68340.040097] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[68340.040100] e1000e 0000:00:19.0: PME# disabled
[68340.040133] e1000e 0000:00:19.0: irq 315 for MSI/MSI-X
[68340.097225] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[68340.097234] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[68340.097243] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[68340.097318] usb usb1: root hub lost power or was reset
[68340.097345] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[68340.097353] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[68340.097426] usb usb2: root hub lost power or was reset
[68340.098449] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[68340.098457] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[68340.098465] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[68340.098539] usb usb3: root hub lost power or was reset
[68340.099403] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[68340.099414] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[68340.099422] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[68340.112201] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[68340.112236] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[68340.112246] HDA Intel 0000:00:1b.0: setting latency timer to 64
[68340.112317] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[68340.112368] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[68340.112418] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[68340.112469] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[68340.112518] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[68340.112568] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[68340.113294] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[68340.113303] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[68340.113311] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[68340.113386] usb usb4: root hub lost power or was reset
[68340.113411] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[68340.113419] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[68340.113493] usb usb5: root hub lost power or was reset
[68340.113517] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[68340.113524] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[68340.113597] usb usb6: root hub lost power or was reset
[68340.114520] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[68340.114531] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[68340.114540] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[68340.114624] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[68340.114641] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[68340.114650] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[68340.114658] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[68340.114676] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[68340.114697] pci 0000:00:1e.0: setting latency timer to 64
[68340.128158] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[68340.128211] ahci 0000:00:1f.2: setting latency timer to 64
[68340.144275] vendor=3D8086 device=3D2942
[68340.144283] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[68340.144470] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[68340.164187] sd 0:0:0:0: [sda] Starting disk
[68340.180662] Registered led device: iwl-phy1:radio
[68340.180707] Registered led device: iwl-phy1:assoc
[68340.180750] Registered led device: iwl-phy1:RX
[68340.180793] Registered led device: iwl-phy1:TX
[68340.449274] ata2: SATA link down (SStatus 0 SControl 300)
[68342.129279] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[68342.215856] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[68342.215864] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[68342.216197] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[68342.216204] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[68342.226940] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[68342.226947] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[68342.227265] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[68342.227272] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[68342.228094] ata1.00: configured for UDMA/100
[68342.229986] ata1.00: configured for UDMA/100
[68342.244268] ata1: EH complete
[68342.244361] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[68342.244394] sd 0:0:0:0: [sda] Write Protect is off
[68342.244398] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[68342.244444] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[68342.244496] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[68342.244523] sd 0:0:0:0: [sda] Write Protect is off
[68342.244527] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[68342.244572] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[68343.624317] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 4
[68343.872287] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 3
[68344.023792] pci 0000:00:02.0: power state changed by ACPI to D0
[68344.023980] pci 0000:00:02.0: power state changed by ACPI to D0
[68344.023993] pci 0000:00:02.0: setting latency timer to 64
[68344.136320] usb 2-2: reset full speed USB device using uhci_hcd and addr=
ess 5
[68344.305916] Restarting tasks ... done.
[68345.361394] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[68345.663812] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[68345.682196] input: TPPS/2 IBM TrackPoint as /class/input/input11
[68489.268054] usb 7-1: new high speed USB device using ehci_hcd and addres=
s 13
[68489.414122] usb 7-1: configuration #1 chosen from 1 choice
[68489.740123] usbcore: registered new interface driver libusual
[68489.808886] Initializing USB Mass Storage driver...
[68489.815721] usb-storage: probe of 7-1:1.0 failed with error -5
[68489.815779] usbcore: registered new interface driver usb-storage
[68489.815785] USB Mass Storage support registered.
[68489.818423] usb 7-1: USB disconnect, address 13
[68490.076140] usb 7-1: new high speed USB device using ehci_hcd and addres=
s 14
[68490.221747] usb 7-1: configuration #1 chosen from 1 choice
[68490.276105] scsi5 : SCSI emulation for USB Mass Storage devices
[68490.276549] usb-storage: device found at 14
[68490.276553] usb-storage: waiting for device to settle before scanning
[68490.455842] usbcore: registered new interface driver usbserial
[68490.455845] usbserial: USB Serial Driver core
[68490.458869] USB Serial support registered for Sierra USB modem
[68490.458897] sierra 7-1:1.0: Sierra USB modem converter detected
[68490.459373] usb 7-1: Sierra USB modem converter now attached to ttyUSB0
[68490.459383] sierra 7-1:1.1: Sierra USB modem converter detected
[68490.460229] usb 7-1: Sierra USB modem converter now attached to ttyUSB1
[68490.460242] sierra 7-1:1.2: Sierra USB modem converter detected
[68490.461046] usb 7-1: Sierra USB modem converter now attached to ttyUSB2
[68490.461056] sierra 7-1:1.3: Sierra USB modem converter detected
[68490.462044] usb 7-1: Sierra USB modem converter now attached to ttyUSB3
[68490.462054] sierra 7-1:1.4: Sierra USB modem converter detected
[68490.463042] usb 7-1: Sierra USB modem converter now attached to ttyUSB4
[68490.463051] sierra 7-1:1.5: Sierra USB modem converter detected
[68490.464311] usb 7-1: Sierra USB modem converter now attached to ttyUSB5
[68490.464321] sierra 7-1:1.6: Sierra USB modem converter detected
[68490.465050] usb 7-1: Sierra USB modem converter now attached to ttyUSB6
[68490.465063] usbcore: registered new interface driver sierra
[68490.465065] sierra: v.1.3.2:USB Driver for Sierra Wireless USB modems
[68495.274800] isa bounce pool size: 16 pages
[68495.276621] scsi 5:0:0:0: Direct-Access     SWI      SD Card          2.=
31 PQ: 0 ANSI: 2
[68495.282335] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[68495.282550] sd 5:0:0:0: Attached scsi generic sg1 type 0
[68495.282998] usb-storage: device scan complete
[68504.418123] PPP generic driver version 2.4.2
[68504.666656] PPP BSD Compression module registered
[68504.801685] PPP Deflate Compression module registered
[68595.368293] device ppp0 entered promiscuous mode
[68604.327010] vendor=3D8086 device=3D2942
[68604.327022] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[68604.327210] iwlagn 0000:03:00.0: irq 314 for MSI/MSI-X
[68604.356406] Registered led device: iwl-phy1:radio
[68604.356456] Registered led device: iwl-phy1:assoc
[68604.356502] Registered led device: iwl-phy1:RX
[68604.356546] Registered led device: iwl-phy1:TX
[68604.370286] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[69134.199241] device ppp0 left promiscuous mode
[69186.618203] general protection fault: 0000 [#1] PREEMPT SMP=20
[69186.618216] last sysfs file: /sys/class/power_supply/BAT0/energy_full
[69186.618220] CPU 0=20
[69186.618224] Modules linked in: ppp_deflate zlib_deflate zlib_inflate bsd=
_comp ppp_async crc_ccitt ppp_generic slhc sierra usbserial usb_storage lib=
usual nfs lockd nfs_acl sunrpc iwlagn tun sg usblp sr_mod cdrom vfat fat i9=
15 drm rfcomm l2cap uinput autofs4 ipv6 cpufreq_powersave sha256_generic an=
si_cprng krng chainiv rng aes_x86_64 aes_generic cbc dm_crypt dm_mod md_mod=
 loop btusb bluetooth arc4 ecb cryptomgr aead crypto_blkcipher crypto_hash =
snd_hda_intel snd_pcm snd_page_alloc snd_hwdep snd_seq snd_timer snd_seq_de=
vice i2c_i801 rtc_cmos rtc_core snd rtc_lib iwlcore i2c_core pcspkr soundco=
re mac80211 cfg80211 ehci_hcd video output uhci_hcd wmi usbcore e1000e inte=
l_agp thinkpad_acpi rfkill hwmon backlight led_class nvram [last unloaded: =
iwlagn]
[69186.618352] Pid: 2848, comm: kcryptd Not tainted 2.6.28-rc6-next-2008112=
5-denkbrett #15
[69186.618357] RIP: 0010:[<ffffffff8031f246>]  [<ffffffff8031f246>] crypto_=
xor+0x7/0x48
[69186.618372] RSP: 0018:ffff880079879cc8  EFLAGS: 00010212
[69186.618377] RAX: 00000000fffffff0 RBX: b6e3880000000010 RCX: 00000000000=
00000
[69186.618382] RDX: 0000000000000010 RSI: b6e3880000000000 RDI: ffff88007a3=
da4e0
[69186.618387] RBP: 0000000000000010 R08: 0000000000000010 R09: 00000000000=
00000
[69186.618392] R10: 0000000000000000 R11: ffff88007a3da4e0 R12: 00000000000=
00010
[69186.618397] R13: ffff88000c8c9000 R14: ffff88007a3da4e0 R15: 00000000000=
001f0
[69186.618403] FS:  0000000000000000(0000) GS:ffffffff805f51c0(0000) knlGS:=
0000000000000000
[69186.618408] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[69186.618413] CR2: 00007f56a00ef000 CR3: 0000000053dc9000 CR4: 00000000000=
006e0
[69186.618418] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[69186.618423] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[69186.618429] Process kcryptd (pid: 2848, threadinfo ffff880079878000, tas=
k ffff88007c2f23a0)
[69186.618433] Stack:
[69186.618436]  ffffffffa027226a ffffffff805e1e00 ffff880079879db0 ffff8800=
7ad33800
[69186.618444]  ffff88007b400360 ffffffffa0285705 fffffff000011212 00000000=
00000000
[69186.618453]  b6e3880000000000 ffffe200002bebf8 ffff88000c8c9000 ffff8800=
7a3da4a0
[69186.618462] Call Trace:
[69186.618468]  [<ffffffffa027226a>] ? crypto_cbc_encrypt+0xfa/0x15a [cbc]
[69186.618481]  [<ffffffffa0285705>] ? aes_encrypt+0x0/0x7 [aes_x86_64]
[69186.618494]  [<ffffffffa020667d>] ? async_encrypt+0x35/0x3a [crypto_blkc=
ipher]
[69186.618509]  [<ffffffffa0269a6f>] ? crypt_convert+0x1d2/0x253 [dm_crypt]
[69186.618522]  [<ffffffffa0269ed6>] ? kcryptd_crypt+0x3e6/0x407 [dm_crypt]
[69186.618533]  [<ffffffffa0269af0>] ? kcryptd_crypt+0x0/0x407 [dm_crypt]
[69186.618543]  [<ffffffff80241704>] ? run_workqueue+0x87/0x122
[69186.618552]  [<ffffffff80241877>] ? worker_thread+0xd8/0xe7
[69186.618560]  [<ffffffff80244e00>] ? autoremove_wake_function+0x0/0x2e
[69186.618569]  [<ffffffff8024179f>] ? worker_thread+0x0/0xe7
[69186.618575]  [<ffffffff8024179f>] ? worker_thread+0x0/0xe7
[69186.618582]  [<ffffffff80244ae7>] ? kthread+0x47/0x73
[69186.618589]  [<ffffffff8020c4e9>] ? child_rip+0xa/0x21
[69186.618597]  [<ffffffff80244aa0>] ? kthread+0x0/0x73
[69186.618604]  [<ffffffff8020c4df>] ? child_rip+0x0/0x21
[69186.618611] Code: 08 48 89 51 08 48 89 0a 48 b9 00 01 10 00 00 00 ad de =
48 ba 00 02 20 00 00 00 ad de 48 89 08 48 89 50 08 c3 41 89 d0 31 c9 eb 0e =
<8b> 04 0e 41 83 e8 04 31 04 0f 48 83 c1 04 41 83 f8 03 77 ec 41=20
[69186.618678] RIP  [<ffffffff8031f246>] crypto_xor+0x7/0x48
[69186.618686]  RSP <ffff880079879cc8>
[69186.618723] ---[ end trace 728c95da3be59caf ]---
[69186.618730] note: kcryptd[2848] exited with preempt_count 2


Linux ikn 2.6.28-rc6-next-20081125-denkbrett #15 SMP PREEMPT Tue Nov 25 13:=
41:17 CET 2008 x86_64 GNU/Linux

 07:12:23 up 1 day, 22:28,  1 user,  load average: 2.21, 0.82, 0.58
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  10312   616 ?        Ss   Nov26   0:00 init [2] =
=20
root         2  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S<   Nov26   0:00 [migration=
/0]
root         4  0.0  0.0      0     0 ?        S<   Nov26   0:00 [ksoftirqd=
/0]
root         7  0.0  0.0      0     0 ?        S<   Nov26   0:01 [events/0]
root         9  0.0  0.0      0     0 ?        S<   Nov26   0:00 [khelper]
root        13  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kstop/0]
root       109  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kblockd/0]
root       111  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kacpid]
root       112  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kacpi_not=
ify]
root       193  0.0  0.0      0     0 ?        S<   Nov26   0:00 [ata/0]
root       195  0.0  0.0      0     0 ?        S<   Nov26   0:00 [ata_aux]
root       197  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kseriod]
root       226  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kondemand=
/0]
root       261  0.0  0.0      0     0 ?        S    Nov26   0:00 [pdflush]
root       262  0.0  0.0      0     0 ?        S    Nov26   0:01 [pdflush]
root       263  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kswapd0]
root       310  0.0  0.0      0     0 ?        S<   Nov26   0:00 [aio/0]
root       322  0.0  0.0      0     0 ?        S<   Nov26   0:00 [jfsIO]
root       323  0.0  0.0      0     0 ?        S<   Nov26   0:02 [jfsCommit]
root       324  0.0  0.0      0     0 ?        S<   Nov26   0:02 [jfsCommit]
root       325  0.0  0.0      0     0 ?        S<   Nov26   0:00 [jfsSync]
nico       392  0.0  0.0  12280  1536 ?        S+   07:00   0:00 /bin/sh /h=
ome/user/nico/bin/ressh.sh tee.schottelius.org
nico       393  0.0  0.1  46916  3008 ?        S+   07:00   0:00 ssh tee.sc=
hottelius.org
root       768  0.0  0.0  21448  1208 ?        S    07:09   0:00 /usr/sbin/=
pppd 57600 modem crtscts defaultroute usehostname -detach user testprofil n=
oipdefault call wvdial usepeerdns idle 0 logfd 8
postfix    834  0.0  0.1  38944  2252 ?        S    07:09   0:00 qmgr -l -t=
 fifo -u
postfix    835  0.0  0.1  38896  2212 ?        S    07:09   0:00 pickup -l =
-t fifo -u -c
nico       948  0.0  0.0  19380   888 ?        D+   07:11   0:00 ls --color=
=3Dauto
nico       963  0.2  0.1  32708  3392 ?        S+   07:12   0:00 vi /tmp/ca=
lltrace-2.6.28-next-1125
root       984  0.0  0.0      0     0 ?        S<   Nov26   0:00 [scsi_eh_0]
root       986  0.0  0.0      0     0 ?        S<   Nov26   0:00 [scsi_eh_1]
root       988  0.0  0.0      0     0 ?        S<   Nov26   0:00 [scsi_eh_2]
root       990  0.0  0.0      0     0 ?        S<   Nov26   0:00 [scsi_eh_3]
nico       993  0.0  0.0  17656  1100 ?        R+   07:12   0:00 ps auxwww
root      1003  0.0  0.0      0     0 ?        S<   Nov26   0:00 [khpsbpkt]
root      1025  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kpsmoused]
root      1028  0.0  0.0      0     0 ?        S<   Nov26   0:00 [hid_compa=
t]
root      1140  0.0  0.0  18280   588 ?        S<s  Nov26   0:00 udevd --da=
emon
root      1966  0.0  0.0      0     0 ?        S<   Nov26   0:00 [ktpacpid]
root      2013  0.0  0.0      0     0 ?        S<   Nov26   0:00 [ksuspend_=
usbd]
root      2022  0.0  0.0      0     0 ?        S<   Nov26   0:00 [khubd]
root      2423  0.0  0.0      0     0 ?        S<   Nov26   0:00 [btaddconn]
root      2425  0.0  0.0      0     0 ?        S<   Nov26   0:00 [btdelconn]
root      2591  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kstriped]
root      2845  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kdmflush]
root      2847  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kcryptd_i=
o]
root      2891  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kdmflush]
root      2895  0.0  0.0      0     0 ?        S<   Nov26   0:00 [kcryptd_i=
o]
root      2896  0.0  0.0      0     0 ?        S<   Nov26   0:05 [kcryptd]
daemon    3107  0.0  0.0   8020   472 ?        Ss   Nov26   0:00 /sbin/port=
map
statd     3119  0.0  0.0  10136   708 ?        Ss   Nov26   0:00 /sbin/rpc.=
statd
root      3339  0.0  0.0 121972  1316 ?        Sl   Nov26   0:00 /usr/sbin/=
rsyslogd -c3
root      3350  0.0  0.1   6828  3520 ?        Ss   Nov26   0:00 /usr/sbin/=
acpid -c /etc/acpi/events
104       3360  0.0  0.0  21212  1016 ?        Ss   Nov26   0:00 /usr/bin/d=
bus-daemon --system
root      3487  0.0  0.0  16240   676 ?        Ss   Nov26   0:09 /usr/sbin/=
automount --pid-file=3D/var/run/autofs/_auto.pid --timeout=3D5 --ghost /aut=
o file /etc/auto.kamera
root      3507  0.0  0.2  14856  4624 ?        S<L  Nov26   0:06 /usr/bin/a=
top -a -w /var/log/atop.log 600
root      3519  0.0  0.0  71580  1276 ?        Ss   Nov26   0:00 /usr/sbin/=
cupsd
root      3560  0.0  0.0   3644   124 ?        S    Nov26   0:00 /usr/sbin/=
thinkpad-keys --no-brightness
root      3569  0.0  0.0  61352   940 ?        Ss   Nov26   0:05 /usr/sbin/=
kerneloops
root      3592  0.0  0.0  10128   516 ?        Ss   Nov26   0:00 /usr/sbin/=
inetd
root      3663  0.0  0.1  36840  2036 ?        Ss   Nov26   0:00 /usr/lib/p=
ostfix/master
uml-net   3683  0.0  0.0   3792   440 ?        S    Nov26   0:00 /usr/bin/u=
ml_switch -unix /var/run/uml-utilities/uml_switch.ctl
avahi     3697  0.0  0.0  28736  1408 ?        Ss   Nov26   0:01 avahi-daem=
on: running [ikn.local]
avahi     3699  0.0  0.0  28504   256 ?        Ss   Nov26   0:00 avahi-daem=
on: chroot helper
root      3707  0.0  0.0   6308  1044 ?        Ss   Nov26   0:03 /usr/sbin/=
dhcdbd --system
107       3718  0.0  0.1  29600  3728 ?        Ss   Nov26   0:05 /usr/sbin/=
hald
root      3719  0.0  0.0  17768  1108 ?        S    Nov26   0:00 hald-runner
root      3738  0.0  0.0  19880  1076 ?        S    Nov26   0:04 hald-addon=
-input: Listening on /dev/input/event0 /dev/input/event1 /dev/input/event2 =
/dev/input/event3 /dev/input/event5 /dev/input/event6 /dev/input/event8
root      3742  0.0  0.0  19892   924 ?        S    Nov26   0:00 /usr/lib/h=
al/hald-addon-cpufreq
107       3743  0.0  0.0  16604   912 ?        S    Nov26   0:00 hald-addon=
-acpi: listening on acpid socket /var/run/acpid.socket
root      3756  0.0  0.0  17696  1300 ?        Ss   Nov26   0:00 /usr/sbin/=
hcid -x -s
root      3765  0.0  0.0      0     0 ?        S<   Nov26   0:00 [krfcommd]
root      3776  0.0  0.0  12364   272 ?        Ss   Nov26   0:00 /sbin/mdad=
m --monitor --pid-file /var/run/mdadm/monitor.pid --daemonise --scan --sysl=
og
root      3784  0.0  0.1 121316  2276 ?        Ssl  Nov26   0:02 /usr/sbin/=
NetworkManager --pid-file /var/run/NetworkManager/NetworkManager.pid
root      3794  0.0  0.0  24104  1304 ?        Ss   Nov26   0:00 /usr/sbin/=
NetworkManagerDispatcher --pid-file /var/run/NetworkManager/NetworkManagerD=
ispatcher.pid
root      3804  0.0  0.0  26556   876 ?        Ss   Nov26   0:00 /usr/bin/s=
ystem-tools-backends
daemon    3828  0.0  0.0  16356   308 ?        Ss   Nov26   0:00 /usr/sbin/=
atd
root      3848  0.0  0.0  21472   896 ?        Ss   Nov26   0:00 /usr/sbin/=
cron
root      3880  0.0  0.0 120200   964 ?        Ss   Nov26   0:02 /usr/sbin/=
apache2 -k start
www-data  3887  0.0  0.0 119932   500 ?        S    Nov26   0:00 /usr/sbin/=
apache2 -k start
www-data  3889  0.0  0.1 343940  2352 ?        Sl   Nov26   0:00 /usr/sbin/=
apache2 -k start
www-data  3890  0.0  0.1 343796  2144 ?        Sl   Nov26   0:00 /usr/sbin/=
apache2 -k start
root      4000  0.0  0.0  45632   864 tty1     Ss   Nov26   0:00 /bin/login=
 --    =20
root      4003  0.0  0.0   3796   472 tty2     Ss+  Nov26   0:00 /sbin/gett=
y 38400 tty2
root      4004  0.0  0.0   3796   472 tty3     Ss+  Nov26   0:00 /sbin/gett=
y 38400 tty3
root      4006  0.0  0.0   3796   472 tty4     Ss+  Nov26   0:00 /sbin/gett=
y 38400 tty4
root      4007  0.0  0.0   3796   472 tty5     Ss+  Nov26   0:00 /sbin/gett=
y 38400 tty5
root      4009  0.0  0.0   3796   472 tty6     Ss+  Nov26   0:00 /sbin/gett=
y 38400 tty6
root      4010  0.0  0.0  17276  1116 ?        Ss   Nov26   0:00 /bin/sh /u=
sr/bin/svscanboot
root      4023  0.0  0.0   3824   400 ?        S    Nov26   0:00 svscan /et=
c/service
root      4024  0.0  0.0   3640   272 ?        S    Nov26   0:00 readprocti=
tle service errors: .......................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E....................................................
root      4025  0.0  0.0   3652   344 ?        S    Nov26   0:00 supervise =
dnscache
root      4026  0.0  0.0   3652   344 ?        S    Nov26   0:00 supervise =
log
djblog    4027  0.0  0.0   3796   420 ?        S    Nov26   0:00 multilog t=
 ./main
nico      4046  0.0  0.0  38472  1564 tty1     S    Nov26   0:00 -zsh
nico      4190  0.0  0.0  12308  1108 tty1     S+   Nov26   0:00 /bin/bash =
/usr/bin/startx
nico      4207  0.0  0.0  17308   728 tty1     S+   Nov26   0:00 xinit /hom=
e/user/nico/.xinitrc -- /etc/X11/xinit/xserverrc :0 -auth /tmp/serverauth.o=
mPcJCstPE
root      4208  0.5  3.0 142252 60752 tty7     Ss+  Nov26  14:43 /usr/bin/X=
11/X -nolisten tcp
nico      4237  0.0  0.5 167508 11564 tty1     S    Nov26   0:43 awesome
nico      4251  0.0  0.0  26204   788 ?        S    Nov26   0:04 xbindkeys
nico      4254  0.0  0.1  42900  3088 tty1     S    Nov26   0:00 /usr/lib/l=
ibgconf2-4/gconfd-2 5
nico      4259  0.0  0.0  25732   468 tty1     S    Nov26   0:00 dbus-launc=
h --autolaunch acba744a0868205ffce3d55548e618c3 --binary-syntax --close-std=
err
nico      4260  0.0  0.0  21084   848 ?        Ss   Nov26   0:00 /usr/bin/d=
bus-daemon --fork --print-pid 5 --print-address 7 --session
nico      4261  0.0  0.2 139212  5504 ?        Ss   Nov26   0:39 gnome-scre=
ensaver
nico      4267  0.0  1.6 195752 33116 tty1     S    Nov26   0:28 urxvtd -q =
-f
nico      4281  0.0  0.1  41400  3192 ?        Ss+  Nov26   0:00 zsh
root      4501  0.0  0.0  48864   548 ?        Ss   Nov26   0:00 /usr/sbin/=
sshd
nico      4973  0.0  0.0  11192   608 ?        S    Nov26   0:00 make
nico      4988  0.0  7.7 384676 155504 ?       Sl   Nov26   0:32 evince git=
=2Epdf
nico      5229  0.0  0.1  41052  3488 ?        Ss   Nov26   0:00 -zsh
nico      5231  0.0  0.1  41020  2852 ?        Ss   Nov26   0:00 -zsh
nico      7119  0.0  0.1  40748  3248 ?        Ss+  Nov26   0:00 zsh
nico      7740  0.0  0.1  38456  2812 ?        Ss   Nov26   0:00 zsh
nico      8031  0.9 14.8 760572 298108 ?       Dsl  Nov26  26:03 /usr/lib/i=
ceweasel/firefox-bin -a iceweasel
root      8674  0.0  0.0      0     0 ?        S<   Nov27   0:00 [rpciod/0]
root      8679  0.0  0.0      0     0 ?        S<   Nov27   0:00 [nfsiod]
nico     15742  0.0  0.1  38456  2704 ?        Ss   Nov27   0:00 zsh
nico     15920  0.0  0.8  72476 17156 ?        D+   Nov27   0:03 mutt
nico     15946  0.0  0.1  38456  2812 ?        Ss   Nov27   0:00 zsh
compiler 22336  0.0  0.0  34088  1136 ?        S    Nov27   0:00 su - compi=
ler
compiler 22339  0.0  0.1  40896  3240 ?        S+   Nov27   0:00 -su
nico     23899  0.0  0.1  38456  2696 ?        Ss   Nov26   0:00 zsh
root     24040  0.0  0.1  37984  2484 ?        S    Nov26   0:02 -zsh
nico     24076  0.0  0.1  40868  3396 ?        Ss+  Nov26   0:00 zsh
nico     24439  0.0  0.1  38456  2692 pts/13   Ss   Nov26   0:00 zsh
root     24581  0.0  0.1  37984  2472 pts/13   S+   Nov26   0:00 -zsh
nico     24704  0.0  0.2  42248  4776 pts/18   Ss+  Nov27   0:02 zsh
nico     24810  0.0  0.1  38456  2692 ?        Ss   Nov26   0:00 zsh
root     25008  0.0  0.1  37984  2336 ?        S    Nov26   0:00 -zsh
dnscache 25687  0.0  0.1   5416  2004 ?        S    Nov26   0:00 /usr/bin/d=
nscache
root     28464  0.0  0.0      0     0 ?        S<   Nov26   0:03 [iwlagn/0]
root     28467  0.0  0.0      0     0 ?        S<   Nov26   0:00 [iwlagn]
nico     30292  0.0  0.1  32840  3688 ?        S+   Nov27   0:23 vi erste-s=
chritte.tex
nico     30396  0.0  0.0  42788  1416 ?        Ss   Nov27   0:00 ssh -T -f =
-C -N -L4242:imaps.schottelius.org:993 nico@77.109.138.222
nico     30398  0.0  0.1  43380  2056 ?        Ss   Nov27   0:00 ssh -T -f =
-C -N -L2323:mx3.schottelius.org:993 nico@77.109.138.222
nico     30400  0.0  0.0  42788  1056 ?        Ss   Nov27   0:00 ssh -T -f =
-C -N -R4242:localhost:22 nico@77.109.138.222
nico     30405  0.0  0.0      0     0 tty1     Z    Nov27   0:00 [awesome] =
<defunct>
nico     30408  0.0  0.2  41360  4056 pts/3    Ss+  Nov27   0:00 zsh
root     32431  0.0  0.0      0     0 ?        S<   06:56   0:00 [migration=
/1]
root     32432  0.0  0.0      0     0 ?        S<   06:56   0:00 [ksoftirqd=
/1]
root     32433  0.0  0.0      0     0 ?        S<   06:56   0:00 [rpciod/1]
root     32434  0.0  0.0      0     0 ?        S<   06:56   0:00 [iwlagn/1]
root     32435  0.0  0.0      0     0 ?        S<   06:56   0:00 [aio/1]
root     32436  0.0  0.0      0     0 ?        S<   06:56   0:00 [kondemand=
/1]
root     32437  0.0  0.0      0     0 ?        S<   06:56   0:00 [ata/1]
root     32438  0.0  0.0      0     0 ?        S<   06:56   0:00 [kblockd/1]
root     32439  0.0  0.0      0     0 ?        S<   06:56   0:00 [kstop/1]
root     32440  0.0  0.0      0     0 ?        S<   06:56   0:00 [events/1]
root     32619  0.0  0.0      0     0 ?        S<   06:58   0:00 [scsi_eh_5]
root     32620  0.0  0.0      0     0 ?        S<   06:58   0:00 [usb-stora=
ge]
root     32702  0.0  0.0  19880  1148 ?        S    06:58   0:00 hald-addon=
-storage: polling /dev/sdb (every 2 sec)
root     32713  0.0  0.1  39944  3520 ?        S+   06:58   0:00 wvdial -C =
/home/user/nico/privat/computer/net/umts/wvdial-swisscom-corporate.conf

--NzB8fVQJ5HfG6fxh--

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkvkNMACgkQuL75KpiFGIySUQCdEy+B0THnt7uYmx1WhOtOQTFp
NogAoOphTM4sz8cBt3T3DQA7arDyjyyD
=I+ZD
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
