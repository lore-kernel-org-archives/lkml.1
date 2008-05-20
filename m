Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYETRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYETRQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYETRQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:16:36 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYETRQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:16:35 -0400
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: netdev <netdev@vger.kernel.org>, Jean Tourrilhes <jt@hpl.hp.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org> (sfid-20080517_154639_384202_6D3479C2)
References: <1211026337.3827.25.camel@johannes.berg>
	 <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
	 (sfid-20080517_154639_384202_6D3479C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5JHaC54Ie6AKHA8YnikR"
Date: Tue, 20 May 2008 19:15:31 +0200
Message-Id: <1211303731.6252.105.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5JHaC54Ie6AKHA8YnikR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-17 at 15:45 +0200, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> > The /sys/class/net/*/wireless/ direcory is, as far as I know, not
> > used by anyone. Additionally, the same data is available via wext
> > ioctls. Hence the sysfs files are pretty much useless. This patch
> > makes them optional and schedules them for removal.
>=20
> it is used by HAL to classify WiFi network cards as net.80211 instead =20
> of net.80203 and so we do have an actual user. However HAL only tests =20
> for the existence of the directory wireless/.
>=20
> Please fix HAL first before submitting such a patch.

I have filed a patch to fix HAL to use the canonical SIOCGIWNAME at
https://bugs.freedesktop.org/show_bug.cgi?id=3D16037. Any further
objections to this patch?

johannes

--=-5JHaC54Ie6AKHA8YnikR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDMHMqVg1VMiehFYAQIRCRAAha1B0TCHwCXxxe0Is+3Ld007hKV2n8kk
0VF3N4Q2bLxKemj4rlyIBltc7fNy0qkNMwybjv0L+Qr8MievBdog31t+nSs5+UnA
twu2OcjYPdDqYwEq/Umfhlsv775z7+E/qdQ1YUVJUrCKHL2M2WKVuNhXJJXX2OJL
PjO3xio5r6A0KiIZpbTgUsIK0rKbM0ATvlswNFnuG0efuydWfnNoLjoMQifWtrfJ
LgR/XziOdO/nmmAaygARjt7uSW9/uI384L8Y6ar4C1eoYmgZXzk4PRak4X8GcSaj
rpVTzdH9SKGQ6J+oBot2YPKAFitivpEGlF2IVxje6suQlYZ0CMdGC2NyPDiW/MTv
VjMtQH33unXxzz0WXaAJBARjbGVqdhVaadJWNRmws3iF+3uHe2aW3l92IpsFPYjy
4b47xAcZisvL8mvDTqaCKqOQRKBbj1fKiYE6p1CwHomzdm/9MGmNOjmu2Vjrohc1
nKHiMQfqbUwFqeYweU1MW4hv03M+jDv2GjFGJYSEjByL3AB9cI2GeqB2mKA6W34H
WgG8UrTBIWqupkjGxPb2Q7U3JcoOF/R2ikMr4vCmQLY1m3se2Bni42d+0jYjIn+J
NAnMJ1nzUMpzs0YLUFti62xzI7HQuOonjezxTVA76m0oe/2UaJotlytAhmaH5dMK
kWNWwyhmyOg=
=r45u
-----END PGP SIGNATURE-----

--=-5JHaC54Ie6AKHA8YnikR--

