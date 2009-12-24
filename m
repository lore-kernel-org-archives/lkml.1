Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZLXMnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZLXMnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZLXMnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:43:51 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:45354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZLXMnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:43:50 -0500
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend 
 issue and mac80211 suspend corner) case
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
In-Reply-To: <43e72e890912231119l79ef5a99h6b57362e38f189ed@mail.gmail.com>
References: <20091222022355.GA32508@bombadil.infradead.org>
	 <20091222193010.GB30201@bombadil.infradead.org>
	 <1261570081.25008.1.camel@johannes.local>  <20091223162813.GB2609@tux>
	 <1261586828.7304.13.camel@johannes.local>  <20091223190840.GI2609@tux>
	 <1261595489.27798.0.camel@johannes.local>
	 <43e72e890912231119l79ef5a99h6b57362e38f189ed@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7Xx8YxSCwBCDcmqMglhX"
Date: Thu, 24 Dec 2009 13:43:46 +0100
Message-ID: <1261658626.28729.9.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7Xx8YxSCwBCDcmqMglhX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-23 at 11:19 -0800, Luis R. Rodriguez wrote:

> Reason for me suggesting for mac80211 to deal with this is drivers
> won't know if their failed start() call will have been from resume and
> we likely won't add a bool to start() callback since we already
> debated this a while back.
>=20
> I don't really care about hardware failures in other cases right now,

Which is the problem.

If your hardware suddenly fails, _regardless_ of when, you need to
unregister from mac80211 since otherwise you'll get loads of callbacks
to failed hardware.

Resume really isn't as special as you'd like to believe.

johannes

--=-7Xx8YxSCwBCDcmqMglhX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLM2H+AAoJEODzc/N7+QmaOMgQAK65YV3/1j1lc+sfe8eJUMrI
5/UeUH+mF9g41wZEkfJpyqWccivibOguiioxdUP5gUseLLdaFrBwWjFhIGlkkZ/A
KqXSq+4AI1U/iucCnOfEGEMyvuij5zqPdb15FLKAFwD2VbC9edR0GQ4XMkm6DGvu
0FzuJyPrJ1urvsi8qB6LIAa6ukpUmGt2t0WFhrSZdJwOv7uRCvTyybQbB7HfbbEb
4YKPNZmEbKWqfYrVb0xw31Orj41fX8Hjvyg1FV/Lfezbk+zF03eCbiHeQTboK8p6
zkPz9Omm39gdtddIc3AIT+ZiOgSzlGEOkmHnk3V4DYgZz4KXkpHEiB2pqHZsMrd+
wvmOLne9YZHcRyikW4O9CJQWm8GQYbyAB86baxIUxGXyMGJioGjkWOBW5YjbIt2B
l2S5oBALcaBvNUlBu0L7uQRt+qQ/1cF8km8DxQZ4c2ieedElgMQcxCIHftNzZqPo
hUS5Gx77jqYPDBNgjUnm/F65evWdH8onn97HJqWsW47y6C4yQjoQ7w1QcPxydP96
YrRIoDThE/nlkVFG5bspeZMjrzBL0Mu/XbPcXxxTRzwRj3r9IUMemRkagkhq5Vma
Hbf8d4bbbUVSiHbB61E/ieD0+7oUdKcs57gCTAxcD1Quz2/gngYe+HRlx2cZCRzg
W2CBeDlPshyVfvBmT/PX
=2Jmf
-----END PGP SIGNATURE-----

--=-7Xx8YxSCwBCDcmqMglhX--

