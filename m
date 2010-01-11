Return-Path: <linux-kernel-owner+w=401wt.eu-S1751320Ab0AKFCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab0AKFCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 00:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946Ab0AKFCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 00:02:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33033 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab0AKFCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 00:02:40 -0500
Date: Mon, 11 Jan 2010 16:02:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: mfd tree build failure
Message-Id: <20100111160232.e37e5393.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Jan_2010_16_02_32_+1100_0/2=oCIWkuoy=N_="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Jan_2010_16_02_32_+1100_0/2=oCIWkuoy=N_=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

Today's linux-next build (x86_64_allmodconfig, gcc 4.4.0, binutils
2.19.1) failed like this:

ERROR: "max8925_set_bits" [drivers/video/backlight/max8925_bl.ko] undefined!
ERROR: "max8925_reg_write" [drivers/video/backlight/max8925_bl.ko] undefine=
d!
ERROR: "max8925_reg_read" [drivers/video/backlight/max8925_bl.ko] undefined!
ERROR: "max8925_set_bits" [drivers/regulator/max8925.ko] undefined!
ERROR: "max8925_reg_read" [drivers/regulator/max8925.ko] undefined!

I am not sure what caused this, so I have used the version of the mfd
tree from next-20100108 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Jan_2010_16_02_32_+1100_0/2=oCIWkuoy=N_=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktKsOgACgkQjjKRsyhoI8xlmwCdGNlW99sqfRQUqXp9rMioIPqT
zCEAoLP59fsQuMtivo7hAYxFlygeSz3M
=FlAT
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Jan_2010_16_02_32_+1100_0/2=oCIWkuoy=N_=--
