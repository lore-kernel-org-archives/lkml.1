Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZJGG3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZJGG3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZJGG3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:29:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57965 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZJGG3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:29:39 -0400
Date: Wed, 07 Oct 2009 15:18:14 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 4/6] Haptic: add haptic configuration
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091007061814.GA7596@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 07 Oct 2009 06:18:20.0348 (UTC)
 FILETIME=[F75DB7C0:01CA4715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

haptic class support

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
+obj-$(CONFIG_HAPTCI)		+= haptic/
 obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
-- 
1.5.3.3

