Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab0CCFXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:23:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38194 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab0CCFXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:23:00 -0500
Date: Wed, 3 Mar 2010 16:22:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Denis Turischev <denis@compulab.co.il>
Subject: linux-next: build warning after merge of the mfd tree
Message-Id: <20100303162252.e7cf0e43.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_16_22_52_+1100_BYbEqRQdlF.0IueB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Mar_2010_16_22_52_+1100_BYbEqRQdlF.0IueB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/gpio/sch_gpio.c: In function 'sch_gpio_probe':
drivers/gpio/sch_gpio.c:232: warning: ignoring return value of 'gpiochip_re=
move', declared with attribute warn_unused_result
drivers/gpio/sch_gpio.c: In function 'sch_gpio_remove':
drivers/gpio/sch_gpio.c:245: warning: ignoring return value of 'gpiochip_re=
move', declared with attribute warn_unused_result
drivers/gpio/sch_gpio.c:246: warning: ignoring return value of 'gpiochip_re=
move', declared with attribute warn_unused_result

Introduced by commit 4faabcde03a89836169f1437127226f4b0714070 ("gpio: add
Intel SCH GPIO controller driver").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_16_22_52_+1100_BYbEqRQdlF.0IueB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuN8iwACgkQjjKRsyhoI8y2jACfeNaRdXlXYN98GgcDQltGugxp
x8oAn11Pu7uuB0/rRuRBCmnk3yAd9K9Z
=i5mG
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_16_22_52_+1100_BYbEqRQdlF.0IueB--
