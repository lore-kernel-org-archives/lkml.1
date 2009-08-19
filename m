Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbZHSNJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbZHSNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZHSNJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:09:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50563 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751951AbZHSNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:47 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/47] x86: Add definition for IGNNE MSR
Date: Wed, 19 Aug 2009 16:02:16 +0300
Message-Id: <1250686963-8357-21-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Hyper-V accesses MSR_IGNNE while running under KVM.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/msr-index.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6be7fc2..bd55490 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -374,6 +374,7 @@
 /* AMD-V MSRs */
 
 #define MSR_VM_CR                       0xc0010114
+#define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
 #endif /* _ASM_X86_MSR_INDEX_H */
-- 
1.6.3.3

