Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYDYDag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYDYDag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYDYD3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:29:54 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:21593 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbYDYD33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:29:29 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67098513"
From: Bryan Wu <cooloney@kernel.org>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] BF54x Framebuffer Driver: BF542 does not have EPPI0, so dont allow the LQ034 driver for now
Date: Fri, 25 Apr 2008 11:29:06 +0800
Message-Id: <1209094146-19872-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209094146-19872-1-git-send-email-cooloney@kernel.org>
References: <1209094146-19872-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/video/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 1bd5fb3..682eb61 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -546,7 +546,7 @@ config FB_VGA16
 
 config FB_BF54X_LQ043
 	tristate "SHARP LQ043 TFT LCD (BF548 EZKIT)"
-	depends on FB && (BF54x)
+	depends on FB && (BF54x) && !BF542
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.5.5
