Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZEKNIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZEKNIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZEKNIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:08:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZEKNIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:08:09 -0400
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
 X86_FEATURE_ARCH_PERFMON flag for AMD cpus
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090511123935.GA10722@erda.amd.com>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
	 <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
	 <1241931753.4796.15.camel@localhost.localdomain>
	 <1241934795.4796.55.camel@localhost.localdomain>
	 <20090510063047.GD30778@elte.hu>
	 <1242044024.10115.3.camel@localhost.localdomain>
	 <20090511123935.GA10722@erda.amd.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 18:37:12 +0530
Message-Id: <1242047232.3301.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Mon, 2009-05-11 at 14:39 +0200, Robert Richter wrote:
> On 11.05.09 17:43:44, Jaswinder Singh Rajput wrote:
> > On Sun, 2009-05-10 at 08:30 +0200, Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> > > > > should be replaced by
> > > > > #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Performace Monitor */
> > > > > 
> > > > > All x86 cpus which support performance monitor should set this feature.
> > > > > 
> > > > 
> > > > Currently X86_FEATURE_ARCH_PERFMON is enabled for >= Intel Core2
> > > > 
> > > > But Performance monitor is almost supported by all Intel 
> > > > processors. I am adding few MSRs list for reference to see 
> > > > complete list please check arch/x86/kernel/cpu/cpu_debug.c
> > > 
> > > I think you are confusing two things:
> > > 
> > > - The 'architectural perfmon' CPU flag, enumerated in CPUID. (this 
> > >   is a relatively new CPUID flag that only Intel CPUs at around 
> > >   Core2 and later will report.)
> > > 
> > > - The concept of 'performance monitoring' - which has been present 
> > >   in various x86 CPUs starting at the original Pentium (P5) 15 years 
> > >   ago or so.
> > > 
> > 
> > Here is the patch for review for ancient performance monitoring
> > cpufeature, complete cpu_debug and cpu_feature patches are available
> > at :
> > http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=summary
> > 
> > Subject: [PATCH] x86: Add cpufeature for ancient performance monitoring
> 
> Jaswinder,
> 
> which branch is this patch against? It is not tip/perfcounters/core
> nor tip/master.
> 

This patch was based on
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=summary
(git tree takes some time for update)

These patches are still for review and I will release these patches in
one or two days after adding some more patches.

--
JSR

