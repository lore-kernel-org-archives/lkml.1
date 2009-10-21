Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZJUSLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZJUSLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZJUSLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:11:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42621 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754644AbZJUSLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:11:32 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Allow platforms to specify an IRQ base for WM8350
Date: Wed, 21 Oct 2009 19:11:34 +0100
Message-Id: <1256148694-23312-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is currently unused by the wm8350 drivers but getting it merged
now will reduce merge issues in the future when implementing wm8350
genirq support.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm8350/core.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 32197fd..ffce508 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -646,10 +646,12 @@ struct wm8350 {
  * @init: Function called during driver initialisation.  Should be
  *        used by the platform to configure GPIO functions and similar.
  * @irq_high: Set if WM8350 IRQ is active high.
+ * @irq_base: Base IRQ for genirq (not currently used).
  */
 struct wm8350_platform_data {
 	int (*init)(struct wm8350 *wm8350);
 	int irq_high;
+	int irq_base;
 };
 
 
-- 
1.6.5

