Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbYAAPvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbYAAPvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYAAPhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:33797 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbYAAPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:32 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 54/54] KVM: LAPIC: minor debugging compile fix
Date: Tue,  1 Jan 2008 17:36:20 +0200
Message-Id: <1199201780-14001-55-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch fixes a compile error of the LAPIC code with APIC debugging enabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/lapic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 5efa6c0..466c37f 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -829,7 +829,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 	/* with FSB delivery interrupt, we can restart APIC functionality */
 	apic_debug("apic base msr is 0x%016" PRIx64 ", and base address is "
-		   "0x%lx.\n", apic->apic_base, apic->base_address);
+		   "0x%lx.\n", apic->vcpu->apic_base, apic->base_address);
 
 }
 
-- 
1.5.3.7

