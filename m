Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXGCP5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXGCP5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbXGCP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:57:45 -0400
Received: from systemlinux.org ([83.151.29.59]:53877 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019AbXGCP5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:57:40 -0400
Date: Tue, 3 Jul 2007 17:55:19 +0200
From: Andre Noll <maan@systemlinux.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.22-rc7
Message-ID: <20070703155519.GY22589@skl-net.de>
References: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qn4G1eBrv+t66M9q"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Qn4G1eBrv+t66M9q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:32, Linus Torvalds wrote:
>=20
> Ok, Linux-2.6.22-rc7 is out there.
>=20
> Final testing always appreciated, of course,

There seems to be a locking problem:

	 [ INFO: inconsistent lock state ]

Full dmesg and .config below.

Have fun
Andre


[    0.000000] Linux version 2.6.22-rc7 (root@huangho2) (gcc version 4.0.3 =
(Ubuntu 4.0.3-1ubuntu5)) #44 SMP Tue Jul 3 17:39:10 CEST 2007
[    0.000000] Command line:=20
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000f57f8000 (usable)
[    0.000000]  BIOS-e820: 00000000f57f8000 - 00000000f5800000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fdc00000 - 00000000fdc01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fdc10000 - 00000000fdc11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec20000 - 00000000fec21000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013ffff000 (usable)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 1005560) 1 entries of 3200=
 used
[    0.000000] Entering add_active_range(0, 1048576, 1310719) 2 entries of =
3200 used
[    0.000000] end_pfn_map =3D 1310719
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F4F20, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT F57F83E0, 0044 (r1 HP     A05             2   =D2=
=04     162E)
[    0.000000] ACPI: FACP F57F8460, 00F4 (r3 HP     A05             2   =D2=
=04     162E)
[    0.000000] ACPI: DSDT F57F8560, 422D (r1 HP         DSDT        1 MSFT =
 2000001)
[    0.000000] ACPI: FACS F57F80C0, 0040
[    0.000000] ACPI: APIC F57F8100, 00B8 (r1 HP     00000083        2      =
       0)
[    0.000000] ACPI: SPCR F57F81E0, 0050 (r1 HP     SPCRRBSU        1   =D2=
=04     162E)
[    0.000000] ACPI: SRAT F57F8260, 0150 (r1 HP     A05             1      =
       0)
[    0.000000] SRAT: PXM 1 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 2 -> Node 1
[    0.000000] ACPI: [SRAT:0x00] ignored 4 entries of 8 found
[    0.000000] SRAT: Node 0 PXM 1 0-c0000000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 786432) 1 entries of 3200 =
used
[    0.000000] SRAT: Node 1 PXM 2 c0000000-140000000
[    0.000000] Entering add_active_range(1, 786432, 1005560) 2 entries of 3=
200 used
[    0.000000] Entering add_active_range(1, 1048576, 1310719) 3 entries of =
3200 used
[    0.000000] NUMA: Using 30 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-00000000c0000000
[    0.000000] Bootmem setup node 1 00000000c0000000-000000013ffff000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1310719
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   786432
[    0.000000]     1:   786432 ->  1005560
[    0.000000]     1:  1048576 ->  1310719
[    0.000000] On node 0 totalpages: 786335
[    0.000000]   DMA zone: 88 pages used for memmap
[    0.000000]   DMA zone: 2674 pages reserved
[    0.000000]   DMA zone: 1237 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16808 pages used for memmap
[    0.000000]   DMA32 zone: 765528 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] On node 1 totalpages: 481271
[    0.000000]   DMA zone: 0 pages used for memmap
[    0.000000]   DMA32 zone: 5632 pages used for memmap
[    0.000000]   DMA32 zone: 213496 pages, LIFO batch:31
[    0.000000]   Normal zone: 5631 pages used for memmap
[    0.000000]   Normal zone: 256512 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, address 0xfec10000, GSI 24-27
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec20000] gsi_base[28])
[    0.000000] IOAPIC[2]: apic_id 6, address 0xfec20000, GSI 28-31
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfdc00000] gsi_base[32])
[    0.000000] IOAPIC[3]: apic_id 7, address 0xfdc00000, GSI 32-35
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfdc10000] gsi_base[36])
[    0.000000] IOAPIC[4]: apic_id 8, address 0xfdc10000, GSI 36-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at f6000000 (gap: f5800000=
:8400000)
[    0.000000] PERCPU: Allocating 34344 bytes of per cpu data
[    0.000000] Built 2 zonelists.  Total pages: 1236773
[    0.000000] Kernel command line:=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[   87.620888] time.c: Detected 2205.040 MHz processor.
[   87.623692] Console: colour VGA+ 80x25
[   87.633167] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[   87.633353] ... MAX_LOCKDEP_SUBCLASSES:    8
[   87.633477] ... MAX_LOCK_DEPTH:          30
[   87.633615] ... MAX_LOCKDEP_KEYS:        2048
[   87.633740] ... CLASSHASH_SIZE:           1024
[   87.633867] ... MAX_LOCKDEP_ENTRIES:     8192
[   87.633992] ... MAX_LOCKDEP_CHAINS:      16384
[   87.634118] ... CHAINHASH_SIZE:          8192
[   87.634246]  memory used by lock dependency info: 1648 kB
[   87.634378]  per task-struct memory footprint: 1680 bytes
[   87.634511] ------------------------
[   87.634652] | Locking API testsuite:
[   87.634774] ------------------------------------------------------------=
----------------
[   87.634972]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[   87.635163]   ----------------------------------------------------------=
----------------
[   87.635356]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.636822]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.638329]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.639935]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.641538]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.643245]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.644944]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.646652]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.648081]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.649493]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   87.651022]   ----------------------------------------------------------=
----------------
[   87.651210]               recursive read-lock:             |  ok  |     =
        |  ok  |
