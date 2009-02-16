Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbZBPK7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbZBPK7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZBPK7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:59:01 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:42586 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZBPK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:58:52 -0500
Date: Mon, 16 Feb 2009 11:58:47 +0100
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: ZhangRui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090216105847.GA29302@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	ZhangRui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
	Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <20090213093354.GA10175@denkbrett.schottelius.org> <20090213094200.GC17774@elte.hu> <alpine.LFD.2.00.0902131302240.3671@localhost.localdomain> <1234775219.4998.1.camel@rzhang-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <1234775219.4998.1.camel@rzhang-desktop>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-ikn-00001-gd5b5623 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello rui,

ZhangRui [Mon, Feb 16, 2009 at 05:06:59PM +0800]:
> do you have an external graphics card as well as the integrated intel
> graphics on your laptops?

No, just the interal one.

> please attach the dmesg and lspci output.

dmesg und lspci running 2.6.29-rc4-ikn-00001-gd5b5623 attached.

I'm upgrading to v2.6.29-rc5 now and will test the supplied patch,
if the error is still there.

Sincerly,

Nico


00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Contr=
oller Hub (rev 07)
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipse=
t Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integ=
rated Graphics Controller (rev 07)
00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset=
 MEI Controller (rev 07)
00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Conn=
ection (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Con=
troller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Con=
troller #5 (rev 03)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Con=
troller #6 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Co=
ntroller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Contr=
oller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port=
 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port=
 2 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port=
 4 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Con=
troller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Con=
troller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Con=
troller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Co=
ntroller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev=
 03)
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (=
rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev=
 03)
03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100


