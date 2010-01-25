Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673Ab0AYTd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab0AYTd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468Ab0AYTd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:33:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48071 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751438Ab0AYTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:33:56 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/3] mfd: Correct regulator platform data
Date: Mon, 25 Jan 2010 19:33:50 +0000
Message-Id: <1264448030-11447-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264447598-11255-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1264447598-11255-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and of course in my split of the driver into relevant per-tree
sections I managed to miss this update of the platform data for
the regulators.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Ideally it should be squashed down into patch 2.

 include/linux/mfd/wm8994/pdata.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index 3e6a86a..96a5800 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -20,7 +20,7 @@
 
 struct wm8994_ldo_pdata {
 	/** GPIOs to enable regulator, 0 or less if not available */
-	int regulator_enables;
+	int enable;
 
 	const char *supply;
 	struct regulator_init_data *init_data;
-- 
1.6.6

