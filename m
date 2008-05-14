Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYENWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYENWGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYENWGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:06:30 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:37008 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754093AbYENWG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:06:27 -0400
Subject: Re: 2.6.26-rc2-mm1
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, me <dhazelton@enter.net>
In-Reply-To: <200805141714.42129.dhazelton@enter.net>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <1210798147.4234.5.camel@localhost>
	 <20080514140032.83fc25b7.akpm@linux-foundation.org>
	 <200805141714.42129.dhazelton@enter.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AQBQw5x+JL7CHVDUmMaZ"
Date: Wed, 14 May 2008 16:06:11 -0600
Message-Id: <1210802771.3784.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080514/1JwP6y-0003K8-OU-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AQBQw5x+JL7CHVDUmMaZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-14 at 17:14 -0400, me wrote:
> On Wednesday 14 May 2008 05:00:32 pm Andrew Morton wrote:
> > On Wed, 14 May 2008 14:49:07 -0600
> >
> > Zan Lynx <zlynx@acm.org> wrote:
> > > On Wed, 2008-05-14 at 01:01 -0700, Andrew Morton wrote:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.2=
6-rc
> > > >2/2.6.26-rc2-mm1/
> > > >
> > > >
> > > > - The -mm tree is now based on linux-next.
> > > >
> > > >   I will occasionally pick up later versions of trees which are alr=
eady
> > > >   in linux-next, to catch material which was added after Stephen la=
st
> > > >   pulled that tree.  That happened this time: git-net had a lot of
> > > > driver changes which weren't in linux-next and which I wanted in
> > > >   2.6.26-rc2-mm1.
> > > >
> > > > - A few more git trees were added: git-ubifs.patch,
> > > > git-regulator.patch, git-logfs.patch, git-orion.patch.
> > >
> > > No good on my first attempt.  Here is what I ran into:
> > >
> > > The printk timestamps have gone wild.  I cannot paste a dmesg but her=
e
> > > is one line I wrote down:
> > > [17180644.495790] Testing tracer ftrace: NMI watchdog ...
> >
> > I've seen reports like this against mainline, but I'm not sure that
> > much has been done about it yet.
>=20
> I've reported problems with -next and ftrace. The timestamps look very si=
milar=20
> to what I've seen as well. I don't have those kernels available anymore -=
 I=20
> decided to wipe my system and move to a distro where it's easier to test =
new=20
> kernels.

I disabled a bunch of trace and self test options, and I am now running
2.6.26-rc2-mm1.  So far, so good.

I am including some dmesg with the weird timestamps in case it is useful
to anyone.

[    0.000000] Linux version 2.6.26-rc2-mm1 (lynx@zephyr) (gcc version 4.3.=
0 (Gentoo 4.3.0 p1.0) ) #13 SMP Wed May 14 15:16:26 MDT 2008
[    0.000000] Command line: root=3D/dev/sda2 rootfstype=3Dreiser4 rootflag=
s=3Ddefaults,noatime i8042.nomux elevator=3Dcfq resume=3D/dev/sda3 panic=3D=
5 debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff70000 (usable)
[    0.000000]  BIOS-e820: 000000003ff70000 - 000000003ff7f000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff7f000 - 000000003ff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] max_pfn_mapped =3D 1048576
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] init_memory_mapping
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F7240, 0014 (r0 PTLTD )
[    0.000000] ACPI: RSDT 3FF7A87E, 0034 (r1 PTLTD    RSDT    6040000  LTP =
       0)
[    0.000000] ACPI: FACP 3FF7EE13, 0074 (r1 NVIDIA CK8       6040000 PTL_ =
   F4240)
[    0.000000] ACPI: DSDT 3FF7A8B2, 4561 (r1 NVIDIA      CK8  6040000 MSFT =
 100000E)
[    0.000000] ACPI: FACS 3FF7FFC0, 0040
[    0.000000] ACPI: APIC 3FF7EE87, 005A (r1 NVIDIA NV_APIC_  6040000  LTP =
       0)
[    0.000000] ACPI: BOOT 3FF7EEE1, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP =
       1)
[    0.000000] ACPI: SSDT 3FF7EF09, 00F7 (r1 PTLTD  POWERNOW  6040000  LTP =
       1)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-8f5977] TEXT DATA BSS
[    0.000000]   early res: 3 [9f800-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-afff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20000dfffff] PMD -> [ffff81000120000=
0-ffff810001ffffff] on node 0
[    0.000000] sizeof(struct page) =3D 56
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262000
[    0.000000] On node 0 totalpages: 261903
[    0.000000]   DMA zone: 2060 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 254378 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-2=
3
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
d0000
[    0.000000] PM: Registered nosave memory: 00000000000d0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000=
:bff80000)
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 33840 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 1
[17180642.907074] Built 1 zonelists in Zone order, mobility grouping on.  T=
otal pages: 256438
[17180642.907074] Kernel command line: root=3D/dev/sda2 rootfstype=3Dreiser=
4 rootflags=3Ddefaults,noatime i8042.nomux elevator=3Dcfq resume=3D/dev/sda=
3 panic=3D5 debug
[17180642.907074] Initializing CPU#0
[17180642.907074] PID hash table entries: 4096 (order: 12, 32768 bytes)
[17180642.907074] TSC calibrated against PM_TIMER
[17180642.907074] time.c: Detected 797.940 MHz processor.

--=20
Zan Lynx <zlynx@acm.org>

--=-AQBQw5x+JL7CHVDUmMaZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgrYlMACgkQolqWs/Y4NLx2jACfbz5bKRmJWRa3APCnaMJNTXdu
3EsAn20211P90KPVHoR1YXyrBNyo1yXq
=Dj3x
-----END PGP SIGNATURE-----

--=-AQBQw5x+JL7CHVDUmMaZ--

