Return-Path: <linux-kernel-owner+w=401wt.eu-S2992572AbXDROUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992572AbXDROUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992592AbXDROUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:20:39 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:56407 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992590AbXDROUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:20:38 -0400
Message-ID: <46262953.3040801@drzeus.cx>
Date: Wed, 18 Apr 2007 16:21:07 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070414)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-24213-1176906036-0001-2"
To: Madhusudhan c <cr.madhusudhan@gmail.com>
CC: linux-kernel@vger.kernel.org, philipl@overt.org
Subject: Re: MMCv4 support (8-bit support missing)
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>	 <4625DAFC.4000208@drzeus.cx> <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>
In-Reply-To: <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-24213-1176906036-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Madhusudhan c wrote:
>=20
> Kyung-ju Hyun from samsung had submitted a patch for MMCPlus support
> long back, which had the bus testing procedure implemented and it
> works fine. I am able to write and read the data pattern back
> successfuly with his patch. I am not sure why his patch was not
> integrated into the main line kernel.
>=20

I don't think I've seen that patch. And now we have the work by Philip an=
d
myself which adds support for both MMC 4.0 and 4.2. The only missing piec=
e is
8-bit data and I'm not that interested in adding it until we have a drive=
r that
can use it.

> Why should we be bothered about how controllers respond at the MMC
> core level. We need to just implement what specification says and
> leave the controller handling part to the controller driver. Am I
> correct?

Kindof. The controller drivers should indeed just handle the controller a=
nd
leave the protocol stuff to the mmc core. The problem is that this bus te=
sting
stuff breaks the previous standards. Sending invalid CRC was not previous=
ly a
supported operation, so many controllers just toss the data when that hap=
pens.
And since the bus testing is specified as a test, not a required part of =
the
wide bus song and dance, we've decided to leave it out.

Rgds
Pierre



--=_hera.drzeus.cx-24213-1176906036-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGJilV7b8eESbyJLgRAi+jAJwLK+T4kFn737GakjzBPqg6jYCYNACdH07a
8JCo+dKIJcv7UenFXuN5g4g=
=whUV
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-24213-1176906036-0001-2--
