Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYHASML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYHASML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYHASL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:11:57 -0400
Received: from home.keithp.com ([63.227.221.253]:1899 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYHASL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:11:57 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 14:11:56 EDT
Subject: Re: [PATCH] drm: Add GEM ("graphics execution manager") to i915
	driver.
From: Keith Packard <keithp@keithp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080801084405.62d3c823.randy.dunlap@oracle.com>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
	 <1217573919-7496-3-git-send-email-eric@anholt.net>
	 <20080801084405.62d3c823.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2oOhEfuwxg8GmAPUuIZR"
Date: Fri, 01 Aug 2008 11:11:50 -0700
Message-Id: <1217614310.23437.251.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2oOhEfuwxg8GmAPUuIZR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 08:44 -0700, Randy Dunlap wrote:

> "the 2d driver" ... "the 3d driver".
> Just curious:  Is there only one of each of these?

We only need one X.org 2D and one Mesa 3D driver for each card, but DRI
supports as many rendering APIs as you like, including XvMC which offers
accelerated video decode on top of DRI as well.

So, the answer is that yes, at this point, we have only the two Intel
integrated graphics drivers using GEM, but also no, the interface can
support as many drivers as you want.

I hope that GEM will encourage more graphics API research as it allows
multiple user-space APIs to talk to the same underlying hardware
resources.

--=20
keith.packard@intel.com

--=-2oOhEfuwxg8GmAPUuIZR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIk1HmQp8BWwlsTdMRAhyJAKCuFvQpgXcXxjDb1wwvY17NSM1g4gCgjtqV
je76tTWJnKnDn/49YV5vNeU=
=Hd+D
-----END PGP SIGNATURE-----

--=-2oOhEfuwxg8GmAPUuIZR--

