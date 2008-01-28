Return-Path: <linux-kernel-owner+w=401wt.eu-S1764764AbYA1Xgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764764AbYA1Xgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbYA1Xg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:36:27 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54649 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYA1Xg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:36:26 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [LTP] [TEST] : LTP Build failure on 2.6.24 kernel
Date: Mon, 28 Jan 2008 18:36:23 -0500
User-Agent: KMail/1.9.7
Cc: ltp-list@lists.sourceforge.net, risrajak@in.ibm.com,
       linux-kernel@vger.kernel.org
References: <1201508081.4029.4.camel@localhost.localdomain> <200801281621.02758.vapier@gentoo.org> <20080128214642.GD8767@does.not.exist>
In-Reply-To: <20080128214642.GD8767@does.not.exist>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1532033.ZkXrdRiGx2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801281836.24792.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1532033.ZkXrdRiGx2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 January 2008, Adrian Bunk wrote:
> On Mon, Jan 28, 2008 at 04:21:01PM -0500, Mike Frysinger wrote:
> > On Monday 28 January 2008, Adrian Bunk wrote:
> > > On Mon, Jan 28, 2008 at 03:43:16PM -0500, Mike Frysinger wrote:
> > > > On Monday 28 January 2008, Adrian Bunk wrote:
> > > > > On Mon, Jan 28, 2008 at 06:53:15AM -0500, Mike Frysinger wrote:
> > > > > > On Monday 28 January 2008, Rishikesh K. Rajak wrote:
> > > > > > > Here i am getting failure on the x86_64 machine with new
> > > > > > > kernel.
> > > > > > >
> > > > > > > Here is the uname for that machine:
> > > > > > >
> > > > > > > rishi@:~/ltp-full-20071231# uname -a
> > > > > > > Linux rishi.in.ibm.com 2.6.24 #1 SMP PREEMPT Mon Jan 28
> > > > > > > 06:47:28 UTC 2008 x86_64 GNU/Linux
> > > > > >
> > > > > > i'm guessing you're using ubuntu and thus dash is your /bin/sh
> > > > > > ... shouldnt be a 2.6.24 issue
> > > > > >
> > > > > > > make[4]: Entering directory
> > > > > > > `/root/ltp-full-20071231/testcases/network/tcp_cmds/ftp'
> > > > > > > ../../generate.sh
> > > > > > > ../../generate.sh: 60: arith: syntax error: "cnt=3Dcnt-1"
> > > > > >
> > > > > > sadly, this is becoming a FAQ.  ubuntu ships a broken /bin/sh
> > > > > > (dash) and thus some LTP scripts fall apart.  i would prefer to
> > > > > > not change the scripts as the message is simple in LTP: fix your
> > > > > > shell, dont add hacks to LTP.  otherwise we slowly back ourselv=
es
> > > > > > into this corner with the shell scripts where we try to support
> > > > > > every craptastic shell out there and we're afraid to make any
> > > > > > changes because we dont know what crappy shell is going to drop=
 a
> > > > > > brick.  LTP scripts are written to be POSIX complaint and only
> > > > > > POSIX complaint shells should be provided by /bin/sh.
> > > > >
> > > > > You better fulfil your claim "LTP scripts are written to be POSIX
> > > > > complaint" before complaining about shells being unhappy with your
> > > > > script. E.g. where in IEEE 1003.1-2004 is the "local" you use
> > > > > specified?
> > > >
> > > > yes, local is a bsd extension not in POSIX.  it has been implemented
> > > > by every shell so far though.  as soon as someone complains, i'll be
> > > > more than happy to fix it.
> > >
> > > David Korn's ksh93 (e.g. shipped in the Debian "ksh" package) disprov=
es
> > > your claim "it has been implemented by every shell so far".
> >
> > sorry, i left out the operative word "relevant".  i dont care what rand=
om
> > shell fails unless people are actually utilizing it as their /bin/sh in
> > any sort of useful context.  as soon as someone complains for real and
> > not just to be annoying, i'll address their complaint then.
> >...
>
> You started with claiming "LTP scripts are written to be POSIX
> complaint" and now that I've shown you a not that uncommon IEEE POSIX
> 1003.2 compliant shell that can't cope with your non-POSIX script you
> suddenly introduce the word "relevant".

what's your point ?  LTP scripts are POSIX compliant with a little extra th=
at=20
so far has worked fine for everyone actually running LTP.  as soon as the=20
little extra realistically becomes a problem, i'll rework things.  you have=
nt=20
shown a realistic system.  i'm willing to tweak things for real LTP users,=
=20
not people being tools.

> But when you care only about "relevant" shells you could simply
> implementing my suggestion of placing a #!/bin/bash at the top of your
> scripts instead of defining your own POSIX superset that you require
> from a /bin/sh for allowing a user to execute your script...

no.  people run LTP on embedded systems w/out bash.
=2Dmike

--nextPart1532033.ZkXrdRiGx2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR55m+EFjO5/oN/WBAQIu2hAAgyHTslpnE6iBk9UqgOf5C4plqaj66HiM
0e0UogqBaKfrf++fHfGpLHssPf0EqCdxvCDNsv8yxj7Rh6S6lrj9J2amVKT1nAy5
2wbIRHOgEmsrGi/2LB2JgyC1EVWlMnMTiXYbfsGkjI8Aa3v4I1VsnBsiQrJbY2F2
mSio3qjrzOgq0+ZixBhAgJuUseXrlZnyWf9Pj9p90xZT9GgytDRJk9NI5NzYO3Qw
X6vh3w2RINtQhSv9NZAVpMBufoOunO+Rv4ZinrvCacYJsr5a7ZIzRm/bdCqNrJtA
9vboOj9ATd0Zk+mrYaY85cxSkQKj104c/48yRTlJD2Bux33zRjgHXOX7jcYN2tjn
6dLk+QbBN3iBlJoEWSi2Ederau5UtW0T6xWUQoxOC9wcAZkXTSI/dPIDjO+j94/J
dPSuSjePKYQFXMOIv3sFEsloplQimD3Dkwwi3weP+YSSeVJbtk2atcuWsY+saQuo
E2SkUuTiPTNMti8KQ7FBqpbQnPc29nWU2cblz9o8lAdePZKhlBVKfu0O3II0MV30
OF5JpkjS7dROqp5iZWJkUCQCrd89viaITZejDp/r/wJFzFiIf+jaGfmCloNos12w
d+JKcIUAM5BkwR3xuBcBUDZOpBm+0N2TtgJITOwVJeCE6L+AEHt3zDZIP3IxAU3j
KBJau8TKPw4=
=NtNh
-----END PGP SIGNATURE-----

--nextPart1532033.ZkXrdRiGx2--
