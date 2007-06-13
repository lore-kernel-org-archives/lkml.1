Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbXFMLcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbXFMLcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbXFMLcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:32:36 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53284 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbXFMLcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:32:35 -0400
Subject: Re: beeping patch for debugging acpi sleep
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070613082448.GH13747@elf.ucw.cz>
References: <20070518213701.GA810@core>
	 <20070611120034.f6d972de.akpm@linux-foundation.org>
	 <1181601771.5064.2.camel@nigel.suspend2.net>
	 <200706121411.56016.rjw@sisk.pl>
	 <1181697460.4910.7.camel@nigel.suspend2.net>
	 <20070613082448.GH13747@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/BW2XYV7ZXT2z6Ow0EW8"
Date: Wed, 13 Jun 2007 21:32:33 +1000
Message-Id: <1181734353.5012.12.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/BW2XYV7ZXT2z6Ow0EW8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-06-13 at 10:24 +0200, Pavel Machek wrote:
> Hi!
>=20
> > > > Wouldn't it be much more useful if it was unconditionally compiled =
in
> > > > and controlled instead by a sysfs entry? That way it will be far mo=
re
> > > > useful to $user who doesn't know or want to know how to compile and
> > > > install a kernel, but wants to do what they can to get provide help=
ful
> > > > debugging info and perhaps even get it going.
> > >=20
> > > I like this idea.
> > >=20
> > > > Yes, Pavel, I'll supply a patch if you (plural) agree.
> > >=20
> > > I agree.  :-)
> >=20
> > Ok. I'll take Pavel's silence as agreement too. I'll be a little slow
> > (as usual, nowadays!), but will try to get it done next week. I think I
> > can in clear conscience do it on Redhat time if I don't manage it
> > beforehand.
>=20
> Well, everyone wants it so what can I do... Stefan basically posted 3
> liner to do that, and that one will probably work... so just test it.

As he admitted, it's a quick and dirty hack. I'd like to try something
nicer.

> Oh, and please keep the macro, so it can be moved around .S file for
> finding out where it crashes.

Are there other points you'd like to nominate? It would defeat the logic
for implementing a nice interface if you still have to recompile your
kernel to test beeping in another place.

Regards,

Nigel

--=-/BW2XYV7ZXT2z6Ow0EW8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGb9XRN0y+n1M3mo0RAulhAJ95zyNira31LiBM6ZJGuIy+N9/tzQCgl53z
UPn+4tq9CVMl2EqWd7qG0sA=
=Je70
-----END PGP SIGNATURE-----

--=-/BW2XYV7ZXT2z6Ow0EW8--

