Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYBSScD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYBSScD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYBSSby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:31:54 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:20601 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYBSSbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DaQEpCbB2g+WTCUum5ZHVxFj0gFpBi1N643lJdZV1Z4QBoTBWcKQsyHh08RrCeiBk9SZdhdq+55rqs202aqIqg+2H3znCtmvUNwwz0uCPDeygm3Ft9bZRUmR3q/h7yh12BQPkLmW29jcInTNBHGq15q6TYqw41+ADaCll1Agk1s=
Subject: [PATCH] kvm: make iopm_base static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 10:32:02 -0800
Message-Id: <1203445922.10464.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warning as well.
arch/x86/kvm/svm.c:69:15: warning: symbol 'iopm_base' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kvm/svm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e1d139f..28ad3c4 100644
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
1.5.4.2.200.g99e75



