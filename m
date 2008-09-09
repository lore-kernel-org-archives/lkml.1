Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbYIJEIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbYIJEIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 00:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYIJEH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 00:07:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:51029 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYIJEHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 00:07:55 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
Date: Tue,  9 Sep 2008 14:07:41 -0700
Message-Id: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the warning by initializing 'rc' to zero.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/ide/ide-probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 994e410..e53c645 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1492,7 +1492,7 @@ static struct device_attribute *ide_port_attrs[] = {
 
 static int ide_sysfs_register_port(ide_hwif_t *hwif)
 {
-	int i, rc;
+	int i, rc = 0;
 
 	for (i = 0; ide_port_attrs[i]; i++) {
 		rc = device_create_file(hwif->portdev, ide_port_attrs[i]);
-- 
1.6.0.1

