Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYDXI5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYDXI5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYDXI5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:57:40 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYDXI5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:57:39 -0400
Subject: Re: [PATCH] wireless: rndis_wlan: modparam_workaround_interval is
	never below 0.
From: Johannes Berg <johannes@sipsolutions.net>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: jussi.kivilinna@mbnet.fi, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <480F97B5.9030009@tiscali.nl> (sfid-20080423_221109_783456_35B212E0)
References: <480F97B5.9030009@tiscali.nl>
	 (sfid-20080423_221109_783456_35B212E0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-elk0awi/LJdjBsMIIy/d"
Date: Thu, 24 Apr 2008 10:57:31 +0200
Message-Id: <1209027451.3357.49.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-elk0awi/LJdjBsMIIy/d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-23 at 22:10 +0200, Roel Kluin wrote:
> priv->param_workaround_interval is unsigned,
> modparam_workaround_interval not.
> the former is never < 0.

> -	priv->param_workaround_interval =3D modparam_workaround_interval;
> =20
> -	if (priv->param_workaround_interval < 0)
> +	if (modparam_workaround_interval < 0)
>  		priv->param_workaround_interval =3D 500;
> +	else
> +		priv->param_workaround_interval =3D modparam_workaround_interval;

Eh, why not make the modparam unsigned and default to 500?

johannes

--=-elk0awi/LJdjBsMIIy/d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBBLeqVg1VMiehFYAQIpKg//SWw4D0YZo9M9stw0llJljNhDTlzv+eGP
41gf/bm7Hi8VAnPc2Lkf/CmrhOQAd33Cb/w6PNZq5/rt70MJUE8o3HHpPmsXjYqN
s70Rz7qKtVY9eSLIWb7AW9w3HPYNEwbDwiE8/WmAbTbHizXXbplwdQbP6FuMXEiI
bRwRdQPiBp22CCY5Nq7U6vQMS51Y+7nMH2AwCh/qnkZraIFrlyzaCEqP76OxuH56
Zyq+Sfg479/Z6RJnHFGJF5IzjJSSRnPtErn96iTS3fpbunskJnYC+oPFDeTXDuyw
1nB9h6vgFNVVg20cTPbUsgJ4K0BfF92OzLJaHSbXXnJdbgXdAwwsdP5F0VrMSyf1
vmH45Irqc4/B/1gmvU7Hp/LR3y7qn66ocH4K1oJQtG48T8WsrEN029JWG5HeWAxC
XRD6sc7u6P91alPWn/FrOZ3rhrsygbUse/S8ytMgPrQAvYXUgetlX1/VjoaJ9VUS
oTq0n79wynEmHibWJlf/ywvnMg1YkxpuEpZWq8vRAhIb3magUK8L8LoI2nqu4/SZ
sqJdGNeKKEiwi4cdK0c2e42/RxSQ3tnaIgQInKE/PMXUjqym9LhFDtBuAvZ3gfAm
Jd5HZJqISKff6u5d+FEYmR30Gva50AoS8MDAuX3RTl+L8I7GdQeW3hGngHjL9roF
YgpB9deszCQ=
=J7yc
-----END PGP SIGNATURE-----

--=-elk0awi/LJdjBsMIIy/d--

