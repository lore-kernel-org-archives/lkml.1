Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYBIHRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYBIHRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYBIHRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:17:10 -0500
Received: from verein.lst.de ([213.95.11.210]:37966 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYBIHRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:17:09 -0500
Date: Sat, 9 Feb 2008 08:15:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, ezk@cs.sunysb.edu, rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix up kerneldoc in fs/ioctl.c a little bit
Message-ID: <20080209071559.GA30903@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - remove non-standard in/out markers
 - use tabs for formatting


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/ioctl.c	2008-02-09 07:49:02.000000000 +0100
+++ linux-2.6/fs/ioctl.c	2008-02-09 07:49:20.000000000 +0100
@@ -18,9 +18,9 @@
 
 /**
  * vfs_ioctl - call filesystem specific ioctl methods
- * @filp: [in]     open file to invoke ioctl method on
- * @cmd:  [in]     ioctl command to execute
- * @arg:  [in/out] command-specific argument for ioctl
+ * @filp:	open file to invoke ioctl method on
+ * @cmd:	ioctl command to execute
+ * @arg:	command-specific argument for ioctl
  *
  * Invokes filesystem specific ->unlocked_ioctl, if one exists; otherwise
  * invokes * filesystem specific ->ioctl method.  If neither method exists,
