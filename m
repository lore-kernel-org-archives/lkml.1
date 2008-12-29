Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYL2QRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYL2QRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYL2QR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:17:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:49833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYL2QR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:17:26 -0500
Subject: [PATCH] x86: amd_iommu.c prealloc_protection_domains should be
	static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, leo.duran@amd.com,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 21:45:22 +0530
Message-Id: <1230567322.26564.16.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/amd_iommu.c:1299:6: warning: symbol 'prealloc_protection_domains' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2e2da71..658e29e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1296,7 +1296,7 @@ static int amd_iommu_dma_supported(struct device *dev, u64 mask)
  * we don't need to preallocate the protection domains anymore.
  * For now we have to.
  */
-void prealloc_protection_domains(void)
+static void prealloc_protection_domains(void)
 {
 	struct pci_dev *dev = NULL;
 	struct dma_ops_domain *dma_dom;
-- 
1.5.5.1



