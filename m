Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbXDAUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbXDAUDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964893AbXDAUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 16:03:17 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:56797 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964826AbXDAUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 16:03:16 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: "michael chang" <thenewme91@gmail.com>
Subject: Re: [ck] [PATCH] sched: staircase deadline misc fixes
Date: Sun, 1 Apr 2007 22:03:08 +0200
User-Agent: KMail/1.9.6
Cc: ck@vds.kolivas.org, "linux list" <linux-kernel@vger.kernel.org>
References: <200703290237.38777.kernel@kolivas.org> <200704010840.11387.prakash@punnoor.de> <b14e81f00704010724i3155a16en91074ab789416f3d@mail.gmail.com>
In-Reply-To: <b14e81f00704010724i3155a16en91074ab789416f3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4260920.jKLnKSYrfV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704012203.12595.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4260920.jKLnKSYrfV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag 01 April 2007 schrieb michael chang:
> On 4/1/07, Prakash Punnoor <prakash@punnoor.de> wrote:
> > Am Mittwoch 28 M=C3=A4rz 2007 schrieb Prakash Punnoor:

> > >
> > > Hi, I am using 2.6.21-rc5 with rsdl 0.37 and think I still see a
> > > regression with my Athlon X2. Namely using this ac3 encoder
> > > (http://aften.sourceforge.net/), which I parallelized in a simple way,
> > > with my test sample I remember having encoding times of ~5.4sec with
> > > vanilla and ~5.8 sec with rsdl - once the whole test wave is in cache.

> > BTW, I confirmed this regression. With vanilla 2.76.21-rc5 I get back my
> > 5.4 secs with the test sample and two threads. Furtmermore for me vanil=
la
>
> Which version of RSDL were you comparing to 2.6.21-rc5? Did you try
> the patch in the first message (http://lkml.org/lkml/2007/3/28/146)?
> The patch that _began_ this thread had SMP fixes in it... (Also, IIRC,
> the latest version of the scheduler no longer has the rotating
> component - so it's just SDl now.)

As I said, I tried 0.37. Didn't it have the fix inside? Actually I am=20
reluctant to go back to (r)sdl, as it didn't show improvements for me, yet.

=2D-=20
(=C2=B0=3D                 =3D=C2=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart4260920.jKLnKSYrfV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGEBAAxU2n/+9+t5gRAj9PAJ9sxnNYaA8CN6mBf/apIEZc0uD7ogCgg8nj
FsI0+UjpxxgW63qOpYWxaqI=
=ascW
-----END PGP SIGNATURE-----

--nextPart4260920.jKLnKSYrfV--
