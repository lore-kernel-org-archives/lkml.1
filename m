Return-Path: <linux-kernel-owner+w=401wt.eu-S1760664AbYDUKgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbYDUKgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYDUKaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:24 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37952
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbYDUKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:08 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 20/31] ppc: Export tlb_44x_hwater for KVM
Date: Mon, 21 Apr 2008 13:29:46 +0300
Message-Id: <1208773797-7829-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

PowerPC 440 KVM needs to know how many TLB entries are used for the host kernel
linear mapping (it does not modify these mappings when switching between guest
and host execution).

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-powerpc/mmu-44x.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-powerpc/mmu-44x.h b/include/asm-powerpc/mmu-44x.h
index 62772ae..b6953e8 100644
--- a/include/asm-powerpc/mmu-44x.h
+++ b/include/asm-powerpc/mmu-44x.h
@@ -53,6 +53,8 @@
 
 #ifndef __ASSEMBLY__
 
+extern unsigned int tlb_44x_hwater;
+
 typedef unsigned long long phys_addr_t;
 
 typedef struct {
-- 
1.5.5

