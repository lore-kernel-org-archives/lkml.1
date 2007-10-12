Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbXJLWvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbXJLWvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932665AbXJLWV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:59 -0400
Received: from ns.suse.de ([195.135.220.2]:53479 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818AbXJLWV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/75] sysfs: clean up header files
Date: Fri, 12 Oct 2007 15:16:59 -0700
Message-Id: <11922276993289-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227695547-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs is about to go through major overhaul making this a pretty good
opportunity to clean up (out-of-tree changes and pending patches will
need regeneration anyway).  Clean up headers.

* Kill space between * and symbolname.

* Move SYSFS_* type constants and flags into fs/sysfs/sysfs.h.
  They're internal to sysfs.

* Reformat function prototypes and add argument symbol names.

* Make dummy function definition order match that of function
  prototypes.

* Add some comments.

* Reorganize fs/sysfs/sysfs.h according to which file the declared
  variable or feature lives in.

This patch does not introduce any behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/sysfs.h      |  148 ++++++++++++++++++++++++++++++------------------
 include/linux/sysfs.h |  127 +++++++++++++++++++-----------------------
 2 files changed, 149 insertions(+), 126 deletions(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 791b3ed..63adbec 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,20 +1,24 @@
+/* type-specific structures for sysfs_dirent->s_* union members */
 struct sysfs_elem_dir {
-	struct kobject		* kobj;
+	struct kobject		*kobj;
 };
 
 struct sysfs_elem_symlink {
-	struct sysfs_dirent	* target_sd;
+	struct sysfs_dirent	*target_sd;
 };
 
 struct sysfs_elem_attr {
-	struct attribute	* attr;
+	struct attribute	*attr;
 };
 
 struct sysfs_elem_bin_attr {
-	struct bin_attribute	* bin_attr;
+	struct bin_attribute	*bin_attr;
 };
 
 /*
+ * sysfs_dirent - the building block of sysfs hierarchy.  Each and
+ * every sysfs node is represented by single sysfs_dirent.
+ *
  * As long as s_count reference is held, the sysfs_dirent itself is
  * accessible.  Dereferencing s_elem or any other outer entity
  * requires s_active reference.
@@ -22,10 +26,10 @@ struct sysfs_elem_bin_attr {
 struct sysfs_dirent {
 	atomic_t		s_count;
 	atomic_t		s_active;
-	struct sysfs_dirent	* s_parent;
-	struct sysfs_dirent	* s_sibling;
-	struct sysfs_dirent	* s_children;
-	const char		* s_name;
+	struct sysfs_dirent	*s_parent;
+	struct sysfs_dirent	*s_sibling;
+	struct sysfs_dirent	*s_children;
+	const char		*s_name;
 
 	union {
 		struct sysfs_elem_dir		dir;
@@ -37,12 +41,31 @@ struct sysfs_dirent {
 	unsigned int		s_flags;
 	umode_t			s_mode;
 	ino_t			s_ino;
-	struct iattr		* s_iattr;
+	struct iattr		*s_iattr;
 	atomic_t		s_event;
 };
 
-#define SD_DEACTIVATED_BIAS	INT_MIN
+#define SD_DEACTIVATED_BIAS		INT_MIN
 
+#define SYSFS_TYPE_MASK			0x00ff
+#define SYSFS_ROOT			0x0001
+#define SYSFS_DIR			0x0002
+#define SYSFS_KOBJ_ATTR			0x0004
+#define SYSFS_KOBJ_BIN_ATTR		0x0008
+#define SYSFS_KOBJ_LINK			0x0020
+#define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
+
+#define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_REMOVED		0x0200
+
+static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
+{
+	return sd->s_flags & SYSFS_TYPE_MASK;
+}
+
+/*
+ * Context structure to be used while adding/removing nodes.
+ */
 struct sysfs_addrm_cxt {
 	struct sysfs_dirent	*parent_sd;
 	struct inode		*parent_inode;
@@ -50,59 +73,47 @@ struct sysfs_addrm_cxt {
 	int			cnt;
 };
 
+/*
+ * mount.c
+ */
 extern struct sysfs_dirent sysfs_root;
+extern struct super_block *sysfs_sb;
 extern struct kmem_cache *sysfs_dir_cachep;
 
-extern struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
-extern struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
-extern void sysfs_put_active(struct sysfs_dirent *sd);
-extern struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
-extern void sysfs_put_active_two(struct sysfs_dirent *sd);
-extern void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
-			      struct sysfs_dirent *parent_sd);
-extern int sysfs_add_one(struct sysfs_addrm_cxt *acxt,
-			  struct sysfs_dirent *sd);
-extern void sysfs_remove_one(struct sysfs_addrm_cxt *acxt,
-			     struct sysfs_dirent *sd);
-extern void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
-
-extern struct inode * sysfs_get_inode(struct sysfs_dirent *sd);
-
-extern void release_sysfs_dirent(struct sysfs_dirent * sd);
-extern struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
-					      const unsigned char *name);
-extern struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
-					     const unsigned char *name);
-extern struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode,
-					     int type);
-
-extern int sysfs_add_file(struct sysfs_dirent *dir_sd,
-			  const struct attribute *attr, int type);
-extern int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
-extern struct sysfs_dirent *sysfs_find(struct sysfs_dirent *dir, const char * name);
-
-extern int sysfs_create_subdir(struct kobject *kobj, const char *name,
-			       struct sysfs_dirent **p_sd);
-extern void sysfs_remove_subdir(struct sysfs_dirent *sd);
-
-extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
-
-extern spinlock_t sysfs_assoc_lock;
+/*
+ * dir.c
+ */
 extern struct mutex sysfs_mutex;
 extern struct mutex sysfs_rename_mutex;
