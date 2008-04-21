Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbYDUKar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbYDUKar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYDUKaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:02 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37842
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbYDUK37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:29:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/31] KVM: SVM: indent svm_set_cr4 with tabs instead of spaces
Date: Mon, 21 Apr 2008 13:29:29 +0300
Message-Id: <1208773797-7829-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The svm_set_cr4 function is indented with spaces. This patch replaces
them with tabs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ad27346..d7439ce 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -878,10 +878,10 @@ set:
 
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
-       vcpu->arch.cr4 = cr4;
-       if (!npt_enabled)
-	       cr4 |= X86_CR4_PAE;
-       to_svm(vcpu)->vmcb->save.cr4 = cr4;
+	vcpu->arch.cr4 = cr4;
+	if (!npt_enabled)
+		cr4 |= X86_CR4_PAE;
+	to_svm(vcpu)->vmcb->save.cr4 = cr4;
 }
 
 static void svm_set_segment(struct kvm_vcpu *vcpu,
-- 
1.5.5

