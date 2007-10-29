Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXJ2C7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXJ2C7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXJ2C7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:59:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50506 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbXJ2C7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:59:13 -0400
Date: Mon, 29 Oct 2007 13:59:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] Silence radeon_pm warning
Message-Id: <20071029135911.ba1bfee2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/aty/radeon_pm.c:30: warning: 'radeon_reinitialize_M10' declared 'static' but never defined

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/video/aty/radeon_pm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index be1d57b..f989836 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -27,7 +27,9 @@
 
 #include "ati_ids.h"
 
+#ifdef CONFIG_PM
 static void radeon_reinitialize_M10(struct radeonfb_info *rinfo);
+#endif
 
 /*
  * Workarounds for bugs in PC laptops:
-- 
1.5.3.4

