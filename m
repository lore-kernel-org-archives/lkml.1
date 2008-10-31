Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYJaNHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYJaNHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYJaNHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:07:21 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYJaNHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:07:20 -0400
Subject: Re: [RFC] B+Tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081031125453.GE18182@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t1JetxqiSNB4uLvfLgjM"
Date: Fri, 31 Oct 2008 14:07:16 +0100
Message-Id: <1225458436.5546.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t1JetxqiSNB4uLvfLgjM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 13:54 +0100, J=C3=B6rn Engel wrote:
> On Fri, 31 October 2008 12:32:41 +0100, Johannes Berg wrote:
> > > >=20
> > > > Would there be an easy way to use 48-bit keys? Or variable length k=
eys?
> > >=20
> > > Variable as in one implementation for several trees with different
> > > sizes, yes.  Variable as in one tree with differently sized keys, no.
> >=20
> > Ok, I guess that would blow up the key size to 6+1+32 bytes, or 10 (5)
> > longs. Bit large.
>=20
> Yes.  Insanely large keys are a good indication to better avoid btrees.

OTOH, there is no need to put the SSID in if I put a small list into
each node, effectively using the tree instead of the hash table and then
disambiguating the unlikely case of multiple SSID in a list.

> I actually have something that compiles now.  It still needs a bit of
> water and soap before I'd consider it presentable, but turned out to be
> less complicated than expected.

:)

johannes

--=-t1JetxqiSNB4uLvfLgjM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCwMBAAoJEKVg1VMiehFYEHUP/AioLeQLn4OQ1VE2d8vsixQz
5FgoSr0wtQX4OPs9U9q1ODOQ8MgJ75LmtYhgxBWgXNBspoimiS5pJqcc/4F++4BV
9pZ8RMGqtdOAg84vzcdfztOaWPy8ANXGqLj7LRG68azY5WI7uoXUBGg6ESJUT/1Z
oI9+GEjG2SU1Tvj2dBsPfUwsJE7+bhWH0INWpo+Bbdv1oPuD2M6SflDRDQNkDQqi
CGtlHF37A8G1znMV01OQvCZbFYIgzQqFy8nVGfxUueXoJWeYGuSFWpkLSZgKl8Oo
YVIHYN2xFfjZbC+3ErhQWpznvIc4sluZLlGQk6RM+Te+8YiuQpyIjActYrzLRH3o
LXbOFM7GUyVkmW63aaBkYvQYqegEq+No5XL8ANi7sbMhm2JPlcNhGzeJ5fhn/bKB
2cLvGps5wg7vGzTUWapmF+MXVd0esqe1z0zqIFIP0obvc1dwV5/gxP1e7xlJX/EC
0sNZSQngOE9+P0EO4HeOhmBfrDTc7acpefcbp2R3JzNVGlcbMyd2yPSrsNtj7J6M
P3ILEUiRfGHEZcHQ/zV0drp2EjEH3SIqS/ibug1LEzyXRinlMATOo0CrmgnQ/jfg
UjtwNYmUDq4A3dL/TfmVY9+kJ+sqIOJb46qTM/H9al0eEKQy1ZQrFPm4O2sg/4az
ybnlMgyTuhFKSgsbgAVv
=AyVh
-----END PGP SIGNATURE-----

--=-t1JetxqiSNB4uLvfLgjM--

