Return-Path: <linux-kernel-owner+w=401wt.eu-S1750863AbXBSKby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbXBSKby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXBSKby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:31:54 -0500
Received: from il.qumranet.com ([82.166.9.18]:57137 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXBSKbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:31:53 -0500
Subject: [PATCH 11/13] KVM: svm: init cr0 with the wp bit set
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:31:52 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219103152.560EE25016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c
+++ linux-2.6/drivers/kvm/svm.c
@@ -554,7 +554,7 @@ static void init_vmcb(struct vmcb *vmcb)
 	 * cr0 val on cpu init should be 0x60000010, we enable cpu
 	 * cache by default. the orderly way is to enable cache in bios.
 	 */
-	save->cr0 = 0x00000010 | CR0_PG_MASK;
+	save->cr0 = 0x00000010 | CR0_PG_MASK | CR0_WP_MASK;
 	save->cr4 = CR4_PAE_MASK;
 	/* rdx = ?? */
 }
