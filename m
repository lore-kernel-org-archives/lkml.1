Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZDRIdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZDRIdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZDRIdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:33:24 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:44630 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZDRIdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:33:21 -0400
Message-ID: <49E9904A.5030201@web.de>
Date: Sat, 18 Apr 2009 10:33:14 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
References: <49E89D1B.7060800@suse.com>
In-Reply-To: <49E89D1B.7060800@suse.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB88E3F2F46A0679A6D652935"
X-Provags-ID: V01U2FsdGVkX19SRWIxv1Re61J7rAftz+UPl4TTyjQ3yscQPL1T
	tRpBpW68Q0YdAYbuETkVUPc6wXt3jwSEJi7bu3RCmAi0BSWN1v
	4FtPiT5V0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB88E3F2F46A0679A6D652935
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jeff Mahoney wrote:
> Hi all -
>=20
> I saw this while booting 2.6.30-rc1, -rc2, and today's git, on one of
> my development nodes. This output is with apic=3Ddebug. With noapic,
> it still hung. Both outputs follow.
>=20
> git bisect leads to commit 8d6f0c8214928f7c5083dd54ecb69c5d615b516e,
> but I'm not seeing anything obvious there. Backing just that change
> out doesn't fix it.
>=20
> -Jeff
>=20
> apic=3Ddebug:
>=20
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.30-rc2-vanilla (jeffm@sled2) (gcc vers=
ion 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #22 SMP Thu Apr=
 16 17:25:38 EDT 2009
> [    0.000000] Command line: root=3D/dev/disk/by-id/ata-ST3120813AS_3LS=
0FAGL-part10 eth0=3Ddhcp console=3Dtty0 console=3DttyS0,115200 resume=3D/=
dev/disk/by-id/ata-ST3120813AS_3LS0FAGL-part6 splash=3Dsilent showopts vg=
a=3D0x314 apic=3Ddebug
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)=

> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserve=
d)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserve=
d)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000f7ff0000 (usable)=

> [    0.000000]  BIOS-e820: 00000000f7ff0000 - 00000000f7fff000 (ACPI da=
ta)
> [    0.000000]  BIOS-e820: 00000000f7fff000 - 00000000f8000000 (ACPI NV=
S)
> [    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserve=
d)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000200000000 (usable)=

