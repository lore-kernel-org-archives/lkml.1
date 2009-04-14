Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbZDNSsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbZDNSsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbZDNSsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:48:09 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:58442 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZDNSsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:48:07 -0400
Subject: [git pull] DRM fixes for 2.6.30
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ikGV2FfmF87sUOqDURmM"
Date: Tue, 14 Apr 2009 11:48:03 -0700
Message-Id: <1239734883.6761.36.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ikGV2FfmF87sUOqDURmM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The following changes since commit 8fe74cf053de7ad2124a894996f84fa890a81093=
:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

There are some nice bugfixes in here, in particular a massive speedup
for some non-netbook 915-class hardware.  But the most exciting thing is
a non-bugfix: batch and ringbuffer dumping from the kernel have let us
build intel_gpu_dump
(git://anongit.freedesktop.org/git/xorg/app/intel-gpu-tools), so now
anybody that hangs their GPU can run it and provide useful information
with bug reports.  Finally.

Ben Gamari (1):
      drm/i915: Implement batch and ring buffer dumping

Eric Anholt (2):
      drm/i915: Correctly set the write flag for get_user_pages in pread.
      drm/i915: Allow tiling of objects with bit 17 swizzling by the CPU.

Ferenc Wagner (1):
      drm/i915: indicate framebuffer restore key in SysRq help message

Florian Mickler (1):
      drm/i915: Fix use of uninitialized var in 40a5f0de

Ma Ling (1):
      drm/i915: sync hdmi detection by hdmi identifier with 2D

Shaohua Li (2):
      drm/i915: Fix a mismerge of the IGD patch (new .find_pll hooks missed=
)
      drm/i915: fix scheduling while holding the new active list spinlock

 drivers/gpu/drm/i915/i915_drv.h         |    7 +
 drivers/gpu/drm/i915/i915_gem.c         |  187 ++++++++++++++++++++++++++-=
----
 drivers/gpu/drm/i915/i915_gem_debugfs.c |   93 +++++++++++++++
 drivers/gpu/drm/i915/i915_gem_tiling.c  |  111 ++++++++++++++++++-
 drivers/gpu/drm/i915/intel_display.c    |    2 +
 drivers/gpu/drm/i915/intel_fb.c         |    4 +-
 drivers/gpu/drm/i915/intel_hdmi.c       |   23 ++++-
 drivers/gpu/drm/i915/intel_sdvo.c       |   22 ++++-
 include/drm/i915_drm.h                  |    3 +
 9 files changed, 412 insertions(+), 40 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-ikGV2FfmF87sUOqDURmM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknk2mMACgkQHUdvYGzw6vd5cACfYqVb/Wk7p2O83ph3j1b/t+5f
IeEAniqzqEoEcL3FJb9xNg+xBXTgIvGL
=jKjM
-----END PGP SIGNATURE-----

--=-ikGV2FfmF87sUOqDURmM--

