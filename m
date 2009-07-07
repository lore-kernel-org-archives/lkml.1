Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZGGRNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZGGRNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZGGRNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:13:23 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZGGRNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:13:23 -0400
Subject: Re: Possible memory leak in net/wireless/scan.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
References: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZJDHCJ3lgcmFKdy2GN8t"
Date: Tue, 07 Jul 2009 19:12:48 +0200
Message-Id: <1246986768.4755.43.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZJDHCJ3lgcmFKdy2GN8t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-07 at 18:04 +0100, Catalin Marinas wrote:

> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index e95b638..f8e71b3 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -366,7 +366,6 @@ cfg80211_bss_update(struct cfg80211_registered_device=
 *dev,
>  	found =3D rb_find_bss(dev, res);
> =20
>  	if (found) {
> -		kref_get(&found->ref);
>  		found->pub.beacon_interval =3D res->pub.beacon_interval;
>  		found->pub.tsf =3D res->pub.tsf;
>  		found->pub.signal =3D res->pub.signal;
>=20
> I'll try this later today to see if it fixes the leak. If that's not
> correct, I'll post more information about the content of the reported
> object (in general, it shouldn't be on any valid list or rb tree since
> kmemleak can't find it).

I have already sent that exact patch.

johannes

--=-ZJDHCJ3lgcmFKdy2GN8t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKU4INAAoJEODzc/N7+QmajfYQAIu6MYu25AGXCuxS/IKlSDvI
ZoRpakQBOI8SFSbRIlL2hViI0JS07Iqt2aJDVkEaADbXaeQOjn/XldNnT3NV/9IJ
1O46SHw88xY0l5XhkJI4FsHtKMq4GBxe7SOwzQUjR8Hq5YMOwAQtpCB7IBXoqnJV
KURZg8hqzpUqnVVGUAv2Z4Ec8nxO+849Xx0Tvx78+Y+8MYvjpMLJGhxmA7wyEslN
/agneHENSOrLLXAQlelXpfT62Ws5BskYhoDC/lAxc1AClUWx+qp2yDqPVRe+LsWq
GZTR+KLaMnS6PQjffkqPsIesG/85g0FUT9OqOXUlKN1SJC2a1MUn7C0Kc5AFWBSs
nB4ouaBLvrd2chvAXj510OZ60unENwP/qssbEwlpKayI+4cStbt7khOz9unIxs0T
UvjjbiL6dRViSBSS0nzu+2O+cZuPOy9N1XYx1efPjgQwufj9bBaBVX6A/EqOJyc0
hrgp5R4Fi3yiDtLfIzqB5xrY2vUpflR2PUyoX6PXnB6iJNmjnMvZy3dqs3wZT4ks
0nFZ4j1Trx3HAWTEHuwF7e6IQm5X8rfnFNWpF0tnZK8CWa8ekjmQIYi9qSGRQ49Y
5SCmKajdcxkzDSA1cIKHkfExM7Mf+/We38td/l6RLMNtkGmwQMsDDKEYPx6wMip7
EXGXns075cT8n4JwLDJ8
=O/FR
-----END PGP SIGNATURE-----

--=-ZJDHCJ3lgcmFKdy2GN8t--

