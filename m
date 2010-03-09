Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0CIQBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:01:06 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59529 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab0CIQBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:01:03 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] fbdev: bfin-lq035q1-fb: remove duplicated #include
Date: Tue,  9 Mar 2010 11:04:19 -0500
Message-Id: <1268150659-27335-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  drivers/video/bfin-lq035q1-fb.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bfin-lq035q1-fb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/bfin-lq035q1-fb.c b/drivers/video/bfin-lq035q1-fb.c
index b690c26..0387236 100644
--- a/drivers/video/bfin-lq035q1-fb.c
+++ b/drivers/video/bfin-lq035q1-fb.c
@@ -22,7 +22,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
-#include <linux/dma-mapping.h>
 
 #include <asm/blackfin.h>
 #include <asm/irq.h>
-- 
1.7.0.2

