Return-Path: <linux-kernel-owner+w=401wt.eu-S1763109AbXKOA4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763109AbXKOA4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbXKOA4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:56:41 -0500
Received: from www.tglx.de ([62.245.132.106]:48827 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbXKOA4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:56:40 -0500
Date: Thu, 15 Nov 2007 01:56:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Bird <tim.bird@am.sony.com>
cc: linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       John Cooper <john.cooper@third-harmonic.com>
Subject: Re: rt-preempt: problem compiling rt-preempt 2.6.23.1-rt11 on MIPS
In-Reply-To: <473B8F91.20704@am.sony.com>
Message-ID: <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
References: <473B8F91.20704@am.sony.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Tim Bird wrote:

Added Steven and John to CC

> I applied the patches in patch-2.6.23.1-rt11-broken-out.tar.bz2
> to a Linux kernel version 2.6.23.1 (along with a few other
> board specific patches).
> 
> I got the following compilation error:
> 
>   GEN     /home/tbird/work/rt-preempt/build/tx49/Makefile
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    /home/tbird/work/rt-preempt/linux-2.6.23.1-rt11/scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      kernel/latency_trace.o
> /home/tbird/work/rt-preempt/linux-2.6.23.1-rt11/kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
> make[2]: *** [kernel/latency_trace.o] Error 1
> make[1]: *** [kernel] Error 2
> make: *** [vmlinux] Error 2
> 
> Indeed, there is no include/asm-mips/rtc.h.
> 
> I commented out the include line in latency_trace.c, and everything
> compiled fine.  I'm not sure what is needed in an arch-specific rtc.h,
> but compiling without it for the mips arch caused no problems.
> Should I create a patch with a stub for rtc.h for mips?

Hm, dunno why the rtc.h include was added.

> As an aside, this has me worried.  Is anyone else doing any
> RT Preempt testing or work on MIPS platforms, or am I forging
> new ground? :-)

I fear you are the one who is in charge to get mips working again :)
But as always, there are bad news and good news:  As far as I heard
last week John Cooper is looking into this as well.

Thanks,

	tglx
