Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZEXQBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZEXQBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbZEXPzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:55:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41830 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZEXPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:32 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 13/45] KVM: Trivial format fix in setup_routing_entry()
Date: Sun, 24 May 2009 18:49:58 +0300
Message-Id: <1243180230-2480-14-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Remove extra tab.

Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 4fa1f60..a8bd466 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -271,7 +271,7 @@ static int setup_routing_entry(struct kvm_kernel_irq_routing_entry *e,
 			delta = 8;
 			break;
 		case KVM_IRQCHIP_IOAPIC:
-				e->set = kvm_set_ioapic_irq;
+			e->set = kvm_set_ioapic_irq;
 			break;
 		default:
 			goto out;
-- 
1.6.0.6

