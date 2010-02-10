Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0BJNex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:34:53 -0500
Received: from smtp.nokia.com ([192.100.105.134]:23841 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0BJNev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:34:51 -0500
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: sameo@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 1/1] MFD: twl4030-core: Fix a typo in the twl_has_pwrbutton definition
Date: Wed, 10 Feb 2010 15:33:48 +0200
Message-Id: <1265808828-11433-1-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.6.5.7.g9ecb2
X-OriginalArrivalTime: 10 Feb 2010 13:34:03.0574 (UTC) FILETIME=[B5FDED60:01CAAA55]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@nokia.com>

Change the typo CONFIG_INPUT_TWL4030_PWBUTTON_MODULE in the
twl_has_pwrbutton definition to CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/mfd/twl4030-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index 0004823..04656f8 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -134,7 +134,7 @@
 #define TWL4030_NUM_SLAVES		4
 
 #if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
-	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
+	|| defined(CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE)
 #define twl_has_pwrbutton()	true
 #else
 #define twl_has_pwrbutton()	false
-- 
1.6.5.7.g9ecb2

