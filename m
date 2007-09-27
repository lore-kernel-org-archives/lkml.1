Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXI0TCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXI0TCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbXI0TCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:02:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58861 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbXI0TCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:02:47 -0400
Date: Thu, 27 Sep 2007 12:00:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, dmitry.adamushko@gmail.com, efault@gmx.de,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH -mm] Hook up group scheduler with control groups
Message-Id: <20070927120033.45915a61.randy.dunlap@oracle.com>
In-Reply-To: <20070927180415.GC5715@linux.vnet.ibm.com>
References: <20070927150624.GG4415@linux.vnet.ibm.com>
	<20070927104005.2ed0b81d.randy.dunlap@oracle.com>
	<20070927180415.GC5715@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 23:34:15 +0530 Dhaval Giani wrote:

> > > +config RESOURCE_COUNTERS
> > > +	bool "Resource counters"
> > > +	help
> > > +	  This option enables controller independent resource accounting
> > > +          infrastructure that works with cgroups
> > 
> > Use tab + 2 spaces consistently for help text indentation.
> > End that sentence with a ".".
> > 
> 
> Hi,
> 
> hmmmm. So I looked into the sources with the patches applied, and they
> don't have an indentation problem. It looks fine. I'm not sure why the
> patch is getting generated like this though. Will fix up the '.' though.
> 
> Here it is,
> 
> Thanks,
> --
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by : Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 
> ---
>  include/linux/cgroup_subsys.h |    6 ++
>  init/Kconfig                  |   24 +++++---
>  kernel/sched.c                |  122 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 145 insertions(+), 7 deletions(-)
> 
> Index: current/include/linux/cgroup_subsys.h
> ===================================================================
> --- current.orig/include/linux/cgroup_subsys.h
> +++ current/include/linux/cgroup_subsys.h
> @@ -36,3 +36,9 @@ SUBSYS(mem_cgroup)
>  #endif
>  
>  /* */
> +
> +#ifdef CONFIG_FAIR_CGROUP_SCHED
> +SUBSYS(cpu_cgroup)
> +#endif
> +
> +/* */
> Index: current/init/Kconfig
> ===================================================================
> --- current.orig/init/Kconfig
> +++ current/init/Kconfig
> @@ -319,6 +319,13 @@ config CPUSETS
>  
>  	  Say N if unsure.
>  
> +config RESOURCE_COUNTERS
> +	bool "Resource counters"
> +	help
> +	  This option enables controller independent resource accounting

Above line is tab + 2 spaces (i.e., correct).

> +          infrastructure that works with cgroups.

Above line indent is 10 spaces (i.e., not correct).


> +	depends on CGROUPS
> +
>  config FAIR_GROUP_SCHED
>  	bool "Fair group CPU scheduler"
>  	default y

---
~Randy
Phaedrus says that Quality is about caring.
