Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbXKOBHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbXKOBHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXKOBH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:07:29 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:56053 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbXKOBH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:07:28 -0500
Date: Wed, 14 Nov 2007 20:06:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       John Cooper <john.cooper@third-harmonic.com>
Subject: Re: rt-preempt: problem compiling rt-preempt 2.6.23.1-rt11 on MIPS
In-Reply-To: <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0711142004080.1364@gandalf.stny.rr.com>
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Thomas Gleixner wrote:

> On Wed, 14 Nov 2007, Tim Bird wrote:
>
> Added Steven and John to CC
>
> > I applied the patches in patch-2.6.23.1-rt11-broken-out.tar.bz2
> > to a Linux kernel version 2.6.23.1 (along with a few other
> > board specific patches).
> >
> > I got the following compilation error:
> >
> >   GEN     /home/tbird/work/rt-preempt/build/tx49/Makefile
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   CALL    /home/tbird/work/rt-preempt/linux-2.6.23.1-rt11/scripts/checksyscalls.sh
> >   CHK     include/linux/compile.h
> >   CC      kernel/latency_trace.o
> > /home/tbird/work/rt-preempt/linux-2.6.23.1-rt11/kernel/latency_trace.c:28:21: error: asm/rtc.h: No such file or directory
> > make[2]: *** [kernel/latency_trace.o] Error 1
> > make[1]: *** [kernel] Error 2
> > make: *** [vmlinux] Error 2
> >
> > Indeed, there is no include/asm-mips/rtc.h.

Looks like that may be just an artifact from older days.

I'll do some more tests, and it it truely is, I'll go and remove the added
headers.

> >
> > I commented out the include line in latency_trace.c, and everything
> > compiled fine.  I'm not sure what is needed in an arch-specific rtc.h,
> > but compiling without it for the mips arch caused no problems.
> > Should I create a patch with a stub for rtc.h for mips?
>
> Hm, dunno why the rtc.h include was added.
>
> > As an aside, this has me worried.  Is anyone else doing any
> > RT Preempt testing or work on MIPS platforms, or am I forging
> > new ground? :-)
>
> I fear you are the one who is in charge to get mips working again :)
> But as always, there are bad news and good news:  As far as I heard
> last week John Cooper is looking into this as well.


I'm just about to release 2.6.24-rc2-rt1 and I'm sure mips as well as
powrepc is badly broken.  Any help in getting these back up and working
would be greatly appreciated.

-- Steve

