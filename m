Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZD2L2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZD2L2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZD2L2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:28:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50962 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbZD2L2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:28:41 -0400
Date: Wed, 29 Apr 2009 13:28:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/29] x86/perfcounters: x86 and AMD cpu updates
Message-ID: <20090429112829.GB8813@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com> <20090429110936.GI2373@elte.hu> <1241004163.8021.256.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241004163.8021.256.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-04-29 at 13:09 +0200, Ingo Molnar wrote:
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > This patch series updates the perfcounters implementation mainly 
> > > for the x86 architecture.
> > 
> > Wow, very nice series! Still havent looked through all of them, but 
> > wanted to give some quick feedback that the splitup and direction 
> > looks all good.
> 
> Agreed, patches look nice, thanks!
> 
> > > I developed this patches based on 03ced43 and later rebased to 
> > > 1b88991. The latest tip/percounters/core branch seems to be 
> > > broken, no nmis are delivered, only perfcounter interrupts with no 
> > > results on kerneltop. I am still debugging this. However, I could 
> > > test successfully the patch series based on 03ced43 and want to 
> > > release the patches anyway.
> > 
> > hm, it works all fine for me. This is "perf top" output from an 
> > AMD/Barcelona box:
> 
> Works on my opteron as well:
> 
> vendor_id       : AuthenticAMD                         
> cpu family      : 15                                   
> model           : 67                                   
> model name      : Dual-Core AMD Opteron(tm) Processor 1216
> stepping        : 2 

Mine is:

processor	: 15
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 2
model name	: Quad-Core AMD Opteron(tm) Processor 8356
stepping	: 3
cpu MHz		: 2300.000
cache size	: 512 KB
physical id	: 3
siblings	: 1
core id		: 3
cpu cores	: 4
apicid		: 19
initial apicid	: 15
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr 
pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx 
mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc 
arch_perfmon rep_good nonstop_tsc pni monitor cx16 lahf_lm 
cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 
3dnowprefetch osvw ibs
bogomips	: 4621.68
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

	Ingo