> [    0.000000] DMI 2.3 present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working aro=
und it.
> [    0.000000] last_pfn =3D 0x200000 max_arch_pfn =3D 0x100000000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x70106=
00070106
> [    0.000000] last_pfn =3D 0xf7ff0 max_arch_pfn =3D 0x100000000
> [    0.000000] Scanning 0 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved=
)
> [    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
> [    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved=
)
> [    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved=
)
> [    0.000000]  modified: 0000000000100000 - 00000000f7ff0000 (usable)
> [    0.000000]  modified: 00000000f7ff0000 - 00000000f7fff000 (ACPI dat=
a)
> [    0.000000]  modified: 00000000f7fff000 - 00000000f8000000 (ACPI NVS=
)
> [    0.000000]  modified: 00000000ff780000 - 0000000100000000 (reserved=
)
> [    0.000000]  modified: 0000000100000000 - 0000000200000000 (usable)
> [    0.000000] init_memory_mapping: 0000000000000000-00000000f7ff0000
> [    0.000000] init_memory_mapping: 0000000100000000-0000000200000000
> [    0.000000] RAMDISK: 37a0b000 - 37fefed3
> [    0.000000] ACPI: RSDP 00000000000f6d40 00024 (v02 ACPIAM)
> [    0.000000] ACPI: XSDT 00000000f7ff0100 00054 (v01 A M I  OEMXSDT  0=
6000514 MSFT 00000097)
> [    0.000000] ACPI: FACP 00000000f7ff0281 000F4 (v01 A M I  OEMFACP  0=
6000514 MSFT 00000097)
> [    0.000000] ACPI: DSDT 00000000f7ff0410 03591 (v01  0AAAA 0AAAA001 0=
0000001 INTL 02002026)
> [    0.000000] ACPI: FACS 00000000f7fff000 00040
> [    0.000000] ACPI: APIC 00000000f7ff0380 00084 (v01 A M I  OEMAPIC  0=
6000514 MSFT 00000097)
> [    0.000000] ACPI: OEMB 00000000f7fff040 00041 (v01 A M I  OEMBIOS  0=
6000514 MSFT 00000097)
> [    0.000000] ACPI: SRAT 00000000f7ff39b0 00110 (v01 A M I  OEMSRAT  0=
6000514 MSFT 00000097)
> [    0.000000] ACPI: HPET 00000000f7ff3ac0 00038 (v01 A M I  OEMHPET  0=
6000514 MSFT 00000097)
> [    0.000000] ACPI: ASF! 00000000f7ff3b00 00086 (v01 AMIASF AMDSTRET 0=
0000001 INTL 02002026)
> [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
> [    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
> [    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
> [    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
> [    0.000000] SRAT: Node 0 PXM 0 100000-f8000000
> [    0.000000] SRAT: Node 1 PXM 1 100000000-200000000
> [    0.000000] SRAT: Node 0 PXM 0 100000000-100000000
> [    0.000000] SRAT: Node 0 PXM 0 0-9fc00
> [    0.000000] Bootmem setup node 0 0000000000000000-0000000100000000
> [    0.000000]   NODE_DATA [000000000001c040 - 000000000003403f]
> [    0.000000]   bootmap [0000000000035000 -  0000000000054fff] pages 2=
0
> [    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 010=
0000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> =
[0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> =
[0000006000 - 0000008000]
> [    0.000000]   #2 [0000200000 - 00009e0d9c]    TEXT DATA BSS =3D=3D> =
[0000200000 - 00009e0d9c]
> [    0.000000]   #3 [0037a0b000 - 0037fefed3]          RAMDISK =3D=3D> =
[0037a0b000 - 0037fefed3]
> [    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved =3D=3D> =
[000009d000 - 0000100000]
> [    0.000000]   #5 [00009e1000 - 00009e11ad]              BRK =3D=3D> =
[00009e1000 - 00009e11ad]
> [    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE =3D=3D> =
[0000010000 - 0000014000]
> [    0.000000]   #7 [0000014000 - 0000018000]          PGTABLE =3D=3D> =
[0000014000 - 0000018000]
> [    0.000000]   #8 [0000018000 - 000001c040]       MEMNODEMAP =3D=3D> =
[0000018000 - 000001c040]
> [    0.000000] Bootmem setup node 1 0000000100000000-0000000200000000
> [    0.000000]   NODE_DATA [0000000100000000 - 0000000100017fff]
> [    0.000000]   bootmap [0000000100018000 -  0000000100037fff] pages 2=
0
> [    0.000000] (9 early reservations) =3D=3D> bootmem [0100000000 - 020=
0000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
> [    0.000000]   #2 [0000200000 - 00009e0d9c]    TEXT DATA BSS
> [    0.000000]   #3 [0037a0b000 - 0037fefed3]          RAMDISK
> [    0.000000]   #4 [000009d000 - 0000100000]    BIOS reserved
> [    0.000000]   #5 [00009e1000 - 00009e11ad]              BRK
> [    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE
> [    0.000000]   #7 [0000014000 - 0000018000]          PGTABLE
> [    0.000000]   #8 [0000018000 - 000001c040]       MEMNODEMAP
> [    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
> [    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
> [    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
> [    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
> [    0.000000]   mpc: fa3b0-fa50c
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00200000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x000f7ff0
> [    0.000000]     1: 0x00100000 -> 0x00200000
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] Detected use of extended apic ids on hypertransport bus
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI=
 0-23
> [    0.000000] ACPI: IOAPIC (id[0x05] address[0xfebff000] gsi_base[24])=

> [    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfebff000, GSI=
 24-27
> [    0.000000] ACPI: IOAPIC (id[0x06] address[0xfebfe000] gsi_base[28])=

> [    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfebfe000, GSI=
 28-31
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=

> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=

> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x102282a0 base: 0xfec01000
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
> [    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
> [    0.000000] mapped IOAPIC to ffffffffff5fa000 (febff000)
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (febfe000)
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 0000000=
0000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000=
0000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000=
000100000
> [    0.000000] PM: Registered nosave memory: 00000000f7ff0000 - 0000000=
0f7fff000
> [    0.000000] PM: Registered nosave memory: 00000000f7fff000 - 0000000=
0f8000000
> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 0000000=
0ff780000
> [    0.000000] PM: Registered nosave memory: 00000000ff780000 - 0000000=
100000000
> [    0.000000] Allocating PCI resources starting at f8800000 (gap: f800=
0000:7780000)
> [    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids=
:2
> [    0.000000] PERCPU: Remapped at ffffc20000000000 with large pages, s=
tatic data 71776 bytes
> [    0.000000] Built 2 zonelists in Node order, mobility grouping on.  =
Total pages: 2033901
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=3D/dev/disk/by-id/ata-ST312081=
3AS_3LS0FAGL-part10 eth0=3Ddhcp console=3Dtty0 console=3DttyS0,115200 res=
ume=3D/dev/disk/by-id/ata-ST3120813AS_3LS0FAGL-part6 splash=3Dsilent show=
opts vga=3D0x314 apic=3Ddebug
> [    0.000000] Initializing CPU#0
> [    0.000000] Experimental hierarchical RCU implementation.
> [    0.000000] Experimental hierarchical RCU init done.
> [    0.000000] NR_IRQS:4352 nr_irqs:576
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2192.534 MHz processor.
> [    0.004000] Console: colour dummy device 80x25
> [    0.004000] console [tty0] enabled
> [    0.004000] console [ttyS0] enabled
> [    0.004000] allocated 82575360 bytes of page_cgroup
> [    0.004000] please try cgroup_disable=3Dmemory option if you don't w=
ant
> [    0.004000] Checking aperture...
> [    0.004000] No AGP bridge found
> [    0.004000] Node 0: aperture @ 0 size 32 MB
> [    0.004000] Your BIOS doesn't leave a aperture memory hole
> [    0.004000] Please enable the IOMMU option in the BIOS setup
> [    0.004000] This costs you 64 MB of RAM
> [    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
> [    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000=
024000000
> [    0.004000] Memory: 7981076k/8388608k available (3350k kernel code, =
131588k absent, 275944k reserved, 1936k data, 1544k init)
> [    0.004000] HPET: 3 timers in total, 0 timers will be used for per-c=
pu timer
> [    0.004010] Calibrating delay loop (skipped), value calculated using=
 timer frequency.. 4385.06 BogoMIPS (lpj=3D8770136)
> [    0.008000] Security Framework initialized
> [    0.008000] SELinux:  Disabled at boot.
> [    0.008000] Dentry cache hash table entries: 1048576 (order: 11, 838=
8608 bytes)
> [    0.008000] Inode-cache hash table entries: 524288 (order: 10, 41943=
04 bytes)
> [    0.008000] Mount-cache hash table entries: 256
> [    0.008000] Initializing cgroup subsys ns
> [    0.008000] Initializing cgroup subsys cpuacct
> [    0.008000] Initializing cgroup subsys memory
> [    0.008000] Initializing cgroup subsys devices
> [    0.008000] Initializing cgroup subsys freezer
> [    0.008000] Initializing cgroup subsys net_cls
> [    0.008000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 by=
tes/line)
> [    0.008000] CPU: L2 Cache: 1024K (64 bytes/line)
> [    0.008000] CPU 0/0x0 -> Node 0
> [    0.008000] CPU: Physical Processor ID: 0
> [    0.008000] CPU: Processor Core ID: 0
> [    0.008000] ACPI: Core revision 20090320
> [    0.008000] Setting APIC routing to flat
> [    0.008000] Getting VERSION: 40010
> [    0.008000] Getting VERSION: 40010
> [    0.008000] Getting ID: 0
> [    0.008000] Getting ID: ff000000
> [    0.008000] Getting LVT0: 700
> [    0.008000] Getting LVT1: 400
> [    0.008000] enabled ExtINT on CPU#0
> [    0.008000] ESR value before enabling vector: 0x00000004  after: 0x0=
0000000
> [    0.008000] ENABLING IO-APIC IRQs
> [    0.008000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=
=3D0
> [    0.008000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.008000] ...trying to set up timer (IRQ0) through the 8259A ...
> [    0.008000] ..... (found apic 0 pin 0) ...
> [    0.008000] ....... failed.
> [    0.008000] ...trying to set up timer as Virtual Wire IRQ...
> [    0.008000] ..... failed.
> [    0.008000] ...trying to set up timer as ExtINT IRQ...
> [    0.008000] ..... failed :(.
> [    0.008000] Kernel panic - not syncing: IO-APIC + timer doesn't work=
!  Boot with apic=3Ddebug and send a report.  Then try booting with the '=
noapic' option.

Hmmmmm. That somehow reminds me of what I thought I had to fix in the
HPET emulation of QEMU just recently [1] - because of 2.6.30-rc's behavio=
r.

Could you try if writing 'delta' a second time makes any difference on
that box?

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 648b3a2..523d72b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -324,6 +324,7 @@ static void hpet_set_mode(enum clock_event_mode mode,=

 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
+		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
 		hpet_start_counter();
 		hpet_print_config();
 		break;

Thanks,
Jan

[1] http://permalink.gmane.org/gmane.comp.emulators.qemu/41570


--------------enigB88E3F2F46A0679A6D652935
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknpkE4ACgkQniDOoMHTA+lyGACdF6c00xTy8g3B6G2OkBzZ1crE
zdQAmwabfOtsn9/B40b9MNNjB11UrBmb
=355s
-----END PGP SIGNATURE-----

--------------enigB88E3F2F46A0679A6D652935--
