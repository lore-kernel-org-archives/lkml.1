Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbXLKXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbXLKXhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXLKXh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:37:28 -0500
Received: from ozlabs.org ([203.10.76.45]:41143 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXLKXh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:37:27 -0500
Subject: Re: [2.6 patch] drivers/pci/msi.c: move arch hooks to the top
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Adrian Bunk <bunk@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <20071211230015.GD14204@stusta.de>
References: <20071211221940.GA14204@stusta.de>
	 <1197413050.7276.1.camel@concordia>  <20071211230015.GD14204@stusta.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TpnjJ6mEUFj5y0mdzbTL"
Date: Wed, 12 Dec 2007 10:37:25 +1100
Message-Id: <1197416245.7276.5.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TpnjJ6mEUFj5y0mdzbTL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-12-12 at 00:00 +0100, Adrian Bunk wrote:
> On Wed, Dec 12, 2007 at 09:44:10AM +1100, Michael Ellerman wrote:
> > On Tue, 2007-12-11 at 23:19 +0100, Adrian Bunk wrote:
> > > This patch fixes the following problem present with older gcc version=
s:
> > >=20
> > > <--  snip  -->
> > >=20
> > > ...
> > >   CC      drivers/pci/msi.o
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:692: warn=
ing: weak declaration of `arch_msi_check_device' after first use results in=
 unspecified behavior
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:704: warn=
ing: weak declaration of `arch_setup_msi_irqs' after first use results in u=
nspecified behavior
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:724: warn=
ing: weak declaration of `arch_teardown_msi_irqs' after first use results i=
n unspecified behavior
> > > ...
> > >=20
> > > <--  snip  -->
> >=20
> > They're declared in <linux/msi.h>, I don't see what it's problem is.
>=20
> Older gcc versions don't like that they cannot see that they are weak=20
> functions at the time when they are used.
>=20
> I'm not sure whether the generated code does the right thing, but even=20
> if it does rearranging the code doesn't do any harm here.

Sure.

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-TpnjJ6mEUFj5y0mdzbTL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXx81dSjSd0sB4dIRAh55AJ4x8pxT1Lnoy8DACrlxG/vkbgugTQCeLWTC
z0WZUz6eTRI1+Va5pIYUe2U=
=JiKl
-----END PGP SIGNATURE-----

--=-TpnjJ6mEUFj5y0mdzbTL--

