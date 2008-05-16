Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbYEPOnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbYEPOnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYEPOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:42:07 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49185 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYEPOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:41:59 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 60/67] aufs debug print functions, header
Date: Fri, 16 May 2008 23:33:14 +0900
Message-Id: <12109484022031-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484021382-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	initial commit
	aufs debug print functions, header

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/debug.h |  210 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 210 insertions(+), 0 deletions(-)

diff --git a/fs/aufs/debug.h b/fs/aufs/debug.h
new file mode 100644
index 0000000..5e723a0
--- /dev/null
+++ b/fs/aufs/debug.h
@@ -0,0 +1,210 @@
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
+ * debug print functions
+ *
+ * $Id: debug.h,v 1.2 2008/04/21 02:00:37 sfjro Exp $
+ */
+
+#ifndef __AUFS_DEBUG_H__
+#define __AUFS_DEBUG_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+
+/* to debug easier, do not make it an inlined function */
+#define MtxMustLock(mtx)	AuDebugOn(!mutex_is_locked(mtx))
+
+#ifdef CONFIG_AUFS_DEBUG
+/* sparse warns about pointer */
+#define AuDebugOn(a)		BUG_ON(!!(a))
+extern atomic_t au_cond;
+#define au_debug_on()		atomic_inc_return(&au_cond)
+#define au_debug_off()		atomic_dec_return(&au_cond)
+static inline int au_debug_test(void)
+{
+	return atomic_read(&au_cond);
+}
+#else
+#define AuDebugOn(a)		do {} while (0)
+#define au_debug_on()		do {} while (0)
+#define au_debug_off()		do {} while (0)
+static inline int au_debug_test(void)
+{
+	return 0;
+}
+#endif /* CONFIG_AUFS_DEBUG */
+
+/* ---------------------------------------------------------------------- */
+
+/* debug print */
+#if defined(CONFIG_LKTR) || defined(CONFIG_LKTR_MODULE)
+#include <linux/lktr.h>
+#ifdef CONFIG_AUFS_DEBUG
+#undef LktrCond
+#define LktrCond	unlikely(au_debug_test() || (lktr_cond && lktr_cond()))
+#endif
+#else
+#define LktrCond			au_debug_test()
+#define LKTRDumpVma(pre, vma, suf)	do {} while (0)
+#define LKTRDumpStack()			do {} while (0)
+#define LKTRTrace(fmt, args...) do { \
+	if (LktrCond) \
+		AuDbg(fmt, ##args); \
+} while (0)
+#define LKTRLabel(label)		LKTRTrace("%s\n", #label)
+#endif /* CONFIG_LKTR */
+
+#define AuTraceErr(e) do { \
+	if (unlikely((e) < 0)) \
+		LKTRTrace("err %d\n", (int)(e)); \
+} while (0)
+
+#define AuTraceErrPtr(p) do { \
+	if (IS_ERR(p)) \
+		LKTRTrace("err %ld\n", PTR_ERR(p)); \
+} while (0)
+
+#define AuTraceEnter()	LKTRLabel(enter)
+
+/* dirty macros for debug print, use with "%.*s" and caution */
+#define AuLNPair(qstr)		(qstr)->len, (qstr)->name
+#define AuDLNPair(d)		AuLNPair(&(d)->d_name)
+
+/* ---------------------------------------------------------------------- */
+
+#define AuDpri(lvl, fmt, arg...) \
+	printk(lvl AUFS_NAME " %s:%d:%s[%d]: " fmt, \
+	       __func__, __LINE__, current->comm, current->pid, ##arg)
+#define AuDbg(fmt, arg...)	AuDpri(KERN_DEBUG, fmt, ##arg)
+#define AuInfo(fmt, arg...)	AuDpri(KERN_INFO, fmt, ##arg)
+#define AuWarn(fmt, arg...)	AuDpri(KERN_WARNING, fmt, ##arg)
+#define AuErr(fmt, arg...)	AuDpri(KERN_ERR, fmt, ##arg)
+#define AuIOErr(fmt, arg...)	AuErr("I/O Error, " fmt, ##arg)
+#define AuIOErrWhck(fmt, arg...) AuErr("I/O Error, try whck. " fmt, ##arg)
+#define AuWarn1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) AuWarn(fmt, ##arg); \
+} while (0)
+
+#define AuErr1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) AuErr(fmt, ##arg); \
+} while (0)
+
+#define AuIOErr1(fmt, arg...) do { \
+	static unsigned char _c; \
+	if (!_c++) AuIOErr(fmt, ##arg); \
+} while (0)
+
+#define AuUnsupportMsg	"This operation is not supported." \
+			" Please report this application to aufs-users ML."
+#define AuUnsupport(fmt, args...) do { \
+	AuErr(AuUnsupportMsg "\n" fmt, ##args); \
+	dump_stack(); \
+} while (0)
+
+/* ---------------------------------------------------------------------- */
+
+struct au_sbinfo;
+#ifdef CONFIG_AUFS_DEBUG
+extern char *au_plevel;
+struct au_nhash;
+void au_dpri_whlist(struct au_nhash *whlist);
+struct au_vdir;
+void au_dpri_vdir(struct au_vdir *vdir);
+void au_dpri_inode(struct inode *inode);
+void au_dpri_dentry(struct dentry *dentry);
+void au_dpri_file(struct file *filp);
+void au_dpri_sb(struct super_block *sb);
+void au_dbg_sleep(int sec);
+int __init au_debug_init(void);
+void au_debug_sbinfo_init(struct au_sbinfo *sbinfo);
+#define AuDbgWhlist(w) do { \
+	LKTRTrace(#w "\n"); \
+	au_dpri_whlist(w); \
+} while (0)
+
+#define AuDbgVdir(v) do { \
+	LKTRTrace(#v "\n"); \
+	au_dpri_vdir(v); \
+} while (0)
+
+#define AuDbgInode(i) do { \
+	LKTRTrace(#i "\n"); \
+	au_dpri_inode(i); \
+} while (0)
+
+#define AuDbgDentry(d) do { \
+	LKTRTrace(#d "\n"); \
+	au_dpri_dentry(d); \
+} while (0)
+
+#define AuDbgFile(f) do { \
+	LKTRTrace(#f "\n"); \
+	au_dpri_file(f); \
+} while (0)
+
+#define AuDbgSb(sb) do { \
+	LKTRTrace(#sb "\n"); \
+	au_dpri_sb(sb); \
+} while (0)
+
+#define AuDbgSleep(sec) do { \
+	AuDbg("sleep %d sec\n", sec); \
+	au_dbg_sleep(sec); \
+} while (0)
+#else
+static inline int au_debug_init(void)
+{
+	return 0;
+}
+static inline void au_debug_sbinfo_init(struct au_sbinfo *sbinfo)
+{
+	/* empty */
+}
+#define AuDbgWhlist(w)		do {} while (0)
+#define AuDbgVdir(v)		do {} while (0)
+#define AuDbgInode(i)		do {} while (0)
+#define AuDbgDentry(d)		do {} while (0)
+#define AuDbgFile(f)		do {} while (0)
+#define AuDbgSb(sb)		do {} while (0)
+#define AuDbgSleep(sec)		do {} while (0)
+#endif /* CONFIG_AUFS_DEBUG */
+
+#ifdef DbgUdbaRace
+#define AuDbgSleep_UdbaRace()	AuDbgSleep(DbgUdbaRace)
+#else
+#define AuDbgSleep_UdbaRace()	do {} while (0)
+#endif
+
+#ifdef CONFIG_AUFS_MAGIC_SYSRQ
+int __init au_sysrq_init(void);
+void au_sysrq_fin(void);
+#else
+static inline int au_sysrq_init(void)
+{
+	return 0;
+}
+#define au_sysrq_fin()		do {} while (0)
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_DEBUG_H__ */
-- 
1.4.4.4

