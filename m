Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbZF1QhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbZF1QhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZF1Q2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1151 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbZF1Q15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:57 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux390@de.ibm.com, Martin Peschke <mp3@de.ibm.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       linux-s390@vger.kernel.org
Subject: [PATCH 41/62] drivers/s390/scsi/zfcp_scsi.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:46 -0700
Message-Id: <2e6b8497e456ba1a86948d1850428a82cf137218.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/scsi/zfcp_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 967ede7..7db90da 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -101,7 +101,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 	if (unlikely((status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
 		     !(status & ZFCP_STATUS_COMMON_RUNNING))) {
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
-		return 0;;
+		return 0;
 	}
 
 	ret = zfcp_fsf_send_fcp_command_task(unit, scpnt);
-- 
1.6.3.1.10.g659a0.dirty

