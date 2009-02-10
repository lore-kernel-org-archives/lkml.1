Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZBJLA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZBJLA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZBJLAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:00:50 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55553 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZBJLAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:00:50 -0500
Date: Tue, 10 Feb 2009 16:30:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: remove mem_cgroup_reclaim_imbalance() perfectly
Message-ID: <20090210110045.GE16317@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090210184538.6FCF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090210184538.6FCF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-02-10 18:50:39]:

> 
> commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db (vmscan: 
> split LRU lists into anon & file sets) remove mem_cgroup_reclaim_imbalance().
> 
> but it isn't enough.
> memcontrol.h header file still have legacy parts.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
>  include/linux/memcontrol.h |    6 ------
>  1 file changed, 6 deletions(-)
>

The calc_mapped_ratio prototype should also be removed from this file. 

-- 
	Balbir
