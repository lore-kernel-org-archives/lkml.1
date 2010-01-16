Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0APAX1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319Ab0APAX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:23:26 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:39326 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab0APAXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:23:25 -0500
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes for 2.6.33rc4
Date: Fri, 15 Jan 2010 16:23:40 -0800
Message-ID: <876372x5gz.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

The following changes since commit 2c1f1895ef2aa8f0e5497893eff71304aef332e1:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

More Ironlake fixes, and a few other modesetting bits.

Eric Anholt (1):
      drm/i915: Remove chatty execbuf failure message.

Jesse Barnes (1):
      drm/i915: disable LVDS downclock by default

Rafael J. Wysocki (1):
      drm/i915: Fix resume regression on MSI Wind U100 w/o KMS

Zhao Yakui (7):
      drm/i915: Add HP nx9020/SamsungSX20S to ACPI LID quirk list
      drm/i915: Use find_pll function to calculate DPLL setting for LVDS downclock
      drm/i915: Fix Ironlake M/N/P ranges to match the spec
      drm/i915: Don't use the child device parsed from VBT to setup HDMI/DP
      drm/i915: Read the response after issuing DDC bus switch command
      drm/i915: try another possible DDC bus for the SDVO device with multiple outputs
      drm/i915: Fix the incorrect cursor A bit definition in DSPFW2 register

Zhenyu Wang (6):
      drm/i915: disable TV hotplug status check
      drm/i915: Don't wait interruptible for possible plane buffer flush
      drm/i915: parse eDP panel color depth from VBT block
      drm/i915: fix pixel color depth setting on eDP
      drm/i915: fix eDP pipe mask
      drm/i915: enable 36bit physical address for hardware status page

Zou Nan hai (1):
      drm/i915: remove loop in Ironlake interrupt handler

 drivers/char/agp/intel-agp.c         |    6 ++-
 drivers/gpu/drm/i915/i915_dma.c      |    4 ++
 drivers/gpu/drm/i915/i915_drv.c      |    8 +++
 drivers/gpu/drm/i915/i915_drv.h      |    3 +
 drivers/gpu/drm/i915/i915_gem.c      |   53 ++++++++++++++++++++-
 drivers/gpu/drm/i915/i915_irq.c      |   68 ++++++++++++----------------
 drivers/gpu/drm/i915/i915_reg.h      |    2 +-
 drivers/gpu/drm/i915/intel_bios.c    |   35 ++++++++++++++-
 drivers/gpu/drm/i915/intel_bios.h    |   40 ++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |   84 ++++++++-------------------------
 drivers/gpu/drm/i915/intel_dp.c      |   75 ++++++------------------------
 drivers/gpu/drm/i915/intel_hdmi.c    |   50 --------------------
 drivers/gpu/drm/i915/intel_lvds.c    |   17 ++++++-
 drivers/gpu/drm/i915/intel_sdvo.c    |   83 ++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_tv.c      |    2 -
 15 files changed, 307 insertions(+), 223 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktRBwwACgkQHUdvYGzw6vd0QwCglQk1gcknLJ3+V4DI7cSdjIZE
H60An1MPk9nxFmJ3wLGUBDVRiZ8uofP2
=eGui
-----END PGP SIGNATURE-----
--=-=-=--
