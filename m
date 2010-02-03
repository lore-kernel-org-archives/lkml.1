Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0BCF5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:57:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60379 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0BCF5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:57:31 -0500
Date: Wed, 3 Feb 2010 16:57:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: linux-next: build warning after merge of usb tree
Message-Id: <20100203165726.e258ad58.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Feb_2010_16_57_26_+1100_6cQjYGcH8d4riTE_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Feb_2010_16_57_26_+1100_6cQjYGcH8d4riTE_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

In file included from drivers/usb/gadget/mass_storage.c:64:
drivers/usb/gadget/f_mass_storage.c: In function 'fsg_setup':
drivers/usb/gadget/f_mass_storage.c:623: warning: comparison of distinct po=
inter types lacks a cast
In file included from drivers/usb/gadget/multi.c:75:
drivers/usb/gadget/f_mass_storage.c: In function 'fsg_setup':
drivers/usb/gadget/f_mass_storage.c:623: warning: comparison of distinct po=
inter types lacks a cast

Introduced by commit a736e2758c6390b854219e6f6bb4f9a0e3be66df ("USB:
g_mass_storage: superfluous and missing packets fixed").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Feb_2010_16_57_26_+1100_6cQjYGcH8d4riTE_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktpEEYACgkQjjKRsyhoI8wzXQCfckGrlLDLEE3kDEyspMQAZ62v
5qQAn1w0EiEEZ2YaFoNImqWJrA1xTplK
=TQeO
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Feb_2010_16_57_26_+1100_6cQjYGcH8d4riTE_--
