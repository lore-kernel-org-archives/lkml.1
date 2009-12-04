Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbZLDMjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbZLDMjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZLDMjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:39:52 -0500
Received: from smtp-out112.alice.it ([85.37.17.112]:3270 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbZLDMjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:39:51 -0500
Date: Fri, 4 Dec 2009 13:39:43 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-Id: <20091204133943.ddf0e53d.ospite@studenti.unina.it>
In-Reply-To: <20091202180658.GA12292@rakim.wolfsonmicro.main>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
	<20091202180658.GA12292@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Dec_2009_13_39_43_+0100_IA7mqDQ8fzO_GEBJ"
X-OriginalArrivalTime: 04 Dec 2009 12:39:54.0043 (UTC) FILETIME=[E107D8B0:01CA74DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Dec_2009_13_39_43_+0100_IA7mqDQ8fzO_GEBJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Dec 2009 18:06:58 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > +	vcc =3D regulator_get(&pdev->dev, pdata->supply);
> > +	if (IS_ERR(vcc)) {
> > +		dev_err(&pdev->dev, "Cannot get vcc for %s\n", pdata->name);
> > +		return PTR_ERR(vcc);;
> > +	}
>=20
> You almost certainly want regulator_get_exclusive() here; this driver
> can't function properly if something else is using the regulator and
> holding the LED on or off without it.  You'll also want to check the
> status of the LED on startup and update your internal status to match
> that.

When you refer to "the status of the LED on startup" do you mean a
initial brightness value passed via leds-regulator platform data, or the
initial status or the regulator itself?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Fri__4_Dec_2009_13_39_43_+0100_IA7mqDQ8fzO_GEBJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksZAw8ACgkQ5xr2akVTsAGxNQCeMI8XMGXOCUfxPpHEedSm6WY8
YV4Anjx/UuQlXeRQH5yr4Xv6GPQr6PgQ
=mp+L
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Dec_2009_13_39_43_+0100_IA7mqDQ8fzO_GEBJ--
