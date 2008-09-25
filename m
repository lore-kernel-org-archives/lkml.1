Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYIYMIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYIYMIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYIYL4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48632 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbYIYL4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:43 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Ben-Ami Yassour <benami@il.ibm.com>
Subject: [PATCH 02/39] KVM: remove unused field from the assigned dev struct
Date: Thu, 25 Sep 2008 14:54:34 +0300
Message-Id: <1222343711-12508-3-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben-Ami Yassour <benami@il.ibm.com>

Remove unused field: struct kvm_assigned_pci_dev assigned_dev
from struct: struct kvm_assigned_dev_kernel

Signed-off-by: Ben-Ami Yassour <benami@il.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm_host.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index fb7d7b7..1161af1 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -341,7 +341,6 @@ struct kvm_assigned_dev_kernel {
 	struct kvm_irq_ack_notifier ack_notifier;
 	struct work_struct interrupt_work;
 	struct list_head list;
-	struct kvm_assigned_pci_dev assigned_dev;
 	int assigned_dev_id;
 	int host_busnr;
 	int host_devfn;
-- 
1.6.0.1

