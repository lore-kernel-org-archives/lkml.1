Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbYA1VVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbYA1VVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYA1VVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:21:06 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38605 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYA1VVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:21:04 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [LTP] [TEST] : LTP Build failure on 2.6.24 kernel
Date: Mon, 28 Jan 2008 16:21:01 -0500
User-Agent: KMail/1.9.7
Cc: ltp-list@lists.sourceforge.net, risrajak@in.ibm.com,
       linux-kernel@vger.kernel.org
References: <1201508081.4029.4.camel@localhost.localdomain> <200801281543.17816.vapier@gentoo.org> <20080128211046.GC8767@does.not.exist>
In-Reply-To: <20080128211046.GC8767@does.not.exist>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2116794.CVirzOAOTt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801281621.02758.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2116794.CVirzOAOTt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 January 2008, Adrian Bunk wrote:
> On Mon, Jan 28, 2008 at 03:43:16PM -0500, Mike Frysinger wrote:
> > On Monday 28 January 2008, Adrian Bunk wrote:
> > > On Mon, Jan 28, 2008 at 06:53:15AM -0500, Mike Frysinger wrote:
> > > > On Monday 28 January 2008, Rishikesh K. Rajak wrote:
> > > > > Here i am getting failure on the x86_64 machine with new kernel.
> > > > >
> > > > > Here is the uname for that machine:
> > > > >
> > > > > rishi@:~/ltp-full-20071231# uname -a
> > > > > Linux rishi.in.ibm.com 2.6.24 #1 SMP PREEMPT Mon Jan 28 06:47:28
> > > > > UTC 2008 x86_64 GNU/Linux
> > > >
> > > > i'm guessing you're using ubuntu and thus dash is your /bin/sh ...
> > > > shouldnt be a 2.6.24 issue
> > > >
> > > > > make[4]: Entering directory
> > > > > `/root/ltp-full-20071231/testcases/network/tcp_cmds/ftp'
> > > > > ../../generate.sh
> > > > > ../../generate.sh: 60: arith: syntax error: "cnt=3Dcnt-1"
> > > >
> > > > sadly, this is becoming a FAQ.  ubuntu ships a broken /bin/sh (dash)
> > > > and thus some LTP scripts fall apart.  i would prefer to not change
> > > > the scripts as the message is simple in LTP: fix your shell, dont a=
dd
> > > > hacks to LTP.  otherwise we slowly back ourselves into this corner
> > > > with the shell scripts where we try to support every craptastic she=
ll
> > > > out there and we're afraid to make any changes because we dont know
> > > > what crappy shell is going to drop a brick.  LTP scripts are written
> > > > to be POSIX complaint and only POSIX complaint shells should be
> > > > provided by /bin/sh.
> > >
> > > You better fulfil your claim "LTP scripts are written to be POSIX
> > > complaint" before complaining about shells being unhappy with your
> > > script. E.g. where in IEEE 1003.1-2004 is the "local" you use
> > > specified?
> >
> > yes, local is a bsd extension not in POSIX.  it has been implemented by
> > every shell so far though.  as soon as someone complains, i'll be more
> > than happy to fix it.
>
> David Korn's ksh93 (e.g. shipped in the Debian "ksh" package) disproves
> your claim "it has been implemented by every shell so far".

sorry, i left out the operative word "relevant".  i dont care what random=20
shell fails unless people are actually utilizing it as their /bin/sh in any=
=20
sort of useful context.  as soon as someone complains for real and not just=
=20
to be annoying, i'll address their complaint then.

the issue that spawned this thread has been fixed in latest dash git tree, =
but=20
no new release has been cut.  Debian has grabbed said fixes, so go bug Ubun=
tu=20
if they havent as well.
=2Dmike

--nextPart2116794.CVirzOAOTt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR55HPkFjO5/oN/WBAQJGZBAAuBBc9V5NytY7LWasBMyVkqaJd9K6Z5Ne
V2GJSNDt935wLXqpBnR3/3MxP3tHiuFVYPO6M0OQ8Mqd5v5mva1gKC1/5RPqcj39
lT9jhdf3/7nxTlRx5XHnzipsr2DU2ucqpDiHL2CFvpAheYvegXJdxC/EJYbuvThb
MwkOGbaTf0QoUbuRxchCxUZp8ylQARGDWTic5m2HDGHe1NlwPjAZfzypF6eMIvKI
YQZLHco1DQ4SbG+jYwr0SaAVbLUlDeEIZRDbPqwjrjgWYB0G5nkQXntQsJsPHeIX
4WrIkQ6hWhlLczhXtYu5vNtlnGvocIRCrnfwHma+RRo0YgbQ7HsAE7qk1jtyOC2v
vpoNaJmqz6InfU0GaZgPhHJor0k2VqN9lMkbdagbtLzEAA4nfz9aNIbaCOwXXMnO
5D8cBm7phdMosn8foswOe0nznl6+0zqk13SSuIJ5HBGKFzB0S5MugYJ/dwWioI93
g3HVuGHvgUUsSj1DudM6fBfDOo3qBYmEzwHjnbuM/a+hh7gv6kd8kfiX1MsxMSVj
WN5JEzlERP5VgFnerYbSKmbpB9OY94xZGFDUB1/QvUZhRvw9bDQvD88SvEi34p9R
gkZQs4u7PCpvCYT7PUTZC/kM2MbN6LybkIesZNoTSSe9b4OM0wEbxcIXyI6tySNE
SwwEV9oQnBo=
=egIg
-----END PGP SIGNATURE-----

--nextPart2116794.CVirzOAOTt--
