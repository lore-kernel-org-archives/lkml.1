Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZEUQIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZEUQIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZEUQIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:08:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbZEUQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:08:11 -0400
Subject: Re: [mac80211 ] Wifi Network slownes bisected
From: Johannes Berg <johannes@sipsolutions.net>
To: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20090521173839.1f20b95d@varda>
References: <20090521173839.1f20b95d@varda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nKeeNjl4BRvdjo5SSGK/"
Date: Thu, 21 May 2009 18:08:11 +0200
Message-Id: <1242922091.4212.14.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nKeeNjl4BRvdjo5SSGK/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 17:38 +0200, Alejandro Riveira Fern=C3=A1ndez wrote:

>  I noticed that my wifi connection has slowed when stitching
> from 2.6.29.1 to 2.6.29.4 (it is also slow on 30-rc6)
> Also 2.6.27 (ubuntu) does not suffer it.

> $ git bisect good
> 64e1b00c974ddeae6a60ebb02e1c487371905cea is first bad commit
> commit 64e1b00c974ddeae6a60ebb02e1c487371905cea
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Fri Apr 24 16:05:16 2009 +0000
>=20
>     mac80211: fix basic rate bitmap calculation

Well ... How much did your connection slow down? It is clear that this
commit might possibly slow down your connection, but not by a lot. And
that's only because before we were sending with a higher rate than the
AP allowed us to... If you need the higher speed then set your AP to
G-only to make it include more rates in the basic rate set, that'll
speed up your connection properly.

That's all discounting driver bugs which may exist, of course.

johannes

--=-nKeeNjl4BRvdjo5SSGK/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFXxnAAoJEODzc/N7+Qma8XMQAIFYa+ZzvbiKdxaicE3tHfIE
yHGS6PneVC17txFW13opEAzMUHiF6d3ViwDjYYWiXjfVMOIsqiRcx5NQdSHJHWIy
cum2dlh5awrd4jf60G65EEN6PQGU0XFPETdaly8NZzPj98xjcVkrOxJTkpnPeWAl
brH18LokWl3U0FuxbXmBUIWXaCLsLovnH1vFaj4fH0+wz317zrLx2dHwp96Mt0WK
4ru1hRJQ0fQyaqKsvi0yeccNitTfCF/3sooC/GoQeNPozK2Pl028zQzjIsaTTmnl
qoxr4+mCQ9WxmONEuTIuKKc0WeQzDv/zM61lflN4vMfxnd2QgQYx4Ogj/4Nl7vMU
jalOCQH9KQf1CzGlwcPMpOsNg5uz7IlXvjgZW1BDUwiUB4ALycMeVXXy2HblDRBm
sDDgacRf/q+Vy0xsMxMgWgfPXFH9K/vkgeMTtC3Q145PBfYk5HIAyQN9BMY1KuuO
5ug3j3YY1U0if6Rm/ttbEIREVZaH38FPbCrLTGkD8+eJgDLvF1cN3Brur+1V7BEb
fK6/7JpS7YTLx6JU9lTAkgkhK43pTBJzv82+bHvqITG2EF+807/csMmZj7904RZ6
6ysjIUKB7Pcq3jx+DaMKdMsTkGgyHSAfWAULRxhXQ96Eou5n/0rNaPsA5iOQcGgB
jmrNDKczWIb9gpJ5s0Ri
=VOWE
-----END PGP SIGNATURE-----

--=-nKeeNjl4BRvdjo5SSGK/--

