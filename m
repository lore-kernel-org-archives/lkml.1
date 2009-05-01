Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZEAIRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZEAIRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 04:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZEAIRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 04:17:23 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZEAIRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 04:17:22 -0400
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Johannes Berg <johannes@sipsolutions.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
In-Reply-To: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HKa1r6ihO2+Ep+GO8LTL"
Date: Fri, 01 May 2009 10:16:45 +0200
Message-Id: <1241165805.13562.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HKa1r6ihO2+Ep+GO8LTL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Parag,

> Niel bisected the probe timeouts with iwlagn to your commit
> 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8 .  I too was getting probe
> timeouts but with ath9k and tried reverting the above commit which
> made the problem disappear.

I know. There's a bug in that commit.

> It is not yet reverted from mainline and compat-wireless - just wanted
> to bring it to your notice that it impacts both iwlagn and ath9k.

I'm not sure what makes you think that it even _should_ be reverted.
Just to make that clear: it should _not_ be reverted. How did you check
that it isn't reverted in compat-wireless anyway? Must have been by code
inspection since if you had made an attempt to verify that the code in
there works, you would have found that indeed there's no reason to
revert this commit since the fix for it went in, and is literally a
single line.

johannes

--=-HKa1r6ihO2+Ep+GO8LTL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+q/qAAoJEKVg1VMiehFYyMoP/0pCoYuldJevAp5O3qk+WUV0
e4PS0SOTzlGa9zmAUvMOJY4bu0ggvDBapHhvzpQgEmNo/v/U0G4kjJJl03JmRZ6E
DFwC7JKWFTUsrOcBCzwEMqPWT3PAr/5tw41gS185o019CmXYUDIuVrdP/8qAN0BI
8ZzGEJESE0ckpVvIOevf5EGDsErv+p6QwaeKCqeT7E9/kHa3KGJseDHVX2wMpnvM
YkXTtsAW7Ad13iNh6RbCsg74fcaCHcfh9yNequIv6aB/VWFOGCRUeLBGlyATD16u
HBgqZzRGX5OrvYJtWM/YMULHb7+Su+bHJv7GEYFc5ES9oZUdHcBwFe4qH4Pi1aCX
CcGJsqflE7NfEVrimwEXTpl9NWUBMj3wc6l/Kt7taIKTRjL9ZGWJPvmfbqkw96x6
/L1u5lsTfhy5LlyzMTBAc0cPcu8u++4sGAe/viIX81fzdp6VOtqxJO/qbBSxJhvD
TenU95bUnwJKo3sunXpuZvWWNb4QjS8DtevxNx3iyijV1rq57YEpDiM2YJ+wDoE0
z7cLpZpucgGR/BeW5zbLYvAXZSh6peSELdv4QShkEm2SOklgfg4fkvPANZty/pfl
4ked014THaCtpxU2mI3SS4tzTpdhTeLwmwaGuPm7RLNxNm1NRhQTYRKYaWsCCnyY
H9yNMOSEQqo7HIBFEdeO
=uS9N
-----END PGP SIGNATURE-----

--=-HKa1r6ihO2+Ep+GO8LTL--

