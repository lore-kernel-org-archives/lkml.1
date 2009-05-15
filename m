Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbZEOM6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbZEOM6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbZEOM54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:57:56 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41933 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbZEOM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:57:51 -0400
Date: Fri, 15 May 2009 12:26:21 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: iwlagn broken in next-20090514 and next-20090514
Message-ID: <20090515102621.GA5735@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <20090515153733.4384db9f.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc5-next-20090514-05233-g7451dbb x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Stephen Rothwell [Fri, May 15, 2009 at 03:37:33PM +1000]:
> Changes since 20090514:

Kernel is not authenticating it against the AP anymore with
messages like:

[16907.701634] wlan0: associate with AP 00:03:52:4e:f3:d1
[16907.703669] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[16907.703672] wlan0: associated
[16907.729958] wlan0: disassociating by local choice (reason=3D3)
[16907.852112] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[16908.052086] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[16908.055331] wlan0 direct probe responded
[16908.055335] wlan0: authenticate with AP 00:03:52:1b:f8:31
[16908.256065] wlan0: authenticate with AP 00:03:52:1b:f8:31
[16908.453689] wlan0: authenticate with AP 00:03:52:1b:f8:31
[16908.656037] wlan0: authentication with AP 00:03:52:1b:f8:31 timed out

Also wpa_supplicant is not happy:

+ wpa_supplicant -B -Dwext -iwlan0 -c /home/user/nico/ethz/wlan/wpa_supplic=
ant.conf
ioctl[SIOCSIWENCODEEXT]: No such file or directory
ioctl[SIOCSIWENCODEEXT]: No such file or directory
ioctl[SIOCSIWENCODEEXT]: No such file or directory
ioctl[SIOCSIWENCODEEXT]: No such file or directory


Config, dmesg attached.

