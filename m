Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXHBUcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXHBUcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbXHBUbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:31:52 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:55871 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621AbXHBUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:31:51 -0400
Date: Thu, 2 Aug 2007 16:30:47 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Gabriel C <nix.or.die@googlemail.com>, Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: ACPI on Averatec 2370
In-Reply-To: <46B23E08.4070106@redhat.com>
Message-ID: <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
 <46ACD8DB.2020108@googlemail.com> <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>
 <46B22BDA.8090604@redhat.com> <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
 <46B23E08.4070106@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Chuck Ebbert wrote:

> On 08/02/2007 03:42 PM, Cal Peake wrote:
> > On Thu, 2 Aug 2007, Chuck Ebbert wrote:
> > 
> >> Try the 'nolapic_timer' option.
> > 
> > Ah, thank you Chuck! This looks to have fixed the stalling/hanging 
> > problems I was having.
> > 
> > Now I'm wondering if arch/i386/kernel/cpu/amd.c:amd_apic_timer_broken() 
> > can (or needs to) be updated for this particular CPU revision.
> 
> What does your /proc/cpuinfo say?

Figured I should have sent that right after I hit the send key...

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 72
model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping	: 2
cpu MHz		: 1607.320
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
bogomips	: 3216.76
clflush size	: 64

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 72
model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping	: 2
cpu MHz		: 1607.320
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
bogomips	: 3214.55
clflush size	: 64

-- 
Cal Peake

