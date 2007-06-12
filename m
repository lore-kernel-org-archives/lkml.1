Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbXFLBLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbXFLBLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbXFLBK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:10:56 -0400
Received: from ozlabs.org ([203.10.76.45]:41176 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747AbXFLBKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:10:55 -0400
Subject: Re: [PATCH] PCI: also read revision ID for sparc64, ppc, read
	class at the same time
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, Auke Kok <auke-jan.h.kok@intel.com>,
       gregkh@suse.de, davem@davemloft.net, grundler@parisc-linux.org
In-Reply-To: <59594cddc7b5eb6e355fd01efef8ebcc@kernel.crashing.org>
References: <20070609201221.5868.31948.stgit@localhost.localdomain>
	 <1181474643.8351.1.camel@concordia.ozlabs.ibm.com>
	 <59594cddc7b5eb6e355fd01efef8ebcc@kernel.crashing.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZxsbfrlbRkrCGTViBMA5"
Date: Tue, 12 Jun 2007 11:10:48 +1000
Message-Id: <1181610648.17771.0.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZxsbfrlbRkrCGTViBMA5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-10 at 14:17 +0200, Segher Boessenkool wrote:
> >> +	dev->revision =3D get_int_prop(node, "revision-id", 0);
> >
> > It's not clear to me in the spec if nodes are required to have the
> > "revision-id" property.
>=20
> It is required for every PCI node.

Yep. I was reading the wrong spec :)

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-ZxsbfrlbRkrCGTViBMA5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGbfKYdSjSd0sB4dIRApZvAKDMB9ciG+ocbmKTD+Bk/yZhR07MNACgl98b
BuUtuppksk26jlWbPY3fl/w=
=yMFD
-----END PGP SIGNATURE-----

--=-ZxsbfrlbRkrCGTViBMA5--

