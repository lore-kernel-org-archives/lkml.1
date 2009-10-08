Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbZJHVeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbZJHVeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbZJHVeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:34:06 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2630 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbZJHVeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:34:05 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Date: Thu, 8 Oct 2009 14:33:13 -0700
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: oprofile-list@lists.sf.net, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
cc: "Leo Chen" <leochen@broadcom.com>
Subject: [PATCH] bcmring: add oprofile pmu support
Message-ID: <20091008213313.GQ4708@broadcom.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.18 (2008-05-17)
X-WSS-ID: 66D085105S442231289-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch is to add oprofile pmu support for bcmring arch.

Thanks,

Leo

From: Leo Chen <leochen@broadcom.com>
Date: Thu, 8 Oct 2009 14:28:35 -0700
Subject: [PATCH] bcmring: add oprofile pmu support

oprofile pmu support for bcmring arch.

Signed-off-by: Leo Hao Chen <leochen@broadcom.com>
---
 arch/arm/oprofile/op_model_v6.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/oprofile/op_model_v6.c b/arch/arm/oprofile/op_model_v6.c
index fe58138..f7d2ec5 100644
--- a/arch/arm/oprofile/op_model_v6.c
+++ b/arch/arm/oprofile/op_model_v6.c
@@ -33,6 +33,9 @@ static int irqs[] = {
 #ifdef CONFIG_ARCH_OMAP2
 	3,
 #endif
+#ifdef CONFIG_ARCH_BCMRING
+	IRQ_PMUIRQ, /* for BCMRING, ARM PMU interrupt is 43 */
+#endif
 };
 
 static void armv6_pmu_stop(void)
-- 
1.6.0.6

-- 

Leo Hao Chen

------------------------
Life is short, run long.

