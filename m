Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZELWDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZELWDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZELWCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:02:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35110 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZELWCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:02:42 -0400
Message-ID: <4A09F216.70203@redhat.com>
Date: Tue, 12 May 2009 18:03:02 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH -tip v5 0/7] tracing: kprobe-based event tracer and x86
 instruction decoder
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509044302.GH8007@elte.hu>
In-Reply-To: <20090509044302.GH8007@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hi,
>>
>> Here are the patches of kprobe-based event tracer for x86, version 
>> 5, which allows you to probe various kernel events through ftrace 
>> interface.
>>
>> This version supports only x86(-32/-64) (but porting it on other 
>> arch just needs kprobes/kretprobes and register and stack access 
>> APIs).
>>
>> This patchset also includes x86(-64) instruction decoder which 
>> supports non-SSE/FP opcodes and includes x86 opcode map. I think 
>> it will be possible to share this opcode map with KVM's decoder.
>>
>> This series can be applied on the latest linux-2.6-tip tree.
>>
>> This patchset includes following changes:
>> - Add x86 instruction decoder [1/7]
>> - Check insertion point safety in kprobe [2/7]
>> - Cleanup fix_riprel() with insn decoder [3/7]
>> - Add kprobe-tracer plugin [4/7]
>> - Fix kernel_trap_sp() on x86 according to systemtap runtime. [5/7]
>> - Add arch-dep register and stack fetching functions [6/7]
>> - Support fetching various status (register/stack/memory/etc.) [7/7]
>>
>> Future items:
>> - .init function tracing support.
>> - Support primitive types(long, ulong, int, uint, etc) for args.
> 
> Ok, this looks pretty complete already.
> 
> Two high-level comments:
> 
>  - There's no self-test - would it be possible to add one? See 
>    trace_selftest* in kernel/trace/
> 
>  - No generic integration.

Hmm, Ingo, could you tell me what I can do for the integration?
Would you means that I should use filters?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

