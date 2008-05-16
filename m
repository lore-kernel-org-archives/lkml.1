Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYEPILV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYEPILV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYEPILH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:11:07 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYEPILF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:11:05 -0400
Subject: Re: [PATCH] crypto: make michael_block a function
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080516070157.GA9769@Chamillionaire.breakpoint.cc>
References: <1210918637.5915.24.camel@brick>
	 <20080516070157.GA9769@Chamillionaire.breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uzLy9Lmi2nw0OHqlk4ex"
Date: Fri, 16 May 2008 10:10:05 +0200
Message-Id: <1210925405.4000.3.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uzLy9Lmi2nw0OHqlk4ex
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 09:01 +0200, Sebastian Siewior wrote:
> * Harvey Harrison | 2008-05-15 23:17:17 [-0700]:
>=20
> >Make the michael_block macro a function and change the calling
> >function to take a struct michael_mic_ctx * and the value for
> >the initial xor with ctx->l.
> >
> >Also open-code xswap in its one use in michael_block.
> Does this change have any performance impact?
> The only user is wireless (I guess). Is it used frequently (sign every
> packet for instance) or once in a while (in every re-keying)?

Every packet. I have no idea whether it has performance impact, very
hard to even guess.

johannes

--=-uzLy9Lmi2nw0OHqlk4ex
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC1BXKVg1VMiehFYAQKz0Q/9E2uiWOpCpogcsNURaB+9TDLiY8+zonoP
Lu4IBlablgimvDVvO7SMNpH+jBYkBS/5vMC+hkHJhCexsI3tMjEY0mDpjJrACp+m
xzIqXVr7R0anBzJIDa7yUqa+u+u8gbvtKaDr3c5e81pTxn13pFwoYy305ncRUH24
7rAca7dCuycXFnwhIFUzLVgwvBREb3bl1LXuSYfjMj95OxxXYjtgUESdTBfByXkm
1734zE/9ff6H2fii7HLg9imOEy+FfFXGPBE61tx8g2Cw5361Qf8+tTkNLXJ5GpkA
t5Qf/xw/d4npuxvhhsiXx0JXA3apWNFMm2yFIowBxRQxtk7KKtvnRakJmaishfHY
I3AQUgm+bsJPkCuKRhddBlmZIWC+3oz1M3J3AW9100WnWE+hKeX1gn6IHFLeYCKD
cruLaFBQ+2VmRNGFzmP9XanlLjS34Iev75U3IAn71qDblR9q2hPcpx9DN28gpEcE
lzN7nh2P9VSTxW1ol7HRIyYoYXPCGwLFxIZdR38m5mPdwP0r6J0wCGbU0U8bHZZL
0uuwf7ZrorZBVyP0HEYA6WaafLaVWVghQy12Zs4Z6OyhwrfdGPn1oCRoJhHiSPEo
OX1Nbv/0USMGzasAHm8jrY1zkdbbZvOrJcWC1O6siMRvzHksqFo5601olfKl9ymT
PgY0XvvkxTg=
=fseh
-----END PGP SIGNATURE-----

--=-uzLy9Lmi2nw0OHqlk4ex--

