Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0CCDrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 22:47:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55560 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0CCDrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 22:47:22 -0500
Date: Wed, 3 Mar 2010 14:47:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?Ik3DoXJ0b24gTsOpbWV0aCI=?= <nm127@freemail.hu>,
       Jean Delvare <khali@linux-fr.org>
Subject: linux-next: manual merge of the mfd tree with the i2c tree
Message-Id: <20100303144715.2b607ac1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Mar_2010_14_47_15_+1100_sJP=Xg3jDV4pqNyw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Mar_2010_14_47_15_+1100_sJP=Xg3jDV4pqNyw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/i2c/busses/i2c-isch.c between commit
482b522a6ced62506aba1c139cb9d4b73e7312f5 ("i2c: Make PCI device ids
constant") from the i2c tree and commit
1fc8fe094a8ebcc09817246277250898a8d2fc5a ("i2c: convert i2c-isch to
platform_device") from the mfd tree.

The latter removes the code modified by the former, so I used the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Mar_2010_14_47_15_+1100_sJP=Xg3jDV4pqNyw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuN28MACgkQjjKRsyhoI8xL4QCfUyoHHCGCz4jahtp/RqAYKlU6
B3YAnixikyNeiau+yg0jaxdw2i09iVY+
=w4to
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Mar_2010_14_47_15_+1100_sJP=Xg3jDV4pqNyw--