[   87.651967]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[   87.652730]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[   87.653486]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[   87.654202]   ----------------------------------------------------------=
----------------
[   87.654355]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   87.655105]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   87.655852]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   87.656607]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   87.657352]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[   87.658094]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[   87.658837]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   87.659604]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   87.660349]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   87.661090]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   87.661834]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   87.662616]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   87.663410]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   87.664193]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   87.664978]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   87.665762]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   87.666547]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   87.667310]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   87.668061]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   87.668799]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   87.669541]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   87.670288]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   87.671051]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   87.671802]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   87.672568]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   87.673315]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   87.674069]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   87.674848]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   87.675603]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   87.676347]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   87.677096]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   87.677844]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   87.678599]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   87.679354]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   87.680103]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   87.680853]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   87.681609]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   87.682356]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   87.683123]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   87.683873]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   87.684629]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   87.685373]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   87.686124]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   87.686882]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   87.687638]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   87.688383]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   87.689136]       hard-irq read-recursion/123:  ok  |
[   87.689494]       soft-irq read-recursion/123:  ok  |
[   87.689854]       hard-irq read-recursion/132:  ok  |
[   87.690213]       soft-irq read-recursion/132:  ok  |
[   87.690574]       hard-irq read-recursion/213:  ok  |
[   87.690943]       soft-irq read-recursion/213:  ok  |
[   87.691302]       hard-irq read-recursion/231:  ok  |
[   87.691660]       soft-irq read-recursion/231:  ok  |
[   87.692019]       hard-irq read-recursion/312:  ok  |
[   87.694075]       soft-irq read-recursion/312:  ok  |
[   87.694435]       hard-irq read-recursion/321:  ok  |
[   87.694794]       soft-irq read-recursion/321:  ok  |
[   87.695165] -------------------------------------------------------
[   87.695279] Good, all 218 testcases passed! |
[   87.695384] ---------------------------------
[   87.695491] Checking aperture...
[   87.695593] CPU 0: aperture @ 8000000 size 32 MB
[   87.695700] Aperture too small (32 MB)
[   87.702640] No AGP bridge found
[   87.702741] Your BIOS doesn't leave a aperture memory hole
[   87.702860] Please enable the IOMMU option in the BIOS setup
[   87.702971] This costs you 64 MB of RAM
[   87.740264] Mapping aperture over 65536 KB of RAM @ 8000000
[   87.815122] Memory: 4883760k/5242876k available (3302k kernel code, 1866=
64k reserved, 1521k data, 1532k init)
[   87.815386] SLUB: Genslabs=3D23, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D4, Nodes=3D2
[   87.894669] Calibrating delay using timer specific routine.. 4415.30 Bog=
oMIPS (lpj=3D8830606)
[   87.895725] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[   87.901342] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[   87.904020] Mount-cache hash table entries: 256
[   87.904760] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   87.904878] CPU: L2 Cache: 1024K (64 bytes/line)
[   87.904986] CPU 0/0 -> Node 0
[   87.905086] CPU: Physical Processor ID: 0
[   87.905190] CPU: Processor Core ID: 0
[   87.905306] Freeing SMP alternatives: 26k freed
[   87.905657] ACPI: Core revision 20070126
[   87.949393] Using local APIC timer interrupts.
[   87.994814] result 12528636
[   87.994913] Detected 12.528 MHz APIC timer.
[   87.998841] lockdep: not fixing up alternatives.
[   87.999034] Booting processor 1/4 APIC 0x2
[   88.009265] Initializing CPU#1
[   88.086506] Calibrating delay using timer specific routine.. 4410.32 Bog=
oMIPS (lpj=3D8820654)
[   88.086514] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   88.086516] CPU: L2 Cache: 1024K (64 bytes/line)
[   88.086519] CPU 1/2 -> Node 1
[   88.086520] CPU: Physical Processor ID: 1
[   88.086521] CPU: Processor Core ID: 0
[   88.086530] AMD Opteron(tm) Processor 275 stepping 02
[   88.090616] lockdep: not fixing up alternatives.
[   88.091628] Booting processor 2/4 APIC 0x1
[   88.101831] Initializing CPU#2
[   88.182430] Calibrating delay using timer specific routine.. 4410.33 Bog=
oMIPS (lpj=3D8820677)
[   88.182436] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   88.182438] CPU: L2 Cache: 1024K (64 bytes/line)
[   88.182440] CPU 2/1 -> Node 0
[   88.182442] CPU: Physical Processor ID: 0
[   88.182443] CPU: Processor Core ID: 1
[   88.182450] AMD Opteron(tm) Processor 275 stepping 02
[   88.186525] lockdep: not fixing up alternatives.
[   88.187539] Booting processor 3/4 APIC 0x3
[   88.197747] Initializing CPU#3
[   88.278353] Calibrating delay using timer specific routine.. 4410.32 Bog=
oMIPS (lpj=3D8820652)
[   88.278360] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[   88.278362] CPU: L2 Cache: 1024K (64 bytes/line)
[   88.278365] CPU 3/3 -> Node 1
[   88.278367] CPU: Physical Processor ID: 1
[   88.278368] CPU: Processor Core ID: 1
[   88.278377] AMD Opteron(tm) Processor 275 stepping 02
[   88.282382] Brought up 4 CPUs
[   89.763446] migration_cost=3D349,405
[   89.764339] NET: Registered protocol family 16
[   89.764791] ACPI: bus type pci registered
[   89.764901] PCI: Using configuration type 1
[   89.770927] ACPI: SSDT F57FD000, 059D (r1 HP        SSDT0        1 MSFT =
 2000001)
[   89.771430] ACPI: SSDT F57FD700, 059D (r1 HP        SSDT1        1 MSFT =
 2000001)
[   89.771921] ACPI: SSDT F57FDE00, 059D (r1 HP        SSDT2        1 MSFT =
 2000001)
[   89.772417] ACPI: SSDT F57FE500, 059D (r1 HP        SSDT3        1 MSFT =
 2000001)
