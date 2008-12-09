Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbYLIH5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYLIH5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 02:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYLIH5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 02:57:25 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:44033 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYLIH5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 02:57:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mime-version:content-type
         :content-disposition:user-agent:from;
        b=dN7RbaG6eMcarBnYqslLXJU+gL6hFQdDU56T1IVBg7BKKFJlztfWliN/+PTTnR0e/2
         5rJOxT5TLajSU0NJs4ahQoeWk6ZeDPvaPzlhpeqx67xCloKowaKCopYQfXPluP3ADbUv
         gcMHh/6Hn0eRKTIzoon95Ux9NmK/qftEDPdbE=
Date: Tue, 9 Dec 2008 15:56:52 +0800
To: hugh@veritas.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] fix coding style of mm/mmap.c
Message-ID: <20081209075652.GA3515@helight>
Reply-To: "Helight.Xu" <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "Helight.Xu" <zhwenxu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

fix some coding style of mm/mmap.c 
-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0002-code-style.patch"

>From e968c1366585e4982f69e8ec0a27a806514676d0 Mon Sep 17 00:00:00 2001
From: ZhenwenXu <helight.xu@gmail.com>
Date: Fri, 14 Nov 2008 22:14:32 +0800
Subject: [PATCH] code style


Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
---
 mm/mmap.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index e7a5a68..5750480 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -412,7 +412,7 @@ void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 
 static inline void __vma_link_file(struct vm_area_struct *vma)
 {
-	struct file * file;
+	struct file *file;
 
 	file = vma->vm_file;
 	if (file) {
@@ -474,10 +474,10 @@ static void vma_link(struct mm_struct *mm, struct vm_area_struct *vma,
  * but it has already been inserted into prio_tree earlier.
  */
 static void
-__insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
+__insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct * __vma, * prev;
-	struct rb_node ** rb_link, * rb_parent;
+	struct vm_area_struct *__vma, *prev;
+	struct rb_node **rb_link, *rb_parent;
 
 	__vma = find_vma_prepare(mm, vma->vm_start,&prev, &rb_link, &rb_parent);
 	BUG_ON(__vma && __vma->vm_start < vma->vm_end);
@@ -909,7 +909,7 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
  * The caller must hold down_write(current->mm->mmap_sem).
  */
 
-unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
+unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
 			unsigned long flags, unsigned long pgoff)
 {
@@ -1458,7 +1458,7 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 EXPORT_SYMBOL(get_unmapped_area);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
-struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr)
+struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma = NULL;
 
@@ -1501,7 +1501,7 @@ find_vma_prev(struct mm_struct *mm, unsigned long addr,
 			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma = NULL, *prev = NULL;
-	struct rb_node * rb_node;
+	struct rb_node *rb_node;
 	if (!mm)
 		goto out;
 
@@ -1535,7 +1535,7 @@ out:
  * update accounting. This is shared with both the
  * grow-up and grow-down cases.
  */
-static int acct_stack_growth(struct vm_area_struct * vma, unsigned long size, unsigned long grow)
+static int acct_stack_growth(struct vm_area_struct *vma, unsigned long size, unsigned long grow)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
-- 
1.5.6.5


--cNdxnHkX5QqsyA0e--
