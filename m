Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXIQIss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXIQIss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXIQIdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:14 -0400
Received: from il.qumranet.com ([82.166.9.18]:45323 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbXIQIcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>
Subject: [PATCH 061/104] KVM: Support more memory slots
Date: Mon, 17 Sep 2007 10:31:43 +0200
Message-Id: <11900179483116-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Needed for mapping memory at 4GB.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 2245bae..a42a6f3 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS 4
 #define KVM_ALIAS_SLOTS 4
-#define KVM_MEMORY_SLOTS 4
+#define KVM_MEMORY_SLOTS 8
 #define KVM_NUM_MMU_PAGES 1024
 #define KVM_MIN_FREE_MMU_PAGES 5
 #define KVM_REFILL_PAGES 25
-- 
1.5.3

