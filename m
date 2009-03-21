Return-Path: <linux-kernel-owner+w=401wt.eu-S1761819AbZCUFvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819AbZCUFvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761472AbZCUFti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:49:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:56594 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761494AbZCUFtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:49:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Fdk/Ck/xggxo1TRLz7xfr0V7tRlfZ0GCUB6jK36TlfBHaxgbrj7w6SxuwxX57pOCBY
         CC+xedAMU8jLbwMuOPODrRnsnGLWn9b3OiLU3kbobDZsFPtpdh9fOSEnHugsGt76/ens
         XWB9xaN+v3th+lPvHCO+w/BWmpkUnc6QEEeEA=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: sameo@openedhand.com
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] mfd: remove duplicated #include
Date: Sat, 21 Mar 2009 13:49:29 +0800
Message-Id: <1237614569-3548-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include in drivers/mfd/pcf50633-core.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/mfd/pcf50633-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 2e36057..7793932 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
-#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
-- 
1.6.0.4

