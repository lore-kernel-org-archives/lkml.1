Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbZHSNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbZHSNJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZHSNJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50567 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751881AbZHSNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:48 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/47] hugetlbfs: export vma_kernel_pagsize to modules
Date: Wed, 19 Aug 2009 16:02:28 +0300
Message-Id: <1250686963-8357-33-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This function is required by KVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 mm/hugetlb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cafdcee..b16d636 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -234,6 +234,7 @@ unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 
 	return 1UL << (hstate->order + PAGE_SHIFT);
 }
+EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
 
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
-- 
1.6.3.3

