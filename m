Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYJVRsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYJVRsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYJVRgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:36:50 -0400
Received: from kroah.org ([198.145.64.141]:50466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758149AbYJVRgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:36:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 41/42] Staging: me4000: remove some compiler warnings
Date: Wed, 22 Oct 2008 10:29:22 -0700
Message-Id: <1224696563-5170-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/me4000/me4000.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index 75c268c..0b33773 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -6017,14 +6017,14 @@ static int me4000_read_procmem(char *buf, char **start, off_t offset, int count,
 		    sprintf(buf + len, "PLX base register = 0x%lX\n",
 			    board_info->plx_regbase);
 		len +=
-		    sprintf(buf + len, "PLX base register size = 0x%lX\n",
-			    board_info->plx_regbase_size);
+		    sprintf(buf + len, "PLX base register size = 0x%X\n",
+			    (unsigned int)board_info->plx_regbase_size);
 		len +=
-		    sprintf(buf + len, "ME4000 base register = 0x%lX\n",
-			    board_info->me4000_regbase);
+		    sprintf(buf + len, "ME4000 base register = 0x%X\n",
+			    (unsigned int)board_info->me4000_regbase);
 		len +=
-		    sprintf(buf + len, "ME4000 base register size = 0x%lX\n",
-			    board_info->me4000_regbase_size);
+		    sprintf(buf + len, "ME4000 base register size = 0x%X\n",
+			    (unsigned int)board_info->me4000_regbase_size);
 		len +=
 		    sprintf(buf + len, "Serial number = 0x%X\n",
 			    board_info->serial_no);
-- 
1.6.0.2

