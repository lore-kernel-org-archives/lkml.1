Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbZKLEyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbZKLEyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbZKLEyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:54:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52112 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759481AbZKLEyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:54:24 -0500
Date: Thu, 12 Nov 2009 15:54:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@sr71.net>,
       Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: linux-next: leds tree build warning
Message-Id: <20091112155422.499f5f16.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_15_54_22_+1100_oadda7ccxMApElxU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_15_54_22_+1100_oadda7ccxMApElxU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/leds/leds-ss4200.c: In function 'ich7_lpc_probe':
drivers/leds/leds-ss4200.c:353: warning: 'return' with no value, in functio=
n returning non-void

Introduced by commit c2b9eda77348ff17b25471ff27f680b2c205d2bf
("leds-ss4200: Check pci_enable_device return").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_15_54_22_+1100_oadda7ccxMApElxU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr7lP4ACgkQjjKRsyhoI8wrcgCgqa2UUDSE2x+3rZ4rhg1XR3QN
CqsAnA5PNZR6HKIwQbL7t+nZTNNDgGcn
=fCY1
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_15_54_22_+1100_oadda7ccxMApElxU--
