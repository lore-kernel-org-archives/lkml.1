Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbXC1ML5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbXC1ML5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbXC1ML5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:11:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36852 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934015AbXC1MLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:11:47 -0400
Date: Wed, 28 Mar 2007 14:11:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Zachary Amsden <zach@vmware.com>
Cc: mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make arch/i386/kernel/io_apic.c:timer_irq_works() static again
Message-ID: <20070328121146.GR16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

timer_irq_works() needlessly became global.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.21-rc5-mm2/arch/i386/kernel/io_apic.c.old	2007-03-28 00:04:18.000000000 +0200
+++ linux-2.6.21-rc5-mm2/arch/i386/kernel/io_apic.c	2007-03-28 00:04:28.000000000 +0200
@@ -1904,7 +1904,7 @@ __setup("no_timer_check", notimercheck);
  *	- if this function detects that timer IRQs are defunct, then we fall
  *	  back to ISA timer IRQs
  */
-int __init timer_irq_works(void)
+static int __init timer_irq_works(void)
 {
 	unsigned long t1 = jiffies;
 

