Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZG0PAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZG0PAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZG0PAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:00:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44670 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751426AbZG0PAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:00:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Fix comment cut'n'paste in register lock code
Date: Mon, 27 Jul 2009 16:00:37 +0100
Message-Id: <1248706837-9656-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248702372-29534-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248702372-29534-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 49b7885..05e5724 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -115,11 +115,11 @@ static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
 }
 
 /**
- * wm831x_reg_unlock: Unlock user keyed registers
+ * wm831x_reg_lock: Unlock user keyed registers
  *
  * The WM831x has a user key preventing writes to particularly
  * critical registers.  This function locks those registers,
- * allowing writes to them.
+ * disallowing writes to them.
  */
 void wm831x_reg_lock(struct wm831x *wm831x)
 {
@@ -145,7 +145,7 @@ EXPORT_SYMBOL_GPL(wm831x_reg_lock);
  *
  * The WM831x has a user key preventing writes to particularly
  * critical registers.  This function locks those registers,
- * preventing spurious writes.
+ * allowing writes to them.
  */
 int wm831x_reg_unlock(struct wm831x *wm831x)
 {
-- 
1.6.3.3

