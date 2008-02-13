Return-Path: <linux-kernel-owner+w=401wt.eu-S934432AbYBMVvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbYBMVvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764562AbYBMVbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:50 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55771 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764313AbYBMVb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:29 -0500
Date: Wed, 13 Feb 2008 23:31:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] include/linux/sysctl.h: remove empty #else
Message-ID: <20080213213113.GV3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an empty #else.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 11 Nov 2007

097da305ddeef7e32d7fc6fac476aa76525c12f9 diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 571f01d..5432b34 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1085,8 +1085,6 @@ struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
 void unregister_sysctl_table(struct ctl_table_header * table);
 int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table);
 
-#else /* __KERNEL__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SYSCTL_H */
