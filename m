Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356Ab0AKPLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0AKPLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 10:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994Ab0AKPLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 10:11:45 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:53112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0AKPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 10:11:44 -0500
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.33
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1001110947350.2873-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1001110947350.2873-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MlwfGFwL4KePCVN3SPHL"
Date: Mon, 11 Jan 2010 16:11:35 +0100
Message-ID: <1263222695.29743.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MlwfGFwL4KePCVN3SPHL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Alan,

> The card doesn't work.  Although the firmware load appears to
> succeed, "iwconfig wlan0" says no wireless extensions present.

You need to set CONFIG_CFG80211_WEXT (it is default y).

> The only clue I can offer is that "rmmod rt61pci" hangs in=20
> wiphy_unregister() during the wait_event() loop near the start,
> because=20
> rdev->opencount is equal to -1.  This suggests a refcounting imbalance
>=20
> of some sort.

Good point, that's a bug that will go away with CONFIG_CFG80211_WEXT,
I'll send a fix.

johannes

--=-MlwfGFwL4KePCVN3SPHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLSz+jAAoJEODzc/N7+QmameQP/ibGo0juP/pZsZbBDYYxgkLB
OvDJrQGrSGcyaB4jdpBtn9677MY0C1n0LTrxvCZBkqwFKGzhKEoGcnYLvL3rrwI8
EbG2vLFQ6npYm3Fi0mQE0PE3YXaEbBZwUwZRLCwwMnkZPiJtULlGPCEUk1tFFLoL
QfTFxhf9mJxuHsjOVkK39AuxxqEI8Hc/MnGPtt04Fb40GkcDPkQSNy/b4YcBd9yZ
XDZl3HBbZXvwLT0bRJGb/35psGNxZfVcPiwWleD3bgNv1J7xBLdcUlQsN3rrgHxi
NsGznjMOYaKX88ROjZws1HebXRdctf79CGDauHH6coEaK5sCDR/zWE9vDqD1Pc4Y
D6rGWsrEUvbO7KL5RwnPShnwLS2IVEu/H80PIRbpgZUM9zv0rInaWDohzto+sz1N
GH1IACEXP2Or4dnvvOl61etzJ+risRY2ip2J63dLibMKX07D1+5v6i2HwfU2IwhZ
LzIqJG8VO6R05/QGVC28zs1xTwBRSB81NH0v34OzcNU+TmhyPevYtD/ksTbygaOj
h/sWhM4RSfVGmT6wAz5U4G+0LkyDIege9XJWGolTT4G6z54qFXKOCs12q1xVu6PZ
RujAH5VdNSfyqLjFeaaf1DPYqUCPuD0ULjlcbnsayQw9RDnXztdjTCSosJcsL74O
Yxf/e+ULvECrfMBP6JIK
=L+0q
-----END PGP SIGNATURE-----

--=-MlwfGFwL4KePCVN3SPHL--

