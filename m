Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbXDZH1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbXDZH1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXDZH1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:27:30 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:38666 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933354AbXDZH13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:27:29 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [ck] [REPORT] cfs-v5 vs sd-0.46
Date: Thu, 26 Apr 2007 08:10:24 +0200
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704240938.07482.mgd@technosis.de> <200704261106.16440.kernel@kolivas.org>
In-Reply-To: <200704261106.16440.kernel@kolivas.org>
MIME-Version: 1.0
Message-Id: <200704260810.38571.mgd@technosis.de>
Content-Type: multipart/signed;
  boundary="nextPart1302670.JfRCr1TZ3R";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177572448;716ad68d;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1302670.JfRCr1TZ3R
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > with cfs-v5 finally booting on my machine I have run my daily
> > numbercrunching jobs on both cfs-v5 and sd-0.46, 2.6.21-v7 on
> > top of a stock openSUSE 10.2 (X86_64).
>=20
> Thanks for testing.

I actually enjoyed it -- the more extensive test I had promised
two days ago is almost finished. There is just one test I have
yet to (re)run and I will have a slot for it later today so I'll
mail out the results comparing
    2.6.21-rc7 (mainline)
    2.6.21-rc7-sd046
    2.6.21-rc7-cfs-v6-rc2 (X @ nice 0)
    2.6.21-rc7-cfs-v6-rc2 (X @ nice -10)
during the early afternoon (my time).

> You have 3 tasks and only 2 cpus. The %cpu is the percentage of the cpu t=
he=20
> task is currently on that it is using; it is not the percentage of=20
> the "overall cpu available on the machine". Since you have 3 tasks and 2=
=20
> cpus, the extra task will always be on one or the other cpu taking half o=
f=20
> the cpu but never on both cpus.

I had assumed that given the interval of 3 sec the three tasks would
be evenly distributed among the 2 CPUs thus resulting in a CPU% of
66 each because that's what they get in the long run anyway.

Apparently 3 sec is too short an interval to see this.

> What is important is that if all three tasks are fully cpu bound and star=
ted=20
> at the same time at the same nice level, that they all receive close to t=
he=20
> same total cpu time overall showing some fairness is working as well. Thi=
s=20
> should be the case no matter how many cpus you have.

They are started via 'make -j3' which implies they start at the
same time (i.e. within a few msec). They initially load some data
and then perform extensive computations on that data.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=C3=A4ftsf=C3=BChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1302670.JfRCr1TZ3R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMEJeUYYhyuxDQc4RAg32AJ0ZCNk7gsg82m1NwctC7l1hD1pUfACdHaIA
gok+X15IMhnfyBEtaHYBm90=
=7Nfs
-----END PGP SIGNATURE-----

--nextPart1302670.JfRCr1TZ3R--
