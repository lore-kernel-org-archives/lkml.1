Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYGZN3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYGZN3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYGZN26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:28:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:36792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYGZN24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:28:56 -0400
Subject: Re: Regression in 2.6.26-gitX: failure of wireless due to commit
	175f9c1bba9b825d22b142
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: Larry.Finger@lwfinger.net, jussi.kivilinna@mbnet.fi, kaber@trash.net,
       linux-kernel@vger.kernel.org, free_beer_for_all@yahoo.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080726.003341.211819981.davem@davemloft.net> (sfid-20080726_093356_627865_68AC8E66)
References: <488AB2F4.7060806@lwfinger.net>
	 <20080726.003341.211819981.davem@davemloft.net>
	 (sfid-20080726_093356_627865_68AC8E66)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8vIfMyS3uEbODMPKk/Hk"
Date: Sat, 26 Jul 2008 15:28:45 +0200
Message-Id: <1217078925.4758.9.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8vIfMyS3uEbODMPKk/Hk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-07-26 at 00:33 -0700, David Miller wrote:

> Yes we know, it exposes a larger problem that's been
> present in the wireless stack for a long time.  It
> assumes that the SKB control block can survive across
> the SKB going through the qdisc, but that has never
> been true.
>=20
> We're thinking about how to solve this but have no
> easy answers yet.

There are three places afaik, and I have a plan on how to fix the worst
two of them, the third one is in the disabled AP mode code.

johannes

--=-8vIfMyS3uEbODMPKk/Hk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiyaKAAoJEKVg1VMiehFYw2IP/RZczj656PkJEZgiFZhGvQ4o
IKmsnUkznowTDhDrXpYANMeaMFLJaCBP5gVjD2CJawheN0Dozjgd5ftSvo+J7nTS
KMhunGiaGtnwYcrqqzi6sGqKkWtuhsfIWLS7oURqLD2+dls8IIwby/fuW6UKX+EX
oieFmG7wnz284SSzEYyYCqmzDrOTMuse442bz/j4GZs+j5WuopUKUilfGDOwUggL
sgYbpk9YMrTBjy4mO0wWuUuyoAeLNGzczBHuIOmeWO+ElOkZoehl1DLhN1uhn5uZ
3BMofOdgxzKYd9x1JkDvyblAxdczSOV6gcyqrf031m8qn4AECKL1TusJLsc4NTH5
SRdYhCEYgD/zIwTR6kT3/B9hjQw6CxqM0G8iw0bY9OaMKWs/awyB1gcDSqkvQ1ag
glvTVQiV2aJotmAauelGlk+sB2oST9t0xP0+vbMJVnY1Je739n5Hx1JcRBoSLOwC
sG0imIBM+8mdzfwH7k1pCJcdwYIx8Iad2rbAXb1puZAk9dZ7XjZtG0A0xHZJXxTn
tXJyYlOSk8QnivBVCJK5Z883YNRqJW/vQNfXslrGFtvHRsdZEeLwb5WDq5ZMVIP3
RLxuorJs9gvbootMXhZBInX9nE8oQ5DRac2jK8j+Ufvs/vDCPWoVSobFjKkCjUk9
1DE7bbqKZ8tH/DD75FWK
=R9qR
-----END PGP SIGNATURE-----

--=-8vIfMyS3uEbODMPKk/Hk--

