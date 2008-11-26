Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbYKZVCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbYKZVCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYKZVCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:02:15 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:27211 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYKZVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:02:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=canb6I1A6vKB+m4ylfOH+Qn7p7cYI2HD/cz60VcNDqkRq8g3N3MbWlodA65G56kDa9
         fKNfrgb6xwkKQvM/qgK77/Pmg0QgZ5yIKrxRUzuovn8n30kLKtWrEl9xGW0F2vKGyYgq
         Wq5ZaIqCXDXcLLYhCsDpPFtUi3GUgSpIx7MFs=
Date: Thu, 27 Nov 2008 00:02:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: uv bau interrupt -- use proper interrupt number
Message-ID: <20081126210210.GA8671@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6.git/arch/x86/kernel/entry_64.S
@@ -945,7 +945,7 @@ apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
 	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
 #endif
 
-apicinterrupt 220 \
+apicinterrupt UV_BAU_MESSAGE \
 	uv_bau_message_intr1 uv_bau_message_interrupt
 apicinterrupt LOCAL_TIMER_VECTOR \
 	apic_timer_interrupt smp_apic_timer_interrupt
