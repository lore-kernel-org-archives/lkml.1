Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbZAIWe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbZAIWe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbZAIWdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:33:44 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34015 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602AbZAIWdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:33:42 -0500
Date: Sat, 10 Jan 2009 04:03:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: clean up Kconfig
Message-ID: <20090109223337.GN9737@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4966B370.5070707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4966B370.5070707@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-01-09 10:16:16]:

> - move CONFIG_PROC_PID_CPUSET into cgroup menu
> - move MM_OWNER to the bottom for better menu indent
> - fix typos
> - use tabs not spaces
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  init/Kconfig |   56 ++++++++++++++++++++++++++++----------------------------
>  1 files changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index a724a14..56fd93c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -328,11 +328,10 @@ config CGROUP_SCHED
> 
>  endchoice
> 
> -menu "Control Group support"
> -config CGROUPS
> -	bool "Control Group support"
> +menuconfig CGROUPS
> +	boolean "Control Group support"
>  	help
> -	  This option add support for grouping sets of processes together, for
> +	  This option adds support for grouping sets of processes together, for
>  	  use with process control subsystems such as Cpusets, CFS, memory
>  	  controls or device isolation.
>  	  See
> @@ -343,6 +342,8 @@ config CGROUPS
> 
>  	  Say N if unsure.
> 
> +if CGROUPS
> +
>  config CGROUP_DEBUG
>  	bool "Example debug cgroup subsystem"
>  	depends on CGROUPS
> @@ -350,24 +351,24 @@ config CGROUP_DEBUG
>  	help
>  	  This option enables a simple cgroup subsystem that
>  	  exports useful debugging information about the cgroups
> -	  framework
> +	  framework.
> 
> -	  Say N if unsure
> +	  Say N if unsure.
> 
>  config CGROUP_NS
> -        bool "Namespace cgroup subsystem"
> -        depends on CGROUPS
> -        help
> -          Provides a simple namespace cgroup subsystem to
> -          provide hierarchical naming of sets of namespaces,
> -          for instance virtual servers and checkpoint/restart
> -          jobs.
> +	bool "Namespace cgroup subsystem"
> +	depends on CGROUPS
> +	help
> +	  Provides a simple namespace cgroup subsystem to
> +	  provide hierarchical naming of sets of namespaces,
> +	  for instance virtual servers and checkpoint/restart
> +	  jobs.
> 
>  config CGROUP_FREEZER
> -        bool "control group freezer subsystem"
> -        depends on CGROUPS
> -        help
> -          Provides a way to freeze and unfreeze all tasks in a
> +	bool "Freezer cgroup subsystem"
> +	depends on CGROUPS
> +	help
> +	  Provides a way to freeze and unfreeze all tasks in a
>  	  cgroup.
> 
>  config CGROUP_DEVICE
> @@ -388,18 +389,23 @@ config CPUSETS
> 
>  	  Say N if unsure.
> 
> +config PROC_PID_CPUSET
> +	bool "Include legacy /proc/<pid>/cpuset file"
> +	depends on CPUSETS
> +	default y
> +
>  config CGROUP_CPUACCT
>  	bool "Simple CPU accounting cgroup subsystem"
>  	depends on CGROUPS
>  	help
>  	  Provides a simple Resource Controller for monitoring the
> -	  total CPU consumed by the tasks in a cgroup
> +	  total CPU consumed by the tasks in a cgroup.
> 
>  config RESOURCE_COUNTERS
>  	bool "Resource counters"
>  	help
>  	  This option enables controller independent resource accounting
> -          infrastructure that works with cgroups
> +	  infrastructure that works with cgroups.
>  	depends on CGROUPS
> 
>  config CGROUP_MEM_RES_CTLR
> @@ -425,9 +431,6 @@ config CGROUP_MEM_RES_CTLR
>  	  This config option also selects MM_OWNER config option, which
>  	  could in turn add some fork/exit overhead.
> 
> -config MM_OWNER
> -	bool
> -
>  config CGROUP_MEM_RES_CTLR_SWAP
>  	bool "Memory Resource Controller Swap Extension(EXPERIMENTAL)"
>  	depends on CGROUP_MEM_RES_CTLR && SWAP && EXPERIMENTAL
> @@ -444,8 +447,10 @@ config CGROUP_MEM_RES_CTLR_SWAP
>  	  there will be no overhead from this. Even when you set this config=y,
>  	  if boot option "noswapaccount" is set, swap will not be accounted.
> 
> +endif # CGROUPS
> 
> -endmenu
> +config MM_OWNER
> +	bool
> 
>  config SYSFS_DEPRECATED
>  	bool
> @@ -483,11 +488,6 @@ config SYSFS_DEPRECATED_V2
>  	  if the original kernel, that came with your distribution, has
>  	  this option set to N.
> 
> -config PROC_PID_CPUSET
> -	bool "Include legacy /proc/<pid>/cpuset file"
> -	depends on CPUSETS
> -	default y
> -
>  config RELAY
>  	bool "Kernel->user space relay support (formerly relayfs)"
>  	help
> -- 
> 1.5.4.rc3
> 

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