[   89.772940]=20
[   89.772943] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   89.773194] [ INFO: inconsistent lock state ]
[   89.773325] 2.6.22-rc7 #44
[   89.773459] ---------------------------------
[   89.773591] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
[   89.773730] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   89.773862]  (&n->list_lock){+-..}, at: [<ffffffff8028cd7c>] add_partial=
+0x1c/0x60
[   89.774314] {hardirq-on-W} state was registered at:
[   89.774468]   [<ffffffff8024c542>] __lock_acquire+0x152/0x1070
[   89.774798]   [<ffffffff8024dc61>] debug_check_no_locks_freed+0x101/0x1c0
[   89.775139]   [<ffffffff8028cd7c>] add_partial+0x1c/0x60
[   89.775471]   [<ffffffff8024d82b>] lock_acquire+0x8b/0xc0
[   89.775797]   [<ffffffff8028cd7c>] add_partial+0x1c/0x60
[   89.776125]   [<ffffffff805364f5>] _spin_lock+0x25/0x40
[   89.776453]   [<ffffffff8028cd7c>] add_partial+0x1c/0x60
[   89.776778]   [<ffffffff80290dab>] kmem_cache_open+0x1db/0x300
[   89.777108]   [<ffffffff802912ea>] create_kmalloc_cache+0x6a/0xe0
[   89.777459]   [<ffffffff806f848c>] kmem_cache_init+0x3c/0x170
[   89.777791]   [<ffffffff806de7da>] start_kernel+0x21a/0x330
[   89.778120]   [<ffffffff806de124>] _sinittext+0x124/0x160
[   89.778450]   [<ffffffffffffffff>] 0xffffffffffffffff
[   89.778772] irq event stamp: 4974
[   89.778898] hardirqs last  enabled at (4973): [<ffffffff80208257>] defau=
lt_idle+0x37/0x60
[   89.779220] hardirqs last disabled at (4974): [<ffffffff805360a1>] trace=
_hardirqs_off_thunk+0x35/0x67
[   89.779549] softirqs last  enabled at (4966): [<ffffffff80233753>] __do_=
softirq+0xf3/0x110
[   89.779868] softirqs last disabled at (4959): [<ffffffff8020adcc>] call_=
softirq+0x1c/0x30
[   89.780189]=20
[   89.780190] other info that might help us debug this:
[   89.780455] no locks held by swapper/0.
[   89.780584]=20
[   89.780584] stack backtrace:
[   89.780814]=20
[   89.780815] Call Trace:
[   89.781046]  <IRQ>  [<ffffffff8024ae36>] print_usage_bug+0x186/0x1a0
[   89.781256]  [<ffffffff8024c26c>] mark_lock+0x49c/0x620
[   89.781401]  [<ffffffff8024ce47>] __lock_acquire+0xa57/0x1070
[   89.781542]  [<ffffffff8022804d>] run_rebalance_domains+0x3bd/0x4e0
[   89.781684]  [<ffffffff8028cd7c>] add_partial+0x1c/0x60
[   89.781819]  [<ffffffff8024d82b>] lock_acquire+0x8b/0xc0
[   89.781956]  [<ffffffff8028cd7c>] add_partial+0x1c/0x60
[   89.782093]  [<ffffffff805364f5>] _spin_lock+0x25/0x40
[   89.782230]  [<ffffffff80232f91>] _local_bh_enable+0x61/0xf0
[   89.782371]  [<ffffffff8028cd7c>] add_partial+0x1c/0x60
[   89.782508]  [<ffffffff8028f8a0>] deactivate_slab+0x60/0x150
[   89.782646]  [<ffffffff8028f9e0>] flush_cpu_slab+0x0/0x20
[   89.782786]  [<ffffffff8028f9b2>] flush_slab+0x22/0x30
[   89.782921]  [<ffffffff8028f9db>] __flush_cpu_slab+0x1b/0x20
[   89.783061]  [<ffffffff8028f9f1>] flush_cpu_slab+0x11/0x20
[   89.783198]  [<ffffffff802146df>] smp_call_function_interrupt+0x4f/0x80
[   89.783341]  [<ffffffff80208220>] default_idle+0x0/0x60
[   89.783478]  [<ffffffff8020a79b>] call_function_interrupt+0x6b/0x70
[   89.783618]  <EOI>  [<ffffffff80208259>] default_idle+0x39/0x60
[   89.783824]  [<ffffffff80208257>] default_idle+0x37/0x60
[   89.783962]  [<ffffffff802082e1>] cpu_idle+0x61/0x90
[   89.784098]  [<ffffffff806eb10b>] start_secondary+0x25b/0x3c0
[   89.784237]=20
[   89.784363] ACPI: Interpreter enabled
[   89.784486] ACPI: Using IOAPIC for interrupt routing
[   89.789997] ACPI: PCI Root Bridge [CFG0] (0000:00)
[   89.790133] PCI: Probing PCI hardware (bus 00)
[   89.791509] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0._PRT]
[   89.791713] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI0._PRT]
[   89.791940] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI1._PRT]
[   89.792133] ACPI: PCI Interrupt Routing Table [\_SB_.CFG0.PCI2._PRT]
[   89.795615] ACPI: PCI Root Bridge [CFG1] (0000:04)
[   89.795725] PCI: Probing PCI hardware (bus 04)
[   89.796234] ACPI: PCI Interrupt Routing Table [\_SB_.CFG1.PCI3._PRT]
[   89.796580] ACPI: PCI Interrupt Routing Table [\_SB_.CFG1.PCI4._PRT]
[   89.797543] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 7 10 *11)
[   89.798127] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 7 10 11) *15
[   89.798767] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 7 10 11) *0, disab=
led.
[   89.799475] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *5 7 10 11)
[   89.800071] Linux Plug and Play Support v0.97 (c) Adam Belay
[   89.800197] pnp: PnP ACPI init
[   89.800305] ACPI: bus type pnp registered
[   89.803924] pnp: PnP ACPI: found 10 devices
[   89.804030] ACPI: ACPI bus type pnp unregistered
[   89.804241] SCSI subsystem initialized
[   89.804447] usbcore: registered new interface driver usbfs
[   89.804605] usbcore: registered new interface driver hub
[   89.804770] usbcore: registered new device driver usb
[   89.804920] PCI: Using ACPI for IRQ routing
[   89.805026] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[   89.805559] PCI-DMA: Disabling AGP.
[   89.806174] PCI-DMA: aperture base @ 8000000 size 65536 KB
[   89.806290] PCI-DMA: using GART IOMMU.
[   89.806418] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[   89.806923] pnp: 00:01: ioport range 0x230-0x233 has been reserved
[   89.807038] pnp: 00:01: ioport range 0x260-0x267 has been reserved
[   89.807153] pnp: 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   89.807689] PCI: Bridge: 0000:00:03.0
[   89.807794]   IO window: 4000-4fff
[   89.807900]   MEM window: f5f00000-f7cfffff
[   89.809133] Time: acpi_pm clocksource has been installed.
[   89.809818]   PREFETCH window: f8000000-f80fffff
[   89.809929] PCI: Bridge: 0000:00:07.0
[   89.810033]   IO window: 5000-5fff
[   89.810137]   MEM window: f7d00000-f7dfffff
[   89.810244]   PREFETCH window: f8100000-f81fffff
[   89.810357] PCI: Bridge: 0000:00:08.0
[   89.810460]   IO window: disabled.
[   89.810564]   MEM window: f7e00000-f7efffff
[   89.810670]   PREFETCH window: disabled.
[   89.810806] PCI: Bridge: 0000:04:09.0
[   89.810910]   IO window: 6000-6fff
[   89.811014]   MEM window: f7f00000-f7ffffff
[   89.811121]   PREFETCH window: f8200000-f82fffff
[   89.811230] PCI: Bridge: 0000:04:0a.0
[   89.811333]   IO window: disabled.
[   89.811437]   MEM window: disabled.
[   89.811540]   PREFETCH window: disabled.
[   89.811679] NET: Registered protocol family 2
[   89.853231] IP route cache hash table entries: 262144 (order: 9, 2097152=
 bytes)
