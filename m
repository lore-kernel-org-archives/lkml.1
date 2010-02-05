Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0BFMfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 07:35:06 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:53720 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0BFMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 07:35:04 -0500
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes for 2.6.33rc6
Date: Fri, 05 Feb 2010 16:58:33 +0100
Message-ID: <877hqr3c9i.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
  Linus Torvalds (1):
        Linux 2.6.33-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Chris Wilson (2):
      drm/i915: Prevent use of uninitialized pointers along error path.
      drm/i915: Fix leak of relocs along do_execbuffer error path

David John (1):
      drm/i915: Disable SR when more than one pipe is enabled

Jesse Barnes (2):
      drm/i915: handle non-flip pending case when unpinning the scanout buffer
      drm/i915: page flip support for Ironlake

Li Peng (3):
      drm/i915: enable vblank interrupt on ironlake
      drm/i915: Fix the device info of Pineview
      drm/i915: don't trigger ironlake vblank interrupt at irq install

Thomas Meyer (1):
      drm/i915: slow acpi_lid_open() causes flickering - V2

Zhao Yakui (2):
      drm/i915: Add support for SDVO composite TV
      drm/i915: Fix the incorrect DMI string for Samsung SX20S laptop

Zhenyu Wang (1):
      drm/i915: disable hotplug detect before Ironlake CRT detect

 drivers/gpu/drm/i915/i915_drv.c      |    2 +-
 drivers/gpu/drm/i915/i915_gem.c      |   11 +++++++-
 drivers/gpu/drm/i915/i915_irq.c      |   42 ++++++++++++++++++++++++---------
 drivers/gpu/drm/i915/intel_crt.c     |    3 ++
 drivers/gpu/drm/i915/intel_display.c |   33 +++++++++++++++++++++++++-
 drivers/gpu/drm/i915/intel_lvds.c    |   11 +++++++-
 drivers/gpu/drm/i915/intel_sdvo.c    |    8 ++++++
 7 files changed, 91 insertions(+), 19 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktsQCkACgkQHUdvYGzw6vcWaQCcD3mD6Ly1LkQDCniy+jc1vuJ3
q2sAnRUHRIIqc65O07LIuuyUKR8l4Ezc
=2kIz
-----END PGP SIGNATURE-----
--=-=-=--
