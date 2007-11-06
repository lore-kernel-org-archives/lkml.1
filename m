Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbXKFKxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbXKFKxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXKFKxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:53:31 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:60861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbXKFKxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:53:30 -0500
Subject: Re: 2.6.24-rc1-git15 Kernel build fails on powerpc - Unrecognized
	opcode: `dssall'
From: Johannes Berg <johannes@sipsolutions.net>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com>
References: <47304343.2010709@linux.vnet.ibm.com>
	 <661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uYIXIRK9kGJr6sndLTNN"
Date: Tue, 06 Nov 2007 11:54:46 +0100
Message-Id: <1194346486.4066.13.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uYIXIRK9kGJr6sndLTNN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> >   CHK     include/linux/compile.h
> >   AS      arch/powerpc/kernel/swsusp_32.o
> > arch/powerpc/kernel/swsusp_32.S: Assembler messages:
> > arch/powerpc/kernel/swsusp_32.S:138: Error: Unrecognized opcode: `dssal=
l'
> > make[1]: *** [arch/powerpc/kernel/swsusp_32.o] Error 1
> > make: *** [arch/powerpc/kernel] Error 2
> >
>=20
> Looks suspiciously like an altivec issue. Could you compile with make
> V=3D1 and/or do a git bisect and see what broke?

Looks more like a toolchain issue to me.

johannes

--=-uYIXIRK9kGJr6sndLTNN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzBH9aVg1VMiehFYAQL+exAAvrYLhzgPOuZeNb7zAyEEFZFdA8eTomgR
xmiLcsoDP0To2Pfvzbv2eILTTn7yKxWfZjwijKutJwqWY9X58z7puG0a0EXlwc4B
yUwx9TCMY6QppBCKu8oXb8CB5xz0I9kbrTwmNJVEKrKcCD1364+tFRnJffGWJenD
tBLLSEPUaKwYL4wkP+d69PvcNifQ2JDEnDE982JwjTkBL9y9q9eDu2tbAW00l9zL
URG75ih2HIr0IvE4BTQpXSk0HcdQMmnGrNOKQ0oejQbKh5uf2hXJlC8A976FC7rB
xGFcc5zwRPfK29H5HxxlL/4HJFA1fdIheVnhgX8szkMjW6egKkYsdFt1xHdtpr/f
JYVvaK5mqQ133KPpacd6weybi99VLC8weULq+HlMtz4Q2CEtOCwGNRrp6LBjUL+m
YgOPDq2jqsfaATZC/PPXgOR9LClD7C7QZ5n/MOMIdx0CMQbe1ZVbbLb0k0qWy3ur
Y8h7ohqWiJ9OUNZQ9co/O3KRxnuQ+JFCvZps7GpZxjGovZU6ZZRmdeFjJj5c6bWJ
MAkGhlx9l+yw2Gnri0qk40JtExOBo8lMV1UE1gX6CgrDDL51k2RDLeOpihaSpj9q
kUt/Qv0xUUiL5Axfdk0TZOZkLHFwvZ8j1d6q9f0IBQ7dkohmXvNqSG85xTovftOP
So9VN6KPc1c=
=+TJD
-----END PGP SIGNATURE-----

--=-uYIXIRK9kGJr6sndLTNN--

