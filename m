Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYCTVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYCTVWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYCTVWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:22:10 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYCTVWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:22:09 -0400
Subject: Re: [PATCH/RFC v2] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig
	symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, dsd@gentoo.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080320.141307.173590705.davem@davemloft.net>
References: <1206023695.16475.137.camel@johannes.berg>
	 <20080320181310.GA17884@uranus.ravnborg.org>
	 <1206038373.16475.150.camel@johannes.berg>
	 <20080320.141307.173590705.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U9d2Ty1Jta9zyVzH3MEN"
Date: Thu, 20 Mar 2008 22:21:46 +0100
Message-Id: <1206048106.16475.161.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U9d2Ty1Jta9zyVzH3MEN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I think you're semantically testing the wrong thing.
>=20
> It's not if unaligned accesses are supported, it's if they are
> efficient enough or not.
>=20
> For example, sparc64 fully handles unaligned accesses but taking the
> trap to fix it up is slow.  So sparc64 "can" handle unaligned
> accesses, but whether we want to set this symbol or not is another
> matter.

Yeah, good point. Should I rename it to HAVE_EFFICIENT_UNALIGNED_ACCESS
or similar? Or have it defined as some sort of number so you can make
actually make tradeoffs? Like Dave Woodhouse suggested at some point to
have get_unaligned() take an argument that indicates the probability...

johannes

--=-U9d2Ty1Jta9zyVzH3MEN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+LVaaVg1VMiehFYAQKGEQ//Y7tlbOZ+5VeIOIzFnf+/JvXG5K9e+xRc
SeHqW1/P4PBJErnpiu4x7Kskdxnth5prPpNnq6NKq0BwDGbwoKvNmJXDaHHFFsNI
tXRkf3eqIcPPDZqkp1COOudY0xXLYxFmt1UR8kPBgpR37MDGg3mZH5/45IotozAh
bAOAnFFKXrzk0yYLI7uHEWPV1whAjxKt4kAaTCFzG0r981uz7/EjitNHzdEg0IVe
nozFGn1+M7yw0WCaaxEZMzREDUjgmRUE8prRa6eGiqvnRMHhxRds+oauH0Rp0Vhq
ZTv2gKJbvF8ylTdHg8JEtRHB6eJhQapf182uyFXOmcgySze1E4rSZ0v4S1+jqGyE
AuXQ0phQziwPCja846vwW8hBHEEeFPVOcQEgDuMtzDZjytuILeHqwvfPvZbOEpp+
5G0FP83RAztR1zE8LDM5WkUWd7mmftgPQgsNMfNhWyHGD/BJ1rv3/Z05B/3kYL0A
e9QgNNh3MBvjJte7aFu+PjYpGvF9s9xguOOzmCRtAc6j6IQepQ+Ya87fMi5zRbQn
y+k5iJg/e806U3GY2KtFaO+EPjpFUteH9x47hv+T1gl4SCws3W15Vu5zxklBfSUP
+nBT2H+NUWAvPNgy9FvN8dmxLBnnmrX6YAZ1piV8N/OyUpQpnoVXCmxlljeGbE9H
mza/0C9i4YQ=
=zg7i
-----END PGP SIGNATURE-----

--=-U9d2Ty1Jta9zyVzH3MEN--

