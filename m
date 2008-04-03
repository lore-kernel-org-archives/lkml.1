Return-Path: <linux-kernel-owner+w=401wt.eu-S1764143AbYDCTot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764143AbYDCTot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761247AbYDCTdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53033
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461AbYDCTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/35] KVM: Remove pointless desc_ptr #ifdef
Date: Thu,  3 Apr 2008 22:32:29 +0300
Message-Id: <1207251170-5013-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The desc_struct changes left an unnecessary #ifdef; remove it.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b2c667f..51741f9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -290,11 +290,7 @@ static void svm_hardware_enable(void *garbage)
 
 	struct svm_cpu_data *svm_data;
 	uint64_t efer;
-#ifdef CONFIG_X86_64
-	struct desc_ptr gdt_descr;
-#else
 	struct desc_ptr gdt_descr;
-#endif
 	struct desc_struct *gdt;
 	int me = raw_smp_processor_id();
 
-- 
1.5.4.5

