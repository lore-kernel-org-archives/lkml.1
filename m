Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZBEHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZBEHST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZBEHSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:18:07 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:14751 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZBEHSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:18:06 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82343764"
From: Bryan Wu <cooloney@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roel Kluin <roel.kluin@gmail.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] Input: bf54x-keys: ! has a higher priority than >
Date: Thu,  5 Feb 2009 15:19:55 +0800
Message-Id: <1233818395-6461-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/input/keyboard/bf54x-keys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 1928401..ee855c5 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -209,8 +209,8 @@ static int __devinit bfin_kpad_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	if (!pdata->debounce_time || !pdata->debounce_time > MAX_MULT ||
-	    !pdata->coldrive_time || !pdata->coldrive_time > MAX_MULT) {
+	if (!pdata->debounce_time || pdata->debounce_time > MAX_MULT ||
+	    !pdata->coldrive_time || pdata->coldrive_time > MAX_MULT) {
 		printk(KERN_ERR DRV_NAME
 			": Invalid Debounce/Columdrive Time from pdata\n");
 		bfin_write_KPAD_MSEL(0xFF0);	/* Default MSEL	*/
-- 
1.5.6.3
