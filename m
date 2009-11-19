Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZKSNmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZKSNmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZKSNm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:42:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 09/35] KVM: VMX: fix handle_pause declaration
Date: Thu, 19 Nov 2009 15:34:45 +0200
Message-Id: <1258637711-11674-10-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

There's no kvm_run argument anymore.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a4580d6..364263a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3387,7 +3387,7 @@ out:
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
  */
-static int handle_pause(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static int handle_pause(struct kvm_vcpu *vcpu)
 {
 	skip_emulated_instruction(vcpu);
 	kvm_vcpu_on_spin(vcpu);
-- 
1.6.5.2

