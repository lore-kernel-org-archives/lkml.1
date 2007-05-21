Return-Path: <linux-kernel-owner+w=401wt.eu-S934510AbXEUUNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510AbXEUUNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764197AbXEUUN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:13:29 -0400
Received: from h155.mvista.com ([63.81.120.158]:55324 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764175AbXEUUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:13:28 -0400
Subject: Re: v2.6.21-rt3
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070517194143.GA25394@elte.hu>
References: <20070517194143.GA25394@elte.hu>
Content-Type: text/plain
Date: Mon, 21 May 2007 13:11:06 -0700
Message-Id: <1179778266.15427.38.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Where did the arm ep93xx changes come from? It looks like patch below
came in with them in 2.6.21-rt6 ..

--- linux.orig/include/asm-arm/system.h
+++ linux/include/asm-arm/system.h
@@ -235,8 +235,9 @@ static inline void set_copro_access(unsi
  * so enable interrupts over the context switch to avoid high
  * latency.
  */
+#if 0 // preempt_rt hack, because warn_on in shedule.c triggers
 #define __ARCH_WANT_INTERRUPTS_ON_CTXSW
-
+#endif
 /*
  * switch_to(prev, next) should switch from task `prev' to `next'
  * `prev' will never be the same as `next'.  schedule() itself


