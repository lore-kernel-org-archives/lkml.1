Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbYG2UJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbYG2UJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYG2UJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:09:12 -0400
Received: from xenotime.net ([66.160.160.81]:56216 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752565AbYG2UJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:09:10 -0400
Date: Tue, 29 Jul 2008 13:05:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       J.A.K.Mouw@its.tudelft.nl
Subject: [PATCH 2/5] docsrc: fix procfs example
Message-ID: <12173619151458@xenotime.net>
In-Reply-To: <12173619152424@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add MODULE_LICENSE() to DocBook/procfs_example.c since modpost complained
about a missing license there.

Remove tty procfs removal since the creation was deleted long ago
(http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=5ad9cb65e9b15e5b83e2dd1c10a4bcaccc4ec644).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/procfs_example.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-next-20080729.orig/Documentation/DocBook/procfs_example.c
+++ linux-next-20080729/Documentation/DocBook/procfs_example.c
@@ -189,8 +189,6 @@ static int __init init_procfs_example(vo
 	return 0;
 
 no_symlink:
-	remove_proc_entry("tty", example_dir);
-no_tty:
 	remove_proc_entry("bar", example_dir);
 no_bar:
 	remove_proc_entry("foo", example_dir);
@@ -206,7 +204,6 @@ out:
 static void __exit cleanup_procfs_example(void)
 {
 	remove_proc_entry("jiffies_too", example_dir);
-	remove_proc_entry("tty", example_dir);
 	remove_proc_entry("bar", example_dir);
 	remove_proc_entry("foo", example_dir);
 	remove_proc_entry("jiffies", example_dir);
@@ -222,3 +219,4 @@ module_exit(cleanup_procfs_example);
 
 MODULE_AUTHOR("Erik Mouw");
 MODULE_DESCRIPTION("procfs examples");
+MODULE_LICENSE("GPL");


-- 

