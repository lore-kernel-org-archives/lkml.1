Return-Path: <linux-kernel-owner+w=401wt.eu-S1751567Ab0AGJ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0AGJ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456Ab0AGJ1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:27:44 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52297 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0AGJ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:27:41 -0500
Date: Thu, 7 Jan 2010 14:57:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-ID: <20100107092736.GW3059@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
 <20100104005030.GG16187@balbir.in.ibm.com>
 <20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
 <20100106070150.GL3059@balbir.in.ibm.com>
 <20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107071554.GO3059@balbir.in.ibm.com>
 <20100107163610.aaf831e6.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107083440.GS3059@balbir.in.ibm.com>
 <20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
 <20100107180800.7b85ed10.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100107180800.7b85ed10.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-07 18:08:00]:

> On Thu, 7 Jan 2010 17:48:14 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > "How pages are shared" doesn't show good hints. I don't hear such parameter
> > > > is used in production's resource monitoring software.
> > > > 
> > > 
> > > You mean "How many pages are shared" are not good hints, please see my
> > > justification above. With Virtualization (look at KSM for example),
> > > shared pages are going to be increasingly important part of the
> > > accounting.
> > > 
> > 
> > Considering KSM, your cuounting style is tooo bad.
> > 
> > You should add 
> > 
> >  - MEM_CGROUP_STAT_SHARED_BY_KSM
> >  - MEM_CGROUP_STAT_FOR_TMPFS/SYSV_IPC_SHMEM
> > 

No.. I am just talking about shared memory being important and shared
accounting being useful, no counters for KSM in particular (in the
memcg context).

> > counters to memcg rather than scanning. I can help tests.
> > 
> > I have no objections to have above 2 counters. It's informative.
> > 

Apart from those two, I want to provide what Pss provides today or an
approximation of it.

> > But, memory reclaim can page-out pages even if pages are shared.
> > So, "how heavy memcg is" is an independent problem from above coutners.
> > 
> 
> In other words, above counters can show
> "What role the memcg play in the system" to some extent.
> 
> But I don't express it as "heavy" ....."importance or influence of cgroup" ?
> 
> Thanks,
> -Kame
> 
> 

-- 
	Balbir
