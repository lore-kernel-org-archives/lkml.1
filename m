Return-Path: <linux-kernel-owner+w=401wt.eu-S1763085AbXHaG4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763085AbXHaG4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 02:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759422AbXHaG4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 02:56:10 -0400
Received: from code-monkey.de ([88.198.45.137]:36701 "EHLO code-monkey.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759098AbXHaG4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 02:56:08 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2007 02:56:08 EDT
Date: Fri, 31 Aug 2007 08:46:39 +0200
From: Tilman Sauerbeck <tilman@code-monkey.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: keith.packard@intel.com, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Ingo Molnar <mingo@elte.hu>, dri-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CFS review
Message-ID: <20070831064638.GA5315@code-monkey.de>
References: <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu> <1188361749.21502.123.camel@koto.keithp.com> <20070829044614.GA13225@elte.hu> <1188374249.21502.155.camel@koto.keithp.com> <20070829080417.GB19386@elte.hu> <1188403075.21502.158.camel@koto.keithp.com> <46D5CF5F.6090505@gmail.com> <46D66C2D.3010900@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <46D66C2D.3010900@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rene Herman [2007-08-30 09:05]:
> On 08/29/2007 09:56 PM, Rene Herman wrote:
>=20
> Realised the BUGs may mean the kernel DRM people could want to be in CC...
>=20
> > On 08/29/2007 05:57 PM, Keith Packard wrote:
> >=20
> >> With X server 1.3, I'm getting consistent crashes with two glxgear
> >> instances running. So, if you're getting any output, it's better than =
my
> >> situation.
> >=20
> > Before people focuss on software rendering too much -- also with 1.3.0
> > (and a Matrox Millenium G550 AGP, 32M) glxgears also works decidedly
> > crummy using hardware rendering. While I can move the glxgears window
> > itself, the actual spinning wheels stay in the upper-left corner of the
> > screen and the movement leaves a non-repainting trace on the screen.

This sounds like you're running an older version of Mesa.
The bugfix went into Mesa 6.3 and 7.0.

> > Running a second instance of glxgears in addition seems to make both
> > instances unkillable -- and when I just now forcefully killed X in this
> > situation (the spinning wheels were covering the upper left corner of a=
ll
> > my desktops) I got the below.

Running two instances of glxgears and killing them works for me, too.

I'm using xorg-server 1.3.0.0, Mesa 7.0.1 with the latest DRM bits from
http://gitweb.freedesktop.org/?p=3Dmesa/drm.git;a=3Dsummary

I'm not running CFS though, but I guess the oops wasn't related to that.

Regards,
Tilman

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing on usenet and in e-mail?

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQFG17lO27uLisrW2w8RAnNdAJ9vsXbjbeGdjoEpnQpdSzQ5E4MtcwCdEFwS
+rra462G/56C4KZYNjJ+pRQ=
=/hx+
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
