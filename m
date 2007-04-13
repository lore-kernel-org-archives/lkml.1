Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbXDMMdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbXDMMdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXDMMdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:33:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36342 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753959AbXDMMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:33:11 -0400
Date: Fri, 13 Apr 2007 13:36:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] apm: Fix incorrect comment
Message-ID: <20070413133617.49b7f4bb@the-village.bc.nu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HZ has not always been 100Hz for some time.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.21-rc6-mm1/arch/i386/kernel/apm.c linux-2.6.21-rc6-mm1/arch/i386/kernel/apm.c
--- linux.vanilla-2.6.21-rc6-mm1/arch/i386/kernel/apm.c	2007-04-12 14:15:03.000000000 +0100
+++ linux-2.6.21-rc6-mm1/arch/i386/kernel/apm.c	2007-04-12 14:27:23.000000000 +0100
@@ -1173,7 +1173,7 @@
 	unsigned long flags;
 
 	spin_lock_irqsave(&i8253_lock, flags);
-	/* set the clock to 100 Hz */
+	/* set the clock to HZ */
 	outb_p(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
 	outb_p(LATCH & 0xff, PIT_CH0);	/* LSB */
