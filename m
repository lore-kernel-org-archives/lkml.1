Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbYDBHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbYDBHST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbYDBHSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:18:00 -0400
Received: from ozlabs.org ([203.10.76.45]:35267 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbYDBHR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:17:59 -0400
Subject: Re: [BUG] 2.6.25-rc8-mm1 kernel panic while bootup on powerpc
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47F330FF.3050806@linux.vnet.ibm.com>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	 <47F326E0.3010604@linux.vnet.ibm.com>
	 <20080401233909.23220623.akpm@linux-foundation.org>
	 <47F330FF.3050806@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bosSrVyBWJmMrKnR8vcF"
Date: Wed, 02 Apr 2008 18:17:56 +1100
Message-Id: <1207120676.7349.11.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bosSrVyBWJmMrKnR8vcF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-04-02 at 12:38 +0530, Kamalesh Babulal wrote:
> Andrew Morton wrote:
> > On Wed, 02 Apr 2008 11:55:36 +0530 Kamalesh Babulal <kamalesh@linux.vne=
t.ibm.com> wrote:
> >=20
> >> Hi Andrew,
> >>
> >> The 2.6.25-rc8-mm1 kernel panic's while bootup on the power machine(s)=
.
> >>
> >> [    0.000000] ------------[ cut here ]------------
> >> [    0.000000] kernel BUG at arch/powerpc/mm/init_64.c:240!
> >> [    0.000000] Oops: Exception in kernel mode, sig: 5 [#1]
> >> [    0.000000] SMP NR_CPUS=3D32 NUMA PowerMac
> >> [    0.000000] Modules linked in:
> >> [    0.000000] NIP: c0000000003d1dcc LR: c0000000003d1dc4 CTR: c000000=
00002b6ac
> >> [    0.000000] REGS: c00000000049b960 TRAP: 0700   Not tainted  (2.6.2=
5-rc8-mm1-autokern1)
> >> [    0.000000] MSR: 9000000000021032 <ME,IR,DR>  CR: 44000088  XER: 20=
000000
> >> [    0.000000] TASK =3D c0000000003f9c90[0] 'swapper' THREAD: c0000000=
00498000 CPU: 0
> >> [    0.000000] GPR00: c0000000003d1dc4 c00000000049bbe0 c0000000004989=
d0 0000000000000001=20
> >> [    0.000000] GPR04: d59aca40f0000000 000000000b000000 00000000000000=
10 0000000000000000=20
> >> [    0.000000] GPR08: 0000000000000004 0000000000000001 c00000027e5208=
00 c0000000004bf0f0=20
> >> [    0.000000] GPR12: c0000000004bf020 c0000000003fa900 00000000000000=
00 0000000000000000=20
> >> [    0.000000] GPR16: 0000000000000000 0000000000000000 00000000000000=
00 0000000000000000=20
> >> [    0.000000] GPR20: 0000000000000000 0000000000000000 00000000000000=
00 4000000001400000=20
> >> [    0.000000] GPR24: 00000000017d64b0 c0000000003d6250 00000000000000=
00 c000000000504000=20
> >> [    0.000000] GPR28: 0000000000000000 cf000000001f8000 00000000010000=
00 cf00000000000000=20
> >> [    0.000000] NIP [c0000000003d1dcc] .vmemmap_populate+0xb8/0xf4
> >> [    0.000000] LR [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4
> >> [    0.000000] Call Trace:
> >> [    0.000000] [c00000000049bbe0] [c0000000003d1dc4] .vmemmap_populate=
+0xb0/0xf4 (unreliable)
> >> [    0.000000] [c00000000049bc70] [c0000000003d2ee8] .sparse_mem_map_p=
opulate+0x38/0x60
> >> [    0.000000] [c00000000049bd00] [c0000000003c242c] .sparse_early_mem=
_map_alloc+0x54/0x94
> >> [    0.000000] [c00000000049bd90] [c0000000003c250c] .sparse_init+0xa0=
/0x20c
> >> [    0.000000] [c00000000049be50] [c0000000003ab7d0] .setup_arch+0x1ac=
/0x218
> >> [    0.000000] [c00000000049bee0] [c0000000003a36ac] .start_kernel+0xe=
0/0x3fc
> >> [    0.000000] [c00000000049bf90] [c000000000008594] .start_here_commo=
n+0x54/0xc0
> >> [    0.000000] Instruction dump:
> >> [    0.000000] 7fe3fb78 7ca02a14 4082000c 3860fff4 4800003c e92289c8 e=
96289c0 e9090002=20
> >> [    0.000000] e8eb0002 4bc575cd 60000000 78630fe0 <0b030000> 7ffff214=
 7fbfe840 7fe3fb78=20
> >> [    0.000000] ---[ end trace 31fd0ba7d8756001 ]---
> >> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle =
task!
> >>
> >=20
> > int __meminit vmemmap_populate(struct page *start_page,
> > 					unsigned long nr_pages, int node)
> > {
> > 	unsigned long mode_rw;
> > 	unsigned long start =3D (unsigned long)start_page;
> > 	unsigned long end =3D (unsigned long)(start_page + nr_pages);
> > 	unsigned long page_size =3D 1 << mmu_psize_defs[mmu_linear_psize].shif=
t;
> >=20
> > 	mode_rw =3D _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_COHERENT | PP_RWXX;
> >=20
> > 	/* Align to the page size of the linear mapping. */
> > 	start =3D _ALIGN_DOWN(start, page_size);
> >=20
> > 	for (; start < end; start +=3D page_size) {
> > 		int mapped;
> > 		void *p;
> >=20
> > 		if (vmemmap_populated(start, page_size))
> > 			continue;
> >=20
> > 		p =3D vmemmap_alloc_block(page_size, node);
> > 		if (!p)
> > 			return -ENOMEM;
> >=20
> > 		pr_debug("vmemmap %08lx allocated at %p, physical %08lx.\n",
> > 			start, p, __pa(p));
> >=20
> > 		mapped =3D htab_bolt_mapping(start, start + page_size,
> > 					__pa(p), mode_rw, mmu_linear_psize,
> > 					mmu_kernel_ssize);
> > =3D=3D=3D=3D=3D>		BUG_ON(mapped < 0);
> > 	}
> >=20
> > 	return 0;
> > }
> >=20
> > Beats me.  pseries?  Badari has been diddling with the bolted memory co=
de
> > in git-powerpc...
>=20
> One of the machines is the Power5 and another is PowerMac G5, on which th=
e=20
> same kernel panic is seen.

Can you enable DEBUG_LOW in arch/powerpc/platforms/pseries/lpar.c, that
should show what's happening in hpte_insert().

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-bosSrVyBWJmMrKnR8vcF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8zMkdSjSd0sB4dIRAnp2AJ99v7Bil1TkqxTgp1tAKNOlLn0iwACfXnNB
tOfCDXRhLra3Oc6tnU9g13A=
=WmVb
-----END PGP SIGNATURE-----

--=-bosSrVyBWJmMrKnR8vcF--

