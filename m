Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0BIL3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 06:29:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0BIL3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:29:10 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove references to CTL_UNNUMBERED which has been removed
Date: Tue, 9 Feb 2010 16:59:24 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002091659.24421.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove references to CTL_UNNUMBERED which has been removed.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -232,10 +232,6 @@ static struct ctl_table root_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -936,10 +932,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1282,10 +1274,6 @@ static struct ctl_table vm_table[] = {
 	},
 #endif
 
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1433,10 +1421,6 @@ static struct ctl_table fs_table[] = {
 		.child		= binfmt_misc_table,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
Index: linux-2.6/Documentation/sysctl/00-INDEX
===================================================================
--- linux-2.6.orig/Documentation/sysctl/00-INDEX
+++ linux-2.6/Documentation/sysctl/00-INDEX
@@ -4,8 +4,6 @@ README
 	- general information about /proc/sys/ sysctl files.
 abi.txt
 	- documentation for /proc/sys/abi/*.
-ctl_unnumbered.txt
-	- explanation of why one should not add new binary sysctl numbers.
 fs.txt
 	- documentation for /proc/sys/fs/*.
 kernel.txt
