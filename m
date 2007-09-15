Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbXIOTzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbXIOTzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbXIOTzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:55:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45900 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbXIOTzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:55:41 -0400
Message-ID: <46EC3843.8010405@oracle.com>
Date: Sat, 15 Sep 2007 12:53:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org> <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com> <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 15 Sep 2007, Randy Dunlap wrote:
>> Had another on recent last night (probably not helpful):
> 
> At least the original "crashme" would write its random number seeds to a 
> logfile each time (and I made it fsync it in some versions), which meant 
> that once a crash happened, you could re-produce it immediately (if it was 
> reproducible at all, of course).
> 
> Does your crashme have something like that?

I tell it the "random" seed to use.  I can also sets its debug level,
but when I did that yesterday, it never faulted, so I lowered it again,
them boom.  Could be coincidence.


> All your crashes look basically identical - I don't think there is 
> anything new in this one, they're all the same issue. What CPU do you have 
> - vendor, stepping, version etc - and has something else than the kernel 
> changed in your setup lately?

Just kernel changes.  CPU is dual Pentium Xeon + HT:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      :                   Intel(R) Xeon(TM) CPU 3.40GHz
stepping        : 4
cpu MHz         : 3400.227
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 c
lflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl est t
m2 cid xtpr
bogomips        : 6805.96
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      :                   Intel(R) Xeon(TM) CPU 3.40GHz
stepping        : 4
cpu MHz         : 3400.227
cache size      : 1024 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 c
lflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl est t
m2 cid xtpr
bogomips        : 6800.28
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      :                   Intel(R) Xeon(TM) CPU 3.40GHz
stepping        : 4
cpu MHz         : 3400.227
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 c
lflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl est t
m2 cid xtpr
bogomips        : 6800.72
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 15
model           : 3
model name      :                   Intel(R) Xeon(TM) CPU 3.40GHz
stepping        : 4
cpu MHz         : 3400.227
cache size      : 1024 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 c
lflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl est t
m2 cid xtpr
bogomips        : 6800.57
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:



> As mentioned, the crash does look like a user-level crash got reported as 
> a kernel page fault, and while a CPU bug sounds incredibly unlikely, this 
> does have the smell of something strange like a fault in the middle of an 
> "iretq" or "sysretq", where part of the CPU state has already been 
> restored - which would explain why rip/cs is user space - but some part of 
> the CPU is still in kernel mode - which would explain the incorrect page 
> fault error code.
> 
> Here's a really *stupid* patch (and untested too, btw) to see if it gets 
> easier to debug when you don't oops, just print the register state 
> instead.

Will add this patch.

> (It might be interesting to also do something like
> 
> 	force_sig_specific(SIGSTOP, current);
> 
> to then be able to more easily attach to the process that had problems, 
> and debug it in user space to see what was going on..)
> 
> 		Linus
> ---
> diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
> index 327c9f2..1b81392 100644
> --- a/arch/x86_64/mm/fault.c
> +++ b/arch/x86_64/mm/fault.c
> @@ -320,6 +320,11 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
>  
>  	info.si_code = SEGV_MAPERR;
>  
> +	if (!(error_code & PF_USER) && user_mode(regs)) {
> +		printk("kernel mode page fault from user space? Huh?\n");
> +		__show_regs(regs);
> +		error_code |= PF_USER;
> +	}
>  
>  	/*
>  	 * We fault-in kernel-space virtual memory on-demand. The

