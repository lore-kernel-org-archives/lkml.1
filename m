Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZGBBDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZGBBDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZGBBDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:03:13 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:47896 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZGBBDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:03:12 -0400
Subject: Re: X server hung, kernel said "task blocked for >120 secs"
 (2.6.30)
From: Eric Anholt <eric@anholt.net>
To: Sanjoy Mahajan <sanjoy@MIT.EDU>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <E1MM2yf-0002dX-Lg@approx.mit.edu>
References: <E1MM2yf-0002dX-Lg@approx.mit.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lYg+CWomkDZh4fL3wukq"
Date: Wed, 01 Jul 2009 18:03:15 -0700
Message-Id: <1246496595.16527.3.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lYg+CWomkDZh4fL3wukq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-01 at 12:48 -0400, Sanjoy Mahajan wrote:
> [Have been away for 10 days and just saw the message]
>=20
> > I assume this is a regression?  Since 2.6.29?
>=20
> I never saw it before using 2.6.30 and haven't been able to reproduce
> it even running 2.6.30. =20
>=20
> So it could be a regression.  Or it could be a recurring problem (I had
> a few X lockups with earlier kernels) now exposed by a blocked-task
> timer (the "INFO: task events/0:9 blocked for more than 120 seconds"
> message) -- if that notification code is new in 2.6.30?

This message appears when the GPU is hung but somebody is still trying
to use it.  The problem is that the GPU is hung, not the presence of the
message (so you can't use the message to indicate any particular bug,
and the bug is almost always in userland).

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-lYg+CWomkDZh4fL3wukq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkpMB1MACgkQHUdvYGzw6vd1+gCdGe5ZIzOxypjEsejRT/GVgFCM
l+kAmMgj6dcuCdKDKaNvLeOFDfITXOs=
=wuJT
-----END PGP SIGNATURE-----

--=-lYg+CWomkDZh4fL3wukq--

