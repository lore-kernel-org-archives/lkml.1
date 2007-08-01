Return-Path: <linux-kernel-owner+w=401wt.eu-S1764225AbXHATuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764225AbXHATuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762011AbXHATuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:50:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761682AbXHATuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=C9aS9+6eyWmM5DBXuyP4mTiKitrk1IVdNp599/KHrl1smvkv/gCaqixaLbBmi0/5c+KLfyVqI2NJN8CNrz4pOU0ItiA93BJF13kyzTVmpyFQSBRvFykB2mSo5PcXsvVxC6PO00OkWPR+bJJDi8q0FBuG1WTGMu8iNCqyfNx7QjU=
Date: Wed, 1 Aug 2007 23:50:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unused struct proc_dir_entry::set
Message-ID: <20070801195010.GC5763@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After /proc/sys rewrite it was left unused.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/proc_fs.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -75,7 +75,6 @@ struct proc_dir_entry {
 	write_proc_t *write_proc;
 	atomic_t count;		/* use count */
 	int deleted;		/* delete flag */
-	void *set;
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;