[    0.000000] Linux version 2.6.29-rc4-ikn-00001-gd5b5623 (compiler@ikn) (=
gcc version 4.3.2 (Debian 4.3.2-1.1) ) #9 SMP PREEMPT Mon Feb 9 20:55:46 CE=
T 2009
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
[    0.000000] last_pfn =3D 0x7ca00 max_arch_pfn =3D 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007ca00000
[    0.000000]  0000000000 - 007ca00000 page 2M
[    0.000000] kernel direct mapping tables up to 7ca00000 @ 8000-b000
[    0.000000] last_map_addr: 7ca00000 end: 7ca00000
[    0.000000] ACPI: RSDP 000F73A0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 7C97BD45, 009C (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: FACP 7C97BF00, 00F4 (r3 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aCo=
ntrolBlock: 16/32 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBl=
ock: 32, using default 16 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_L=
EN (4)
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
[    0.000000]   #2 [0000200000 - 000073641c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 000073641c]
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
[    0.000000]   DMA zone: 1437 pages reserved
[    0.000000]   DMA zone: 2505 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6923 pages used for memmap
[    0.000000]   DMA32 zone: 498526 pages, LIFO batch:31
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
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000=
:61000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 501031
[    0.000000] Kernel command line: root=3D/dev/sda1 ro=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.956 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[    0.004000] Memory: 1999600k/2041856k available (2891k kernel code, 4068=
k absent, 37460k reserved, 1408k data, 336k init)
[    0.004000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4521.91 BogoMIPS (lpj=3D9043824)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20081204
[    0.048093] Setting APIC routing to flat
[    0.048635] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.097472] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.100001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4522.06 Bog=
oMIPS (lpj=3D9044129)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.189268] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.190631] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.192042] Brought up 2 CPUs
[    0.192173] Total of 2 processors activated (9043.97 BogoMIPS).
[    0.192411] net_namespace: 1752 bytes
[    0.196246] regulator: core version 0.5
[    0.196365] NET: Registered protocol family 16
[    0.197132] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.197348] ACPI: bus type pci registered
[    0.197757] PCI: Using configuration type 1 for base access
[    0.204094] bio: create slab <bio-0> at 0
[    0.211641] ACPI: EC: EC description table is found, configuring boot EC
[    0.232787] ACPI: BIOS _OSI(Linux) query ignored
[    0.233447] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.253876] ACPI: Interpreter enabled
[    0.254009] ACPI: (supports S0 S3 S5)
[    0.254314] ACPI: Using IOAPIC for interrupt routing
[    0.300583] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.300720] ACPI: EC: driver started in interrupt mode
[    0.306782] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.308608] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.308826] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.308826] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.308826] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.308826] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.308826] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.308826] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.308826] pci 0000:00:03.0: PME# disabled
[    0.308865] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.308878] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.308890] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.308967] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.309104] pci 0000:00:19.0: PME# disabled
[    0.312103] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.312236] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.312368] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.312504] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.312604] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.312741] pci 0000:00:1a.7: PME# disabled
[    0.312945] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.313028] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.313164] pci 0000:00:1b.0: PME# disabled
[    0.313403] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.313539] pci 0000:00:1c.0: PME# disabled
[    0.313781] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.313918] pci 0000:00:1c.1: PME# disabled
[    0.314161] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.314298] pci 0000:00:1c.3: PME# disabled
[    0.314530] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.314530] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.314530] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.314530] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.314530] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.314530] pci 0000:00:1d.7: PME# disabled
[    0.314530] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.314530] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.314530] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.314530] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.314530] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.314530] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.314530] pci 0000:00:1f.2: PME# supported from D3hot
[    0.314530] pci 0000:00:1f.2: PME# disabled
[    0.314530] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.314530] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.314530] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.314530] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.314530] pci 0000:03:00.0: PME# disabled
[    0.314530] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.314530] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.314530] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.314530] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.314530] pci 0000:00:1e.0: transparent bridge
[    0.314632] pci_bus 0000:00: on NUMA node 0
[    0.314653] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.315164] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.315389] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.315618] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.336565] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.337754] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.338935] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.340166] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.341347] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.342526] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.343704] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.344857] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.345684] ACPI: Power Resource [PUBS] (on)
[    0.345684] SCSI subsystem initialized
[    0.348092] libata version 3.00 loaded.
[    0.348127] PCI: Using ACPI for IRQ routing
[    0.364037] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.364399] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.390864] pnp: PnP ACPI init
[    0.391009] ACPI: bus type pnp registered
[    0.461054] pnp: PnP ACPI: found 10 devices
[    0.461188] ACPI: ACPI bus type pnp unregistered
[    0.461340] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.461476] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.461612] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.461749] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.461884] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.462019] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.462155] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.462291] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.462427] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.462563] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.462699] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.462835] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.462984] system 00:00: iomem range 0x100000-0x7effffff could not be r=
eserved
[    0.463198] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.463412] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.463635] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.463771] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.463906] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.464042] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.464177] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.464312] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.464447] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.464584] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.464721] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.464857] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.464994] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.465131] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.465268] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.470991] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.471128] pci 0000:00:1c.0:   IO window: disabled
[    0.471264] pci 0000:00:1c.0:   MEM window: disabled
[    0.471399] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.471538] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.471671] pci 0000:00:1c.1:   IO window: disabled
[    0.471808] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.471944] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.472096] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.472231] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.472368] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.472505] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.472725] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.472857] pci 0000:00:1e.0:   IO window: disabled
[    0.472993] pci 0000:00:1e.0:   MEM window: disabled
[    0.473127] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.473283] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.473422] pci 0000:00:1c.0: setting latency timer to 64
[    0.473439] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.473577] pci 0000:00:1c.1: setting latency timer to 64
[    0.473593] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.473730] pci 0000:00:1c.3: setting latency timer to 64
[    0.473743] pci 0000:00:1e.0: setting latency timer to 64
[    0.473751] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.473756] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.473762] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.473766] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    0.473771] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.473775] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.473779] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.473784] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.473789] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.473793] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.473798] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.473803] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.473808] pci_bus 0000:05: resource 2 mem: [0xf2900000-0xf29fffff]
[    0.473813] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
[    0.473817] pci_bus 0000:0d: resource 0 mem: [0x0-0x0]
[    0.473821] pci_bus 0000:0d: resource 1 mem: [0x0-0x0]
[    0.473826] pci_bus 0000:0d: resource 2 mem: [0x0-0x0]
[    0.473830] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.473835] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.473891] NET: Registered protocol family 2
[    0.520123] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.521450] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.524397] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.525362] TCP: Hash tables configured (established 262144 bind 65536)
[    0.525497] TCP reno registered
[    0.536194] NET: Registered protocol family 1
[    0.536823] Simple Boot Flag at 0x35 set to 0x1
[    0.539233] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
[    0.545238] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.550862] Switched to high resolution mode on CPU 1
[    0.551019] VFS: Disk quotas dquot_6.5.2
[    0.551351] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.552009] Switched to high resolution mode on CPU 0
[    0.552723] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.557941] msgmni has been set to 3906
[    0.558571] alg: No test for stdrng (krng)
[    0.558724] io scheduler noop registered
[    0.558855] io scheduler anticipatory registered (default)
[    0.558989] io scheduler deadline registered
[    0.559292] io scheduler cfq registered
[    0.559447] pci 0000:00:02.0: Boot video device
[    0.559935] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.560043] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.560363] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.560463] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.560769] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.560869] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.562321] ACPI: AC Adapter [AC] (off-line)
[    0.606430] ACPI: Battery Slot [BAT0] (battery present)
[    0.606895] input: Power Button (FF) as /class/input/input0
[    0.607100] ACPI: Power Button (FF) [PWRF]
[    0.607481] input: Lid Switch as /class/input/input1
[    0.608574] ACPI: Lid Switch [LID]
[    0.608934] input: Sleep Button (CM) as /class/input/input2
[    0.609095] ACPI: Sleep Button (CM) [SLPB]
[    0.611329] ACPI: SSDT 7C6D6C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL =
20050624)
[    0.613345] ACPI: SSDT 7C6D4020, 087A (r1  PmRef  Cpu0Cst     3001 INTL =
20050624)
[    0.623915] Monitor-Mwait will be used to enter C-1 state
[    0.623934] Monitor-Mwait will be used to enter C-2 state
[    0.623950] Monitor-Mwait will be used to enter C-3 state
[    0.624071] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.624605] processor ACPI_CPU:00: registered as cooling_device0
[    0.624744] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.626650] ACPI: SSDT 7C6D5CA0, 01CF (r1  PmRef    ApIst     3000 INTL =
20050624)
[    0.628458] ACPI: SSDT 7C6D5F20, 008D (r1  PmRef    ApCst     3000 INTL =
20050624)
[    0.634120] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.634546] processor ACPI_CPU:01: registered as cooling_device1
[    0.634686] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.686529] thermal LNXTHERM:01: registered as thermal_zone0
[    0.690947] ACPI: Thermal Zone [THM0] (29 C)
[    0.693596] thermal LNXTHERM:02: registered as thermal_zone1
[    0.696642] ACPI: Thermal Zone [THM1] (31 C)
[    0.794559] Linux agpgart interface v0.103
[    3.808022] floppy0: no floppy controllers found
[    3.811535] brd: module loaded
[    3.811853] Uniform Multi-Platform E-IDE driver
[    3.812201] ide-gd driver 1.18
[    3.812612] Driver 'sd' needs updating - please use bus_type methods
[    3.812864] ahci 0000:00:1f.2: version 3.0
[    3.812894] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.813084] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    3.813154] ahci: SSS flag set, parallel bus scan disabled
[    3.813323] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.813538] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.813754] ahci 0000:00:1f.2: setting latency timer to 64
[    3.814090] scsi0 : ahci
[    3.814441] scsi1 : ahci
[    3.814740] scsi2 : ahci
[    3.815031] scsi3 : ahci
[    3.816745] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 27
[    3.816961] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 27
[    3.817202] ata3: DUMMY
[    3.817329] ata4: DUMMY
[    4.136026] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.180038] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.180045] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.180271] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.180278] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.181153] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    4.181288] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.191124] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.191131] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.191356] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.191362] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.192293] ata1.00: configured for UDMA/100
[    4.219648] ata1.00: configured for UDMA/100
[    4.219781] ata1: EH complete
[    4.232173] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    4.232719] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.232961] sd 0:0:0:0: [sda] Write Protect is off
[    4.233094] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.233148] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.233472] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.233714] sd 0:0:0:0: [sda] Write Protect is off
[    4.233848] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.233899] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.234119]  sda: sda1 sda2 sda3
[    4.291560] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.608023] ata2: SATA link down (SStatus 0 SControl 300)
[    4.672225] Fusion MPT base driver 3.04.07
[    4.674570] Copyright (c) 1999-2008 LSI Corporation
[    4.674713] Fusion MPT SPI Host driver 3.04.07
[    4.675651] ieee1394: raw1394: /dev/raw1394 device initialized
[    4.676084] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    4.686430] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.686571] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.687112] mice: PS/2 mouse device common for all mice
[    4.730059] cpuidle: using governor ladder
[    4.731512] cpuidle: using governor menu
[    4.731822] Marking TSC unstable due to TSC halts in idle
[    4.732162] oprofile: using NMI interrupt.
[    4.732914] TCP cubic registered
[    4.733060] NET: Registered protocol family 17
[    4.735739] registered taskstats version 1
[    4.737434] input: AT Translated Set 2 keyboard as /class/input/input3
[    4.988980] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[    5.000241] Clocksource tsc unstable (delta =3D -231254716 ns)
[    5.299633] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    5.318896] input: TPPS/2 IBM TrackPoint as /class/input/input4
[    5.437924] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    5.438094] Freeing unused kernel memory: 336k freed
[    8.395219] Non-volatile memory driver v1.3
[    8.593527] thinkpad_acpi: ThinkPad ACPI Extras v0.22
[    8.593637] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.593742] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[    8.593848] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[    8.594664] thinkpad_acpi: radio switch found; radios are enabled
[    8.594885] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    8.595057] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    8.603275] Registered led device: tpacpi::thinklight
[    8.603417] Registered led device: tpacpi::power
[    8.603535] Registered led device: tpacpi:orange:batt
[    8.603657] Registered led device: tpacpi:green:batt
[    8.603780] Registered led device: tpacpi::dock_active
[    8.603902] Registered led device: tpacpi::bay_active
[    8.604023] Registered led device: tpacpi::dock_batt
[    8.604149] Registered led device: tpacpi::unknown_led
[    8.604267] Registered led device: tpacpi::standby
[    8.606649] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[    8.607051] input: ThinkPad Extra Buttons as /class/input/input5
[    8.823710] agpgart-intel 0000:00:00.0: Intel Mobile Intel=AE GM45 Expre=
ss Chipset
[    8.824747] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    8.827864] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.907708] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    8.907822] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    8.907968] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    8.908092] e1000e 0000:00:19.0: setting latency timer to 64
[    8.908190] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    8.999398] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[    8.999565] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.999691] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1008ff-0ff
[    9.033070] usbcore: registered new interface driver usbfs
[    9.033198] usbcore: registered new interface driver hub
[    9.073057] usbcore: registered new device driver usb
[    9.101455] ACPI: WMI: Mapper loaded
[    9.365564] rtc_cmos 00:07: RTC can wake from S4
[    9.365772] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    9.365911] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    9.413792] uhci_hcd: USB Universal Host Controller Interface driver
[    9.414492] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    9.414602] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    9.414713] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    9.414716] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    9.414853] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    9.415050] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    9.415269] usb usb1: configuration #1 chosen from 1 choice
[    9.415397] hub 1-0:1.0: USB hub found
[    9.415502] hub 1-0:1.0: 2 ports detected
[    9.415704] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    9.415813] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    9.415816] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    9.415936] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 2
[    9.416131] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    9.416306] usb usb2: configuration #1 chosen from 1 choice
[    9.416431] hub 2-0:1.0: USB hub found
[    9.416535] hub 2-0:1.0: 2 ports detected
[    9.417249] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    9.417359] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[    9.417467] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    9.417470] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    9.417591] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 3
[    9.417783] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    9.417958] usb usb3: configuration #1 chosen from 1 choice
[    9.418084] hub 3-0:1.0: USB hub found
[    9.418189] hub 3-0:1.0: 2 ports detected
[    9.418896] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    9.419002] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    9.419110] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    9.419113] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    9.419235] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 4
[    9.419427] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    9.419601] usb usb4: configuration #1 chosen from 1 choice
[    9.419726] hub 4-0:1.0: USB hub found
[    9.419829] hub 4-0:1.0: 2 ports detected
[    9.420015] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[    9.420123] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    9.420126] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    9.420247] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 5
[    9.420437] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    9.420608] usb usb5: configuration #1 chosen from 1 choice
[    9.420734] hub 5-0:1.0: USB hub found
[    9.420836] hub 5-0:1.0: 2 ports detected
[    9.421042] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    9.421151] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    9.421153] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    9.421273] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 6
[    9.421464] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    9.421637] usb usb6: configuration #1 chosen from 1 choice
[    9.421761] hub 6-0:1.0: USB hub found
[    9.421865] hub 6-0:1.0: 2 ports detected
[    9.452771] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.452880] Warning! ehci_hcd should always be loaded before uhci_hcd an=
d ohci_hcd, not after
[    9.453963] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    9.454075] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    9.454203] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    9.454206] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    9.454338] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 7
[    9.458398] ehci_hcd 0000:00:1a.7: debug port 1
[    9.458503] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    9.458520] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    9.473011] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.473227] usb usb7: configuration #1 chosen from 1 choice
[    9.473356] hub 7-0:1.0: USB hub found
[    9.473460] hub 7-0:1.0: 6 ports detected
[    9.474171] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    9.474284] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    9.474407] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    9.474411] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.474535] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 8
[    9.478601] ehci_hcd 0000:00:1d.7: debug port 1
[    9.478706] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    9.478720] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    9.493013] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.493234] usb usb8: configuration #1 chosen from 1 choice
[    9.493366] hub 8-0:1.0: USB hub found
[    9.493470] hub 8-0:1.0: 6 ports detected
[    9.505045] cfg80211: Calling CRDA to update world regulatory domain
[    9.573310] acpi device:03: registered as cooling_device2
[    9.573685] input: Video Bus as /class/input/input6
[    9.608158] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    9.829546] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    9.901103] usb 7-6: new high speed USB device using ehci_hcd and addres=
s 3
[    9.934836] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[    9.935001] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.935177] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    9.935287] iwlagn 0000:03:00.0: setting latency timer to 64
[    9.935344] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[    9.953756] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    9.954088] iwlagn 0000:03:00.0: PCI INT A disabled
[    9.954388] wmaster0 (iwlagn): not using net_device_ops yet
[    9.954762] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   10.039758] usb 7-6: configuration #1 chosen from 1 choice
[   10.136376] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   10.136603] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.150135] wlan0 (iwlagn): not using net_device_ops yet
[   10.153032] usb 8-6: new high speed USB device using ehci_hcd and addres=
s 2
[   10.294770] usb 8-6: configuration #1 chosen from 1 choice
[   10.333033] input: HDA Intel at 0xf2620000 irq 17 Mic as /class/input/in=
put7
[   10.348256] input: HDA Intel at 0xf2620000 irq 17 Mic as /class/input/in=
put8
[   10.364184] input: HDA Intel at 0xf2620000 irq 17 Headphone as /class/in=
put/input9
[   10.434486] usbcore: registered new interface driver libusual
[   10.533355] Initializing USB Mass Storage driver...
[   10.533844] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 2
[   10.539347] scsi4 : SCSI emulation for USB Mass Storage devices
[   10.540438] usb-storage: device found at 2
[   10.540440] usbcore: registered new interface driver usb-storage
[   10.540443] USB Mass Storage support registered.
[   10.540671] usb-storage: waiting for device to settle before scanning
[   10.707861] usb 2-1: configuration #1 chosen from 1 choice
[   14.153784] loop: module loaded
[   14.841373] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   15.540494] isa bounce pool size: 16 pages
[   15.541237] scsi 4:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[   15.731688] sd 4:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[   15.732280] sd 4:0:0:0: [sdb] Write Protect is off
[   15.732283] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   15.732286] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.733899] sd 4:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[   15.734520] sd 4:0:0:0: [sdb] Write Protect is off
[   15.734523] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   15.734526] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.734530]  sdb: sdb1
[   15.736877] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   15.737438] usb-storage: device scan complete
[   28.289104] fuse init (API version 7.11)
[   31.689617] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   31.745207] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   32.233214] Loading iSCSI transport class v2.0-870.
[   32.293802] iscsi: registered transport (tcp)
[   32.428677] NET: Registered protocol family 10
[   32.429890] lo: Disabled Privacy Extensions
[   32.431162] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   32.591208] iscsi: registered transport (iser)
[   40.594979] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[   40.595208] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[   40.679142] input: /usr/sbin/thinkpad-keys as /class/input/input10
[   49.009756] Bluetooth: Core ver 2.14
[   49.010442] NET: Registered protocol family 31
[   49.010575] Bluetooth: HCI device and connection manager initialized
[   49.010711] Bluetooth: HCI socket layer initialized
[   49.075183] Bluetooth: L2CAP ver 2.11
[   49.075330] Bluetooth: L2CAP socket layer initialized
[   49.087281] Bluetooth: RFCOMM socket layer initialized
[   49.087443] Bluetooth: RFCOMM TTY layer initialized
[   49.087585] Bluetooth: RFCOMM ver 1.10
[   49.558939] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   49.559169] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100102, writing 0x100106)
[   49.559282] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[   49.559368] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[   49.745603] iwlagn loaded firmware version 5.4.1.16
[   49.904038] Registered led device: iwl-phy0:radio
[   49.904343] Registered led device: iwl-phy0:assoc
[   49.904542] Registered led device: iwl-phy0:RX
[   49.904738] Registered led device: iwl-phy0:TX
[   49.926124] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   79.685242] [drm] Initialized drm 1.1.0 20060810
[   79.718053] pci 0000:00:02.0: power state changed by ACPI to D0
[   79.718072] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   79.718081] pci 0000:00:02.0: setting latency timer to 64
[   79.722908] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[   79.722949] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   80.547607] set status page addr 0x08da0000
[   89.002680] iwlagn: Radio Frequency Kill Switch is On:
[   89.002685] Kill switch must be turned off for wireless networking to wo=
rk.
[  181.850208] PM: Syncing filesystems ... done.
[  182.747540] Freezing user space processes ... (elapsed 0.04 seconds) don=
e.
[  182.787762] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[  182.788067] Suspending console(s) (use no_console_suspend to debug)
[  182.804281] pci 0000:00:02.0: power state changed by ACPI to D3
[  183.480541] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  183.481175] sd 0:0:0:0: [sda] Stopping disk
[  183.846566] iwlagn 0000:03:00.0: PCI INT A disabled
[  183.908387] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[  183.908465] ehci_hcd 0000:00:1d.7: PME# disabled
[  183.928506] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[  183.928533] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  183.928603] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  183.928669] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  183.945156] HDA Intel 0000:00:1b.0: PCI INT B disabled
[  183.960205] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[  183.960280] ehci_hcd 0000:00:1a.7: PME# disabled
[  183.979089] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[  183.979115] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  183.979185] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  183.979251] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  184.035126] e1000e 0000:00:19.0: PME# enabled
[  184.035159] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  184.035167] e1000e 0000:00:19.0: PME# enabled
[  184.035171] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  184.035182] e1000e 0000:00:19.0: PCI INT A disabled
[  184.053573] ACPI: Preparing to enter system sleep state S3
[  184.074443] Disabling non-boot CPUs ...
[  184.076724] CPU 1 is now offline
[  184.076727] SMP alternatives: switching to UP code
[  184.256332] CPU1 is down
[  184.256438] Extended CMOS year: 2000
[  184.256438] Back to C!
[  184.256438] Extended CMOS year: 2000
[  184.256438] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900003)
[  184.256438] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[  184.256438] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[  184.256438] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[  184.256438] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[  184.256438] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[  184.256438] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[  184.256438] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[  184.256438] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[  184.256438] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x7 (was 0xf0, writing 0x200000f0)
[  184.256438] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[  184.256438] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x7 (was 0xf0, writing 0x200000f0)
[  184.256438] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[  184.256438] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[  184.256438] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[  184.256438] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[  184.256438] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[  184.256438] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[  184.256438] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[  184.256438] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[  184.256438] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[  184.256438] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[  184.256438] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[  184.256438] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[  184.256438] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100106, writing 0x100102)
[  184.256438] Enabling non-boot CPUs ...
[  184.256438] SMP alternatives: switching to SMP code
[  184.375186] Booting processor 1 APIC 0x1 ip 0x6000
[  184.249860] Initializing CPU#1
[  184.249860] Calibrating delay using timer specific routine.. 4522.01 Bog=
oMIPS (lpj=3D9044028)
[  184.249860] CPU: L1 I cache: 32K, L1 D cache: 32K
[  184.249860] CPU: L2 cache: 3072K
[  184.249860] [ds] using Core 2/Atom configuration
[  184.249860] CPU: Physical Processor ID: 0
[  184.249860] CPU: Processor Core ID: 1
[  184.249860] CPU1: Thermal monitoring enabled (TM2)
[  184.464504] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[  184.465011] Switched to high resolution mode on CPU 1
[  184.476340] CPU1 is up
[  184.476341] ACPI: Waking up from system sleep state S3
[  184.518393] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[  184.572157] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900403, writing 0x900003)
[  184.575066] pci 0000:00:02.0: PME# disabled
[  184.575070] pci 0000:00:02.1: PME# disabled
[  184.575073] pci 0000:00:03.0: PME# disabled
[  184.575128] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[  184.575133] e1000e 0000:00:19.0: setting latency timer to 64
[  184.575136] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  184.575140] e1000e 0000:00:19.0: PME# disabled
[  184.575141] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  184.575145] e1000e 0000:00:19.0: PME# disabled
[  184.575176] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[  184.635715] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  184.635724] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[  184.635731] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  184.635756] usb usb1: root hub lost power or was reset
[  184.635776] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[  184.635783] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  184.635805] usb usb2: root hub lost power or was reset
[  184.636323] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[  184.636328] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[  184.636334] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[  184.636357] usb usb3: root hub lost power or was reset
[  184.636376] ehci_hcd 0000:00:1a.7: PME# disabled
[  184.637014] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[  184.637020] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[  184.637027] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  184.637033] ehci_hcd 0000:00:1a.7: PME# disabled
[  184.637052] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[  184.637058] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  184.637077] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[  184.637085] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[  184.637092] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[  184.637720] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  184.637725] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[  184.637731] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  184.637754] usb usb4: root hub lost power or was reset
[  184.637773] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[  184.637779] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  184.637801] usb usb5: root hub lost power or was reset
[  184.637818] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[  184.637825] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  184.637846] usb usb6: root hub lost power or was reset
[  184.637865] ehci_hcd 0000:00:1d.7: PME# disabled
[  184.638336] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[  184.638342] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[  184.638349] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  184.638356] ehci_hcd 0000:00:1d.7: PME# disabled
[  184.638375] pci 0000:00:1e.0: setting latency timer to 64
[  184.638446] ahci 0000:00:1f.2: setting latency timer to 64
[  184.638645] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[  184.638795] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[  184.638848] iwlagn: Radio disabled by HW RF Kill switch
[  184.639171] sd 0:0:0:0: [sda] Starting disk
[  184.956293] ata2: SATA link down (SStatus 0 SControl 300)
[  186.300286] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  186.389782] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[  186.389790] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  186.389974] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[  186.389980] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[  186.400868] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[  186.400876] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  186.401060] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[  186.401067] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[  186.402182] ata1.00: configured for UDMA/100
[  186.404506] ata1.00: configured for UDMA/100
[  186.420272] ata1: EH complete
[  186.420378] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[  186.420415] sd 0:0:0:0: [sda] Write Protect is off
[  186.420420] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  186.420472] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  186.420531] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[  186.420562] sd 0:0:0:0: [sda] Write Protect is off
[  186.420566] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  186.420616] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  187.816319] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[  188.064312] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 2
[  188.320287] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[  188.472795] pci 0000:00:02.0: power state changed by ACPI to D0
[  188.472833] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900403, writing 0x900003)
[  188.473001] pci 0000:00:02.0: power state changed by ACPI to D0
[  188.473014] pci 0000:00:02.0: setting latency timer to 64
[  188.488362] Restarting tasks ... done.
[  189.592607] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[  189.904116] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[  189.922992] input: TPPS/2 IBM TrackPoint as /class/input/input11
[  272.887037] iwlagn 0000:03:00.0: PCI INT A disabled
[  281.594321] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[  281.594329] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[  281.594478] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[  281.594494] do_IRQ: 1.217 No irq handler for vector
[  281.594500] iwlagn 0000:03:00.0: setting latency timer to 64
[  281.594560] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[  281.614192] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[  281.616608] wmaster0 (iwlagn): not using net_device_ops yet
[  281.617108] phy1: Selected rate control algorithm 'iwl-agn-rs'
[  281.617125] wlan0 (iwlagn): not using net_device_ops yet
[  281.631739] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[  281.631886] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[  281.631937] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[  281.650386] iwlagn loaded firmware version 5.4.1.16
[  281.808985] Registered led device: iwl-phy1:radio
[  281.809809] Registered led device: iwl-phy1:assoc
[  281.811717] Registered led device: iwl-phy1:RX
[  281.811780] Registered led device: iwl-phy1:TX
[  281.850142] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1039.525810] Monitor-Mwait will be used to enter C-3 state
[ 1039.527923] thinkpad_acpi: EC reports that Thermal Table has changed
[ 1140.333571] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
[ 1140.336804] wlan0 direct probe responded
[ 1140.336810] wlan0: authenticate with AP 00:14:6c:67:9c:32
[ 1140.536070] wlan0: authenticate with AP 00:14:6c:67:9c:32
[ 1140.538142] wlan0: authenticated
[ 1140.538147] wlan0: associate with AP 00:14:6c:67:9c:32
[ 1140.545346] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=3D0x601 st=
atus=3D0 aid=3D5)
[ 1140.545352] wlan0: associated
[ 1140.550295] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1151.156100] wlan0: no IPv6 routers present
[ 1745.067786] PM: Syncing filesystems ... done.
[ 1746.017890] Freezing user space processes ... (elapsed 0.05 seconds) don=
e.
[ 1746.076943] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[ 1746.077281] Suspending console(s) (use no_console_suspend to debug)
[ 1746.092126] pci 0000:00:02.0: power state changed by ACPI to D3
[ 1746.768362] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1746.768465] sd 0:0:0:0: [sda] Stopping disk
[ 1747.228192] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[ 1747.228268] ehci_hcd 0000:00:1d.7: PME# disabled
[ 1747.245012] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[ 1747.245029] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 1747.245096] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 1747.245162] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 1747.260744] HDA Intel 0000:00:1b.0: PCI INT B disabled
[ 1747.276124] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[ 1747.276199] ehci_hcd 0000:00:1a.7: PME# disabled
[ 1747.292990] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[ 1747.293006] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 1747.293074] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 1747.293139] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 1747.350925] e1000e 0000:00:19.0: PME# enabled
[ 1747.350943] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 1747.350951] e1000e 0000:00:19.0: PME# enabled
[ 1747.350955] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 1747.350965] e1000e 0000:00:19.0: PCI INT A disabled
[ 1747.369979] ACPI: Preparing to enter system sleep state S3
[ 1747.390693] Disabling non-boot CPUs ...
[ 1747.392974] CPU 1 is now offline
[ 1747.392978] SMP alternatives: switching to UP code
[ 1747.540412] CPU1 is down
[ 1747.540517] Extended CMOS year: 2000
[ 1747.540517] Back to C!
[ 1747.540517] Extended CMOS year: 2000
[ 1747.540517] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[ 1747.540517] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[ 1747.540517] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[ 1747.540517] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[ 1747.540517] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 1747.540517] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 1747.540517] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 1747.540517] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[ 1747.540517] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[ 1747.540517] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[ 1747.540517] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[ 1747.540517] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[ 1747.540517] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 1747.540517] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 1747.540517] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 1747.540517] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[ 1747.540517] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[ 1747.540517] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[ 1747.540517] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[ 1747.540517] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[ 1747.540517] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[ 1747.540517] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[ 1747.540517] Enabling non-boot CPUs ...
[ 1747.540517] SMP alternatives: switching to SMP code
[ 1747.662706] Booting processor 1 APIC 0x1 ip 0x6000
[ 1747.532086] Initializing CPU#1
[ 1747.532086] Calibrating delay using timer specific routine.. 4522.01 Bog=
oMIPS (lpj=3D9044022)
[ 1747.532086] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 1747.532086] CPU: L2 cache: 3072K
[ 1747.532086] [ds] using Core 2/Atom configuration
[ 1747.532086] CPU: Physical Processor ID: 0
[ 1747.532086] CPU: Processor Core ID: 1
[ 1747.532086] CPU1: Thermal monitoring enabled (TM2)
[ 1747.752541] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[ 1747.756014] Switched to high resolution mode on CPU 1
[ 1747.764346] CPU1 is up
[ 1747.764348] ACPI: Waking up from system sleep state S3
[ 1747.807031] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[ 1747.857142] pci 0000:00:02.0: PME# disabled
[ 1747.857148] pci 0000:00:02.1: PME# disabled
[ 1747.857152] pci 0000:00:03.0: PME# disabled
[ 1747.857222] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[ 1747.857228] e1000e 0000:00:19.0: setting latency timer to 64
[ 1747.857232] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 1747.857237] e1000e 0000:00:19.0: PME# disabled
[ 1747.857239] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 1747.857243] e1000e 0000:00:19.0: PME# disabled
[ 1747.857278] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[ 1747.912815] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 1747.912820] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[ 1747.912827] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 1747.912850] usb usb1: root hub lost power or was reset
[ 1747.912870] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[ 1747.912876] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 1747.912898] usb usb2: root hub lost power or was reset
[ 1747.913740] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[ 1747.913745] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[ 1747.913751] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 1747.913774] usb usb3: root hub lost power or was reset
[ 1747.913793] ehci_hcd 0000:00:1a.7: PME# disabled
[ 1747.914572] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[ 1747.914578] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[ 1747.914585] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 1747.914592] ehci_hcd 0000:00:1a.7: PME# disabled
[ 1747.914611] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[ 1747.914617] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 1748.001232] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[ 1748.001245] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[ 1748.001263] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[ 1748.002001] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 1748.002010] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[ 1748.002020] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 1748.002050] usb usb4: root hub lost power or was reset
[ 1748.002076] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[ 1748.002086] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 1748.002115] usb usb5: root hub lost power or was reset
[ 1748.002139] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[ 1748.002149] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 1748.002179] usb usb6: root hub lost power or was reset
[ 1748.002202] ehci_hcd 0000:00:1d.7: PME# disabled
[ 1748.002902] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[ 1748.002913] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[ 1748.002924] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 1748.002935] ehci_hcd 0000:00:1d.7: PME# disabled
[ 1748.002964] pci 0000:00:1e.0: setting latency timer to 64
[ 1748.003068] ahci 0000:00:1f.2: setting latency timer to 64
[ 1748.003364] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[ 1748.003548] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[ 1748.015331] sd 0:0:0:0: [sda] Starting disk
[ 1748.032690] Registered led device: iwl-phy1:radio
[ 1748.032736] Registered led device: iwl-phy1:assoc
[ 1748.032781] Registered led device: iwl-phy1:RX
[ 1748.032827] Registered led device: iwl-phy1:TX
[ 1748.324121] ata2: SATA link down (SStatus 0 SControl 300)
[ 1749.945131] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1750.017798] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[ 1750.017804] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 1750.017976] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[ 1750.017982] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 1750.028883] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[ 1750.028889] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 1750.029074] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[ 1750.029080] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 1750.029990] ata1.00: configured for UDMA/100
[ 1750.032094] ata1.00: configured for UDMA/100
[ 1750.048117] ata1: EH complete
[ 1750.048193] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[ 1750.048228] sd 0:0:0:0: [sda] Write Protect is off
[ 1750.048232] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1750.048283] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 1750.048337] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[ 1750.048366] sd 0:0:0:0: [sda] Write Protect is off
[ 1750.048371] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1750.048419] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 1751.444121] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[ 1751.692120] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 2
[ 1751.948134] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[ 1752.100384] pci 0000:00:02.0: power state changed by ACPI to D0
[ 1752.100576] pci 0000:00:02.0: power state changed by ACPI to D0
[ 1752.100588] pci 0000:00:02.0: setting latency timer to 64
[ 1752.118429] Restarting tasks ... done.
[ 1753.196560] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[ 1753.494082] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[ 1753.512155] input: TPPS/2 IBM TrackPoint as /class/input/input12
[ 1754.374816] wlan0: deauthenticated (Reason: 7)
[ 1754.389383] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
[ 1754.589038] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 2
[ 1754.591999] wlan0 direct probe responded
[ 1754.592001] wlan0: authenticate with AP 00:14:6c:67:9c:32
[ 1754.594020] wlan0: authenticated
[ 1754.594022] wlan0: associate with AP 00:14:6c:67:9c:32
[ 1754.793037] wlan0: associate with AP 00:14:6c:67:9c:32
[ 1754.801454] wlan0: RX ReassocResp from 00:14:6c:67:9c:32 (capab=3D0x201 =
status=3D0 aid=3D10)
[ 1754.801456] wlan0: associated
[15874.669834] PM: Syncing filesystems ... done.
[15875.683860] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[15875.701248] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[15875.701675] Suspending console(s) (use no_console_suspend to debug)
[15875.716268] pci 0000:00:02.0: power state changed by ACPI to D3
[15876.392209] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[15876.392526] sd 0:0:0:0: [sda] Stopping disk
[15876.816246] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[15876.816323] ehci_hcd 0000:00:1d.7: PME# disabled
[15876.833095] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[15876.833113] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[15876.833180] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[15876.833246] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[15876.848740] HDA Intel 0000:00:1b.0: PCI INT B disabled
[15876.864124] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[15876.864200] ehci_hcd 0000:00:1a.7: PME# disabled
[15876.881202] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[15876.881218] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[15876.881285] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[15876.881351] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[15876.938928] e1000e 0000:00:19.0: PME# enabled
[15876.938946] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[15876.938954] e1000e 0000:00:19.0: PME# enabled
[15876.938958] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[15876.938968] e1000e 0000:00:19.0: PCI INT A disabled
[15876.957830] ACPI: Preparing to enter system sleep state S3
[15876.978957] Disabling non-boot CPUs ...
[15876.981229] CPU 1 is now offline
[15876.981233] SMP alternatives: switching to UP code
[15877.144309] CPU1 is down
[15877.144414] Extended CMOS year: 2000
[15877.144414] Back to C!
[15877.144414] Extended CMOS year: 2000
[15877.144414] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[15877.144414] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[15877.144414] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[15877.144414] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[15877.144414] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[15877.144414] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[15877.144414] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[15877.144414] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[15877.144414] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[15877.144414] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[15877.144414] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[15877.144414] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[15877.144414] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[15877.144414] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[15877.144414] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[15877.144414] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[15877.144414] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[15877.144414] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[15877.144414] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[15877.144414] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[15877.144414] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[15877.144414] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[15877.144414] Enabling non-boot CPUs ...
[15877.144414] SMP alternatives: switching to SMP code
[15877.264988] Booting processor 1 APIC 0x1 ip 0x6000
[15877.136789] Initializing CPU#1
[15877.136789] Calibrating delay using timer specific routine.. 4522.04 Bog=
oMIPS (lpj=3D9044095)
[15877.136789] CPU: L1 I cache: 32K, L1 D cache: 32K
[15877.136789] CPU: L2 cache: 3072K
[15877.136789] [ds] using Core 2/Atom configuration
[15877.136789] CPU: Physical Processor ID: 0
[15877.136789] CPU: Processor Core ID: 1
[15877.136789] CPU1: Thermal monitoring enabled (TM2)
[15877.352541] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[15877.353011] Switched to high resolution mode on CPU 1
[15877.364345] CPU1 is up
[15877.364346] ACPI: Waking up from system sleep state S3
[15877.390681] thinkpad_acpi: EC reports that Thermal Table has changed
[15877.412400] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[15877.462809] pci 0000:00:02.0: PME# disabled
[15877.462815] pci 0000:00:02.1: PME# disabled
[15877.462819] pci 0000:00:03.0: PME# disabled
[15877.462882] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[15877.462888] e1000e 0000:00:19.0: setting latency timer to 64
[15877.462892] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[15877.462896] e1000e 0000:00:19.0: PME# disabled
[15877.462899] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[15877.462903] e1000e 0000:00:19.0: PME# disabled
[15877.462939] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[15877.521460] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[15877.521469] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[15877.521477] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[15877.521502] usb usb1: root hub lost power or was reset
[15877.521524] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[15877.521530] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[15877.521552] usb usb2: root hub lost power or was reset
[15877.522119] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[15877.522128] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[15877.522135] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[15877.522159] usb usb3: root hub lost power or was reset
[15877.522181] ehci_hcd 0000:00:1a.7: PME# disabled
[15877.522984] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[15877.522991] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[15877.522998] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[15877.523005] ehci_hcd 0000:00:1a.7: PME# disabled
[15877.523026] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[15877.523031] HDA Intel 0000:00:1b.0: setting latency timer to 64
[15877.523051] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[15877.523059] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[15877.523067] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[15877.523732] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[15877.523737] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[15877.523744] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[15877.523766] usb usb4: root hub lost power or was reset
[15877.523785] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[15877.523792] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[15877.523813] usb usb5: root hub lost power or was reset
[15877.523831] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[15877.523837] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[15877.523859] usb usb6: root hub lost power or was reset
[15877.523878] ehci_hcd 0000:00:1d.7: PME# disabled
[15877.524590] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[15877.524597] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[15877.524604] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[15877.524611] ehci_hcd 0000:00:1d.7: PME# disabled
[15877.524630] pci 0000:00:1e.0: setting latency timer to 64
[15877.524700] ahci 0000:00:1f.2: setting latency timer to 64
[15877.524896] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[15877.525045] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[15877.536616] sd 0:0:0:0: [sda] Starting disk
[15877.555369] Registered led device: iwl-phy1:radio
[15877.555415] Registered led device: iwl-phy1:assoc
[15877.555461] Registered led device: iwl-phy1:RX
[15877.555506] Registered led device: iwl-phy1:TX
[15877.844283] ata2: SATA link down (SStatus 0 SControl 300)
[15879.076274] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[15879.140330] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[15879.140337] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[15879.140641] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[15879.140648] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[15879.151606] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[15879.151613] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[15879.151926] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[15879.151932] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[15879.152816] ata1.00: configured for UDMA/100
[15879.155387] ata1.00: configured for UDMA/100
[15879.168270] ata1: EH complete
[15879.168374] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[15879.168410] sd 0:0:0:0: [sda] Write Protect is off
[15879.168415] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[15879.168467] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[15879.168527] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[15879.168557] sd 0:0:0:0: [sda] Write Protect is off
[15879.168561] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[15879.168611] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[15880.556292] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[15880.804292] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 2
[15881.060314] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[15881.212795] pci 0000:00:02.0: power state changed by ACPI to D0
[15881.212992] pci 0000:00:02.0: power state changed by ACPI to D0
[15881.213005] pci 0000:00:02.0: setting latency timer to 64
[15881.230457] Restarting tasks ... done.
[15882.387782] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[15882.685906] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[15882.702827] input: TPPS/2 IBM TrackPoint as /class/input/input13
[15883.231370] wlan0: No ProbeResp from current AP 00:14:6c:67:9c:32 - assu=
me out of range
[17335.524527] wlan0: direct probe to AP 00:13:f7:53:df:e5 try 1
[17335.724306] wlan0: direct probe to AP 00:13:f7:53:df:e5 try 2
[17335.924303] wlan0: direct probe to AP 00:13:f7:53:df:e5 try 3
[17336.124085] wlan0: direct probe to AP 00:13:f7:53:df:e5 timed out
[17366.215242] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[17366.215438] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[17366.246913] Registered led device: iwl-phy1:radio
[17366.246971] Registered led device: iwl-phy1:assoc
[17366.247022] Registered led device: iwl-phy1:RX
[17366.247073] Registered led device: iwl-phy1:TX
[17366.276015] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[21229.431304] iwlagn: Radio Frequency Kill Switch is On:
[21229.431309] Kill switch must be turned off for wireless networking to wo=
rk.
[21297.987392] PM: Syncing filesystems ... done.
[21298.818411] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[21298.837181] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[21298.842308] Suspending console(s) (use no_console_suspend to debug)
[21298.856139] pci 0000:00:02.0: power state changed by ACPI to D3
[21299.532357] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[21299.532633] sd 0:0:0:0: [sda] Stopping disk
[21299.964388] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[21299.964466] ehci_hcd 0000:00:1d.7: PME# disabled
[21299.982066] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[21299.982093] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[21299.982162] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[21299.982229] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[21299.982496] HDA Intel 0000:00:1b.0: PCI INT B disabled
[21299.996138] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[21299.996214] ehci_hcd 0000:00:1a.7: PME# disabled
[21300.013495] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[21300.013522] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[21300.013591] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[21300.013657] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[21300.071110] e1000e 0000:00:19.0: PME# enabled
[21300.071144] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[21300.071152] e1000e 0000:00:19.0: PME# enabled
[21300.071157] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[21300.071168] e1000e 0000:00:19.0: PCI INT A disabled
[21300.089338] ACPI: Preparing to enter system sleep state S3
[21300.110004] Disabling non-boot CPUs ...
[21300.112291] CPU 1 is now offline
[21300.112296] SMP alternatives: switching to UP code
[21300.276161] CPU1 is down
[21300.276268] Extended CMOS year: 2000
[21300.276268] Back to C!
[21300.276268] Extended CMOS year: 2000
[21300.276268] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[21300.276268] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[21300.276268] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[21300.276268] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[21300.276268] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[21300.276268] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[21300.276268] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[21300.276268] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[21300.276268] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[21300.276268] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[21300.276268] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[21300.276268] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[21300.276268] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[21300.276268] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[21300.276268] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[21300.276268] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[21300.276268] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[21300.276268] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[21300.276268] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[21300.276268] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[21300.276268] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[21300.276268] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[21300.276268] Enabling non-boot CPUs ...
[21300.276268] SMP alternatives: switching to SMP code
[21300.397267] Booting processor 1 APIC 0x1 ip 0x6000
[21300.264540] Initializing CPU#1
[21300.264540] Calibrating delay using timer specific routine.. 4522.04 Bog=
oMIPS (lpj=3D9044082)
[21300.264540] CPU: L1 I cache: 32K, L1 D cache: 32K
[21300.264540] CPU: L2 cache: 3072K
[21300.264540] [ds] using Core 2/Atom configuration
[21300.264540] CPU: Physical Processor ID: 0
[21300.264540] CPU: Processor Core ID: 1
[21300.264540] CPU1: Thermal monitoring enabled (TM2)
[21300.488522] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[21300.492015] Switched to high resolution mode on CPU 1
[21300.500334] CPU1 is up
[21300.500336] ACPI: Waking up from system sleep state S3
[21300.527194] thinkpad_acpi: EC reports that Thermal Table has changed
[21300.548295] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[21300.605874] pci 0000:00:02.0: PME# disabled
[21300.605880] pci 0000:00:02.1: PME# disabled
[21300.605884] pci 0000:00:03.0: PME# disabled
[21300.605947] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[21300.605953] e1000e 0000:00:19.0: setting latency timer to 64
[21300.605957] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[21300.605961] e1000e 0000:00:19.0: PME# disabled
[21300.605964] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[21300.605968] e1000e 0000:00:19.0: PME# disabled
[21300.606003] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[21300.665353] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[21300.665362] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[21300.665373] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[21300.665405] usb usb1: root hub lost power or was reset
[21300.665432] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[21300.665442] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[21300.665472] usb usb2: root hub lost power or was reset
[21300.666266] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[21300.666275] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[21300.666286] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[21300.666316] usb usb3: root hub lost power or was reset
[21300.666342] ehci_hcd 0000:00:1a.7: PME# disabled
[21300.667165] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[21300.667177] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[21300.667188] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[21300.667199] ehci_hcd 0000:00:1a.7: PME# disabled
[21300.667228] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[21300.667238] HDA Intel 0000:00:1b.0: setting latency timer to 64
[21300.667265] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[21300.667279] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[21300.667292] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[21300.668089] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[21300.668098] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[21300.668108] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[21300.668139] usb usb4: root hub lost power or was reset
[21300.668165] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[21300.668176] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[21300.668205] usb usb5: root hub lost power or was reset
[21300.668232] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[21300.668245] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[21300.668277] usb usb6: root hub lost power or was reset
[21300.668301] ehci_hcd 0000:00:1d.7: PME# disabled
[21300.668971] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[21300.668982] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[21300.668994] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[21300.669009] ehci_hcd 0000:00:1d.7: PME# disabled
[21300.669044] pci 0000:00:1e.0: setting latency timer to 64
[21300.669151] ahci 0000:00:1f.2: setting latency timer to 64
[21300.669447] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[21300.669631] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[21300.669699] iwlagn: Radio disabled by HW RF Kill switch
[21300.670297] sd 0:0:0:0: [sda] Starting disk
[21300.988131] ata2: SATA link down (SStatus 0 SControl 300)
[21302.780124] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[21302.826601] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[21302.826607] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[21302.826745] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[21302.826751] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[21302.837687] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[21302.837693] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[21302.837831] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[21302.837837] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[21302.838750] ata1.00: configured for UDMA/100
[21302.840863] ata1.00: configured for UDMA/100
[21302.856112] ata1: EH complete
[21302.856191] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[21302.856226] sd 0:0:0:0: [sda] Write Protect is off
[21302.856231] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[21302.856282] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[21302.856338] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[21302.856368] sd 0:0:0:0: [sda] Write Protect is off
[21302.856372] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[21302.856422] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[21304.240122] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[21304.488123] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 2
[21304.744120] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[21304.895385] pci 0000:00:02.0: power state changed by ACPI to D0
[21304.895575] pci 0000:00:02.0: power state changed by ACPI to D0
[21304.895587] pci 0000:00:02.0: setting latency timer to 64
[21304.912282] Restarting tasks ... done.
[21306.032408] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[21306.343910] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[21306.372019] input: TPPS/2 IBM TrackPoint as /class/input/input14
[21315.924801] Registered led device: iwl-phy1:radio
[21315.924854] Registered led device: iwl-phy1:assoc
[21315.924902] Registered led device: iwl-phy1:RX
[21315.924950] Registered led device: iwl-phy1:TX
[21322.700142] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
[21322.703349] wlan0 direct probe responded
[21322.703355] wlan0: authenticate with AP 00:14:6c:67:9c:32
[21322.900142] wlan0: authenticate with AP 00:14:6c:67:9c:32
[21322.902208] wlan0: authenticated
[21322.902213] wlan0: associate with AP 00:14:6c:67:9c:32
[21322.909120] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=3D0x601 st=
atus=3D0 aid=3D11)
[21322.909126] wlan0: associated
[21322.914921] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[21333.392112] wlan0: no IPv6 routers present
[43604.112076] usb 8-2: new high speed USB device using ehci_hcd and addres=
s 3
[43604.246775] usb 8-2: configuration #1 chosen from 1 choice
[43604.247419] scsi5 : SCSI emulation for USB Mass Storage devices
[43604.249461] usb-storage: device found at 3
[43604.249465] usb-storage: waiting for device to settle before scanning
[43609.248978] scsi 5:0:0:0: Direct-Access     TinyDisk 2007-02-13       0.=
00 PQ: 0 ANSI: 2
[43609.250936] sd 5:0:0:0: [sdc] 2031615 512-byte hardware sectors: (1.04 G=
B/991 MiB)
[43609.251433] sd 5:0:0:0: [sdc] Write Protect is off
[43609.251440] sd 5:0:0:0: [sdc] Mode Sense: 00 00 00 00
[43609.251445] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[43609.253937] sd 5:0:0:0: [sdc] 2031615 512-byte hardware sectors: (1.04 G=
B/991 MiB)
[43609.254408] sd 5:0:0:0: [sdc] Write Protect is off
[43609.254415] sd 5:0:0:0: [sdc] Mode Sense: 00 00 00 00
[43609.254421] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[43609.254429]  sdc:
[43609.359812] sd 5:0:0:0: [sdc] Attached SCSI removable disk
[43609.360515] usb-storage: device scan complete
[43609.484064] ------------[ cut here ]------------
[43609.484073] WARNING: at drivers/usb/storage/transport.c:584 last_sector_=
hacks+0x103/0x165 [usb_storage]()
[43609.484078] Hardware name: 7458AH8
[43609.484084] sdc: Successful last sector success at 2031614, device 1307:=
0163:0100
[43609.484088] Modules linked in: iwlagn i915 fb drm i2c_algo_bit cfbcopyar=
ea cfbimgblt cfbfillrect rfcomm l2cap bluetooth uinput autofs4 cpufreq_powe=
rsave ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_t=
cp libiscsi_tcp libiscsi scsi_transport_iscsi fuse sha256_generic aes_x86_6=
4 aes_generic cbc dm_crypt dm_mod md_mod loop usb_storage libusual snd_hda_=
codec_conexant arc4 snd_hda_intel ecb snd_hda_codec snd_hwdep snd_pcm snd_s=
eq snd_timer snd_seq_device iwlcore i2c_i801 snd mac80211 i2c_core video so=
undcore snd_page_alloc cfg80211 output ehci_hcd uhci_hcd rtc_cmos rtc_core =
rtc_lib wmi usbcore e1000e intel_agp thinkpad_acpi rfkill hwmon backlight l=
ed_class nvram [last unloaded: iwlagn]
[43609.484217] Pid: 18596, comm: usb-storage Not tainted 2.6.29-rc4-ikn-000=
01-gd5b5623 #9
[43609.484222] Call Trace:
[43609.484240]  [<ffffffff8023568f>] warn_slowpath+0xd3/0x10f
[43609.484284]  [<ffffffffa006aab4>] ? urb_destroy+0x23/0x28 [usbcore]
[43609.484294]  [<ffffffff804c9b06>] ? wait_for_common+0x116/0x131
[43609.484303]  [<ffffffff80231b4f>] ? default_wake_function+0x0/0xf
[43609.484323]  [<ffffffffa01a610f>] ? usb_stor_bulk_transfer_buf+0x7c/0x85=
 [usb_storage]
