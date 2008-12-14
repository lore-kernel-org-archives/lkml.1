Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYLNIQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYLNIQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYLNIHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 13/36] KVM: VMX: fix sparse warning
Date: Sun, 14 Dec 2008 10:06:46 +0200
Message-Id: <1229242029-13410-14-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Impact: make global function static

  arch/x86/kvm/vmx.c:134:3: warning: symbol 'vmx_capability' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
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
1.6.0.3

