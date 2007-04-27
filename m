Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbXD0GxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbXD0GxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXD0GxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:53:04 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:34355 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425AbXD0GxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:53:01 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [ck] Re: [REPORT] cfs-v6-rc2 vs sd-0.46 vs 2.6.21-rc7
Date: Fri, 27 Apr 2007 07:59:07 +0200
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>, Bill Davidsen <davidsen@tmr.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Gene Heskett <gene.heskett@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704261312.25571.mgd@technosis.de> <20070426120723.GA4092@elte.hu> <200704270859.37931.kernel@kolivas.org>
In-Reply-To: <200704270859.37931.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1563788.bnKDMgynq7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704270759.23265.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177656781;8b32656d;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1563788.bnKDMgynq7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Very interesting indeed but fairly complicated as well.

Sorry for that -- I've taken these figures from the 3MB logfile
that each job creates and "reading" them on a regular basis tend
to forget that probably everyody else does not find them as
obvious as I do. Also I'm don't really have lots of experience
with how a scheduler is properly tested.

=46or any upcoming tests I will restrict the numbers to wallclock
and what time provides which probably is better suited anyway.

> > as a summary: i think your numbers demonstrate it nicely that the
> > shorter 'timeslice length' that both CFS and SD utilizes does not have a
> > measurable negative impact on your workload. To measure the total impact
> > of 'timeslicing' you might want to try the exact same workload with a
> > much higher 'timeslice length' of say 400 msecs, via:
> >
> >     echo 400000000 > /proc/sys/kernel/sched_granularity_ns  # on CFS
> >     echo 400 > /proc/sys/kernel/rr_interval                 # on SD
>=20
> I thought that the effective "timeslice" on CFS was double the=20
> sched_granularity_ns so wouldn't this make the effective timeslice double=
=20
> that of what you're setting SD to? Anyway the difference between 400 and=
=20
> 800ms timeslices is unlikely to be significant so I don't mind.

I'm happy to do that, hopefully over the weekend.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1563788.bnKDMgynq7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMZE7UYYhyuxDQc4RAsRCAJ9OPG2u5zAeIYwUa0GV4b9DDMOC8gCfUdIS
1Dc+Q1HhMRRiIyXq7lnsNXo=
=5Vq8
-----END PGP SIGNATURE-----

--nextPart1563788.bnKDMgynq7--
