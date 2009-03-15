Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZCOSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZCOSM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZCOSMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:12:41 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbZCOSMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:12:40 -0400
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com> (sfid-20090315_040645_344726_0E746861)
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com>
	 <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
	 (sfid-20090315_040645_344726_0E746861)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AVqk3u9ur7XpbtCSWx/D"
Date: Sun, 15 Mar 2009 19:11:05 +0100
Message-Id: <1237140665.24621.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AVqk3u9ur7XpbtCSWx/D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-15 at 11:06 +0800, Jeff Chua wrote:

> The commit below is causing problem with associating with the hidden AP a=
s well.

> 71c11fb57b924c160297ccd9e1761db598d00ac2 is first bad commit
> commit 71c11fb57b924c160297ccd9e1761db598d00ac2
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Tue Oct 28 18:29:48 2008 +0100
>=20
>     b43/legacy: remove SSID code
>=20
>     The SSID programmed into the device is used by the ucode only
>     to reply to probe requests, a functionality we disable anyway
>     because it doesn't fit with the mac80211/hostapd programming
>     model. Therefore, it isn't useful to program the SSID into
>     device.

That's not believable, sorry. I know exactly what the microcode uses the
SSID here for, and it never uses it when we're in station mode.

johannes

--=-AVqk3u9ur7XpbtCSWx/D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvUS3AAoJEKVg1VMiehFYHbwP/23mwPlFgJ1/pUMeENy0CwWl
4gbwtEUoSPS4s4V4iakJNBLxmcBpv0txZzrkZo7XpFtoCyCo2w3gzd8swrkN/ZCJ
1IQekBsbfVxGH14CoOg/V+/K0m53nr+bqkW/7aFDGpS/0KyLEsLecvZHDOKaw6nP
2AKXrpnCupqjmDVySnaRMrUp7zd3oarRhxmkZFp7lOxfrFGT0gMkBqML4kAsHd/Y
tp3of6TOj5lsmIemitokGhPPVENXMZUorZyTbAo/HPFDBGY+07OJVsis90uZTPtT
3DjRSJNvs7s4e0YQHyQvROo3j7WphcPlPLLj+VT/+uYkHnmfv7no6PCnpRgLcdjO
xLRRQxGj47bMIikdimjTk7gH84eObTqjaXXnUaqAh6CMORyMUXXawMyqu7G8JIId
S9DEzYR6sAq1x8RT3wuH1DssTsCxN2xWKU8BSi+B0ZrbjqkCLp2G4q93Av+yWSNQ
9p8mHiJiCyicXnTHsbPve+MsFbAJ4YnbOyi9lvl5giX6hDGHrXHoaX5Ic4nsLn4d
kZoelPLCo6c1iD1wxk43q69K0c9IVZe6Ox9v3pFw/sKDaq1d8RHvt0XX21ADYAIU
lnL3x9HQWP94TfB0jJdd/0inRrePsgHzpqXQOcx5sof+4gYaQdZrP0anHNc3JzNr
t6sZVt0jm43S6jCLTwFB
=3LKL
-----END PGP SIGNATURE-----

--=-AVqk3u9ur7XpbtCSWx/D--

