Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYIDFUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYIDFUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 01:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYIDFUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 01:20:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33715 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYIDFUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 01:20:39 -0400
Date: Thu, 4 Sep 2008 15:20:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080904152015.3145b06e.sfr@canb.auug.org.au>
In-Reply-To: <20080903220546.bd673658.akpm@linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<20080903215455.792c78a3.akpm@linux-foundation.org>
	<20080904145744.3f791ca7.sfr@canb.auug.org.au>
	<20080903220546.bd673658.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Sep_2008_15_20_15_+1000_UAzYWt9izz.wEp_S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Sep_2008_15_20_15_+1000_UAzYWt9izz.wEp_S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 3 Sep 2008 22:05:46 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> Thank gawd for that.
>=20
> This breakage spans over 1000 commits.  Not sure how that can happen in
> a rebased tree, but whatever.

It happens because I merge that tree into linux-next early in the
sequence and the two builds I do after each merge did not get the error
(*and* David really did not do enough testing ...). The set of builds I
do after merging all the trees hit that so I added a commit to the end of
linux-next to fix it.

That particular build bug will not be in today's linux-next because that
particular tree has been fixed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Sep_2008_15_20_15_+1000_UAzYWt9izz.wEp_S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki/cA8ACgkQjjKRsyhoI8zGpQCfaAsbUkNJRPxCz7J6XtRkvaFm
T1wAn1zXeoFvyM3yrYlfLi5dLdDUj6Ew
=vuM1
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Sep_2008_15_20_15_+1000_UAzYWt9izz.wEp_S--
