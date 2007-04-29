Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbXD2Mho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbXD2Mho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXD2Mho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:37:44 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:55508 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755262AbXD2Mhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:37:42 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v7
Date: Sun, 29 Apr 2007 15:37:31 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, Kasper Sandberg <lkml@metanurb.dk>,
       buddabrod <buddabrod@gmail.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <20070428152539.GA21601@elte.hu> <200704290242.43741.caglar@pardus.org.tr> <20070429071117.GA3612@elte.hu>
In-Reply-To: <20070429071117.GA3612@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3628578.V27dnF21mq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704291537.34748.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3628578.V27dnF21mq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

29 Nis 2007 Paz tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> > [...] and there were no regression instead of my daydreams) or im too
> > tired to understand the differences.
>
> could the CPU have dropped speed for that bootup (some CPUs do that
> automatically upon overheating), or perhaps if you are using some RAID
> array, could it have done a background resync? Especially the bootup
> slowdown you saw seemed significant, and because bootup speed is 90% IO
> dominated, the CPU scheduler seems an unlikely candidate.

It could some overheating problem but i think if it is, this is the first t=
ime=20
it occurs :), and i don't have any array, SAMSUNG HM120JC IDE disk works on=
=20
SONY VAIO FS-215B.

I just boot with plain CFSv7 and boot time seems normal;=20

Apr 29 15:02:54 (up 10.72) /sbin/mudur.py sysinit
Apr 29 15:03:02 (up 17.26) /sbin/mudur.py boot
Apr 29 15:03:06 (up 21.34) /sbin/mudur.py default

I'll report if i can find any reproducable problem, so far CFSv7 works as=20
expected :)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3628578.V27dnF21mq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGNJGOy7E6i0LKo6YRArB+AJ46R8NV0sUB8dC/7pYTNmb48ftG+ACfcEp7
WdJky652MkWw1AaGAf4tC24=
=4Msq
-----END PGP SIGNATURE-----

--nextPart3628578.V27dnF21mq--
