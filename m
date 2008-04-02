Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYDBJeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYDBJeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 05:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYDBJe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 05:34:28 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:53320 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYDBJe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 05:34:27 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Wed, 2 Apr 2008 11:34:24 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200804020029.12019.chunkeey@web.de> <alpine.LFD.1.10.0804020820130.3219@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804020820130.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021134.24555.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+NjKoSpVq2XPHlKYQCl6WL54TSnlO7lAj0Ccd+
	KGV88TcdHpk1BN4qMUL9F/DejnemZXYOOiVImT+JR9+ZJWNSuQ
	N9PZS/dZQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008 09:08:29 Thomas Gleixner wrote:
> On Wed, 2 Apr 2008, Chr wrote:
> > On Tuesday 01 April 2008 18:27:34 Thomas Gleixner wrote:
> > > On Tue, 1 Apr 2008, Chr wrote:
> > > > Ahhm it happend again (well, actually it's the fifth time today, but
> > > > this time I _hopefully_ found something)
> > > >
> > > > (direct link)
> > > > http://bugzilla.kernel.org/attachment.cgi?id=15542
> > >
> > > # expires at 4839289000000 nsecs [in -168780949682 nsecs]
> > >
> > > That's strange. Local APIC timer interrupt seems to be stuck.
> > >
> > > Can you please upload a boot log and the output of
> > > /proc/timer_list of 2.6.24.x to the bugzilla ?
> > >
> > > Does adding "noapictimer" to the command line help ?
> >
> > noapictimer seems to help too... (chrony is on)
>
> Ok. Can you please provide the output of /proc/cpuinfo ?
>
> Thanks,
>
> 	tglx

ok...

/proc/cpuinfo:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 43
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 1
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 
3dnow rep_good pni lahf_lm cmp_legacy
bogomips	: 2012.13
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 43
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 1
cpu MHz		: 1000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 
3dnow rep_good pni lahf_lm cmp_legacy
bogomips	: 2012.13
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

Regards,
	Chr.
