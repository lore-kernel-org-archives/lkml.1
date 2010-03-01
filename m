Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0CACMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 21:12:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43393 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab0CACMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 21:12:37 -0500
Date: Mon, 1 Mar 2010 13:12:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: build failure after merge of the i2c tree
Message-Id: <20100301131231.4c541979.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Mar_2010_13_12_31_+1100_mrF_45LvJn.ooEgk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Mar_2010_13_12_31_+1100_mrF_45LvJn.ooEgk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

After merging the i2c tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/i2c/busses/i2c-powermac.c: In function 'i2c_powermac_smbus_xfer':
drivers/i2c/busses/i2c-powermac.c:125: error: 'err' undeclared (first use i=
n this function)

Caused by commit 2fe61c97a4b1be56d93a84992ffcf00d55f60f63 ("i2c-powermac:
Be less verbose in the absence of real errors").

I have used the i2c tree from next-20100226 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Mar_2010_13_12_31_+1100_mrF_45LvJn.ooEgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuLIo8ACgkQjjKRsyhoI8ym5gCfbtPKaibCM2LOj40PaQsid3AD
K1IAnRBDILFpTrKfr6n0mq7zwU9mMuXu
=S01i
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Mar_2010_13_12_31_+1100_mrF_45LvJn.ooEgk--
