Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbZBEA5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbZBEA5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761504AbZBEA5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:57:15 -0500
Received: from ozlabs.org ([203.10.76.45]:40710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816AbZBEA5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:57:13 -0500
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in
 pci_legacy_suspend
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, rjw@sisk.pl, jbarnes@virtuousgeek.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <1233794410.4612.34.camel@pasglop>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl>
	 <1233712613.16867.136.camel@pasglop> <200902041115.00842.elendil@planet.nl>
	 <1233783502.4612.7.camel@pasglop>
	 <alpine.LFD.2.00.0902041355320.3247@localhost.localdomain>
	 <1233794410.4612.34.camel@pasglop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DeYx9UdJZLhLbSjmSSO5"
Date: Thu, 05 Feb 2009 11:57:11 +1100
Message-Id: <1233795431.15714.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DeYx9UdJZLhLbSjmSSO5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 11:40 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-02-04 at 13:56 -0800, Linus Torvalds wrote:
> >=20
> > On Thu, 5 Feb 2009, Benjamin Herrenschmidt wrote:
> > >=20
> > > How so ? I've had such backtraces with no other info in my log...
> >=20
> > _with_ that patch?
> >=20
> > It very much replaces a warning with no further info with
> >=20
> > +                       WARN_ONCE(pci_dev->current_state !=3D prev,
> > +                               "PCI PM: Device state not saved by %pF\=
n",
> > +                               drv->suspend);
> >=20
> > And notice the "%pF" and the 'drv->suspend': it should tell you exactly=
=20
> > which suspend routine it was that messed up.
>=20
> Yup, missed that change in the patch. In fact, I even missed the
> existence of a WARN_ONCE that takes those text arguments... baaaah. I
> suppose I should try to read more of lkml :-)

But don't expect to see them on powerpc, they never make it to the
console.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-DeYx9UdJZLhLbSjmSSO5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmKOWcACgkQdSjSd0sB4dIFgQCfYInwPROG3x1tbaYMnagL8uu9
okgAnRJgy7ujTkYPvYjhbnB0hLOVjhiX
=j8Z9
-----END PGP SIGNATURE-----

--=-DeYx9UdJZLhLbSjmSSO5--

