Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbXKGPEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbXKGPEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbXKGPEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:04:48 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:38989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbXKGPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:04:47 -0500
Subject: Re: 2.6.24-rc1-git15 Kernel build fails on powerpc - Unrecognized
	opcode: `dssall'
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, David Miller <davem@davemloft.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1194428323.4055.3.camel@johannes.berg>
References: <47304343.2010709@linux.vnet.ibm.com>
	 <661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com>
	 <1194346486.4066.13.camel@johannes.berg>
	 <20071106.031001.189578769.davem@davemloft.net>
	 <47304FE5.2010309@linux.vnet.ibm.com> <47306E9C.4090202@linux.vnet.ibm.com>
	 <20071106154439.GK5080@shadowen.org>
	 <1194428323.4055.3.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-26Y8EXtSwRy74FzyOLmt"
Date: Wed, 07 Nov 2007 13:49:39 +0100
Message-Id: <1194439779.4470.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-26Y8EXtSwRy74FzyOLmt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-11-07 at 10:38 +0100, Johannes Berg wrote:
>=20
> > So that sounds like a Kconfig problem then?  That HIBERATION requires
> > ALITIVEC and yet does not depend on it or set it.
>=20
> Yes. I'm guessing that it broke with Rafael's hibernation/suspend
> Kconfig changes but will take a look. I think it used to depend on
> powermac.

Hmm, no, it didn't. I don't feel confident enough that nobody cares
about this code to make these Kconfig changes for 2.6.24.

johannes

--=-26Y8EXtSwRy74FzyOLmt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzG0YaVg1VMiehFYAQLF3w/+NQFkyTeE8bwChy93sXbJCKIHipDktfSi
MXyZNjC1g36N+h/LFAd27uVv1ldkkHPqbQGdroZHstUjScsXJ/VoRRP9jq+bvYPM
Pzj5dVAY89BXy7r6iiCnE+tLEEmbEMrPtgGhx0uvujaU7m/CMulPnP3Gx4EGdWyi
gdL3bBzXawxm7JfYbPylHENl3JLfpbm1Cdd9+gUl5LFBCNIk0H4ZgLv7ytRn6yyG
GwwxcWdsMUA4p8C4uAO6FjiS8JXeLYz3epCExZu63vjbuloTMqk6FevG72sW+cqU
TNXkDZLLjiUjmxC+A0z1rVdKkjgo2pO2y3BQxtUuzEAxWMqsRDxKFtPiWE1x31L4
f8IGp/WBUmi7ITB2Fqy1OQyZ1WG4XsGwcQjwy4EoDSE9NYwN7ha5Y0Ik9bH7hil+
s1KWaMGyEC1enAeLpi/e62vZYwShUmmRKGdr6aRlgruulw2Uad5pOpjvcDGgtd+n
9SXMboBLmw5H4EWkC1K5Jc+6vMVYKqi2CqRs4OFR75lSUQA2KFRKBVqnkN00soSv
rhKXHGOxXc7nd/e/e3yxe2XXajywEq09e7L8LzxRSDDZi4xIQg3ie5UsEmT41o2P
M5sRdqgWConqYZjbq3kc/avJDyNoSO3yuOhtAWvdlW736YmaHG+EMop0kv42siCZ
wlEMOz/ITvg=
=ZYcs
-----END PGP SIGNATURE-----

--=-26Y8EXtSwRy74FzyOLmt--

