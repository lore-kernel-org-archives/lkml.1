Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZBBQ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZBBQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 11:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZBBQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 11:56:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:56425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZBBQ45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 11:56:57 -0500
Subject: [git-pull -tip] fix headers_check warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 02 Feb 2009 22:26:05 +0530
Message-Id: <1233593765.3244.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

The following changes since commit 1ff8f739c7cc4eaa89b6ba986494f458ff7bdbef:
  Jaswinder Singh Rajput (1):
        headers_check fix: xtensa, swab.h

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tipclean.git core/header-fixes

Jaswinder Singh Rajput (7):
      headers_check fix: linux/coda_psdev.h
      headers_check fix: linux/in6.h
      headers_check fix: linux/nubus.h
      headers_check fix: linux/socket.h
      headers_check fix: linux/reinserfs_fs.h
      headers_check fix: x86, prctl.h
      headers_check fix: x86, setup.h

 arch/x86/include/asm/prctl.h |    6 +++-
 arch/x86/include/asm/setup.h |   45 ++++++++++++++++++++---------------------
 include/linux/coda_psdev.h   |   15 ++++++-------
 include/linux/in6.h          |    2 +-
 include/linux/nubus.h        |    2 +
 include/linux/reiserfs_fs.h  |    8 +++++++
 include/linux/socket.h       |    6 +++-
 7 files changed, 48 insertions(+), 36 deletions(-)

This patcset fixes 31 headers_check warnings:
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/coda_psdev.h:90: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/in6.h:47: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/in6.h:49: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nubus.h:296: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nubus.h:298: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/nubus.h:302: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/socket.h:29: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:687: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:995: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:997: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1467: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1760: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1764: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1766: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1769: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1771: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1805: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1948: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1949: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1950: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1951: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1962: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1963: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/linux/reiserfs_fs.h:1964: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/prctl.h:10: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/setup.h:16: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/setup.h:17: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/setup.h:23: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/setup.h:24: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/setup.h:51: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/setup.h:52: extern's make no sense in userspace

Complete diff:
diff --git a/arch/x86/include/asm/prctl.h b/arch/x86/include/asm/prctl.h
index a889464..fdbeb85 100644
--- a/arch/x86/include/asm/prctl.h
+++ b/arch/x86/include/asm/prctl.h
@@ -6,8 +6,10 @@
 #define ARCH_GET_FS 0x1003
 #define ARCH_GET_GS 0x1004
 
-#ifdef CONFIG_X86_64
+#ifdef __KERNEL__
+# ifdef CONFIG_X86_64
 extern long sys_arch_prctl(int, unsigned long);
-#endif /* CONFIG_X86_64 */
+# endif /* CONFIG_X86_64 */
+#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ebe858c..5a3a137 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -5,23 +5,6 @@
 
 #ifndef __ASSEMBLY__
 
-/* Interrupt control for vSMPowered x86_64 systems */
-void vsmp_init(void);
-
-
-void setup_bios_corruption_check(void);
-
-
-#ifdef CONFIG_X86_VISWS
-extern void visws_early_detect(void);
-extern int is_visws_box(void);
-#else
-static inline void visws_early_detect(void) { }
-static inline int is_visws_box(void) { return 0; }
-#endif
-
-extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
-extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
  */
@@ -48,12 +31,6 @@ struct x86_quirks {
 	int (*update_genapic)(void);
 };
 
-extern struct x86_quirks *x86_quirks;
-extern unsigned long saved_video_mode;
-
-#ifndef CONFIG_PARAVIRT
-#define paravirt_post_allocator_init()	do {} while (0)
-#endif
 #endif /* __ASSEMBLY__ */
 
 #ifdef __KERNEL__
@@ -78,6 +55,28 @@ extern unsigned long saved_video_mode;
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
 
