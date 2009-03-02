Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZCBHfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZCBHfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZCBHfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:35:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47815 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZCBHfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:35:21 -0500
Date: Mon, 2 Mar 2009 18:35:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: Linus' tree build warnings
Message-Id: <20090302183511.a1415086.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Mar_2009_18_35_11_+1100_5J2FEI1wTfrFbkjZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Mar_2009_18_35_11_+1100_5J2FEI1wTfrFbkjZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (i386 defconfig) produced these warnings:

In file included from drivers/gpu/drm/i915/i915_drv.h:36,
                 from drivers/gpu/drm/i915/i915_drv.c:35:
include/linux/io-mapping.h: In function 'io_mapping_map_wc':
include/linux/io-mapping.h:95: warning: ISO C90 forbids mixed declarations =
and code

And several more of the same.

Caused by commit 4ab0d47d0ab311eb181532c1ecb6d02905685071 ("gpu/drm, x86, P=
AT: io_mapping_create_wc and resource_size_t") from Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Mar_2009_18_35_11_+1100_5J2FEI1wTfrFbkjZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmrjC8ACgkQjjKRsyhoI8zZAQCeJZEVSAQGEvBNB4Ba0665hnvx
M6gAoLYZWpvSU2FZ8vQ9VQVniaRbdevK
=/mSQ
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Mar_2009_18_35_11_+1100_5J2FEI1wTfrFbkjZ--
