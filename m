Return-Path: <linux-kernel-owner+w=401wt.eu-S1763579AbZE1Svx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763579AbZE1Svx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbZE1Svq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:51:46 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:48668 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbZE1Svp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:51:45 -0400
Subject: [GIT PULL] drm-intel fixes for 2.6.30-rc7
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JbgR4b+5K9HW0rKLZlFA"
Date: Thu, 28 May 2009 11:50:13 -0700
Message-Id: <1243536613.4976.2.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JbgR4b+5K9HW0rKLZlFA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit cd86a536c81e9300d984327517548ca0652eebf9=
:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/=
linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

Volume of fixes is down, but importance is way up.  Fixes 3D rendering
correctness, stability, and performance on 8xx machines.  Fixes 2D and
3D rendering and stability on 865.  Fixes rendering and stability on all
hardware in the presence of swapping.

Eric Anholt (2):
      drm/i915: Fix tiling pitch handling on 8xx.
      drm/i915: Apply a big hammer to 865 GEM object CPU cache flushing.

Kristian H=C3=B8gsberg (1):
      i915: Set object to gtt domain when faulting it back in

 drivers/gpu/drm/i915/i915_gem.c        |   23 +++++++++++++++++++++--
 drivers/gpu/drm/i915/i915_gem_tiling.c |   14 +++++++++++---
 drivers/gpu/drm/i915/i915_reg.h        |    3 ++-
 3 files changed, 34 insertions(+), 6 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-JbgR4b+5K9HW0rKLZlFA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoe3OIACgkQHUdvYGzw6vclWACfY6P++snSk9MqaEP0fwoAc/yx
KokAnjNBsPYhyi07aLyDar4tsgclPp6J
=7dUx
-----END PGP SIGNATURE-----

--=-JbgR4b+5K9HW0rKLZlFA--

