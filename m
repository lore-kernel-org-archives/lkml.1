Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYFZMgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYFZMgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYFZM3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:14 -0400
Received: from il.qumranet.com ([212.179.150.194]:32394 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbYFZM2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 49/50] KVM: MMU: When debug is enabled, make it a run-time parameter
Date: Thu, 26 Jun 2008 15:28:31 +0300
Message-Id: <1214483312-9265-50-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5ebb278..5994645 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -66,7 +66,8 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg) {}
 #endif
 
 #if defined(MMU_DEBUG) || defined(AUDIT)
-static int dbg = 1;
+static int dbg = 0;
+module_param(dbg, bool, 0644);
 #endif
 
 #ifndef MMU_DEBUG
-- 
1.5.6

