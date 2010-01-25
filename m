Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296Ab0AYEFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0AYEFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 23:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892Ab0AYEFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 23:05:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34484 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab0AYEFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 23:05:07 -0500
Date: Mon, 25 Jan 2010 15:04:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: vfs/fsnotify trees build warning
Message-Id: <20100125150456.c796f0b0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Jan_2010_15_04_56_+1100_fC/hMM.XJaQnSYTn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jan_2010_15_04_56_+1100_fC/hMM.XJaQnSYTn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric, Al,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

In file included from include/linux/security.h:26,
                 from fs/xfs/linux-2.6/xfs_iops.c:56:
include/linux/fsnotify.h: In function 'fsnotify_move':
include/linux/fsnotify.h:87: warning: pointer targets in initialization dif=
fer in signedness
include/linux/fsnotify.h: In function 'fsnotify_create':
include/linux/fsnotify.h:154: warning: pointer targets in passing argument =
5 of 'fsnotify' differ in signedness
include/linux/fsnotify_backend.h:300: note: expected 'const char *' but arg=
ument is of type 'const unsigned char *'
include/linux/fsnotify.h: In function 'fsnotify_link':
include/linux/fsnotify.h:167: warning: pointer targets in passing argument =
5 of 'fsnotify' differ in signedness
include/linux/fsnotify_backend.h:300: note: expected 'const char *' but arg=
ument is of type 'const unsigned char *'
include/linux/fsnotify.h: In function 'fsnotify_mkdir':
include/linux/fsnotify.h:180: warning: pointer targets in passing argument =
5 of 'fsnotify' differ in signedness
include/linux/fsnotify_backend.h:300: note: expected 'const char *' but arg=
ument is of type 'const unsigned char *'

I am not sure why these started turning up (they were there on Friday as
well and I may have missed them earlier).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Jan_2010_15_04_56_+1100_fC/hMM.XJaQnSYTn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktdGGgACgkQjjKRsyhoI8xCBgCdHF10qPWzTT4cviUkIasUsODJ
dr4AniM0nMyZAjWEtEfxCzkXSmpl0XGb
=Gbug
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jan_2010_15_04_56_+1100_fC/hMM.XJaQnSYTn--