[   89.860639] TCP established hash table entries: 1048576 (order: 14, 6710=
8864 bytes)
[   89.912001] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[   89.914865] TCP: Hash tables configured (established 1048576 bind 65536)
[   89.914984] TCP reno registered
[   89.963663] audit: initializing netlink socket (disabled)
[   89.963800] audit(1183477398.296:1): initialized
[   89.964041] Total HugeTLB memory allocated, 0
[   89.967307] VFS: Disk quotas dquot_6.5.1
[   89.967489] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   89.967916] SGI XFS with large block/inode numbers, no debug enabled
[   89.968773] io scheduler noop registered
[   89.968880] io scheduler anticipatory registered
[   89.968993] io scheduler deadline registered
[   89.969242] io scheduler cfq registered (default)
[   90.009093] Boot video device is 0000:01:03.0
[   90.009913] input: Power Button (FF) as /class/input/input0
[   90.010028] ACPI: Power Button (FF) [PWRF]
[   90.013849] Generic RTC Driver v1.07
[   90.014030] AMD768 RNG detected
[   90.014190] Linux agpgart interface v0.102 (c) Dave Jones
[   90.014301] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[   90.014932] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   90.015954] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024=
 blocksize
[   90.016105] HP CISS Driver (v 3.6.14)
[   90.016303] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 24 (level, low) -=
> IRQ 24
[   90.056853] cciss0: <0x46> at PCI 0000:02:04.0 IRQ 24 using DAC
[   90.072830]       blocks=3D 142253280 block_size=3D 512
[   90.080824]       heads=3D255, sectors=3D32, cylinders=3D17433
[   90.080825]=20
[   90.088817]       blocks=3D 142253280 block_size=3D 512
[   90.096810]       heads=3D255, sectors=3D32, cylinders=3D17433
[   90.096811]=20
[   90.097131]       blocks=3D 142253280 block_size=3D 512
[   90.097322]       heads=3D255, sectors=3D32, cylinders=3D17433
[   90.097323]=20
[   90.097526]  cciss/c0d0: p1 p2 p3
[   90.104488]       blocks=3D 142253280 block_size=3D 512
[   90.104687]       heads=3D255, sectors=3D32, cylinders=3D17433
[   90.104688]=20
[   90.104894]  cciss/c0d1: p1 p2 p3
[   90.116935] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   90.117052] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[   90.117254] AMD8111: IDE controller at PCI slot 0000:00:04.1
[   90.117374] AMD8111: chipset revision 3
[   90.117478] AMD8111: not 100% native mode: will probe irqs later
[   90.117597] AMD8111: 0000:00:04.1 (rev 03) UDMA133 controller
[   90.117714]     ide0: BM-DMA at 0x2000-0x2007, BIOS settings: hda:pio, h=
db:pio
[   90.117982] Probing IDE interface ide0...
[   90.912321] hda: TSSTcorpCD-ROM TS-L162C, ATAPI CD/DVD-ROM drive
[   91.588684] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   91.591083] hda: ATAPI 24X CD-ROM drive, 96kB Cache, UDMA(33)
[   91.591556] Uniform CD-ROM driver Revision: 3.20
[   91.595730] Loading iSCSI transport class v2.0-724.
[   91.595970] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[   91.596198] ACPI: PCI Interrupt 0000:01:00.0[D] -> GSI 19 (level, low) -=
> IRQ 19
[   91.596791] ohci_hcd 0000:01:00.0: OHCI Host Controller
[   91.597076] ohci_hcd 0000:01:00.0: new USB bus registered, assigned bus =
number 1
[   91.597249] ohci_hcd 0000:01:00.0: irq 19, io mem 0xf7cf0000
[   91.657696] usb usb1: configuration #1 chosen from 1 choice
[   91.657870] hub 1-0:1.0: USB hub found
[   91.657982] hub 1-0:1.0: 3 ports detected
[   91.763541] ACPI: PCI Interrupt 0000:01:00.1[D] -> GSI 19 (level, low) -=
> IRQ 19
[   91.763940] ohci_hcd 0000:01:00.1: OHCI Host Controller
[   91.764213] ohci_hcd 0000:01:00.1: new USB bus registered, assigned bus =
number 2
[   91.764379] ohci_hcd 0000:01:00.1: irq 19, io mem 0xf7ce0000
[   91.825533] usb usb2: configuration #1 chosen from 1 choice
[   91.825706] hub 2-0:1.0: USB hub found
[   91.825818] hub 2-0:1.0: 3 ports detected
[   91.931524] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64=
 irq 1,12
