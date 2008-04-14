Return-Path: <linux-kernel-owner+w=401wt.eu-S1765437AbYDNSP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765437AbYDNSP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764997AbYDNSOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:14:41 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56877 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764985AbYDNSOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:14:40 -0400
Date: Mon, 14 Apr 2008 21:13:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper pid{hash,map}_init() prototypes
Message-ID: <20080414181334.GF6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper prototypes for pid{hash,map}_init() in 
include/linux/pid_namespace.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 22 Feb 2008

 include/linux/pid_namespace.h |    3 +++
 init/main.c                   |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

279d377cacc55d031230ed98370726dbd8c82602 diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index fcd61fa..2ce9521 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -85,4 +85,7 @@ static inline struct task_struct *task_child_reaper(struct task_struct *tsk)
 	return tsk->nsproxy->pid_ns->child_reaper;
 }
 
+void pidhash_init(void);
+void pidmap_init(void);
+
 #endif /* _LINUX_PID_NS_H */
diff --git a/init/main.c b/init/main.c
index 7dd9916..696e5f1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -84,8 +84,6 @@ extern void init_IRQ(void);
 extern void fork_init(unsigned long);
 extern void mca_init(void);
 extern void sbus_init(void);
-extern void pidhash_init(void);
-extern void pidmap_init(void);
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
 extern void free_initmem(void);

