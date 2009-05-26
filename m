Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZEZVir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZEZVir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZEZVik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:38:40 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:35393 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZEZVij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:38:39 -0400
Subject: Re: i915_gem_retire_requests oops on 2.6.30-rc7
From: Eric Anholt <eric@anholt.net>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <b2cdc9f30905260520m6d779cdof202dabe511ed49b@mail.gmail.com>
References: <b2cdc9f30905260520m6d779cdof202dabe511ed49b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-A3Xg05cDiQB/h7RkrUsB"
Date: Tue, 26 May 2009 14:38:34 -0700
Message-Id: <1243373914.8400.29.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A3Xg05cDiQB/h7RkrUsB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-26 at 13:20 +0100, Alex Bennee wrote:
> Hi,
>=20
> I've just had X crash on me with an attendant oops in the kernel as it di=
d so:

That's not an oops, that's a WARN_ON.  The hardware wasn't caught up by
the time we gave up when shutting down the harwdare for VT switching.
That's bad.  But we don't know how long we should wait, since the GPU
may be hung, and waiting forever would be bad.  So we warn that
Something Bad may have happened.

It's gone with KMS since we never shut down the GPU.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-A3Xg05cDiQB/h7RkrUsB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkocYVoACgkQHUdvYGzw6vfGXACfbibc2XEEJVZcL9rMLDIK4DEe
QBgAn2XPLWegSqgy6+OvbY3OXyD9feMQ
=8upE
-----END PGP SIGNATURE-----

--=-A3Xg05cDiQB/h7RkrUsB--

