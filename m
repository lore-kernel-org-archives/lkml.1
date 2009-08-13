Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbZHMJvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbZHMJvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZHMJvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:51:23 -0400
Received: from mail.df.lth.se ([194.47.250.12]:55480 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751772AbZHMJvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:51:23 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, dann frazier <dannf@debian.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 5/5] MFD AB3100 fix build warning
Date: Thu, 13 Aug 2009 11:51:04 +0200
Message-Id: <1250157064-9917-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build warning in the AB3100 driver reported by
Stephen Rothwell and Dann Frazier due to a mismatched prototype
in the ab3100_get_set_reg() file operation callback.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 16675f7..098e825 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -470,7 +470,7 @@ static int ab3100_get_set_reg_open_file(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int ab3100_get_set_reg(struct file *file,
+static ssize_t ab3100_get_set_reg(struct file *file,
 			      const char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
-- 
1.6.2.1

