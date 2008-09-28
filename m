Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYI1Puk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYI1Puk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYI1Pp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50894 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYI1Pp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:56 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 24/25] KVM: x86.c make kvm_load_realmode_segment static
Date: Sun, 28 Sep 2008 18:45:00 +0300
Message-Id: <1222616701-1206-25-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

Noticed by sparse:
arch/x86/kvm/x86.c:3591:5: warning: symbol 'kvm_load_realmode_segment' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 108f072..1b738cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3611,7 +3611,7 @@ static int load_segment_descriptor_to_kvm_desct(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_load_realmode_segment(struct kvm_vcpu *vcpu, u16 selector, int seg)
+static int kvm_load_realmode_segment(struct kvm_vcpu *vcpu, u16 selector, int seg)
 {
 	struct kvm_segment segvar = {
 		.base = selector << 4,
-- 
1.6.0.1

