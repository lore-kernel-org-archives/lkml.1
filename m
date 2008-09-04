Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYIDJDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYIDJDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYIDJDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:03:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:35438 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752434AbYIDJDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:03:15 -0400
Subject: Re: [PATCH 1/2] utrace core
From: Petr Tesarik <ptesarik@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080903184613.GD16175@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain>
	 <20080826220157.397C7154233@magilla.localdomain>
	 <1220446707.6041.27.camel@elijah.suse.cz>
	 <20080903180854.61207154228@magilla.localdomain>
	 <20080903184613.GD16175@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qhsYZrVp9TwLv8TteA7k"
Organization: SUSE LINUX
Date: Thu, 04 Sep 2008 11:03:14 +0200
Message-Id: <1220518994.6041.83.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qhsYZrVp9TwLv8TteA7k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-03 at 14:46 -0400, Christoph Hellwig wrote:
> On Wed, Sep 03, 2008 at 11:08:54AM -0700, Roland McGrath wrote:
> > > Why does it depend on MODULES?=20
> >=20
> > Because otherwise it's not adding anything new anyone can use.
>=20
> It doesn't add anything new to use either way
>=20
> > > Does this mean that when ptrace is switched to using the utrace engin=
es,
> > > non-modular kernels will have to lack ptrace(2)?
> >=20
> > No.  If that were done, then it would be:
> > 	depends on MODULE || PTRACE
> > or suchlike.
> >=20
> > > Is there anything in the code that actually breaks without
> > > CONFIG_MODULES?
> >=20
> > No.
>=20
> In which case you should just remove this bogus (non-)dependency.

+1

Petr Tesarik


--=-qhsYZrVp9TwLv8TteA7k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBIv6RSjpY2ODFi2ogRAvCsAJ9FnshgZ3arlVpmsdWZyJ+MaAzQ2wCeP8B1
6T2565iM143Om0Ddu6okCeI=
=pL3J
-----END PGP SIGNATURE-----

--=-qhsYZrVp9TwLv8TteA7k--

