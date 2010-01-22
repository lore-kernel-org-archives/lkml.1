Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052Ab0AVEWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0AVEWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539Ab0AVEV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:21:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0AVEV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:21:58 -0500
Date: Fri, 22 Jan 2010 15:21:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Jean-Hugues Deschenes" <jean-hugues.deschenes@octasic.com>
Subject: linux-next: spi tree build failure
Message-Id: <20100122152152.5666ccab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Jan_2010_15_21_52_+1100_2=kDCgZ6EKF_CHNK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Jan_2010_15_21_52_+1100_2=kDCgZ6EKF_CHNK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "clk_get_rate" [drivers/spi/dw_spi_mmio.ko] undefined!
ERROR: "clk_enable" [drivers/spi/dw_spi_mmio.ko] undefined!
ERROR: "clk_get" [drivers/spi/dw_spi_mmio.ko] undefined!
ERROR: "clk_put" [drivers/spi/dw_spi_mmio.ko] undefined!
ERROR: "clk_disable" [drivers/spi/dw_spi_mmio.ko] undefined!

Caused by commit f7b6fd6d1d3833529f1626c761ba7e338586d35e ("Memory-mapped
dw_spi driver").

I have used the spi tree from next-20100120 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Jan_2010_15_21_52_+1100_2=kDCgZ6EKF_CHNK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktZJ+AACgkQjjKRsyhoI8yndgCguBuG8iZAEj6ksLlIWC8elx7o
vjIAn39ahU3rWy4tjCFqYpjSDKfda2Sn
=3HuY
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Jan_2010_15_21_52_+1100_2=kDCgZ6EKF_CHNK--
