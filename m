Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbZAWX3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbZAWX3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZAWX3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:29:46 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50965 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZAWX3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:29:46 -0500
Subject: Re: [PATCH] x86: Work around PAGE_KERNEL_WC not getting WC in
	iomap_atomic_prot_pfn.
From: Eric Anholt <eric@anholt.net>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <adamydh1uo0.fsf@cisco.com>
References: <1232751258-32611-1-git-send-email-eric@anholt.net>
	 <1232751258-32611-2-git-send-email-eric@anholt.net>
	 <adamydh1uo0.fsf@cisco.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9BGsiprTQjjZgHZOYMk7"
Date: Fri, 23 Jan 2009 15:29:43 -0800
Message-Id: <1232753383.4749.2.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9BGsiprTQjjZgHZOYMk7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 15:15 -0800, Roland Dreier wrote:
> > +	if (!pat_enabled && pgprot_val(prot) =3D=3D pgprot_val(PAGE_KERNEL_WC=
))
>  > +	  prot =3D PAGE_KERNEL_UC_MINUS;
>=20
> indentation broke here (the "prot =3D" line is indented with a tab then
> two spaces, instead of two tabs)

Bad path matching going on in my .emacs indentation setup.  I don't get
out of the DRM driver often enough.  Or rather, I'm in nasty X code too
often :)

Fixed this and the other nitpick.  Thanks!

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-9BGsiprTQjjZgHZOYMk7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl6UuMACgkQHUdvYGzw6vewOQCfe8bntrB6KtCpfk0vrBO6ag7V
AyEAn0z37+VMQVaAaHyNmtu/itGb4Z32
=d98c
-----END PGP SIGNATURE-----

--=-9BGsiprTQjjZgHZOYMk7--
