Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYHTSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYHTSbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYHTSbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:31:10 -0400
Received: from gw.goop.org ([64.81.55.164]:51576 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbYHTSbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:31:09 -0400
Message-ID: <48AC62EB.6060804@goop.org>
Date: Wed, 20 Aug 2008 11:31:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: export pv_lock_ops non-GPL
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the spinlock API is exported GPL, so there's no reason for
pv_lock_ops to be.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: drago01 <drago01@gmail.com>
---
 arch/x86/kernel/paravirt-spinlocks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -17,7 +17,7 @@
 	.spin_unlock = __ticket_spin_unlock,
 #endif
 };
-EXPORT_SYMBOL_GPL(pv_lock_ops);
+EXPORT_SYMBOL(pv_lock_ops);
 
 void __init paravirt_use_bytelocks(void)
 {


