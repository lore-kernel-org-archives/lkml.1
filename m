Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYJMEPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYJMEPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 00:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYJMEPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 00:15:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42143 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYJMEPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:15:30 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] i_version: remount support
Date: Mon, 13 Oct 2008 00:09:50 -0400
Message-Id: <d5d579e01cc14ca4c3efb04758dc3f4b9cf77a5d.1223870657.git.zohar@localhost.localdomain>
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
index 349d548..c1df981 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -136,7 +136,7 @@ extern int dir_notify_enable;
 /*
  * Superblock flags that can be altered by MS_REMOUNT
  */
-#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK)
+#define MS_RMT_MASK	(MS_RDONLY|MS_SYNCHRONOUS|MS_MANDLOCK|MS_I_VERSION)
 
 /*
  * Old magic mount flag and mask
-- 
1.5.5.1

