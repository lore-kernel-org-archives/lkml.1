Return-Path: <linux-kernel-owner+w=401wt.eu-S1750850AbXB0Bbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850AbXB0Bbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXB0Bbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:31:50 -0500
Received: from ozlabs.org ([203.10.76.45]:60131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXB0Bbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:31:50 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
	patch
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net
In-Reply-To: <200702270051.00393.arnd@arndb.de>
References: <1172102523.5233.31.camel@dyn9047021078.beaverton.ibm.com>
	 <200702270051.00393.arnd@arndb.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NXpwvAIj5UyJc5dBBuIX"
Date: Tue, 27 Feb 2007 10:31:46 +0900
Message-Id: <1172539906.15967.36.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NXpwvAIj5UyJc5dBBuIX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-27 at 00:50 +0100, Arnd Bergmann wrote:
> On Thursday 22 February 2007, Carl Love wrote:
> > This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
> > to add in the SPU profiling capabilities.  In addition, a 'cell' subdir=
ectory
> > was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
> > code.
>=20
> There was a significant amount of whitespace breakage in this patch,
> which I cleaned up. The patch below consists of the other things
> I changed as a further cleanup. Note that I changed the format
> of the context switch record, which I found too complicated, as
> I described on IRC last week.
>=20
> 	Arnd <><
>=20
> --
> Subject: cleanup spu oprofile code
>=20
> From: Arnd Bergmann <arnd.bergmann@de.ibm.com>
> This cleans up some of the new oprofile code. It's mostly
> cosmetic changes, like way multi-line comments are formatted.
> The most significant change is a simplification of the
> context-switch record format.
>=20
> It does mean the oprofile report tool needs to be adapted,
> but I'm sure that it pays off in the end.

I hate to be a stickler, but this patch is quite large, contains
multiple changes, and mixes formatting changes with functional
changes ... makes it a little hard to review :/

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-NXpwvAIj5UyJc5dBBuIX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBF44oCdSjSd0sB4dIRAgFIAKCJuAhgkS7NjyVo+hilSLYAfdNj1QCdH6Do
gM7ZRT1LJWSYm+h0JkyyjC8=
=nQ/o
-----END PGP SIGNATURE-----

--=-NXpwvAIj5UyJc5dBBuIX--

