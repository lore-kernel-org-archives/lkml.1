Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0BLOD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:03:29 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:58616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab0BLOD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:03:27 -0500
Subject: Re: [PATCH] nl80211: does not allow NEW_STATION and DEL_STATION
 for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Simon Raffeiner <sturmflut@lieberbiber.de>,
       Andrey Yurovsky <andrey@cozybit.com>,
       Javier Cardona <javier@cozybit.com>
In-Reply-To: <20100212135535.GA1123@holoscopio.com>
References: <1265978241-1601-1-git-send-email-cascardo@holoscopio.com>
	 <1265978993.15701.0.camel@jlt3.sipsolutions.net>
	 <20100212135535.GA1123@holoscopio.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yTlN8a5gyYBjmZyr+faU"
Date: Fri, 12 Feb 2010 15:03:24 +0100
Message-ID: <1265983404.18938.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yTlN8a5gyYBjmZyr+faU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-12 at 11:55 -0200, Thadeu Lima de Souza Cascardo wrote:

> Sorry. This code has obviously given me an oops. I did it in a hurry
> and
> thought that was a good optimization to get out as early as possible
> in
> the case the device was not in AP mode.

Which device, at that point :)

> I have fixed it, but I would like to do a more thorough test now to
> make
> up for my mistake.
>=20
> So, is there any test tool around? I am playing with iw code to do
> these tests. Any recommendations for the values of listen interval and
> the acceptable values for supported rates and aid?

I guess just using hostapd and connecting to it once would be a good
test for that code path, but the rest _looked_ fine to me.

johannes

--=-yTlN8a5gyYBjmZyr+faU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLdV+pAAoJEODzc/N7+QmarAkQAJTofwuvGcauTKEs1UD8xWvg
v3boQBJAY4cnjAf9uSlf9aEn7YxjBxvJ7pbfadtC9Ai+K1mIVSpWV4LY5cM6f026
YcId9Affd7zykS2/0JtZ2fV0KAG06y0HjfjkJElOADfTwirqK1lOpUhUrCGA/lgY
8kimWnjGrSONLWwB6T5XmOEp9GqVKM0FnB9M1Koknia7BtpeNC1JajcLsUlY+WPw
svEHZQIlrZPKuP0oRwRSd2rW3DOGF9k0JNe1V3XAYPpfsMGQpAvgAfHcud8H4XTG
wfP2pA6Mxh4Tt6JGRyCxS2t3/o7oYFrrkpTQE5mgfTzMaG3ZNxNjEIU5dYr+cvOk
wo+mPUcLcjgcQtjbycFimf9CGuNyoBh8+aEC4fqRdek4oMfTaO2/3XBvFCGr9i/k
uOPq330wiLI2DE2iPtBbnZ/lefQz+8dX6SzgTORjAKm/KpBcZ5MSsN2yMiealutH
E3dVmfg/cZc8Gt/3/kb3sQQ1Y7mNUpQ7GbbTd5CL8C2mreQ2Omz1DNV73yZ81qHk
L2Pg6nnblem49YGXnFD0RTqDAmyEVcEJ9NBXvKRlVA8sdF3/qVOZFZ26Hxsx7Q6k
qSsqFAIqbq3j0tj8TWxIB01lO4YQIizukgzp3Hn5GhUSt8S2L+8qlJhUKcIYznoP
NwFpsY71A6/EMgQhdj0V
=jwGV
-----END PGP SIGNATURE-----

--=-yTlN8a5gyYBjmZyr+faU--

