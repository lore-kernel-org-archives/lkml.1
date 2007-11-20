Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbXKTB7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbXKTB7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXKTBt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:57 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2101 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373AbXKTBtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:15 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 26/59] drivers/message: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:18 -0800
Message-Id: <1195523331-15303-27-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-26-git-send-email-joe@perches.com>
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
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
 <1195523331-15303-26-git-send-email-joe@perches.com>
Message-Id: <48f19e3c182fdbd1ccd30b544209f962d16d7dc9.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/message/i2o/exec-osm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/i2o/exec-osm.c b/drivers/message/i2o/exec-osm.c
index 6cbcc21..16177c2 100644
--- a/drivers/message/i2o/exec-osm.c
+++ b/drivers/message/i2o/exec-osm.c
@@ -503,7 +503,7 @@ static int i2o_exec_reply(struct i2o_controller *c, u32 m,
 	 * to aid in debugging.
 	 *
 	 */
-	printk(KERN_WARNING "%s: Unsolicited message reply sent to core!"
+	printk(KERN_WARNING "%s: Unsolicited message reply sent to core! "
 	       "Message dumped to syslog\n", c->name);
 	i2o_dump_message(msg);
 
-- 
1.5.3.5.652.gf192c

