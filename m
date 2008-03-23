Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbYCWJDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbYCWJDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760289AbYCWIMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:17 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2363 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760223AbYCWIL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:59 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 077/148] include/asm-x86/mtrr.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:52 -0700
Message-Id: <1206259443-13210-78-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mtrr.h |   64 ++++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/include/asm-x86/mtrr.h b/include/asm-x86/mtrr.h
index ee17229..7877f46 100644
--- a/include/asm-x86/mtrr.h
+++ b/include/asm-x86/mtrr.h
@@ -28,8 +28,7 @@
 
 #define	MTRR_IOCTL_BASE	'M'
 
-struct mtrr_sentry
-{
+struct mtrr_sentry {
     unsigned long base;    /*  Base address     */
     unsigned int size;    /*  Size of region   */
     unsigned int type;     /*  Type of region   */
@@ -41,8 +40,7 @@ struct mtrr_sentry
    will break. */
 
 #ifdef __i386__
-struct mtrr_gentry
-{
+struct mtrr_gentry {
     unsigned int regnum;   /*  Register number  */
     unsigned long base;    /*  Base address     */
     unsigned int size;    /*  Size of region   */
@@ -51,8 +49,7 @@ struct mtrr_gentry
 
 #else /* __i386__ */
 
-struct mtrr_gentry
-{
+struct mtrr_gentry {
     unsigned long base;    /*  Base address     */
     unsigned int size;    /*  Size of region   */
     unsigned int regnum;   /*  Register number  */
@@ -89,12 +86,12 @@ struct mtrr_gentry
 extern u8 mtrr_type_lookup(u64 addr, u64 end);
 extern void mtrr_save_fixed_ranges(void *);
 extern void mtrr_save_state(void);
-extern int mtrr_add (unsigned long base, unsigned long size,
-		     unsigned int type, bool increment);
-extern int mtrr_add_page (unsigned long base, unsigned long size,
-		     unsigned int type, bool increment);
-extern int mtrr_del (int reg, unsigned long base, unsigned long size);
-extern int mtrr_del_page (int reg, unsigned long base, unsigned long size);
+extern int mtrr_add(unsigned long base, unsigned long size,
+		    unsigned int type, bool increment);
+extern int mtrr_add_page(unsigned long base, unsigned long size,
+			 unsigned int type, bool increment);
+extern int mtrr_del(int reg, unsigned long base, unsigned long size);
+extern int mtrr_del_page(int reg, unsigned long base, unsigned long size);
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
@@ -109,23 +106,21 @@ static inline u8 mtrr_type_lookup(u64 addr, u64 end)
 }
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
 #define mtrr_save_state() do {} while (0)
-static __inline__ int mtrr_add (unsigned long base, unsigned long size,
-				unsigned int type, bool increment)
+static inline int mtrr_add(unsigned long base, unsigned long size,
+			   unsigned int type, bool increment)
 {
     return -ENODEV;
 }
-static __inline__ int mtrr_add_page (unsigned long base, unsigned long size,
+static inline int mtrr_add_page(unsigned long base, unsigned long size,
 				unsigned int type, bool increment)
 {
     return -ENODEV;
 }
-static __inline__ int mtrr_del (int reg, unsigned long base,
-				unsigned long size)
+static inline int mtrr_del(int reg, unsigned long base, unsigned long size)
 {
     return -ENODEV;
 }
-static __inline__ int mtrr_del_page (int reg, unsigned long base,
-				unsigned long size)
+static inline int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 {
     return -ENODEV;
 }
@@ -133,7 +128,9 @@ static inline int mtrr_trim_uncached_memory(unsigned long end_pfn)
 {
 	return 0;
 }
-static __inline__ void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi) {;}
+static inline void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi)
+{
+}
 
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
@@ -142,15 +139,13 @@ static __inline__ void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi) {;}
 #ifdef CONFIG_COMPAT
 #include <linux/compat.h>
 
-struct mtrr_sentry32
-{
+struct mtrr_sentry32 {
     compat_ulong_t base;    /*  Base address     */
     compat_uint_t size;    /*  Size of region   */
     compat_uint_t type;     /*  Type of region   */
 };
 
-struct mtrr_gentry32
-{
+struct mtrr_gentry32 {
     compat_ulong_t regnum;   /*  Register number  */
     compat_uint_t base;    /*  Base address     */
     compat_uint_t size;    /*  Size of region   */
@@ -159,16 +154,17 @@ struct mtrr_gentry32
 
 #define MTRR_IOCTL_BASE 'M'
 
-#define MTRRIOC32_ADD_ENTRY        _IOW(MTRR_IOCTL_BASE,  0, struct mtrr_sentry32)
-#define MTRRIOC32_SET_ENTRY        _IOW(MTRR_IOCTL_BASE,  1, struct mtrr_sentry32)
-#define MTRRIOC32_DEL_ENTRY        _IOW(MTRR_IOCTL_BASE,  2, struct mtrr_sentry32)
-#define MTRRIOC32_GET_ENTRY        _IOWR(MTRR_IOCTL_BASE, 3, struct mtrr_gentry32)
-#define MTRRIOC32_KILL_ENTRY       _IOW(MTRR_IOCTL_BASE,  4, struct mtrr_sentry32)
-#define MTRRIOC32_ADD_PAGE_ENTRY   _IOW(MTRR_IOCTL_BASE,  5, struct mtrr_sentry32)
-#define MTRRIOC32_SET_PAGE_ENTRY   _IOW(MTRR_IOCTL_BASE,  6, struct mtrr_sentry32)
-#define MTRRIOC32_DEL_PAGE_ENTRY   _IOW(MTRR_IOCTL_BASE,  7, struct mtrr_sentry32)
-#define MTRRIOC32_GET_PAGE_ENTRY   _IOWR(MTRR_IOCTL_BASE, 8, struct mtrr_gentry32)
-#define MTRRIOC32_KILL_PAGE_ENTRY  _IOW(MTRR_IOCTL_BASE,  9, struct mtrr_sentry32)
+#define MTRRIOC32_ADD_ENTRY      _IOW(MTRR_IOCTL_BASE,  0, struct mtrr_sentry32)
+#define MTRRIOC32_SET_ENTRY      _IOW(MTRR_IOCTL_BASE,  1, struct mtrr_sentry32)
+#define MTRRIOC32_DEL_ENTRY      _IOW(MTRR_IOCTL_BASE,  2, struct mtrr_sentry32)
+#define MTRRIOC32_GET_ENTRY      _IOWR(MTRR_IOCTL_BASE, 3, struct mtrr_gentry32)
+#define MTRRIOC32_KILL_ENTRY     _IOW(MTRR_IOCTL_BASE,  4, struct mtrr_sentry32)
+#define MTRRIOC32_ADD_PAGE_ENTRY _IOW(MTRR_IOCTL_BASE,  5, struct mtrr_sentry32)
+#define MTRRIOC32_SET_PAGE_ENTRY _IOW(MTRR_IOCTL_BASE,  6, struct mtrr_sentry32)
+#define MTRRIOC32_DEL_PAGE_ENTRY _IOW(MTRR_IOCTL_BASE,  7, struct mtrr_sentry32)
+#define MTRRIOC32_GET_PAGE_ENTRY _IOWR(MTRR_IOCTL_BASE, 8, struct mtrr_gentry32)
+#define MTRRIOC32_KILL_PAGE_ENTRY		\
+				 _IOW(MTRR_IOCTL_BASE,  9, struct mtrr_sentry32)
 #endif /* CONFIG_COMPAT */
 
 #endif /* __KERNEL__ */
-- 
1.5.4.rc2

