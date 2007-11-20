Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbXKTB5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbXKTB5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbXKTBtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:40 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2087 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbXKTBtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:11 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 22/59] drivers/macintosh: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:14 -0800
Message-Id: <1195523331-15303-23-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-22-git-send-email-joe@perches.com>
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
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
Message-Id: <e898ed30e34f209e9309667be632d75945672cd5.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/macintosh/smu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index d409f67..0568313 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -194,7 +194,7 @@ static irqreturn_t smu_db_intr(int irq, void *arg)
 		reply_len = rc == 0 ? smu->cmd_buf->length : 0;
 		DPRINTK("SMU: reply len: %d\n", reply_len);
 		if (reply_len > cmd->reply_len) {
-			printk(KERN_WARNING "SMU: reply buffer too small,"
+			printk(KERN_WARNING "SMU: reply buffer too small, "
 			       "got %d bytes for a %d bytes buffer\n",
 			       reply_len, cmd->reply_len);
 			reply_len = cmd->reply_len;
-- 
1.5.3.5.652.gf192c

