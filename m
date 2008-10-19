Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYJSBHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYJSBHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 21:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYJSBHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 21:07:38 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:63458 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYJSBHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 21:07:37 -0400
Date: Sun, 19 Oct 2008 09:07:46 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: linux-mm@kvack.org
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: fix-a-problem-of-annotation.patch
Message-ID: <20081019010746.GA6882@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianjun Kong <jianjun@zeuux.org>

mm/mmap.c: fix a problem of annotation
It should be "down_write(&current->mm->mmap_sem)".

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 mm/mmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index e7a5a68..f2e4444 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -906,7 +906,7 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
 #endif /* CONFIG_PROC_FS */
 
 /*
- * The caller must hold down_write(current->mm->mmap_sem).
+ * The caller must hold down_write(&current->mm->mmap_sem).
  */
 
 unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
-- 
1.5.2.5

-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
