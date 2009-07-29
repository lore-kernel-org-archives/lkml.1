Return-Path: <linux-kernel-owner+w=401wt.eu-S932175AbZG2NnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbZG2NnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbZG2NnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:43:09 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbZG2NnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:43:06 -0400
Subject: Re: [PATCH] kmemcheck: fix sparse warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1246873983.20908.0.camel@johannes.local>
References: <1246873983.20908.0.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q4Ihtr7cIiO9FHMnvl5H"
Date: Wed, 29 Jul 2009 15:42:31 +0200
Message-Id: <1248874951.25614.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q4Ihtr7cIiO9FHMnvl5H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-06 at 11:53 +0200, Johannes Berg wrote:
> Whether or not the sparse warning
>=20
> warning: do-while statement is not a compound statement
>=20
> is justified or not in this case, it is annoying and
> trivial to fix.

Whatever happened to this patch? Did you decide to screw sparse
warnings?

johannes

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  include/linux/kmemcheck.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> --- wireless-testing.orig/include/linux/kmemcheck.h	2009-07-06 11:41:16.0=
00000000 +0200
> +++ wireless-testing/include/linux/kmemcheck.h	2009-07-06 11:41:30.000000=
000 +0200
> @@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia
>  	int name##_end[0];
> =20
>  #define kmemcheck_annotate_bitfield(ptr, name)				\
> -	do if (ptr) {							\
> +	do { if (ptr) {							\
>  		int _n =3D (long) &((ptr)->name##_end)			\
>  			- (long) &((ptr)->name##_begin);		\
>  		BUILD_BUG_ON(_n < 0);					\
>  									\
>  		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
> -	} while (0)
> +	} } while (0)
> =20
>  #define kmemcheck_annotate_variable(var)				\
>  	do {								\
>=20


--=-Q4Ihtr7cIiO9FHMnvl5H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcFHAAAoJEODzc/N7+Qma09oQAM74NUsLzM4JizdfE3pieQiI
M+dVm97XiRuSghCLfl5g9U/+VugbR9H55+4ilIz3w+grlWTxWHu0j87vCHZEe5Pa
TvuGHYVzsX5zQsdSvQ8pi7xR78yTK9nBf8EO1b46TyDkTjiuXYyXzU79jODT4qLt
mU8kgeiUXi+wO/vMannxUMoij/e+DUGvGsM/ZxvC10O9pjfcWoxPBkQ1mC//CEOL
qA6vkYokO84zRxOD6rTwwKGco//z4+LAxdRdBg+yzz265JwlMErrnP9NNMmhcz5E
GoQ5xC57GqOP4w/a4xnS77FGoJZruBprROz21OEHzc09BmsSDBfupYQ2IQ/RtHOm
/Vle6Y+7if8FjmkeLrKxyHkqauz+Xg8T2985fDkgUZSMk4HATnUeP5rIHMiOIm2h
0FCSDsGrmmFqOGigsPjumIDf8uY0ZvSRDSKPqbmWe+wUpnLRjoqG85p7Ey3SgqEz
4xL75oWLUbW4CdnZLE5LSKFPFNaV4IHB1NHavX4sHy7/qhB9AvD6bMcB5jl53qPk
VC5MNo3ZhQbQyVBn59E0mr92+1yQUWGaOx87l4U+qDWC1+EuILmghEIPny6aRDcg
Dg0gxVVDrooQw9wvrV6RBwQP8IhKAz+/zVQY+5rXlVimYXHI9NudLau9EA5yaig8
Hj4QSGDmYIu2bp2Ig17R
=ckQD
-----END PGP SIGNATURE-----

--=-Q4Ihtr7cIiO9FHMnvl5H--

