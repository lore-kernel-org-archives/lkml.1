Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZIWAX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZIWAX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZIWAX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:23:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51979 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZIWAX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:23:56 -0400
Date: Wed, 23 Sep 2009 01:24:03 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] two radeon fixes.
Message-ID: <alpine.DEB.2.00.0909230123000.7108@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

These fix one regression in kms and a bug on the blit path.

Dave.

 drivers/gpu/drm/radeon/r600_blit.c     |    2 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c |    2 +-
 drivers/gpu/drm/radeon/radeon.h        |   59 +-------------------
 drivers/gpu/drm/radeon/radeon_drv.h    |   65 +---------------------
 drivers/gpu/drm/radeon/radeon_family.h |   97 ++++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 123 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/radeon_family.h

commit 5b31aee9d72f529ee6b60e8d66967f817a0e39fc
Author: Andre Maasikas <amaasikas@gmail.com>
Date:   Mon Sep 21 08:59:41 2009 -0400

    drm/radeon/r600: set correct pitch for 4 byte copy
    
    [agd5f: also fix the non-kms path]
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>

commit c214271563c00f2721c5111e27b53bf06dabc6e4
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Sep 22 08:50:10 2009 +1000

    drm/radeon: consolidate family flags used in pciids.
    
    having these separate was pointless and introduced a bug when
    one got updated without the other.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