[43609.484342]  [<ffffffffa01a6754>] ? usb_stor_Bulk_transport+0x13b/0x267 =
[usb_storage]
[43609.484359]  [<ffffffffa01a5b45>] last_sector_hacks+0x103/0x165 [usb_sto=
rage]
[43609.484376]  [<ffffffffa01a64c2>] usb_stor_invoke_transport+0x299/0x2a6 =
[usb_storage]
[43609.484384]  [<ffffffff804c9b06>] ? wait_for_common+0x116/0x131
[43609.484392]  [<ffffffff80231b4f>] ? default_wake_function+0x0/0xf
[43609.484409]  [<ffffffffa01a5971>] usb_stor_transparent_scsi_command+0x9/=
0xb [usb_storage]
[43609.484427]  [<ffffffffa01a7993>] usb_stor_control_thread+0x12e/0x1d3 [u=
sb_storage]
[43609.484444]  [<ffffffffa01a7865>] ? usb_stor_control_thread+0x0/0x1d3 [u=
sb_storage]
[43609.484454]  [<ffffffff802489aa>] kthread+0x49/0x76
[43609.484463]  [<ffffffff8020c5aa>] child_rip+0xa/0x20
[43609.484471]  [<ffffffff80248961>] ? kthread+0x0/0x76
[43609.484477]  [<ffffffff8020c5a0>] ? child_rip+0x0/0x20
[43609.484482] ---[ end trace 40c9516201ee044e ]---
[44097.830908] usb 8-2: USB disconnect, address 3
[45415.469990] PM: Syncing filesystems ... done.
[45416.421390] Freezing user space processes ... (elapsed 0.06 seconds) don=
e.
[45416.483642] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[45416.484096] Suspending console(s) (use no_console_suspend to debug)
[45416.500257] pci 0000:00:02.0: power state changed by ACPI to D3
[45417.176411] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[45417.176515] sd 0:0:0:0: [sda] Stopping disk
[45417.632176] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[45417.632254] ehci_hcd 0000:00:1d.7: PME# disabled
[45417.648737] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[45417.648753] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[45417.648821] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[45417.648888] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[45417.664743] HDA Intel 0000:00:1b.0: PCI INT B disabled
[45417.680126] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[45417.680201] ehci_hcd 0000:00:1a.7: PME# disabled
[45417.697112] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[45417.697128] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[45417.697195] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[45417.697262] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[45417.754930] e1000e 0000:00:19.0: PME# enabled
[45417.754948] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[45417.754956] e1000e 0000:00:19.0: PME# enabled
[45417.754960] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[45417.754970] e1000e 0000:00:19.0: PCI INT A disabled
[45417.774037] ACPI: Preparing to enter system sleep state S3
[45417.795088] Disabling non-boot CPUs ...
[45417.797375] CPU 1 is now offline
[45417.797379] SMP alternatives: switching to UP code
[45417.956180] CPU1 is down
[45417.956286] Extended CMOS year: 2000
[45417.956286] Back to C!
[45417.956286] Extended CMOS year: 2000
[45417.956286] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[45417.956286] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[45417.956286] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[45417.956286] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[45417.956286] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[45417.956286] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[45417.956286] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[45417.956286] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[45417.956286] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[45417.956286] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[45417.956286] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[45417.956286] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[45417.956286] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[45417.956286] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[45417.956286] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[45417.956286] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[45417.956286] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[45417.956286] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[45417.956286] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[45417.956286] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[45417.956286] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[45417.956286] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[45417.956286] Enabling non-boot CPUs ...
[45417.956286] SMP alternatives: switching to SMP code
[45418.077124] Booting processor 1 APIC 0x1 ip 0x6000
[45417.946347] Initializing CPU#1
[45417.946347] Calibrating delay using timer specific routine.. 4522.03 Bog=
oMIPS (lpj=3D9044075)
[45417.946347] CPU: L1 I cache: 32K, L1 D cache: 32K
[45417.946347] CPU: L2 cache: 3072K
[45417.946347] [ds] using Core 2/Atom configuration
[45417.946347] CPU: Physical Processor ID: 0
[45417.946347] CPU: Processor Core ID: 1
[45417.946347] CPU1: Thermal monitoring enabled (TM2)
[45418.168523] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[45418.172014] Switched to high resolution mode on CPU 1
[45418.180339] CPU1 is up
[45418.180341] ACPI: Waking up from system sleep state S3
[45418.206753] thinkpad_acpi: EC reports that Thermal Table has changed
[45418.229080] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[45418.279457] pci 0000:00:02.0: PME# disabled
[45418.279463] pci 0000:00:02.1: PME# disabled
[45418.279467] pci 0000:00:03.0: PME# disabled
[45418.279530] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[45418.279535] e1000e 0000:00:19.0: setting latency timer to 64
[45418.279540] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[45418.279544] e1000e 0000:00:19.0: PME# disabled
[45418.279546] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[45418.279551] e1000e 0000:00:19.0: PME# disabled
[45418.279586] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[45418.336945] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[45418.336954] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[45418.336962] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[45418.336986] usb usb1: root hub lost power or was reset
[45418.337007] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[45418.337014] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[45418.337036] usb usb2: root hub lost power or was reset
[45418.337819] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[45418.337824] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[45418.337831] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[45418.337853] usb usb3: root hub lost power or was reset
[45418.337873] ehci_hcd 0000:00:1a.7: PME# disabled
[45418.338412] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[45418.338419] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[45418.338426] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[45418.338433] ehci_hcd 0000:00:1a.7: PME# disabled
[45418.338452] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[45418.338458] HDA Intel 0000:00:1b.0: setting latency timer to 64
[45418.425675] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[45418.425695] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[45418.425713] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[45418.426727] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[45418.426740] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[45418.426751] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[45418.426782] usb usb4: root hub lost power or was reset
[45418.426809] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[45418.426819] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[45418.426848] usb usb5: root hub lost power or was reset
[45418.426873] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[45418.426883] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[45418.426913] usb usb6: root hub lost power or was reset
[45418.426937] ehci_hcd 0000:00:1d.7: PME# disabled
[45418.427605] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[45418.427616] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[45418.427627] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[45418.427638] ehci_hcd 0000:00:1d.7: PME# disabled
[45418.427670] pci 0000:00:1e.0: setting latency timer to 64
[45418.427777] ahci 0000:00:1f.2: setting latency timer to 64
[45418.428100] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[45418.428288] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[45418.439027] sd 0:0:0:0: [sda] Starting disk
[45418.455338] Registered led device: iwl-phy1:radio
[45418.455387] Registered led device: iwl-phy1:assoc
[45418.455433] Registered led device: iwl-phy1:RX
[45418.455478] Registered led device: iwl-phy1:TX
[45418.744286] ata2: SATA link down (SStatus 0 SControl 300)
[45420.312280] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[45420.392090] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[45420.392097] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[45420.392211] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[45420.392217] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[45420.403153] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[45420.403161] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[45420.403476] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[45420.403483] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[45420.404422] ata1.00: configured for UDMA/100
[45420.406899] ata1.00: configured for UDMA/100
[45420.420262] ata1: EH complete
[45420.420368] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[45420.420405] sd 0:0:0:0: [sda] Write Protect is off
[45420.420410] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[45420.420463] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[45420.420523] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[45420.420554] sd 0:0:0:0: [sda] Write Protect is off
[45420.420559] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[45420.420609] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[45421.808312] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[45422.056384] pm_op(): usb_dev_resume+0x0/0x10 [usbcore] returns -19
[45422.056391] PM: Device 8-6 failed to resume: error -19
[45422.168289] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[45422.319803] pci 0000:00:02.0: power state changed by ACPI to D0
[45422.319999] pci 0000:00:02.0: power state changed by ACPI to D0
[45422.320052] pci 0000:00:02.0: setting latency timer to 64
[45422.337647] Restarting tasks ... <6>usb 8-6: USB disconnect, address 2
[45422.407515] done.
[45423.475628] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[45423.774879] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[45423.794892] input: TPPS/2 IBM TrackPoint as /class/input/input15
[45424.336277] wlan0: No ProbeResp from current AP 00:14:6c:67:9c:32 - assu=
me out of range
[45429.736297] usb 8-6: new high speed USB device using ehci_hcd and addres=
s 4
[45429.879889] usb 8-6: configuration #1 chosen from 1 choice
[45429.894364] scsi6 : SCSI emulation for USB Mass Storage devices
[45429.904796] usb-storage: device found at 4
[45429.904802] usb-storage: waiting for device to settle before scanning
[45434.901508] scsi 6:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[45435.068891] sd 6:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96 G=
B/3.69 GiB)
[45435.069510] sd 6:0:0:0: [sdb] Write Protect is off
[45435.069513] sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[45435.069515] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[45435.071121] sd 6:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96 G=
B/3.69 GiB)
[45435.071741] sd 6:0:0:0: [sdb] Write Protect is off
[45435.071744] sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[45435.071747] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[45435.071751]  sdb: sdb1
[45435.073838] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[45435.074407] usb-storage: device scan complete
[45663.759678] usb 8-6: USB disconnect, address 4
[45684.872293] usb 8-6: new high speed USB device using ehci_hcd and addres=
s 5
[45685.015702] usb 8-6: configuration #1 chosen from 1 choice
[45685.016245] scsi7 : SCSI emulation for USB Mass Storage devices
[45685.026560] usb-storage: device found at 5
[45685.026565] usb-storage: waiting for device to settle before scanning
[45690.026545] scsi 7:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[45690.221592] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[45690.222302] sd 7:0:0:0: [sdb] Write Protect is off
[45690.222310] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[45690.222315] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[45690.225056] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[45690.225670] sd 7:0:0:0: [sdb] Write Protect is off
[45690.225678] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[45690.225684] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[45690.225692]  sdb: sdb1
[45690.230611] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[45690.231186] usb-storage: device scan complete
[46518.908347] PM: Syncing filesystems ... done.
[46519.724057] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[46519.741245] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[46519.745386] Suspending console(s) (use no_console_suspend to debug)
[46519.760279] pci 0000:00:02.0: power state changed by ACPI to D3
[46520.436440] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[46520.436633] sd 0:0:0:0: [sda] Stopping disk
[46520.864395] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[46520.864473] ehci_hcd 0000:00:1d.7: PME# disabled
[46520.881653] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[46520.881680] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[46520.881750] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[46520.881817] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[46520.896776] HDA Intel 0000:00:1b.0: PCI INT B disabled
[46520.912127] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[46520.912202] ehci_hcd 0000:00:1a.7: PME# disabled
[46520.929215] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[46520.929241] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[46520.929311] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[46520.929377] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[46520.987131] e1000e 0000:00:19.0: PME# enabled
[46520.987164] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[46520.987172] e1000e 0000:00:19.0: PME# enabled
[46520.987177] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[46520.987189] e1000e 0000:00:19.0: PCI INT A disabled
[46521.005445] ACPI: Preparing to enter system sleep state S3
[46521.025909] Disabling non-boot CPUs ...
[46521.028179] CPU 1 is now offline
[46521.028182] SMP alternatives: switching to UP code
[46521.216333] CPU1 is down
[46521.216439] Extended CMOS year: 2000
[46521.216439] Back to C!
[46521.216439] Extended CMOS year: 2000
[46521.216439] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[46521.216439] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[46521.216439] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[46521.216439] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[46521.216439] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[46521.216439] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[46521.216439] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[46521.216439] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[46521.216439] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[46521.216439] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[46521.216439] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[46521.216439] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[46521.216439] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[46521.216439] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[46521.216439] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[46521.216439] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[46521.216439] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[46521.216439] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[46521.216439] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[46521.216439] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[46521.216439] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[46521.216439] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[46521.216439] Enabling non-boot CPUs ...
[46521.216439] SMP alternatives: switching to SMP code
[46521.337285] Booting processor 1 APIC 0x1 ip 0x6000
[46521.208801] Initializing CPU#1
[46521.208801] Calibrating delay using timer specific routine.. 4522.01 Bog=
oMIPS (lpj=3D9044023)
[46521.208801] CPU: L1 I cache: 32K, L1 D cache: 32K
[46521.208801] CPU: L2 cache: 3072K
[46521.208801] [ds] using Core 2/Atom configuration
[46521.208801] CPU: Physical Processor ID: 0
[46521.208801] CPU: Processor Core ID: 1
[46521.208801] CPU1: Thermal monitoring enabled (TM2)
[46521.428485] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[46521.429011] Switched to high resolution mode on CPU 1
[46521.440344] CPU1 is up
[46521.440346] ACPI: Waking up from system sleep state S3
[46521.482615] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[46521.532396] pci 0000:00:02.0: PME# disabled
[46521.532400] pci 0000:00:02.1: PME# disabled
[46521.532403] pci 0000:00:03.0: PME# disabled
[46521.532459] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[46521.532463] e1000e 0000:00:19.0: setting latency timer to 64
[46521.532466] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[46521.532470] e1000e 0000:00:19.0: PME# disabled
[46521.532472] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[46521.532475] e1000e 0000:00:19.0: PME# disabled
[46521.532507] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[46521.588825] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[46521.588832] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[46521.588839] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[46521.588864] usb usb1: root hub lost power or was reset
[46521.588885] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[46521.588891] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[46521.588913] usb usb2: root hub lost power or was reset
[46521.589697] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[46521.589702] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[46521.589708] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[46521.589731] usb usb3: root hub lost power or was reset
[46521.589750] ehci_hcd 0000:00:1a.7: PME# disabled
[46521.590232] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[46521.590239] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[46521.590246] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[46521.590253] ehci_hcd 0000:00:1a.7: PME# disabled
[46521.590272] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[46521.590278] HDA Intel 0000:00:1b.0: setting latency timer to 64
[46521.677881] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[46521.677901] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[46521.677919] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[46521.678722] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[46521.678734] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[46521.678745] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[46521.678776] usb usb4: root hub lost power or was reset
[46521.678803] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[46521.678813] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[46521.678842] usb usb5: root hub lost power or was reset
[46521.678867] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[46521.678877] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[46521.678906] usb usb6: root hub lost power or was reset
[46521.678930] ehci_hcd 0000:00:1d.7: PME# disabled
[46521.679595] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[46521.679607] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[46521.679618] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[46521.679629] ehci_hcd 0000:00:1d.7: PME# disabled
[46521.679659] pci 0000:00:1e.0: setting latency timer to 64
[46521.679766] ahci 0000:00:1f.2: setting latency timer to 64
[46521.680088] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[46521.680277] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[46521.691440] sd 0:0:0:0: [sda] Starting disk
[46521.708992] Registered led device: iwl-phy1:radio
[46521.709054] Registered led device: iwl-phy1:assoc
[46521.709100] Registered led device: iwl-phy1:RX
[46521.709147] Registered led device: iwl-phy1:TX
[46521.997284] ata2: SATA link down (SStatus 0 SControl 300)
[46523.453277] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[46523.506373] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[46523.506381] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[46523.506697] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[46523.506703] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[46523.517461] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[46523.517468] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[46523.517783] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[46523.517790] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[46523.518845] ata1.00: configured for UDMA/100
[46523.520975] ata1.00: configured for UDMA/100
[46523.536304] ata1: EH complete
[46523.536402] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[46523.536438] sd 0:0:0:0: [sda] Write Protect is off
[46523.536442] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[46523.536494] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[46523.536553] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[46523.536584] sd 0:0:0:0: [sda] Write Protect is off
[46523.536588] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[46523.536639] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[46524.924311] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[46525.172317] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[46525.324786] pci 0000:00:02.0: power state changed by ACPI to D0
[46525.324982] pci 0000:00:02.0: power state changed by ACPI to D0
[46525.324995] pci 0000:00:02.0: setting latency timer to 64
[46525.436286] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[46525.597311] Restarting tasks ... done.
[46526.662106] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[46526.834942] ready
[46526.836040] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[46526.837032] sd 7:0:0:0: [sdb] Write Protect is off
[46526.837040] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[46526.837045] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[46526.838387] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[46526.839009] sd 7:0:0:0: [sdb] Write Protect is off
[46526.839015] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[46526.839020] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[46526.839027]  sdb: sdb1
[46526.987323] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[46527.007395] input: TPPS/2 IBM TrackPoint as /class/input/input16
[46531.600293] usb 8-1: new high speed USB device using ehci_hcd and addres=
s 6
[46531.747065] usb 8-1: configuration #1 chosen from 1 choice
[46531.812936] usb-storage: probe of 8-1:1.0 failed with error -5
[46531.813558] usb 8-1: USB disconnect, address 6
[46532.108317] usb 8-1: new high speed USB device using ehci_hcd and addres=
s 7
[46532.253875] usb 8-1: configuration #1 chosen from 1 choice
[46532.299011] scsi9 : SCSI emulation for USB Mass Storage devices
[46532.299474] usb-storage: device found at 7
[46532.299479] usb-storage: waiting for device to settle before scanning
[46532.630128] usbcore: registered new interface driver usbserial
[46532.630132] usbserial: USB Serial Driver core
[46532.672043] USB Serial support registered for Sierra USB modem
[46532.672115] sierra 8-1:1.0: Sierra USB modem converter detected
[46532.672699] usb 8-1: Sierra USB modem converter now attached to ttyUSB0
[46532.672729] sierra 8-1:1.1: Sierra USB modem converter detected
[46532.674793] usb 8-1: Sierra USB modem converter now attached to ttyUSB1
[46532.674823] sierra 8-1:1.2: Sierra USB modem converter detected
[46532.675269] usb 8-1: Sierra USB modem converter now attached to ttyUSB2
[46532.675295] sierra 8-1:1.3: Sierra USB modem converter detected
[46532.676175] usb 8-1: Sierra USB modem converter now attached to ttyUSB3
[46532.676204] sierra 8-1:1.4: Sierra USB modem converter detected
[46532.677171] usb 8-1: Sierra USB modem converter now attached to ttyUSB4
[46532.677202] sierra 8-1:1.5: Sierra USB modem converter detected
[46532.678185] usb 8-1: Sierra USB modem converter now attached to ttyUSB5
[46532.678215] sierra 8-1:1.6: Sierra USB modem converter detected
[46532.679157] usb 8-1: Sierra USB modem converter now attached to ttyUSB6
[46532.679200] usbcore: registered new interface driver sierra
[46532.679205] sierra: v.1.3.2:USB Driver for Sierra Wireless USB modems
[46537.302096] scsi 9:0:0:0: Direct-Access     SWI      SD Card          2.=
31 PQ: 0 ANSI: 2
[46537.308904] sd 9:0:0:0: [sdc] Attached SCSI removable disk
[46537.311649] usb-storage: device scan complete
[46541.068891] PPP generic driver version 2.4.2
[46541.382750] PPP BSD Compression module registered
[46541.529475] PPP Deflate Compression module registered
[46655.617322] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[46655.617520] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[46655.644815] Registered led device: iwl-phy1:radio
[46655.644883] Registered led device: iwl-phy1:assoc
[46655.644933] Registered led device: iwl-phy1:RX
[46655.644984] Registered led device: iwl-phy1:TX
[46655.666316] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[46813.745632] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[46813.800378] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[46813.802269] ADDRCONF(NETDEV_UP): eth0: link is not ready
[46915.683704] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[46915.683904] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[46915.683981] iwlagn: Radio disabled by HW RF Kill switch
[46915.698302] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[47577.570082] usb 8-1: USB disconnect, address 7
[47577.571325] sierra ttyUSB0: Sierra USB modem converter now disconnected =
=66rom ttyUSB0
[47577.571393] sierra 8-1:1.0: device disconnected
[47577.572829] sierra ttyUSB1: Sierra USB modem converter now disconnected =
=66rom ttyUSB1
[47577.572879] sierra 8-1:1.1: device disconnected
[47577.573694] sierra ttyUSB2: Sierra USB modem converter now disconnected =
=66rom ttyUSB2
[47577.573737] sierra 8-1:1.2: device disconnected
[47577.574141] sierra 8-1:1.3: device disconnected
[47577.574811] sierra ttyUSB4: Sierra USB modem converter now disconnected =
=66rom ttyUSB4
[47577.575482] sierra 8-1:1.4: device disconnected
[47577.576355] sierra ttyUSB5: Sierra USB modem converter now disconnected =
=66rom ttyUSB5
[47577.576398] sierra 8-1:1.5: device disconnected
[47577.577067] sierra ttyUSB6: Sierra USB modem converter now disconnected =
=66rom ttyUSB6
[47577.577109] sierra 8-1:1.6: device disconnected
[47582.931477] sierra ttyUSB3: Sierra USB modem converter now disconnected =
=66rom ttyUSB3
[47616.546721] PM: Syncing filesystems ... done.
[47617.363896] Freezing user space processes ... (elapsed 0.02 seconds) don=
e.
[47617.385182] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[47617.385852] Suspending console(s) (use no_console_suspend to debug)
[47617.400180] pci 0000:00:02.0: power state changed by ACPI to D3
[47618.076542] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[47618.076879] sd 0:0:0:0: [sda] Stopping disk
[47618.492387] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[47618.492465] ehci_hcd 0000:00:1d.7: PME# disabled
[47618.509174] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[47618.509201] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[47618.509270] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[47618.509337] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[47618.524752] HDA Intel 0000:00:1b.0: PCI INT B disabled
[47618.540125] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[47618.540200] ehci_hcd 0000:00:1a.7: PME# disabled
[47618.557038] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[47618.557063] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[47618.557131] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[47618.557197] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[47618.615116] e1000e 0000:00:19.0: PME# enabled
[47618.615150] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[47618.615158] e1000e 0000:00:19.0: PME# enabled
[47618.615162] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[47618.615174] e1000e 0000:00:19.0: PCI INT A disabled
[47618.633750] ACPI: Preparing to enter system sleep state S3
[47618.655845] Disabling non-boot CPUs ...
[47618.658157] CPU 1 is now offline
[47618.658161] SMP alternatives: switching to UP code
[47618.832163] CPU1 is down
[47618.832269] Extended CMOS year: 2000
[47618.832269] Back to C!
[47618.832269] Extended CMOS year: 2000
[47618.832269] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[47618.832269] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[47618.832269] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[47618.832269] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[47618.832269] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[47618.832269] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[47618.832269] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[47618.832269] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[47618.832269] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[47618.832269] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[47618.832269] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[47618.832269] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[47618.832269] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[47618.832269] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[47618.832269] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[47618.832269] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[47618.832269] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[47618.832269] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[47618.832269] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[47618.832269] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[47618.832269] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[47618.832269] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[47618.832269] Enabling non-boot CPUs ...
[47618.832269] SMP alternatives: switching to SMP code
[47618.955873] Booting processor 1 APIC 0x1 ip 0x6000
[47618.822996] Initializing CPU#1
[47618.822996] Calibrating delay using timer specific routine.. 4522.02 Bog=
oMIPS (lpj=3D9044049)
[47618.822996] CPU: L1 I cache: 32K, L1 D cache: 32K
[47618.822996] CPU: L2 cache: 3072K
[47618.822996] [ds] using Core 2/Atom configuration
[47618.822996] CPU: Physical Processor ID: 0
[47618.822996] CPU: Processor Core ID: 1
[47618.822996] CPU1: Thermal monitoring enabled (TM2)
[47619.044552] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[47619.048015] Switched to high resolution mode on CPU 1
[47619.056353] CPU1 is up
[47619.056355] ACPI: Waking up from system sleep state S3
[47619.098418] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[47619.156354] pci 0000:00:02.0: PME# disabled
[47619.156359] pci 0000:00:02.1: PME# disabled
[47619.156363] pci 0000:00:03.0: PME# disabled
[47619.156427] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[47619.156432] e1000e 0000:00:19.0: setting latency timer to 64
[47619.156437] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[47619.156441] e1000e 0000:00:19.0: PME# disabled
[47619.156443] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[47619.156448] e1000e 0000:00:19.0: PME# disabled
[47619.156484] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[47619.212893] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[47619.212902] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[47619.212909] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[47619.212933] usb usb1: root hub lost power or was reset
[47619.212954] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[47619.212960] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[47619.212983] usb usb2: root hub lost power or was reset
[47619.213798] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[47619.213803] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[47619.213809] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[47619.213832] usb usb3: root hub lost power or was reset
[47619.213851] ehci_hcd 0000:00:1a.7: PME# disabled
[47619.214696] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[47619.214703] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[47619.214710] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[47619.214717] ehci_hcd 0000:00:1a.7: PME# disabled
[47619.214736] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[47619.214742] HDA Intel 0000:00:1b.0: setting latency timer to 64
[47619.302169] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[47619.302189] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[47619.302207] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[47619.303425] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[47619.303438] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[47619.303449] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[47619.303480] usb usb4: root hub lost power or was reset
[47619.303506] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[47619.303517] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[47619.303546] usb usb5: root hub lost power or was reset
[47619.303570] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[47619.303581] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[47619.303610] usb usb6: root hub lost power or was reset
[47619.303635] ehci_hcd 0000:00:1d.7: PME# disabled
[47619.304372] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[47619.304384] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[47619.304395] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[47619.304406] ehci_hcd 0000:00:1d.7: PME# disabled
[47619.304438] pci 0000:00:1e.0: setting latency timer to 64
[47619.304544] ahci 0000:00:1f.2: setting latency timer to 64
[47619.304841] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[47619.305029] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[47619.305103] iwlagn: Radio disabled by HW RF Kill switch
[47619.305700] sd 0:0:0:0: [sda] Starting disk
[47619.624289] ata2: SATA link down (SStatus 0 SControl 300)
[47621.136287] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[47621.202165] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[47621.202173] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[47621.202356] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[47621.202363] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[47621.213254] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[47621.213262] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[47621.213446] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[47621.213452] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[47621.214570] ata1.00: configured for UDMA/100
[47621.216854] ata1.00: configured for UDMA/100
[47621.232274] ata1: EH complete
[47621.232381] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[47621.232418] sd 0:0:0:0: [sda] Write Protect is off
[47621.232423] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[47621.232475] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[47621.232534] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[47621.232564] sd 0:0:0:0: [sda] Write Protect is off
[47621.232568] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[47621.232618] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[47622.628284] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[47622.876282] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[47623.027794] pci 0000:00:02.0: power state changed by ACPI to D0
[47623.027990] pci 0000:00:02.0: power state changed by ACPI to D0
[47623.028043] pci 0000:00:02.0: setting latency timer to 64
[47623.140313] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[47623.301031] Restarting tasks ... done.
[47624.402440] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[47624.538108] ready
[47624.539098] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[47624.539889] sd 7:0:0:0: [sdb] Write Protect is off
[47624.539900] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[47624.539905] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[47624.541728] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[47624.542477] sd 7:0:0:0: [sdb] Write Protect is off
[47624.542483] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[47624.542488] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[47624.542495]  sdb: sdb1
[47624.738799] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[47624.760184] input: TPPS/2 IBM TrackPoint as /class/input/input17
[55609.446540] PM: Syncing filesystems ... done.
[55610.256336] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[55610.273244] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[55610.280454] Suspending console(s) (use no_console_suspend to debug)
[55610.296296] pci 0000:00:02.0: power state changed by ACPI to D3
[55610.972555] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[55610.972873] sd 0:0:0:0: [sda] Stopping disk
[55611.388422] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[55611.388500] ehci_hcd 0000:00:1d.7: PME# disabled
[55611.405136] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[55611.405163] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[55611.405233] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[55611.405300] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[55611.420746] HDA Intel 0000:00:1b.0: PCI INT B disabled
[55611.436128] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[55611.436203] ehci_hcd 0000:00:1a.7: PME# disabled
[55611.453286] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[55611.453312] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[55611.453382] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[55611.453449] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[55611.511110] e1000e 0000:00:19.0: PME# enabled
[55611.511143] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[55611.511151] e1000e 0000:00:19.0: PME# enabled
[55611.511156] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[55611.511168] e1000e 0000:00:19.0: PCI INT A disabled
[55611.530243] ACPI: Preparing to enter system sleep state S3
[55611.551778] Disabling non-boot CPUs ...
[55611.554064] CPU 1 is now offline
[55611.554069] SMP alternatives: switching to UP code
[55611.720161] CPU1 is down
[55611.720267] Extended CMOS year: 2000
[55611.720267] Back to C!
[55611.720267] Extended CMOS year: 2000
[55611.720267] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[55611.720267] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[55611.720267] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[55611.720267] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[55611.720267] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55611.720267] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55611.720267] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55611.720267] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[55611.720267] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[55611.720267] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[55611.720267] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[55611.720267] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[55611.720267] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55611.720267] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55611.720267] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55611.720267] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[55611.720267] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[55611.720267] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[55611.720267] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[55611.720267] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[55611.720267] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[55611.720267] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[55611.720267] Enabling non-boot CPUs ...
[55611.720267] SMP alternatives: switching to SMP code
[55611.844349] Booting processor 1 APIC 0x1 ip 0x6000
[55611.708219] Initializing CPU#1
[55611.708219] Calibrating delay using timer specific routine.. 4521.99 Bog=
oMIPS (lpj=3D9043996)
[55611.708219] CPU: L1 I cache: 32K, L1 D cache: 32K
[55611.708219] CPU: L2 cache: 3072K
[55611.708219] [ds] using Core 2/Atom configuration
[55611.708219] CPU: Physical Processor ID: 0
[55611.708219] CPU: Processor Core ID: 1
[55611.708219] CPU1: Thermal monitoring enabled (TM2)
[55611.932492] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[55611.936015] Switched to high resolution mode on CPU 1
[55611.944337] CPU1 is up
[55611.944339] ACPI: Waking up from system sleep state S3
[55611.986307] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[55612.045026] pci 0000:00:02.0: PME# disabled
[55612.045032] pci 0000:00:02.1: PME# disabled
[55612.045038] pci 0000:00:03.0: PME# disabled
[55612.045104] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[55612.045109] e1000e 0000:00:19.0: setting latency timer to 64
[55612.045114] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[55612.045118] e1000e 0000:00:19.0: PME# disabled
[55612.045120] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[55612.045125] e1000e 0000:00:19.0: PME# disabled
[55612.045160] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[55612.101258] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[55612.101273] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[55612.101285] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[55612.101318] usb usb1: root hub lost power or was reset
[55612.101347] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[55612.101357] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[55612.101387] usb usb2: root hub lost power or was reset
[55612.102220] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[55612.102229] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[55612.102239] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[55612.102269] usb usb3: root hub lost power or was reset
[55612.102295] ehci_hcd 0000:00:1a.7: PME# disabled
[55612.102945] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[55612.102957] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[55612.102968] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[55612.102979] ehci_hcd 0000:00:1a.7: PME# disabled
[55612.103008] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[55612.103019] HDA Intel 0000:00:1b.0: setting latency timer to 64
[55612.190382] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[55612.190402] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[55612.190420] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[55612.191323] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[55612.191335] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[55612.191346] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[55612.191377] usb usb4: root hub lost power or was reset
[55612.191403] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[55612.191414] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[55612.191443] usb usb5: root hub lost power or was reset
[55612.191468] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[55612.191478] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[55612.191507] usb usb6: root hub lost power or was reset
[55612.191531] ehci_hcd 0000:00:1d.7: PME# disabled
[55612.192213] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[55612.192224] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[55612.192235] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[55612.192246] ehci_hcd 0000:00:1d.7: PME# disabled
[55612.192278] pci 0000:00:1e.0: setting latency timer to 64
[55612.192383] ahci 0000:00:1f.2: setting latency timer to 64
[55612.192680] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[55612.192870] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[55612.192943] iwlagn: Radio disabled by HW RF Kill switch
[55612.193540] sd 0:0:0:0: [sda] Starting disk
[55612.512281] ata2: SATA link down (SStatus 0 SControl 300)
[55614.248283] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[55614.350203] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[55614.350211] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[55614.350394] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[55614.350400] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[55614.361293] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[55614.361302] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[55614.361484] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[55614.361490] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[55614.362615] ata1.00: configured for UDMA/100
[55614.364897] ata1.00: configured for UDMA/100
[55614.380274] ata1: EH complete
[55614.380380] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[55614.380416] sd 0:0:0:0: [sda] Write Protect is off
[55614.380421] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[55614.380474] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[55614.380533] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[55614.380563] sd 0:0:0:0: [sda] Write Protect is off
[55614.380567] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[55614.380617] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[55615.764290] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[55616.012301] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[55616.164786] pci 0000:00:02.0: power state changed by ACPI to D0
[55616.164983] pci 0000:00:02.0: power state changed by ACPI to D0
[55616.164996] pci 0000:00:02.0: setting latency timer to 64
[55616.276319] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[55616.437019] Restarting tasks ... done.
[55617.537569] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[55617.645144] ready
[55617.646132] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[55617.647136] sd 7:0:0:0: [sdb] Write Protect is off
[55617.647146] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[55617.647151] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[55617.649016] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[55617.649638] sd 7:0:0:0: [sdb] Write Protect is off
[55617.649644] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[55617.649648] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[55617.649657]  sdb: sdb1
[55617.845748] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[55617.864057] input: TPPS/2 IBM TrackPoint as /class/input/input18
[55695.748207] PM: Syncing filesystems ... done.
[55696.500555] Freezing user space processes ... (elapsed 0.03 seconds) don=
e.
[55696.533249] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[55696.533682] Suspending console(s) (use no_console_suspend to debug)
[55696.548297] pci 0000:00:02.0: power state changed by ACPI to D3
[55697.224539] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[55697.225178] sd 0:0:0:0: [sda] Stopping disk
[55697.644386] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[55697.644464] ehci_hcd 0000:00:1d.7: PME# disabled
[55697.661407] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[55697.661434] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[55697.661503] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[55697.661570] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[55697.676750] HDA Intel 0000:00:1b.0: PCI INT B disabled
[55697.692127] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[55697.692202] ehci_hcd 0000:00:1a.7: PME# disabled
[55697.709362] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[55697.709388] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[55697.709457] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[55697.709523] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[55697.767109] e1000e 0000:00:19.0: PME# enabled
[55697.767143] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[55697.767151] e1000e 0000:00:19.0: PME# enabled
[55697.767156] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[55697.767167] e1000e 0000:00:19.0: PCI INT A disabled
[55697.785523] ACPI: Preparing to enter system sleep state S3
[55697.805682] Disabling non-boot CPUs ...
[55697.908065] CPU 1 is now offline
[55697.908070] SMP alternatives: switching to UP code
[55698.048159] CPU1 is down
[55698.048265] Extended CMOS year: 2000
[55698.048265] Back to C!
[55698.048265] Extended CMOS year: 2000
[55698.048265] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[55698.048265] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[55698.048265] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[55698.048265] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[55698.048265] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55698.048265] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55698.048265] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55698.048265] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[55698.048265] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[55698.048265] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[55698.048265] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[55698.048265] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[55698.048265] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55698.048265] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55698.048265] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[55698.048265] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[55698.048265] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[55698.048265] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[55698.048265] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[55698.048265] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[55698.048265] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[55698.048265] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[55698.048265] Enabling non-boot CPUs ...
[55698.048265] SMP alternatives: switching to SMP code
[55698.172652] Booting processor 1 APIC 0x1 ip 0x6000
[55698.039695] Initializing CPU#1
[55698.039695] Calibrating delay using timer specific routine.. 4521.99 Bog=
oMIPS (lpj=3D9043989)
[55698.039695] CPU: L1 I cache: 32K, L1 D cache: 32K
[55698.039695] CPU: L2 cache: 3072K
[55698.039695] [ds] using Core 2/Atom configuration
[55698.039695] CPU: Physical Processor ID: 0
[55698.039695] CPU: Processor Core ID: 1
[55698.039695] CPU1: Thermal monitoring enabled (TM2)
[55698.260535] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[55698.264015] Switched to high resolution mode on CPU 1
[55698.272342] CPU1 is up
[55698.272344] ACPI: Waking up from system sleep state S3
[55698.316831] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[55698.368509] pci 0000:00:02.0: PME# disabled
[55698.368515] pci 0000:00:02.1: PME# disabled
[55698.368518] pci 0000:00:03.0: PME# disabled
[55698.368582] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[55698.368588] e1000e 0000:00:19.0: setting latency timer to 64
[55698.368592] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[55698.368596] e1000e 0000:00:19.0: PME# disabled
[55698.368599] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[55698.368603] e1000e 0000:00:19.0: PME# disabled
[55698.368639] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[55698.425246] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[55698.425261] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[55698.425273] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[55698.425305] usb usb1: root hub lost power or was reset
[55698.425334] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[55698.425345] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[55698.425374] usb usb2: root hub lost power or was reset
[55698.426282] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[55698.426291] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[55698.426302] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[55698.426332] usb usb3: root hub lost power or was reset
[55698.426358] ehci_hcd 0000:00:1a.7: PME# disabled
[55698.427224] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[55698.427236] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[55698.427247] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[55698.427258] ehci_hcd 0000:00:1a.7: PME# disabled
[55698.427287] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[55698.427297] HDA Intel 0000:00:1b.0: setting latency timer to 64
[55698.514652] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[55698.514672] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[55698.514690] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[55698.515604] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[55698.515617] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[55698.515627] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[55698.515658] usb usb4: root hub lost power or was reset
[55698.515685] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[55698.515696] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[55698.515725] usb usb5: root hub lost power or was reset
[55698.515750] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[55698.515760] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[55698.515789] usb usb6: root hub lost power or was reset
[55698.515814] ehci_hcd 0000:00:1d.7: PME# disabled
[55698.516522] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[55698.516534] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[55698.516545] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[55698.516556] ehci_hcd 0000:00:1d.7: PME# disabled
[55698.516588] pci 0000:00:1e.0: setting latency timer to 64
[55698.516694] ahci 0000:00:1f.2: setting latency timer to 64
[55698.516992] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[55698.517180] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[55698.517254] iwlagn: Radio disabled by HW RF Kill switch
[55698.517851] sd 0:0:0:0: [sda] Starting disk
[55698.836289] ata2: SATA link down (SStatus 0 SControl 300)
[55700.292284] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[55700.340911] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[55700.340919] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[55700.341105] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[55700.341111] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[55700.351998] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[55700.352041] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[55700.352182] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[55700.352188] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[55700.353377] ata1.00: configured for UDMA/100
[55700.355881] ata1.00: configured for UDMA/100
[55700.368270] ata1: EH complete
[55700.368379] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[55700.368416] sd 0:0:0:0: [sda] Write Protect is off
[55700.368421] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[55700.368474] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[55700.368533] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[55700.368564] sd 0:0:0:0: [sda] Write Protect is off
[55700.368569] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[55700.368619] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[55701.768284] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[55702.016316] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[55702.168785] pci 0000:00:02.0: power state changed by ACPI to D0
[55702.168981] pci 0000:00:02.0: power state changed by ACPI to D0
[55702.168994] pci 0000:00:02.0: setting latency timer to 64
[55702.280323] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[55702.440905] Restarting tasks ... done.
[55703.533535] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[55703.679250] ready
[55703.680027] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[55703.680746] sd 7:0:0:0: [sdb] Write Protect is off
[55703.680753] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[55703.680758] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[55703.682101] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[55703.682729] sd 7:0:0:0: [sdb] Write Protect is off
[55703.682735] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[55703.682740] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[55703.682747]  sdb: sdb1
[55703.859041] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[55703.878165] input: TPPS/2 IBM TrackPoint as /class/input/input19
[55710.968285] usb 8-1: new high speed USB device using ehci_hcd and addres=
s 8
[55711.114779] usb 8-1: configuration #1 chosen from 1 choice
[55711.169582] usb-storage: probe of 8-1:1.0 failed with error -5
[55711.170033] usb 8-1: USB disconnect, address 8
[55711.444291] usb 8-1: new high speed USB device using ehci_hcd and addres=
s 9
[55711.589965] usb 8-1: configuration #1 chosen from 1 choice
[55711.633992] sierra 8-1:1.0: Sierra USB modem converter detected
[55711.635049] usb 8-1: Sierra USB modem converter now attached to ttyUSB0
[55711.635359] sierra 8-1:1.1: Sierra USB modem converter detected
[55711.635877] usb 8-1: Sierra USB modem converter now attached to ttyUSB1
[55711.636738] sierra 8-1:1.2: Sierra USB modem converter detected
[55711.637149] usb 8-1: Sierra USB modem converter now attached to ttyUSB2
[55711.637439] sierra 8-1:1.3: Sierra USB modem converter detected
[55711.638126] usb 8-1: Sierra USB modem converter now attached to ttyUSB3
[55711.638514] sierra 8-1:1.4: Sierra USB modem converter detected
[55711.639116] usb 8-1: Sierra USB modem converter now attached to ttyUSB4
[55711.639494] sierra 8-1:1.5: Sierra USB modem converter detected
[55711.640755] usb 8-1: Sierra USB modem converter now attached to ttyUSB5
[55711.641139] sierra 8-1:1.6: Sierra USB modem converter detected
[55711.641504] usb 8-1: Sierra USB modem converter now attached to ttyUSB6
[55711.668071] scsi11 : SCSI emulation for USB Mass Storage devices
[55711.698186] usb-storage: device found at 9
[55711.698192] usb-storage: waiting for device to settle before scanning
[55716.699781] scsi 11:0:0:0: Direct-Access     SWI      SD Card          2=
=2E31 PQ: 0 ANSI: 2
[55716.704693] sd 11:0:0:0: [sdc] Attached SCSI removable disk
[55716.705266] usb-storage: device scan complete
[57064.932555] usb 8-1: USB disconnect, address 9
[57064.943801] sierra ttyUSB0: Sierra USB modem converter now disconnected =
=66rom ttyUSB0
[57064.943844] sierra 8-1:1.0: device disconnected
[57064.944744] sierra ttyUSB1: Sierra USB modem converter now disconnected =
=66rom ttyUSB1
[57064.944784] sierra 8-1:1.1: device disconnected
[57064.945348] sierra ttyUSB2: Sierra USB modem converter now disconnected =
=66rom ttyUSB2
[57064.945385] sierra 8-1:1.2: device disconnected
[57064.946043] sierra ttyUSB3: Sierra USB modem converter now disconnected =
=66rom ttyUSB3
[57064.946082] sierra 8-1:1.3: device disconnected
[57064.946723] sierra ttyUSB4: Sierra USB modem converter now disconnected =
=66rom ttyUSB4
[57064.946763] sierra 8-1:1.4: device disconnected
[57064.947409] sierra ttyUSB5: Sierra USB modem converter now disconnected =
=66rom ttyUSB5
[57064.947448] sierra 8-1:1.5: device disconnected
[57064.948920] sierra ttyUSB6: Sierra USB modem converter now disconnected =
=66rom ttyUSB6
[57064.948960] sierra 8-1:1.6: device disconnected
[57067.725840] PM: Syncing filesystems ... done.
[57068.813115] Freezing user space processes ... (elapsed 0.02 seconds) don=
e.
[57068.837252] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[57068.837690] Suspending console(s) (use no_console_suspend to debug)
[57068.852291] pci 0000:00:02.0: power state changed by ACPI to D3
[57069.532621] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[57069.532909] sd 0:0:0:0: [sda] Stopping disk
[57069.948389] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[57069.948468] ehci_hcd 0000:00:1d.7: PME# disabled
[57069.965682] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[57069.965709] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[57069.965779] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[57069.965846] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[57069.980744] HDA Intel 0000:00:1b.0: PCI INT B disabled
[57069.996131] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[57069.996206] ehci_hcd 0000:00:1a.7: PME# disabled
[57070.012863] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[57070.012882] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[57070.012950] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[57070.013017] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[57070.071112] e1000e 0000:00:19.0: PME# enabled
[57070.071144] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[57070.071152] e1000e 0000:00:19.0: PME# enabled
[57070.071156] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[57070.071168] e1000e 0000:00:19.0: PCI INT A disabled
[57070.089239] ACPI: Preparing to enter system sleep state S3
[57070.110462] Disabling non-boot CPUs ...
[57070.112747] CPU 1 is now offline
[57070.112752] SMP alternatives: switching to UP code
[57070.280161] CPU1 is down
[57070.280267] Extended CMOS year: 2000
[57070.280267] Back to C!
[57070.280267] Extended CMOS year: 2000
[57070.280267] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[57070.280267] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[57070.280267] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[57070.280267] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[57070.280267] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[57070.280267] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[57070.280267] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[57070.280267] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[57070.280267] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[57070.280267] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[57070.280267] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[57070.280267] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[57070.280267] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[57070.280267] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[57070.280267] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[57070.280267] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[57070.280267] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[57070.280267] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[57070.280267] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[57070.280267] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[57070.280267] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[57070.280267] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[57070.280267] Enabling non-boot CPUs ...
[57070.280267] SMP alternatives: switching to SMP code
[57070.404413] Booting processor 1 APIC 0x1 ip 0x6000
[57070.268346] Initializing CPU#1
[57070.268346] Calibrating delay using timer specific routine.. 4522.01 Bog=
oMIPS (lpj=3D9044029)
[57070.268346] CPU: L1 I cache: 32K, L1 D cache: 32K
[57070.268346] CPU: L2 cache: 3072K
[57070.268346] [ds] using Core 2/Atom configuration
[57070.268346] CPU: Physical Processor ID: 0
[57070.268346] CPU: Processor Core ID: 1
[57070.268346] CPU1: Thermal monitoring enabled (TM2)
[57070.492492] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[57070.496013] Switched to high resolution mode on CPU 1
[57070.504336] CPU1 is up
[57070.504338] ACPI: Waking up from system sleep state S3
[57070.547117] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[57070.598219] pci 0000:00:02.0: PME# disabled
[57070.598224] pci 0000:00:02.1: PME# disabled
[57070.598228] pci 0000:00:03.0: PME# disabled
[57070.598291] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[57070.598297] e1000e 0000:00:19.0: setting latency timer to 64
[57070.598301] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[57070.598306] e1000e 0000:00:19.0: PME# disabled
[57070.598308] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[57070.598312] e1000e 0000:00:19.0: PME# disabled
[57070.598348] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[57070.657083] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[57070.657098] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[57070.657110] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[57070.657143] usb usb1: root hub lost power or was reset
[57070.657171] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[57070.657181] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[57070.657211] usb usb2: root hub lost power or was reset
[57070.658233] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[57070.658243] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[57070.658253] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[57070.658283] usb usb3: root hub lost power or was reset
[57070.658309] ehci_hcd 0000:00:1a.7: PME# disabled
[57070.659246] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[57070.659258] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[57070.659269] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[57070.659280] ehci_hcd 0000:00:1a.7: PME# disabled
[57070.659310] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[57070.659320] HDA Intel 0000:00:1b.0: setting latency timer to 64
[57070.746942] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[57070.746961] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[57070.746979] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[57070.747808] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[57070.747820] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[57070.747831] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[57070.747862] usb usb4: root hub lost power or was reset
[57070.747889] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[57070.747899] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[57070.747929] usb usb5: root hub lost power or was reset
[57070.747953] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[57070.747963] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[57070.747993] usb usb6: root hub lost power or was reset
[57070.748034] ehci_hcd 0000:00:1d.7: PME# disabled
[57070.748908] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[57070.748920] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[57070.748931] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[57070.748942] ehci_hcd 0000:00:1d.7: PME# disabled
[57070.748974] pci 0000:00:1e.0: setting latency timer to 64
[57070.749093] ahci 0000:00:1f.2: setting latency timer to 64
[57070.749388] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[57070.749577] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[57070.749650] iwlagn: Radio disabled by HW RF Kill switch
[57070.750247] sd 0:0:0:0: [sda] Starting disk
[57071.068287] ata2: SATA link down (SStatus 0 SControl 300)
[57072.692279] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[57072.782943] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[57072.782951] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[57072.783071] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[57072.783078] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[57072.794028] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[57072.794035] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[57072.794155] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[57072.794162] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[57072.795267] ata1.00: configured for UDMA/100
[57072.797892] ata1.00: configured for UDMA/100
[57072.812263] ata1: EH complete
[57072.812368] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[57072.812405] sd 0:0:0:0: [sda] Write Protect is off
[57072.812410] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[57072.812463] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[57072.812523] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[57072.812553] sd 0:0:0:0: [sda] Write Protect is off
[57072.812557] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[57072.812607] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[57074.196313] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[57074.444316] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[57074.596805] pci 0000:00:02.0: power state changed by ACPI to D0
[57074.597002] pci 0000:00:02.0: power state changed by ACPI to D0
[57074.597015] pci 0000:00:02.0: setting latency timer to 64
[57074.708312] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[57074.868887] Restarting tasks ... done.
[57076.019449] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[57076.106945] ready
[57076.107926] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[57076.108753] sd 7:0:0:0: [sdb] Write Protect is off
[57076.108760] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[57076.108765] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[57076.110886] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[57076.111505] sd 7:0:0:0: [sdb] Write Protect is off
[57076.111511] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[57076.111516] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[57076.111523]  sdb: sdb1
[57076.340329] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[57076.362031] input: TPPS/2 IBM TrackPoint as /class/input/input20
[58692.532150] PM: Syncing filesystems ... done.
[58693.344868] Freezing user space processes ... (elapsed 0.07 seconds) don=
e.
[58693.417950] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[58693.418274] Suspending console(s) (use no_console_suspend to debug)
[58693.432176] pci 0000:00:02.0: power state changed by ACPI to D3
[58694.112593] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[58694.113280] sd 0:0:0:0: [sda] Stopping disk
[58694.536394] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[58694.536472] ehci_hcd 0000:00:1d.7: PME# disabled
[58694.553820] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[58694.553846] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[58694.553916] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[58694.553983] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[58694.568753] HDA Intel 0000:00:1b.0: PCI INT B disabled
[58694.584149] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[58694.584225] ehci_hcd 0000:00:1a.7: PME# disabled
[58694.600984] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[58694.601009] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[58694.601077] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[58694.601144] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[58694.659133] e1000e 0000:00:19.0: PME# enabled
[58694.659166] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[58694.659174] e1000e 0000:00:19.0: PME# enabled
[58694.659179] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[58694.659191] e1000e 0000:00:19.0: PCI INT A disabled
[58694.677748] ACPI: Preparing to enter system sleep state S3
[58694.698933] Disabling non-boot CPUs ...
[58694.701221] CPU 1 is now offline
[58694.701225] SMP alternatives: switching to UP code
[58694.900182] CPU1 is down
[58694.900289] Extended CMOS year: 2000
[58694.900289] Back to C!
[58694.900289] Extended CMOS year: 2000
[58694.900289] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[58694.900289] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[58694.900289] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[58694.900289] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[58694.900289] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[58694.900289] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[58694.900289] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[58694.900289] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[58694.900289] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[58694.900289] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[58694.900289] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[58694.900289] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[58694.900289] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[58694.900289] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[58694.900289] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[58694.900289] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[58694.900289] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[58694.900289] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[58694.900289] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[58694.900289] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[58694.900289] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[58694.900289] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[58694.900289] Enabling non-boot CPUs ...
[58694.900289] SMP alternatives: switching to SMP code
[58695.023935] Booting processor 1 APIC 0x1 ip 0x6000
[58694.888903] Initializing CPU#1
[58694.888903] Calibrating delay using timer specific routine.. 4522.01 Bog=
oMIPS (lpj=3D9044026)
[58694.888903] CPU: L1 I cache: 32K, L1 D cache: 32K
[58694.888903] CPU: L2 cache: 3072K
[58694.888903] [ds] using Core 2/Atom configuration
[58694.888903] CPU: Physical Processor ID: 0
[58694.888903] CPU: Processor Core ID: 1
[58694.888903] CPU1: Thermal monitoring enabled (TM2)
[58695.112551] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[58695.116014] Switched to high resolution mode on CPU 1
[58695.124344] CPU1 is up
[58695.124346] ACPI: Waking up from system sleep state S3
[58695.166164] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[58695.215372] pci 0000:00:02.0: PME# disabled
[58695.215377] pci 0000:00:02.1: PME# disabled
[58695.215380] pci 0000:00:03.0: PME# disabled
[58695.215435] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[58695.215439] e1000e 0000:00:19.0: setting latency timer to 64
[58695.215443] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[58695.215446] e1000e 0000:00:19.0: PME# disabled
[58695.215448] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[58695.215452] e1000e 0000:00:19.0: PME# disabled
[58695.215483] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[58695.272851] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[58695.272860] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[58695.272867] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[58695.272892] usb usb1: root hub lost power or was reset
[58695.272912] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[58695.272919] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[58695.272941] usb usb2: root hub lost power or was reset
[58695.273719] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[58695.273724] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[58695.273730] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[58695.273753] usb usb3: root hub lost power or was reset
[58695.273772] ehci_hcd 0000:00:1a.7: PME# disabled
[58695.274163] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[58695.274170] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[58695.274177] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[58695.274184] ehci_hcd 0000:00:1a.7: PME# disabled
[58695.274203] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[58695.274209] HDA Intel 0000:00:1b.0: setting latency timer to 64
[58695.363135] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[58695.363155] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[58695.363172] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[58695.364171] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[58695.364184] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[58695.364194] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[58695.364226] usb usb4: root hub lost power or was reset
[58695.364253] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[58695.364263] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[58695.364292] usb usb5: root hub lost power or was reset
[58695.364316] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[58695.364327] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[58695.364356] usb usb6: root hub lost power or was reset
[58695.364380] ehci_hcd 0000:00:1d.7: PME# disabled
[58695.365222] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[58695.365234] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[58695.365245] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[58695.365256] ehci_hcd 0000:00:1d.7: PME# disabled
[58695.365288] pci 0000:00:1e.0: setting latency timer to 64
[58695.365394] ahci 0000:00:1f.2: setting latency timer to 64
[58695.365690] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[58695.365879] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[58695.365952] iwlagn: Radio disabled by HW RF Kill switch
[58695.366548] sd 0:0:0:0: [sda] Starting disk
[58695.684283] ata2: SATA link down (SStatus 0 SControl 300)
[58697.588273] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[58697.659793] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[58697.659801] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[58697.659885] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[58697.659891] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[58697.670878] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[58697.670885] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[58697.671005] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[58697.671012] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[58697.672113] ata1.00: configured for UDMA/100
[58697.674536] ata1.00: configured for UDMA/100
[58697.688266] ata1: EH complete
[58697.688372] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[58697.688408] sd 0:0:0:0: [sda] Write Protect is off
[58697.688413] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[58697.688466] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[58697.688526] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[58697.688556] sd 0:0:0:0: [sda] Write Protect is off
[58697.688561] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[58697.688611] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[58699.084289] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[58699.332316] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[58699.484782] pci 0000:00:02.0: power state changed by ACPI to D0
[58699.484979] pci 0000:00:02.0: power state changed by ACPI to D0
[58699.484992] pci 0000:00:02.0: setting latency timer to 64
[58699.596288] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[58699.757051] Restarting tasks ... done.
[58700.862251] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[58701.014948] ready
[58701.016040] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[58701.017254] sd 7:0:0:0: [sdb] Write Protect is off
[58701.017263] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[58701.017268] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[58701.018634] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[58701.019255] sd 7:0:0:0: [sdb] Write Protect is off
[58701.019261] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[58701.019267] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[58701.019274]  sdb: sdb1
[58701.180915] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[58701.198362] input: TPPS/2 IBM TrackPoint as /class/input/input21
[59394.789766] PM: Syncing filesystems ... done.
[59395.817741] Freezing user space processes ... (elapsed 0.03 seconds) don=
e.
[59395.849250] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[59395.849683] Suspending console(s) (use no_console_suspend to debug)
[59395.864482] pci 0000:00:02.0: power state changed by ACPI to D3
[59396.544391] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[59396.544911] sd 0:0:0:0: [sda] Stopping disk
[59396.964394] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[59396.964472] ehci_hcd 0000:00:1d.7: PME# disabled
[59396.981600] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[59396.981627] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[59396.981696] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[59396.981762] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[59396.996746] HDA Intel 0000:00:1b.0: PCI INT B disabled
[59397.012128] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[59397.012203] ehci_hcd 0000:00:1a.7: PME# disabled
[59397.028977] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[59397.029001] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[59397.029070] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[59397.029136] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[59397.087127] e1000e 0000:00:19.0: PME# enabled
[59397.087161] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[59397.087169] e1000e 0000:00:19.0: PME# enabled
[59397.087173] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[59397.087185] e1000e 0000:00:19.0: PCI INT A disabled
[59397.106200] ACPI: Preparing to enter system sleep state S3
[59397.128075] Disabling non-boot CPUs ...
[59397.232022] CPU 1 is now offline
[59397.232027] SMP alternatives: switching to UP code
[59397.444311] CPU1 is down
[59397.444419] Extended CMOS year: 2000
[59397.444419] Back to C!
[59397.444419] Extended CMOS year: 2000
[59397.444419] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[59397.444419] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[59397.444419] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[59397.444419] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[59397.444419] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59397.444419] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59397.444419] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59397.444419] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[59397.444419] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[59397.444419] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[59397.444419] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[59397.444419] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[59397.444419] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59397.444419] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59397.444419] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59397.444419] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[59397.444419] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[59397.444419] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[59397.444419] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[59397.444419] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[59397.444419] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[59397.444419] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[59397.444419] Enabling non-boot CPUs ...
[59397.444419] SMP alternatives: switching to SMP code
[59397.567938] Booting processor 1 APIC 0x1 ip 0x6000
[59397.438229] Initializing CPU#1
[59397.438229] Calibrating delay using timer specific routine.. 4522.05 Bog=
oMIPS (lpj=3D9044114)
[59397.438229] CPU: L1 I cache: 32K, L1 D cache: 32K
[59397.438229] CPU: L2 cache: 3072K
[59397.438229] [ds] using Core 2/Atom configuration
[59397.438229] CPU: Physical Processor ID: 0
[59397.438229] CPU: Processor Core ID: 1
[59397.438229] CPU1: Thermal monitoring enabled (TM2)
[59397.656572] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[59397.657011] Switched to high resolution mode on CPU 1
[59397.668342] CPU1 is up
[59397.668344] ACPI: Waking up from system sleep state S3
[59397.712128] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[59397.763073] pci 0000:00:02.0: PME# disabled
[59397.763077] pci 0000:00:02.1: PME# disabled
[59397.763080] pci 0000:00:03.0: PME# disabled
[59397.763136] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[59397.763140] e1000e 0000:00:19.0: setting latency timer to 64
[59397.763144] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[59397.763147] e1000e 0000:00:19.0: PME# disabled
[59397.763149] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[59397.763153] e1000e 0000:00:19.0: PME# disabled
[59397.763184] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[59397.821168] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[59397.821178] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[59397.821185] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[59397.821211] usb usb1: root hub lost power or was reset
[59397.821232] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[59397.821239] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[59397.821261] usb usb2: root hub lost power or was reset
[59397.822147] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[59397.822156] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[59397.822164] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[59397.822188] usb usb3: root hub lost power or was reset
[59397.822209] ehci_hcd 0000:00:1a.7: PME# disabled
[59397.822895] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[59397.822906] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[59397.822914] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[59397.822922] ehci_hcd 0000:00:1a.7: PME# disabled
[59397.822944] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[59397.822950] HDA Intel 0000:00:1b.0: setting latency timer to 64
[59397.911377] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[59397.911397] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[59397.911414] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[59397.912461] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[59397.912473] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[59397.912484] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[59397.912515] usb usb4: root hub lost power or was reset
[59397.912542] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[59397.912552] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[59397.912581] usb usb5: root hub lost power or was reset
[59397.912606] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[59397.912616] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[59397.912646] usb usb6: root hub lost power or was reset
[59397.912670] ehci_hcd 0000:00:1d.7: PME# disabled
[59397.913502] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[59397.913513] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[59397.913524] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[59397.913535] ehci_hcd 0000:00:1d.7: PME# disabled
[59397.913566] pci 0000:00:1e.0: setting latency timer to 64
[59397.913672] ahci 0000:00:1f.2: setting latency timer to 64
[59397.913969] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[59397.914159] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[59397.914232] iwlagn: Radio disabled by HW RF Kill switch
[59397.914829] sd 0:0:0:0: [sda] Starting disk
[59398.232293] ata2: SATA link down (SStatus 0 SControl 300)
[59399.744284] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[59399.816292] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[59399.816300] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[59399.816434] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[59399.816441] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[59399.827477] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[59399.827486] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[59399.827660] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[59399.827667] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[59399.828578] ata1.00: configured for UDMA/100
[59399.830647] ata1.00: configured for UDMA/100
[59399.844278] ata1: EH complete
[59399.844386] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[59399.844422] sd 0:0:0:0: [sda] Write Protect is off
[59399.844427] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[59399.844479] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[59399.844538] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[59399.844568] sd 0:0:0:0: [sda] Write Protect is off
[59399.844573] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[59399.844623] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[59401.232320] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[59401.480316] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[59401.632819] pci 0000:00:02.0: power state changed by ACPI to D0
[59401.633016] pci 0000:00:02.0: power state changed by ACPI to D0
[59401.633029] pci 0000:00:02.0: setting latency timer to 64
[59401.744315] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[59401.904887] Restarting tasks ... done.
[59403.028310] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[59403.113264] ready
[59403.114255] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[59403.115197] sd 7:0:0:0: [sdb] Write Protect is off
[59403.115206] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[59403.115211] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[59403.117260] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[59403.117885] sd 7:0:0:0: [sdb] Write Protect is off
[59403.117891] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[59403.117896] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[59403.117904]  sdb: sdb1
[59403.322945] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[59403.339944] input: TPPS/2 IBM TrackPoint as /class/input/input22
[59405.904985] Registered led device: iwl-phy1:radio
[59405.905234] Registered led device: iwl-phy1:assoc
[59405.905293] Registered led device: iwl-phy1:RX
[59405.905341] Registered led device: iwl-phy1:TX
[59411.742259] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
[59411.745510] wlan0 direct probe responded
[59411.745519] wlan0: authenticate with AP 00:14:6c:67:9c:32
[59411.749503] wlan0: authenticated
[59411.749511] wlan0: associate with AP 00:14:6c:67:9c:32
[59411.758411] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=3D0x601 st=
atus=3D0 aid=3D14)
[59411.758420] wlan0: associated
[59411.761713] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[59422.540232] wlan0: no IPv6 routers present
[59892.543863] PM: Syncing filesystems ... done.
[59893.449995] Freezing user space processes ... (elapsed 0.07 seconds) don=
e.
[59893.527416] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[59893.527857] Suspending console(s) (use no_console_suspend to debug)
[59893.544326] pci 0000:00:02.0: power state changed by ACPI to D3
[59894.220498] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[59894.221212] sd 0:0:0:0: [sda] Stopping disk
[59894.652396] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[59894.652474] ehci_hcd 0000:00:1d.7: PME# disabled
[59894.669499] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[59894.669525] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[59894.669594] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[59894.669661] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[59894.684760] HDA Intel 0000:00:1b.0: PCI INT B disabled
[59894.700130] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[59894.700206] ehci_hcd 0000:00:1a.7: PME# disabled
[59894.717392] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[59894.717419] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[59894.717488] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[59894.717555] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[59894.775128] e1000e 0000:00:19.0: PME# enabled
[59894.775162] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[59894.775170] e1000e 0000:00:19.0: PME# enabled
[59894.775175] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[59894.775186] e1000e 0000:00:19.0: PCI INT A disabled
[59894.793851] ACPI: Preparing to enter system sleep state S3
[59894.814827] Disabling non-boot CPUs ...
[59894.817143] CPU 1 is now offline
[59894.817148] SMP alternatives: switching to UP code
[59894.984327] CPU1 is down
[59894.984435] Extended CMOS year: 2000
[59894.984435] Back to C!
[59894.984435] Extended CMOS year: 2000
[59894.984435] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[59894.984435] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[59894.984435] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[59894.984435] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[59894.984435] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59894.984435] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59894.984435] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59894.984435] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[59894.984435] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[59894.984435] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[59894.984435] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[59894.984435] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[59894.984435] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59894.984435] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59894.984435] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[59894.984435] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[59894.984435] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[59894.984435] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[59894.984435] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[59894.984435] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[59894.984435] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[59894.984435] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[59894.984435] Enabling non-boot CPUs ...
[59894.984435] SMP alternatives: switching to SMP code
[59895.107205] Booting processor 1 APIC 0x1 ip 0x6000
[59894.982528] Initializing CPU#1
[59894.982528] Calibrating delay using timer specific routine.. 4522.12 Bog=
oMIPS (lpj=3D9044248)
[59894.982528] CPU: L1 I cache: 32K, L1 D cache: 32K
[59894.982528] CPU: L2 cache: 3072K
[59894.982528] [ds] using Core 2/Atom configuration
[59894.982528] CPU: Physical Processor ID: 0
[59894.982528] CPU: Processor Core ID: 1
[59894.982528] CPU1: Thermal monitoring enabled (TM2)
[59895.196516] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[59895.200014] Switched to high resolution mode on CPU 1
[59895.208344] CPU1 is up
[59895.208346] ACPI: Waking up from system sleep state S3
[59895.252024] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[59895.303243] pci 0000:00:02.0: PME# disabled
[59895.303249] pci 0000:00:02.1: PME# disabled
[59895.303253] pci 0000:00:03.0: PME# disabled
[59895.303315] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[59895.303321] e1000e 0000:00:19.0: setting latency timer to 64
[59895.303325] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[59895.303330] e1000e 0000:00:19.0: PME# disabled
[59895.303332] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[59895.303336] e1000e 0000:00:19.0: PME# disabled
[59895.303372] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[59895.360872] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[59895.360881] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[59895.360888] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[59895.360913] usb usb1: root hub lost power or was reset
[59895.360933] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[59895.360940] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[59895.360962] usb usb2: root hub lost power or was reset
[59895.361716] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[59895.361721] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[59895.361728] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[59895.361750] usb usb3: root hub lost power or was reset
[59895.361769] ehci_hcd 0000:00:1a.7: PME# disabled
[59895.362550] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[59895.362557] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[59895.362564] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[59895.362571] ehci_hcd 0000:00:1a.7: PME# disabled
[59895.362590] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[59895.362596] HDA Intel 0000:00:1b.0: setting latency timer to 64
[59895.451606] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[59895.451625] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[59895.451643] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[59895.452514] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[59895.452527] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[59895.452537] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[59895.452568] usb usb4: root hub lost power or was reset
[59895.452595] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[59895.452605] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[59895.452634] usb usb5: root hub lost power or was reset
[59895.452659] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[59895.452669] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[59895.452698] usb usb6: root hub lost power or was reset
[59895.452722] ehci_hcd 0000:00:1d.7: PME# disabled
[59895.453411] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[59895.453422] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[59895.453433] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[59895.453444] ehci_hcd 0000:00:1d.7: PME# disabled
[59895.453475] pci 0000:00:1e.0: setting latency timer to 64
[59895.453581] ahci 0000:00:1f.2: setting latency timer to 64
[59895.453878] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[59895.454067] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[59895.467243] sd 0:0:0:0: [sda] Starting disk
[59895.483339] Registered led device: iwl-phy1:radio
[59895.483386] Registered led device: iwl-phy1:assoc
[59895.483431] Registered led device: iwl-phy1:RX
[59895.483477] Registered led device: iwl-phy1:TX
[59895.772272] ata2: SATA link down (SStatus 0 SControl 300)
[59897.452279] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[59897.498115] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[59897.498122] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[59897.498436] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[59897.498443] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[59897.509210] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[59897.509217] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[59897.509525] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[59897.509533] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[59897.510584] ata1.00: configured for UDMA/100
[59897.512761] ata1.00: configured for UDMA/100
[59897.528272] ata1: EH complete
[59897.528376] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[59897.528412] sd 0:0:0:0: [sda] Write Protect is off
[59897.528417] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[59897.528470] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[59897.528529] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[59897.528559] sd 0:0:0:0: [sda] Write Protect is off
[59897.528564] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[59897.528614] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[59898.912321] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[59899.160316] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[59899.312811] pci 0000:00:02.0: power state changed by ACPI to D0
[59899.313007] pci 0000:00:02.0: power state changed by ACPI to D0
[59899.313020] pci 0000:00:02.0: setting latency timer to 64
[59899.424323] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[59899.585290] Restarting tasks ... done.
[59900.662508] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[59900.843090] ready
[59900.843918] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[59900.844898] sd 7:0:0:0: [sdb] Write Protect is off
[59900.844905] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[59900.844910] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[59900.846259] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[59900.846883] sd 7:0:0:0: [sdb] Write Protect is off
[59900.846889] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[59900.846894] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[59900.846912]  sdb: sdb1
[59900.974105] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[59900.995158] input: TPPS/2 IBM TrackPoint as /class/input/input23
[59901.584016] wlan0: No ProbeResp from current AP 00:14:6c:67:9c:32 - assu=
me out of range
[61075.077222] PM: Syncing filesystems ... done.
[61075.893015] Freezing user space processes ... (elapsed 0.06 seconds) don=
e.
[61075.956727] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[61075.957173] Suspending console(s) (use no_console_suspend to debug)
[61075.972291] pci 0000:00:02.0: power state changed by ACPI to D3
[61076.648613] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[61076.649135] sd 0:0:0:0: [sda] Stopping disk
[61077.076391] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[61077.076469] ehci_hcd 0000:00:1d.7: PME# disabled
[61077.093407] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[61077.093434] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[61077.093503] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[61077.093570] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[61077.108761] HDA Intel 0000:00:1b.0: PCI INT B disabled
[61077.124123] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[61077.124197] ehci_hcd 0000:00:1a.7: PME# disabled
[61077.141058] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[61077.141082] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[61077.141150] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[61077.141217] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[61077.199120] e1000e 0000:00:19.0: PME# enabled
[61077.199155] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[61077.199162] e1000e 0000:00:19.0: PME# enabled
[61077.199167] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[61077.199178] e1000e 0000:00:19.0: PCI INT A disabled
[61077.217973] ACPI: Preparing to enter system sleep state S3
[61077.238720] Disabling non-boot CPUs ...
[61077.241006] CPU 1 is now offline
[61077.241011] SMP alternatives: switching to UP code
[61077.400161] CPU1 is down
[61077.400267] Extended CMOS year: 2000
[61077.400267] Back to C!
[61077.400267] Extended CMOS year: 2000
[61077.400267] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[61077.400267] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[61077.400267] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[61077.400267] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[61077.400267] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[61077.400267] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[61077.400267] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[61077.400267] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[61077.400267] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[61077.400267] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[61077.400267] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[61077.400267] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[61077.400267] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[61077.400267] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[61077.400267] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[61077.400267] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[61077.400267] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[61077.400267] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[61077.400267] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[61077.400267] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[61077.400267] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[61077.400267] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[61077.400267] Enabling non-boot CPUs ...
[61077.400267] SMP alternatives: switching to SMP code
[61077.523950] Booting processor 1 APIC 0x1 ip 0x6000
[61077.390129] Initializing CPU#1
[61077.390129] Calibrating delay using timer specific routine.. 4522.06 Bog=
oMIPS (lpj=3D9044124)
[61077.390129] CPU: L1 I cache: 32K, L1 D cache: 32K
[61077.390129] CPU: L2 cache: 3072K
[61077.390129] [ds] using Core 2/Atom configuration
[61077.390129] CPU: Physical Processor ID: 0
[61077.390129] CPU: Processor Core ID: 1
[61077.390129] CPU1: Thermal monitoring enabled (TM2)
[61077.612505] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[61077.616015] Switched to high resolution mode on CPU 1
[61077.624341] CPU1 is up
[61077.624342] ACPI: Waking up from system sleep state S3
[61077.666757] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[61077.717361] pci 0000:00:02.0: PME# disabled
[61077.717367] pci 0000:00:02.1: PME# disabled
[61077.717373] pci 0000:00:03.0: PME# disabled
[61077.717436] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[61077.717442] e1000e 0000:00:19.0: setting latency timer to 64
[61077.717446] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[61077.717451] e1000e 0000:00:19.0: PME# disabled
[61077.717453] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[61077.717457] e1000e 0000:00:19.0: PME# disabled
[61077.717492] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[61077.772802] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[61077.772811] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[61077.772818] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[61077.772842] usb usb1: root hub lost power or was reset
[61077.772863] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[61077.772869] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[61077.772891] usb usb2: root hub lost power or was reset
[61077.773785] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[61077.773790] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[61077.773796] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[61077.773818] usb usb3: root hub lost power or was reset
[61077.773838] ehci_hcd 0000:00:1a.7: PME# disabled
[61077.774600] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[61077.774607] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[61077.774614] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[61077.774622] ehci_hcd 0000:00:1a.7: PME# disabled
[61077.774642] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[61077.774648] HDA Intel 0000:00:1b.0: setting latency timer to 64
[61077.863889] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[61077.863909] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[61077.863926] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[61077.864813] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[61077.864826] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[61077.864836] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[61077.864867] usb usb4: root hub lost power or was reset
[61077.864894] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[61077.864905] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[61077.864934] usb usb5: root hub lost power or was reset
[61077.864958] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[61077.864968] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[61077.864997] usb usb6: root hub lost power or was reset
[61077.865027] ehci_hcd 0000:00:1d.7: PME# disabled
[61077.865969] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[61077.865980] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[61077.865991] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[61077.866002] ehci_hcd 0000:00:1d.7: PME# disabled
[61077.866035] pci 0000:00:1e.0: setting latency timer to 64
[61077.866142] ahci 0000:00:1f.2: setting latency timer to 64
[61077.866438] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[61077.866628] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[61077.877949] sd 0:0:0:0: [sda] Starting disk
[61077.895883] Registered led device: iwl-phy1:radio
[61077.895929] Registered led device: iwl-phy1:assoc
[61077.895975] Registered led device: iwl-phy1:RX
[61077.896021] Registered led device: iwl-phy1:TX
[61078.184287] ata2: SATA link down (SStatus 0 SControl 300)
[61079.528273] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[61079.588209] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[61079.588217] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[61079.588330] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[61079.588337] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[61079.599262] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[61079.599269] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[61079.599585] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[61079.599592] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[61079.600433] ata1.00: configured for UDMA/100
[61079.602908] ata1.00: configured for UDMA/100
[61079.616297] ata1: EH complete
[61079.616398] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[61079.616434] sd 0:0:0:0: [sda] Write Protect is off
[61079.616439] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[61079.616491] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[61079.616550] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[61079.616580] sd 0:0:0:0: [sda] Write Protect is off
[61079.616585] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[61079.616635] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[61081.004321] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[61081.252320] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[61081.404782] pci 0000:00:02.0: power state changed by ACPI to D0
[61081.404978] pci 0000:00:02.0: power state changed by ACPI to D0
[61081.404991] pci 0000:00:02.0: setting latency timer to 64
[61081.516293] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[61081.677328] Restarting tasks ... done.
[61082.809688] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[61082.885157] ready
[61082.886271] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[61082.887036] sd 7:0:0:0: [sdb] Write Protect is off
[61082.887046] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[61082.887051] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[61082.888643] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[61082.889503] sd 7:0:0:0: [sdb] Write Protect is off
[61082.889510] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[61082.889515] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[61082.889522]  sdb: sdb1
[61083.119301] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[61083.138394] input: TPPS/2 IBM TrackPoint as /class/input/input24
[61116.752319] usb 8-1: new high speed USB device using ehci_hcd and addres=
s 10
[61116.898850] usb 8-1: configuration #1 chosen from 1 choice
[61116.953498] usb-storage: probe of 8-1:1.0 failed with error -5
[61116.953951] usb 8-1: USB disconnect, address 10
[61117.224110] usb 8-1: new high speed USB device using ehci_hcd and addres=
s 11
[61117.369898] usb 8-1: configuration #1 chosen from 1 choice
[61117.413775] sierra 8-1:1.0: Sierra USB modem converter detected
[61117.414977] usb 8-1: Sierra USB modem converter now attached to ttyUSB0
[61117.415300] sierra 8-1:1.1: Sierra USB modem converter detected
[61117.417267] usb 8-1: Sierra USB modem converter now attached to ttyUSB1
[61117.417573] sierra 8-1:1.2: Sierra USB modem converter detected
[61117.420693] usb 8-1: Sierra USB modem converter now attached to ttyUSB2
[61117.420999] sierra 8-1:1.3: Sierra USB modem converter detected
[61117.421412] usb 8-1: Sierra USB modem converter now attached to ttyUSB3
[61117.421781] sierra 8-1:1.4: Sierra USB modem converter detected
[61117.422407] usb 8-1: Sierra USB modem converter now attached to ttyUSB4
[61117.422774] sierra 8-1:1.5: Sierra USB modem converter detected
[61117.423402] usb 8-1: Sierra USB modem converter now attached to ttyUSB5
[61117.423775] sierra 8-1:1.6: Sierra USB modem converter detected
[61117.424873] usb 8-1: Sierra USB modem converter now attached to ttyUSB6
[61117.428279] scsi13 : SCSI emulation for USB Mass Storage devices
[61117.456558] usb-storage: device found at 11
[61117.456564] usb-storage: waiting for device to settle before scanning
[61122.459826] scsi 13:0:0:0: Direct-Access     SWI      SD Card          2=
=2E31 PQ: 0 ANSI: 2
[61122.464743] sd 13:0:0:0: [sdc] Attached SCSI removable disk
[61122.465318] usb-storage: device scan complete
[61201.683664] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[61201.683863] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[61202.208268] iwlagn: Error sending REPLY_ADD_STA: time out after 500ms.
[61202.208470] Registered led device: iwl-phy1:radio
[61202.208523] Registered led device: iwl-phy1:assoc
[61202.208574] Registered led device: iwl-phy1:RX
[61202.208624] Registered led device: iwl-phy1:TX
[61202.227284] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[62506.394832] usb 8-1: USB disconnect, address 11
[62506.398955] sierra ttyUSB0: Sierra USB modem converter now disconnected =
=66rom ttyUSB0
[62506.399000] sierra 8-1:1.0: device disconnected
[62506.399554] sierra ttyUSB1: Sierra USB modem converter now disconnected =
=66rom ttyUSB1
[62506.399591] sierra 8-1:1.1: device disconnected
[62506.400181] sierra ttyUSB2: Sierra USB modem converter now disconnected =
=66rom ttyUSB2
[62506.400221] sierra 8-1:1.2: device disconnected
[62506.400874] sierra ttyUSB3: Sierra USB modem converter now disconnected =
=66rom ttyUSB3
[62506.400912] sierra 8-1:1.3: device disconnected
[62506.401558] sierra ttyUSB4: Sierra USB modem converter now disconnected =
=66rom ttyUSB4
[62506.401595] sierra 8-1:1.4: device disconnected
[62506.402230] sierra ttyUSB5: Sierra USB modem converter now disconnected =
=66rom ttyUSB5
[62506.402268] sierra 8-1:1.5: device disconnected
[62506.402907] sierra ttyUSB6: Sierra USB modem converter now disconnected =
=66rom ttyUSB6
[62506.402944] sierra 8-1:1.6: device disconnected
[62591.876910] PM: Syncing filesystems ... done.
[62592.689634] Freezing user space processes ... (elapsed 0.06 seconds) don=
e.
[62592.751886] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[62592.752348] Suspending console(s) (use no_console_suspend to debug)
[62592.768301] pci 0000:00:02.0: power state changed by ACPI to D3
[62593.440721] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[62593.440979] sd 0:0:0:0: [sda] Stopping disk
[62593.876391] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[62593.876470] ehci_hcd 0000:00:1d.7: PME# disabled
[62593.893089] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[62593.893116] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[62593.893185] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[62593.893252] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[62593.908756] HDA Intel 0000:00:1b.0: PCI INT B disabled
[62593.924127] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[62593.924202] ehci_hcd 0000:00:1a.7: PME# disabled
[62593.941346] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[62593.941372] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[62593.941442] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[62593.941509] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[62593.999121] e1000e 0000:00:19.0: PME# enabled
[62593.999154] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[62593.999162] e1000e 0000:00:19.0: PME# enabled
[62593.999167] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[62593.999178] e1000e 0000:00:19.0: PCI INT A disabled
[62594.018073] ACPI: Preparing to enter system sleep state S3
[62594.040041] Disabling non-boot CPUs ...
[62594.144071] CPU 1 is now offline
[62594.144077] SMP alternatives: switching to UP code
[62594.296158] CPU1 is down
[62594.296264] Extended CMOS year: 2000
[62594.296264] Back to C!
[62594.296264] Extended CMOS year: 2000
[62594.296264] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900403)
[62594.296264] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[62594.296264] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[62594.296264] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[62594.296264] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[62594.296264] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[62594.296264] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[62594.296264] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[62594.296264] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[62594.296264] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[62594.296264] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[62594.296264] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[62594.296264] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[62594.296264] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[62594.296264] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[62594.296264] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[62594.296264] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[62594.296264] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[62594.296264] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[62594.296264] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[62594.296264] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[62594.296264] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[62594.296264] Enabling non-boot CPUs ...
[62594.296264] SMP alternatives: switching to SMP code
[62594.420219] Booting processor 1 APIC 0x1 ip 0x6000
[62594.279936] Initializing CPU#1
[62594.279936] Calibrating delay using timer specific routine.. 4521.96 Bog=
oMIPS (lpj=3D9043932)
[62594.279936] CPU: L1 I cache: 32K, L1 D cache: 32K
[62594.279936] CPU: L2 cache: 3072K
[62594.279936] [ds] using Core 2/Atom configuration
[62594.279936] CPU: Physical Processor ID: 0
[62594.279936] CPU: Processor Core ID: 1
[62594.279936] CPU1: Thermal monitoring enabled (TM2)
[62594.508560] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[62594.512015] Switched to high resolution mode on CPU 1
[62594.520345] CPU1 is up
[62594.520347] ACPI: Waking up from system sleep state S3
[62594.547312] thinkpad_acpi: EC reports that Thermal Table has changed
[62594.672130] ACPI: \_SB_.GDCK - docking
[62594.721181] acpi device:27: parent device:14 should not be sleeping
[62594.723707] acpi IBM0079:00: parent device:00 should not be sleeping
[62594.732669] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[62594.793198] pci 0000:00:02.0: PME# disabled
[62594.793209] pci 0000:00:02.1: PME# disabled
[62594.793218] pci 0000:00:03.0: PME# disabled
[62594.793317] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[62594.793327] e1000e 0000:00:19.0: setting latency timer to 64
[62594.793334] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[62594.793342] e1000e 0000:00:19.0: PME# disabled
[62594.793346] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[62594.793354] e1000e 0000:00:19.0: PME# disabled
[62594.793407] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[62594.849120] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[62594.849130] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[62594.849140] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[62594.849172] usb usb1: root hub lost power or was reset
[62594.849199] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[62594.849209] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[62594.849238] usb usb2: root hub lost power or was reset
[62594.850198] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[62594.850208] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[62594.850218] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[62594.850248] usb usb3: root hub lost power or was reset
[62594.850274] ehci_hcd 0000:00:1a.7: PME# disabled
[62594.851099] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[62594.851111] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[62594.851122] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[62594.851133] ehci_hcd 0000:00:1a.7: PME# disabled
[62594.851163] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[62594.851173] HDA Intel 0000:00:1b.0: setting latency timer to 64
[62594.944107] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[62594.944121] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[62594.944139] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[62594.945237] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[62594.945246] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[62594.945257] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[62594.945287] usb usb4: root hub lost power or was reset
[62594.945313] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[62594.945323] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[62594.945352] usb usb5: root hub lost power or was reset
[62594.945376] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[62594.945386] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[62594.945416] usb usb6: root hub lost power or was reset
[62594.945440] ehci_hcd 0000:00:1d.7: PME# disabled
[62594.946372] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[62594.946383] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[62594.946394] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[62594.946405] ehci_hcd 0000:00:1d.7: PME# disabled
[62594.946435] pci 0000:00:1e.0: setting latency timer to 64
[62594.946540] ahci 0000:00:1f.2: setting latency timer to 64
[62594.946835] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[62594.947019] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[62594.960054] sd 0:0:0:0: [sda] Starting disk
[62594.978066] Registered led device: iwl-phy1:radio
[62594.978113] Registered led device: iwl-phy1:assoc
[62594.978161] Registered led device: iwl-phy1:RX
[62594.978206] Registered led device: iwl-phy1:TX
[62595.268123] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[62595.275068] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[62595.275922] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[62595.279665] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[62595.287421] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[62595.288346] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[62595.292101] ata2.00: configured for UDMA/133
[62595.485407] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[62596.500121] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[62596.562310] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[62596.562316] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[62596.562489] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[62596.562495] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[62596.573396] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[62596.573402] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[62596.573574] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[62596.573580] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[62596.574486] ata1.00: configured for UDMA/100
[62596.576568] ata1.00: configured for UDMA/100
[62596.592118] ata1: EH complete
[62596.592181] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[62596.592215] sd 0:0:0:0: [sda] Write Protect is off
[62596.592220] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[62596.592270] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[62596.592325] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[62596.592354] sd 0:0:0:0: [sda] Write Protect is off
[62596.592359] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[62596.592408] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[62597.284955] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[62597.285705] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[62597.976140] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 3
[62598.224133] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[62598.376379] pci 0000:00:02.0: power state changed by ACPI to D0
[62598.376573] pci 0000:00:02.0: power state changed by ACPI to D0
[62598.376586] pci 0000:00:02.0: setting latency timer to 64
[62598.488120] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 5
[62598.649386] Restarting tasks ... done.
[62598.773029] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 4
[62598.928587] usb 7-5: configuration #1 chosen from 1 choice
[62598.932115] hub 7-5:1.0: USB hub found
[62598.932187] hub 7-5:1.0: 4 ports detected
[62599.009330] Driver 'sr' needs updating - please use bus_type methods
[62599.020838] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[62599.020842] Uniform CD-ROM driver Revision: 3.20
[62599.020925] sr 1:0:0:0: Attached scsi CD-ROM sr0
[62599.042180] sd 0:0:0:0: Attached scsi generic sg0 type 0
[62599.042219] sd 7:0:0:0: Attached scsi generic sg1 type 0
[62599.042257] sr 1:0:0:0: Attached scsi generic sg2 type 5
[62599.204237] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 5
[62599.298812] usb 7-5.4: configuration #1 chosen from 1 choice
[62599.482931] usblp0: USB Bidirectional printer dev 5 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[62599.483501] usbcore: registered new interface driver usblp
[62599.866507] ready
[62599.867008] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[62599.867585] sd 7:0:0:0: [sdb] Write Protect is off
[62599.867592] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[62599.867597] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[62599.868978] sd 7:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[62599.869601] sd 7:0:0:0: [sdb] Write Protect is off
[62599.869607] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[62599.869612] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[62599.869618]  sdb: sdb1
[62602.289229] e1000e: eth0 NIC Link is Down
[62605.480895] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: None
[62605.481662] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[62623.516153] eth0: no IPv6 routers present
[64148.377651] RPC: Registered udp transport module.
[64148.377660] RPC: Registered tcp transport module.


--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmZRucACgkQuL75KpiFGIw3uACfVeBZBNqhBTl106vSZvuDQN7Y
dLIAoMqt9wTVGVOwwsEvszWxZFNU7ewA
=oTqS
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
