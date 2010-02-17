Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab0BQAjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:39:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47362 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933749Ab0BQAjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:39:01 -0500
Date: Wed, 17 Feb 2010 11:38:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the i2c tree
Message-Id: <20100217113855.7ebf3d39.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Feb_2010_11_38_55_+1100_xByEQyEja66rkF2l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Feb_2010_11_38_55_+1100_xByEQyEja66rkF2l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

After merging the i2c tree, today's linux-next build (powerpc
ppc64_defconfig) produced warnings like this:

In file included from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from drivers/i2c/i2c-boardinfo.c:19:
arch/powerpc/include/asm/bitops.h:226: warning: declaration of 'ffs' shadow=
s a built-in function

The x86_64 allmodconfig produces similar:

In file included from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from next/drivers/i2c/i2c-boardinfo.c:19:
arch/x86/include/asm/bitops.h:395: warning: declaration of 'ffs' shadows a =
built-in function

Exposed by commit fa4f62e9f3a85490aebe8857e2208c37da851ce3 ("i2c: Build
core and algo drivers with -Wshadow").

Jean, I realise that these warnings are not something your tree has
added, just that you have exposed them.  They are a bit annoying,
though.  I am using gcc v4.4.3.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Feb_2010_11_38_55_+1100_xByEQyEja66rkF2l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt7Op8ACgkQjjKRsyhoI8zRnQCggW97XNVXP8N2Fga8oYCemurB
XVwAoLL7Tg5FV+3npgi9mQc2dYWpOKet
=18RF
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Feb_2010_11_38_55_+1100_xByEQyEja66rkF2l--
