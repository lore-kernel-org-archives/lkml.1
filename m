Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbXGYWWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbXGYWWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXGYWWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:22:32 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33532 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750822AbXGYWWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:22:31 -0400
Subject: Re: -mm merge plans for 2.6.23
From: Zan Lynx <zlynx@acm.org>
To: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, rene.herman@gmail.com,
       Valdis.Kletnieks@vt.edu, david@lang.hm, nickpiggin@yahoo.com.au,
       ray-lk@madrabbit.org, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       ck@vds.kolivas.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070725150509.4d80a85e.pj@sgi.com>
References: <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu>
	 <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu>
	 <46A70D37.3060005@gmail.com> <20070725113401.GA23341@elte.hu>
	 <20070725150509.4d80a85e.pj@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IBxGqHANLpnHXsRehCQK"
Date: Wed, 25 Jul 2007 16:22:12 -0600
Message-Id: <1185402132.9409.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IBxGqHANLpnHXsRehCQK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-25 at 15:05 -0700, Paul Jackson wrote:
[snip]
> Question:
>   Could those who have found this prefetch helps them alot say how
>   many disks they have?  In particular, is their swap on the same
>   disk spindle as their root and user files?
>=20
> Answer - for me:
>   On my system where updatedb is a big problem, I have one, slow, disk.
>   On my system where updatedb is a small problem, swap is on a separate
>     spindle.
>   On my system where updatedb is -no- problem, I have so much memory
>     I never use swap.
>=20
> I'd expect the laptop crowd to mostly have a single, slow, disk, and
> hence to find updatedb more painful.

A well done swap-to-flash would help here.  I sometimes do it anyway to
a 4GB CF card but I can tell it's hitting the read/update/write cycles
on the flash blocks.  The sad thing is that it is still a speed
improvement over swapping to laptop disk.
--=20
Zan Lynx <zlynx@acm.org>

--=-IBxGqHANLpnHXsRehCQK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGp80UG8fHaOLTWwgRAoDzAJ9TmBn/QvPI6JZs6QbqHtyTZoohoACfX/aw
LrxpMh3c7H/9bkv0t9pzsNw=
=FL34
-----END PGP SIGNATURE-----

--=-IBxGqHANLpnHXsRehCQK--

