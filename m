Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZERJl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZERJl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZERJZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38432 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 37/43] KVM: VMX: Simplify module parameter names
Date: Mon, 18 May 2009 12:22:59 +0300
Message-Id: <1242638585-18470-38-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of 'enable_vpid=1', use a simple 'vpid=1'.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 85f4fd5..a69ba6b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -42,13 +42,13 @@ static int bypass_guest_pf = 1;
 module_param(bypass_guest_pf, bool, S_IRUGO);
 
 static int enable_vpid = 1;
-module_param(enable_vpid, bool, 0444);
+module_param_named(vpid, enable_vpid, bool, 0444);
 
 static int flexpriority_enabled = 1;
-module_param(flexpriority_enabled, bool, S_IRUGO);
+module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
 
 static int enable_ept = 1;
-module_param(enable_ept, bool, S_IRUGO);
+module_param_named(ept, enable_ept, bool, S_IRUGO);
 
 static int emulate_invalid_guest_state = 0;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
-- 
1.6.0.6

