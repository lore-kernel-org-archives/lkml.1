Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYJHRn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYJHRn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYJHRnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:43:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60046 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbYJHRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:43:20 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] i_version: remount support
Date: Wed,  8 Oct 2008 13:42:58 -0400
Message-Id: <6023f6ce96e8e25fc886b36899048652620f38fe.1223486174.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for remounting a filesystem with the i_version option.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 342922f..d6fadf9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -134,7 +134,7 @@ extern int dir_notify_enable;
 /*
  * Superblock flags that can be altered by MS_REMOUNT
  */
-#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK)
+#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK|MS_I_VERSION)
 
 /*
  * Old magic mount flag and mask
-- 
1.5.5.1

