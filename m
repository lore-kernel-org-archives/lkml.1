Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbZF1Qc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbZF1Qc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZF1Q1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:34 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1106 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZF1Q1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:32 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: [PATCH 19/62] drivers/ide: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:24 -0700
Message-Id: <e5dd29302107ff49a0a34e24df1438966f4285f5.1246173681.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/ide-probe.c |    2 +-
 drivers/ide/umc8672.c   |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 1bb106f..20120fd 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1201,7 +1201,7 @@ static int ide_find_port_slot(const struct ide_port_info *d)
 {
 	int idx = -ENOENT;
 	u8 bootable = (d && (d->host_flags & IDE_HFLAG_NON_BOOTABLE)) ? 0 : 1;
-	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;;
+	u8 i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;
 
 	/*
 	 * Claim an unassigned slot.
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
index 0608d41..60f936e 100644
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -170,9 +170,9 @@ static int __init umc8672_init(void)
 		goto out;
 
 	if (umc8672_probe() == 0)
-		return 0;;
+		return 0;
 out:
-	return -ENODEV;;
+	return -ENODEV;
 }
 
 module_init(umc8672_init);
-- 
1.6.3.1.10.g659a0.dirty

