Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbXE3Bf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbXE3Bf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbXE3BfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:35:18 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56548 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXE3BfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:35:17 -0400
Date: Wed, 30 May 2007 02:35:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes for 2.6.22-rc3
Message-ID: <Pine.LNX.4.64.0705300234060.19669@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1807755747-1180488914=:19669"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1807755747-1180488914=:19669
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

It contains a fix for a kmalloc 0, along with new pci ids for the radeon rs480
and a spinlock initialiser.

I have stuff that actually fixes up the drm_drawable.c to use an idr but I'll hold until the next merge window.

Dave.

  drivers/char/drm/drm_drawable.c |   41 ++++++++++++++++++++++++--------------
  drivers/char/drm/drm_pciids.h   |    7 ++++++
  drivers/char/drm/i915_irq.c     |    2 +-
  3 files changed, 34 insertions(+), 16 deletions(-)

commit c4814f9001a8dd28e39311a919beac34f778f76d
Author: Michel Dänzer <michel@tungstengraphics.com>
Date:   Sat May 26 04:37:08 2007 +1000

     drm: make sure the drawable code doesn't call malloc(0).

     Signed-off-by: Michel Dänzer <michel@tungstengraphics.com>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 777c7738a598c6e8d4b850181a509757fb79cf36
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat May 26 04:19:03 2007 +1000

     drm/radeon: add more IGP chipset pci ids

     Add more IGP chipset PCI IDs

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit a6399bdd492a3289d39e4b79cbe69ad44a054ee3
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat May 26 05:56:14 2007 +1000

     drm: Spinlock initializer cleanup

     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-1807755747-1180488914=:19669--
