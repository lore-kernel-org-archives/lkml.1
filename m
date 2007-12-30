Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXL3HLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXL3HLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXL3HKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:45 -0500
Received: from il.qumranet.com ([82.166.9.18]:59469 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXL3HKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:42 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 02/52] KVM: Remove __init attributes for kvm_init_debug and kvm_init_msr_list
Date: Sun, 30 Dec 2007 09:09:48 +0200
Message-Id: <1198998638-22713-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Since their callers are not declared with __init.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/x86.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 7a871e0..acd26cf 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1332,7 +1332,7 @@ static u64 stat_get(void *_offset)
 
 DEFINE_SIMPLE_ATTRIBUTE(stat_fops, stat_get, NULL, "%llu\n");
 
-static __init void kvm_init_debug(void)
+static void kvm_init_debug(void)
 {
 	struct kvm_stats_debugfs_item *p;
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index f1746af..abb7bee 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1049,7 +1049,7 @@ out:
 	return r;
 }
 
-static __init void kvm_init_msr_list(void)
+static void kvm_init_msr_list(void)
 {
 	u32 dummy[2];
 	unsigned i, j;
-- 
1.5.3.7

