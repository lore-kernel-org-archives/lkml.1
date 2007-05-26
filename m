Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXEZPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXEZPJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXEZPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 11:09:13 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:55092 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752875AbXEZPJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 11:09:12 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v14
Date: Sat, 26 May 2007 18:08:55 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com
References: <20070523120616.GA23407@elte.hu> <200705261758.26956.caglar@pardus.org.tr>
In-Reply-To: <200705261758.26956.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1604955.BIWbijiMyt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705261808.58445.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1604955.BIWbijiMyt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

26 May 2007 Cts tarihinde, S.=C3=87a=C4=9Flar Onur =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:=20
> 23 May 2007 =C3=87ar tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:
> > As usual, any sort of feedback, bugreport, fix and suggestion is more
> > than welcome!
>
> I have another kaffeine [0.8.4]/xine-lib [1.1.6] problem with CFS for you
> :)
>
> Under load (compiling any Qt app. or kernel with -j1 or -j2) audio always
> goes sync with time (and i'm sure it never skips) but video starts slowdo=
wn
> and loses its sync with audio (like for the 10th sec. of a movie, audio is
> at 10th sec. also, but the shown video is from 7th sec.).
>
> After some time video suddenly wants to sync with audio and starts to play
> really fast (like fast-forward) and syncs with audio. But it will lose its
> audio/video sync after a while and loop continues like that.
>
> I also reproduced that behaviour with CFS-13, i'm not sure its reproducib=
le
> with mainline cause for a long time i only use CFS (but i'm pretty sure
> that problem not exists or not hit me with CFS-1 to CFS-11). And its only
> reproducible with some load and mplayer plays same video without losing i=
ts
> audio/video sync with same load.

Ah, i forgot to add you can find the "strace -o kaffine.log -f -tttTTT=20
kaffeine" and ps output while that problem exists at [1]

[1] http://cekirdek.pardus.org.tr/~caglar/kaffeine/
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1604955.BIWbijiMyt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGWE2Ky7E6i0LKo6YRAhSoAJ0b9CBxrZvOMdbGyn4W6FrEfOjwrwCffrhg
Uw2DEo1xb+sJ+oP4z9njW28=
=L/1g
-----END PGP SIGNATURE-----

--nextPart1604955.BIWbijiMyt--
