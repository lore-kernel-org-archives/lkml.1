Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZADK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZADK7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZADK7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:59:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZADK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:59:04 -0500
Subject: [PATCH -tip] x86: time_32.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:26:52 +0530
Message-Id: <1231066612.27852.20.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'

total: 4 errors, 0 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/time_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 65309e4..3985cac 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -105,8 +105,8 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		high bit of the PPI port B (0x61).  Note that some PS/2s,
 		notably the 55SX, work fine if this is removed.  */
 
-		u8 irq_v = inb_p( 0x61 );	/* read the current state */
-		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
+		u8 irq_v = inb_p(0x61);		/* read the current state */
+		outb_p(irq_v | 0x80, 0x61);	/* reset the IRQ */
 	}
 #endif
 
-- 
1.5.5.1



