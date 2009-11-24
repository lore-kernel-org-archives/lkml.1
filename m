Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbZKXBOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbZKXBOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757650AbZKXBOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:14:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45538 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZKXBOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:14:16 -0500
Date: Tue, 24 Nov 2009 12:14:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Corentin Chary <corentincj@iksaif.net>
Subject: linux-next: ubifs tree build failure
Message-Id: <20091124121415.dc1e98a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_12_14_15_+1100_K+=LIqF2JST8bf1m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_12_14_15_+1100_K+=LIqF2JST8bf1m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next build (x86_64 allmodconfig) failed like this:

fs/ubifs/super.c: In function 'open_ubi':
fs/ubifs/super.c:1866: error: implicit declaration of function 'ubi_open_vo=
lume_path'
fs/ubifs/super.c:1866: warning: assignment makes pointer from integer witho=
ut a cast

Caused by commit 82ccbf8c4ec2113d4e73dbac3ca914019ca883ca ("UBIFS:
support mounting of UBI volume character devices") which I have reverted
for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_12_14_15_+1100_K+=LIqF2JST8bf1m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLM2cACgkQjjKRsyhoI8wszQCgpmcSPcWZ6jEFiRbP6zA70pop
n6QAnjE720ogS6tAH7jUhiDlz+qhQQ9l
=kUrE
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_12_14_15_+1100_K+=LIqF2JST8bf1m--
