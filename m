Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZFYBOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZFYBOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 21:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZFYBNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 21:13:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51301 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZFYBNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 21:13:49 -0400
Date: Thu, 25 Jun 2009 11:13:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Baruch Siach <baruch@tkos.co.il>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: linux-next: origin tree build failure
Message-Id: <20090625111344.35febd82.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Jun_2009_11_13_44_+1000_d/xe=HKojjtr4JTg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Jun_2009_11_13_44_+1000_d/xe=HKojjtr4JTg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "clk_enable" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_disable" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_put" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_get_rate" [drivers/i2c/busses/i2c-designware.ko] undefined!
ERROR: "clk_get" [drivers/i2c/busses/i2c-designware.ko] undefined!

Caused by commit 1ab52cf910bbbee92861227e6ed77c56b1dc233c ("i2c: driver
for the Synopsys DesignWare I2C controller") from Linus' tree which I
have reverted for today.

This, again, never saw the light of day in linux-next ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Jun_2009_11_13_44_+1000_d/xe=HKojjtr4JTg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpCz0gACgkQjjKRsyhoI8wCmgCgtpJKuo02/HS5p4EtXoC8vtwT
oHMAmgIlC0stldJq9dkqglQRJgKkuxSt
=aKdR
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Jun_2009_11_13_44_+1000_d/xe=HKojjtr4JTg--
