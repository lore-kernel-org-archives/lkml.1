Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbZFSNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbZFSNRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbZFSNQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:16:53 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47284 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZFSNQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:16:48 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KLHM7P-02-2UC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/8] kvm/mmu: enable gbpages by increasing nr of pagesizes
Date: Fri, 19 Jun 2009 15:16:28 +0200
Message-ID: <1245417389-5527-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jun 2009 13:16:38.0771 (UTC) FILETIME=[2DC0A430:01C9F0E0]
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
index 397f992..26ea9b8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -54,7 +54,7 @@
 #define UNMAPPED_GVA (~(gpa_t)0)
 
 /* KVM Hugepage definitions for x86 */
-#define KVM_NR_PAGE_SIZES	2
+#define KVM_NR_PAGE_SIZES	3
 #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + (((x) - 1) * 9))
 #define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
 #define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
-- 
1.6.3.1


