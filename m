Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbXEZO6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbXEZO6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbXEZO6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:58:41 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:57475 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754915AbXEZO6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:58:40 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v14
Date: Sat, 26 May 2007 17:58:24 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com
References: <20070523120616.GA23407@elte.hu>
In-Reply-To: <20070523120616.GA23407@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1337484.DvkqiQpqWq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705261758.26956.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1337484.DvkqiQpqWq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo;

23 May 2007 =C3=87ar tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome!

I have another kaffeine [0.8.4]/xine-lib [1.1.6] problem with CFS for you :)

Under load (compiling any Qt app. or kernel with -j1 or -j2) audio always g=
oes=20
sync with time (and i'm sure it never skips) but video starts slowdown and=
=20
loses its sync with audio (like for the 10th sec. of a movie, audio is at=20
10th sec. also, but the shown video is from 7th sec.).=20

After some time video suddenly wants to sync with audio and starts to play=
=20
really fast (like fast-forward) and syncs with audio. But it will lose its=
=20
audio/video sync after a while and loop continues like that.

I also reproduced that behaviour with CFS-13, i'm not sure its reproducible=
=20
with mainline cause for a long time i only use CFS (but i'm pretty sure tha=
t=20
problem not exists or not hit me with CFS-1 to CFS-11). And its only=20
reproducible with some load and mplayer plays same video without losing its=
=20
audio/video sync with same load.

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1337484.DvkqiQpqWq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGWEsSy7E6i0LKo6YRAnLlAJ0RjS9QS9rLp0a0pyuNPgCt0AnRrwCfQQge
4HK+KULEcupoX1DOMv6ctmI=
=sgFU
-----END PGP SIGNATURE-----

--nextPart1337484.DvkqiQpqWq--
