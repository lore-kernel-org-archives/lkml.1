Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbZJII7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbZJII7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbZJII7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:59:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41619 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZJII7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:59:35 -0400
Date: Fri, 09 Oct 2009 17:58:48 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 4/6] Haptic: add haptic configuration (v2)
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091009085847.GA24918@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 09 Oct 2009 08:58:55.0807 (UTC)
 FILETIME=[BB5F94F0:01CA48BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

haptic class support

Changelog v1:
	Fix typo

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/Kconfig  |    2 ++
 drivers/Makefile |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 48bbdbe..a44348e 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -90,6 +90,8 @@ source "drivers/memstick/Kconfig"
 
 source "drivers/leds/Kconfig"
 
+source "drivers/haptic/Kconfig"
+
 source "drivers/accessibility/Kconfig"
 
 source "drivers/infiniband/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 6ee53c7..ee6f438 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -94,6 +94,7 @@ obj-y				+= idle/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
+obj-$(CONFIG_HAPTIC)		+= haptic/
 obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
-- 
1.5.3.3