[   91.933222] serio: i8042 KBD port at 0x60,0x64 irq 1
[   91.933348] serio: i8042 AUX port at 0x60,0x64 irq 12
[   91.933561] mice: PS/2 mouse device common for all mice
[   91.975617] input: AT Translated Set 2 keyboard as /class/input/input1
[   91.980984] md: linear personality registered for level -1
[   91.981098] md: raid0 personality registered for level 0
[   91.981210] md: raid1 personality registered for level 1
[   91.981384] usbcore: registered new interface driver hiddev
[   91.981540] usbcore: registered new interface driver usbhid
[   91.981654] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   91.981870] TCP cubic registered
[   91.982052] NET: Registered protocol family 1
[   91.982393] Freeing unused kernel memory: 1532k freed
[   91.984338] Write protecting the kernel read-only data: 4500k
[   92.001449] md: md0 stopped.
[   92.033825] md: bind<cciss/c0d1p1>
[   92.034308] md: bind<cciss/c0d0p1>
[   92.034601] raid1: raid set md0 active with 2 out of 2 mirrors
[   92.035827] md: md1 stopped.
[   92.062523] md: bind<cciss/c0d1p2>
[   92.062952] md: bind<cciss/c0d0p2>
[   92.063208] raid1: raid set md1 active with 2 out of 2 mirrors
[   92.064378] md: md2 stopped.
[   92.076005] md: bind<cciss/c0d1p3>
[   92.076437] md: bind<cciss/c0d0p3>
[   92.076691] raid1: raid set md2 active with 2 out of 2 mirrors
[   92.097676] kjournald starting.  Commit interval 5 seconds
[   92.097683] EXT3-fs: mounted filesystem with ordered data mode.
[   94.860415] tg3.c:v3.77 (May 31, 2007)
[   94.860638] ACPI: PCI Interrupt 0000:03:06.0[A] -> GSI 28 (level, low) -=
> IRQ 28
[   94.908955] eth0: Tigon3 [partno(N/A) rev 2100 PHY(5704)] (PCIX:133MHz:6=
4-bit) 10/100/1000Base-T Ethernet 00:18:71:e4:5e:8a
[   94.909465] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] =
TSOcap[0]
[   94.909615] eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[   94.909750] ACPI: PCI Interrupt 0000:03:06.1[B] -> GSI 29 (level, low) -=
> IRQ 29
[   94.910676] QLogic Fibre Channel HBA Driver
[   94.956852] eth1: Tigon3 [partno(N/A) rev 2100 PHY(5704)] (PCIX:133MHz:6=
4-bit) 10/100/1000Base-T Ethernet 00:18:71:e4:5e:89
[   94.957796] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] =
TSOcap[1]
[   94.958031] eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[   94.958299] ACPI: PCI Interrupt 0000:05:08.0[A] -> GSI 32 (level, low) -=
> IRQ 32
[   94.958757] qla2xxx 0000:05:08.0: Found an ISP2422, irq 32, iobase 0xfff=
fc200051d2000
[   94.959189] qla2xxx 0000:05:08.0: Configuring PCI space...
[   94.961756] qla2xxx 0000:05:08.0: Configure NVRAM parameters...
[   94.968368] qla2xxx 0000:05:08.0: Verifying loaded RISC code...
[   95.099707] PM: Writing back config space on device 0000:03:06.1 at offs=
et b (was 164814e4, writing d00e11)
[   95.099974] PM: Writing back config space on device 0000:03:06.1 at offs=
et 3 (was 804000, writing 804010)
[   95.100220] PM: Writing back config space on device 0000:03:06.1 at offs=
et 2 (was 2000000, writing 2000010)
[   95.100465] PM: Writing back config space on device 0000:03:06.1 at offs=
et 1 (was 2b00000, writing 2b00146)
[   95.184998] Adding 6540152k swap on /dev/md2.  Priority:-1 extents:1 acr=
oss:6540152k
[   95.256439] qla2xxx 0000:05:08.0: Allocated (64 KB) for EFT...
[   95.256708] qla2xxx 0000:05:08.0: Allocated (1413 KB) for firmware dump.=
=2E.
[   95.276458] scsi0 : qla2xxx
[   95.421174] EXT3 FS on md1, internal journal
[   95.537798] qla2xxx 0000:05:08.0: LIP reset occured (f700).
[   95.755814] PM: Writing back config space on device 0000:03:06.0 at offs=
et b (was 164814e4, writing d00e11)
[   95.756020] PM: Writing back config space on device 0000:03:06.0 at offs=
et 3 (was 804000, writing 804010)
[   95.756182] PM: Writing back config space on device 0000:03:06.0 at offs=
et 2 (was 2000000, writing 2000010)
[   95.756343] PM: Writing back config space on device 0000:03:06.0 at offs=
et 1 (was 2b00000, writing 2b00146)
[   96.539625] qla2xxx 0000:05:08.0: LOOP UP detected (4 Gbps).
[   96.601142] scsi 0:0:0:0: Direct-Access     ADVUNI   OXYGENRAID 424F  34=
7A PQ: 0 ANSI: 5
[   96.601849] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACI=
TY(16).
[   96.602090] sd 0:0:0:0: [sda] 19529912320 512-byte hardware sectors (999=
9315 MB)
[   96.602507] sd 0:0:0:0: [sda] Write Protect is off
[   96.602626] sd 0:0:0:0: [sda] Mode Sense: 9b 00 00 08
[   96.603020] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   96.603406] sd 0:0:0:0: [sda] Very big device. Trying to use READ CAPACI=
TY(16).
[   96.603633] sd 0:0:0:0: [sda] 19529912320 512-byte hardware sectors (999=
9315 MB)
[   96.604009] sd 0:0:0:0: [sda] Write Protect is off
[   96.604119] sd 0:0:0:0: [sda] Mode Sense: 9b 00 00 08
[   96.604492] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   96.604654]  sda: unknown partition table
[   96.605043] sd 0:0:0:0: [sda] Attached SCSI disk
[   96.605196] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   96.605915] scsi 0:0:1:0: Direct-Access     ADVUNI   OXYGENRAID 424F  34=
7A PQ: 0 ANSI: 5
[   96.606450] sd 0:0:1:0: [sdb] Very big device. Trying to use READ CAPACI=
TY(16).
[   96.606687] sd 0:0:1:0: [sdb] 19529912320 512-byte hardware sectors (999=
9315 MB)
[   96.607058] sd 0:0:1:0: [sdb] Write Protect is off
[   96.607169] sd 0:0:1:0: [sdb] Mode Sense: 9b 00 00 08
[   96.607546] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   96.607869] sd 0:0:1:0: [sdb] Very big device. Trying to use READ CAPACI=
TY(16).
[   96.608093] sd 0:0:1:0: [sdb] 19529912320 512-byte hardware sectors (999=
9315 MB)
[   96.608446] sd 0:0:1:0: [sdb] Write Protect is off
[   96.608557] sd 0:0:1:0: [sdb] Mode Sense: 9b 00 00 08
[   96.608921] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   96.609081]  sdb: unknown partition table
[   96.609408] sd 0:0:1:0: [sdb] Attached SCSI disk
[   96.609553] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   96.611290] qla2xxx 0000:05:08.0:=20
[   96.611291]  QLogic Fibre Channel HBA Driver: 8.01.07-k7
[   96.611293]   QLogic HP AE369-60001 - QLA2340
[   96.611294]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.0 hdma+, host=
#=3D0, fw=3D4.00.27 [IP]=20
[   96.611795] ACPI: PCI Interrupt 0000:05:08.1[B] -> GSI 33 (level, low) -=
> IRQ 33
[   96.612057] qla2xxx 0000:05:08.1: Found an ISP2422, irq 33, iobase 0xfff=
fc200051d8000
[   96.612344] qla2xxx 0000:05:08.1: Configuring PCI space...
[   96.614615] qla2xxx 0000:05:08.1: Configure NVRAM parameters...
[   96.621192] qla2xxx 0000:05:08.1: Verifying loaded RISC code...
[   96.867063] qla2xxx 0000:05:08.1: Allocated (64 KB) for EFT...
[   96.867291] qla2xxx 0000:05:08.1: Allocated (1413 KB) for firmware dump.=
=2E.
[   96.883079] scsi1 : qla2xxx
[   97.050576] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   97.079474] kjournald starting.  Commit interval 5 seconds
[   97.102710] EXT3 FS on md0, internal journal
[   97.102892] EXT3-fs: mounted filesystem with ordered data mode.
[   97.107581] NET: Registered protocol family 17
[   97.886212] tg3: eth2: Link is up at 1000 Mbps, full duplex.
[   97.886360] tg3: eth2: Flow control is on for TX and on for RX.
[   98.391136] tg3: eth3: Link is up at 1000 Mbps, full duplex.
[   98.391327] tg3: eth3: Flow control is off for TX and off for RX.
[  101.882801] qla2xxx 0000:05:08.1:=20
[  101.882802]  QLogic Fibre Channel HBA Driver: 8.01.07-k7
[  101.882803]   QLogic HP AE369-60001 - QLA2340
[  101.882805]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.1 hdma+, host=
#=3D1, fw=3D4.00.27 [IP]=20
[  110.025161] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[  110.029332] NFSD: starting 90-second grace period
[  119.024220] qla2xxx 0000:05:08.1: Cable is unplugged...
[  161.442311] PM: Writing back config space on device 0000:03:06.0 at offs=
et b (was 164814e4, writing d00e11)
[  161.442486] PM: Writing back config space on device 0000:03:06.0 at offs=
et 3 (was 804000, writing 804010)
[  161.442647] PM: Writing back config space on device 0000:03:06.0 at offs=
et 2 (was 2000000, writing 2000010)
[  161.442815] PM: Writing back config space on device 0000:03:06.0 at offs=
et 1 (was 2b00000, writing 2b00146)
[  168.405116] PM: Writing back config space on device 0000:03:06.0 at offs=
et b (was 164814e4, writing d00e11)
[  168.405296] PM: Writing back config space on device 0000:03:06.0 at offs=
et 3 (was 804000, writing 804010)
[  168.405461] PM: Writing back config space on device 0000:03:06.0 at offs=
et 2 (was 2000000, writing 2000010)
[  168.405629] PM: Writing back config space on device 0000:03:06.0 at offs=
et 1 (was 2b00000, writing 2b00146)
[  171.037813] tg3: eth3: Link is up at 1000 Mbps, full duplex.
[  171.037937] tg3: eth3: Flow control is off for TX and off for RX.
[  379.644485] PM: Writing back config space on device 0000:03:06.1 at offs=
et b (was 164814e4, writing d00e11)
[  379.644660] PM: Writing back config space on device 0000:03:06.1 at offs=
et 3 (was 804000, writing 804010)
[  379.644822] PM: Writing back config space on device 0000:03:06.1 at offs=
et 2 (was 2000000, writing 2000010)
[  379.644990] PM: Writing back config space on device 0000:03:06.1 at offs=
et 1 (was 2b00000, writing 2b00146)
[  383.429271] PM: Writing back config space on device 0000:03:06.0 at offs=
et b (was 164814e4, writing d00e11)
[  383.429450] PM: Writing back config space on device 0000:03:06.0 at offs=
et 3 (was 804000, writing 804010)
[  383.429614] PM: Writing back config space on device 0000:03:06.0 at offs=
et 2 (was 2000000, writing 2000010)
[  383.429778] PM: Writing back config space on device 0000:03:06.0 at offs=
et 1 (was 2b00000, writing 2b00146)
[  391.553182] PM: Writing back config space on device 0000:03:06.1 at offs=
et b (was 164814e4, writing d00e11)
[  391.553361] PM: Writing back config space on device 0000:03:06.1 at offs=
et 3 (was 804000, writing 804010)
[  391.553525] PM: Writing back config space on device 0000:03:06.1 at offs=
et 2 (was 2000000, writing 2000010)
[  391.553689] PM: Writing back config space on device 0000:03:06.1 at offs=
et 1 (was 2b00000, writing 2b00146)
[  394.188626] tg3: eth2: Link is up at 1000 Mbps, full duplex.
[  394.188753] tg3: eth2: Flow control is on for TX and on for RX.
[  409.079938] PM: Writing back config space on device 0000:03:06.0 at offs=
et b (was 164814e4, writing d00e11)
[  409.080115] PM: Writing back config space on device 0000:03:06.0 at offs=
et 3 (was 804000, writing 804010)
[  409.080277] PM: Writing back config space on device 0000:03:06.0 at offs=
et 2 (was 2000000, writing 2000010)
[  409.080445] PM: Writing back config space on device 0000:03:06.0 at offs=
et 1 (was 2b00000, writing 2b00146)
[  411.713469] tg3: eth3: Link is up at 1000 Mbps, full duplex.
[  411.713621] tg3: eth3: Flow control is off for TX and off for RX.


