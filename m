Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYGIQ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYGIQ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYGIQv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37654 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbYGIQv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:58 -0400
Date: Thu, 10 Jul 2008 02:51:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 9
Message-Id: <20080710025149.3e69fecd.sfr@canb.auug.org.au>
In-Reply-To: <20080709155957.6bca2744@the-village.bc.nu>
References: <20080709183047.0eb1eb72.sfr@canb.auug.org.au>
	<20080709155957.6bca2744@the-village.bc.nu>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Jul_2008_02_51_49_+1000_yOoLfKlXAuhS/WK/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Jul_2008_02_51_49_+1000_yOoLfKlXAuhS/WK/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Wed, 9 Jul 2008 15:59:57 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> On Wed, 9 Jul 2008 18:30:47 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Temporarily dropped tree: ttydev (since it would not import on top of a=
ny
> > tree I have)
>=20
> I can make no sense of this as it applies cleanly on top of your tree.

And so it does, sorry.  I noticed in previous emails that you said you
had based the ttydev series on the firmware tree, so I tried to apply it
there and it failed.  I am still tired after Monday's attempt to build
the linux-next tree failed (not because of ttydev since I never got that
far :-().

I assume that you were never informed about how I work with quilt series
and I am sorry for that.  Here it is:

I collect the series in the morning (my time) and then import it into a
branch of its own based on the commit id in the BASE or NEXT-BASE comment
at the top of the series file.  Because the developer has chosen whee the
branch is based, the patches should always apply cleanly.  This branch
then gets merged into that days linux-next at some point.

So, I need a series based on something that is *not* linux-next itself
(otherwise merging the branch will pull in all of the previous version of
linux-next - bad :-)). It can be based on something that is merged into
linux-next (either named in a NEXT-BASE comment or a SHA1 if the base
tree is never rebased).  If this causes me to fix up merge conflicts,
then that is fine (up to a point, of course) what I can't do easily is
fix up when a patch will not apply in the middle of a series.

Therefore, you should pick a nice stable place to base your tree on.
This base can change from day to day and some do.=20

Remember that you have to get your series of patches into Linus' tree
eventually and when you do that, all the things in linux-next may not
have been merged yet (or much more may have been).  Part of what
linux-next is for is to take what you intend to send to Linus and try to
merge it with all the other stuff that is headed his way to see how much
of a mess we get into - and in some cases to change things so that we
minimise that mess.

Hope this is helpful.  If not, please note what time it is here :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Jul_2008_02_51_49_+1000_yOoLfKlXAuhS/WK/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh07KUACgkQjjKRsyhoI8yM3ACcCFphcM+9wz+3xqciwiILqPw3
yxgAnA9q+g65CJqIePW1R+Y2ZN1GeBRn
=jW4K
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Jul_2008_02_51_49_+1000_yOoLfKlXAuhS/WK/--
