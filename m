Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZCLFEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZCLFEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZCLFEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:04:39 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:40744 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZCLFEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:04:38 -0400
Date: Thu, 12 Mar 2009 10:34:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-ID: <20090312050423.GI23583@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com> <20090312034647.GA23583@balbir.in.ibm.com> <20090312133949.130b20ed.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090312133949.130b20ed.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 13:39:49]:

> On Thu, 12 Mar 2009 09:16:47 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-12 09:52:47]:
> > I've tested so far by
> > 
> > Creating two cgroups and then 
> > 
> > a. Assigning limits of 1G and 2G and run memory allocation and touch
> > test
> softlimit ?
>

Yes
 
> > b. Same as (a) with 1G and 1G
> > c. Same as (a) with 0 and 1G
> > d. Same as (a) with 0 and 0
> > 
> > More comments in induvidual patches.
> > 
> Then,
>   1. what's the number of active threads ?

One for each process in the two groups

>   2. what's the number of cpus ?

4

>   3. what's the numa configuration, if numa ?

Fake NUMA with nodes = 4, I have DMA, DMA32 and NORMAL split across
nodes.

>   4. what's the zone configuration ?
>   5. what's arch ?
>   6. what's amount of total memory ?

I have 4GB on x86-64 system (Quad Core)

>   7. Do you find difference in behavior with and without softlimit ?

Very much so.. I see the resources being shared as defined by soft
limits.

>   8. Do you tested *this* version ?
> 

Not yet.. you just posted it. I am testing my v5, which I'll post
soon. I am seeing very good results with v5. I'll test yours later
today.

> Thanks,
> -Kame

-- 
	Balbir
