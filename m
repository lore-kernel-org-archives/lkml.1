Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbZHECL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbZHECL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933245AbZHECL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:11:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42071 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232AbZHECL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:11:27 -0400
Date: Wed, 5 Aug 2009 03:11:28 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0908050310400.14018@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Just some new hw support from AMD (chip ID + pci ids).

Dave.

 drivers/gpu/drm/radeon/r600_cp.c    |   22 +++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_drv.h |    1 +
 include/drm/drm_pciids.h            |    5 +++++
 3 files changed, 21 insertions(+), 7 deletions(-)

commit 6502fbfaf81b09b3f474bb7b3796257e9450273e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Aug 4 11:24:24 2009 -0400

    drm/radeon: Add support for RS880 chips
    
    These are new AMD IGP chips
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
