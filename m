Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZHMJt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZHMJt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZHMJtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:49:55 -0400
Received: from mail.df.lth.se ([194.47.250.12]:55435 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753816AbZHMJtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:49:53 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/5] MFD AB3100 alter default setting
Date: Thu, 13 Aug 2009 11:49:49 +0200
Message-Id: <1250156989-9376-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This alters the default setting for AB3100_IMRB1 from 0xff to
0xbf. These registers are used for the yet unimplemented ADC
and this new setting will deactivate ADC Trigger 1.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 1fd20cd..630c925 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -667,7 +667,7 @@ ab3100_init_settings[] = {
 		.setting = 0x01
 	}, {
 		.abreg = AB3100_IMRB1,
-		.setting = 0xFF
+		.setting = 0xBF
 	}, {
 		.abreg = AB3100_IMRB2,
 		.setting = 0xFF
-- 
1.6.2.1

