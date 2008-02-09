Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYBIHYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYBIHYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYBIHYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:24:07 -0500
Received: from verein.lst.de ([213.95.11.210]:38138 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbYBIHYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:24:06 -0500
Date: Sat, 9 Feb 2008 08:22:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up kerneldoc in fs/ioctl.c a little bit
Message-ID: <20080209072242.GA31231@lst.de>
References: <20080209071559.GA30903@lst.de> <200802090719.m197JRan023715@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802090719.m197JRan023715@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 02:19:27AM -0500, Erez Zadok wrote:
> >   * Invokes filesystem specific ->unlocked_ioctl, if one exists; otherwise
> >   * invokes * filesystem specific ->ioctl method.  If neither method exists,
>               ^
> 
> I also think this extra '*' in the last comment line above is spurious,
> perhaps the result of a paragraph reformatting command that mixed comment
> *'s with text.

Indeed.  Updated patch below:


Index: linux-2.6/fs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/ioctl.c	2008-02-09 07:51:31.000000000 +0100
+++ linux-2.6/fs/ioctl.c	2008-02-09 08:21:30.000000000 +0100
@@ -18,12 +18,12 @@
 
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
- * invokes * filesystem specific ->ioctl method.  If neither method exists,
+ * invokes filesystem specific ->ioctl method.  If neither method exists,
  * returns -ENOTTY.
  *
  * Returns 0 on success, -errno on error.
