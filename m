Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXFKXOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXFKXOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXFKXOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:14:47 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:60202 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbXFKXOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:14:46 -0400
Date: Tue, 12 Jun 2007 00:14:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] drm fixes for 2.6.22-rc4
Message-ID: <Pine.LNX.4.64.0706120013560.30772@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-patches' branch from the drm git tree,
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

It contains a fix for a radeon 32/64-bit issue along with
hw support for some new Intel hw. Sorry for the lateness but I rely
on AGP PCI IDS being in the tree before DRM ids become useful.

Dave.

  drivers/char/drm/drm_pciids.h   |    5 ++
  drivers/char/drm/i915_dma.c     |   90 +++++++++++++++++++++++++++++++--------
  drivers/char/drm/i915_drm.h     |    5 ++
  drivers/char/drm/i915_drv.h     |    2 +
  drivers/char/drm/radeon_ioc32.c |   26 +++++++++++
  5 files changed, 110 insertions(+), 18 deletions(-)

commit 9b01bd5b284bbf519b726b39f1352023cb5e9e69
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Jun 10 16:00:27 2007 +1000

     drm: fix radeon setparam on 32/64 bit systems.

     The alignment on 64-bit is different for 64-bit values.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit dc7a93190c21edbf3ed23e678ad04f852b9cff28
Author: Wang Zhenyu <zhenyu.z.wang@intel.com>
Date:   Sun Jun 10 15:58:19 2007 +1000

     drm/i915:  Add support for the G33, Q33, and Q35 chipsets.

     These require that the status page be referenced by a pointer in GTT, rather
     than phsyical memory.  So, we have the X Server allocate that memory and tell
     us the address, instead.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2f4042b186b9bfe82f48fe801619c6c285c16bef
Author: Wang Zhenyu <zhenyu.z.wang@intel.com>
Date:   Fri Jun 1 22:03:44 2007 +1000

     i915: add new pciids for 945GME, 965GME/GLE

     Signed-off-by: Dave Airlie <airlied@linux.ie>

