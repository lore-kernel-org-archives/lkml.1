Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0CERIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:08:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab0CERIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:08:43 -0500
Message-ID: <4B913A83.4040805@redhat.com>
Date: Fri, 05 Mar 2010 12:08:19 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H . Peter Anvin" <hpa@zytor.com>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Archs <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf: Introduce new perf_save_regs() for hot regs
 snapshot
References: <1267605529.25158.75.camel@laptop> <1267758486-30499-2-git-send-regression-fweisbec@gmail.com> <4B911E57.60004@redhat.com> <20100305163838.GA5244@nowhere>
In-Reply-To: <20100305163838.GA5244@nowhere>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Fri, Mar 05, 2010 at 10:08:07AM -0500, Masami Hiramatsu wrote:
>>> +void perf_arch_save_regs(struct pt_regs *regs, unsigned long ip, int skip)
>>
>> Hmm, why would you call it 'save_regs' ?
>> It seems that this function is just for fixing registers 
>> instead of saving it into somewhere...
>>
>> Thank you,
> 
> 
> Hmm, save_regs() describes what it does: you pass
> a pt_regs and it saves registers inside. But it
> has also a kind of fixup thing as it also rewinds.

Ah, I see. so this saves current register values
into pt_regs. :)

> 
> I'm not sure using a fixup thing for the naming
> is correct as we are not starting with initial
> regs passed to the function (just a raw buffer).
> 
> What about perf_save_caller_regs() ?
> 

Hmm, I think, it might be better perf_get_caller_regs()
or something like that (fetch ?). 

Thank you,


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
