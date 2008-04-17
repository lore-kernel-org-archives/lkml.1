Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbYDQJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbYDQJWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763561AbYDQJL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:27 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59094
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763156AbYDQJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:06 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 26/45] KVM: s390: rename stfl to kvm_stfl
Date: Thu, 17 Apr 2008 12:10:31 +0300
Message-Id: <1208423450-29415-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Temporarily rename this function to avoid merge conflicts and/or
dependencies. This function will be removed as soon as git-s390
and kvm.git are finally upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/kvm/priv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index c97e904..1465946 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -151,7 +151,7 @@ static int handle_chsc(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static unsigned int stfl(void)
+static unsigned int kvm_stfl(void)
 {
 	asm volatile(
 		"	.insn	s,0xb2b10000,0(0)\n" /* stfl */
@@ -162,7 +162,7 @@ static unsigned int stfl(void)
 
 static int handle_stfl(struct kvm_vcpu *vcpu)
 {
-	unsigned int facility_list = stfl();
+	unsigned int facility_list = kvm_stfl();
 	int rc;
 
 	vcpu->stat.instruction_stfl++;
-- 
1.5.5

