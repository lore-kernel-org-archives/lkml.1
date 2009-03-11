Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZCKS3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZCKS3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZCKS3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:29:40 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:46846 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZCKS3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:29:39 -0400
Subject: [GIT PULL] drm-intel pull request for 2.6.29-rc7
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W0xCWllzdZJhzXR1S8nr"
Date: Wed, 11 Mar 2009 11:29:35 -0700
Message-Id: <1236796175.9354.28.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W0xCWllzdZJhzXR1S8nr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You suggested at OSTS that I send pull requests to you directly, so here
goes.  Hopefully I'm doing it right (in particular, I'm not rebasing to
the very latest since you suggested you didn't want to see that having
happened just before the pull request, and I checked that nothing
conflicting has happened since the rebase).

There's a bunch of fencing fixes in here, which helps 915 and 945 3D
(especially 945 with my fix).  The fencing code could still use some
more love, but I know Chris Wilson's been exercising this fencing code
more than the actual released drivers do by a significant margin, and
the fixes do look good.  There's also the resume fix that we tested a
variant of at OSTS.

The following changes since commit 16b71fdf97599f1b1b7f38418ee9922d9f117396=
:
  Samuel CUELLA (1):
        i810: fix kernel crash fix when struct fb_var_screeninfo is supplie=
d

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Chris Wilson (4):
      drm/i915: First recheck for an empty fence register.
      drm/i915: Check fence status on every pin.
      drm/i915: Check to see if we've pinned all available fences
      drm/i915: Protect active fences on i915

Eric Anholt (2):
      drm/i915: Fix bad \n in MTRR failure notice.
      drm/i915: fix 945 fence register writes for fence 8 and above.

Kristian H=C3=B8gsberg (1):
      drm: Return EINVAL on duplicate objects in execbuffer object list

Kyle McMartin (1):
      i915: add newline to i915_gem_object_pin failure msg

Pierre Willenbrock (1):
      drm/i915: Don't restore palettes through VGA registers.

 drivers/gpu/drm/i915/i915_dma.c     |    2 +-
 drivers/gpu/drm/i915/i915_drv.h     |    7 ++-
 drivers/gpu/drm/i915/i915_gem.c     |  115 +++++++++++++++++++++++++++----=
---
 drivers/gpu/drm/i915/i915_reg.h     |    1 +
 drivers/gpu/drm/i915/i915_suspend.c |   11 ---
 5 files changed, 99 insertions(+), 37 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-W0xCWllzdZJhzXR1S8nr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm4Aw8ACgkQHUdvYGzw6veVvgCdGTmhg2PF5Fr/IBUk9lA6ja/l
ACYAoIsyFak1PmSR1UcHKoELZNcHbaO4
=pKrH
-----END PGP SIGNATURE-----

--=-W0xCWllzdZJhzXR1S8nr--

