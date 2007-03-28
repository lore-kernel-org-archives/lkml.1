Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXC1ReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXC1ReX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965052AbXC1ReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:34:23 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:48545 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964988AbXC1ReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:34:22 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] [PATCH] sched: staircase deadline misc fixes
Date: Wed, 28 Mar 2007 19:34:17 +0200
User-Agent: KMail/1.9.6
Cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>
References: <200703290237.38777.kernel@kolivas.org>
In-Reply-To: <200703290237.38777.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3882975.nSRCeiYS0B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703281934.17932.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3882975.nSRCeiYS0B
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 28 M=E4rz 2007 schrieb Con Kolivas:
> I'm cautiously optimistic that we're at the thin edge of the bugfix wedge
> now.
>
> ---
> set_load_weight() should be performed after p->quota is set. This fixes a
> large SMP performance regression.

Hi, I am using 2.6.21-rc5 with rsdl 0.37 and think I still see a regression=
=20
with my Athlon X2. Namely using this ac3 encoder=20
(http://aften.sourceforge.net/), which I parallelized in a simple way, with=
=20
my test sample I remember having encoding times of ~5.4sec with vanilla and=
=20
~5.8 sec with rsdl - once the whole test wave is in cache. Otherwise you ca=
n=20
easily I/O limit the encoder. ;-) You need to get sources from svn though.=
=20
The current 0.06 release doesn't have threads support.

Cheers,

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart3882975.nSRCeiYS0B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGCqcZxU2n/+9+t5gRAj3BAJ99v/YlQcb0YxYkXnPTTmMHLtt5CgCguXcZ
Wk5Xf1AEWFxvuuMH1TI8D58=
=W/Wp
-----END PGP SIGNATURE-----

--nextPart3882975.nSRCeiYS0B--
