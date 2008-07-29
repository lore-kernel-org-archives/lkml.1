Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYG2D5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYG2D5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYG2D5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:57:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34384 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYG2D5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:57:12 -0400
Date: Tue, 29 Jul 2008 13:56:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, joerg.roedel@amd.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
Message-Id: <20080729135652.f89042c1.sfr@canb.auug.org.au>
In-Reply-To: <20080729104722H.fujita.tomonori@lab.ntt.co.jp>
References: <20080725233325W.fujita.tomonori@lab.ntt.co.jp>
	<20080726134156.GC4401@elte.hu>
	<20080729110749.728c54e6.sfr@canb.auug.org.au>
	<20080729104722H.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jul_2008_13_56_52_+1000_X9X/exck9Sc6I/dy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jul_2008_13_56_52_+1000_X9X/exck9Sc6I/dy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,=20

On Tue, 29 Jul 2008 10:46:31 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt=
.co.jp> wrote:
>
> > So, I assume a patch created on July 25 is not destined for 2.6.27,
>=20
> Hmm, seems that they will go into 2.6.27:
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D121729275722287&w=3D2
>=20
>=20
> > right?  Especially since it breaks another architecture build and has
> > only made it to linux-next on July 29 ... and needs more work given the
> > comments already on this patch.
>=20
> It doesn't break another architecture build since only x86 IOMMUs use
> the helper function. But as I pointed out, it doesn't work for some
> architectures.

Um, did you see the linux-next build report I posted (possibly not):

arch/powerpc/kernel/iommu.c:56: error: static declaration of 'iommu_num_pag=
es' follows non-static declaration
include/linux/iommu-helper.h:11: error: previous declaration of 'iommu_num_=
pages' was here

This is now a build of 2.6.27-rc1 for powerpc64 ppc64_defconfig ...

So we have a patch first posted to lkml on July 25 first hits linux-next
on July 29 and is no in Linus' tree on July 29.  A grep would have found
the problem.

More care required ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jul_2008_13_56_52_+1000_X9X/exck9Sc6I/dy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiOlQQACgkQjjKRsyhoI8zysgCgmihpZhmUz7KiajEUPaF/JEm7
JkYAnRiJj5vhpe8iqcXEO/TPTI+zaRwT
=pcyZ
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jul_2008_13_56_52_+1000_X9X/exck9Sc6I/dy--
