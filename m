Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYHUKUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYHUKUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYHUKUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:20:21 -0400
Received: from ozlabs.org ([203.10.76.45]:39631 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYHUKUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:20:19 -0400
Subject: Re: [Cbe-oss-dev] powerpc/cell/oprofile: fix mutex locking for
	spu-oprofile
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, Robert Richter <robert.richter@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>
In-Reply-To: <200808211014.42683.arnd@arndb.de>
References: <1217620879.15667.145.camel@carll-linux-desktop>
	 <200808201519.19453.arnd@arndb.de>
	 <18604.60738.523963.886786@drongo.ozlabs.ibm.com>
	 <200808211014.42683.arnd@arndb.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JqgvIhwwsQmTK+CI1mt6"
Date: Thu, 21 Aug 2008 20:20:10 +1000
Message-Id: <1219314010.7827.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JqgvIhwwsQmTK+CI1mt6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-21 at 10:14 +0200, Arnd Bergmann wrote:
> On Thursday 21 August 2008, Paul Mackerras wrote:
> > Arnd Bergmann writes:
> >=20
> > > Paul, any chance we can still get this into 2.6.27?
> >=20
> > Possibly.  We'll need a really good explanation for Linus as to why
> > this is needed (what regression or serious bug this fixes) and why it
> > is late.  Can you send me something explaining that?
>=20
> The patch does not fix a regression, the spu-oprofile code basically neve=
r
> worked. With the current code in Linux, samples in the profile buffer
> can get corrupted because reader and writer to that buffer use different
> locks for accessing it.

Actually for me it worked[1] a reasonable amount of the time, enough to
be useful. So the spu-oprofile code has always been broken in this way,
but it's not always fatal. So the patch doesn't fix a regression, but it
fixes a serious user-visible bug, which makes it legit rc4 material
IMHO.

[1] that was late last year, so possibly a kernel or two ago.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-JqgvIhwwsQmTK+CI1mt6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIrUFadSjSd0sB4dIRAlHKAJ4oBE3v9ppU4oEOPWkj14wwKwLLSQCgs6iu
GyCYGC3opKCqo8n1WiZtmME=
=uCJc
-----END PGP SIGNATURE-----

--=-JqgvIhwwsQmTK+CI1mt6--

