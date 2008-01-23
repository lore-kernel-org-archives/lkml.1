Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbYAWRln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbYAWRln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756963AbYAWRjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:39:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717AbYAWRjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:39:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=IFbsntE+q/ZaLxVbrPD+ELtVt2MnRO6+lavmM1skvU3438uuz6+9AKfBxWmbThc5K3PIa+E8+GyRNVHp4u6KnvM8lhAKPaqP3xrGArPXAqX1sHTPBRz4DcuatRAyxbIz3sHkMQNRP8OZM4j0hJ4Xp0rLr9jOiHGCxABiGDAhZxk=
Date: Wed, 23 Jan 2008 20:39:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/6] SH64: use KSYM_NAME_LEN
Message-ID: <20080123173922.GF12877@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use KSYM_NAME_LEN instead of numeric value

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/sh64/kernel/unwind.c
===================================================================
--- linux-2.6.git.orig/arch/sh64/kernel/unwind.c	2008-01-21 19:35:06.000000000 +0300
+++ linux-2.6.git/arch/sh64/kernel/unwind.c	2008-01-23 19:16:41.000000000 +0300
@@ -46,7 +46,7 @@ static int lookup_prev_stack_frame(unsig
 		      struct pt_regs *regs)
 {
 	const char *sym;
-	char namebuf[128];
+	char namebuf[KSYM_NAME_LEN];
 	unsigned long offset;
 	unsigned long prologue = 0;
 	unsigned long fp_displacement = 0;
