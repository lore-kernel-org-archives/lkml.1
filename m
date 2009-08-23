Return-Path: <linux-kernel-owner+w=401wt.eu-S933764AbZHWMDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbZHWMDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933756AbZHWMC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933537AbZHWL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/46] KVM: s390: remove unused structs
Date: Sun, 23 Aug 2009 14:56:29 +0300
Message-Id: <1251028605-31977-31-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

They are not used by common code without defines which s390 does not
have.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/s390/include/asm/kvm.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/kvm.h b/arch/s390/include/asm/kvm.h
index 0b2f829..3dfcaeb 100644
--- a/arch/s390/include/asm/kvm.h
+++ b/arch/s390/include/asm/kvm.h
@@ -15,15 +15,6 @@
  */
 #include <linux/types.h>
 
-/* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
-struct kvm_pic_state {
-	/* no PIC for s390 */
-};
-
-struct kvm_ioapic_state {
-	/* no IOAPIC for s390 */
-};
-
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
-- 
1.6.4.1

