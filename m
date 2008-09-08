Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbYIHIrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbYIHIrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 04:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYIHIrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 04:47:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:5386 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYIHIrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 04:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UFTnLtw37vGcOK8O3Z1IgElkU1u1+IJvXxDdWKWfGuaB2l5JeqEqZ3pb9XmbLc9lww
         niY2BlhtxsDZTpYhqCHkBuzb/JcoYdGF2r6GH+DuL2BVVQO7e2DVxHZtH8HwSAVkJgkv
         p1WrNYHVgBPc9WBb5XAcaT+iMw2huog01AZ7o=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, David Woodhouse <dwmw2@infradead.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] power_supply: fix dependency of tosa_battery
Date: Mon,  8 Sep 2008 12:44:50 +0400
Message-Id: <1220863490-31415-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tosa_battery should also depend on wm97xx_ts as it uses dac-accessing functions
from that module.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/power/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9ce5585..b001984 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -51,7 +51,7 @@ config BATTERY_OLPC
 
 config BATTERY_TOSA
 	tristate "Sharp SL-6000 (tosa) battery"
-	depends on MACH_TOSA && MFD_TC6393XB
+	depends on MACH_TOSA && MFD_TC6393XB && TOUCHSCREEN_WM97XX
 	help
 	  Say Y to enable support for the battery on the Sharp Zaurus
 	  SL-6000 (tosa) models.
-- 
1.5.6.5

