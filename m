Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZA3JQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZA3JQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZA3JQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:16:27 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:34017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZA3JQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:16:26 -0500
Subject: Re: [PATCH] w35und: fix registration with wlan stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Bruno Randolf <br1@einfach.org>
In-Reply-To: <1233306825.13655.28.camel@penberg-laptop>
References: <497E1F3A.1060604@cs.helsinki.fi> <497E2EC4.5030302@gmail.com>
	 <497E35A1.8080301@cs.helsinki.fi> <497F5FEA.7020203@gmail.com>
	 <20090127200602.GA16444@elf.ucw.cz> <4980B2DD.307@gmail.com>
	 <4980BB9A.2020309@cs.helsinki.fi> <4980C028.2030709@gmail.com>
	 <4980C035.4070105@cs.helsinki.fi> <4980DB5D.6010906@gmail.com>
	 <20090130090525.GA1997@elf.ucw.cz>
	 <1233306825.13655.28.camel@penberg-laptop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zz/SwqChRnbjKmf64Dp2"
Date: Fri, 30 Jan 2009 10:16:20 +0100
Message-Id: <1233306980.4161.19.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zz/SwqChRnbjKmf64Dp2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-30 at 11:13 +0200, Pekka Enberg wrote:


> >  	dev->extra_tx_headroom =3D 12;	/* FIXME */
> > -	dev->flags =3D 0;
> > +	dev->flags =3D IEEE80211_HW_SIGNAL_UNSPEC;
> > +	dev->wiphy->interface_modes =3D BIT(NL80211_IFTYPE_STATION);
>=20
> The wiphy->interface_modes thing is probably fall-out from commit
> 8dffff216fcac4f79078478085e86d68db64922e ("mac80211: only create default
> STA interface if supported"). I'm cc'ing Johannes.

Yes. That looks reasonable, though it means you'll only support STA, not
ad-hoc.

> > =20
> >  	dev->channel_change_time =3D 1000;
> > +	dev->max_signal =3D 100;
>=20
> And the IEEE80211_HW_SIGNAL_UNSPEC and ->max_signal from commit
> 566bfe5a8bcde13188a356f77666f8115813cf31 ("mac80211: use hardware flags
> for signal/noise units"). Lets cc Bruno.

Seems reasonable, though does it would be good to see if it can do DBM,
which we very very much prefer.

johannes

--=-Zz/SwqChRnbjKmf64Dp2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgsVZAAoJEKVg1VMiehFY//EQAJ0Vonz3zVvLRIkej7PqGSv2
lndZa75Lb7AuBre3s8fPMjwz97yIJjFbRt5oVyzPyt+FOl7nr5HeC3+sSdhcZVP0
20zCMHWD/14IJs58dtO4GQRDNKNahFmWEl/hL5QBlPheP0GmIibdmMpKRzqNn1Tw
ad4v1uG8/1jrqVPfGpOLnwvY4bOtnUmeaCfxt5fymQJHO1tjz8SjNeZRmwM8t05M
1cEl/49WRrMu68Jy2b0kdJT0chjWmbnVChSyEF9gNRWXOzSgdwEX4+JQaGWHpAI2
w1pDbCiSjkx1HAgRFxWCFUog++V7zKM1eftQdq8tnfkwjLGkd7w1GAdBANF/QCsg
owaGsWAD/c9C81+GJHXLHmhEfB3JsuKZK5HOgEw/kHI7EURZ+3xihqigZEp+AfYp
UQdzlW22BQXJo2usFdFbsXkBigySIiO88loUBP+W4q/0tagETtR9Ygp4bsBm4C0Q
SG3qW2zy1Wm9skgE2eUf9hdDsXlbFGRHt/gRMW8+g6dUPIcRVrMwnJKsLtpmSQX2
n28kwfkI3g4Cgk1Br43selEWS9EzvsGJUd2FkEQJZk296aqvTYy1MiXX/0FcojCG
udJEi39lBM7K4sjIY0y/EEC0IDoo+pJbPiOFwVOj3oVWIghPC04cj8R5aRty3d+N
zFb6MnCe9kHlyyOC61g9
=ezp2
-----END PGP SIGNATURE-----

--=-Zz/SwqChRnbjKmf64Dp2--

