Return-Path: <linux-kernel-owner+w=401wt.eu-S1751251AbZG1Ebs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbZG1Ebs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZG1Ebr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:31:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60515 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZG1Ebq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:31:46 -0400
Date: Tue, 28 Jul 2009 14:31:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Natarajan <vivek.natraj@gmail.com>
Subject: linux-next: wireless tree build warning
Message-Id: <20090728143141.5d6108ff.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Jul_2009_14_31_41_+1000_bDEsJwCZH9_yMtEz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jul_2009_14_31_41_+1000_bDEsJwCZH9_yMtEz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/net/wireless/ath/ath9k/eeprom.c: In function 'ath9k_hw_AR9287_check=
_eeprom':
drivers/net/wireless/ath/ath9k/eeprom.c:2866: warning: comparison of distin=
ct pointer types lacks a cast

Introduced by commit ac88b6ecdfa629fd1261dab1504d78a56fd4cabf ("ath9k:
Add support for AR9287 based chipsets").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Jul_2009_14_31_41_+1000_bDEsJwCZH9_yMtEz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpufy0ACgkQjjKRsyhoI8w6jACgkK+lBi/2z+UOWqzrSUD/sUbo
waAAoI32MeaJbMZ8tTBbHYf/G+BYEjo2
=4G/g
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jul_2009_14_31_41_+1000_bDEsJwCZH9_yMtEz--
