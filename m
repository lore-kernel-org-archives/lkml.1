Return-Path: <linux-kernel-owner+w=401wt.eu-S935909AbXJQAbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935909AbXJQAbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932681AbXJQAa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:30:56 -0400
Received: from fw01.cmbrmaks.akamai.com ([80.67.64.10]:57576 "EHLO
	smtp1.akamai.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965984AbXJQAaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:30:55 -0400
X-Greylist: delayed 1181 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 20:30:54 EDT
Date: Tue, 16 Oct 2007 17:11:02 -0700
From: Jason Uhlenkott <juhlenko@akamai.com>
To: trivial@kernel.org
Cc: drepper@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix do_sys_open() prototype
Message-ID: <20071017001102.GC13858@48M1231.sanmateo.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an argument name in do_sys_open()'s prototype.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>

Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-10-16 15:19:26.632794062 -0700
+++ linux/include/linux/fs.h	2007-10-16 16:46:38.000182413 -0700
@@ -1426,7 +1426,7 @@
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
-extern long do_sys_open(int fdf, const char __user *filename, int flags,
+extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int);
