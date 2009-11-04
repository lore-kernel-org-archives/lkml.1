Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZKDEAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZKDEAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZKDEAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:00:05 -0500
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:35583 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZKDEAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:00:04 -0500
Subject: [git pull][resend] drm-intel fixes for 2.6.32-rc5
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6f2f6Z0J3fNSVKOVH1q7"
Date: Tue, 03 Nov 2009 19:54:21 -0800
Message-Id: <1257306861.28287.5.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6f2f6Z0J3fNSVKOVH1q7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit 161291396e76e0832c08f617eb9bd364d1648148=
:
  Linus Torvalds (1):
        Linux 2.6.32-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Here's a set of fixes for the regressions introduced with the
power-saving improvements in this cycle.  The flicker on GM45 laptops
appears to be gone or almost gone, and hopefully the power consumption
regression across suspend/resume is fixed as well.  There are also a
number of fixes to new-chipset support, updating the code to catch up
with either changes to powersaving code that didn't take new chipsets
into account (mostly since they landed at the same time), or updating
the new chipset support as new pre-release revs have come out.

Andy Lutomirski (1):
      drm/i915: Fix render reclock availability detection.

Chris Wilson (1):
      drm/i915: Install a fence register for fbc on g4x

Jesse Barnes (5):
      drm/i915: Save and restore the GM45 FBC regs on suspend and resume.
      drm/i915: save/restore BLC histogram control reg across suspend/resum=
e
      drm/i915: add FIFO watermark support for G4x
      drm/i915: update watermarks before enabling PLLs
      drm/i915: kill warning in intel_find_pll_g4x_dp

Shaohua Li (1):
      drm/i915: disable FBC for Pineview, fixing a boot hang.

Zhao Yakui (1):
      drm/i915: Set the LVDS_BORDER when using LVDS scaling mode

Zhenyu Wang (6):
      drm/i915: disable powersave feature for Ironlake currently
      drm/i915: Fix FDI M/N setting according with correct color depth
      drm/i915: fix to setup display reference clock control on Ironlake
      drm/i915: fix panel fitting filter coefficient select for Ironlake
      drm/i915: quiet DP i2c init
      drm/i915: Ironlake suspend/resume support

 drivers/gpu/drm/i915/i915_dma.c      |    3 +-
 drivers/gpu/drm/i915/i915_drv.h      |   39 +++++-
 drivers/gpu/drm/i915/i915_reg.h      |   30 +++-
 drivers/gpu/drm/i915/i915_suspend.c  |  305 +++++++++++++++++++++++++++---=
----
 drivers/gpu/drm/i915/intel_bios.c    |   14 +-
 drivers/gpu/drm/i915/intel_display.c |  178 ++++++++++++++++++--
 drivers/gpu/drm/i915/intel_dp.c      |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c    |   10 +-
 8 files changed, 486 insertions(+), 95 deletions(-)


--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com




--=-6f2f6Z0J3fNSVKOVH1q7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrw+u0ACgkQHUdvYGzw6vc+BQCfWAFi0wqFsn6j9h8uA4KQC9BX
YF8An3G/FvZoGmDvtnLg2ycyiaoFX5uI
=6paS
-----END PGP SIGNATURE-----

--=-6f2f6Z0J3fNSVKOVH1q7--

