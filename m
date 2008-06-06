Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbYFFPUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbYFFPUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbYFFPU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:20:29 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50558 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756884AbYFFPU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:20:28 -0400
Message-ID: <484955B9.5070704@sgi.com>
Date: Fri, 06 Jun 2008 08:20:25 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
References: <20080606002957.6329a0ec.akpm@linux-foundation.org> <20080606024811.70db9ab2.akpm@linux-foundation.org> <20080606035413.37f340ef.akpm@linux-foundation.org> <20080606115759.GA29321@elte.hu> <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com> <48493CBD.1000202@sgi.com> <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com> <19f34abd0806060707x7570c835u4b1837b54dfa36ba@mail.gmail.com> <484947A9.5050804@sgi.com> <19f34abd0806060736m10424455kfbc3e6272d18646e@mail.gmail.com> <20080606145717.GA5300@elte.hu> <484951E6.1030207@sgi.com>
In-Reply-To: <484951E6.1030207@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> Hi Ingo,
> 
> My -tip branch has:
> 
> 	a953e4597abd51b74c99e0e3b7074532a60fd031
> 
> 	sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
> 	committed: 2008-05-23 09:22:17
> 
> The check for node > nr_node_ids however should be included (at least
> when CONFIG_DEBUG_PER_CPU_MAPS is enabled.)
> 
> Thanks,
> Mike

Note this was in the following set of patches:


 -      Subject: [PATCH 01/10] percpu: Use a kconfig variable to signal arch specific percpu setup
 -      Subject: [PATCH 00/11] x86: cleanup early per cpu variables/accesses v5-folded
 -      Subject: [PATCH 04/11] x86: remove the static 256k node_to_cpumask_map
 -      Subject: [PATCH 03/11] x86: restore pda nodenumber field
 -      Subject: [PATCH 08/11] x86: Add performance variants of cpumask operators
 -      Subject: [PATCH 09/11] x86: Use performance variant for_each_cpu_mask_nr
 -      Subject: [PATCH 02/11] x86: cleanup early per cpu variables/accesses v4
 -      Subject: [PATCH 06/11] cpu: change some globals to statics in drivers/base/cpu.c v2
 -      Subject: [PATCH 07/11] x86: remove static boot_cpu_pda array
 -      Subject: [PATCH 05/11] sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
 -      Subject: [PATCH 11/11] net: Pass reference to cpumask variable in net/sunrpc/svc.c

 -	Date: Fri, 25 Apr 2008 17:15:48 -0700

(Some have been further modified by later patches.)

The patch ordering was incorrect as I removed the node_to_cpumask_map before I replaced
the MAX_NUMNODES, should have been the opposite.


