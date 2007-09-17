Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbXIQJEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbXIQJEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXIQIeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:45292 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 044/104] KVM: Remove redundant alloc_vmcs_cpu declaration
Date: Mon, 17 Sep 2007 10:31:26 +0200
Message-Id: <1190017947103-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

alloc_vmcs_cpu is already declared (static) above, no need to
redeclare.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index c4b8bfe..a94eb20 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -949,8 +949,6 @@ static void free_kvm_area(void)
 		free_vmcs(per_cpu(vmxarea, cpu));
 }
 
-extern struct vmcs *alloc_vmcs_cpu(int cpu);
-
 static __init int alloc_kvm_area(void)
 {
 	int cpu;
-- 
1.5.3

