Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYLENtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYLENtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYLENtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:49:36 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3707 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYLENtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:49:35 -0500
Message-ID: <49393160.20606@imap.cc>
Date: Fri, 05 Dec 2008 14:49:20 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.18) Gecko/20081031 SeaMonkey/1.1.13 Mnenhy/0.7.6.0
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use vprintk rather that vsnprintf where possible
References: <1228423309.3255.109.camel@calx>
In-Reply-To: <1228423309.3255.109.camel@calx>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFFEBE2B934329A285B9CFE57"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFFEBE2B934329A285B9CFE57
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

A diffstat would have been nice, so that a small driver maintainer
like me can quickly check whether s/he should have a closer look:

 drivers/cpufreq/cpufreq.c    |   11 +--------
 drivers/scsi/arm/fas216.c    |    6 +----
 drivers/scsi/nsp32.c         |   29 ++++++++++--------------
 drivers/scsi/pcmcia/nsp_cs.c |   28 ++++++++++--------------
 fs/adfs/super.c              |   12 ++++------
 fs/affs/amigaffs.c           |   22 +++++++-----------
 fs/befs/debug.c              |   47 +++++++-----------------------------=
----
 fs/hpfs/super.c              |    7 +-----
 fs/jfs/super.c               |    7 ++----
 fs/ntfs/debug.c              |   50 +++++++++++++++++-------------------=
-------
 fs/ocfs2/super.c             |   22 ++++++++----------
 fs/partitions/ldm.c          |    7 ++----
 fs/udf/super.c               |   16 ++++++-------
 fs/ufs/super.c               |   46 +++++++++++++++++++-----------------=
---
 fs/xfs/support/debug.c       |   28 ++++++------------------
 15 files changed, 127 insertions(+), 211 deletions(-)

shows at a glance who's affected by this.

Also, I'm a big fan of diff's -p option.

Thanks,

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigFFEBE2B934329A285B9CFE57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJOTFhQ3+did9BuFsRArPPAKCJoeonIIKwvl7FfuIR6PaK2M5v4wCfaJwM
E3qKF411lGLA5A/VhbBNLDc=
=khuj
-----END PGP SIGNATURE-----

--------------enigFFEBE2B934329A285B9CFE57--
