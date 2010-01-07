Return-Path: <linux-kernel-owner+w=401wt.eu-S932788Ab0AGJLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0AGJLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932731Ab0AGJLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:11:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56228 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab0AGJLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:11:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 18:08:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100107180800.7b85ed10.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091229182743.GB12533@balbir.in.ibm.com>
	<20100104085108.eaa9c867.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104000752.GC16187@balbir.in.ibm.com>
	<20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104005030.GG16187@balbir.in.ibm.com>
	<20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
	<20100106070150.GL3059@balbir.in.ibm.com>
	<20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107071554.GO3059@balbir.in.ibm.com>
	<20100107163610.aaf831e6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107083440.GS3059@balbir.in.ibm.com>
	<20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 17:48:14 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > "How pages are shared" doesn't show good hints. I don't hear such parameter
> > > is used in production's resource monitoring software.
> > > 
> > 
> > You mean "How many pages are shared" are not good hints, please see my
> > justification above. With Virtualization (look at KSM for example),
> > shared pages are going to be increasingly important part of the
> > accounting.
> > 
> 
> Considering KSM, your cuounting style is tooo bad.
> 
> You should add 
> 
>  - MEM_CGROUP_STAT_SHARED_BY_KSM
>  - MEM_CGROUP_STAT_FOR_TMPFS/SYSV_IPC_SHMEM
> 
> counters to memcg rather than scanning. I can help tests.
> 
> I have no objections to have above 2 counters. It's informative.
> 
> But, memory reclaim can page-out pages even if pages are shared.
> So, "how heavy memcg is" is an independent problem from above coutners.
> 

In other words, above counters can show
"What role the memcg play in the system" to some extent.

But I don't express it as "heavy" ....."importance or influence of cgroup" ?

Thanks,
-Kame

