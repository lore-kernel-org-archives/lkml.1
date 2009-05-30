Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZE3FV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZE3FV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 01:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZE3FVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 01:21:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45996 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZE3FVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 01:21:17 -0400
Date: Sat, 30 May 2009 13:21:13 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] add swap cache interface for swap reference v2
	(updated)
Message-ID: <20090530052113.GD24073@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090528135455.0c83bedc.kamezawa.hiroyu@jp.fujitsu.com> <20090528141049.cc45a116.kamezawa.hiroyu@jp.fujitsu.com> <20090529132153.3a72f2c3.nishimura@mxp.nes.nec.co.jp> <20090529140832.1f4b288b.kamezawa.hiroyu@jp.fujitsu.com> <20090529143758.4c3db3eb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090529143758.4c3db3eb.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-05-29 14:37:58]:

> On Fri, 29 May 2009 14:08:32 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > IIUC, swap_free() at the end of shmem_writepage() should also be changed to swapcache_free().
> > > 
> > Hmm!. Oh, yes. shmem_writepage()'s error path. Thank you. It will be fixed.
> > 
> here. 
> 
> ==
> 
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> In following patch, usage of swap cache will be recorded into swap_map.
> This patch is for necessary interface changes to do that.
> 
> 2 interfaces:
>   - swapcache_prepare()
>   - swapcache_free()
> is added for allocating/freeing refcnt from swap-cache to existing
> swap entries. But implementation itself is not changed under this patch.
> At adding swapcache_free(), memcg's hook code is moved under swapcache_free().
> This is better than using scattered hooks.
> 
> Changelog: v1->v2
>  - fixed shmem_writepage() error path.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Looks good to me so far

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 


-- 
	Balbir
