Return-Path: <linux-kernel-owner+w=401wt.eu-S1763757AbZAOK7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763757AbZAOK7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbZAOK7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:59:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59945 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZAOK7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:59:43 -0500
Date: Thu, 15 Jan 2009 19:58:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] cgroup/memcg : updates related to CSS
Message-Id: <20090115195834.e07e604d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090115105116.GG30358@balbir.in.ibm.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090115105116.GG30358@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 16:21:16 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 19:21:20]:
> 
> > 
> > I'm sorry that I couldn't work so much, this week.
> > No much updates but I think all comments I got are applied.
> > 
> > About memcg part, I'll wait for that all Nishimura's fixes go ahead.
> > If cgroup part looks good, please Ack. I added CC to Andrew Morton for that part.
> > 
> > changes from previous series
> >   - dropeed a fix to OOM KILL   (will reschedule)
> >   - dropped a fix to -EBUSY     (will reschedule)
> >   - added css_is_populated()
> >   - added hierarchy_stat patch
> > 
> > Known my homework is
> >   - resize_limit should return -EBUSY. (Li Zefan reported.)
> > 
> > Andrew, I'll CC: you [1/4] and [2/4]. But no explicit Acked-by yet to any patches.
> >
> 
> Kamezawa-San, like you've suggested earlier, I think it is important
> to split up the fixes from the development patches. I wonder if we
> should start marking all patches with BUGFIX for bug fixes, so that we
> can prioritize those first.
>  
Ah yes. I'll do that from next post. 

patch [1/4] and [2/4] doesnt modify memcg at all. So, I added Andrew to CC.
It's a new feature for cgroup.

for memcg part. of course, I'll wait for all Nishimura's fixes goes to -rc.

patch [3/4] will remove most of them, crazy maze of hierarchical reclaim.
patch [4/4] is written for demonstration. but the output seems atractive.

Thanks,
-Kame

