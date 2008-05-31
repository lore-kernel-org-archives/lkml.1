Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYEaUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYEaUWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYEaUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:22:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYEaUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:22:11 -0400
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet
	transmit
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Roskin <proski@gnu.org>,
       Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805311954.46639.mb@bu3sch.de>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <200805311841.46740.mb@bu3sch.de> <1212252636.2766.10.camel@rd>
	 <200805311954.46639.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fPR82+C+HKQChBKZuqVe"
Date: Sat, 31 May 2008 22:22:02 +0200
Message-Id: <1212265322.7672.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fPR82+C+HKQChBKZuqVe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-31 at 19:54 +0200, Michael Buesch wrote:
> On Saturday 31 May 2008 18:50:36 Pavel Roskin wrote:
> > On Sat, 2008-05-31 at 18:41 +0200, Michael Buesch wrote:
> > > On Saturday 31 May 2008 18:34:29 Stefanik G=C3=A1bor wrote:
> > > > "BUG: unable to handle kernel NULL pointer dereference at 00000004
> > > > IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790
> > >=20
> > > So can you put a few printks into the function to see where it derefe=
rences
> > > a NULL pointer? (or use gdb to lookup the offset).
> >=20
> > u8 key_idx =3D info->control.hw_key->hw_key_idx;
> >=20
> > info->control.hw_key is NULL.
>=20
> Is a NULL pointer supposed to tell "do not encrypt", or is this a mac8021=
1 bug?

It's probably a bug.

johannes

--=-fPR82+C+HKQChBKZuqVe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEGzaaVg1VMiehFYAQJklxAAtvK2Tewxn1aSc/vyL5lPUmg1uRKqV5lh
RgI5eq1ZMDKGlYEleJa2SJnxFayVFfSjN+shiw/J3O905p7XJN1KzhAd1aT6+boB
i0Mu+yx25ti5UVoqs1PxAmMI99FCp41CrdK/YXe/Oavb1F80SceT29RlfGztI7Ph
IFA2CdSRxn2WkOtzLsy8ei4eHjraayjQgnDiIW9RQXRWcA7qW//EFAg3paCEq6DC
g5I3NpBeEhndplf7jbJY2RE++qnKWAcMfDRBeENsl/NjdIBj6jxMLSV/o/hJst60
dsBHT8kmEk78iQv333M50tDJGd+NRwtlXGxv0Vt52eAv51I4S0TQ4whs8PneqqnA
oCoj8tLZmbH9+9nYkFxi/9aHjEc5eS9MzLf1I42pLs5Mcwa+WY5lorQBC5fIe3rG
bBVMK0l5k+61qGve4yZTl8khd3W/ONhHVSrPUy4FXFlYe48sSMlzDsZOhvCqq3/E
FYrnVZyq1cEPkMTqT96f37VuWO9aY6n0bCWRUHr0RCt1rBvJZxz0E/cQBAC8e/A4
nhoVjYSTjK0hy/1q2wJrQYN22LmrY+Q5XdDFY9VAqBxk3uUTWhWqhxUywgxlL3YF
txVc8X8pSYWCzsGntvuuEzrJWoBhMd+7FDsetJXfD3vEzndvkT3HDNkZChC4lM5C
OV6iBOAxowo=
=Yszy
-----END PGP SIGNATURE-----

--=-fPR82+C+HKQChBKZuqVe--

