Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXDAOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXDAOlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXDAOlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:41:15 -0400
Received: from il.qumranet.com ([82.166.9.18]:47554 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 33/41] KVM: Remove unused function
Date: Sun,  1 Apr 2007 17:35:30 +0300
Message-Id: <1175438139249-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381393184-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Remove unused function

CC      drivers/kvm/svm.o
drivers/kvm/svm.c:207: warning: ‘inject_db’ defined but not used

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index ca2642f..303e959 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -203,13 +203,6 @@ static void inject_ud(struct kvm_vcpu *vcpu)
 						UD_VECTOR;
 }
 
-static void inject_db(struct kvm_vcpu *vcpu)
-{
-	vcpu->svm->vmcb->control.event_inj = 	SVM_EVTINJ_VALID |
-						SVM_EVTINJ_TYPE_EXEPT |
-						DB_VECTOR;
-}
-
 static int is_page_fault(uint32_t info)
 {
 	info &= SVM_EVTINJ_VEC_MASK | SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
-- 
1.5.0.5

