Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZF1QaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZF1QaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZF1Q1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:22 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1081 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZF1Q1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:17 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>, linux390@de.ibm.com,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, kvm@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: [PATCH 07/62] arch/s390/kvm/interrupt.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:12 -0700
Message-Id: <c719f73e63f4836087caa7fe9dbef9e1df765bd8.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/kvm/interrupt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index f04f530..dc94adb 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -484,7 +484,7 @@ int kvm_s390_inject_program_int(struct kvm_vcpu *vcpu, u16 code)
 	if (!inti)
 		return -ENOMEM;
 
-	inti->type = KVM_S390_PROGRAM_INT;;
+	inti->type = KVM_S390_PROGRAM_INT;
 	inti->pgm.code = code;
 
 	VCPU_EVENT(vcpu, 3, "inject: program check %d (from kernel)", code);
-- 
1.6.3.1.10.g659a0.dirty

