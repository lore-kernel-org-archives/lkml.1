Return-Path: <linux-kernel-owner+w=401wt.eu-S1763186AbZAOKv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763186AbZAOKv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZAOKvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:51:21 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41082 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbZAOKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:51:20 -0500
Date: Thu, 15 Jan 2009 16:21:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] cgroup/memcg : updates related to CSS
Message-ID: <20090115105116.GG30358@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-15 19:21:20]:

> 
> I'm sorry that I couldn't work so much, this week.
> No much updates but I think all comments I got are applied.
> 
> About memcg part, I'll wait for that all Nishimura's fixes go ahead.
> If cgroup part looks good, please Ack. I added CC to Andrew Morton for that part.
> 
> changes from previous series
>   - dropeed a fix to OOM KILL   (will reschedule)
>   - dropped a fix to -EBUSY     (will reschedule)
>   - added css_is_populated()
>   - added hierarchy_stat patch
> 
> Known my homework is
>   - resize_limit should return -EBUSY. (Li Zefan reported.)
> 
> Andrew, I'll CC: you [1/4] and [2/4]. But no explicit Acked-by yet to any patches.
>

Kamezawa-San, like you've suggested earlier, I think it is important
to split up the fixes from the development patches. I wonder if we
should start marking all patches with BUGFIX for bug fixes, so that we
can prioritize those first.
 

-- 
	Balbir
