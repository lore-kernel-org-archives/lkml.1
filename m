Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXB1MJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXB1MJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbXB1MJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:09:45 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:40452 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932162AbXB1MJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:09:44 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [BUG] at drivers/char/vt.c:3332 do_blank_screen() on resume
Date: Wed, 28 Feb 2007 14:10:00 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       lkml <linux-kernel@vger.kernel.org>, spock@gentoo.org
References: <200702090838.21060.caglar@pardus.org.tr> <1172151671.4306.13.camel@daplas> <200702221552.14491.caglar@pardus.org.tr>
In-Reply-To: <200702221552.14491.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1335488.UqRRKp3YA4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702281410.04196.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1335488.UqRRKp3YA4
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

22 =C5=9Eub 2007 Per tarihinde, S.=C3=87a=C4=9Flar Onur =C5=9Funlar=C4=B1 y=
azm=C4=B1=C5=9Ft=C4=B1:=20
> 22 =C5=9Eub 2007 Per tarihinde, Antonino A. Daplas =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:
> > Ah, and you have fb_splash too.  That's why the tracing was not what I
> > expected it to be.
> >
> > Try using video=3Dvesafb:noblank to disable hardware blanking and find =
out
> > if you can still reproduce the oops.
>
> I'll try and also will try to reproduce with vanilla one.

Sorry for long delay, here are some more test results;

* using video=3Dvesafb:noblank _sometimes_ causes hard freezes on resume, a=
nd=20
_sometimes_ X can't start properly (it enters a weird "switch vt1 - wait fo=
r=20
some seconds - switch vt7" loop and after ~10 minutes X starts magically!)=
=20
whenever this happens system starts to become really unresponsive and dmesg=
=20
and Xorg's logs shows nothing strange :(. I will try an older kernel with=20
noblank to see its related or not.

* If system resumes normally with noblank (it can sometimes :)), dmesg show=
s=20
no error at all, X starts normally and system works well.

* I cannot reproduce that BUG with _vanilla one_ but please note that i can=
not=20
easily reproduce that with patched one also (it occurs only once for ~20=20
suspend2disk/resume cycle)

I'll try to test more and trying to reproduce, if i can find anything else=
=20
i'll knock your door again :)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1335488.UqRRKp3YA4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBF5XEcy7E6i0LKo6YRAh9YAJ0ZVwxEyPmZ0NGitN8zUjksSUxgCACg1yv6
d4GQG5x7up0y134hlxbM+Dc=
=SQmG
-----END PGP SIGNATURE-----

--nextPart1335488.UqRRKp3YA4--
