Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbXJNSed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbXJNSed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXJNSeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:34:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759563AbXJNSeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:34:21 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] mpc5200_wdt: __user annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ih8I8-00040h-5I@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:34:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/watchdog/mpc5200_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/watchdog/mpc5200_wdt.c b/drivers/char/watchdog/mpc5200_wdt.c
index 564143d..9cfb975 100644
--- a/drivers/char/watchdog/mpc5200_wdt.c
+++ b/drivers/char/watchdog/mpc5200_wdt.c
@@ -81,7 +81,7 @@ static int mpc5200_wdt_stop(struct mpc5200_wdt *wdt)
 
 
 /* file operations */
-static ssize_t mpc5200_wdt_write(struct file *file, const char *data,
+static ssize_t mpc5200_wdt_write(struct file *file, const char __user *data,
 		size_t len, loff_t *ppos)
 {
 	struct mpc5200_wdt *wdt = file->private_data;
-- 
1.5.3.GIT


