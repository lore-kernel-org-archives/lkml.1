Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033Ab0A0ARR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0A0ARR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297Ab0A0ARP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:17:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57439 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0A0ARP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:17:15 -0500
Date: Wed, 27 Jan 2010 11:17:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the gfs2 tree with the vfs tree
Message-Id: <20100127111708.ed39215c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Jan_2010_11_17_08_+1100_7lWEqtcz2vC1a57G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Jan_2010_11_17_08_+1100_7lWEqtcz2vC1a57G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Today's linux-next merge of the gfs2 tree got a conflict in
fs/gfs2/super.c between commit 716c28c0bc8bcbdd26e819f38dfc8fdfaafc0289
("pass writeback_control to ->write_inode") from the vfs tree and commit
56c79d55103b5d0943e063d036e7ebf8a7a1c21b ("GFS2: Wait for unlock
completion on umount") from the gfs2 tree.

Just simple overlapping additions.  I fixed up (see below) and can carry
the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/gfs2/super.c
index effa35a,e2bf19f..0000000
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@@ -21,7 -21,7 +21,8 @@@
  #include <linux/gfs2_ondisk.h>
  #include <linux/crc32.h>
  #include <linux/time.h>
 +#include <linux/writeback.h>
+ #include <linux/wait.h>
 =20
  #include "gfs2.h"
  #include "incore.h"

--Signature=_Wed__27_Jan_2010_11_17_08_+1100_7lWEqtcz2vC1a57G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktfhgQACgkQjjKRsyhoI8x74wCfV+SRxdmXTFMdLnNa2SxPmpLE
lpkAn3XTC4Vi6XXX/NhQap5F+2aOHD67
=KBMt
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Jan_2010_11_17_08_+1100_7lWEqtcz2vC1a57G--
