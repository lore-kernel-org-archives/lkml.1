Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbXEHIjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbXEHIjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934675AbXEHIjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:39:48 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:43681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934669AbXEHIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:39:48 -0400
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <200705072335.15357.rjw@sisk.pl>
References: <200705041132.32227.rjw@sisk.pl>
	 <1178538404.7261.16.camel@johannes.berg>
	 <1178538966.7261.18.camel@johannes.berg>  <200705072335.15357.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8mWerKlO4Ta99S02oQCD"
Date: Tue, 08 May 2007 10:41:36 +0200
Message-Id: <1178613696.18162.28.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8mWerKlO4Ta99S02oQCD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-05-07 at 23:35 +0200, Rafael J. Wysocki wrote:

> > Also, you could then simplify all the instances of
> >   (hibernation_mode =3D=3D HIBERNATION_PLATFORM && hibernation_ops)=20
> > to just
> >   (hibernation_mode =3D=3D HIBERNATION_PLATFORM)
> > in various if statements and other places.
>=20
> No, that's not a good idea, because of the "reduce code duplication patch=
"
> that I'd like to go on top of this.  I'd rather use 'if (hibernation_ops)=
' here. :-)

But if you want the user to be able to change away from 'platform' mode
you still have to have
  if (hibernation_ops && hibernation_mode =3D=3D HIBERNATION_PLATFORM)
in most places, no?

johannes

--=-8mWerKlO4Ta99S02oQCD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGQDfA/ETPhpq3jKURAsR8AJ9PNTU8AqnMzXVPa8UI1nS7qoSj/gCeJ6Hc
HJ5SeqIcml1MPBTHauJ0nFA=
=iyZL
-----END PGP SIGNATURE-----

--=-8mWerKlO4Ta99S02oQCD--

