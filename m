Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXHYIcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXHYIcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 04:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765093AbXHYIcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 04:32:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41239 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765089AbXHYIcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 04:32:06 -0400
Date: Sat, 25 Aug 2007 09:32:04 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm patches for 2.6.23-rc4
Message-ID: <Pine.LNX.4.64.0708250930390.778@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-patches' branch from
git://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

This just contains a pci id, ioremap balancing and dead code removal 
patches.

Dave.

  drivers/char/drm/drm_bufs.c    |   13 +++++++------
  drivers/char/drm/via_dmablit.c |    2 +-
  2 files changed, 8 insertions(+), 7 deletions(-)

commit 0769d39c993145754852b517ddd9c11586f0a014
Author: Scott Thompson <postfail at hushmail.com>
Date:   Sat Aug 25 18:17:49 2007 +1000

     drm: ioremap return value checks

     Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 22c806c23fe17f9c744d19edfe650cfd6496bc2a
Author: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Date:   Mon Jul 23 18:32:01 2007 +1000

     drm/via: Fix dmablit when blit queue is full

     fd.o bug 11542

     Acked-by: Thomas Hellstrom
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7ea4d4bd5e21380f028c3a6e2500655090a3f932
Author: Adrian Bunk <bunk@stusta.de>
Date:   Mon Jul 23 10:00:51 2007 +0200

     drm_rmmap_ioctl(): remove dead code

     This patch removes some obviously dead code spotted by the Coverity
     checker.

     Signed-off-by: Adrian Bunk <bunk@stusta.de>
     Signed-off-by: Dave Airlie <airlied@linux.ie>
