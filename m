Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZFWGWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZFWGWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbZFWGW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:22:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54098 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbZFWGW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:22:27 -0400
Date: Tue, 23 Jun 2009 16:22:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andy Green <andy@warmcat.com>, Ben Dooks <ben-linux@fluff.org>,
       Michel Pollet <buserror@gmail.com>
Subject: linux-next: origin tree build failure
Message-Id: <20090623162223.55b9880c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Jun_2009_16_22_23_+1000_pR/qoTxm.Cyayvwo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jun_2009_16_22_23_+1000_pR/qoTxm.Cyayvwo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Today's linux-next build (arm s3c2410_defconfig) failed like this:

arch/arm/mach-s3c2410/mach-smdk2410.c:94: error: 's3c_device_iis' undeclare=
d here (not in a function)
arch/arm/mach-s3c2410/mach-h1940.c:189: error: 's3c_device_iis' undeclared =
here (not in a function)
arch/arm/mach-s3c2440/mach-rx3715.c:183: error: 's3c_device_iis' undeclared=
 here (not in a function)
arch/arm/mach-s3c2412/mach-smdk2413.c:111: error: 's3c_device_iis' undeclar=
ed here (not in a function)
arch/arm/mach-s3c2440/mach-smdk2440.c:157: error: 's3c_device_iis' undeclar=
ed here (not in a function)
arch/arm/mach-s3c2412/mach-vstms.c:127: error: 's3c_device_iis' undeclared =
here (not in a function)
rch/arm/mach-s3c2440/mach-nexcoder.c:113: error: 's3c_device_iis' undeclare=
d here (not in a function)

Probably caused by commit 52da219e9664e537a745877b0efa7cf2b1ff2996
("[ARM] S3C64XX: Provide device for IIS ports");

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Jun_2009_16_22_23_+1000_pR/qoTxm.Cyayvwo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpAdJ8ACgkQjjKRsyhoI8wdPwCfWmOY156tr97XeOx08OZYKsEG
Qp8AoLkX+WyGIEC8bVJPmvDkrMgYAHFr
=0JaO
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jun_2009_16_22_23_+1000_pR/qoTxm.Cyayvwo--
