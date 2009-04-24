Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZDXL73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZDXL73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZDXL7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:59:01 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:17334
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753703AbZDXL7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:59:00 -0400
X-BigFish: VPS5(zba6jzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KILT9Z-02-NGR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.or>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/7] hugetlbfs: export vma_kernel_pagsize to modules
Date: Fri, 24 Apr 2009 13:58:41 +0200
Message-ID: <1240574327-21575-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Apr 2009 11:58:48.0096 (UTC) FILETIME=[06AE3200:01C9C4D4]
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
index 28c655b..7dcf5b8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -234,6 +234,7 @@ unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 
 	return 1UL << (hstate->order + PAGE_SHIFT);
 }
+EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
 
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
-- 
1.6.2.3


