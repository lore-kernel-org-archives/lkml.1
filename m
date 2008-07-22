Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYGVC3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYGVC3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYGVC32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:29:28 -0400
Received: from ozlabs.org ([203.10.76.45]:34909 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYGVC31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:29:27 -0400
Subject: Re: [PATCH] pci kernel-doc fatal error
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20080721161440.31c97fb8.randy.dunlap@oracle.com>
References: <20080721092718.f15dc1ea.randy.dunlap@oracle.com>
	 <1216681665.7427.9.camel@localhost>
	 <20080721161440.31c97fb8.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sDOzEDMsossJjNuFwA1J"
Date: Tue, 22 Jul 2008 12:29:25 +1000
Message-Id: <1216693765.8479.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sDOzEDMsossJjNuFwA1J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-21 at 16:14 -0700, Randy Dunlap wrote:
> On Tue, 22 Jul 2008 09:07:45 +1000 Michael Ellerman wrote:
>=20
> > On Mon, 2008-07-21 at 09:27 -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > >=20
> > > Fix kernel-doc comments so that they don't produce errors.
> > > Also cut some extraneous copy-paste text.
> > >=20
> > > Error(linhead//drivers/pci/pci.c:1133): duplicate section name 'Descr=
iption'
> > > Error(linhead//drivers/pci/pci.c:1189): duplicate section name 'Descr=
iption'
> >=20
> > But now the description lines exceed 80 columns, and with longer
>=20
> Yes, I'm pretty well aware of that.  :(
> This is one of the places where we tolerate that, while not enjoying it.
>=20
> This is a request that akpm has also made, and it makes some sense, and i=
t's
> on my long list of (volunteer) doc work to do...

Sure.

> > ps. I did look at changing kerneldoc to do that myself, but whereas
> > previously I thought I didn't really know perl, now I /know/ I totally
> > don't know perl ;)
>=20
> Yes, I understand that comment.  ;)
> That's part of the problem, of course.
> I.e., if it were straightforward, it would probably already be done.

I guess there's also a good reason why the kernel implements its own
doco-from-c-comments extraction tool, rather than using something that
already exists (doxygen?).

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-sDOzEDMsossJjNuFwA1J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIhUYFdSjSd0sB4dIRApzwAJ40qejkR/KZj729P1/3WM0iy7a/zACfUnYN
l6WBxizWOfHJ9rqKlhzcrjw=
=8/n4
-----END PGP SIGNATURE-----

--=-sDOzEDMsossJjNuFwA1J--

