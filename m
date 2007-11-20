Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbXKTBwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbXKTBwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbXKTBtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:10 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2061 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688AbXKTBtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/59] drivers/cdrom: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:04 -0800
Message-Id: <1195523331-15303-13-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-12-git-send-email-joe@perches.com>
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
Message-Id: <51d5cae73b21c33174340db0e389ac810bba63fa.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/viocd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index d8bb44b..1ca73d1 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -129,7 +129,7 @@ static int proc_viocd_show(struct seq_file *m, void *v)
 	int i;
 
 	for (i = 0; i < viocd_numdev; i++) {
-		seq_printf(m, "viocd device %d is iSeries resource %10.10s"
+		seq_printf(m, "viocd device %d is iSeries resource %10.10s "
 				"type %4.4s, model %3.3s\n",
 				i, viocd_diskinfo[i].rsrcname,
 				viocd_diskinfo[i].type,
-- 
1.5.3.5.652.gf192c

