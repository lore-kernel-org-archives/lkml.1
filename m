Return-Path: <linux-kernel-owner+w=401wt.eu-S1761303AbYBLXRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303AbYBLXRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759058AbYBLXRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:17:08 -0500
Received: from h1137427.serverkompetenz.net ([85.214.91.45]:54306 "EHLO
	h1137427.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758612AbYBLXRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:17:06 -0500
Subject: Re: [PATCH] pata_cs5536 Fix secondary port configuration
From: Gregor Radtke <mail@g-radtke.name>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, Tim Kunschke <beatmeistah@web.de>
In-Reply-To: <yq1myq6p7fe.fsf_-_@sermon.lab.mkp.net>
References: <1202158828.6229.22.camel@desktop.ein-elch.local>
	 <yq163x47wsy.fsf@sermon.lab.mkp.net>
	 <1202662829.6418.8.camel@desktop.ein-elch.local>
	 <yq1myq6p7fe.fsf_-_@sermon.lab.mkp.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YWB8oNT83OzhXamIlkKI"
Date: Wed, 13 Feb 2008 00:17:01 +0100
Message-Id: <1202858221.6419.33.camel@desktop.ein-elch.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YWB8oNT83OzhXamIlkKI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 12.02.2008, 09:37 -0500 schrieb Martin K. Petersen:
> Brown paper bag time.  My devel board has a 16MB 1st generation
> compact flash on the secondary so I never noticed this was hosed.
> Please try the following patch...

boots! For some reason, i had to apply it by hand (to 2.6.24.2), and i
was too stupid to examine how to produce a new patch. Looks like i have
to read the documentation at kernelnewbies.org...

Anyway, the patch fits perfectly and now UDMA/33 (due to 40wire-cable,
vendor says UDMA/100 should work either) on a HDD using pata_cs5536 just
works =3D)

--=20
Jabber: elch@ein-elch.de        PGP: 0x63FC728D
Tel: 0170/238 30 53    http://www.g-radtke.name


--=-YWB8oNT83OzhXamIlkKI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHsijti3HX/2P8co0RAs7kAJ0bB8nxNE7yGeuZtQ647dm4TaK59gCgsrMv
IV0Je03Mcii2Rj3bfU9aIQY=
=SAVf
-----END PGP SIGNATURE-----

--=-YWB8oNT83OzhXamIlkKI--

