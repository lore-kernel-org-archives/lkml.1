Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZBYID6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZBYID6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 03:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbZBYIDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 03:03:43 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36490 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760717AbZBYIDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 03:03:41 -0500
Date: Wed, 25 Feb 2009 13:33:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cgroup/memcg show correct file mode
Message-ID: <20090225080329.GE11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090225163555.d2a0b24c.kamezawa.hiroyu@jp.fujitsu.com> <20090225163729.cc43bd5c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090225163729.cc43bd5c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-25 16:37:29]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Set correct permission to memcg's file.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: mmotm-2.6.29-Feb24/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.29-Feb24.orig/mm/memcontrol.c
> +++ mmotm-2.6.29-Feb24/mm/memcontrol.c
> @@ -2218,6 +2218,7 @@ static struct cftype mem_cgroup_files[] 
>  		.name = "usage_in_bytes",
>  		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
>  		.read_u64 = mem_cgroup_read,
> +		.mode = 0444
>  	},
>  	{
>  		.name = "max_usage_in_bytes",
> @@ -2240,10 +2241,12 @@ static struct cftype mem_cgroup_files[] 
>  	{
>  		.name = "stat",
>  		.read_map = mem_control_stat_show,
> +		.mode = 0444
>  	},
>  	{
>  		.name = "force_empty",
>  		.trigger = mem_cgroup_force_empty_write,
> +		.mode = 0200
>  	},
>  	{
>  		.name = "use_hierarchy",
> @@ -2263,6 +2266,7 @@ static struct cftype memsw_cgroup_files[
>  		.name = "memsw.usage_in_bytes",
>  		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
>  		.read_u64 = mem_cgroup_read,
> +		.mode = 0444
>  	},
>  	{
>  		.name = "memsw.max_usage_in_bytes",
> 
>

Yes, please, very much required

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
