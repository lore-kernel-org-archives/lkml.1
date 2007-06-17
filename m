Return-Path: <linux-kernel-owner+w=401wt.eu-S1761828AbXFQJ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761828AbXFQJ5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbXFQJp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:26 -0400
Received: from il.qumranet.com ([82.166.9.18]:55204 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759446AbXFQJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 50/58] KVM: Enable guest smp
Date: Sun, 17 Jun 2007 12:44:31 +0300
Message-Id: <11820734811440-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As we don't support guest tlb shootdown yet, this is only reliable
for real-mode guests.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 3ec4e26..e665f55 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -55,7 +55,7 @@
 #define INVALID_PAGE (~(hpa_t)0)
 #define UNMAPPED_GVA (~(gpa_t)0)
 
-#define KVM_MAX_VCPUS 1
+#define KVM_MAX_VCPUS 4
 #define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 4
 #define KVM_NUM_MMU_PAGES 1024
-- 
1.5.0.6

