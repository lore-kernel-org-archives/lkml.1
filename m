Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0BLRNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:13:50 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:45819 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab0BLRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:13:49 -0500
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes for 2.6.33-rc7
Date: Fri, 12 Feb 2010 09:14:12 -0800
Message-ID: <87hbpmjs0r.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

The following changes since commit e28cab42f384745c8a947a9ccd51e4aae52f5d51:
  Linus Torvalds (1):
        Merge branch 'i2c-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

These are all regression fixes.

Chris Wilson (1):
      drm/i915: Increase fb alignment to 64k

Daniel Vetter (1):
      drm/i915: Update write_domains on active list after flush.

Jesse Barnes (3):
      drm/i915: handle FBC and self-refresh better
      drm/i915: untangle page flip completion
      drm/i915: hold ref on flip object until it completes

Owain Ainsworth (1):
      drm/i915: Correctly return -ENOMEM on allocation failure in cmdbuf ioctls.

Rafael J. Wysocki (1):
      drm/i915: Fix crash while aborting hibernation

Zhenyu Wang (3):
      drm/i915: Rework DPLL calculation parameters for Ironlake
      drm/i915: fix flip done interrupt on Ironlake
      drm/i915: fix pipe source image setting in flip command

 drivers/gpu/drm/i915/i915_dma.c      |    4 +-
 drivers/gpu/drm/i915/i915_drv.c      |  168 ++++++++++++++---------
 drivers/gpu/drm/i915/i915_drv.h      |   11 ++
 drivers/gpu/drm/i915/i915_gem.c      |   27 +++-
 drivers/gpu/drm/i915/i915_irq.c      |   16 +-
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |  245 +++++++++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_fb.c      |    2 +-
 8 files changed, 332 insertions(+), 142 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt1jGQACgkQHUdvYGzw6vc1eQCfUK7bwdZRpBfYVbZpvKYbsdMY
nvUAoIvomJKnGXXX3B2GxeUyb025e+ry
=nHyZ
-----END PGP SIGNATURE-----
--=-=-=--
