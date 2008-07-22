Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYGVPt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYGVPt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGVPtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:49:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47337 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbYGVPtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:49:18 -0400
Date: Wed, 23 Jul 2008 01:49:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-Id: <20080723014910.7351c495.sfr@canb.auug.org.au>
In-Reply-To: <20080722114436.2c13edea@lxorguk.ukuu.org.uk>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
	<20080722025850.0d073a5e@lxorguk.ukuu.org.uk>
	<20080722130152.f115224d.sfr@canb.auug.org.au>
	<20080722114436.2c13edea@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jul_2008_01_49_10_+1000_54=MKzBin+g38X6A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jul_2008_01_49_10_+1000_54=MKzBin+g38X6A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Tue, 22 Jul 2008 11:44:36 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> > What is your problem with the linux-next tree.  The problem was
> > discovered and reported when I first merged the ttydev tree into
> > linux-next on July 1.  The fixes were in linux-next on July 2.
>=20
> Yes .. and ? The clashes kept happening despite that when I was doing the
> merges (and going on holiday for a week and trying to sort it out with
> limited time and internet access)
>=20
> Sorry I don't follow your line of discussion at all here ?

I interpreted your "So much for the linux-next tree" as saying "well,
that has been no help".  I am sorry if I got that wrong.

But my point above is that you had a fix for the current breakage in
Linus' tree a couple of weeks before you sent the patches to Linus that
broke the powerpc build (i.e. linux-next did its job) and yet you didn't
combine the fix with the original patch or send the fix with the original
patch.  So we end up with a powerpc tree that won't build in the middle
of the merge window while more powerpc patches are trying to be
tested ... I understand that this could easily happen because of
forgetfulness, tiredness or accident.

More care was needed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jul_2008_01_49_10_+1000_54=MKzBin+g38X6A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiGAXYACgkQjjKRsyhoI8wlkQCeJQjD+tiLvZtl3N47Jnq9NjuV
XzYAn2QGiZJ4gKDb9TxyvdB8Ij7QtzfT
=XP8y
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jul_2008_01_49_10_+1000_54=MKzBin+g38X6A--
