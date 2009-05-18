Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZERJpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZERJpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZERJZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 38/43] KVM: VMX: Annotate module parameters as __read_mostly
Date: Mon, 18 May 2009 12:23:00 +0300
Message-Id: <1242638585-18470-39-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a69ba6b..f4b6c4b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -38,19 +38,19 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
-static int bypass_guest_pf = 1;
+static int __read_mostly bypass_guest_pf = 1;
 module_param(bypass_guest_pf, bool, S_IRUGO);
 
-static int enable_vpid = 1;
+static int __read_mostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);
 
-static int flexpriority_enabled = 1;
+static int __read_mostly flexpriority_enabled = 1;
 module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
 
-static int enable_ept = 1;
+static int __read_mostly enable_ept = 1;
 module_param_named(ept, enable_ept, bool, S_IRUGO);
 
-static int emulate_invalid_guest_state = 0;
+static int __read_mostly emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
 struct vmcs {
-- 
1.6.0.6

