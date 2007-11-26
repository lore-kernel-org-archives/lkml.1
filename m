Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXKZPsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXKZPsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXKZPsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:48:17 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:41556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbXKZPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:48:16 -0500
Subject: Re: [RFC] Documentation about unaligned memory access
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KgnKXDgvFNYDmqsdXDXR"
Date: Mon, 26 Nov 2007 15:47:06 +0100
Message-Id: <1196088427.4149.262.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KgnKXDgvFNYDmqsdXDXR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Sidenote: in the above example, you may wish to reorder the fields in the
> above structure so that the overall structure uses less memory. For examp=
le,
> moving field3 to sit inbetween field1 and field2 (where the padding is
> inserted) would shrink the overall structure by 1 byte:
>=20
> 	struct foo {
> 		u16 field1;
> 		u8 field3;
> 		u32 field2;
> 	};

You can reorder to u32, u16, u8 order and save another byte :)

A reference to pahole could be appropriate here, and probably a small
note that some large existing structures like netdev have deliberate
holes to achieve cache alignment.

johannes

--=-KgnKXDgvFNYDmqsdXDXR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0rcaaVg1VMiehFYAQI3Kg//aSevX9UzfDL7+vloaS8osnygOyNu3gYs
ijLKInZ5i9LS3oP1PlJW75QaDBAkLx//PXNLuO198D6OGCjS5KVVUXRfpcUt3gXv
3y14oTCxtlekeJcD/CFtwoAFNmevFI/kcoVQbp1mq1v+e7uZE6bb/e0UpT9mhlxm
t4nPXMFVDZtRdflnn9cDVGJ50KT/2FrFG9Qvecpr1e4nGHfCgHZQbZfmD2Kx/jhZ
CMztgysuVkOjc0cVW3355wYXiqKikMU6KNHG4VRke9nlAdwezrNWK8hCDvIC6uE+
IXp2oS7897bgaC3q1q5moiAppEjdRjCX+aGpU7iV7gHkUctd4WhTTTfx9U093Srs
vj++pt7zV6afx6tq7J7EMOejdgxjj06qTMphB/PfDF8cLOzbqpFmdKd3d/caedTy
w3PG7s2rHCcUdH4mk9ys4vVN/LWhdDXpRszaUY4fA5IyFYdMugLDG0MkD259on4u
0Llv1+l6c9Gu+lEfS5ewq+5M/mNx9ZGzM+BQeapjOuFF+ggtvxtsozFWgwMuRs25
22u0bdqOiALFSe5alPGjIR1q0veNhwMZCbkRRJZ6bzqy1cyx0+EtvKffWgL6khq/
gq7YWdKGnlwvFeFBs8eKXVCUlRhyv4VNieT9qSj4LgosgcRbXvcQ6ZcpujrJurbq
BoK8K59eHDI=
=Y8Zm
-----END PGP SIGNATURE-----

--=-KgnKXDgvFNYDmqsdXDXR--

