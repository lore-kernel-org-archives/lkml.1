Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbZEVBMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbZEVBMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 21:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZEVBL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 21:11:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55818 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZEVBL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 21:11:58 -0400
Date: Fri, 22 May 2009 11:11:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       Jan Blunck <jblunck@suse.de>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: powerpc tree build warning
Message-Id: <20090522111153.38f7bd1c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_May_2009_11_11_53_+1000_Y5oFJdEdanpQ4eJM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_May_2009_11_11_53_+1000_Y5oFJdEdanpQ4eJM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

arch/powerpc/platforms/cell/spufs/inode.c: In function 'spufs_create':
arch/powerpc/platforms/cell/spufs/inode.c:647: warning: label 'out_dput' de=
fined but not used

Introduced by commit 45db9240890d9343c934db1fe82d6e68ac2d28da
("powerpc/spufs: Remove double check for non-negative dentry").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_May_2009_11_11_53_+1000_Y5oFJdEdanpQ4eJM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoV+9kACgkQjjKRsyhoI8zQcgCeNsNTRVqIIK8BH6uYTvfNIHNM
AhMAnip/giJgZvtsxLi8m+nT9dEqM6d0
=l1V7
-----END PGP SIGNATURE-----

--Signature=_Fri__22_May_2009_11_11_53_+1000_Y5oFJdEdanpQ4eJM--
