Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZCFDcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZCFDcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZCFDcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:32:43 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:44098 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZCFDcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:32:42 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83877044"
From: Bryan Wu <cooloney@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] Input: bf54x-keys: Fix typo
Date: Fri,  6 Mar 2009 11:34:51 +0800
Message-Id: <1236310491-24387-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/input/keyboard/bf54x-keys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index ee855c5..c6f4e16 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -212,7 +212,7 @@ static int __devinit bfin_kpad_probe(struct platform_device *pdev)
 	if (!pdata->debounce_time || pdata->debounce_time > MAX_MULT ||
 	    !pdata->coldrive_time || pdata->coldrive_time > MAX_MULT) {
 		printk(KERN_ERR DRV_NAME
-			": Invalid Debounce/Columdrive Time from pdata\n");
+			": Invalid Debounce/Columndrive Time from platform data\n");
 		bfin_write_KPAD_MSEL(0xFF0);	/* Default MSEL	*/
 	} else {
 		bfin_write_KPAD_MSEL(
-- 
1.5.6.3
