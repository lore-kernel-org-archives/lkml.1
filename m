Return-Path: <linux-kernel-owner+w=401wt.eu-S933720AbYB2XqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbYB2XqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbYB2XqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:46:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35240 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbYB2XqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:46:00 -0500
Date: Sat, 1 Mar 2008 10:45:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080301104554.c3fedf97.sfr@canb.auug.org.au>
In-Reply-To: <20080229130426.GB22335@cs181133002.pp.htv.fi>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080216000943.GD31474@flint.arm.linux.org.uk>
	<20080226145418.59f6f35f.sfr@canb.auug.org.au>
	<20080229234551.d8023f5c.sfr@canb.auug.org.au>
	<20080229130426.GB22335@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__1_Mar_2008_10_45_54_+1100_irr1Bhawx+nkl8dz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__1_Mar_2008_10_45_54_+1100_irr1Bhawx+nkl8dz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Adrian,

On Fri, 29 Feb 2008 15:04:26 +0200 Adrian Bunk <bunk@kernel.org> wrote:
>
> 2 errors are expected (long-standing breakages).
>=20
> 14 failures are due to your ancient gcc 4.0.2 not supporting -mabi=3Daapc=
s-linux:
> /scratch/sfr/next/scripts/mod/empty.c:1: error: invalid ABI option: -mabi=
=3Daapcs-linux
>=20
> Another one is an internal error in your ancient compiler:
> /scratch/sfr/next/arch/arm/common/it8152.c:148: internal compiler error: =
in trunc_int_for_mode, at explow.c:53
>=20
> Can you build a cross compiler using gcc 4.2.3 from ftp.gnu.org instead?
> That one serves me perfectly for my cross-compile tests.

OK, thanks for the feedback it is very helpful.  I will look at building
a newer compiler on Monday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__1_Mar_2008_10_45_54_+1100_irr1Bhawx+nkl8dz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHyJk4TgG2atn1QN8RAoNnAJ9lN4R8ioRMCuqfO68LR5xc7G7/KwCfd2uX
JDBUIT13uT6LVS1MnAEM5/Y=
=YHT/
-----END PGP SIGNATURE-----

--Signature=_Sat__1_Mar_2008_10_45_54_+1100_irr1Bhawx+nkl8dz--
