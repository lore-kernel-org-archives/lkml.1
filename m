Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZDXMCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZDXMCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757000AbZDXL7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:59:33 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:5286 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756921AbZDXL7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:59:32 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-WSS-ID: 0KILTA4-02-NGX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.or>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/7] kvm/mmu: enable gbpages by increasing nr of pagesizes
Date: Fri, 24 Apr 2009 13:58:46 +0200
Message-ID: <1240574327-21575-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Apr 2009 11:58:48.0409 (UTC) FILETIME=[06DDF490:01C9C4D4]
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
index 5795177..6215d10 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -52,7 +52,7 @@
 #define UNMAPPED_GVA (~(gpa_t)0)
 
 /* KVM Hugepage definitions for x86 */
-#define KVM_NR_PAGE_SIZES	2
+#define KVM_NR_PAGE_SIZES	3
 #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + (((x) - 1) * 9))
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
-- 
1.6.2.3


