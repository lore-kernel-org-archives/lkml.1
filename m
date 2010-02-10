Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0BJBdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:33:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45819 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab0BJBdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:33:49 -0500
Date: Wed, 10 Feb 2010 12:33:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Smart <james.smart@emulex.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20100210123337.7a715aa0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Feb_2010_12_33_37_+1100_puv4N.cnF43vaFSl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Feb_2010_12_33_37_+1100_puv4N.cnF43vaFSl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/lpfc/lpfc_bsg.c: In function 'lpfc_bsg_diag_mode':
drivers/scsi/lpfc/lpfc_bsg.c:1496: error: implicit declaration of function =
'msleep'

Caused by commit 3b5dd52aaffd291edea9f939ed46a960b240bb45 ("[SCSI] lpfc
8.3.8: (BSG4) Add new vendor specific BSG Commands").

Missing include of linux/delay.h?

I have used the version of the scsi tree from next-20100209 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Feb_2010_12_33_37_+1100_puv4N.cnF43vaFSl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktyDPEACgkQjjKRsyhoI8wi+ACeJvZyqnMAJ2sFwAcc92bFkmj0
4yoAnj6d8UF/FWA40bcg97i71N9IkP8A
=/1E1
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Feb_2010_12_33_37_+1100_puv4N.cnF43vaFSl--
