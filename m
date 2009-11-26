Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZKZDGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZKZDGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:06:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZKZDGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:06:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45331 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbZKZDGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:06:00 -0500
Date: Thu, 26 Nov 2009 14:06:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: i2c tree build warning
Message-Id: <20091126140600.2f55ab0e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_14_06_00_+1100_cJf71GLr139HqxNf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_14_06_00_+1100_cJf71GLr139HqxNf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/misc/eeprom/at24.c: In function 'at24_eeprom_read':
drivers/misc/eeprom/at24.c:230: warning: format '%zd' expects type 'signed =
size_t', but argument 6 has type 'int'

Introduced by commit 39bfab2519e6f148f2508d719f9fc5f4581aeefd ("at24: Use
timeout also for read").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_14_06_00_+1100_cJf71GLr139HqxNf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksN8JgACgkQjjKRsyhoI8wKOQCeJgrpQBxE39ABa2bXDiD/GctH
+hAAoLqka7NHuMgPrQ59M5Hi49lbUb5J
=w7YH
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_14_06_00_+1100_cJf71GLr139HqxNf--
