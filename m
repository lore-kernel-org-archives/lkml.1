Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbYGOSzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbYGOSzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYGOSzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:55:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781AbYGOSzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:55:38 -0400
Message-ID: <487CF206.4010905@redhat.com>
Date: Tue, 15 Jul 2008 14:52:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch 01/15] Kernel Tracepoints
References: <20080709145929.352201601@polymtl.ca>	 <20080709150043.693920317@polymtl.ca> <1216108237.12595.122.camel@twins>	 <20080715132543.GB20037@Krystal> <1216130593.12595.189.camel@twins>	 <20080715144628.GD20037@Krystal> <1216134829.12595.207.camel@twins>
In-Reply-To: <1216134829.12595.207.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Peter Zijlstra wrote:
> On Tue, 2008-07-15 at 10:46 -0400, Mathieu Desnoyers wrote:
> 
>> Talking about headers, I have noticed that placing headers with the code
>> may not be as clean as I would hope. For instance, the kernel/irq-trace.h
>> header, when included from kernel/irq/handle.c, has to be included with:
>>
>> #include "../irq-trace.h"
>>
>> Which is not _that_ bad, but we we want to instrument the irq handler
>> found in arch/x86/kernel/cpu/mcheck/mce_intel_64.c, including
>> #include "../../../../../kernel/irq-trace.h" makes me go "yeeeek!"
>>
>> How about creating include/trace/irq.h and friends ?
> 
> Might as well.. anybody else got opinions?

I just wonder why DEFINE_TRACE are used in separated headers
instead of include/linux/irq.h directly.

anyway, #include <trace/XXX.h> is good to me.

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

