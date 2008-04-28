Return-Path: <linux-kernel-owner+w=401wt.eu-S935836AbYD1W0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935836AbYD1W0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933495AbYD1W0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:26:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933684AbYD1W0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:26:09 -0400
Message-ID: <48164EC2.6050906@redhat.com>
Date: Mon, 28 Apr 2008 18:25:06 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for	sched-devel.git
References: <20080424150324.802695381@polymtl.ca>	 <1209238735.6441.4.camel@lappy>	 <20080428113610.b2d1e8e4.akpm@linux-foundation.org> <1209412359.6433.12.camel@lappy>
In-Reply-To: <1209412359.6433.12.camel@lappy>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-04-28 at 11:36 -0700, Andrew Morton wrote:
>> On Sat, 26 Apr 2008 21:38:54 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>> lets hide the ugly bits.
>> It hides the cosmetically-ugly bits, but not the deeply ugly: each of these
>> trace points is an extension to the kernel->userspace API, with all that
>> this implies.
> 
> Agreed, and I'm rather concerned about that as well. OTOH its very
> unlikely we'll ever have a Linux that will not have a context switch, or
> task wakeup operation.
> 
> So tracing these and things like syscall seem safe enough to do -
> although I wish it wouldn't look so ugly. 

What would you think about the basic-hardware events like
interruptions, and exceptions?:-)

> As for some of these other trace points in this set, dubious.
> 
> We can of course clearly state that any marker is free of API
> constraints and users will have to cope with them changing. But I'm not
> sure that's a realistic position.


BTW, I also have a question about the maintenance policy of markers.
Who will pay a cost for updating (maintaining) those trace points
according to changing logic of the kernel?

I think that each developer who modifies the kernel has to fix
trace points just for removing compile-errors. They can (but don't need to)
leave, update or remove the trace points to fit their changes, because they
knows their changes precisely, but they don't know why the trace points are
there and what information is required.
So, trace points should be basically maintained by trace point maintainers
who know all about the trace points.
is that right?

Thanks,

Best regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


