Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbYGIHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbYGIHj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYGIHjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:39:04 -0400
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:49524 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYGIHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:39:03 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jul 2008 03:39:03 EDT
Date: Wed, 9 Jul 2008 16:29:41 +0900
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080709162913H.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be CONFIG_GART_IOMMU instead of CONFIG_IOMMU here?

Hmm, looks like it would be nice to have more cleanups of iommu.h and
gart.h.

This is against tip/master.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-x86/iommu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 07862fd..cb7e989 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -5,7 +5,7 @@ extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
-#ifdef CONFIG_IOMMU
+#ifdef CONFIG_GART_IOMMU
 extern void gart_iommu_init(void);
 extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
-- 
1.5.4.2

