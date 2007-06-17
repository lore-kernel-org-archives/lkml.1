Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbXFQJsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbXFQJsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbXFQJos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:55175 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbXFQJom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 11/58] KVM: Increase mmu shadow cache to 1024 pages
Date: Sun, 17 Jun 2007 12:43:52 +0300
Message-Id: <11820734804190-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This improves kbuild times by about 10%, bringing it within a respectable
25% of native.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 11c519e..f6ee189 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -54,7 +54,7 @@
 #define KVM_MAX_VCPUS 1
 #define KVM_ALIAS_SLOTS 4
 #define KVM_MEMORY_SLOTS 4
-#define KVM_NUM_MMU_PAGES 256
+#define KVM_NUM_MMU_PAGES 1024
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 40
-- 
1.5.0.6

