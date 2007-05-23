Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbXEWUAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbXEWUAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXEWUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:00:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:60924 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755849AbXEWUAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:00:33 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH 2.6.21-rt7] PowerPC: kill cpu_khz reference
Date: Wed, 23 May 2007 23:02:00 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705240002.00698.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove forgotten reference to 'cpu_khz' which have been removed for PowerPC in
2.6.21-rt7...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The irony here is that it was me who sent a patch to add that line. :-)

Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c
+++ linux-2.6/arch/powerpc/kernel/time.c
@@ -816,7 +816,6 @@ void __init time_init(void)
 	tb_ticks_per_jiffy = ppc_tb_freq / HZ;
 	tb_ticks_per_sec = ppc_tb_freq;
 	tb_ticks_per_usec = ppc_tb_freq / 1000000;
-	cpu_khz  = ppc_tb_freq / 1000;
 	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
 	calc_cputime_factors();
 

