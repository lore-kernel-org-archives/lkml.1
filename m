Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYGOIbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYGOIbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYGOIa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:30:59 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:45499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbYGOIa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:30:58 -0400
Subject: Re: 2.6.26-rc9-git12: Reported regressions from 2.6.25
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.44L0.0807141153110.2566-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0807141153110.2566-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+GiSh08knjRFA4qNWoZp"
Date: Tue, 15 Jul 2008 10:30:38 +0200
Message-Id: <1216110638.3535.0.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+GiSh08knjRFA4qNWoZp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Add
>=20
> 	printk(KERN_ALERT "Unplug now!\n");
> 	ssleep(10);
>=20
> to the start of slave_configure() in drivers/usb/storage/scsiglue.c. =20
> Then it should be very easy to trigger the failure.  :-)

Indeed.

> Assuming the failure does occur without the patch, see if it still=20
> occurs once the patch is in place.

Yes, it occurs without the patch and not with the patch, thanks!

johannes

--=-+GiSh08knjRFA4qNWoZp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIfGAqAAoJEKVg1VMiehFYUn8P/AlyE+8PQwLmpAJyaXHXwDAE
y4lNbcj8TYz5lt+h822n+I3FhbvbSTqglY2QndrAOYWqB3suMy2LhMPW4Ybzwa0r
2r0VJqmNkw1kSblDSrTFnM9Ic23JycK8t1E2coZ4wDQFtF3nRBUHnVdeRmJ+W9Hq
HMGcrmfb3K0X/C7Szy9crZfPx9Mi2aQTpN8AxHtFvv4NlQo3o275/04twhNANjP+
r3CKxfjnAi9hoVBrEh+yuUr6TLF1NZ0bSCl6YuYf/2ETVj75CXgB0gEymkM5MdMM
53QS5mFrwmc4su2O1GnG8ctkYJ49nBWFaC3RpinX4pbIxZgqnsiJ5pScCi/AEz8O
yOleDynNFntlo/SkJlxjDpoKdibCAPY7Z80xODyypt39ZCcRAe14h+0XWZZ2V2uL
lqIOb+ayyCmxgWHtRpqMY5XISy4Q65Knob1zt3RqzIKPp0Um3wgQ0/M+IthgoOND
5YsKDjXu5QN6lxL6gA28+1ms1Xw87oarzAcQE5qeVKT/dfmYJ7p+8E6ilz2w3UBZ
sjbfNdYRDEGo6qukMyvkJE/YrUNO9potTbl3oH0cY17wqq0iuUDG890hDNg+ah7l
ZXaKWfBg3X3aHXVIVX0KxDYmeGz6iWGW1itsEKFr3zwQeQkwv6oL/up/ohzubgLb
NkxYxQmHvM2lHno984ms
=ORmp
-----END PGP SIGNATURE-----

--=-+GiSh08knjRFA4qNWoZp--

