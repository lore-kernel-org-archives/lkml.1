Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbZEFMG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbZEFMG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbZEFMGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:06:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60235 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZEFMGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:06:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Robert Schwebel <r.schwebel@pengutronix.de>
Subject: Re: [PATCH] fix blkid.h include
Date: Wed, 6 May 2009 08:06:15 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.2; KDE/4.2.2; x86_64; ; )
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
References: <20090505214214.GC4460@nb.net.home> <20090506113550.GQ15802@pengutronix.de>
In-Reply-To: <20090506113550.GQ15802@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5592940.gQMm7z3cVd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905060806.16600.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5592940.gQMm7z3cVd
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 06 May 2009 07:35:50 Robert Schwebel wrote:
> The reason is that blkid.h comes from e2fsutils, which install the header
> file into /usr/include/blkid/blkid.h; /usr/include is also what the .pc
> file specifies for the include path for the CFLAGS. So IMHO the patch bel=
ow
> must be applied to make it work.

sounds like the .pc file is broken and you need to report this to your=20
distributor.  works fine on Gentoo:
$ pkg-config blkid --cflags
=2DI/usr/include/blkid -I/usr/include/uuid
=2Dmike

--nextPart5592940.gQMm7z3cVd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJKAX04AAoJEEFjO5/oN/WBm5gP/3J7HUmlyBJPMVFt1VwCDOZb
WV5ok3V0PEmie0IqvJQLRHgFadmKUzuwVVAQCDmnJ8pIBncPJdd/Iz1BRSvQxxVh
/rGSZPXhCd70uii9gLsrClWceyJVgGihJYjjmMk0E7rM/12PbEz0HhMOZ5oiQWyf
PN3RMH36YbDD5YLcQE6XZ7JFrR3iXHC5AVzLVf5Yz+rI4w82xVHBTWkxAl6DSFsC
kgS7SeW06rFFFWwTKussu1qZSEBFXuJwWbJG+C0AvlzoTmM70rnyTYJNrO//F47m
zV779txbIdFdn19EYS9w8H3t4vCosLX71tkqXGeiuHo15n4vD8C1tYmFnNDg1Ktt
S/sJiWWwXtSxi4HGmahArDSaxxAYM3HnF/6FSI1Xr+xyxWvvEKvUtC4O3nSxProN
Za3aXkiv7Lk/+zngydAcxVTPpgMwtCD6xIoY9dd9p5U6j1hfeuNm72o+MG/uyes0
KtuCpBo4qDiiXAbwEB8ByffzxoE/Gx3HisnXdFVJw1bWQAl1WkJ+bzHgL3O7gQWL
0lp/6XkmUlDWjygy+Y8PNZv5+sgMFTAaSNbKE8D0HDNJyH+9ZokcHpg4YgOZT4JS
J8tBZ4DyiITe/pD/Z/Rw/uSTguWabgDP++BdNuKKexKZGdviEXZSNxHiHlyaY5Vb
sju2HylEF5oZsPmSKw2l
=5P8w
-----END PGP SIGNATURE-----

--nextPart5592940.gQMm7z3cVd--
