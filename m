Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZFDLMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZFDLMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZFDLMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:12:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55284 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbZFDLMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:12:06 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090604112.650907584@firstfloor.org>
To: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] x86: MCE: Define MCE_VECTOR
Date: Thu,  4 Jun 2009 13:12:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[This patch is already in the "mce3" branch in mce3 tip, but I'm including
it here because it's needed for the next patch.]

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/irq_vectors.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2009-05-27 21:48:38.000000000 +0200
+++ linux/arch/x86/include/asm/irq_vectors.h	2009-05-27 21:48:38.000000000 +0200
@@ -25,6 +25,7 @@
  */
 
 #define NMI_VECTOR			0x02
+#define MCE_VECTOR			0x12
 
 /*
  * IDT vectors usable for external interrupt sources start
