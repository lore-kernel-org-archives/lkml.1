Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZEZVOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZEZVOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZEZVOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:14:30 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:51765 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZEZVO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:14:29 -0400
Subject: [GIT PULL] drm-intel fixes for 2.6.30-rc6
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6ZgrkFJrA4B1XB2udmJC"
Date: Tue, 26 May 2009 14:14:24 -0700
Message-Id: <1243372464.8400.19.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6ZgrkFJrA4B1XB2udmJC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The following changes since commit 1406de8e11eb043681297adf86d6892ff8efc27a=
:
  Linus Torvalds (1):
        Linux 2.6.30-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Mostly a bunch of KMS fixes to get more hardware working, and most of it
is right out of the 2D driver.  The notable change is the vmalloc fix,
which gets firefox working with big panorama photos (along with some
userland fixes).

Jesse Barnes (2):
      drm/i915: allocate large pointer arrays with vmalloc
      i915: support 8xx desktop cursors

Jonas Bonn (1):
      drm/i915: Determine type before initialising connector

Ma Ling (4):
      drm/i915: Fetch SDVO LVDS mode lines from VBT, then reserve them
      drm/i915: Return SDVO LVDS VBT mode if no EDID modes are detected.
      drm/i915: Use an I2C algo to do the flip to SDVO DDC bus.
      drm/i915: Add support for VGA load detection (pre-945).

 drivers/gpu/drm/i915/i915_drv.h      |    3 +-
 drivers/gpu/drm/i915/i915_gem.c      |   42 ++++------
 drivers/gpu/drm/i915/i915_reg.h      |   17 ++++
 drivers/gpu/drm/i915/intel_bios.c    |  102 ++++++++++++++++-------
 drivers/gpu/drm/i915/intel_bios.h    |   17 ++++
 drivers/gpu/drm/i915/intel_crt.c     |  149 ++++++++++++++++++++++++++++++=
+++-
 drivers/gpu/drm/i915/intel_display.c |   26 +++++--
 drivers/gpu/drm/i915/intel_lvds.c    |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c    |  137 ++++++++++++++++++++++++++----=
-
 include/drm/drmP.h                   |   24 ++++++
 10 files changed, 432 insertions(+), 89 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-6ZgrkFJrA4B1XB2udmJC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkocW7AACgkQHUdvYGzw6verdACeMz5nH2M8c3sPwidXSGaqFuib
CDsAn2meJ2Xw0DV8yM40DOQ0qFarSdAN
=VjIw
-----END PGP SIGNATURE-----

--=-6ZgrkFJrA4B1XB2udmJC--

