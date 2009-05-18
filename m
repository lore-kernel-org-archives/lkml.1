Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbZERJml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbZERJml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbZERJZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38434 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 35/43] KVM: VMX: Make module parameters readable
Date: Mon, 18 May 2009 12:22:57 +0300
Message-Id: <1242638585-18470-36-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful to see how the module was loaded.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c0a2ed..469787c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -39,19 +39,19 @@ MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
 static int bypass_guest_pf = 1;
-module_param(bypass_guest_pf, bool, 0);
+module_param(bypass_guest_pf, bool, S_IRUGO);
 
 static int enable_vpid = 1;
-module_param(enable_vpid, bool, 0);
+module_param(enable_vpid, bool, 0444);
 
 static int flexpriority_enabled = 1;
-module_param(flexpriority_enabled, bool, 0);
+module_param(flexpriority_enabled, bool, S_IRUGO);
 
 static int enable_ept = 1;
-module_param(enable_ept, bool, 0);
+module_param(enable_ept, bool, S_IRUGO);
 
 static int emulate_invalid_guest_state = 0;
-module_param(emulate_invalid_guest_state, bool, 0);
+module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
 struct vmcs {
 	u32 revision_id;
-- 
1.6.0.6