#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.22-rc6
# Thu Jun 28 14:51:35 2007
#
CONFIG_X86_64=3Dy
CONFIG_64BIT=3Dy
CONFIG_X86=3Dy
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_SEMAPHORE_SLEEPERS=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_RWSEM_GENERIC_SPINLOCK=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_X86_CMPXCHG=3Dy
CONFIG_EARLY_PRINTK=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_DMI=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_GENERIC_BUG=3Dy
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_LOCK_KERNEL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32

#
# General setup
#
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
# CONFIG_IPC_NS is not set
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
CONFIG_AUDIT=3Dy
# CONFIG_AUDITSYSCALL is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=3D17
CONFIG_CPUSETS=3Dy
CONFIG_SYSFS_DEPRECATED=3Dy
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D"initramfs.txt"
CONFIG_INITRAMFS_ROOT_UID=3D0
CONFIG_INITRAMFS_ROOT_GID=3D0
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_UID16=3Dy
CONFIG_SYSCTL_SYSCALL=3Dy
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=3Dy
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=3D0

#
# Loadable module support
#
CONFIG_MODULES=3Dy
CONFIG_MODULE_UNLOAD=3Dy
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=3Dy
CONFIG_MODULE_SRCVERSION_ALL=3Dy
CONFIG_KMOD=3Dy
CONFIG_STOP_MACHINE=3Dy

