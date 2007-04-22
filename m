Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXDVICd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXDVICd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965512AbXDVICd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:02:33 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:44751 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965461AbXDVICa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:02:30 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: ck@vds.kolivas.org
Subject: Re: [ck] [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Date: Sun, 22 Apr 2007 10:02:07 +0200
User-Agent: KMail/1.9.5
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Al Boldi <a1426z@gawab.com>, Peter Williams <pwil3058@bigpond.net.au>,
       Nick Piggin <npiggin@suse.de>, Matt Mackall <mpm@selenic.com>,
       Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
References: <200704221441.48897.kernel@kolivas.org>
In-Reply-To: <200704221441.48897.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1749841.6YSV0uADGl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704221002.21289.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177228950;6465c97e;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1749841.6YSV0uADGl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Con,

I now have 2.6.21-rc7-sd-0.45 running on my Intel Core2 T7600 2.33
machine and there is something I don't understand.

=46or testing I have a Perl script that does some numbercrunching
and runs a couple of hours.

I have two scenarios
a) start the job via loops in a shellscript
b) start the job via a makefile (make -j 2)
that I run in parallel.

I watch the jobs via top and this is what I see:
Job a) quickly gets about 100% (- 0-2) while job b) creates two
perl jobs that both get 50% (- 0-2). I suppose it is expected
behaviour that the single perl job created via a) gets same same
share of the cpu as the two perl jobs created via b) together.

However occasionally cpu drops to 33% for all three perl jobs
while there is no other job visible in top (i.e. the sum drops
from 200% to 100%). After some time this changes back to 100/50/50.

How could this happen and would applying the other patch you
mailed to Willy Tarreau help tracking that down ?

Best wishes,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1749841.6YSV0uADGl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGKxaNUYYhyuxDQc4RAog8AJ9xSI/r3xhOxF7lxZDuB+GhCq+d6gCfVpUI
W7CFk5mZU5sJNd/OHabOv44=
=e0a5
-----END PGP SIGNATURE-----

--nextPart1749841.6YSV0uADGl--
