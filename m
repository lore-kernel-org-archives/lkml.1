Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZAJSnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZAJSnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZAJSnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:43:06 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:47325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZAJSnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:43:05 -0500
Subject: Re: [PATCH] add b+tree library
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090110183921.GD20611@logfs.org>
References: <1231584446.3685.21.camel@johannes>
	 <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
	 <1231587428.3803.0.camel@johannes>
	 <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
	 <20090110183921.GD20611@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CsBGz3OdW89ONZHeLoYX"
Date: Sat, 10 Jan 2009 19:44:02 +0100
Message-Id: <1231613042.3706.16.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CsBGz3OdW89ONZHeLoYX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 19:39 +0100, J=C3=B6rn Engel wrote:
> On Sat, 10 January 2009 21:29:04 +0900, KOSAKI Motohiro wrote:
> > >
> > > Joern is going to use it for logfs, that's the point. Not sure about
> > > other filesystems.
> >=20
> > Why can't you investigate other filesystem?
> > if this library is used by only one fs, why does this library routine
> > need to linux/lib/ directory?
>=20
> Because it is not used for on-disk data structures.  It is an
> alternative to radix trees, rbtrees, hash tables or linked lists.

Sorry, I misunderstood the question here.

Also, to elaborate on that answer, I'm going to use this as a sort of
hash table for wireless, where it ensures better scalability than a pure
hashtable from quiet environments (say wireless off on an airplane) to
your wireless test lab (100+ access points)

johannes

--=-CsBGz3OdW89ONZHeLoYX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJaOxpAAoJEKVg1VMiehFY6zYQAInkeF6SegdVrWosT/m3ariD
WNTTFgrkK/8m8QkPHPUFc9KB66gYbFNaN92cTBvokAF2HSXcgOXKSBs6P5iHRmO9
Bev/c6A5mnMyYZWfRgqnSo8Nn7PhVVrF7IPRAWE0VJaKFdgOTImZdN+dij9yOmgv
uiXbuzj+Qx+c+OClWomZ4mATXxtcwJ+re1/I2bg1Q7t8DScvO8htTk7GheP23Qdi
m6N8iCsAbSjUAU5VumonAHT5UB0rZOookMkyzVABrDfAHgB2/Fafmjx1XK3EHVzU
78cf6R5Wmf+Ei4GTmCnHqnzhQFxOUY8zuJiuc9mTpCiG45fA1mfYtR+rI9oavKik
7ewjr7cHW6594IsD71xsKNgaayjsYrXD0mHCh7HKBUWjlUEvnFWF/JSg7/PmLbp3
sCs4NJNHtNFphKIMTINL6u0FXKLpzcdDSY5qW0/67M5bvDIgwXE9QqJV28iNM5GA
FepTaJUm+IlXFeFTv93zd3OUu9GxtjcRt+sU8dIzKURVr9qMEkQI8YGrW5tuW8kg
2JfvcDSe3+Bl11FO6c5ddczSQgphN8rFhkZofx9xrVweWCkKPl3H/lTKAcCP97KQ
XuHe9mLM8x3y1LsRbv53DHodidVVvxcxYjYlJLrKqPE3F3GGryRKMqjWdzeQrD1r
FJ4+XoLm14K6uqNDw01q
=7gDm
-----END PGP SIGNATURE-----

--=-CsBGz3OdW89ONZHeLoYX--

