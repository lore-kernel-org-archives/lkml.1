Return-Path: <linux-kernel-owner+w=401wt.eu-S1759863AbZLOKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbZLOKsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZLOKsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:48:17 -0500
Received: from smtp-out13.alice.it ([85.33.2.18]:2205 "EHLO
	smtp-out13.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbZLOKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:48:16 -0500
Date: Tue, 15 Dec 2009 11:22:46 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Daniel Ribeiro <drwyrm@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       openezx-devel@lists.openezx.org,
       Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH v2] leds: Add LED class driver for regulator driven
 LEDs.
Message-Id: <20091215112246.3abaa457.ospite@studenti.unina.it>
In-Reply-To: <1260194893-30149-1-git-send-email-ospite@studenti.unina.it>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
	<1260194893-30149-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Dec_2009_11_22_46_+0100_M.LDIHr92MT81u=8"
X-OriginalArrivalTime: 15 Dec 2009 10:22:54.0000 (UTC) FILETIME=[900C1300:01CA7D70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Dec_2009_11_22_46_+0100_M.LDIHr92MT81u=8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon,  7 Dec 2009 15:08:13 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> This driver provides an interface for controlling LEDs (or vibrators)
> connected to PMICs for which there is a regulator framework driver.
>=20
> This driver can be used, for instance, to control vibrator on all Motorol=
a EZX
> phones using the pcap-regulator driver services.
>=20
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>=20
> Addressed the observations from Mark Brown, Liam Girdwood and Linus Walle=
ij.
>=20
> Patch against:
> git://git.o-hand.com/linux-rpurdie-leds for-mm
>=20
> Changes since v1:
>  - Use "vled" as supply id.
>  - use regulator_get_exclusive
>  - remove double semicolon
>  - check for LED_OFF instead of 0
>  - handle regulators which can't change voltages
>  - rename led_regulator_get_vdd to led_regulator_get_voltage
>  - split regulator_led_set_value out of led_work
>  - allow setting an initial brightness value
>  - fix sections markers (__devinit, __devexit, etc.)
>=20
> The only slight doubt I still have is about
> led_regulator_get_max_brightness(), I have to use regulator_set_voltage()=
 there
> to tell if a regulator has REGULATOR_CHANGE_VOLTAGE enabled.
>=20
> Regards,
>    Antonio

Ping?

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

--Signature=_Tue__15_Dec_2009_11_22_46_+0100_M.LDIHr92MT81u=8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksnY3YACgkQ5xr2akVTsAGdsgCfd9Z0DC8U9UmrMBoHOCAEyXdc
QkwAnitZoOHK7cPwA20rtxjDDsevWUHP
=zsd+
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Dec_2009_11_22_46_+0100_M.LDIHr92MT81u=8--
