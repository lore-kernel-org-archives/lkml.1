Return-Path: <linux-kernel-owner+w=401wt.eu-S935865AbZDCSBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935865AbZDCSBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935696AbZDCSAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:00:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45977 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935688AbZDCSAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:00:50 -0400
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <49D63F70.7040308@redhat.com>
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu>
	 <49D5F80B.7000305@redhat.com> <49D61B56.9020408@redhat.com>
	 <20090403142325.GA14932@elte.hu>  <49D63F70.7040308@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 10:59:55 -0700
Message-Id: <1238781595.3568.32.camel@dyn9047018139.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 12:55 -0400, Masami Hiramatsu wrote:
> Ingo Molnar wrote:
> > * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> > 
> >> Hmm, I'd like to know actually kvm aims to emulate all kinds of 
> >> instructions. If so, I might find some bugs in x86_emulate.c. 
> >> However, I don't know all bugs. To find all of them, we have to 
> >> port x86_emulate.c to user-space, decode binaries with it, and 
> >> compare its output with another decoder, as Jim had done with 
> >> insn.c.
> >>
> >> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
> > 
> > btw., i'd suggest we put a build time check for this into the kernel 
> > version as well. For example to decode the vmlinux via objdump, run 
> > it through your decoder as well and compare the results. Put under a 
> > CONFIG_DEBUG_X86_DECODER_TEST kind of (deault-off) build-time 
> > self-test.
> > 
> > This would ensure that the kernel we are running is fully supported 
> > by the decoder - even as GCC/GAS starts using new instructions, etc. 
> > 
> > How does this sound to you?
> 
> Thanks! That is a good idea.
> Jim, would you think you can port your script into kernel tree?
...

I'd be happy to do what's needed to make it happen, and maintain it in
the face of x86 changes.  The script itself is practically nothing (~100
lines of awk and C), but what I don't know about the kernel build is a
lot, so I'd need some help from a kernel-build expert.

Jim

