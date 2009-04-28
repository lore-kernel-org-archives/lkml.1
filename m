Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbZD1XtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbZD1XtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZD1Xs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:48:56 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:55175 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZD1Xsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:48:54 -0400
Subject: [git pull] Intel DRM fixes for 2.6.30-rc3
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UrKZUBDKBNlVvhJIzdcL"
Date: Tue, 28 Apr 2009 16:48:53 -0700
Message-Id: <1240962533.12272.32.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UrKZUBDKBNlVvhJIzdcL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The following changes since commit cd97824994042b809493807ea644ba26c0c23290=
:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

This is mostly a resend of the last pull request that didn't make it in,
featuring a critical KMS fix.  In the meantime one of the patches made
it in through a different tree, and G41 support (PCI ID addition) has
been added along with a couple of error path fixups.

Chris Wright (1):
      drm/i915: fix up error path leak in i915_cmdbuffer

Eric Anholt (1):
      drm/i915: Don't let an oops get triggered from irq_emit without dma i=
nit.

Jesse Barnes (1):
      drm/i915: allow tiled front buffers on 965+

Keith Packard (1):
      drm/i915: fix transition to I915_TILING_NONE

Matthew Garrett (3):
      drm/i915: Register ACPI video even when not modesetting
      drm/i915: Unregister ACPI video driver when exiting
      drm/i915: Enable ASLE if present

Wu Fengguang (1):
      drm/i915: fix unpaired i915 device mutex on entervt failure.

Zhenyu Wang (1):
      drm/i915: add support for G41 chipset

 drivers/acpi/video.c                   |    3 ++-
 drivers/gpu/drm/i915/i915_dma.c        |    8 ++++----
 drivers/gpu/drm/i915/i915_drv.c        |    2 +-
 drivers/gpu/drm/i915/i915_drv.h        |    8 +++++---
 drivers/gpu/drm/i915/i915_gem.c        |    4 +++-
 drivers/gpu/drm/i915/i915_gem_tiling.c |    1 -
 drivers/gpu/drm/i915/i915_irq.c        |    2 +-
 drivers/gpu/drm/i915/i915_opregion.c   |   15 ++++++++++-----
 drivers/gpu/drm/i915/i915_reg.h        |    1 +
 drivers/gpu/drm/i915/intel_display.c   |    9 +++++++++
 include/acpi/video.h                   |    2 ++
 include/drm/drm_pciids.h               |    1 +
 12 files changed, 39 insertions(+), 17 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-UrKZUBDKBNlVvhJIzdcL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn3leUACgkQHUdvYGzw6vcGwwCaA1IIiZLWS7o2pRaYBr0CoC6Q
JPQAoJYAsOHrlp4qnBD5pf6HpqWFjgb4
=Fg5/
-----END PGP SIGNATURE-----

--=-UrKZUBDKBNlVvhJIzdcL--

