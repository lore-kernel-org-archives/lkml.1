Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYF3GaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYF3GaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbYF3G30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:29:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbYF3G3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:29:25 -0400
Message-ID: <48687871.3040407@cn.fujitsu.com>
Date: Mon, 30 Jun 2008 14:08:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Lee.Schermerhorn@hp.com,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>, rientjes@google.com
Subject: Re: [PATCH] doc: Document the relax_domain_level kernel boot argument
References: <20080630045640.20308.22031.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080630045640.20308.22031.sendpatchset@polaris-admin.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> From: Paul Jackson <pj@sgi.com>
> 
> Document the kernel boot parameter: relax_domain_level=.
> 
> Signed-off-by: Paul Jackson <pj@sgi.com>
> 
> ---
>  Documentation/cpusets.txt           |    3 +++
>  Documentation/kernel-parameters.txt |    4 ++++
>  2 files changed, 7 insertions(+)
> 
> --- 2.6.26-rc5-mm3.orig/Documentation/cpusets.txt	2008-06-27 06:55:34.000000000 -0700
> +++ 2.6.26-rc5-mm3/Documentation/cpusets.txt	2008-06-29 21:49:53.984674621 -0700
> @@ -546,6 +546,9 @@ otherwise initial value -1 that indicate
>   ( 4  : search nodes in a chunk of node [on NUMA system] )
>   ( 5~ : search system wide [on NUMA system])
>  
> +The system default is 0 (no search).  The system default can be
> +changed using the relax_domain_level= boot parameter.
> +
>  This file is per-cpuset and affect the sched domain where the cpuset
>  belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
>  is disabled, then 'sched_relax_domain_level' have no effect since
> --- 2.6.26-rc5-mm3.orig/Documentation/kernel-parameters.txt	2008-06-27 06:28:26.000000000 -0700
> +++ 2.6.26-rc5-mm3/Documentation/kernel-parameters.txt	2008-06-29 21:51:10.477997208 -0700
> @@ -1732,6 +1732,10 @@ and is between 256 and 4096 characters. 
>  			Format: <reboot_mode>[,<reboot_mode2>[,...]]
>  			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
>  
> +	relax_domain_level=
> +			[KNL, SMP] Set schedulers default relax_domain_level.
> +			See Documentation/cpusets.txt.
> +

is [KNL,SMP] more consistent ?

and s/schedulers/scheduler's/

but maybe I'm wrong due to my English skill.

>  	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
>  
>  	reservetop=	[X86-32]
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

