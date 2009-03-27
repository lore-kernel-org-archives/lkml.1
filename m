Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZC0OfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZC0OfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbZC0OeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:34:02 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:15610 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZC0OeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:34:00 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KH65PB-01-IGS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, William Irwin <wli@holomorphy.com>
Subject: [PATCH 1/7] hugetlb: export vma_kernel_pagesize to modules
Date: Fri, 27 Mar 2009 15:31:53 +0100
Message-ID: <1238164319-16092-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0243 (UTC) FILETIME=[CA0F8430:01C9AEE8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is required in the KVM module to determine the size of the
backing page size.

Cc: William Irwin <wli@holomorphy.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 mm/hugetlb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 107da3d..29f4fbf 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -234,6 +234,7 @@ unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
 
 	return 1UL << (hstate->order + PAGE_SHIFT);
 }
+EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
 
 /*
  * Return the page size being used by the MMU to back a VMA. In the majority
-- 
1.5.6.4


