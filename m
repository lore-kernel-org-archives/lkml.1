Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZDGN2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZDGN2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZDGN2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:28:14 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55176 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZDGN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:28:13 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239110412.15015.23.camel@maxim-laptop> (sfid-20090407_152021_060436_AEF9110F)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V4p9hjqcLf9UBbXYRLIw"
Date: Tue, 07 Apr 2009 15:27:40 +0200
Message-Id: <1239110860.4084.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V4p9hjqcLf9UBbXYRLIw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 16:20 +0300, Maxim Levitsky wrote:

> > Of course, we can go back to dropping the scan request, but that
> > wouldn't be very nice.
> >=20
> > Is this creating any problems?

> Yep, but dropping the request won't help ether.

Indeed.

> Problem is that wpa_supplicant will attempt to scan before association,
> scan fails (it doesn't know it is already running) thus it waits 10
> seconds. (I patched it to wait 2 seconds).
>=20
> It happens if user first disconnects, and then reconnects to a network
> (typical test I do for time it takes to connect)
>=20
> Now I patched it not to clear essid on disconnect, and this helped
> reduce connect times by about 2 seconds.
>=20
> now it takes just 3~4 seconds to connect to open network, and ~6 seconds
> to WPA2 network.
>=20
> (This is with patched dhclient, I reduced its timeouts, but this is
> another story.... it seems that first DHCPREQUEST never succeeds, and I
> tested this with 2 cards, and few wireless networks)

Have you tried with a new tree and wpa_supplicant's (from git) nl80211
driver? Might be a lot better.

johannes

--=-V4p9hjqcLf9UBbXYRLIw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ21TJAAoJEKVg1VMiehFYB2UP/34O0gOMdaXdJAswm4juKEJ9
dT9CFURHWBuh6LNahHT0AUh7YB5KlYrzCVCtuLwVBuJGwBxZFOPwBXEpil5KHjEt
fQ990XJ8KgHcVgPHvvVBFIWnj+EqbegQIf4hkbp8JTxv9/LMrQ250tbR/hl7NtLV
IS/iR7YU08N1ntgTn1kBvFqI7U2Ev9IEHhSIEwLyLLt09Sh3Y77F/iqLU++G56qY
8159z7HfoWYeNbl+pb2V4tG83s2rkUSt2n+nth26XzpBl7l7eXsd20kala7VG4nG
hzLOOjOIV84IlR2/zJe/xAakbk2GRi2rKwSS+IvLb1ylWY+pXTn/6mwL1UujjaAg
7E3DE9q0zt94LE127q185CwAPutZYZLPFqK41e0eiZiJV9oXfUsr2j6lMsFlrr/l
NFmaB8PGT+gLLDKagDmantBOCzlsbL3tk2R2DWvTEbkw3NFC+C/0sB1Ea5uUrXUn
nTT1nVFBvj954b1MQQ84cO6dw6t6Mr/u+PyAsxYFj7vnQdE1eehcTJ6/oxLGApNX
Innt17EoImriXVeN0v/fFPnsPxRiCO4QYgbqhSIR37ix76X2Ufy0DSeHTshNTwEQ
nOeqdtZClLqdnpdwyOeXF913z7JJpOZ5GV6HSCPnHLtT7aFsRBkvSIz++HZLRc/c
4RxXQXsctR5PDcPimqdi
=LkoF
-----END PGP SIGNATURE-----

--=-V4p9hjqcLf9UBbXYRLIw--

