Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbXFANgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbXFANgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbXFANgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:36:05 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:49332 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757066AbXFANgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:36:04 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v14
Date: Fri, 1 Jun 2007 16:35:02 +0300
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
  boundary="nextPart2768931.ufvtY1Ksb2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706011635.02774.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2768931.ufvtY1Ksb2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

26 May 2007 Cts tarihinde, S.=C3=87a=C4=9Flar Onur =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:=20
> Under load (compiling any Qt app. or kernel with -j1 or -j2) audio always
> goes sync with time (and i'm sure it never skips) but video starts slowdo=
wn
> and loses its sync with audio (like for the 10th sec. of a movie, audio is
> at 10th sec. also, but the shown video is from 7th sec.).
>
> After some time video suddenly wants to sync with audio and starts to play
> really fast (like fast-forward) and syncs with audio. But it will lose its
> audio/video sync after a while and loop continues like that.

After a lots of private mail traffic and debuggin efforts with Ingo, yester=
day=20
i simply requested to ignore that problem (at least until i can reproduce=20
same with different machines).=20

Yesterday i turn back to vanilla 2.6.18.8 to see the situation with it and =
i=20
reproduce the problem even with lower loads.

Seems like this piece of hardware is dieing [For a while my laptop starts t=
o=20
poweroff suddenly without any log/error etc] and i think all these problems=
=20
caused by this. Or at least/ for me/ this laptop (sony vaio fs-215b) is not=
 a=20
stable test bed for this kind of human involved testings.

Ingo cannot reproduce same audio/video out-of-sync problems with his setups=
,=20
and currently i'm the only person deals with that problem.=20

And for some boots kernel reports wrong frequency for my cpu (and notice th=
e=20
timing difference), [this maybe a overheat problem but aslo i'll try=20
disabling CONFIG_NO_HZ as Ingo suggested]

=2E..
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 897.591 MHz processor.
[   13.142654] Console: colour dummy device 80x25
[   13.143609] Dentry cache hash table entries: 131072 (order: 7, 524288=20
 bytes)
[   13.144530] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
=2E..

=2E..
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1729.292 MHz processor.
[    8.286228] Console: colour dummy device 80x25
[    8.286650] Dentry cache hash table entries: 131072 (order: 7, 524288=20
bytes)
[    8.287058] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
=2E..

As a result, please ignore this problem until i can reproduce on different=
=20
machines or someone else reports the same problem :)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart2768931.ufvtY1Ksb2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGYCCGy7E6i0LKo6YRAgxsAJ0aALgq0OKCivH1vJvX5vk7f52RxACgm4ra
hjDLeyjNjMeNJyRv14rxnis=
=tJPG
-----END PGP SIGNATURE-----

--nextPart2768931.ufvtY1Ksb2--
