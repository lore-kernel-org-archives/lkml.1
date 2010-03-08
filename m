Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0CHDn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 22:43:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34687 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab0CHDnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 22:43:51 -0500
Date: Mon, 8 Mar 2010 14:43:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard =?UTF-8?B?UsO2amZvcnM=?= <richard.rojfors@pelagicore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: linux-next: build failure after merge of the scsi-post-merge final
 tree
Message-Id: <20100308144343.d2129e35.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Mar_2010_14_43_43_+1100_FeY75_NsKR7QXpPx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Mar_2010_14_43_43_+1100_FeY75_NsKR7QXpPx
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/i2c/busses/i2c-xiic.c:39:28: error: linux/i2c-xiic.h: No such file =
or directory
drivers/i2c/busses/i2c-xiic.c: In function =E2=80=98xiic_i2c_probe=E2=80=99:
drivers/i2c/busses/i2c-xiic.c:750: error: dereferencing pointer to incomple=
te type
drivers/i2c/busses/i2c-xiic.c:751: error: dereferencing pointer to incomple=
te type

I assume people already now about this.

Caused by commit e1d5b6598cdc33257fe68302ae9db81d2f7bb883 ("i2c: Add
support for Xilinx XPS IIC Bus Interface") from Linus' tree.  I have
reverted that commit for today.

[The version of that patch in next-20100305 had the extra file in it ...]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__8_Mar_2010_14_43_43_+1100_FeY75_NsKR7QXpPx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuUcm8ACgkQjjKRsyhoI8ytBgCgkttl4V+pbhnNCwPIN1jgJGAx
byoAn1xYxbw0b0XWcf2kYx0eL2NzByIj
=BvM7
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Mar_2010_14_43_43_+1100_FeY75_NsKR7QXpPx--
