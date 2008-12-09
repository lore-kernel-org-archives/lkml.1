Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYLIU0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYLIU0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbYLIUXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbYLIUXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:08 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 11/44] KVM: ia64: Remove some macro definitions in asm-offsets.c.
Date: Tue,  9 Dec 2008 22:22:26 +0200
Message-Id: <1228854179-23002-12-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Use kernel's corresponding macro instead.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/asm-offsets.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/kvm/asm-offsets.c b/arch/ia64/kvm/asm-offsets.c
index 4e3dc13..0c3564a 100644
--- a/arch/ia64/kvm/asm-offsets.c
+++ b/arch/ia64/kvm/asm-offsets.c
@@ -24,19 +24,10 @@
 
 #include <linux/autoconf.h>
 #include <linux/kvm_host.h>
+#include <linux/kbuild.h>
 
 #include "vcpu.h"
 
-#define task_struct kvm_vcpu
-
-#define DEFINE(sym, val) \
-	asm volatile("\n->" #sym " (%0) " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : :)
-
-#define OFFSET(_sym, _str, _mem) \
-    DEFINE(_sym, offsetof(_str, _mem));
-
 void foo(void)
 {
 	DEFINE(VMM_TASK_SIZE, sizeof(struct kvm_vcpu));
-- 
1.6.0.3

