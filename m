Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbYJNKIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbYJNKIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 06:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbYJNKH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 06:07:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:51886 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYJNKH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 06:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=U7tzQANAblIKF3g10akl4neroHbqYGq4Jl2BgBAel8BSBxh+PuFlkii+3DhgABVwvv
         6A+m3V2W+l3AFP3PFoaqkHAPN2yqEE6plvuswE0r/NpuhfIdH3u6EnYtTtUMMpEq2U41
         BP9Z+QVy8sK2kz7D6oopiqXs5gKLHocdsfm8E=
Message-ID: <269694c00810140307t20c86d0bsaf071a80bbb1eed6@mail.gmail.com>
Date: Tue, 14 Oct 2008 21:07:56 +1100
From: "Ameya Palande" <2ameya@gmail.com>
To: "Ashok Raj" <ashok.raj@intel.com>, "Shaohua Li" <shaohua.li@intel.com>,
       "Anil S Keshavamurthy" <anil.s.keshavamurthy@intel.com>
Subject: [PATCH 2.6.27] Intel-IOMMU: Typo Fix and correct word in the Comment
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for a typo and and replacing incorrect word in the comment.

Signed-off-by: Ameya Palande <2ameya@gmail.com>
---

--- drivers/pci/intel-iommu.c.orig      2008-10-14 20:16:59.000000000 +1100
+++ drivers/pci/intel-iommu.c   2008-10-14 20:17:59.000000000 +1100
@@ -587,7 +587,7 @@ static int __iommu_flush_context(struct

        spin_unlock_irqrestore(&iommu->register_lock, flag);

-       /* flush context entry will implictly flush write buffer */
+       /* flush context entry will implicitly flush write buffer */
        return 0;
 }

@@ -680,7 +680,7 @@ static int __iommu_flush_iotlb(struct in
        if (DMA_TLB_IAIG(val) != DMA_TLB_IIRG(type))
                pr_debug("IOMMU: tlb flush request %Lx, actual %Lx\n",
                        DMA_TLB_IIRG(type), DMA_TLB_IAIG(val));
-       /* flush context entry will implictly flush write buffer */
+       /* flush iotlb entry will implicitly flush write buffer */
        return 0;
 }
