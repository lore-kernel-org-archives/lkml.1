Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbXLFPYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbXLFPYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXLFPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:24:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:35530 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXLFPYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:24:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=f/LHoxMmZm/j+ATmnlrvHHUAOC+yoYYJouyDSQg5sYcsPQlJi6JAWY7kw2pWWxqvWTrmQ3DQRyxL+VLdV1OUfed5T8pfY93h/aKeOFt1cQqSkJMRVloXqunjDwsmfZfuq4HVCCrLKw61+KhOYA4MEl5cMdZTTDHj8NomcvbNjss=
From: Denis Cheng <crquan@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/20] drivers/scsi/ipr.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 23:21:30 +0800
Message-Id: <1196954490-5516-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0841df0..9018ee8 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -84,7 +84,7 @@
 /*
  *   Global Data
  */
-static struct list_head ipr_ioa_head = LIST_HEAD_INIT(ipr_ioa_head);
+static LIST_HEAD(ipr_ioa_head);
 static unsigned int ipr_log_level = IPR_DEFAULT_LOG_LEVEL;
 static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
-- 
1.5.3.4