-extern struct super_block * sysfs_sb;
+extern spinlock_t sysfs_assoc_lock;
+
 extern const struct file_operations sysfs_dir_operations;
-extern const struct file_operations sysfs_file_operations;
-extern const struct file_operations bin_fops;
 extern const struct inode_operations sysfs_dir_inode_operations;
-extern const struct inode_operations sysfs_symlink_inode_operations;
 
-static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
-{
-	return sd->s_flags & SYSFS_TYPE_MASK;
-}
-
-static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
+struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
+struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
+void sysfs_put_active(struct sysfs_dirent *sd);
+struct sysfs_dirent *sysfs_get_active_two(struct sysfs_dirent *sd);
+void sysfs_put_active_two(struct sysfs_dirent *sd);
+void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
+		       struct sysfs_dirent *parent_sd);
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
+void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd);
+void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
+
+struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
+				       const unsigned char *name);
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name);
+struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type);
+
+void release_sysfs_dirent(struct sysfs_dirent *sd);
+
+int sysfs_create_subdir(struct kobject *kobj, const char *name,
+			struct sysfs_dirent **p_sd);
+void sysfs_remove_subdir(struct sysfs_dirent *sd);
+
+static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
 		WARN_ON(!atomic_read(&sd->s_count));
@@ -111,8 +122,33 @@ static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 	return sd;
 }
 
-static inline void sysfs_put(struct sysfs_dirent * sd)
+static inline void sysfs_put(struct sysfs_dirent *sd)
 {
 	if (sd && atomic_dec_and_test(&sd->s_count))
 		release_sysfs_dirent(sd);
 }
+
+/*
+ * inode.c
+ */
+struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
+int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
+
+/*
+ * file.c
+ */
+extern const struct file_operations sysfs_file_operations;
+
+int sysfs_add_file(struct sysfs_dirent *dir_sd,
+		   const struct attribute *attr, int type);
+
+/*
+ * bin.c
+ */
+extern const struct file_operations bin_fops;
+
+/*
+ * symlink.c
+ */
+extern const struct inode_operations sysfs_symlink_inode_operations;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index c16e4c5..b393bb4 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -23,14 +23,14 @@ struct module;
  * until the tree gets cleaned up fully.
  */
 struct attribute {
-	const char		* name;
-	struct module		* owner;
+	const char		*name;
+	struct module		*owner;
 	mode_t			mode;
 };
 
 struct attribute_group {
-	const char		* name;
-	struct attribute	** attrs;
+	const char		*name;
+	struct attribute	**attrs;
 };
 
 
@@ -74,65 +74,43 @@ struct sysfs_ops {
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
 };
 
-#define SYSFS_TYPE_MASK		0x00ff
-#define SYSFS_ROOT		0x0001
-#define SYSFS_DIR		0x0002
-#define SYSFS_KOBJ_ATTR 	0x0004
-#define SYSFS_KOBJ_BIN_ATTR	0x0008
-#define SYSFS_KOBJ_LINK 	0x0020
-#define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
-
-#define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
-#define SYSFS_FLAG_REMOVED	0x0100
-
 #ifdef CONFIG_SYSFS
 
-extern int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data, struct module *owner);
-
-extern int __must_check
-sysfs_create_dir(struct kobject *);
-
-extern void
-sysfs_remove_dir(struct kobject *);
-
-extern int __must_check
-sysfs_rename_dir(struct kobject *kobj, const char *new_name);
-
-extern int __must_check
-sysfs_move_dir(struct kobject *, struct kobject *);
-
-extern int __must_check
-sysfs_create_file(struct kobject *, const struct attribute *);
-
-extern int __must_check
-sysfs_update_file(struct kobject *, const struct attribute *);
+int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
+			    void *data, struct module *owner);
 
-extern int __must_check
-sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode);
+int __must_check sysfs_create_dir(struct kobject *kobj);
+void sysfs_remove_dir(struct kobject *kobj);
+int __must_check sysfs_rename_dir(struct kobject *kobj, const char *new_name);
+int __must_check sysfs_move_dir(struct kobject *kobj,
+				struct kobject *new_parent_kobj);
 
