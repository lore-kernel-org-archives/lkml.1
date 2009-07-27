Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbZG0ObL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbZG0ObL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZG0ObK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:31:10 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13152 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZG0ObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:31:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KNG2ZI-04-HYI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/7] kvm/mmu: enable gbpages by increasing nr of pagesizes
Date: Mon, 27 Jul 2009 16:30:47 +0200
Message-ID: <1248705048-22607-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
References: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Jul 2009 14:30:51.0020 (UTC) FILETIME=[D7326CC0:01CA0EC6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c9fb2bc..3315efa 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -55,7 +55,7 @@
 #define UNMAPPED_GVA (~(gpa_t)0)
 
 /* KVM Hugepage definitions for x86 */
-#define KVM_NR_PAGE_SIZES	2
+#define KVM_NR_PAGE_SIZES	3
 #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + (((x) - 1) * 9))
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
-- 
1.6.3.3


