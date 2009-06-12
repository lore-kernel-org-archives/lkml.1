Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZFLBq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZFLBq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZFLBqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:46:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58897 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZFLBqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:46:48 -0400
Date: Fri, 12 Jun 2009 11:46:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: linux-next: xfs tree build warnings
Message-Id: <20090612114641.f93edc8b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_11_46_41_+1000_1VAQyhksXy/CdxBo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_11_46_41_+1000_1VAQyhksXy/CdxBo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) produced these warnings:

fs/xfs/xfs_vnodeops.c: In function 'xfs_create':
fs/xfs/xfs_vnodeops.c:1418: warning: unused variable 'gdqp'
fs/xfs/xfs_vnodeops.c:1417: warning: unused variable 'udqp'
fs/xfs/linux-2.6/xfs_ioctl.c: In function 'xfs_ioctl_setattr':
fs/xfs/linux-2.6/xfs_ioctl.c:902: warning: unused variable 'gdqp'
fs/xfs/linux-2.6/xfs_ioctl.c:901: warning: unused variable 'udqp'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_11_46_41_+1000_1VAQyhksXy/CdxBo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoxs4EACgkQjjKRsyhoI8yvCwCgwGKGTRrK6FkU4zxz7Dm6SJ59
vNcAnja5ry8RwzhhssF+FvpiR5QOmh+1
=1Nfu
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_11_46_41_+1000_1VAQyhksXy/CdxBo--
