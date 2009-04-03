Return-Path: <linux-kernel-owner+w=401wt.eu-S1764621AbZDCObW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764621AbZDCObW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZDCObJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:31:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32947 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646AbZDCObI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:31:08 -0400
Message-ID: <49D61D85.7030609@redhat.com>
Date: Fri, 03 Apr 2009 17:30:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu> <49D5F80B.7000305@redhat.com> <49D61B56.9020408@redhat.com>
In-Reply-To: <49D61B56.9020408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Hmm, I'd like to know actually kvm aims to emulate all kinds of
> instructions. 

We're less interested in fpu/sse.  The interesting instructions are 
those used for page table management, mmio, and real mode execution.

> If so, I might find some bugs in x86_emulate.c.
> However, I don't know all bugs. To find all of them, we have to
> port x86_emulate.c to user-space, decode binaries with it, and
> compare its output with another decoder, as Jim had done with insn.c.
>
>   

That would be very useful.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

