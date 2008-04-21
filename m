Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbYDUKk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbYDUKk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYDUKap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:45 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37976
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbYDUKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:11 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 28/31] KVM: SVM: remove now obsolete FIXME comment
Date: Mon, 21 Apr 2008 13:29:54 +0300
Message-Id: <1208773797-7829-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

With the usage of the V_TPR field this comment is now obsolete.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 61bb2cb..d643605 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -916,13 +916,6 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 
 }
 
-/* FIXME:
-
-	svm(vcpu)->vmcb->control.int_ctl &= ~V_TPR_MASK;
-	svm(vcpu)->vmcb->control.int_ctl |= (sregs->cr8 & V_TPR_MASK);
-
-*/
-
 static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
 {
 	return -EOPNOTSUPP;
-- 
1.5.5

