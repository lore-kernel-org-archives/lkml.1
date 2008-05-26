Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYEZLIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYEZLIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYEZLIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:08:07 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYEZLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:08:03 -0400
Subject: Re: 2.6.26-rc3 - appletouch resume "incomplete data package"
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
In-Reply-To: <b6c5339f0805251324k70a3a56ci9cab5274acc2d01d@mail.gmail.com>
References: <b6c5339f0805251324k70a3a56ci9cab5274acc2d01d@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kwlRZvUtXlELej4Xxn0G"
Date: Mon, 26 May 2008 13:06:44 +0200
Message-Id: <1211800004.17151.51.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kwlRZvUtXlELej4Xxn0G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-05-25 at 16:24 -0400, Bob Copeland wrote:
> This appears to be a regression since 2.6.25.  After resuming, I get:
>=20
>     appletouch: incomplete data package (first byte: 2, length: 4).
>     appletouch: incomplete data package (first byte: 2, length: 4).
>     appletouch: incomplete data package (first byte: 2, length: 4).
>     [...]
>=20
> And the touchpad doesn't work.  This is on a first gen MacBook.  I
> didn't see any changes to the driver itself in that timeframe.
> Anyone have ideas, or should I try a bisect?

I have intermittently seen this problem happen for quite a while, a
bisect will probably not help you. The "incomplete data package" message
doesn't actually seem to be related to the fact that suspend/resume
sometimes breaks the touchpad though, it seems to happen, for example,
when you switch from X to a console and back, something must be bad with
the timing, possibly even in the hardware.

johannes

--=-kwlRZvUtXlELej4Xxn0G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDqZwqVg1VMiehFYAQK3WhAAob1er7d/yyLA1HX8otI5N+9eDfgb1T4O
1R0/4f2XOoIR8pJaIaFmbwMi6kVDkpVc704PlxZrHwHxcFCe6/uaqefz56XMBrpn
SCiOw8SjhZANBcFekKSyFbN+h3aIwpwNtaRmNtyYhtg/DeE1lo2BZPzm1ZYPghUG
k4bM3zd+g2Rvq37NKPB441xOlE4W03coxP+mtZXJpWikgCAjif98FOe53eCTBsvO
lZfrXMSPoSBUNpKBRYYHHePpmcxcMmYwJgvJblAf92QXRl7YEwhQRhBVf/MpKwp7
2BlgkYem7k1nXu6WfjtOGoPLQzk+9C2VsEd+UO4b7HYW0wdj+m+Kp1AA3ukCsSIi
YWz4zHMStd8f9KMek00HDUi/l2mACAhng92MlS1vGmtiXULo6AFHrK+S0M5kdCcL
RLXMDTuPUii9lq6Oshm0k7yvihchqDjbMS/AN1DFiFlqFXsDA9cXyMmSzPSa9HuF
0ydBLwI1Q0PrAPf5+EYs/RODBTvKF67CbvLJii9YwUIBtW0CXGKZT3PvskRpJ7ZY
Mb7Afo0YlV/COvtF7d0kleLKDuOZXH7us0lNm4Fvlfa3jjBR9scRkOUWD0kaJMXS
veWUkLAH2CMNhcn+RtKBXyAT65i4JRSxuZRIYtyG5l8h0Xul7PMesHEiEatrbpW9
ytLLAdpRfqM=
=FNu7
-----END PGP SIGNATURE-----

--=-kwlRZvUtXlELej4Xxn0G--

