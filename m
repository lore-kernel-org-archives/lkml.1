Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbZHPJh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbZHPJh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZHPJh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:37:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZHPJaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:12 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/48] KVM: Downsize max support MSI-X entry to 256
Date: Sun, 16 Aug 2009 12:29:37 +0300
Message-Id: <1250415008-17175-18-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

We only trap one page for MSI-X entry now, so it's 4k/(128/8) = 256 entries at
most.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 65df6f5..632a856 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -676,7 +676,7 @@ struct kvm_assigned_msix_nr {
 	__u16 padding;
 };
 
-#define KVM_MAX_MSIX_PER_DEV		512
+#define KVM_MAX_MSIX_PER_DEV		256
 struct kvm_assigned_msix_entry {
 	__u32 assigned_dev_id;
 	__u32 gsi;
-- 
1.6.3.3

