Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZFDXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZFDXxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZFDXxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:53:10 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:43020 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZFDXxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:53:09 -0400
Subject: Re: [GIT PULL] drm-intel fixes for 2.6.30-rc8
From: Eric Anholt <eric@anholt.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1244139713.23850.3.camel@localhost.localdomain>
References: <1244133916.11142.14.camel@gaiman.anholt.net>
	 <1244139713.23850.3.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EA6ct/cH80NmNEVTJSly"
Date: Thu, 04 Jun 2009 23:52:31 +0000
Message-Id: <1244159551.11142.16.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EA6ct/cH80NmNEVTJSly
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 20:21 +0200, Marcel Holtmann wrote:
> Hi Eric,
>=20
> > The following changes since commit 9fa7eb283c5cdc2b0f4a8cfe6387ed82e5e9=
a3d3:
> >   Linus Torvalds (1):
> >         Linux 2.6.30-rc8
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-li=
nus
> >=20
> > This fixes a bogus BUG_ON that I saw get triggered with the new texture
> > tiling code on gen4.  There are a couple of lovely further bugfixes in
> > drm-intel-next, but it's rc8 and I'd rather help quiet things down
> > so .30 gets out the door :)
>=20
> no idea if this has any relation to it. I am running wireless-testing
> which is based on 2.6.30-rc8 and I got this (for the the first time):
>=20
> [   46.185008] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank=
 count for disabled pipe 0

This has been around for ages, is unrelated, and harmless.

> [   54.606049] metacity[2319]: segfault at 0 ip 0000000000462a4e sp 00007=
fff412e4f60 error 4 in metacity[400000+86000]

Sounds like you need some gdb.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-EA6ct/cH80NmNEVTJSly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkooXj8ACgkQHUdvYGzw6vfetACgh1sndY/nFNUoFjuMHpy8q6Fo
wqAAnRPwIWXgJL/FNGm29W3WDD/G0HId
=nNFB
-----END PGP SIGNATURE-----

--=-EA6ct/cH80NmNEVTJSly--
