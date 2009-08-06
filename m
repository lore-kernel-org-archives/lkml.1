Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZHFFTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZHFFTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZHFFTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:19:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52047 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZHFFTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:19:36 -0400
Date: Thu, 6 Aug 2009 06:19:37 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [updated git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0908060618260.12958@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

I queued up another patch on top of the new rs880 PCI IDs, Jerome 
submitted this a while ago on lkml and I missed it, it speeds up the 
radeon kms code for some of the 2D driver cases.

Dave.

 drivers/gpu/drm/radeon/r600_cp.c       |   22 +++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_drv.h    |    1 +
 drivers/gpu/drm/radeon/radeon_object.c |    2 +-
 include/drm/drm_pciids.h               |    5 +++++
 4 files changed, 22 insertions(+), 8 deletions(-)

commit 985fe845aea9cd56fd351800302270444556e45a
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Jul 29 18:55:53 2009 +0200

    drm/radeon/kms: Fix caching mode selection for GTT object
    
    GTT object can either be cached,uncached or wc just let core ttm
    pick the best mode according to how the bo driver and GTT memory
    type was initialized.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6502fbfaf81b09b3f474bb7b3796257e9450273e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Aug 4 11:24:24 2009 -0400

    drm/radeon: Add support for RS880 chips
    
    These are new AMD IGP chips
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
