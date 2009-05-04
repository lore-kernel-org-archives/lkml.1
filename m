Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZEDQIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZEDQIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZEDQHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:07:49 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZEDQHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:07:48 -0400
Subject: Re: [PATCH 2/2] mac80211: pid, fix memory corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1241453096-8517-2-git-send-email-jirislaby@gmail.com>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
	 <1241453096-8517-2-git-send-email-jirislaby@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Pj2+d931gA64YYIw1mXp"
Date: Mon, 04 May 2009 18:07:17 +0200
Message-Id: <1241453238.8683.52.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pj2+d931gA64YYIw1mXp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 18:04 +0200, Jiri Slaby wrote:

> +	for (i =3D 0; i < IEEE80211_NUM_BANDS; i++) {
> +		sband =3D hw->wiphy->bands[i];
> +		if (sband->n_bitrates > max_rates)
> +			max_rates =3D sband->n_bitrates;
> +	}
> +
>  	/* We can safely assume that sband won't change unless we get
>  	 * reinitialized. */
> -	rinfo =3D kmalloc(sizeof(*rinfo) * sband->n_bitrates, GFP_ATOMIC);
> +	rinfo =3D kmalloc(sizeof(*rinfo) * max_rates, GFP_ATOMIC);

I suppose you should remove the comment...

johannes

--=-Pj2+d931gA64YYIw1mXp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/xKzAAoJEKVg1VMiehFYsIAP/AshTex9OcRJ160LwDYGGRQ9
0nXeI7+dJmuG+mVJ1rjOaX/K1gk/BP9eZxnao6N5HKKYDSn2FJU5STt4LbAdF78R
Nusk8BuTJin2vrfAu8dDf5iIwpMXalyuNt4iY4C7SMjvD+KO3JlSTUfQHPBU9w3R
QhgmmsyWevESQl7hTdakSj5jVFzoiVp/vHsZ1IteaxL//VabQnx4hA8R/uExFTRH
j1NEQX5J4eR9uvGnEjfe4hWU4VAgb7VKpIOe+R08UuoQG4n2QlHg9e08/n6zYsQh
Z58ysCLpPjhn2qvhHJH3MUSXTkxhDIOiPNiQt4rsQmWLPCW+QGv2Yc5yGynw24nd
VvRp59cnZnhiq8bIcPW1j4w4YS2AhRUSuqqMy481OGRDmCLUcws8hE6cwffh+TnR
RMvagoIxuSdrvmOz6n0cslgzrFkDXsgmL1hXtJ5Y0CEINIaagSZHV2CIh6d7jmpk
a0Er0ndWQXNJKH3gJfjtVqc6bBvydlPP+JmwYNKwvkq7e3kM9VzZlt3HX6mayQ4p
XZbpQ7sQ3dmfbuVgRtSfQ9bOY0Ty1tvxRWMLxT4Xkk4D7m2jAEumVctCShi38qnX
15mJq0L4PLDcnI3jVVBCaIAMY0T2AGokO9UTI3nx9Hxg8K6rZ2iexvhkwNGWEIHP
rDoAwVs/9fuJFpBegavJ
=ffNT
-----END PGP SIGNATURE-----

--=-Pj2+d931gA64YYIw1mXp--