Last working kernel version: vmlinuz-2.6.30-rc4-next-20090505-04518-g1f9c23a

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="dmesg.2.6.30-rc5-next-20090515-05297-g9bbe396"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 2.6.30-rc5-next-20090515-05297-g9bbe396 (compi=
ler@ikn) (gcc version 4.3.3 (Debian 4.3.3-3) ) #45 SMP PREEMPT Fri May 15 1=
1:47:04 CEST 2009
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-rc5-next-200=
90515-05297-g9bbe396 root=3D/dev/sda1 ro quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x13c000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbda00 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] ACPI: RSDP 00000000000f73a0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd97bd45 0009C (v01 LENOVO TP-6D    00001=
050  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd97bf00 000F4 (v03 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd97c2f4 0D910 (v01 LENOVO TP-6D    00001=
050 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd97c0b4 00240 (v01 LENOVO TP-6D    00001=
050 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd989c04 00052 (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd989c56 00078 (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd989cce 0003C (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd989d0a 00038 (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd989dc2 00176 (v01 LENOVO TP-6D    00001=
050  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd989f38 00028 (v01 LENOVO TP-6D    00001=
050  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd989f60 000A0 (v16 LENOVO TP-6D    00001=
050 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d203 0055F (v01 LENOVO TP-6D    00001=
050 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000=
000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               =01 000=
00001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003=
000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003=
000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 013c000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000073011c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 000073011c]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #4 [0000731000 - 000073114c]              BRK =3D=3D> [000=
0731000 - 000073114c]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f73e0] f73e0
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88002860000=
0-ffff88002bdfffff] on node 0
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
[    0.000000]   DMA zone: 1431 pages reserved
[    0.000000]   DMA zone: 2511 pages, LIFO batch:0
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
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages at ffff880028023000, static data 6=
8704 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1002320
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-rc5-n=
ext-20090515-05297-g9bbe396 root=3D/dev/sda1 ro quiet
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.979 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing 64MB software IO TLB between ffff880020000000 - ffff=
880024000000
[    0.004000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.004000] Memory: 3949564k/5177344k available (2892k kernel code, 1091=
556k absent, 135316k reserved, 1407k data, 364k init)
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4521.95 BogoMIPS (lpj=3D9043916)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] [ds] sizes: address: 64 bit, bts/pebs record: 24/144 bytes
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20090422
[    0.048090] Setting APIC routing to flat
[    0.048479] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.089418] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.092001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4522.03 Bog=
oMIPS (lpj=3D9044069)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.177284] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.177301] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.180036] Brought up 2 CPUs
[    0.180042] Total of 2 processors activated (9043.99 BogoMIPS).
[    0.180162] devtmpfs: initialized
[    0.180180] net_namespace: 1752 bytes
[    0.180280] regulator: core version 0.5
[    0.180280] NET: Registered protocol family 16
[    0.180280] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.180280] ACPI: bus type pci registered
[    0.180280] PCI: Using configuration type 1 for base access
[    0.188074] bio: create slab <bio-0> at 0
[    0.193668] ACPI: EC: EC description table is found, configuring boot EC
[    0.213370] ACPI: BIOS _OSI(Linux) query ignored
[    0.212023] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.240873] ACPI: Interpreter enabled
[    0.240882] ACPI: (supports S0 S3 S5)
[    0.240937] ACPI: Using IOAPIC for interrupt routing
[    0.284989] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.284989] ACPI: EC: driver started in interrupt mode
[    0.284989] ACPI: Power Resource [PUBS] (on)
[    0.292351] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.293353] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.293448] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.293448] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.293448] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.293448] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.293448] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.293448] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.293448] pci 0000:00:03.0: PME# disabled
[    0.293448] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.293448] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.293448] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.293448] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.293448] pci 0000:00:19.0: PME# disabled
[    0.293448] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.293448] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.293448] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.293448] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.293448] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.293448] pci 0000:00:1a.7: PME# disabled
[    0.293448] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.293483] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.293492] pci 0000:00:1b.0: PME# disabled
[    0.293606] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.293615] pci 0000:00:1c.0: PME# disabled
[    0.293732] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.293741] pci 0000:00:1c.1: PME# disabled
[    0.293861] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.293870] pci 0000:00:1c.3: PME# disabled
[    0.293980] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.294116] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.294251] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.294391] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.294491] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.294500] pci 0000:00:1d.7: PME# disabled
[    0.296344] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.296357] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.296370] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.296382] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.296395] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.296408] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.296473] pci 0000:00:1f.2: PME# supported from D3hot
[    0.296481] pci 0000:00:1f.2: PME# disabled
[    0.296542] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.296571] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.296903] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.297081] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.297114] pci 0000:03:00.0: PME# disabled
[    0.297238] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.297337] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.297346] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.297360] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.297460] pci 0000:00:1e.0: transparent bridge
[    0.297513] pci_bus 0000:00: on NUMA node 0
[    0.297533] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.298007] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.298225] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.298446] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.316452] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316452] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316805] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.317410] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.318015] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.318619] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.319226] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.319830] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.320210] SCSI subsystem initialized
[    0.320210] libata version 3.00 loaded.
[    0.320210] PCI: Using ACPI for IRQ routing
[    0.336030] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.336044] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.341968] Failed to register trace events module notifier
[    0.361348] pnp: PnP ACPI init
[    0.361368] ACPI: bus type pnp registered
[    0.432042] pnp: PnP ACPI: found 10 devices
[    0.432048] ACPI: ACPI bus type pnp unregistered
[    0.432072] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.432080] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.432087] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.432095] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.432102] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.432110] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.432117] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.432125] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.432132] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.432139] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.432147] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.432155] system 00:00: iomem range 0x100000-0xbfffffff could not be r=
eserved
[    0.432163] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.432171] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.432189] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.432197] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.432204] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.432212] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.432219] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.432227] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.432234] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.432242] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.432251] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.432259] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.432267] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.432275] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.432283] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.438093] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.438099] pci 0000:00:1c.0:   IO window: disabled
[    0.438109] pci 0000:00:1c.0:   MEM window: disabled
[    0.438116] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.438125] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.438130] pci 0000:00:1c.1:   IO window: disabled
[    0.438141] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.438150] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.438158] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.438166] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.438176] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.438186] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.438199] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.438204] pci 0000:00:1e.0:   IO window: disabled
[    0.438213] pci 0000:00:1e.0:   MEM window: disabled
[    0.438221] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.438241]   alloc irq_desc for 20 on node -1
[    0.438246]   alloc kstat_irqs on node -1
[    0.438257] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.438267] pci 0000:00:1c.0: setting latency timer to 64
[    0.438281]   alloc irq_desc for 21 on node -1
[    0.438285]   alloc kstat_irqs on node -1
[    0.438294] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.438303] pci 0000:00:1c.1: setting latency timer to 64
[    0.438317]   alloc irq_desc for 23 on node -1
[    0.438321]   alloc kstat_irqs on node -1
[    0.438329] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.438338] pci 0000:00:1c.3: setting latency timer to 64
[    0.438351] pci 0000:00:1e.0: setting latency timer to 64
[    0.438361] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.438368] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.438375] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.438381] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.438387] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.438393] pci_bus 0000:05: resource 2 pref mem [0xf2900000-0xf29fffff]
[    0.438400] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.438406] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.438493] NET: Registered protocol family 2
[    0.438693] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.440706] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.443664] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.444496] TCP: Hash tables configured (established 262144 bind 65536)
[    0.444503] TCP reno registered
[    0.444742] NET: Registered protocol family 1
[    0.445144] Simple Boot Flag at 0x35 set to 0x1
[    0.447553] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
[    0.454028] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.469295] VFS: Disk quotas dquot_6.5.2
[    0.469515] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.470883] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.475946] msgmni has been set to 7715
[    0.476726] alg: No test for stdrng (krng)
[    0.476748] io scheduler noop registered
[    0.476754] io scheduler anticipatory registered (default)
[    0.476759] io scheduler deadline registered
[    0.477046] io scheduler cfq registered
[    0.477073] pci 0000:00:02.0: Boot video device
[    0.477636]   alloc irq_desc for 24 on node -1
[    0.477641]   alloc kstat_irqs on node -1
[    0.477661] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.477688] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.478052]   alloc irq_desc for 25 on node -1
[    0.478057]   alloc kstat_irqs on node -1
[    0.478072] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.478097] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.478452]   alloc irq_desc for 26 on node -1
[    0.478456]   alloc kstat_irqs on node -1
[    0.478471] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.478496] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.581342] Switched to high resolution mode on CPU 1
[    0.584007] Switched to high resolution mode on CPU 0
[    0.602133] Linux agpgart interface v0.103
[    3.616024] floppy0: no floppy controllers found
[    3.619816] brd: module loaded
[    3.619820] Uniform Multi-Platform E-IDE driver
[    3.620045] ide-gd driver 1.18
[    3.620367] Driver 'sd' needs updating - please use bus_type methods
[    3.620490] ahci 0000:00:1f.2: version 3.0
[    3.620514]   alloc irq_desc for 16 on node -1
[    3.620519]   alloc kstat_irqs on node -1
[    3.620532] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.620593]   alloc irq_desc for 27 on node -1
[    3.620598]   alloc kstat_irqs on node -1
[    3.620613] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    3.620739] ahci: SSS flag set, parallel bus scan disabled
[    3.620784] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.620793] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.620804] ahci 0000:00:1f.2: setting latency timer to 64
[    3.621151] scsi0 : ahci
[    3.621654] scsi1 : ahci
[    3.621821] scsi2 : ahci
[    3.621994] scsi3 : ahci
[    3.623591] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 27
[    3.623599] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 27
[    3.623604] ata3: DUMMY
[    3.623608] ata4: DUMMY
[    3.624167] Fusion MPT base driver 3.04.07
[    3.624171] Copyright (c) 1999-2008 LSI Corporation
[    3.624186] Fusion MPT SPI Host driver 3.04.07
[    3.624510] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    3.636888] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.636902] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.637332] mice: PS/2 mouse device common for all mice
[    3.637649] cpuidle: using governor ladder
[    3.637654] cpuidle: using governor menu
[    3.638481] TCP cubic registered
[    3.638488] NET: Registered protocol family 17
[    3.638922] registered taskstats version 1
[    3.642869] input: AT Translated Set 2 keyboard as /class/input/input0
[    3.940030] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.972118] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.972127] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.972208] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.972216] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.972962] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    3.972969] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.983205] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.983213] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.983294] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.983301] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.984097] ata1.00: configured for UDMA/100
[    4.011729] ata1.00: configured for UDMA/100
[    4.011735] ata1: EH complete
[    4.011913] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    4.012443] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.012478] sd 0:0:0:0: [sda] Write Protect is off
[    4.012485] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.012536] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.012737]  sda: sda1 sda2 sda3
[    4.061496] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.186047] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    4.203940] input: TPPS/2 IBM TrackPoint as /class/input/input1
[    4.332025] ata2: SATA link down (SStatus 0 SControl 300)
[    4.430126] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    4.445095] devtmpfs: mounted
[    4.445154] Freeing unused kernel memory: 364k freed
[    8.681410] input: Power Button as /class/input/input2
[    8.681579] ACPI: Power Button [PWRF]
[    8.681733] input: Lid Switch as /class/input/input3
[    8.683237] ACPI: Lid Switch [LID]
[    8.683378] input: Sleep Button as /class/input/input4
[    8.683489] ACPI: Sleep Button [SLPB]
[    8.789875] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050624)
[    8.791600] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050624)
[    8.808762] Monitor-Mwait will be used to enter C-1 state
[    8.808770] Monitor-Mwait will be used to enter C-2 state
[    8.808776] Monitor-Mwait will be used to enter C-3 state
[    8.808783] Marking TSC unstable due to TSC halts in idle
[    8.808951] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    8.809033] processor ACPI_CPU:00: registered as cooling_device0
[    8.809047] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.810484] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003=
000 INTL 20050624)
[    8.812066] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003=
000 INTL 20050624)
[    8.820395] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    8.820459] processor ACPI_CPU:01: registered as cooling_device1
[    8.820469] ACPI: Processor [CPU1] (supports 8 throttling states)
[    8.895815] thermal LNXTHERM:01: registered as thermal_zone0
[    8.895840] ACPI: Thermal Zone [THM0] (47 C)
[    8.899822] thermal LNXTHERM:02: registered as thermal_zone1
[    8.899843] ACPI: Thermal Zone [THM1] (43 C)
[    8.919966] ACPI: AC Adapter [AC] (off-line)
[    8.971217] Non-volatile memory driver v1.3
[    8.980872] agpgart-intel 0000:00:00.0: Intel Mobile Intel=AE GM45 Expre=
ss Chipset
[    8.983260] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    8.991555] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.996060] ACPI: Battery Slot [BAT0] (battery present)
[    9.001105] Clocksource tsc unstable (delta =3D -74788374 ns)
[    9.088393] cfg80211: Calling CRDA to update world regulatory domain
[    9.165118] usbcore: registered new interface driver usbfs
[    9.165187] usbcore: registered new interface driver hub
[    9.165843] usbcore: registered new device driver usb
[    9.201046] ACPI: WMI: Mapper loaded
[    9.232476] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    9.232483] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    9.232556] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    9.232575] e1000e 0000:00:19.0: setting latency timer to 64
[    9.232757]   alloc irq_desc for 28 on node -1
[    9.232762]   alloc kstat_irqs on node -1
[    9.232782] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    9.321531] rtc_cmos 00:07: RTC can wake from S4
[    9.321746] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    9.321792] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    9.326894] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[    9.326901] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    9.326938] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    9.335764] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.336415] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    9.336436] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    9.336469] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    9.336477] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    9.336541] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    9.340497] ehci_hcd 0000:00:1a.7: debug port 1
[    9.340510] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    9.340544] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    9.351816] uhci_hcd: USB Universal Host Controller Interface driver
[    9.357045] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.357356] usb usb1: configuration #1 chosen from 1 choice
[    9.357436] hub 1-0:1.0: USB hub found
[    9.357455] hub 1-0:1.0: 6 ports detected
[    9.358485] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    9.358504] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    9.358522] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    9.358529] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    9.358554] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 2
[    9.358620] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    9.358896] usb usb2: configuration #1 chosen from 1 choice
[    9.358972] hub 2-0:1.0: USB hub found
[    9.358988] hub 2-0:1.0: 2 ports detected
[    9.360127] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    9.360142]   alloc irq_desc for 19 on node -1
[    9.360147]   alloc kstat_irqs on node -1
[    9.360159] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    9.360198] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    9.360205] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.360228] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 3
[    9.364179] ehci_hcd 0000:00:1d.7: debug port 1
[    9.364191] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    9.364221] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    9.377066] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.377381] usb usb3: configuration #1 chosen from 1 choice
[    9.377463] hub 3-0:1.0: USB hub found
[    9.377483] hub 3-0:1.0: 6 ports detected
[    9.377805] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    9.377824] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    9.377832] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    9.377854] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[    9.377923] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    9.378182] usb usb4: configuration #1 chosen from 1 choice
[    9.378259] hub 4-0:1.0: USB hub found
[    9.378276] hub 4-0:1.0: 2 ports detected
[    9.379379] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    9.379392]   alloc irq_desc for 22 on node -1
[    9.379397]   alloc kstat_irqs on node -1
[    9.379409] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[    9.379424] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    9.379431] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    9.379455] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[    9.379514] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    9.379782] usb usb5: configuration #1 chosen from 1 choice
[    9.379859] hub 5-0:1.0: USB hub found
[    9.379874] hub 5-0:1.0: 2 ports detected
[    9.380783] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    9.380796] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    9.380811] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    9.380818] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    9.380840] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[    9.380898] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    9.381207] usb usb6: configuration #1 chosen from 1 choice
[    9.381289] hub 6-0:1.0: USB hub found
[    9.381305] hub 6-0:1.0: 2 ports detected
[    9.381571]   alloc irq_desc for 17 on node -1
[    9.381576]   alloc kstat_irqs on node -1
[    9.381587] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[    9.381602] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    9.381609] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    9.381628] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[    9.381683] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    9.381926] usb usb7: configuration #1 chosen from 1 choice
[    9.382005] hub 7-0:1.0: USB hub found
[    9.382019] hub 7-0:1.0: 2 ports detected
[    9.382296]   alloc irq_desc for 18 on node -1
[    9.382301]   alloc kstat_irqs on node -1
[    9.382311] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    9.382325] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    9.382332] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    9.382352] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[    9.382407] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    9.382657] usb usb8: configuration #1 chosen from 1 choice
[    9.382731] hub 8-0:1.0: USB hub found
[    9.382746] hub 8-0:1.0: 2 ports detected
[    9.743979] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    9.781106] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 3
[    9.815904] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[    9.815910] thinkpad_acpi: http://ibm-acpi.sf.net/
[    9.815914] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[    9.815920] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[    9.817154] thinkpad_acpi: radio switch found; radios are enabled
[    9.817468] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    9.817474] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    9.833703] Registered led device: tpacpi::thinklight
[    9.833813] Registered led device: tpacpi::power
[    9.833863] Registered led device: tpacpi::standby
[    9.836579] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[    9.837023] input: ThinkPad Extra Buttons as /class/input/input5
[    9.917994] usb 1-6: configuration #1 chosen from 1 choice
[    9.927125] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27k
[    9.927132] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    9.930073] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    9.930116] iwlagn 0000:03:00.0: setting latency timer to 64
[    9.930198] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[    9.949576] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[    9.949667]   alloc irq_desc for 29 on node -1
[    9.949672]   alloc kstat_irqs on node -1
[    9.949699] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[   10.028132] usb 3-6: new high speed USB device using ehci_hcd and addres=
s 2
[   10.093326] Linux video capture interface: v2.00
[   10.171668] uvcvideo: Found UVC 1.00 device <unnamed> (17ef:480c)
[   10.173191] input: UVC Camera (17ef:480c) as /class/input/input6
[   10.173351] usbcore: registered new interface driver uvcvideo
[   10.173357] USB Video Class driver (v0.1.0)
[   10.175726] usb 3-6: configuration #1 chosen from 1 choice
[   10.178117] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   10.334590] usbcore: registered new interface driver libusual
[   10.395780] Initializing USB Mass Storage driver...
[   10.396601] scsi4 : SCSI emulation for USB Mass Storage devices
[   10.398383] usbcore: registered new interface driver usb-storage
[   10.398392] USB Mass Storage support registered.
[   10.398404] usb-storage: device found at 2
[   10.398408] usb-storage: waiting for device to settle before scanning
[   10.429068] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 2
[   10.443726] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   10.443775] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.532387] input: HDA Intel Headphone as /class/input/input7
[   10.532663] input: HDA Intel Mic as /class/input/input8
[   10.532855] input: HDA Intel Mic as /class/input/input9
[   10.533049] input: HDA Intel Headphone as /class/input/input10
[   10.613507] usb 4-1: configuration #1 chosen from 1 choice
[   13.615231] loop: module loaded
[   14.003065] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   15.397295] scsi 4:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[   15.563771] sd 4:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96 G=
B/3.69 GiB)
[   15.564443] sd 4:0:0:0: [sdb] Write Protect is off
[   15.564450] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   15.564455] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.565324] usb-storage: device scan complete
[   15.566801] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.566812]  sdb: sdb1
[   15.568953] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   19.851683] Intel AES-NI instructions are not detected.
[   19.885206] padlock: VIA PadLock not detected.
[   19.931853] padlock: VIA PadLock Hash Engine not detected.
[   52.249821] fuse init (API version 7.11)
[   55.749852] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   55.805600] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   56.480175] Loading iSCSI transport class v2.0-870.
[   56.537996] iscsi: registered transport (tcp)
[   56.641740] NET: Registered protocol family 10
[   56.643197] lo: Disabled Privacy Extensions
[   56.644439] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   56.793737] iscsi: registered transport (iser)
[   63.867404] lp: driver loaded but no devices found
[   63.891428] ppdev: user-space parallel port driver
[   66.588870] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[   66.589115] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[   66.681004] input: /usr/sbin/thinkpad-keys as /class/input/input11
[   67.637041] RPC: Registered udp transport module.
[   67.637182] RPC: Registered tcp transport module.
[   67.741437] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   67.869927] svc: failed to register lockdv1 RPC service (errno 97).
[   67.872789] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   67.890211] NFSD: starting 90-second grace period
[   77.100130] Bluetooth: Core ver 2.15
[   77.100378] NET: Registered protocol family 31
[   77.100520] Bluetooth: HCI device and connection manager initialized
[   77.100662] Bluetooth: HCI socket layer initialized
[   77.135734] Bluetooth: L2CAP ver 2.14
[   77.135889] Bluetooth: L2CAP socket layer initialized
[   77.168864] Bluetooth: RFCOMM socket layer initialized
[   77.169053] Bluetooth: RFCOMM TTY layer initialized
[   77.169205] Bluetooth: RFCOMM ver 1.11
[   81.468391] ip_tables: (C) 2000-2006 Netfilter Core Team
[   82.172313] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[   82.276807] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
[   82.446033] Registered led device: iwl-phy0::radio
[   82.446223] Registered led device: iwl-phy0::assoc
[   82.446410] Registered led device: iwl-phy0::RX
[   82.446594] Registered led device: iwl-phy0::TX
[   82.474381] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   85.556959] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[   85.560259] wlan0: authenticated
[   85.560269] wlan0: associate with AP 00:03:52:4e:f3:d1
[   85.760271] wlan0: associate with AP 00:03:52:4e:f3:d1
[   85.762386] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D1 aid=3D0)
[   85.762395] wlan0: AP denied association (code=3D1)
[   85.960295] wlan0: associate with AP 00:03:52:4e:f3:d1
[   85.962588] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D1 aid=3D0)
[   85.962597] wlan0: AP denied association (code=3D1)
[   86.160312] wlan0: association with AP 00:03:52:4e:f3:d1 timed out
[   98.687288] [drm] Initialized drm 1.1.0 20060810
[   98.753433] pci 0000:00:02.0: power state changed by ACPI to D0
[   98.753453] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   98.753463] pci 0000:00:02.0: setting latency timer to 64
[   98.780972]   alloc irq_desc for 30 on node -1
[   98.780981]   alloc kstat_irqs on node -1
[   98.780999] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[   98.796076] acpi device:03: registered as cooling_device2
[   98.796744] input: Video Bus as /class/input/input12
[   98.796942] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   98.797049] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   99.696895] set status page addr 0x08da0000
[  161.744217] CE: hpet increasing min_delta_ns to 15000 nsec
[  226.718057] iwlagn 0000:03:00.0: PCI INT A disabled
[  226.829888] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27k
[  226.829897] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[  226.830203] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[  226.830253] iwlagn 0000:03:00.0: setting latency timer to 64
[  226.830337] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[  226.850863] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[  226.850975] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[  226.862702] phy1: Selected rate control algorithm 'iwl-agn-rs'
[  229.044319] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[  229.057255] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
[  229.215114] Registered led device: iwl-phy1::radio
[  229.215137] Registered led device: iwl-phy1::assoc
[  229.215156] Registered led device: iwl-phy1::RX
[  229.215174] Registered led device: iwl-phy1::TX
[  229.262328] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  233.418153] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  236.490003] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  236.688150] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  236.691253] wlan0: authenticated
[  236.691263] wlan0: associate with AP 00:03:52:4d:e7:91
[  236.693538] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  236.693547] wlan0: associated
[  236.702979] wlan0: disassociating by local choice (reason=3D3)
[  236.718776] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  236.806631] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  236.807548] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  236.809445] wlan0: authenticated
[  236.809452] wlan0: associate with AP 00:03:52:4e:f3:d1
[  236.831740] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  236.831749] wlan0: associated
[  237.332141] iwlagn 0000:03:00.0: Error sending REPLY_ADD_STA: time out a=
fter 500ms.
[  237.332582] iwlagn 0000:03:00.0: Error: Response NULL in 'REPLY_ADD_STA'
[  237.335345] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  237.339645] wlan0: disassociating by local choice (reason=3D3)
[  237.353758] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  237.443401] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  237.445670] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  237.644274] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[  237.844273] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 3
[  238.044092] wlan0: direct probe to AP 00:03:52:1b:f8:31 timed out
[  242.469412] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  242.668089] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  242.869264] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  243.068304] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  247.353059] wlan0: no IPv6 routers present
[  250.417637] wlan0: direct probe to AP 00:03:52:4d:e7:91 try 1
[  250.418545] wlan0: direct probe to AP 00:03:52:4d:e7:91 try 1
[  250.421977] wlan0 direct probe responded
[  250.421986] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  250.423938] wlan0: authenticated
[  250.423947] wlan0: associate with AP 00:03:52:4d:e7:91
[  250.426237] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  250.426246] wlan0: associated
[  250.433646] wlan0: disassociating by local choice (reason=3D3)
[  250.554244] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  250.752307] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[  250.952310] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 3
[  251.153274] wlan0: direct probe to AP 00:03:52:1b:f8:31 timed out
[  251.177764] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 1
[  251.376718] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 2
[  251.576126] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 3
[  251.776092] wlan0: direct probe to AP 00:03:52:1b:f6:01 timed out
[  256.185159] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 1
[  256.384133] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 2
[  256.585269] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 3
[  256.784103] wlan0: direct probe to AP 00:03:52:4d:e4:f1 timed out
[  267.313471] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  267.315444] wlan0: authenticated
[  267.315452] wlan0: associate with AP 00:03:52:4d:e7:91
[  267.317643] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  267.317651] wlan0: associated
[  267.323639] wlan0: disassociating by local choice (reason=3D3)
[  267.458111] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  267.656287] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  267.660329] wlan0: authenticated
[  267.660338] wlan0: associate with AP 00:03:52:4d:e8:81
[  267.860300] wlan0: associate with AP 00:03:52:4d:e8:81
[  267.863358] wlan0: RX AssocResp from 00:03:52:4d:e8:81 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  267.863367] wlan0: associated
[  267.870801] wlan0: disassociating by local choice (reason=3D3)
[  267.976144] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  268.177171] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  268.180613] wlan0: authenticated
[  268.180620] wlan0: associate with AP 00:03:52:4e:f3:d1
[  268.182738] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  268.182745] wlan0: associated
[  268.205652] wlan0: disassociating by local choice (reason=3D3)
[  268.217644] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  268.313800] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 1
[  268.512306] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 2
[  268.712102] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 3
[  268.912100] wlan0: direct probe to AP 00:03:52:1b:f6:01 timed out
[  273.320028] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 1
[  273.322597] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 1
[  273.520311] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 2
[  273.720285] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 3
[  273.920274] wlan0: direct probe to AP 00:03:52:4d:d3:21 timed out
[  284.313867] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  284.513309] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  284.515277] wlan0: authenticated
[  284.515286] wlan0: associate with AP 00:03:52:4e:f3:d1
[  284.521776] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  284.521785] wlan0: associated
[  284.530926] wlan0: disassociating by local choice (reason=3D3)
[  284.649289] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 1
[  284.848273] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 2
[  284.850810] wlan0 direct probe responded
[  284.850819] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  285.048106] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  285.052384] wlan0: authenticated
[  285.052392] wlan0: associate with AP 00:03:52:4d:e8:81
[  285.055790] wlan0: RX AssocResp from 00:03:52:4d:e8:81 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  285.055799] wlan0: associated
[  285.060197] wlan0: disassociating by local choice (reason=3D3)
[  285.180768] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  285.380291] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  285.580106] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  285.780078] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  290.189429] wlan0: direct probe to AP 00:03:52:1c:01:01 try 1
[  290.388085] wlan0: direct probe to AP 00:03:52:1c:01:01 try 2
[  290.588091] wlan0: direct probe to AP 00:03:52:1c:01:01 try 3
[  290.788088] wlan0: direct probe to AP 00:03:52:1c:01:01 timed out
[  301.308827] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  301.317531] wlan0: authenticated
[  301.317540] wlan0: associate with AP 00:03:52:4e:f3:d1
[  301.320861] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  301.320870] wlan0: associated
[  301.335711] wlan0: disassociating by local choice (reason=3D3)
[  301.454758] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  301.652097] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 2
[  301.853090] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 3
[  302.052248] wlan0: direct probe to AP 00:03:52:4d:bd:c1 timed out
[  306.466978] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  306.664274] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 2
[  306.864105] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 3
[  307.064292] wlan0: direct probe to AP 00:03:52:4d:de:d1 timed out
[  317.680771] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  317.683930] wlan0: authenticated
[  317.683937] wlan0: associate with AP 00:03:52:4e:f3:d1
[  317.686010] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  317.686018] wlan0: associated
[  317.691119] wlan0: disassociating by local choice (reason=3D3)
[  317.796442] wlan0: direct probe to AP 00:03:52:1c:18:71 try 1
[  317.992272] wlan0: direct probe to AP 00:03:52:1c:18:71 try 2
[  318.192270] wlan0: direct probe to AP 00:03:52:1c:18:71 try 3
[  318.392077] wlan0: direct probe to AP 00:03:52:1c:18:71 timed out
[  321.177874] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  321.376132] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  321.576277] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  321.776292] wlan0: authentication with AP 00:03:52:4d:d3:21 timed out
[  332.335019] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  332.341930] wlan0: authenticated
[  332.341940] wlan0: associate with AP 00:03:52:4e:f3:d1
[  332.344330] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  332.344340] wlan0: associated
[  332.348423] wlan0: disassociating by local choice (reason=3D3)
[  332.467594] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  332.664176] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 2
[  332.865275] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 3
[  333.064313] wlan0: direct probe to AP 00:03:52:4d:bd:c1 timed out
[  337.477094] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  337.676081] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  337.876106] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  338.076269] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  348.616258] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  348.618367] wlan0: authenticated
[  348.618377] wlan0: associate with AP 00:03:52:4e:f3:d1
[  348.621315] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  348.621324] wlan0: associated
[  348.627085] wlan0: disassociating by local choice (reason=3D3)
[  348.757686] wlan0: direct probe to AP 00:03:52:4e:f3:a1 try 1
[  348.956325] wlan0: direct probe to AP 00:03:52:4e:f3:a1 try 2
[  349.156292] wlan0: direct probe to AP 00:03:52:4e:f3:a1 try 3
[  349.356276] wlan0: direct probe to AP 00:03:52:4e:f3:a1 timed out
[  353.766817] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  353.965269] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  354.164110] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  354.364124] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  364.897051] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  364.902255] wlan0: authenticated
[  364.902265] wlan0: associate with AP 00:03:52:4d:e8:81
[  364.904799] wlan0: RX AssocResp from 00:03:52:4d:e8:81 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  364.904808] wlan0: associated
[  364.913826] wlan0: disassociating by local choice (reason=3D3)
[  364.936305] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  365.017743] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  365.019600] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  365.021178] wlan0: authenticated
[  365.021185] wlan0: associate with AP 00:03:52:4d:e7:91
[  365.024045] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  365.024053] wlan0: associated
[  365.030407] wlan0: disassociating by local choice (reason=3D3)
[  365.046876] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  365.133847] wlan0: direct probe to AP 00:03:52:4e:f3:d1 try 1
[  365.135266] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  365.137205] wlan0: authenticated
[  365.137210] wlan0: associate with AP 00:03:52:4e:f3:d1
[  365.336274] wlan0: associate with AP 00:03:52:4e:f3:d1
[  365.340668] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  365.340677] wlan0: associated
[  365.349192] wlan0: disassociating by local choice (reason=3D3)
[  365.468681] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 1
[  365.668083] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 2
[  365.868298] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 3
[  366.068269] wlan0: direct probe to AP 00:03:52:4d:d3:21 timed out
[  370.477745] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  370.478708] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  370.676161] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  370.876276] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  371.076293] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  371.172810] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 1
[  371.175308] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 1
[  371.372266] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 2
[  371.572297] wlan0: direct probe to AP 00:03:52:1b:f6:01 try 3
[  371.772282] wlan0: direct probe to AP 00:03:52:1b:f6:01 timed out
[  379.224262] wlan0: direct probe to AP 00:03:52:4d:e7:91 try 1
[  379.227626] wlan0: direct probe to AP 00:03:52:4d:e7:91 try 1
[  379.227655] wlan0 direct probe responded
[  379.227660] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  379.233896] wlan0: authenticated
[  379.233906] wlan0: associate with AP 00:03:52:4d:e7:91
[  379.236187] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  379.236196] wlan0: associated
[  379.242265] wlan0: disassociating by local choice (reason=3D3)
[  379.350305] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  379.548332] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[  379.748170] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 3
[  379.948296] wlan0: direct probe to AP 00:03:52:1b:f8:31 timed out
[  384.362591] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  384.560281] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  384.760089] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  384.960071] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  392.442479] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  392.443428] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  392.445330] wlan0: authenticated
[  392.445336] wlan0: associate with AP 00:03:52:4d:e7:91
[  392.447493] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  392.447500] wlan0: associated
[  392.451181] wlan0: disassociating by local choice (reason=3D3)
[  392.570118] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  392.571982] wlan0: authenticated
[  392.571988] wlan0: associate with AP 00:03:52:4e:f3:d1
[  392.772103] wlan0: associate with AP 00:03:52:4e:f3:d1
[  392.774172] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  392.774180] wlan0: associated
[  392.782531] wlan0: disassociating by local choice (reason=3D3)
[  392.905361] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  393.104292] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  393.106250] wlan0: authenticated
[  393.106259] wlan0: associate with AP 00:03:52:4d:e8:81
[  393.108422] wlan0: RX AssocResp from 00:03:52:4d:e8:81 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  393.108465] wlan0: associated
[  393.116183] wlan0: disassociating by local choice (reason=3D3)
[  393.223067] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 1
[  393.420303] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 2
[  393.620296] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 3
[  393.821072] wlan0: direct probe to AP 00:03:52:4d:d3:21 timed out
[  398.227047] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  398.425270] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  398.624309] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  398.824104] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  409.337413] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  409.339288] wlan0: authenticated
[  409.339296] wlan0: associate with AP 00:03:52:4e:f3:d1
[  409.341736] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D5)
[  409.341743] wlan0: associated
[  409.350711] wlan0: disassociating by local choice (reason=3D3)
[  409.453649] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  409.652084] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[  409.852163] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 3
[  410.052299] wlan0: direct probe to AP 00:03:52:1b:f8:31 timed out

--bp/iNruPH9dso1Pn
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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
+yuh/wNBcBd9ElgBAA==

--bp/iNruPH9dso1Pn--

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoNQ00ACgkQuL75KpiFGIyA7ACgrchLBxGA5s+rgRJar67dxrNZ
1jAAoKoUG2apFvzAv/i9LIE3cUpDHyT6
=gk2Q
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
