Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbXIMHP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbXIMHP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXIMHPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:15:11 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:51731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXIMHPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:15:08 -0400
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, satyam@infradead.org, flo@rfc822.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
In-Reply-To: <20070912.053411.21914920.davem@davemloft.net>
References: <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
	 <20070906082301.GB21929@gondor.apana.org.au>
	 <1189091995.28781.99.camel@johannes.berg>
	 <20070912.053411.21914920.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5q22gSmlNtum6WvC184l"
Date: Thu, 13 Sep 2007 09:16:27 +0200
Message-Id: <1189667787.6161.83.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5q22gSmlNtum6WvC184l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-12 at 05:34 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 06 Sep 2007 17:19:55 +0200
>=20
> >=20
> > Oh btw. Can we stick a might_sleep() into dev_close() *before* the test
> > whether the device is up? That way, we'd have seen the bug, but
> > apparently nobody before Florian ever did a 'ip link set wmaster0 down'
> > while the other interfaces were still open.
>=20
> I've added this to net-2.6.24

Great, thanks. Now I just hope John gets around to merging all the
accumulated fixes :)

johannes

--=-5q22gSmlNtum6WvC184l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6OPL/ETPhpq3jKURAiTOAJwMn5glpAN/OmX5HDwzBuMV07lF5wCdEnkk
FOg8XO6khHJn/9NbCUHx7Ys=
=y5gF
-----END PGP SIGNATURE-----

--=-5q22gSmlNtum6WvC184l--

