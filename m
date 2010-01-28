Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547Ab0A1Xiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0A1Xiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499Ab0A1Xir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:38:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49476 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab0A1Xio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:38:44 -0500
Date: Fri, 29 Jan 2010 10:38:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: arm tree build failure
Message-Id: <20100129103837.02cc865f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jan_2010_10_38_37_+1100_MolG_fyd+2mpi+IW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jan_2010_10_38_37_+1100_MolG_fyd+2mpi+IW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Yesterday's linux-next (next-20100128) build (arm versatile_defconfig)
failed like this:

arch/arm/mach-versatile/core.c: In function 'versatile_init':
arch/arm/mach-versatile/core.c:838: error: 'i' undeclared (first use in thi=
s function)

Looks like a bad merge (commit b7cdd38da36d61d0f42367057c9d04678644317a
"Merge branch 'versatile' into devel").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jan_2010_10_38_37_+1100_MolG_fyd+2mpi+IW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktiH/0ACgkQjjKRsyhoI8zcEQCcCirgo9eReCBNbNt1NBqanU9Z
kvYAn28DknfkxLCrsUihaPdO6pSkW1z9
=QxKm
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jan_2010_10_38_37_+1100_MolG_fyd+2mpi+IW--
