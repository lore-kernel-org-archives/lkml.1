Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbZDCQ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbZDCQ4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbZDCQ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:56:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49234 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbZDCQ4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:56:02 -0400
Message-ID: <49D63F70.7040308@redhat.com>
Date: Fri, 03 Apr 2009 12:55:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>
CC: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com> <49D61B56.9020408@redhat.com> <20090403142325.GA14932@elte.hu>
In-Reply-To: <20090403142325.GA14932@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hmm, I'd like to know actually kvm aims to emulate all kinds of 
>> instructions. If so, I might find some bugs in x86_emulate.c. 
>> However, I don't know all bugs. To find all of them, we have to 
>> port x86_emulate.c to user-space, decode binaries with it, and 
>> compare its output with another decoder, as Jim had done with 
>> insn.c.
>>
>> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
> 
> btw., i'd suggest we put a build time check for this into the kernel 
> version as well. For example to decode the vmlinux via objdump, run 
> it through your decoder as well and compare the results. Put under a 
> CONFIG_DEBUG_X86_DECODER_TEST kind of (deault-off) build-time 
> self-test.
> 
> This would ensure that the kernel we are running is fully supported 
> by the decoder - even as GCC/GAS starts using new instructions, etc. 
> 
> How does this sound to you?

Thanks! That is a good idea.
Jim, would you think you can port your script into kernel tree?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

