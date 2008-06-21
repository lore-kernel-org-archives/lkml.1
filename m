Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYFUCkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYFUCkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 22:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYFUCk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 22:40:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44507 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbYFUCkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 22:40:25 -0400
Date: Sat, 21 Jun 2008 12:40:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-staging/linux-next merge/build errors
Message-Id: <20080621124017.ec3b0a51.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__21_Jun_2008_12_40_17_+1000_XsH=e2o6HXxQxLqi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__21_Jun_2008_12_40_17_+1000_XsH=e2o6HXxQxLqi
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today I have done a test merge of linux-staging into linux-next.  I got
merge conflicts in drivers/char/agp/via-agp.c and drivers/misc/Makefile -
neither of which is really surprising and both tivial to fix up.

I then did an x86 allmodconfig build with these errors:

In file included from /home/sfr/kernels/next/src/drivers/char/drm/via_chrom=
e9_drm.c:32:
/home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h: In functi=
on =E2=80=98IS_AGPHEADER_INV=E2=80=99:
/home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:230: error=
: =E2=80=98TRUE=E2=80=99 undeclared (first use in this function)
/home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:230: error=
: (Each undeclared identifier is reported only once
/home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:230: error=
: for each function it appears in.)
/home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:232: error=
: =E2=80=98FALSE=E2=80=99 undeclared (first use in this function)

And several new warnings (these may not be all):

/home/sfr/kernels/next/src/fs/novfs/inode.c:265: warning: initialization fr=
om incompatible pointer type
/home/sfr/kernels/next/src/fs/novfs/inode.c:267: warning: initialization fr=
om incompatible pointer type
/home/sfr/kernels/next/src/fs/novfs/inode.c:273: warning: initialization fr=
om incompatible pointer type
/home/sfr/kernels/next/src/fs/novfs/inode.c:275: warning: initialization fr=
om incompatible pointer type
In file included from /home/sfr/kernels/next/src/fs/novfs/daemon.c:24:
include2/asm/semaphore.h:1:2: warning: #warning Use linux/semaphore.h, not =
asm/semaphore.h
In file included from /home/sfr/kernels/next/src/fs/novfs/scope.c:26:
include2/asm/semaphore.h:1:2: warning: #warning Use linux/semaphore.h, not =
asm/semaphore.h
In file included from /home/sfr/kernels/next/src/fs/novfs/nwcapi.c:22:
include2/asm/semaphore.h:1:2: warning: #warning Use linux/semaphore.h, not =
asm/semaphore.h

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__21_Jun_2008_12_40_17_+1000_XsH=e2o6HXxQxLqi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhcahEACgkQTgG2atn1QN9/AgCgmLNW2f9da/od/AGA1ddFRUsW
TpAAmwTRC7F0k2awqF7P+6xiCL+ygEmn
=ABTV
-----END PGP SIGNATURE-----

--Signature=_Sat__21_Jun_2008_12_40_17_+1000_XsH=e2o6HXxQxLqi--
