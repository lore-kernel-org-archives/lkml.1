Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYA1Un2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYA1Un2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYA1UnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:43:19 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:44825 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYA1UnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:43:19 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [LTP] [TEST] : LTP Build failure on 2.6.24 kernel
Date: Mon, 28 Jan 2008 15:43:16 -0500
User-Agent: KMail/1.9.7
Cc: ltp-list@lists.sourceforge.net, risrajak@in.ibm.com,
       linux-kernel@vger.kernel.org
References: <1201508081.4029.4.camel@localhost.localdomain> <200801280653.16624.vapier@gentoo.org> <20080128202929.GB8767@does.not.exist>
In-Reply-To: <20080128202929.GB8767@does.not.exist>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5949662.I3ddcLqd3t";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801281543.17816.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5949662.I3ddcLqd3t
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 January 2008, Adrian Bunk wrote:
> On Mon, Jan 28, 2008 at 06:53:15AM -0500, Mike Frysinger wrote:
> > On Monday 28 January 2008, Rishikesh K. Rajak wrote:
> > > Here i am getting failure on the x86_64 machine with new kernel.
> > >
> > > Here is the uname for that machine:
> > >
> > > rishi@:~/ltp-full-20071231# uname -a
> > > Linux rishi.in.ibm.com 2.6.24 #1 SMP PREEMPT Mon Jan 28 06:47:28 UTC
> > > 2008 x86_64 GNU/Linux
> >
> > i'm guessing you're using ubuntu and thus dash is your /bin/sh ...
> > shouldnt be a 2.6.24 issue
> >
> > > make[4]: Entering directory
> > > `/root/ltp-full-20071231/testcases/network/tcp_cmds/ftp'
> > > ../../generate.sh
> > > ../../generate.sh: 60: arith: syntax error: "cnt=3Dcnt-1"
> >
> > sadly, this is becoming a FAQ.  ubuntu ships a broken /bin/sh (dash) and
> > thus some LTP scripts fall apart.  i would prefer to not change the
> > scripts as the message is simple in LTP: fix your shell, dont add hacks
> > to LTP.  otherwise we slowly back ourselves into this corner with the
> > shell scripts where we try to support every craptastic shell out there
> > and we're afraid to make any changes because we dont know what crappy
> > shell is going to drop a brick.  LTP scripts are written to be POSIX
> > complaint and only POSIX complaint shells should be provided by /bin/sh.
>
> You better fulfil your claim "LTP scripts are written to be POSIX
> complaint" before complaining about shells being unhappy with your
> script. E.g. where in IEEE 1003.1-2004 is the "local" you use specified?

yes, local is a bsd extension not in POSIX.  it has been implemented by eve=
ry=20
shell so far though.  as soon as someone complains, i'll be more than happy=
=20
to fix it.

> Or instead of working on making your script using only the stuff
> specified in IEEE 1003.1-2004 you could simply replace the #!/bin/sh at
> the top with a #!/bin/bash and everbody will be happy.

no
=2Dmike

--nextPart5949662.I3ddcLqd3t
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR54+ZUFjO5/oN/WBAQJFoQ/9HVOR980jPQ0BA6UzW8/ctEH2XUGIMFpK
aIuDR6uYcwooE888X/eXQoOCYK3N1ljwqWQ2pJ8cSKO9te6t8km30HWHh9oIGroQ
Gh11gufUzeb1/2KsRFUi1TCiyYzXjjAkAgJmsJmd04fS4IfCU7NwAHAyEvWBQUOy
DGFoO/keD4HRgvZlnaQVEfW2dQPvo2Mi2Uvx8RaKFDl+rbZRgnIvvJwb1TfvpgtK
pz1mNfAET+lOZ91B+270h2u8/xU0sD0bibuidzs9onVA1BJ+ubxASeIiUDWWVJXF
CiWMDa5F/n77lJ+3CFwxPl0Xmp4n7+ZeUvc8vVdfscnpjazScGZmd5iETfzOloVZ
7Hs/N2Y6TzeHWQLI9FksTP9PhFZGxLWVBPSZZ9hTEjb2nSL0pof8xOeeY2HwR38E
wJehxkh/j6FBoXQnacy1l4ZBGg2KyVW8m8xVasTuOhuo7egRAOCwmxHQpp0HRSml
yp/J3I2UICJrWW9KQIwbYn3g3hc1VqIls7E+bd9lbGP7FI5AlHfqxxYUsrzNZhWu
OJZeE5Z2OOmFDDkpuD535Hx0s9Dwj99jmtRNLHjpH4paqKQyR3qgRc229QutRLrP
RX8ok5TNOiW2Eiz3fw22oWMw3L1ik3t0w1MBdRMuftN6yA2e+zF9g+aDmOUGI5dO
EUgg7MhLG84=
=MlXW
-----END PGP SIGNATURE-----

--nextPart5949662.I3ddcLqd3t--
