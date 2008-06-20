Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbYFUAIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbYFUAIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 20:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbYFUAI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 20:08:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbYFUAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 20:08:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=Mlm9xhL3jUTXz3vPp/BKinNnsMEyg5xStVmCTq07aYmIV09On3tdWS5L93AfK4Bjv
	vcT13+mM6nvoOcdmdTPfA==
Message-Id: <20080621000729.853353000@menage.corp.google.com>
References: <20080620234358.182933000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Fri, 20 Jun 2008 16:43:59 -0700
From: menage@google.com
To: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 1/8] CGroup Files: Clean up whitespace in struct cftype
Content-Disposition: inline; filename=cgroup_remove_spaces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some extraneous spaces from method declarations in
struct cftype, to fit in with conventional kernel style.

Signed-off-by: Paul Menage <menage@google.com>

---
 include/linux/cgroup.h |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: cws-2.6.26-rc5-mm3/include/linux/cgroup.h
===================================================================
--- cws-2.6.26-rc5-mm3.orig/include/linux/cgroup.h
+++ cws-2.6.26-rc5-mm3/include/linux/cgroup.h
@@ -205,48 +205,48 @@ struct cftype {
 	 * subsystem, followed by a period */
 	char name[MAX_CFTYPE_NAME];
 	int private;
-	int (*open) (struct inode *inode, struct file *file);
-	ssize_t (*read) (struct cgroup *cgrp, struct cftype *cft,
-			 struct file *file,
-			 char __user *buf, size_t nbytes, loff_t *ppos);
+	int (*open)(struct inode *inode, struct file *file);
+	ssize_t (*read)(struct cgroup *cgrp, struct cftype *cft,
+			struct file *file,
+			char __user *buf, size_t nbytes, loff_t *ppos);
 	/*
 	 * read_u64() is a shortcut for the common case of returning a
 	 * single integer. Use it in place of read()
 	 */
-	u64 (*read_u64) (struct cgroup *cgrp, struct cftype *cft);
+	u64 (*read_u64)(struct cgroup *cgrp, struct cftype *cft);
 	/*
 	 * read_s64() is a signed version of read_u64()
 	 */
-	s64 (*read_s64) (struct cgroup *cgrp, struct cftype *cft);
+	s64 (*read_s64)(struct cgroup *cgrp, struct cftype *cft);
 	/*
 	 * read_map() is used for defining a map of key/value
 	 * pairs. It should call cb->fill(cb, key, value) for each
 	 * entry. The key/value pairs (and their ordering) should not
 	 * change between reboots.
 	 */
-	int (*read_map) (struct cgroup *cont, struct cftype *cft,
-			 struct cgroup_map_cb *cb);
+	int (*read_map)(struct cgroup *cont, struct cftype *cft,
+			struct cgroup_map_cb *cb);
 	/*
 	 * read_seq_string() is used for outputting a simple sequence
 	 * using seqfile.
 	 */
-	int (*read_seq_string) (struct cgroup *cont, struct cftype *cft,
-			 struct seq_file *m);
+	int (*read_seq_string)(struct cgroup *cont, struct cftype *cft,
+			       struct seq_file *m);
 
-	ssize_t (*write) (struct cgroup *cgrp, struct cftype *cft,
-			  struct file *file,
-			  const char __user *buf, size_t nbytes, loff_t *ppos);
+	ssize_t (*write)(struct cgroup *cgrp, struct cftype *cft,
+			 struct file *file,
+			 const char __user *buf, size_t nbytes, loff_t *ppos);
 
 	/*
 	 * write_u64() is a shortcut for the common case of accepting
 	 * a single integer (as parsed by simple_strtoull) from
 	 * userspace. Use in place of write(); return 0 or error.
 	 */
-	int (*write_u64) (struct cgroup *cgrp, struct cftype *cft, u64 val);
+	int (*write_u64)(struct cgroup *cgrp, struct cftype *cft, u64 val);
 	/*
 	 * write_s64() is a signed version of write_u64()
 	 */
-	int (*write_s64) (struct cgroup *cgrp, struct cftype *cft, s64 val);
+	int (*write_s64)(struct cgroup *cgrp, struct cftype *cft, s64 val);
 
 	/*
 	 * trigger() callback can be used to get some kick from the
@@ -256,7 +256,7 @@ struct cftype {
 	 */
 	int (*trigger)(struct cgroup *cgrp, unsigned int event);
 
-	int (*release) (struct inode *inode, struct file *file);
+	int (*release)(struct inode *inode, struct file *file);
 };
 
 struct cgroup_scanner {

--
