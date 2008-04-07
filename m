Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYDGA1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYDGA1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 20:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYDGA1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 20:27:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46967 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbYDGA1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 20:27:31 -0400
Date: Mon, 7 Apr 2008 10:27:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-next@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: origin build failure
Message-Id: <20080407102716.2e2d3c7a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Apr_2008_10_27_16_+1000_wLyXloWI18ZOzD92"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Apr_2008_10_27_16_+1000_wLyXloWI18ZOzD92
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (Linus' tree only, powerpc ppc64_defconfig)
fails like this:

drivers/media/video/pvrusb2/pvrusb2-devattr.c:178: error: unknown field 'fl=
ag_has_analogtuner' specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:179: error: unknown field 'fl=
ag_has_composite' specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:180: error: unknown field 'fl=
ag_has_svideo' specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error: unknown field 'di=
gital_control_scheme' specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:182: error: 'PVR2_DIGITAL_SCH=
EME_HAUPPAUGE' undeclared here (not in a function)
drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error: unknown field 'le=
d_scheme' specified in initializer
drivers/media/video/pvrusb2/pvrusb2-devattr.c:183: error: 'PVR2_LED_SCHEME_=
HAUPPAUGE' undeclared here (not in a function)

Introduced by commit 92c9d07507f0a90b64172bfede7e6fa845e8e66b ("V4L/DVB
(7497): pvrusb2: add new usb pid for 73xxx models").  I have reverted
that commit for today's linux-next tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Apr_2008_10_27_16_+1000_wLyXloWI18ZOzD92
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH+WpoTgG2atn1QN8RApbPAJ9qe7hEvMPZd7xiPU/VbyO1BuYGIQCfSzS1
oMH7SQYbfHHnreuR1SqQKGo=
=ImiU
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Apr_2008_10_27_16_+1000_wLyXloWI18ZOzD92--
