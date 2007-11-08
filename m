Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbXKHSKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbXKHSKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760451AbXKHSKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:10:25 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:36668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963AbXKHSKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:10:24 -0500
Subject: Re: [PATCH (2.6.25) 1/2] hibernation: clean up Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071108100618.40e6c0af.akpm@linux-foundation.org>
References: <20071107135758.100171000@sipsolutions.net>
	 <200711072317.48023.rjw@sisk.pl> <1194533053.6294.42.camel@johannes.berg>
	 <20071108092149.e27c5ba3.akpm@linux-foundation.org>
	 <1194543003.4793.19.camel@johannes.berg>
	 <20071108100618.40e6c0af.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iuGcRNwDjosqqmwiwwfX"
Date: Thu, 08 Nov 2007 19:11:36 +0100
Message-Id: <1194545496.4793.28.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iuGcRNwDjosqqmwiwwfX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I assume this was against 2.6.23.  Please, it's not very useful to prepar=
e
> patches against such an old kernel.  Even if the receiver were to fix te
> patch up, there isn't much confidence that it will actually work at
> compile-time and runtime.

No, it wasn't, I diffed it against -rc1. I tested the Kconfig changes
with "make ARCH=3Dx86_64 menuconfig" and "make ARCH=3Di386 menuconfig". As
far as I understand, the new x86 arch depends on being called as
ARCH=3Di386 or ARCH=3Dx86_64. I may have misunderstood how the x86
architecture works but hoped Rafael would know more and tell me if I was
wrong.

joahnnes

--=-iuGcRNwDjosqqmwiwwfX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzNRV6Vg1VMiehFYAQKaVA/8CBLMwrg8Vn0N1uCBXR3WgC5AwPDaM1+F
OrCXtu+ysYNSCUUTjx7ZLGO2vmMpD6hXFO/DPdHovCSFW6CKGtLk6GxrHGK793Tg
T4pjA3u9tH3ukwC87f/h7MQuXbDgjzo7Ns/iojSKuFhN393vbPbxg57LjO2AGgKJ
EH8qefiQggbeBOupR+OHUPK6FD2s0TF8NhuTgNTsGVzKbb2D2hbbhR1LsjCcEwi5
Cnk8zUzvJHi0IVQSy/XSafEoCnMUKJ3DZ/aGMmAz+N1fVBOWkZuvC7InKSd3UCxC
WO4i1UW1InUTFWrsneW3OC5TnhkHUCquFPIdxJ5h1e+QIk/ZhwhFnb25JEPeX/8g
RZ1MYLwPaqbPZa7eUSLQUC2IfCVQgeRx69kRHFXzylXC2Ekh54DpRQ1TBHrxGtXd
dbPaoJ+gjDr6OL5Lr8xSrmOU5fpBV6r5pLAfnruK6iyrAh5W91VppUikA7C98iMg
bT7TUYyQ4cJmGhOf1/20SnIZGx3Bgf9JAHuxSyast2hKyAaKb2a6U1IcxUNUcJFJ
2c5nJ+nCjPq6VOiAXHkANPso8mpybqQpK8AYC/2gRPCjVqpJrIBxqrdTDdO94QDO
qi3Q/Obyav8ghii/jBELOjaIxo2ymGkLsYDja3gbUYqqLrPuIaWGh+zx097Dyw4I
qf+UgWkRajQ=
=vqsE
-----END PGP SIGNATURE-----

--=-iuGcRNwDjosqqmwiwwfX--

