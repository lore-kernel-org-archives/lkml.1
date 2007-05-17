Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbXEQOZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbXEQOZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbXEQOZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:25:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbXEQOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:25:35 -0400
From: Hubertus Grobbel <hubertus@grobbel.net>
To: Erik Mouw <mouw@nl.linux.org>
Subject: Re: O_DIRECT for FAT
Date: Thu, 17 May 2007 17:25:02 +0100
User-Agent: KMail/1.9.5
Cc: Linux List <linux-kernel@vger.kernel.org>
References: <200705150103.02398.hubertus@grobbel.net> <20070515122819.GK26683@gateway.home>
In-Reply-To: <20070515122819.GK26683@gateway.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1339296.H3jC1nqouX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705171725.09620.hubertus@grobbel.net>
X-Provags-ID: V01U2FsdGVkX19Ae9xy5iptvlBsMga/9GGtH3wEq7VoJ3dLU29
 MXTh3ozyvQpeWyylQet1j1teI7poceix+pC3HTLd0xJ5MJQmn1
 kjYSe/+oSdIsHUdUSEkGCxJB3VTWrBf
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1339296.H3jC1nqouX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Alan, Erik and Hirofumi and the rest,

I want to inform you of my success. So first of all thanks for your help!=20

Assuring, that the buffer is aligned according 4k (pagesize =3D getpagesize=
()=20
and multiple of sectorsize =3D blockdev --getss) using memalign or=20
posix_memalign, did the job. Thanks a lot. A very nice feature.

The compiler option -D_GNU_SOURCE helped also to avoid including asm-header=
 of=20
fcntl.h.

bye
Hubi

--nextPart1339296.H3jC1nqouX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGTIHlAB1de4oeNLkRArdPAKDcg2ZjLoVJ6vZUUTOOYY2ZyC6jLACgnyUM
wOtYt8Ci9uB6D9D2PqFUT8A=
=qzdK
-----END PGP SIGNATURE-----

--nextPart1339296.H3jC1nqouX--
