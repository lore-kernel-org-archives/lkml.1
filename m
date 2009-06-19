Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbZFSNRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbZFSNRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbZFSNQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:16:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18257 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZFSNQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:16:48 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzzz1202hzzz32i17ch65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KLHM7P-01-2NA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/8] hugetlbfs: export vma_kernel_pagsize to modules
Date: Fri, 19 Jun 2009 15:16:22 +0200
Message-ID: <1245417389-5527-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jun 2009 13:16:38.0443 (UTC) FILETIME=[2D8E97B0:01C9F0E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is required by KVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 mm/hugetlb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e83ad2c..e2016ef 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -234,6 +234,7 @@ unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 
 	return 1UL << (hstate->order + PAGE_SHIFT);
 }
+EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
 
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
-- 
1.6.3.1


