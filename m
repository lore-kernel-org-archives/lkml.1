Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbZBCCOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbZBCCOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZBCCNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:13:55 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45573 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZBCCNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:13:54 -0500
Date: Tue, 3 Feb 2009 11:12:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH] trivial: fix where cgroup documentation is not
 correctly referred to
Message-Id: <20090203111242.c71bedaa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1233614324-27603-1-git-send-email-cascardo@holoscopio.com>
References: <1233614324-27603-1-git-send-email-cascardo@holoscopio.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Feb 2009 20:38:44 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> cgroup documentation was moved to Documentation/cgroups/. There are some
> places that still refer to Documentation/controllers/,
> Documentation/cgroups.txt and Documentation/cpusets.txt. Fix those.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Thanks, very helpful.
for memory cgroup part, Ack from me.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  Documentation/kernel-parameters.txt            |    4 ++--
>  Documentation/scheduler/sched-rt-group.txt     |    2 +-
>  Documentation/vm/numa_memory_policy.txt        |    3 ++-
>  Documentation/vm/page_migration                |    3 ++-
>  Documentation/x86/x86_64/fake-numa-for-cpusets |    5 +++--
>  include/linux/cgroup.h                         |    5 ++++-
>  init/Kconfig                                   |    2 +-
>  7 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index d8362cf..4fd448b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1563,7 +1563,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  	nosoftlockup	[KNL] Disable the soft-lockup detector.
>  
>  	noswapaccount	[KNL] Disable accounting of swap in memory resource
> -			controller. (See Documentation/controllers/memory.txt)
> +			controller. (See Documentation/cgroups/memory.txt)
>  
>  	nosync		[HW,M68K] Disables sync negotiation for all devices.
>  
> @@ -1907,7 +1907,7 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	relax_domain_level=
>  			[KNL, SMP] Set scheduler's default relax_domain_level.
> -			See Documentation/cpusets.txt.
> +			See Documentation/cgroups/cpusets.txt.
>  
>  	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
>  
> diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
> index 3ef339f..5ba4d3f 100644
> --- a/Documentation/scheduler/sched-rt-group.txt
> +++ b/Documentation/scheduler/sched-rt-group.txt
> @@ -126,7 +126,7 @@ This uses the /cgroup virtual file system and "/cgroup/<cgroup>/cpu.rt_runtime_u
>  to control the CPU time reserved for each control group instead.
>  
>  For more information on working with control groups, you should read
> -Documentation/cgroups.txt as well.
> +Documentation/cgroups/cgroups.txt as well.
>  
>  Group settings are checked against the following limits in order to keep the configuration
>  schedulable:
> diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
> index 6aaaeb3..be45dbb 100644
> --- a/Documentation/vm/numa_memory_policy.txt
> +++ b/Documentation/vm/numa_memory_policy.txt
> @@ -8,7 +8,8 @@ The current memory policy support was added to Linux 2.6 around May 2004.  This
>  document attempts to describe the concepts and APIs of the 2.6 memory policy
>  support.
>  
> -Memory policies should not be confused with cpusets (Documentation/cpusets.txt)
> +Memory policies should not be confused with cpusets
> +(Documentation/cgroups/cpusets.txt)
>  which is an administrative mechanism for restricting the nodes from which
>  memory may be allocated by a set of processes. Memory policies are a
>  programming interface that a NUMA-aware application can take advantage of.  When
> diff --git a/Documentation/vm/page_migration b/Documentation/vm/page_migration
> index d5fdfd3..6513fe2 100644
> --- a/Documentation/vm/page_migration
> +++ b/Documentation/vm/page_migration
> @@ -37,7 +37,8 @@ locations.
>  
>  Larger installations usually partition the system using cpusets into
>  sections of nodes. Paul Jackson has equipped cpusets with the ability to
> -move pages when a task is moved to another cpuset (See ../cpusets.txt).
> +move pages when a task is moved to another cpuset (See
> +Documentation/cgroups/cpusets.txt).
>  Cpusets allows the automation of process locality. If a task is moved to
>  a new cpuset then also all its pages are moved with it so that the
>  performance of the process does not sink dramatically. Also the pages
> diff --git a/Documentation/x86/x86_64/fake-numa-for-cpusets b/Documentation/x86/x86_64/fake-numa-for-cpusets
> index 33bb566..0f11d9b 100644
> --- a/Documentation/x86/x86_64/fake-numa-for-cpusets
> +++ b/Documentation/x86/x86_64/fake-numa-for-cpusets
> @@ -7,7 +7,8 @@ you can create fake NUMA nodes that represent contiguous chunks of memory and
>  assign them to cpusets and their attached tasks.  This is a way of limiting the
>  amount of system memory that are available to a certain class of tasks.
>  
> -For more information on the features of cpusets, see Documentation/cpusets.txt.
> +For more information on the features of cpusets, see
> +Documentation/cgroups/cpusets.txt.
>  There are a number of different configurations you can use for your needs.  For
>  more information on the numa=fake command line option and its various ways of
>  configuring fake nodes, see Documentation/x86/x86_64/boot-options.txt.
> @@ -32,7 +33,7 @@ A machine may be split as follows with "numa=fake=4*512," as reported by dmesg:
>  	On node 3 totalpages: 131072
>  
>  Now following the instructions for mounting the cpusets filesystem from
> -Documentation/cpusets.txt, you can assign fake nodes (i.e. contiguous memory
> +Documentation/cgroups/cpusets.txt, you can assign fake nodes (i.e. contiguous memory
>  address spaces) to individual cpusets:
>  
>  	[root@xroads /]# mkdir exampleset
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index e267e62..1d9dd8f 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -341,7 +341,10 @@ int cgroup_task_count(const struct cgroup *cgrp);
>  /* Return true if the cgroup is a descendant of the current cgroup */
>  int cgroup_is_descendant(const struct cgroup *cgrp);
>  
> -/* Control Group subsystem type. See Documentation/cgroups.txt for details */
> +/*
> + * Control Group subsystem type.
> + * See Documentation/cgroups/cgroups.txt for details
> + */
>  
>  struct cgroup_subsys {
>  	struct cgroup_subsys_state *(*create)(struct cgroup_subsys *ss,
> diff --git a/init/Kconfig b/init/Kconfig
> index f068071..87e26cd 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -505,7 +505,7 @@ config CGROUP_MEM_RES_CTLR
>  	select MM_OWNER
>  	help
>  	  Provides a memory resource controller that manages both anonymous
> -	  memory and page cache. (See Documentation/controllers/memory.txt)
> +	  memory and page cache. (See Documentation/cgroups/memory.txt)
>  
>  	  Note that setting this option increases fixed memory overhead
>  	  associated with each page of memory in the system. By this,
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

