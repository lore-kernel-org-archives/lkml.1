Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbYGAUg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbYGAUg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYGAUgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:36:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:48164 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754814AbYGAUgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:36:47 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX195HiEdoA55jsKLC7dnPuFUfhx9IlEVTA7KDze0zl
	h96qf8EpQnRDwY
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Date: Tue, 1 Jul 2008 22:36:40 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2464213.i8bOyPabV9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807012236.43780.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2464213.i8bOyPabV9
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I've one question related to that patch:

At Tue Jul  1 22:35:30 CEST 2008 Ingo Molnar wrote :
>diff --git a/kernel/sched.c b/kernel/sched.c
>index a66e856..94ead43 100644
>--- a/kernel/sched.c
>+++ b/kernel/sched.c
>@@ -8502,6 +8502,9 @@ int sched_group_set_rt_period(struct task_group *tg,=
 long rt_period_us)
> 	rt_period =3D (u64)rt_period_us * NSEC_PER_USEC;
> 	rt_runtime =3D tg->rt_bandwidth.rt_runtime;
>=20
>+	if (rt_period =3D=3D 0)
>+		return -EINVAL;
>+
> 	return tg_set_bandwidth(tg, rt_period, rt_runtime);

Why isn't the check be make before rt_runtime is set ?

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2464213.i8bOyPabV9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhqlVsACgkQhyrlCH22naMJCgCgrKUB3lFJ1evQegpJcQdKHP0q
NicAniEtuq3NoQyU6Ec1KatYxJ1Fmywt
=YHGA
-----END PGP SIGNATURE-----

--nextPart2464213.i8bOyPabV9--
