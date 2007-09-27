Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXI0Row@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXI0Row (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXI0Roo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:44:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37201 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbXI0Ron (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:44:43 -0400
Date: Thu, 27 Sep 2007 10:40:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: vatsa@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, efault@gmx.de, dhaval@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH -mm] Hook up group scheduler with control groups
Message-Id: <20070927104005.2ed0b81d.randy.dunlap@oracle.com>
In-Reply-To: <20070927150624.GG4415@linux.vnet.ibm.com>
References: <20070927150624.GG4415@linux.vnet.ibm.com>
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

On Thu, 27 Sep 2007 20:36:24 +0530 Srivatsa Vaddagiri wrote:

> Andrew,
> 	This is a resend of the patch I had sent earlier at:
> 	
> http://marc.info/?l=linux-kernel&m=119065506607858
> 
> This patch enables group cpu scheduler feature to work with control
> groups.
> 
> Could you include this in -mm for folks to test it?

Hi  :)

Uh, a few of my previous comments weren't fixed... (below)


> --
> 
> Enable "cgroup" (formerly containers) based fair group scheduling.
> This will let administrator create arbitrary groups of tasks (using
> "cgroup" pseudo filesystem) and control their cpu bandwidth usage.
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
> +          infrastructure that works with cgroups

Use tab + 2 spaces consistently for help text indentation.
End that sentence with a ".".

> +	depends on CGROUPS
> +
>  config FAIR_GROUP_SCHED
>  	bool "Fair group CPU scheduler"
>  	default y



---
~Randy
Phaedrus says that Quality is about caring.
