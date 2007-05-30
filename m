Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbXE3WVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbXE3WVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXE3WVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:21:43 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:47870 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbXE3WVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:21:42 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200705301604.23312.rjw@sisk.pl>
References: <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
	 <20070530124027.GA27942@srcf.ucam.org>
	 <1180531067.24891.1.camel@nigel.suspend2.net>
	 <200705301604.23312.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RYiV9ite0RNtGBJghlu8"
Date: Thu, 31 May 2007 08:21:39 +1000
Message-Id: <1180563699.6777.6.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RYiV9ite0RNtGBJghlu8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-05-30 at 16:04 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 30 May 2007 15:17, Nigel Cunningham wrote:
> > On Wed, 2007-05-30 at 13:40 +0100, Matthew Garrett wrote:
> > > On Wed, May 30, 2007 at 01:49:21PM +0200, Pavel Machek wrote:
> > >=20
> > > (Trimmed the Cc:s quite heavily - I think this has gone somewhere bey=
ond=20
> > > the original point)
> > >=20
> > > > Notice that we want to be able to suspend while hibernating -- for
> > > > suspend to both behaviour. So drivers may _not_ rely on system bein=
g
> > > > runnable.
> > >=20
> > > So keep the driver layers read-only and unfreeze the processes after=20
> > > doing the atomic copy.
> >=20
> > I know you probably won't care, but that's not an option for Suspend2 -
> > I get the possibility of a full image by overwriting LRU pages that wer=
e
> > saved prior to the atomic copy.
>=20
> This generally is a problem, not only for suspend2. :-)
>=20
> Once you've unfrozen the user land, we can't rely on the hibernation imag=
e any
> more, because some tasks may cause the on-disk filesystems' state to chan=
ge.

True. I understood, perhaps wrongly, that when Matthew spoke of keeping
the drivers layers read-only, he was meaning stopping filesystem changes
by some other means.

Regards,

Nigel

--=-RYiV9ite0RNtGBJghlu8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXfjzN0y+n1M3mo0RAijWAKC5fFzuHBlLgkYn7KoCZ+7h0FAxVQCfX3/h
TzR9yItXQCVTBbqOQJmX1/c=
=qMUJ
-----END PGP SIGNATURE-----

--=-RYiV9ite0RNtGBJghlu8--

