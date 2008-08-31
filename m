Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYHaToY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYHaToY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756343AbYHaToP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:44:15 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:61946 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328AbYHaToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:44:14 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tom Tucker <tom@opengridcomputing.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       John Ronciak <john.ronciak@gmail.com>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <20080831193037.GB14876@fieldses.org>
References: <1219442213.9097.25.camel@localhost>
	 <1219603981.27921.145.camel@localhost.localdomain>
	 <1219605422.14389.2.camel@localhost> <1219605596.14389.5.camel@localhost>
	 <1219615789.27921.152.camel@localhost.localdomain>
	 <1219616136.14389.12.camel@localhost>
	 <48B2D7F8.5020206@opengridcomputing.com>
	 <20080826192711.GJ4380@fieldses.org>
	 <48B567F5.2090605@opengridcomputing.com>
	 <1220111261.31172.14.camel@localhost.localdomain>
	 <20080831193037.GB14876@fieldses.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+6bOO1Np7AoKUki5/su3"
Date: Sun, 31 Aug 2008 20:44:02 +0100
Message-Id: <1220211842.31172.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+6bOO1Np7AoKUki5/su3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-31 at 15:30 -0400, J. Bruce Fields wrote:
> On Sat, Aug 30, 2008 at 04:47:41PM +0100, Ian Campbell wrote:
> > On Wed, 2008-08-27 at 09:43 -0500, Tom Tucker wrote:
> > > Sure. I've actually tried to reproduce it here unsuccessfully.
> > >=20
> > > As a starter, I would suggest turning on transport debugging:
> > >=20
> > > # echo 256 > /proc/sys/sunrpc/rpc_debug
> > > [...]
> > > If Ian is willing to create the log (or already has one), I'm
> > > certainly willing to look at it.
> >=20
> > It produced only the following (is that what was expected?):
> >=20
> > [146866.448112] -pid- proc flgs status -client- -prog- --rqstp- -timeou=
t -rpcwait -action- ---ops--
> > [146866.448112] 30576 0001 00a0      0 f77a1600 100003 f7903340    1500=
0 xprt_pending fa0ba88e fa0c9df4
> > [146866.448112] 30577 0004 0080    -11 f77a1600 100003 f7903000        =
0 xprt_sending fa0ba88e fa0c9df4
>=20
> It's normal to get something like that when you turn it on, yes (unless
> someone else spots anything odd about that...) but what's really needed
> is to turn this on and then reproduce the problem--it's the debugging
> output that goes to the logs during the problem that'll be interesting.

That's what I did. The first time I did the echo I just got the header
line, then I waited for the repro and since there had been no further
logging I ran the echo again and got the three lines above.

Sounds like you expected there to be more and ongoing logging?

Ian.

> --b.
>=20
--=20
Ian Campbell

kernel, n.:
	A part of an operating system that preserves the medieval
	traditions of sorcery and black art.

--=-+6bOO1Np7AoKUki5/su3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAki69IIACgkQM0+0qS9rzVnkYgCfWrYh529Bqt8yNRz176054Y2e
1d8AoLXxBJLlJph71wmqItVaQ9/hgtg3
=cHPe
-----END PGP SIGNATURE-----

--=-+6bOO1Np7AoKUki5/su3--

