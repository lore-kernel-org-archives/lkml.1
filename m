Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbZJHXy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbZJHXy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 19:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbZJHXyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 19:54:25 -0400
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:44751 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbZJHXyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 19:54:24 -0400
Subject: [git pull] drm-intel fixes for 2.6.32-rc3
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/8PUrpswgyvDwP6B49ex"
Date: Thu, 08 Oct 2009 16:53:41 -0700
Message-Id: <1255046021.9296.42.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/8PUrpswgyvDwP6B49ex
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit 17d857be649a21ca90008c6dc425d849fa83db5c=
:
  Linus Torvalds (1):
        Linux 2.6.32-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel drm-intel-=
next

Pretty minor fixes.  We've still got some outstanding regressions
related to the power saving code, which jbarnes and keithp are looking
into.  Hopefully we'll have some results soon.

Adam Jackson (1):
      drm/i915: Initialize HDMI outputs as HDMI connectors, not DVI.

Brian Rogers (1):
      drm/i915: Don't call intel_update_fbc from intel_crtc_cursor_set

Chris Wilson (3):
      drm/i915: Record device minor rather than pointer in TRACE_EVENT
      drm/i915: batch submit seqno off-by-one.
      drm/i915: Enable irq to trace batch buffer completion.

Eric Anholt (1):
      Merge commit 'ickle/for-anholt' into drm-intel-next

Zhao Yakui (1):
      drm/i915: Multiply the refresh by 1000 in TV mode validatiion

 drivers/gpu/drm/i915/i915_dma.c      |    1 +
 drivers/gpu/drm/i915/i915_drv.h      |    2 +
 drivers/gpu/drm/i915/i915_gem.c      |   10 +++++-
 drivers/gpu/drm/i915/i915_irq.c      |   10 +++++++
 drivers/gpu/drm/i915/i915_trace.h    |   49 +++++++++++++++++-------------=
---
 drivers/gpu/drm/i915/intel_display.c |    4 ---
 drivers/gpu/drm/i915/intel_hdmi.c    |    2 +-
 drivers/gpu/drm/i915/intel_tv.c      |    3 +-
 8 files changed, 49 insertions(+), 32 deletions(-)


--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-/8PUrpswgyvDwP6B49ex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrOe4QACgkQHUdvYGzw6vdJXwCfWljOMggGKgpyCAA88srg+aZf
aKcAniA7jqCmXVRqgS2ZGk7gHV3k/92v
=g8eq
-----END PGP SIGNATURE-----

--=-/8PUrpswgyvDwP6B49ex--

