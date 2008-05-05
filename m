Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYEEApt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYEEApt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 20:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYEEApk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 20:45:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44729 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYEEApj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 20:45:39 -0400
Date: Mon, 5 May 2008 10:45:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       v4l-dvb-maintainer@linuxtv.org
Subject: linux-next: v4l-dvb/upstream build failure
Message-Id: <20080505104531.c1a57e29.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_May_2008_10_45_31_+1000_lbsnJwhr5YI_mhWh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2008_10_45_31_+1000_lbsnJwhr5YI_mhWh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's (and for a few days now) linux-next build (x86_64 allmodconfig)
of a pristine Linus tree fails like this:

/opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-un=
known-linux-gnu-ld: drivers/media/built-in.o: No such file: No such file or=
 director

I have been applying the following patch, but would prefer a real fix in
upstream ASAP.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

>From 88ecd1aa3e79b4d220d27a3380776aba3d3d097a Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 1 May 2008 12:01:40 +1000
Subject: [PATCH] v4l build fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 73f742c..cc11c4c 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
=20
+obj-y :=3D common/
+
 obj-$(CONFIG_VIDEO_MEDIA) +=3D common/
=20
 # Since hybrid devices are here, should be compiled if DVB and/or V4L
--=20
1.5.5.1

--Signature=_Mon__5_May_2008_10_45_31_+1000_lbsnJwhr5YI_mhWh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHliwTgG2atn1QN8RAi7RAJ9KMClvTTmt5kdmtpUi+JlwmTj49QCeI70r
hhSro4A4Ru+JbvCE7RxTdzQ=
=R8Vl
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2008_10_45_31_+1000_lbsnJwhr5YI_mhWh--
