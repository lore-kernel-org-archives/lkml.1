Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbYDCTdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbYDCTdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbYDCTc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:32:56 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53006
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYDCTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 04/35] KVM: SVM: make iopm_base static
Date: Thu,  3 Apr 2008 22:32:19 +0300
Message-Id: <1207251170-5013-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Fixes sparse warning as well.
arch/x86/kvm/svm.c:69:15: warning: symbol 'iopm_base' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7d73e93..ff6e5c8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -66,7 +66,7 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_svm, vcpu);
 }
 
-unsigned long iopm_base;
+static unsigned long iopm_base;
 
 struct kvm_ldttss_desc {
 	u16 limit0;
-- 
1.5.4.5

