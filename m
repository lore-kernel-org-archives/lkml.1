Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbXKTB4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbXKTB4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbXKTBtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:36 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2085 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348AbXKTBtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:09 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 20/59] drivers/input: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:12 -0800
Message-Id: <1195523331-15303-21-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-20-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
Message-Id: <f56e301a22202f30e5443b129f4ea15fa20c5226.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/input/keyboard/omap-keypad.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index babc913..ce6206f 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -335,7 +335,7 @@ static int __init omap_kp_probe(struct platform_device *pdev)
 		/* Cols: outputs */
 		for (col_idx = 0; col_idx < omap_kp->cols; col_idx++) {
 			if (omap_request_gpio(col_gpios[col_idx]) < 0) {
-				printk(KERN_ERR "Failed to request"
+				printk(KERN_ERR "Failed to request "
 				       "GPIO%d for keypad\n",
 				       col_gpios[col_idx]);
 				goto err1;
@@ -345,7 +345,7 @@ static int __init omap_kp_probe(struct platform_device *pdev)
 		/* Rows: inputs */
 		for (row_idx = 0; row_idx < omap_kp->rows; row_idx++) {
 			if (omap_request_gpio(row_gpios[row_idx]) < 0) {
-				printk(KERN_ERR "Failed to request"
+				printk(KERN_ERR "Failed to request "
 				       "GPIO%d for keypad\n",
 				       row_gpios[row_idx]);
 				goto err2;
-- 
1.5.3.5.652.gf192c

