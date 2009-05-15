Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZEOUdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZEOUdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZEOUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:33:41 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:41573 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZEOUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:33:40 -0400
Subject: Fwd: [git pull] drm-intel fixes for 2.6.30-rc4
From: Eric Anholt <eric@anholt.net>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8J5KbUILV/rRRdeBUEYJ"
Date: Fri, 15 May 2009 13:33:40 -0700
Message-Id: <1242419620.18219.331.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8J5KbUILV/rRRdeBUEYJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I fail at CC.

-------- Forwarded Message --------
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] drm-intel fixes for 2.6.30-rc4
Date: Fri, 15 May 2009 13:09:46 -0700

The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1=
:
  Linus Torvalds (1):
        Linux 2.6.30-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

For the most part this is a bunch of regression fixes for moving to KMS
from UMS.  My fix should make a bunch of people with "My chip hangs
randomly every couple of days" happy.  And jbarnes's should help us
point fingers at distros who muck with chip state by pointlessly calling
the BIOS and have it show up as "regressions" in our driver :)

Carl Worth (1):
      drm/i915: Add new GET_PIPE_FROM_CRTC_ID ioctl.

Eric Anholt (1):
      drm/i915: Don't allow binding objects into the last page of the apert=
ure.

Jarod Wilson (1):
      drm/i915: ignore LVDS on intel graphics systems that lie about having=
 it

Jesse Barnes (1):
      drm/i915: sanity check IER at wait_request time

Keith Packard (2):
      drm/i915: x86 always has writeq. Add I915_READ64 for symmetry.
      drm/i915: save/restore fence registers across suspend/resume

Ma Ling (3):
      drm/i915: Use the GM45 VGA hotplug workaround on G45 as well.
      drm/i915: Include 965GME pci ID in IS_I965GM(dev) to match UMS.
      drm/i915: Set HDMI hot plug interrupt enable for only the output in q=
uestion.

Shaohua Li (1):
      drm/i915: workaround IGD i2c bus issue in kernel side (v2)

 drivers/gpu/drm/i915/i915_dma.c      |   13 +++++++-
 drivers/gpu/drm/i915/i915_drv.h      |   11 ++----
 drivers/gpu/drm/i915/i915_gem.c      |    9 +++++
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/i915_suspend.c  |   24 +++++++++++++++
 drivers/gpu/drm/i915/intel_crt.c     |    2 +-
 drivers/gpu/drm/i915/intel_display.c |   31 +++++++++++++++++++
 drivers/gpu/drm/i915/intel_drv.h     |    4 ++-
 drivers/gpu/drm/i915/intel_hdmi.c    |   17 +++++++---
 drivers/gpu/drm/i915/intel_i2c.c     |   17 ++++++++++
 drivers/gpu/drm/i915/intel_lvds.c    |   54 +++++++++++++++++++++++++++++-=
----
 drivers/gpu/drm/i915/intel_modes.c   |    6 ++++
 include/drm/i915_drm.h               |   10 ++++++
 13 files changed, 175 insertions(+), 24 deletions(-)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-8J5KbUILV/rRRdeBUEYJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoN0aQACgkQHUdvYGzw6vfd6QCeMYHnEGsJuYheYlJn2QvtTqOX
/+gAniunLp/dCbZV25PRLhmoxXu28cOT
=0QkS
-----END PGP SIGNATURE-----

--=-8J5KbUILV/rRRdeBUEYJ--

