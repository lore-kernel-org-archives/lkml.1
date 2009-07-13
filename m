Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZGMH1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZGMH1C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:27:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZGMH06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:26:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbZGMH05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:26:57 -0400
Date: Mon, 13 Jul 2009 17:26:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: linux-next: driver-core tree build warning
Message-Id: <20090713172646.55b9acee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Jul_2009_17_26_46_+1000_+mjsBoU_SS7jqa+u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jul_2009_17_26_46_+1000_+mjsBoU_SS7jqa+u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/firewire/core-device.c: In function 'init_fw_attribute_group':
drivers/firewire/core-device.c:315: warning: assignment from incompatible p=
ointer type

Introduced by commit 025a6a26b70e5dc12ab9333ea43d70c735f459ac ("driver
model: constify attribute groups").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Jul_2009_17_26_46_+1000_+mjsBoU_SS7jqa+u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpa4bYACgkQjjKRsyhoI8wdRwCgpEEyntdypiVpg6aOKVn7pb5f
o8MAn2D40vz/ejG57be8duLQRnVaUzkT
=qBsq
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jul_2009_17_26_46_+1000_+mjsBoU_SS7jqa+u--
