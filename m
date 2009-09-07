Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbZIGDAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbZIGDAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbZIGDAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:00:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZIGDAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:00:34 -0400
Date: Mon, 7 Sep 2009 13:00:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Robert Love <robert.w.love@intel.com>
Subject: linux-next: scsi tree build warnings
Message-Id: <20090907130024.d67c032d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Sep_2009_13_00_24_+1000_=CTRovQU6tJUWo/C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Sep_2009_13_00_24_+1000_=CTRovQU6tJUWo/C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

usr/include/scsi/fc/fc_els.h:165: found __[us]{8,16,32,64} type without #in=
clude <linux/types.h>
usr/include/scsi/fc/fc_fs.h:32: found __[us]{8,16,32,64} type without #incl=
ude <linux/types.h>
usr/include/scsi/fc/fc_gs.h:29: found __[us]{8,16,32,64} type without #incl=
ude <linux/types.h>
usr/include/scsi/fc/fc_ns.h:71: found __[us]{8,16,32,64} type without #incl=
ude <linux/types.h>

Introduced by commit 171bb4f9f6a20d405a3cb5111ce92ad83aae2302 ("[SCSI]
libfc: Export FC headers").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Sep_2009_13_00_24_+1000_=CTRovQU6tJUWo/C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqkd0gACgkQjjKRsyhoI8xdTQCgmn5p2bILNPvJHq+/hdByqcdh
VYkAni1niZBynwgNcM/CMV46s4yHmn0/
=YuWS
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Sep_2009_13_00_24_+1000_=CTRovQU6tJUWo/C--
