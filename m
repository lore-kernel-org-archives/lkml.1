Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZIGKHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZIGKHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZIGKHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:07:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60784 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbZIGKG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:06:59 -0400
Date: Mon, 7 Sep 2009 20:06:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jayamohan Kallickal <jayamohank@serverengines.com>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: linux-next: scsi-post-merge tree build failure
Message-Id: <20090907200646.c6d6fadc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Sep_2009_20_06_46_+1000_nvjNj7yDjY+qKbnn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Sep_2009_20_06_46_+1000_nvjNj7yDjY+qKbnn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/scsi/be2iscsi/be_main.c: In function 'hwi_write_buffer':
drivers/scsi/be2iscsi/be_main.c:1481: error: implicit declaration of functi=
on 'virt_to_bus'

Caused by commit 9316dc3deb9675c674f96a0c6fb74ccc6c497fae ("[SCSI]
be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver") which I have reverted
for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Sep_2009_20_06_46_+1000_nvjNj7yDjY+qKbnn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqk2zYACgkQjjKRsyhoI8yGSwCeIBsZoAPHTEeOvWoSGiUV90r7
dRMAoLAqqaXfLjf3LSWrWO7ElYqIjNOq
=0sp8
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Sep_2009_20_06_46_+1000_nvjNj7yDjY+qKbnn--
