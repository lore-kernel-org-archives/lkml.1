Return-Path: <linux-kernel-owner+w=401wt.eu-S967203AbXEHSTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967203AbXEHSTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967080AbXEHSTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:19:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967021AbXEHSTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:19:49 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unused variable in get_unmapped_area
X-Shopping-List: (1) Quaint corruption excitements
   (2) Carbonated abrasion wigs
   (3) Stimulating dwarves
   (4) Dyspeptic circumlocutions
Message-Id: <20070508181938.B5B6E1F850E@magilla.localdomain>
Date: Tue,  8 May 2007 11:19:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 mm/mmap.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 52646d6..4be69af 100644  
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1366,7 +1366,6 @@ unsigned long
 get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
 {
-	unsigned long ret;
 	unsigned long (*get_area)(struct file *, unsigned long,
 				  unsigned long, unsigned long, unsigned long);
 
