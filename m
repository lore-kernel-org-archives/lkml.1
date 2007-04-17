Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXDQOrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXDQOrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030503AbXDQOrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:47:31 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:57825 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030502AbXDQOra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:47:30 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Date: Tue, 17 Apr 2007 17:45:19 +0300
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <20070416220715.GA4071@elte.hu> <200704170112.35819.caglar@pardus.org.tr> <20070417085936.GB16645@elte.hu>
In-Reply-To: <20070417085936.GB16645@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7797411.ZGXQWlPFLj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704171745.22544.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7797411.ZGXQWlPFLj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

17 Nis 2007 Sal tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> > Sorry for delayed response but i just find some free time, do you
> > still want me to test mainline + "parent-runs first" patch or will i
> > drop that one and test v2 which can change default behaviour?
>
> i suspect for now it would be sufficient if you could check the v2
> patch.
>
> if it _works_, please try this:
>
>     echo 0 > /proc/sys/kernel/sched_child_runs_first
>
> this should break Kaffeine again :)
>
> (if it doesnt work then the Kaffeine problem is unrelated to
> child-runs-first.)

OK, i tested both plain -rc7 and -rc7 + CFSv2 with while=20
sched_child_runs_first enabled/disabled.

I'm always using same video file and try to reproduce freeze with constantl=
y=20
pressing forward/backward buttons. With CFS 2-3 forward/backward attempt=20
reproduces this behaviour.=20

And here are the results.

Mainline still has no issues with both xine-lib/kaffeine and xine-ui=20
(kaffeine-0.8.4, xine-lib-1.1.5 [both xcb enabled], xine-ui-0.99.4). I real=
ly=20
try hard to reproduce the freeze, but i can't...

And CFSv2 still fails for both child_runs_first and parent_runs_first cases=
=20
with same strace output (FUTEX_WAIT).

If you want me to test something else just ask please :)=20

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart7797411.ZGXQWlPFLj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGJN2Cy7E6i0LKo6YRArrMAKDT6+4Ke7h3mDFA5JsqR0FdmfreLwCgnzoP
5bWHFM2cPPkcN4R8w5O6Whg=
=NnwD
-----END PGP SIGNATURE-----

--nextPart7797411.ZGXQWlPFLj--
