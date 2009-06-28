Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZF1Qgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZF1Qgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZF1Q2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1146 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009AbZF1Q1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:54 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 39/62] drivers/s390/block/dasd_eckd.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:44 -0700
Message-Id: <553faa06257c375a83e55f40f0a3ed48c49b9f17.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/block/dasd_eckd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index f8b1f04..dd45277 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -706,7 +706,7 @@ static int dasd_eckd_generate_uid(struct dasd_device *device,
 	       sizeof(uid->serial) - 1);
 	EBCASC(uid->serial, sizeof(uid->serial) - 1);
 	uid->ssid = private->gneq->subsystemID;
-	uid->real_unit_addr = private->ned->unit_addr;;
+	uid->real_unit_addr = private->ned->unit_addr;
 	if (private->sneq) {
 		uid->type = private->sneq->sua_flags;
 		if (uid->type == UA_BASE_PAV_ALIAS)
-- 
1.6.3.1.10.g659a0.dirty

