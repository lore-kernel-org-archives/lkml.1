Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZFCCPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZFCCPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZFCCPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:15:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41921 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZFCCPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:15:22 -0400
Date: Wed, 3 Jun 2009 12:15:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: linux-next: manual merge of the wireless tree with the x86 tree
Message-Id: <20090603121515.4bd45eec.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Jun_2009_12_15_15_+1000_p1uBGdfDLF48tsnB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jun_2009_12_15_15_+1000_p1uBGdfDLF48tsnB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
Documentation/feature-removal-schedule.txt between commit
45f458e9a8a216b02b76fe61d9e8bc40d659fbe8 ("x86, mce: deprecate old 32bit
machine check code") from the x86 tree and commit
0122405503e36bd15077acb571821d459bbd3e85 ("rfkill: create useful
userspace interface") from the wireless tree.

Juts overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/feature-removal-schedule.txt
index ec9ef5d,edb2f0b..0000000
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@@ -438,12 -438,9 +438,19 @@@ Why:	Superseded by tdfxfb. I2C/DDC supp
  Who:	Jean Delvare <khali@linux-fr.org>
  	Krzysztof Helt <krzysztof.h1@wp.pl>
 =20
 +----------------------------
 +
 +What:	CONFIG_X86_OLD_MCE
 +When:	2.6.32
 +Why:	Remove the old legacy 32bit machine check code. This has been
 +	superseded by the newer machine check code from the 64bit port,
 +	but the old version has been kept around for easier testing. Note this
 +	doesn't impact the old P5 and WinChip machine check handlers.
 +Who:	Andi Kleen <andi@firstfloor.org>
++
+ ---------------------------
+=20
+ What:	CONFIG_RFKILL_INPUT
+ When:	2.6.33
+ Why:	Should be implemented in userspace, policy daemon.
+ Who:	Johannes Berg <johannes@sipsolutions.net>

--Signature=_Wed__3_Jun_2009_12_15_15_+1000_p1uBGdfDLF48tsnB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkol3LMACgkQjjKRsyhoI8w6uACeNacK08u+c9i4p5iFr2knq82Z
BS0AoKr4XTVkNeG8sQn0JIWuQTfHpe1c
=53I5
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jun_2009_12_15_15_+1000_p1uBGdfDLF48tsnB--
