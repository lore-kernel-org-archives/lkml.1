Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbXKKGtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbXKKGtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 01:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbXKKGsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 01:48:43 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32857 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039AbXKKGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 01:48:42 -0500
Date: Sun, 11 Nov 2007 07:48:18 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/linux/sysctl.h: remove empty #else
Message-ID: <20071111064818.GE21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an empty #else.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8e3fb6d59ceb3fbb853c0d74f1aa0a73de90af97 
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index e99171f..4c1694d 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1070,8 +1070,6 @@ struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
 void unregister_sysctl_table(struct ctl_table_header * table);
 int sysctl_check_table(struct ctl_table *table);
 
-#else /* __KERNEL__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SYSCTL_H */

