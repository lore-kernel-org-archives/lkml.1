Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbYENMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbYENMtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbYENMtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:49:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42171 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbYENMtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:49:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: maximilian attems <max@stro.at>
Subject: Re: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
Date: Wed, 14 May 2008 08:49:04 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, debian-kernel@lists.debian.org
References: <200805100836.48046.vapier@gentoo.org> <200805140812.44230.vapier@gentoo.org> <20080514123209.GE27599@baikonur.stro.at>
In-Reply-To: <20080514123209.GE27599@baikonur.stro.at>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2413756.LbDRbmpMzK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805140849.05748.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2413756.LbDRbmpMzK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 14 May 2008, maximilian attems wrote:
> On Wed, May 14, 2008 at 08:12:42AM -0400, Mike Frysinger wrote:
> > On Wednesday 14 May 2008, maximilian attems wrote:
> > > On Wed, May 14, 2008 at 01:05:31PM +0200, maximilian attems wrote:
> > > > could we please get an ack or nack on that patch.
> > > > checked linux-next and it doesn't appear there.
> > > > without it currently perl 5.10 doesn't build on alpha:
> > > > perl.c: In function 'perl_construct':
> > > > perl.c:388: error: 'CONFIG_HZ' undeclared (first use in this
> > > > function) ->
> > > > http://buildd.debian.org/fetch.cgi?pkg=3Dperl;ver=3D5.10.0-10;arch=
=3Dalpha;
> > > >stam p=3D1210252894
> > >
> > > hmm it seems more userspace expects CONFIG_HZ, so it's not only a perl
> > > build breakage..
> >
> > anything using CONFIG_HZ is absolutely broken.  go fix the package.
> >
> > anything using HZ should be converted to sysconf(), but i'm not about to
> > go on that crusade to fix things up
>
> news at 11
>
> okay great that the patch went into mm.

i'm guessing you're thinking packages are using CONFIG_HZ when in reality t=
hey=20
arent.  the asm-alpha/param.h in 2.6.25 does:
#define HZ CONFIG_HZ
so anything using HZ would end up with an error message about CONFIG_HZ bei=
ng=20
undefined
=2Dmike

--nextPart2413756.LbDRbmpMzK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUASCrfwUFjO5/oN/WBAQIBFhAAoOZECF9/9X6g4ge1A/xiWsG6Y+dkouPi
Hz2kvvIa97fAUi1UHn/1eByXzd0Y+Pq33Tp8Q3BXUc4WrnSxolFPUl/dzYRe4rWj
ICbGLdblZOtAZCD0e2+NQmBhnpn9BLEATdPKc7IrykHr5t+/dJR8Q1c665Y20jwA
+53fcZ8EPKp2cl0GhDTcHtYHYev2CAs0GvLMCcnI1/KQ7+KB9hZZ19OwTIEXd6rD
nCoZEkuYt6R7mUxS0R9KS78dAwxUWNG17ru1JUhT97jDMhaLh5jbsX69DAB/8sFI
oCjrLjUiuWi5ADJ/QQhUVZqYZI+6gwGHU1B32qZNiB2iAmnDhTTYr8xa2Liw0qZj
4ha5Y0Op9GvHfV+pKnygatt8DOGUjrlAQst5UPeWyiJefqLSoxAx+YtEuD700QUQ
43EePjhi8uVz7cUqIuosBOUF7cYF1ptSX4TffTGm7TsS4YY1dm9GF1666chrNmoq
//yeEmX3sIovdI+8zamnPRswPNC/t4/vFSJ1Rc3UI2w1noOAIkqfQwMXWvRCIdJQ
cFSSmkNA1vF4DLSR7RX0VlBjEFGm5Kx5wm5GtNFu4qcBZBu+tEcCaZeaZMrKlUrp
YRLwTT2hcp0dD0sNOYnt4XDSY2a7/bcIPgd1xvb0KLIjJGNBCHDO5IvNDQ7fQWUy
f2SyQ8g1HwQ=
=j1j8
-----END PGP SIGNATURE-----

--nextPart2413756.LbDRbmpMzK--