+/* Interrupt control for vSMPowered x86_64 systems */
+void vsmp_init(void);
+
+void setup_bios_corruption_check(void);
+
+#ifdef CONFIG_X86_VISWS
+extern void visws_early_detect(void);
+extern int is_visws_box(void);
+#else
+static inline void visws_early_detect(void) { }
+static inline int is_visws_box(void) { return 0; }
+#endif
+
+extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
+extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
+extern struct x86_quirks *x86_quirks;
+extern unsigned long saved_video_mode;
+
+#ifndef CONFIG_PARAVIRT
+#define paravirt_post_allocator_init()	do {} while (0)
+#endif
+
 #ifndef _SETUP
 
 /*
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 07ae8f8..6f06352 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -24,7 +24,7 @@ static inline struct venus_comm *coda_vcp(struct super_block *sb)
 	return (struct venus_comm *)((sb)->s_fs_info);
 }
 
-
+#ifdef __KERNEL__
 /* upcalls */
 int venus_rootfid(struct super_block *sb, struct CodaFid *fidp);
 int venus_getattr(struct super_block *sb, struct CodaFid *fid,
@@ -64,6 +64,12 @@ int coda_downcall(int opcode, union outputArgs *out, struct super_block *sb);
 int venus_fsync(struct super_block *sb, struct CodaFid *fid);
 int venus_statfs(struct dentry *dentry, struct kstatfs *sfs);
 
+/*
+ * Statistics
+ */
+
+extern struct venus_comm coda_comms[];
+#endif /* __KERNEL__ */
 
 /* messages between coda filesystem in kernel and Venus */
 struct upc_req {
@@ -82,11 +88,4 @@ struct upc_req {
 #define REQ_WRITE  0x4
 #define REQ_ABORT  0x8
 
-
-/*
- * Statistics
- */
-
-extern struct venus_comm coda_comms[];
-
 #endif
diff --git a/include/linux/in6.h b/include/linux/in6.h
index bc49204..718bf21 100644
--- a/include/linux/in6.h
+++ b/include/linux/in6.h
@@ -44,11 +44,11 @@ struct in6_addr
  * NOTE: Be aware the IN6ADDR_* constants and in6addr_* externals are defined
  * in network byte order, not in host byte order as are the IPv4 equivalents
  */
+#ifdef __KERNEL__
 extern const struct in6_addr in6addr_any;
 #define IN6ADDR_ANY_INIT { { { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } } }
 extern const struct in6_addr in6addr_loopback;
 #define IN6ADDR_LOOPBACK_INIT { { { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 } } }
-#ifdef __KERNEL__
 extern const struct in6_addr in6addr_linklocal_allnodes;
 #define IN6ADDR_LINKLOCAL_ALLNODES_INIT	\
 		{ { { 0xff,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1 } } }
diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index 7382af3..9be57d9 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -296,6 +296,7 @@ struct nubus_dev {
 	struct nubus_board* board;
 };
 
+#ifdef __KERNEL__
 /* This is all NuBus devices (used to find devices later on) */
 extern struct nubus_dev* nubus_devices;
 /* This is all NuBus cards */
@@ -351,6 +352,7 @@ void nubus_get_rsrc_mem(void* dest,
 void nubus_get_rsrc_str(void* dest,
 			const struct nubus_dirent *dirent,
 			int maxlen);
+#endif /* __KERNEL__ */
 
 /* We'd like to get rid of this eventually.  Only daynaport.c uses it now. */
 static inline void *nubus_slot_addr(int slot)
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index bc5114d..a4db55f 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -698,7 +698,9 @@ static inline void cpu_key_k_offset_dec(struct cpu_key *key)
 /* object identifier for root dir */
 #define REISERFS_ROOT_OBJECTID 2
 #define REISERFS_ROOT_PARENT_OBJECTID 1
+#ifdef __KERNEL__
 extern struct reiserfs_key root_key;
+#endif /* __KERNEL__ */
 
 /* 
  * Picture represents a leaf of the S+tree
@@ -1006,10 +1008,12 @@ struct reiserfs_de_head {
 #define de_visible(deh)	    	    test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
 #define de_hidden(deh)	    	    !test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
 
+#ifdef __KERNEL__
 extern void make_empty_dir_item_v1(char *body, __le32 dirid, __le32 objid,
 				   __le32 par_dirid, __le32 par_objid);
 extern void make_empty_dir_item(char *body, __le32 dirid, __le32 objid,
 				__le32 par_dirid, __le32 par_objid);
+#endif /* __KERNEL__ */
 
 /* array of the entry headers */
  /* get item body */
@@ -1478,7 +1482,9 @@ struct item_operations {
 	void (*print_vi) (struct virtual_item * vi);
 };
 
+#ifdef __KERNEL__
 extern struct item_operations *item_ops[TYPE_ANY + 1];
+#endif /* __KERNEL__ */
 
 #define op_bytes_number(ih,bsize)                    item_ops[le_ih_k_type (ih)]->bytes_number (ih, bsize)
 #define op_is_left_mergeable(key,bsize)              item_ops[le_key_k_type (le_key_version (key), key)]->is_left_mergeable (key, bsize)
@@ -1679,6 +1685,7 @@ struct reiserfs_transaction_handle {
 	struct list_head t_list;
 };
 
+#ifdef __KERNEL__
 /* used to keep track of ordered and tail writes, attached to the buffer
  * head through b_journal_head.
  */
@@ -2203,4 +2210,5 @@ int reiserfs_unpack(struct inode *inode, struct file *filp);
 /* xattr stuff */
 #define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
 
+#endif /* __KERNEL__ */
 #endif				/* _LINUX_REISER_FS_H */
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 20fc4bb..afc0190 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -24,10 +24,12 @@ struct __kernel_sockaddr_storage {
 #include <linux/types.h>		/* pid_t			*/
 #include <linux/compiler.h>		/* __user			*/
 
-#ifdef CONFIG_PROC_FS
+#ifdef __KERNEL__
+# ifdef CONFIG_PROC_FS
 struct seq_file;
 extern void socket_seq_show(struct seq_file *seq);
-#endif
+# endif
+#endif /* __KERNEL__ */
 
 typedef unsigned short	sa_family_t;
 


