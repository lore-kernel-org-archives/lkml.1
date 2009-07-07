Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZGGQln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZGGQln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZGGQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:41:27 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:17038
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753247AbZGGQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:41:26 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KMF7OP-03-MPG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/6] kvm/mmu: enable gbpages by increasing nr of pagesizes
Date: Tue, 7 Jul 2009 18:41:06 +0200
Message-ID: <1246984867-15952-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
References: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Jul 2009 16:41:16.0162 (UTC) FILETIME=[BF155620:01C9FF21]
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
index 1fa1ff0..be2315b 100644
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


