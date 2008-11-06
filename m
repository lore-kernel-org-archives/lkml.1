Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYKFLhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYKFLhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYKFLhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:37:04 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47281 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbYKFLhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:37:01 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] SSB: hide empty sub menu
Date: Thu,  6 Nov 2008 06:37:00 -0500
Message-Id: <1225971420-32044-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the target system cannot support SSB, then don't show the menu option as
it'll simply be an empty submenu.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/ssb/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 307b1f6..b1b947e 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -1,10 +1,11 @@
-menu "Sonics Silicon Backplane"
-
 config SSB_POSSIBLE
 	bool
 	depends on HAS_IOMEM && HAS_DMA
 	default y
 
+menu "Sonics Silicon Backplane"
+	depends on SSB_POSSIBLE
+
 config SSB
 	tristate "Sonics Silicon Backplane support"
 	depends on SSB_POSSIBLE
-- 
1.6.0.3

