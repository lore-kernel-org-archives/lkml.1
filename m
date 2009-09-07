Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZIGGcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZIGGcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbZIGGcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:32:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48757 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758954AbZIGGcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:32:12 -0400
Date: Mon, 7 Sep 2009 16:32:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, wanzongshun <mcuos.com@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the trivial tree with the arm tree
Message-Id: <20090907163201.72adc3f6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Sep_2009_16_32_01_+1000_pXQU15ByGm6Nutls"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Sep_2009_16_32_01_+1000_pXQU15ByGm6Nutls
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/mach-w90x900/w90p910.c between commit
35c9221acb133ecc9abd701a1fb6fa909d177a77 ("ARM: 5682/1: Add cpu.c and
dev.c and modify some files of w90p910 platform") from the arm tree and
commit 6f8fadf4a5c43f9f10f1910c71d8d9ff0b0a26ca ("trivial: remove
unnecessary semicolons") from the trivial tree.

The former commit moved the code changed by the latter into a different
file (arch/arm/mach-w90x900/cpu.c - and removed the old file).  Its not
important enough to fix it there (so I just removed this file), but maybe
the part of the trivial commit touching this file could be sent to the
arm maintainer.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_Sep_2009_16_32_01_+1000_pXQU15ByGm6Nutls
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqkqOEACgkQjjKRsyhoI8wxDgCgmn1hE4eI6mZtr1fYoxKWtuDr
IpoAnRoOAiDZOh2DFRIdUYt4aI1nGQmu
=Yg8N
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Sep_2009_16_32_01_+1000_pXQU15ByGm6Nutls--