#
# Block layer
#
CONFIG_BLOCK=3Dy
# CONFIG_BLK_DEV_IO_TRACE is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_AS=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"

#
# Processor type and features
#
CONFIG_X86_PC=3Dy
# CONFIG_X86_VSMP is not set
CONFIG_MK8=3Dy
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=3D64
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_INTERNODE_CACHE_BYTES=3D64
CONFIG_X86_TSC=3Dy
CONFIG_X86_GOOD_APIC=3Dy
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_X86_IO_APIC=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
# CONFIG_MTRR is not set
CONFIG_SMP=3Dy
CONFIG_SCHED_SMT=3Dy
CONFIG_SCHED_MC=3Dy
CONFIG_PREEMPT_NONE=3Dy
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_NUMA=3Dy
CONFIG_K8_NUMA=3Dy
CONFIG_NODES_SHIFT=3D6
CONFIG_X86_64_ACPI_NUMA=3Dy
# CONFIG_NUMA_EMU is not set
CONFIG_ARCH_DISCONTIGMEM_ENABLE=3Dy
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_SELECT_MEMORY_MODEL=3Dy
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_NEED_MULTIPLE_NODES=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=3Dy
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_MIGRATION=3Dy
CONFIG_RESOURCES_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=3Dy
CONFIG_NR_CPUS=3D4
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy
CONFIG_HPET_TIMER=3Dy
CONFIG_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_X86_MCE=3Dy
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=3Dy
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_START=3D0x200000
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=3Dy
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D250
CONFIG_K8_NB=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy

#
# Power management options
#
CONFIG_PM=3Dy
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=3Dy
CONFIG_ACPI_PROCFS=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_FAN=3Dy
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=3Dy
CONFIG_ACPI_THERMAL=3Dy
CONFIG_ACPI_NUMA=3Dy
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dm
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dm
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dm
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_ACPI_CPUFREQ is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCIEPORTBUS=3Dy
CONFIG_PCIEAER=3Dy
CONFIG_ARCH_SUPPORTS_MSI=3Dy
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=3Dy

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_BINFMT_MISC=3Dy
CONFIG_IA32_EMULATION=3Dy
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy

#
# Networking
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dm
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dm
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=3Dm
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=3Dy
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dm
CONFIG_NET_IPGRE=3Dm
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=3Dy
CONFIG_INET_AH=3Dm
CONFIG_INET_ESP=3Dm
CONFIG_INET_IPCOMP=3Dm
CONFIG_INET_XFRM_TUNNEL=3Dm
CONFIG_INET_TUNNEL=3Dm
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dy
CONFIG_INET_XFRM_MODE_TUNNEL=3Dy
CONFIG_INET_XFRM_MODE_BEET=3Dy
CONFIG_INET_DIAG=3Dy
CONFIG_INET_TCP_DIAG=3Dy
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=3Dm
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=3Dm
CONFIG_IEEE80211_CRYPT_CCMP=3Dm
# CONFIG_IEEE80211_CRYPT_TKIP is not set
# CONFIG_IEEE80211_SOFTMAC is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=3Dy
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dy
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=3Dy

#
# Block devices
#
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=3Dy
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
CONFIG_BLK_DEV_CRYPTOLOOP=3Dm
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D65536
CONFIG_BLK_DEV_RAM_BLOCKSIZE=3D1024
CONFIG_CDROM_PKTCDVD=3Dm
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_BLINK is not set
CONFIG_IDE=3Dy
CONFIG_BLK_DEV_IDE=3Dy

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
# CONFIG_BLK_DEV_IDEDISK is not set
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=3Dy
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=3Dy

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_SHARE_IRQ=3Dy
CONFIG_IDEPCI_PCIBUS_ORDER=3Dy
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=3Dy
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=3Dy
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=3Dy
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=3Dy
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=3Dy
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=3Dy
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dy
CONFIG_SCSI_FC_ATTRS=3Dy
CONFIG_SCSI_ISCSI_ATTRS=3Dy
CONFIG_SCSI_SAS_ATTRS=3Dy
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=3Dm
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_ATA is not set

#
# Multi-device support (RAID and LVM)
#
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_LINEAR=3Dy
CONFIG_MD_RAID0=3Dy
CONFIG_MD_RAID1=3Dy
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=3Dm
CONFIG_MD_FAULTY=3Dm
# CONFIG_BLK_DEV_DM is not set

#
# Fusion MPT device support
#
CONFIG_FUSION=3Dy
CONFIG_FUSION_SPI=3Dm
CONFIG_FUSION_FC=3Dm
CONFIG_FUSION_SAS=3Dm
CONFIG_FUSION_MAX_SGE=3D128
CONFIG_FUSION_CTL=3Dm
CONFIG_FUSION_LAN=3Dm

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set

