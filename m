Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZEKMlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZEKMlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbZEKMkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:40:16 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:32465
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758304AbZEKMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:40:12 -0400
X-BigFish: VPS-37(zz1432R62a3L98dR936eQ1805Mzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJHCIO-01-4X1-01
Date: Mon, 11 May 2009 14:39:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
	X86_FEATURE_ARCH_PERFMON flag for AMD cpus
Message-ID: <20090511123935.GA10722@erda.amd.com>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com> <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org> <1241931753.4796.15.camel@localhost.localdomain> <1241934795.4796.55.camel@localhost.localdomain> <20090510063047.GD30778@elte.hu> <1242044024.10115.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1242044024.10115.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 May 2009 12:39:37.0213 (UTC) FILETIME=[8B7D8AD0:01C9D235]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.09 17:43:44, Jaswinder Singh Rajput wrote:
> On Sun, 2009-05-10 at 08:30 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> > > > should be replaced by
> > > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Performace Monitor */
> > > > 
> > > > All x86 cpus which support performance monitor should set this feature.
> > > > 
> > > 
> > > Currently X86_FEATURE_ARCH_PERFMON is enabled for >= Intel Core2
> > > 
> > > But Performance monitor is almost supported by all Intel 
> > > processors. I am adding few MSRs list for reference to see 
> > > complete list please check arch/x86/kernel/cpu/cpu_debug.c
> > 
> > I think you are confusing two things:
> > 
> > - The 'architectural perfmon' CPU flag, enumerated in CPUID. (this 
> >   is a relatively new CPUID flag that only Intel CPUs at around 
> >   Core2 and later will report.)
> > 
> > - The concept of 'performance monitoring' - which has been present 
> >   in various x86 CPUs starting at the original Pentium (P5) 15 years 
> >   ago or so.
> > 
> 
> Here is the patch for review for ancient performance monitoring
> cpufeature, complete cpu_debug and cpu_feature patches are available
> at :
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=summary
> 
> Subject: [PATCH] x86: Add cpufeature for ancient performance monitoring

Jaswinder,

which branch is this patch against? It is not tip/perfcounters/core
nor tip/master.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

