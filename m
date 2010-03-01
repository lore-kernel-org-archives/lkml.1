Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab0CAFra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:47:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48590 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0CAFr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:47:28 -0500
Date: Mon, 1 Mar 2010 16:47:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>
Subject: linux-next: build warning after merge of the net tree
Message-Id: <20100301164721.f8ce9fac.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Mar_2010_16_47_21_+1100_2RYTlIYccz0aAOMh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Mar_2010_16_47_21_+1100_2RYTlIYccz0aAOMh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the net tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

net/bluetooth/hci_sysfs.c: In function 'inquiry_cache_read':
net/bluetooth/hci_sysfs.c:441: warning: the frame size of 4208 bytes is lar=
ger than 2048 bytes

Introduced by commit ca325f698996c1a0770a67f41e7dc97a007d8bc2
("Bluetooth: Convert inquiry cache to use debugfs instead of sysfs")
which introduces a function with a 4096 char array on the stack.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Mar_2010_16_47_21_+1100_2RYTlIYccz0aAOMh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuLVOkACgkQjjKRsyhoI8zrfgCfVfKWnHwTrmLvbZo5anCEyVuJ
HW4An0IRiICeQ0ciB4LkOqlWixUEqe9I
=fNPV
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Mar_2010_16_47_21_+1100_2RYTlIYccz0aAOMh--
