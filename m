Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYK1Tsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYK1Tsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYK1Tsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:48:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:5918 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYK1Tsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:48:41 -0500
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 17:02:06 +0100
Subject: [PATCH] KVM: VMX: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <49304b16.0ab6660a.0d69.ffff9a04@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: make global function static

  arch/x86/kvm/vmx.c:134:3: warning: symbol 'vmx_capability' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7ea4855..e446f23 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -128,7 +128,7 @@ static struct vmcs_config {
 	u32 vmentry_ctrl;
 } vmcs_config;
 
-struct vmx_capability {
+static struct vmx_capability {
 	u32 ept;
 	u32 vpid;
 } vmx_capability;
-- 
1.5.6.3

