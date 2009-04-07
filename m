Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbZDGISj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbZDGISj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZDGISW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:18:22 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:45360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZDGISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:18:21 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239062401.4705.23.camel@maxim-laptop> (sfid-20090407_020013_939126_90578556)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1e+v3vSe+ZP0YSmO6I41"
Date: Tue, 07 Apr 2009 10:18:16 +0200
Message-Id: <1239092296.22453.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1e+v3vSe+ZP0YSmO6I41
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 03:00 +0300, Maxim Levitsky wrote:

> I noticed that always first attempt at scan fails when NM asks for scan.
> I also noticed that this happens with quite recent kernels (I think
> 2,6.28) didn't have this behavior.

I'm pretty sure it did.

> Looking a bit deeper I discovered that each time NM disconnects from a
> networks it sets random ssid/essid to the card (using wireless
> extensions)

This forces a scan

> After that scan fails for some time.
>=20
> as a NM free example you can run=20
>=20
> iwconfig wlan0 essid dummy
> iwlist scan

and then this fails with EBUSY.

johannes

--=-1e+v3vSe+ZP0YSmO6I41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2wxGAAoJEKVg1VMiehFYXBoQAJdRubE/lbOMjON/iTZ//GKa
u3hAxAdea7mVEB2VfnxyyweARiUr84WWo1drt8PSawqw45EUarc4q2ZXF0PqFwcm
piFZ0bx4tpXCD0FBiEdtNrNHyJFs7kG7bDF/Qoj1bB/Kx68Id34TKTo02bVz8x+2
18VEapSPVLdOrV4bljOg0unArzk8g+GzKVjHwcdbPnqHdWM6/OOKUoldmiF/4Xo5
PF0sdztA5E9QpUk6n5HRih5Gb6CU+/E5zP0WkVM/eJwr1PX9weaMCX4BPZljvm7f
L/SZq44ZSR7tbHZMyu4uBVllOWAFTIzSz2yB5uL+Q4ZN8ChgKNItxTtrkb5OIIxY
7mnSMJxVL1uYxbWqSt13G3udW6vEfAIQGK0XHC/kWS84W3iHrBLd/LFS22vb/lGj
Q29SeDIxIZO4hUUeaogjGPznuQqzGZ22yhPbjzEW7ZZyXe5TmmXvlMyESH51qytB
Tapkf+8yw9tpAXKPggzp0whwj6X43ig9XFBmbdkFe+X4+/STCjyE/iQV7k1Ec7dG
fA8RjFLibJ7oAKUNjrtFm08isoa/zcx0uzGSS1fAFfxysKvo1puIaBhihzYg9WCK
BafjENH6XZhSIkcA6lJ1EhFo54v2uRQxVYiAk6fEfW5gMsSjTih8PXnocjnZjcG3
s44gaLhciLcu0/MJX0qf
=07mc
-----END PGP SIGNATURE-----

--=-1e+v3vSe+ZP0YSmO6I41--

