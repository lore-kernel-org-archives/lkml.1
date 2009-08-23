Return-Path: <linux-kernel-owner+w=401wt.eu-S933611AbZHWL5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbZHWL5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933555AbZHWL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933566AbZHWL4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:51 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 45/46] KVM: MMU: enable gbpages by increasing nr of pagesizes
Date: Sun, 23 Aug 2009 14:56:44 +0300
Message-Id: <1251028605-31977-46-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
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
1.6.4.1

