Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXCaILk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXCaILk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXCaILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:11:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:58393 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752361AbXCaILh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:11:37 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18+YaF49ww+HQesS7+1WX0/WkN/ObXrHdbz+Ky1YD
	VuKANEP89+xFfA
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Date: Sat, 31 Mar 2007 10:11:27 +0200
User-Agent: KMail/1.9.5
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jikos@jikos.cz>,
       Lee Revell <rlrevell@joe-job.com>, andrea@suse.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
References: <200703281847.05356.toralf.foerster@gmx.de> <46C1CD24-F48E-4EB9-B6A5-E1B3C303C62F@mac.com> <20070330194701.GL14134@stusta.de>
In-Reply-To: <20070330194701.GL14134@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3667177.0Mu84K5rlP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703311011.32682.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3667177.0Mu84K5rlP
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Freitag, 30. M=C3=A4rz 2007 21:47 schrieb Adrian Bunk:
>=20
>=20
> No, the code is correct and it's impossible that the variable ever gets=20
> read uninitialized.
>=20
> And BTW, i386 gcc 4.1 doesn't give me a warning for this.
> Toralf, which gcc version and architecture did you see this with?

> cu
> Adrian
>=20

Hi, I use currently the following version:

gcc version 3.4.6 (Gentoo 3.4.6-r2, ssp-3.4.6-1.0, pie-8.7.10)

=2D-=20
MfG/Sincerely

Toralf F=C3=B6rster

--nextPart3667177.0Mu84K5rlP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGDhe0hyrlCH22naMRAnEsAJ4y1pVAZcl2bT6GxAe5K41+zFwJngCgk/yr
GYpXzt0AusumAu+UStWN2xs=
=DT7p
-----END PGP SIGNATURE-----

--nextPart3667177.0Mu84K5rlP--
