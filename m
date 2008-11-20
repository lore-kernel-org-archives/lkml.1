Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbYKTPxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbYKTPxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYKTPvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:08 -0500
Received: from mail23.svc.cra.dublin.eircom.net ([159.134.118.145]:36998 "HELO
	mail23.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754956AbYKTPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:01 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 7/8] intel-iommu: kill off duplicate def of dmar_disabled
Date: Thu, 20 Nov 2008 15:49:49 +0000
Message-Id: <1227196190-488-7-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227196190-488-6-git-send-email-markmc@redhat.com>
References: <1227191861.4901.24.camel@macbook.infradead.org>
 <1227196190-488-1-git-send-email-markmc@redhat.com>
 <1227196190-488-2-git-send-email-markmc@redhat.com>
 <1227196190-488-3-git-send-email-markmc@redhat.com>
 <1227196190-488-4-git-send-email-markmc@redhat.com>
 <1227196190-488-5-git-send-email-markmc@redhat.com>
 <1227196190-488-6-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only used in dmar.c and intel-iommu.h, so dma_remapping.h
seems like the appropriate place for it.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 include/linux/dmar.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index f1984fc..f284407 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -144,7 +144,6 @@ struct dmar_rmrr_unit {
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
 /* Intel DMAR  initialization functions */
 extern int intel_iommu_init(void);
-extern int dmar_disabled;
 #else
 static inline int intel_iommu_init(void)
 {
-- 
1.5.4.3

