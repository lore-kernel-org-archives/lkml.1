Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYAINeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYAINeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYAINd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:33:58 -0500
Received: from systemlinux.org ([83.151.29.59]:44388 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYAINd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:33:57 -0500
Date: Wed, 9 Jan 2008 14:33:23 +0100
From: Andre Noll <maan@systemlinux.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, paolo.ciarrocchi@gmail.com,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080109133323.GD16462@skl-net.de>
References: <20080108164015.GC31504@one.firstfloor.org> <20080109103459.GC16462@skl-net.de> <4784C96D.5030805@student.ltu.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline
In-Reply-To: <4784C96D.5030805@student.ltu.se>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:17, Richard Knutsson wrote:

> Would had preferred:
>=20
> if (x) {
>    result =3D -Exxxx;
>    goto out;
> }
>=20
> then:
>=20
> result =3D -Exxxx;
> if (x)
>    goto out;
>=20

AFAIK, the second form is preferred in Linux because it is better
readable and it generates slightly better code.

Thanks for the review.
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--XvKFcGCOAo53UbWW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHhM0jWto1QDEAkw8RAhw8AJ4x2Jt2rknSfKQRxn8+4/t1ly+WAgCfZNRr
vBjDHDAL+TsEaBbDDD6ZnHQ=
=n25R
-----END PGP SIGNATURE-----

--XvKFcGCOAo53UbWW--
