Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZDQUuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZDQUuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZDQUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:50:05 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:41286 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZDQUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:50:04 -0400
Subject: [git pull] Fixes to 2.6.30rc2
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SjF7FpXUiSy2IsTNz5HZ"
Date: Fri, 17 Apr 2009 13:49:59 -0700
Message-Id: <1240001399.11172.121.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SjF7FpXUiSy2IsTNz5HZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The following changes since commit cd97824994042b809493807ea644ba26c0c23290=
:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

A few miscellaneous fixes.  The 965 tiling one fixes breakage exposed by
the current 2D driver when we fixed performance for 2D rendering on KMS
(factor of 3 win).

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

 drivers/acpi/video.c                   |    3 ++-
 drivers/gpu/drm/i915/i915_dma.c        |    2 +-
 drivers/gpu/drm/i915/i915_drv.c        |    2 +-
 drivers/gpu/drm/i915/i915_drv.h        |    4 ++--
 drivers/gpu/drm/i915/i915_gem_tiling.c |    1 -
 drivers/gpu/drm/i915/i915_irq.c        |    2 +-
 drivers/gpu/drm/i915/i915_opregion.c   |   15 ++++++++++-----
 drivers/gpu/drm/i915/i915_reg.h        |    1 +
 drivers/gpu/drm/i915/intel_display.c   |    9 +++++++++
 include/acpi/video.h                   |    2 ++
 10 files changed, 29 insertions(+), 12 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-SjF7FpXUiSy2IsTNz5HZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkno63YACgkQHUdvYGzw6veyCgCfQllFwihuCo2X5A7KwI6Apjzp
QrgAoI0yBqZOgtPYaln2SyDCezv2H0Ry
=tC+b
-----END PGP SIGNATURE-----

--=-SjF7FpXUiSy2IsTNz5HZ--

