Return-Path: <linux-kernel-owner+w=401wt.eu-S1946590AbXBIQFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946590AbXBIQFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946569AbXBIQFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53626 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946566AbXBIQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:17 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] assigning enum constant to char * is vile, even if it happens to be 0
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYFR-0004r1-0e@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/lkdtm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index db9d7df..552b795 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -108,8 +108,8 @@ static struct jprobe lkdtm;
 static int lkdtm_parse_commandline(void);
 static void lkdtm_handler(void);
 
-static char* cpoint_name = INVALID;
-static char* cpoint_type = NONE;
+static char* cpoint_name;
+static char* cpoint_type;
 static int cpoint_count = DEFAULT_COUNT;
 static int recur_count = REC_NUM_DEFAULT;
 
-- 
1.5.0-rc2.GIT


