Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbZG3GAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbZG3GAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 02:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZG3GAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 02:00:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49085 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbZG3GAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 02:00:18 -0400
Date: Thu, 30 Jul 2009 16:00:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: kmemleak tree build failure
Message-Id: <20090730160012.5814e251.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jul_2009_16_00_12_+1000_rNIFNMyaApnbNZFD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jul_2009_16_00_12_+1000_rNIFNMyaApnbNZFD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Today's linux-next build (x86_64 allmodconfig) failed like this:

arch/x86/kernel/process.c: In function 'free_thread_info':
arch/x86/kernel/process.c:58: error: implicit declaration of function 'kmem=
leak_free'

Caused by commit 3d898087320a732ec853c98f244253892616840f ("kmemleak:
Inform kmemleak about kernel stack allocation") from the kmemleak tree.
Probably a missing include of linux/kmemleak.h.

I have dropped the kmemleak tree for today.  (It accidentally did not
get included yesterday.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jul_2009_16_00_12_+1000_rNIFNMyaApnbNZFD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpxNuwACgkQjjKRsyhoI8wG+gCgh8FppJqsXDkcIW5v7sgmDbd7
NWoAn0NSjbfxL6c7wvCtFDoQKMdM5bNL
=unLw
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jul_2009_16_00_12_+1000_rNIFNMyaApnbNZFD--
