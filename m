Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbXGZJsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbXGZJsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbXGZJr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:47:59 -0400
Received: from www.osadl.org ([213.239.205.134]:39381 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754145AbXGZJr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:47:58 -0400
Subject: [PATCH] x86_64: cleanup tsc.c merge artifact
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 11:47:51 +0200
Message-Id: <1185443271.3227.28.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tsc_unstable is declared twice.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86_64/kernel/tsc.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.23-rc1/arch/x86_64/kernel/tsc.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/tsc.c	2007-07-26 09:45:51.000000000 +0200
+++ linux-2.6.23-rc1/arch/x86_64/kernel/tsc.c	2007-07-26 09:45:53.000000000 +0200
@@ -118,8 +118,6 @@ core_initcall(cpufreq_tsc);
 
 #endif
 
-static int tsc_unstable = 0;
-
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.


