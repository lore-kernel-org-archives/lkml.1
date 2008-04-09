Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYDINpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYDINpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYDINpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:45:46 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbYDINpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:45:45 -0400
Subject: Re: [PATCH] introduce HAVE_EFFICIENT_UNALIGNED_ACCESS Kconfig
	symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, sam <sam@ravnborg.org>
In-Reply-To: <200804082111.35944.zippel@linux-m68k.org>
References: <1207667127.14253.42.camel@johannes.berg>
	 <200804082111.35944.zippel@linux-m68k.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kpF6x3sYdVbcYwHfQHYk"
Date: Wed, 09 Apr 2008 15:43:43 +0200
Message-Id: <1207748623.7442.14.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kpF6x3sYdVbcYwHfQHYk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Please CC linux-arch@vger.kernel.org for such changes, so it's more likel=
y=20
> noticed by more arch maintainers, so a list can be compiled what is=20
> appropriate for the various archs.

Hah. I thought there was such a list but it didn't show up in
MAINTAINERS so I thought I was wrong.

> The scope of this symbol is IMO a little unclear, is it intended for one-=
time=20
> accesses to small object or also for repeated accesses to larger objects?
> Anyway, this probably should be set for m68k as well.

Also for repeated accesses, for example network packets where the IPv4
header might not always be aligned. That's why we want it to be
"efficient", not just "possible" (as an earlier version of the patch
called it.)

johannes

--=-kpF6x3sYdVbcYwHfQHYk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/zIDqVg1VMiehFYAQLspQ/9GCcNILMzg6k5U/LsudZTw41Q0jLcDrcV
IP7njVlTNPg5PTOzMzMkDuj/uCDTAE9WDEIjgeHQqGWyBak8Qhs5YqfW41FbbFkJ
0ln+G2trSQNN/mt6S7eWE00y1ftavS8LXUkO7Sar/pupzFbODI6DeMVnUf//ZAFt
pUrU9BnTa7yoPi3lD3okLxQBK0cvwkr7q9/sNdhGnN2grdS5GVKUCEI0zFtARC9b
HBY2AP6daVHbs3uo0zLc+Sax76gwMa3xxrql/Rx5FRTPQfcqFsfNJC+Ox05TjT1R
AMJ2uo4XrfsVvrBkaJL9Yux0NjNUH0G6OCvq8LGwCcWdQpFEbvhGtOw5d7reZJfB
Ak+B5Y7tF1qz2PUDMtk389Pz5QtPpN/T+54cHhRWlCklKr1stHUHF3yk49B+IYRf
+uIwhO6ClKQdNio4my8MzeLGJKgLjndpdZ0hKAZkalyFKANlm8RqigRciA5gbGcc
E1dpY94D7pDu3qPf6LevU3T/dKfUr0IDL4JNdmiBEteGoUQSKYpEkDFP/xvoETDi
WGqctvV2h2audL+q245FpaV44hKLm++e9spdnGniWC0lwLEtQ37/hr/VNKeRtJJ+
sXRzcYrWHPZkX4bLRvrS2BZizw6x+6/AD9Rr6rHEH/jRwtrOPvmxtigbPy5MxzY1
eGZ+g4+bz/Q=
=1ksc
-----END PGP SIGNATURE-----

--=-kpF6x3sYdVbcYwHfQHYk--

