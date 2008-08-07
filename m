Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYHGOeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYHGOeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYHGOeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:34:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43151 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbYHGOd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:33:59 -0400
Date: Fri, 8 Aug 2008 00:33:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: s3c2410_wdt build failure
Message-Id: <20080808003350.3c1671d8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Aug_2008_00_33_50_+1000_HFon7Jx3asHijvN0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Aug_2008_00_33_50_+1000_HFon7Jx3asHijvN0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

>From an arm s3c2410_defconfig build of today's linux-next (there are no
commits affecting this file that are not in Linus' tree):

drivers/watchdog/s3c2410_wdt.c:130: error: redefinition of '__s3c2410wdt_st=
op'
drivers/watchdog/s3c2410_wdt.c:119: error: previous definition of '__s3c241=
0wdt_stop' was here

Something appears to have gone wrong with commit
41dc8b72e37c514f7332cbc3f3dd864910c2a1fa ("s3c2410_wdt watchdog driver:
Locking and coding style") and we ended up with two versions of
__s3c2410wdt_stop.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Aug_2008_00_33_50_+1000_HFon7Jx3asHijvN0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkibB84ACgkQjjKRsyhoI8yaTgCfVfpBnq65GoeM2ou/FsA0YeCC
4NsAoItM+oM20GLayoTUneugPMcenUwz
=Qo//
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Aug_2008_00_33_50_+1000_HFon7Jx3asHijvN0--
