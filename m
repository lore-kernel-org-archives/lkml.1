Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZIGNng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZIGNng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZIGNnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:43:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39943 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZIGNnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:43:35 -0400
Date: Mon, 7 Sep 2009 23:43:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: security-testing tree build failure
Message-Id: <20090907234331.58140be8.sfr@canb.auug.org.au>
In-Reply-To: <20090907234028.6728eb5e.sfr@canb.auug.org.au>
References: <20090907234028.6728eb5e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Sep_2009_23_43_31_+1000_vX/CXRkXmtnMY37z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Sep_2009_23_43_31_+1000_vX/CXRkXmtnMY37z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Sep 2009 23:40:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next build (arm lots of configs) failed like this:
>=20
> arch/arm/kernel/signal.c: In function 'do_notify_resume':
> arch/arm/kernel/signal.c:701: error: implicit declaration of function 'tr=
acehook_notify_resume'
>=20
> Caused by commit d0420c83f39f79afb82010c2d2cafd150eef651b ("KEYS: Extend
> TIF_NOTIFY_RESUME to (almost) all architectures [try #6]").  Presumably
> the include of linux/tracehook.h is missing.

The avr32 defconfig build fails the same way as well.  Thee may be
others, that is as far as we have gone so far.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Sep_2009_23_43_31_+1000_vX/CXRkXmtnMY37z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqlDgMACgkQjjKRsyhoI8z1dgCfVsagSnod3UF+u41stlNNmE7x
UuQAnifvAi4PXBTihflDGTeiCUYBCqf+
=8VJq
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Sep_2009_23_43_31_+1000_vX/CXRkXmtnMY37z--
