Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYGOPOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYGOPOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYGOPNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:13:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:51140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYGOPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:13:48 -0400
Subject: Re: [patch 01/15] Kernel Tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20080715144628.GD20037@Krystal>
References: <20080709145929.352201601@polymtl.ca>
	 <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins>
	 <20080715132543.GB20037@Krystal> <1216130593.12595.189.camel@twins>
	 <20080715144628.GD20037@Krystal>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 17:13:49 +0200
Message-Id: <1216134829.12595.207.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 10:46 -0400, Mathieu Desnoyers wrote:

> Talking about headers, I have noticed that placing headers with the code
> may not be as clean as I would hope. For instance, the kernel/irq-trace.h
> header, when included from kernel/irq/handle.c, has to be included with:
> 
> #include "../irq-trace.h"
> 
> Which is not _that_ bad, but we we want to instrument the irq handler
> found in arch/x86/kernel/cpu/mcheck/mce_intel_64.c, including
> #include "../../../../../kernel/irq-trace.h" makes me go "yeeeek!"
> 
> How about creating include/trace/irq.h and friends ?

Might as well.. anybody else got opinions?