-extern void
-sysfs_remove_file(struct kobject *, const struct attribute *);
-
-extern int __must_check
-sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * name);
-
-extern void
-sysfs_remove_link(struct kobject *, const char * name);
+int __must_check sysfs_create_file(struct kobject *kobj,
+				   const struct attribute *attr);
+int __must_check sysfs_update_file(struct kobject *kobj,
+				   const struct attribute *attr);
+int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
+				  mode_t mode);
+void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
 
 int __must_check sysfs_create_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr);
+				       struct bin_attribute *attr);
 void sysfs_remove_bin_file(struct kobject *kobj, struct bin_attribute *attr);
 
-int __must_check sysfs_create_group(struct kobject *,
-					const struct attribute_group *);
-void sysfs_remove_group(struct kobject *, const struct attribute_group *);
+int __must_check sysfs_create_link(struct kobject *kobj, struct kobject *target,
+				   const char *name);
+void sysfs_remove_link(struct kobject *kobj, const char *name);
+
+int __must_check sysfs_create_group(struct kobject *kobj,
+				    const struct attribute_group *grp);
+void sysfs_remove_group(struct kobject *kobj,
+			const struct attribute_group *grp);
 int sysfs_add_file_to_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group);
+			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group);
+			const struct attribute *attr, const char *group);
 
-void sysfs_notify(struct kobject * k, char *dir, char *attr);
+void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
 
 extern int __must_check sysfs_init(void);
 
@@ -144,72 +122,81 @@ static inline int sysfs_schedule_callback(struct kobject *kobj,
 	return -ENOSYS;
 }
 
-static inline int sysfs_create_dir(struct kobject * kobj)
+static inline int sysfs_create_dir(struct kobject *kobj)
 {
 	return 0;
 }
 
-static inline void sysfs_remove_dir(struct kobject * k)
+static inline void sysfs_remove_dir(struct kobject *kobj)
 {
 	;
 }
 
-static inline int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
+static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
 {
 	return 0;
 }
 
-static inline int sysfs_move_dir(struct kobject * k, struct kobject * new_parent)
+static inline int sysfs_move_dir(struct kobject *kobj,
+				 struct kobject *new_parent_kobj)
 {
 	return 0;
 }
 
-static inline int sysfs_create_file(struct kobject * k, const struct attribute * a)
+static inline int sysfs_create_file(struct kobject *kobj,
+				    const struct attribute *attr)
 {
 	return 0;
 }
 
-static inline int sysfs_update_file(struct kobject * k, const struct attribute * a)
+static inline int sysfs_update_file(struct kobject *kobj,
+				    const struct attribute *attr)
 {
 	return 0;
 }
-static inline int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
+static inline int sysfs_chmod_file(struct kobject *kobj,
+				   struct attribute *attr, mode_t mode)
 {
 	return 0;
 }
 
-static inline void sysfs_remove_file(struct kobject * k, const struct attribute * a)
+static inline void sysfs_remove_file(struct kobject *kobj,
+				     const struct attribute *attr)
 {
 	;
 }
 
-static inline int sysfs_create_link(struct kobject * k, struct kobject * t, const char * n)
+static inline int sysfs_create_bin_file(struct kobject *kobj,
+					struct bin_attribute *attr)
 {
 	return 0;
 }
 
-static inline void sysfs_remove_link(struct kobject * k, const char * name)
+static inline int sysfs_remove_bin_file(struct kobject *kobj,
+					struct bin_attribute *attr)
 {
-	;
+	return 0;
 }
 
-
-static inline int sysfs_create_bin_file(struct kobject * k, struct bin_attribute * a)
+static inline int sysfs_create_link(struct kobject *kobj,
+				    struct kobject *target, const char *name)
 {
 	return 0;
 }
 
-static inline int sysfs_remove_bin_file(struct kobject * k, struct bin_attribute * a)
+static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
-	return 0;
+	;
 }
 
-static inline int sysfs_create_group(struct kobject * k, const struct attribute_group *g)
+static inline int sysfs_create_group(struct kobject *kobj,
+				     const struct attribute_group *grp)
 {
 	return 0;
 }
 
-static inline void sysfs_remove_group(struct kobject * k, const struct attribute_group * g)
+static inline void sysfs_remove_group(struct kobject *kobj,
+				      const struct attribute_group *grp)
 {
 	;
 }
@@ -225,7 +212,7 @@ static inline void sysfs_remove_file_from_group(struct kobject *kobj,
 {
 }
 
-static inline void sysfs_notify(struct kobject * k, char *dir, char *attr)
+static inline void sysfs_notify(struct kobject *kobj, char *dir, char *attr)
 {
 }
 
-- 
1.5.3.4

