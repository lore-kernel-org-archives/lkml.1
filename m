Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYF0LN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYF0LN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYF0LNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:13:04 -0400
Received: from saeurebad.de ([85.214.36.134]:38413 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbYF0LNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:13:02 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mmotm] remove unused vma_page_offset()
CC: linux-kernel@vger.kernel.org
Date: Fri, 27 Jun 2008 13:12:30 +0200
Message-ID: <874p7fyvvl.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function has no callees, drop it.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 690abf0..a7c7c18 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -48,17 +48,6 @@ static DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
  * Convert the address within this vma to the page offset within
- * the mapping, in base page units.
- */
-static pgoff_t vma_page_offset(struct vm_area_struct *vma,
-				unsigned long address)
-{
-	return ((address - vma->vm_start) >> PAGE_SHIFT) +
-					(vma->vm_pgoff >> PAGE_SHIFT);
-}
-
-/*
- * Convert the address within this vma to the page offset within
  * the mapping, in pagecache page units; huge pages here.
  */
 static pgoff_t vma_pagecache_offset(struct hstate *h,
