Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYEPPJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYEPPJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbYEPOpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:45:54 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49192 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYEPOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:42:00 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 58/67] aufs misc functions, header
Date: Fri, 16 May 2008 23:33:12 +0900
Message-Id: <12109484023487-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1210948402783-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs misc functions, header

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/misc.h |  201 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 201 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/misc.h b/fs/aufs/misc.h
new file mode 100644
index 0000000..e57c398
--- /dev/null
+++ b/fs/aufs/misc.h
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) 2005-2008 Junjiro Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * $Id: misc.h,v 1.2 2008/04/21 01:33:00 sfjro Exp $
+ */
+
+#ifndef __AUFS_MISC_H__
+#define __AUFS_MISC_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/aufs_type.h>
+
+/* ---------------------------------------------------------------------- */
+
+typedef unsigned int au_gen_t;
+/* see linux/include/linux/jiffies.h */
+#define AuGenYounger(a, b)	((int)(b) - (int)(a) < 0)
+#define AuGenOlder(a, b)	AufsGenYounger(b, a)
+
+/* ---------------------------------------------------------------------- */
+
+struct au_rwsem {
+	struct rw_semaphore	rwsem;
+#ifdef CONFIG_AUFS_DEBUG
+	atomic_t		rcnt;
+#endif
+};
+
+#ifdef CONFIG_AUFS_DEBUG
+#define AuDbgRcntInit(rw) do { \
+	atomic_set(&(rw)->rcnt, 0); \
+	smp_mb(); \
+} while (0)
+
+#define AuDbgRcntInc(rw)	atomic_inc_return(&(rw)->rcnt)
+#define AuDbgRcntDec(rw)	WARN_ON(atomic_dec_return(&(rw)->rcnt) < 0)
+#else
+#define AuDbgRcntInit(rw)	do {} while (0)
+#define AuDbgRcntInc(rw)	do {} while (0)
+#define AuDbgRcntDec(rw)	do {} while (0)
+#endif /* CONFIG_AUFS_DEBUG */
+
+static inline void au_rw_init_nolock(struct au_rwsem *rw)
+{
+	AuDbgRcntInit(rw);
+	init_rwsem(&rw->rwsem);
+}
+
+static inline void au_rw_init_wlock(struct au_rwsem *rw)
+{
+	au_rw_init_nolock(rw);
+	down_write(&rw->rwsem);
+}
+
+static inline void au_rw_init_wlock_nested(struct au_rwsem *rw,
+					   unsigned int lsc)
+{
+	au_rw_init_nolock(rw);
+	down_write_nested(&rw->rwsem, lsc);
+}
+
+static inline void au_rw_read_lock(struct au_rwsem *rw)
+{
+	down_read(&rw->rwsem);
+	AuDbgRcntInc(rw);
+}
+
+static inline void au_rw_read_lock_nested(struct au_rwsem *rw, unsigned int lsc)
+{
+	down_read_nested(&rw->rwsem, lsc);
+	AuDbgRcntInc(rw);
+}
+
+static inline void au_rw_read_unlock(struct au_rwsem *rw)
+{
+	AuDbgRcntDec(rw);
+	up_read(&rw->rwsem);
+}
+
+static inline void au_rw_dgrade_lock(struct au_rwsem *rw)
+{
+	AuDbgRcntInc(rw);
+	downgrade_write(&rw->rwsem);
+}
+
+static inline void au_rw_write_lock(struct au_rwsem *rw)
+{
+	down_write(&rw->rwsem);
+}
+
+static inline void au_rw_write_lock_nested(struct au_rwsem *rw,
+					   unsigned int lsc)
+{
+	down_write_nested(&rw->rwsem, lsc);
+}
+
+static inline void au_rw_write_unlock(struct au_rwsem *rw)
+{
+	up_write(&rw->rwsem);
+}
+
+/* why is not _nested version defined */
+static inline int au_rw_read_trylock(struct au_rwsem *rw)
+{
+	int ret = down_read_trylock(&rw->rwsem);
+	if (ret)
+		AuDbgRcntInc(rw);
+	return ret;
+}
+
+static inline int au_rw_write_trylock(struct au_rwsem *rw)
+{
+	return down_write_trylock(&rw->rwsem);
+}
+
+#undef AuDbgRcntInit
+#undef AuDbgRcntInc
+#undef AuDbgRcntDec
+
+/* to debug easier, do not make them inlined functions */
+#define AuRwMustNoWaiters(rw)	AuDebugOn(!list_empty(&(rw)->rwsem.wait_list))
+#define AuRwMustAnyLock(rw)	AuDebugOn(down_write_trylock(&(rw)->rwsem))
+#ifdef CONFIG_AUFS_DEBUG
+#define AuRwMustReadLock(rw) do { \
+	AuRwMustAnyLock(rw); \
+	AuDebugOn(!atomic_read(&(rw)->rcnt)); \
+} while (0)
+
+#define AuRwMustWriteLock(rw) do { \
+	AuRwMustAnyLock(rw); \
+	AuDebugOn(atomic_read(&(rw)->rcnt)); \
+} while (0)
+#else
+#define AuRwMustReadLock(rw)	AuRwMustAnyLock(rw)
+#define AuRwMustWriteLock(rw)	AuRwMustAnyLock(rw)
+#endif /* CONFIG_AUFS_DEBUG */
+
+#define AuSimpleLockRwsemFuncs(prefix, param, rwsem) \
+static inline void prefix##_read_lock(param) \
+{ au_rw_read_lock(&(rwsem)); } \
+static inline void prefix##_write_lock(param) \
+{ au_rw_write_lock(&(rwsem)); } \
+static inline int prefix##_read_trylock(param) \
+{ return au_rw_read_trylock(&(rwsem)); } \
+static inline int prefix##_write_trylock(param) \
+{ return au_rw_write_trylock(&(rwsem)); }
+//static inline void prefix##_read_trylock_nested(param, lsc)
+//{au_rw_read_trylock_nested(&(rwsem, lsc));}
+//static inline void prefix##_write_trylock_nestd(param, lsc)
+//{au_rw_write_trylock_nested(&(rwsem), nested);}
+
+#define AuSimpleUnlockRwsemFuncs(prefix, param, rwsem) \
+static inline void prefix##_read_unlock(param) \
+{ au_rw_read_unlock(&(rwsem)); } \
+static inline void prefix##_write_unlock(param) \
+{ au_rw_write_unlock(&(rwsem)); } \
+static inline void prefix##_downgrade_lock(param) \
+{ au_rw_dgrade_lock(&(rwsem)); }
+
+#define AuSimpleRwsemFuncs(prefix, param, rwsem) \
+	AuSimpleLockRwsemFuncs(prefix, param, rwsem) \
+	AuSimpleUnlockRwsemFuncs(prefix, param, rwsem)
+
+/* ---------------------------------------------------------------------- */
+
+void *au_kzrealloc(void *p, unsigned int nused, unsigned int new_sz, gfp_t gfp);
+
+struct au_sbinfo;
+struct nameidata *au_dup_nd(struct au_sbinfo *sbinfo, struct nameidata *dst,
+			    struct nameidata *src);
+
+struct nameidata *au_fake_dm(struct nameidata *fake_nd, struct nameidata *nd,
+			     struct super_block *sb, aufs_bindex_t bindex);
+void au_fake_dm_release(struct nameidata *fake_nd);
+int au_h_create(struct inode *h_dir, struct dentry *h_dentry, int mode,
+		int dlgt, struct nameidata *nd, struct vfsmount *nfsmnt);
+
+int au_copy_file(struct file *dst, struct file *src, loff_t len,
+		 struct super_block *sb);
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_MISC_H__ */
-- 
1.4.4.4

