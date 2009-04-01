Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZDAUut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZDAUut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZDAUuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:50:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58596 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZDAUug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:50:36 -0400
Message-ID: <49D3D3B4.4060702@redhat.com>
Date: Wed, 01 Apr 2009 16:51:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 0/4 V3] tracing: kprobe-based event tracer
References: <49CC08A2.5030602@redhat.com> <20090401133654.GB18677@elte.hu>	<49D37584.50208@redhat.com> <873acsm8qp.fsf@basil.nowhere.org>
In-Reply-To: <873acsm8qp.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Masami Hiramatsu <mhiramat@redhat.com> writes:
>> I agreed. Fortunately, Jim Keniston and I wrote an x86 instruction
>> decoder :-) which has been made originally for uprobe andd kprobes
>> jump-optimizer.
>>
>> https://www.redhat.com/archives/utrace-devel/2009-March/msg00031.html
> 
> An alternative would be to adapt the x86 interpreter in KVM.
> I thought for some time that that one should be available in 
> a more generic form in a library.

As far as I can see, KVM's instruction emulator is incomplete
(it doesn't cover all instructions...) and aims to emulate
instructions, not to analyze (so I couldn't relay on it).

Anyway, I think making x86 interpreter in a library is a good idea.

Thank you,

> 
> -Andi
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