#
# Network device support
#
CONFIG_NETDEVICES=3Dy
CONFIG_DUMMY=3Dm
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=3Dm
CONFIG_NETDEV_1000=3Dy
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=3Dm
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=3Dy
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=3Dm
CONFIG_USB_KAWETH=3Dm
CONFIG_USB_PEGASUS=3Dm
CONFIG_USB_RTL8150=3Dm
# CONFIG_USB_USBNET_MII is not set
CONFIG_USB_USBNET=3Dm
CONFIG_USB_NET_CDCETHER=3Dm
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_GL620A=3Dm
CONFIG_USB_NET_NET1080=3Dm
CONFIG_USB_NET_PLUSB=3Dm
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=3Dm
CONFIG_USB_NET_CDC_SUBSET=3Dm
CONFIG_USB_ALI_M5632=3Dy
CONFIG_USB_AN2720=3Dy
CONFIG_USB_BELKIN=3Dy
CONFIG_USB_ARMLINUX=3Dy
CONFIG_USB_EPSON2888=3Dy
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=3Dm
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=3Dy
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=3Dm
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
CONFIG_KEYBOARD_SUNKBD=3Dy
CONFIG_KEYBOARD_LKKBD=3Dy
CONFIG_KEYBOARD_XTKBD=3Dy
CONFIG_KEYBOARD_NEWTON=3Dy
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dm
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=3Dm
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dy
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D48
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_MANY_PORTS=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=3Dy

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dy
CONFIG_SERIAL_JSM=3Dm
CONFIG_UNIX98_PTYS=3Dy
# CONFIG_LEGACY_PTYS is not set

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set
# CONFIG_WATCHDOG is not set
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dy
CONFIG_HW_RANDOM_AMD=3Dy
CONFIG_HW_RANDOM_GEODE=3Dy
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
CONFIG_GEN_RTC=3Dy
# CONFIG_GEN_RTC_X is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_AGP=3Dy
CONFIG_AGP_AMD64=3Dy
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set
# CONFIG_HWMON is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DVB_CORE=3Dm
# CONFIG_DVB_CORE_ATTACH is not set
CONFIG_DVB_CAPTURE_DRIVERS=3Dy
CONFIG_DVB_TTUSB_DEC=3Dm
CONFIG_DVB_CINERGYT2=3Dm
CONFIG_DVB_CINERGYT2_TUNING=3Dy
CONFIG_DVB_CINERGYT2_STREAM_URB_COUNT=3D32
CONFIG_DVB_CINERGYT2_STREAM_BUF_SIZE=3D512
CONFIG_DVB_CINERGYT2_QUERY_INTERVAL=3D250
CONFIG_DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE=3Dy
CONFIG_DVB_CINERGYT2_RC_QUERY_INTERVAL=3D100

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# Tuners/PLL support
#

#
# Miscellaneous devices
#
CONFIG_DAB=3Dy
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=3Dy

#
# Sound
#
# CONFIG_SOUND is not set

#
# HID Devices
#
CONFIG_HID=3Dy
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
CONFIG_USB_HIDINPUT_POWERBOOK=3Dy
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=3Dy

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dy
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
CONFIG_USB_DEVICE_CLASS=3Dy
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=3Dy
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
CONFIG_USB_SERIAL_AIRPRIME=3Dm
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=3Dm
CONFIG_USB_SERIAL_WHITEHEAT=3Dm
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=3Dm
CONFIG_USB_SERIAL_CP2101=3Dm
CONFIG_USB_SERIAL_CYPRESS_M8=3Dm
CONFIG_USB_SERIAL_EMPEG=3Dm
CONFIG_USB_SERIAL_FTDI_SIO=3Dm
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=3Dm
CONFIG_USB_SERIAL_IPAQ=3Dm
CONFIG_USB_SERIAL_IR=3Dm
CONFIG_USB_SERIAL_EDGEPORT=3Dm
CONFIG_USB_SERIAL_EDGEPORT_TI=3Dm
CONFIG_USB_SERIAL_GARMIN=3Dm
CONFIG_USB_SERIAL_IPW=3Dm
CONFIG_USB_SERIAL_KEYSPAN_PDA=3Dm
CONFIG_USB_SERIAL_KEYSPAN=3Dm
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
CONFIG_USB_SERIAL_KLSI=3Dm
CONFIG_USB_SERIAL_KOBIL_SCT=3Dm
CONFIG_USB_SERIAL_MCT_U232=3Dm
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dm
CONFIG_USB_SERIAL_HP4X=3Dm
CONFIG_USB_SERIAL_SAFE=3Dm
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_TI=3Dm
CONFIG_USB_SERIAL_CYBERJACK=3Dm
CONFIG_USB_SERIAL_XIRCOM=3Dm
# CONFIG_USB_SERIAL_OPTION is not set
CONFIG_USB_SERIAL_OMNINET=3Dm
# CONFIG_USB_SERIAL_DEBUG is not set
CONFIG_USB_EZUSB=3Dy

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# Virtualization
#
# CONFIG_KVM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=3Dy
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=3Dy
CONFIG_REISERFS_FS=3Dy
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_XFS_FS=3Dy
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_SECURITY is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_QUOTA=3Dy
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_AUTOFS_FS=3Dm
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=3Dy
CONFIG_HUGETLB_PAGE=3Dy
CONFIG_RAMFS=3Dy
CONFIG_CONFIGFS_FS=3Dm

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=3Dm
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=3Dm
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set

#
# Network File Systems
#
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V3=3Dy
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=3Dy
CONFIG_NFS_DIRECTIO=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V3=3Dy
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=3Dy
CONFIG_NFSD_TCP=3Dy
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=3Dm
CONFIG_RPCSEC_GSS_SPKM3=3Dm
CONFIG_SMB_FS=3Dm
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=3Dm
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=3Dm

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=3Dy
CONFIG_MSDOS_PARTITION=3Dy
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"cp437"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dm

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_MAGIC_SYSRQ=3Dy
CONFIG_UNUSED_SYMBOLS=3Dy
CONFIG_DEBUG_FS=3Dy
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=3Dy
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=3Dy
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_RT_MUTEXES=3Dy
CONFIG_DEBUG_PI_LIST=3Dy
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_PROVE_LOCKING=3Dy
CONFIG_LOCKDEP=3Dy
CONFIG_DEBUG_LOCKDEP=3Dy
CONFIG_TRACE_IRQFLAGS=3Dy
CONFIG_DEBUG_SPINLOCK_SLEEP=3Dy
CONFIG_DEBUG_LOCKING_API_SELFTESTS=3Dy
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_INFO=3Dy
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=3Dy
# CONFIG_FORCED_INLINING is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_DEBUG_RODATA=3Dy
# CONFIG_IOMMU_DEBUG is not set
CONFIG_DEBUG_STACKOVERFLOW=3Dy
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_HMAC=3Dy
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_SHA1=3Dm
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_CBC=3Dy
CONFIG_CRYPTO_PCBC=3Dm
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=3Dm
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
CONFIG_CRYPTO_SERPENT=3Dy
CONFIG_CRYPTO_AES=3Dy
# CONFIG_CRYPTO_AES_X86_64 is not set
CONFIG_CRYPTO_CAST5=3Dy
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=3Dy
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_DEFLATE=3Dy
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set

#
# Hardware crypto devices
#

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dm
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=3Dy
CONFIG_LIBCRC32C=3Dm
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Qn4G1eBrv+t66M9q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGinFnWto1QDEAkw8RAuKIAKCb0CsVejUMc1OvwQ0I0LlW9cNSpQCeLUyp
Vuis8oGBzOg+PTDZoXTZTZY=
=g7oZ
-----END PGP SIGNATURE-----

--Qn4G1eBrv+t66M9q--
