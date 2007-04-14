Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbXDNRB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbXDNRB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXDNRB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:01:57 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:38312 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140AbXDNRB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:01:56 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Date: Sat, 14 Apr 2007 19:59:47 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070413202100.GA9957@elte.hu> <200704141809.58737.caglar@pardus.org.tr> <20070414160939.GB3099@elte.hu>
In-Reply-To: <20070414160939.GB3099@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1789212.inGmM7HUJd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704141959.50076.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1789212.inGmM7HUJd
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

14 Nis 2007 Cts tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> hm, could you try to strace it and/or attach gdb to it and figure out
> what's wrong? (perhaps involving the Kaffeine developers too?) As long
> as it's not a kernel level crash i cannot see how the scheduler could
> directly cause this - other than by accident creating a scheduling
> pattern that triggers a user-space bug more often than with other
> schedulers.

=2E..
futex(0x89ac218, FUTEX_WAIT, 2, NULL)   =3D 0
futex(0x89ac218, FUTEX_WAIT, 2, NULL)   =3D 0
futex(0x89ac218, FUTEX_WAIT, 2, NULL)   =3D 0
futex(0x89ac218, FUTEX_WAIT, 2, NULL)   =3D 0
futex(0x89ac218, FUTEX_WAIT, 2, NULL)   =3D 0
futex(0x89ac218, FUTEX_WAIT, 2, NULL)   =3D -1 EINTR (Interrupted system ca=
ll)
=2D-- SIGINT (Interrupt) @ 0 (0) ---
+++ killed by SIGINT +++

is where freeze occurs. Full log can be found at [1]

> > [1] http://cekirdek.pardus.org.tr/~caglar/psaux
>
> looks quite weird!

:)

[1] http://cekirdek.pardus.org.tr/~caglar/strace.kaffeine
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1789212.inGmM7HUJd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGIQiGy7E6i0LKo6YRAoMWAJ9hElBBw/GBfrGlPKNiXuR0D+c38wCggCBH
Xke1iBVKHWTslTGXvzoqx5U=
=a8RS
-----END PGP SIGNATURE-----

--nextPart1789212.inGmM7HUJd--
