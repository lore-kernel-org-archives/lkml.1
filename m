Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZIDMcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZIDMcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 08:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZIDMcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 08:32:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59960 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbZIDMcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 08:32:31 -0400
Date: Fri, 4 Sep 2009 18:02:15 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrea Righi <arighi@develer.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v1 PATCH 3/7] sched: Bandwidth initialization for fair
	task groups
Message-ID: <20090904123215.GA3601@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090825094729.GP3663@in.ibm.com> <20090825094950.GS3663@in.ibm.com> <20090904104324.GA10807@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904104324.GA10807@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 12:43:25PM +0200, Andrea Righi wrote:
> On Tue, Aug 25, 2009 at 03:19:50PM +0530, Bharata B Rao wrote:
> > +config CFS_HARD_LIMITS
> > +	bool "Hard Limits for CFS Group Scheduler"
> > +	depends on EXPERIMENTAL
> > +	depends on FAIR_GROUP_SCHED
> 
> Shouldn't depend also on CGROUPS and CGROUP_SCHED? without them hard
> limits can't be defined, right?

Right, but do we need to explicitly mention CGROUPS as dependency since
CGROUP_SCHED is already dependent on it ?

> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
>  init/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 71868a0..19c0290 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -459,7 +459,7 @@ config FAIR_GROUP_SCHED
>  config CFS_HARD_LIMITS
>  	bool "Hard Limits for CFS Group Scheduler"
>  	depends on EXPERIMENTAL
> -	depends on FAIR_GROUP_SCHED
> +	depends on FAIR_GROUP_SCHED && CGROUPS && CGROUP_SCHED
>  	default n
>  	help
>  	  This option enables hard limiting of CPU time obtained by

Thanks for looking at the patches.

Regards,
Bharata.
