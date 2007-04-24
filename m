Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbXDXJGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbXDXJGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 05:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXDXJGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 05:06:48 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:42884 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbXDXJGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 05:06:47 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [REPORT] cfs-v5 vs sd-0.46
Date: Tue, 24 Apr 2007 11:06:29 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704240938.07482.mgd@technosis.de> <200704241041.53762.mgd@technosis.de> <20070424085105.GA12329@elte.hu>
In-Reply-To: <20070424085105.GA12329@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1395167.vdoqPGDQBM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704241106.41912.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177405606;267aaf53;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1395167.vdoqPGDQBM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> oh, you are writing the number-cruncher?

Yep.

> In general the 'best' =20
> performance metrics for scheduler validation are the ones where you have=
=20
> immediate feedback: i.e. some ops/sec (or ops per minute) value in some=20
> readily accessible place, or some "milliseconds-per-100,000 ops" type of=
=20
> metric - whichever lends itself better to the workload at hand.

I'll have to see whether that works out. I don't have an easily
available ops/sec but I guess I could create something similar.

> If you =20
> measure time then the best is to use long long and nanoseconds and the=20
> monotonic clocksource:

[snip]
Thanks, I will implement that, for Linux anyway.

> Plus an absolute metric of "the whole workload took X.Y seconds" is=20
> useful too.

That's the easiest to come by and is already available.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1395167.vdoqPGDQBM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLcihUYYhyuxDQc4RAj5sAJ4/ngT7J3JWcsQwUb4y/2Pc2ISMlACfToj1
dLzQc7NLwIXxrKg/4V3WX6Q=
=yL3g
-----END PGP SIGNATURE-----

--nextPart1395167.vdoqPGDQBM--
