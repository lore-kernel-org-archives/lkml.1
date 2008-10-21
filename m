Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYJUIaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYJUIaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYJUIa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:30:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43191 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYJUIa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:30:27 -0400
Date: Tue, 21 Oct 2008 19:30:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: tree build failure
Message-Id: <20081021193013.4ccbf02f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Oct_2008_19_30_13_+1100_PsjEatYOTO8Z0aq="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Oct_2008_19_30_13_+1100_PsjEatYOTO8Z0aq=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next build (i386 defconfig) failed like this:

drivers/gpu/drm/i915/i915_gem.c: In function 'fast_user_write':
drivers/gpu/drm/i915/i915_gem.c:196: error: 'o' undeclared (first use in th=
is function)

Caused by commit 9b7530cc329eb036cfa589930c270e85031f554c ("i915: cleanup
coding horrors in i915_gem_gtt_pwrite()").

I have applied Thomas' fix since today' linux-next base precedes the fix
being added.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Oct_2008_19_30_13_+1100_PsjEatYOTO8Z0aq=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj9kxUACgkQjjKRsyhoI8y3OACdEs7IKhj0iWBz6lP1grTccXm7
QDIAn2QcDdiYZCBILjLVm+Ytt+DQe2r9
=xKHC
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Oct_2008_19_30_13_+1100_PsjEatYOTO8Z0aq=--
