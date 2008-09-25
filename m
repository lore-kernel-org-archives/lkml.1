Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYIYMIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYIYMIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYIYL4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbYIYL41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:27 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 37/39] KVM: add MC5_MISC msr read support
Date: Thu, 25 Sep 2008 14:55:09 +0300
Message-Id: <1222343711-12508-38-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Currently KVM implements MC0-MC4_MISC read support. When booting Linux this
results in KVM warnings in the kernel log when the guest tries to read
MC5_MISC. Fix this warnings with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 675d010..e3b8966 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -991,6 +991,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MC0_MISC+8:
 	case MSR_IA32_MC0_MISC+12:
 	case MSR_IA32_MC0_MISC+16:
+	case MSR_IA32_MC0_MISC+20:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_EBL_CR_POWERON:
 	case MSR_IA32_DEBUGCTLMSR:
-- 
1.6.0.1

