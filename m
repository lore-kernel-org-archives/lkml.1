Return-Path: <linux-kernel-owner+w=401wt.eu-S1752508AbYL2PKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbYL2PKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYL2PKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:10:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:36607 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYL2PKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:10:10 -0500
Subject: [PATCH] x86_64: pci-gart_64.c iommu_fullflush should be static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 20:38:09 +0530
Message-Id: <1230563289.26564.10.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/pci-gart_64.c:55:5: warning: symbol 'iommu_fullflush' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/pci-gart_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a35eaa3..00c2bcd 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -52,7 +52,7 @@ static u32 *iommu_gatt_base;		/* Remapping table */
  * to trigger bugs with some popular PCI cards, in particular 3ware (but
  * has been also also seen with Qlogic at least).
  */
-int iommu_fullflush = 1;
+static int iommu_fullflush = 1;
 
 /* Allocation bitmap for the remapping area: */
 static DEFINE_SPINLOCK(iommu_bitmap_lock);
-- 
1.5.5.1



