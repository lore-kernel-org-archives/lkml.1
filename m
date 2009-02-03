Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZBCEee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZBCEee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZBCEeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:34:11 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53106 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZBCEeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:34:10 -0500
Date: Tue, 3 Feb 2009 10:04:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM
Message-ID: <20090203043404.GK918@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090202125240.GA918@balbir.in.ibm.com> <20090202140849.GB918@balbir.in.ibm.com> <20090203102157.9f643965.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090203102157.9f643965.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-03 10:21:57]:

> On Mon, 2 Feb 2009 19:38:49 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-02-02 18:22:40]:
> > 
> > > Hi, All,
> > > 
> > > I found the following patch useful while debugging the memory
> > > controller. It adds additional information if memcg invoked the OOM.
> > > 
> > > Comments, Suggestions?
> > >
> > 
> > 
> > Description: Add RSS and swap to OOM output from memcg
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> 
> > This patch displays memcg values like failcnt, usage and limit
> > when an OOM occurs due to memcg.
> > 
> 
> please use "KB" not bytes in OOM killer information.
> 
> And the most important information is dropped..
> Even if you show information, the most important information that
> "where I am and where we hit limit ?" is not coverred.
> Could you consider some way to show full-path ?
> 
>   OOM-Killer:
>   Task in /memory/xxx/yyy/zzz is killed by
>   Limit of /memory/xxxx
>   RSS Limit :     Usage:     Failcnt....
>   RSS+SWAP Limit: ....
>

Sounds good to me, let me add this information. 

-- 
	Balbir
