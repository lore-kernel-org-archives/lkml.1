Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXIZIgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXIZIgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXIZIg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:36:29 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60034 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXIZIg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:36:28 -0400
Date: Wed, 26 Sep 2007 10:36:27 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 03/25] Unionfs: display informational messages only if
 debug is on
In-Reply-To: <11907762061611-git-send-email-ezk@cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709261036140.3121@fbirervta.pbzchgretzou.qr>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
 <11907762061611-git-send-email-ezk@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25 2007 23:09, Erez Zadok wrote:
>--- a/fs/unionfs/commonfops.c
>+++ b/fs/unionfs/commonfops.c
>@@ -394,8 +394,8 @@ int unionfs_file_revalidate(struct file *file, bool willwrite)
> 	if (willwrite && IS_WRITE_FLAG(file->f_flags) &&
> 	    !IS_WRITE_FLAG(unionfs_lower_file(file)->f_flags) &&
> 	    is_robranch(dentry)) {
>-		printk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
>-		       dentry->d_name.name);
>+		dprintk(KERN_DEBUG "unionfs: do delay copyup of \"%s\"\n",
>+			dentry->d_name.name);

Don't we have pr_debug() for that?

