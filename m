Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZA1K6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZA1K6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZA1K5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:57:45 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:47294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbZA1K5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:57:43 -0500
Subject: Re: since 2.6.29-rc: apple infrared keeps system awake?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Samuel Ortiz <sameo@openedhand.com>
In-Reply-To: <alpine.LNX.1.10.0901271417070.5377@jikos.suse.cz>
References: <1232635779.4224.12.camel@johannes.local>
	 <alpine.LRH.1.10.0901261151320.26411@twin.jikos.cz>
	 <1232968513.20525.1.camel@johannes.local>
	 <alpine.LNX.1.10.0901261220150.5377@jikos.suse.cz>
	 <1232969733.20525.4.camel@johannes.local>
	 <alpine.LNX.1.10.0901271417070.5377@jikos.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BiiqlFiOICoAJw0VVrVS"
Date: Wed, 28 Jan 2009 11:27:41 +0100
Message-Id: <1233138461.3936.11.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BiiqlFiOICoAJw0VVrVS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 14:18 +0100, Jiri Kosina wrote:
> On Mon, 26 Jan 2009, Johannes Berg wrote:
>=20
> > Is it possible that I was just in an environment where there was lots o=
f=20
> > random infrared traffic that the device picked up? Is it possible to=20
> > disable it completely?
>=20
> Well, you can always unbind the driver from the device, I guess that=20
> should shut it up.

Ok, I'll have to write a script for that or something ;)

> But I'd like to understand why this started happening all of a sudden. Ar=
e=20
> you able to reproduce this easily?

I've watched this issue some more over the last couple of days, and it
seems that it's not (at least not only) related to the kernel version,
2.6.29-rc2 is behaving just fine right now for me. I'm almost ready to
blame it only on the environment, though I don't know why a few places
at university would have so much infrared signal that the device felt a
need to react to them all the time.

I'll try to see whether it happens there with an older kernel too, in
which case I'll just blame it on the environment and disable the device
(well, I guess I want that anyway lest someone actually tries to use the
IR when I'm somewhere with my laptop)

johannes

--=-BiiqlFiOICoAJw0VVrVS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgDMaAAoJEKVg1VMiehFY/tQP/18BUYIpDeiaABvS1iTiSR0m
zAAbjPgBr7/O7UDY73okyI4xyrrQsi9ApWBj134aXqF1rVam350d39mIwUJduv51
xmCTkn9bMR9sxF+tkB5b0tQlZfRHye/TvZnDof2dcc9rBU9k1oAXQjCYVbFhuHnd
rdPohE4Hb/sNMEOGTsb332tZfxvSsOTBsWu7gtC9n0UM1f7sHUjy+iDUQtLCT/9+
NZS2Fcv2QT7vgLmO5XA238APD4UM4kNFHwLr2uYutfxVbTmlRPpcp2+Tb/i10SHV
Wgj+lYl+538oqrOoLi3gO3GtEiw9thM3X3slhHaQ9It4+0YfP4Ra/Y7MEtXkc7kT
QfbiD3b/dIFzMthbUjt3rSHuiaBELpE9+I2Tv0c4PMaRYXUzRSFgi22kIxWAvaZ4
gSWY+FVmTiccNbVPpun1IrjiB3VsAHjzCCftDmwavkfFAMz6ZmZyZFsuuW313lKf
0qxPZV/FPp5nIm1wBnRTa0XYq0c1fpE1YzxnVvZfROY6qg40oXg6Q2d2ciyW3f2j
ne8kc+vuo+Di4We8E8gZCdg2k5O9Zw/xWE3CKLggh8aYtFlPyuBQolNJHOFg+1jw
zcTgqhTyzJt9WpZoHQSWtfciwz6Qr1RgfVQ/vp7RvquwQ/yYyWC62q+jLZingxSN
piG31Cteory8Qcww/6LT
=A3ZR
-----END PGP SIGNATURE-----

--=-BiiqlFiOICoAJw0VVrVS--

