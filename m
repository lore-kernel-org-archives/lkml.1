Return-Path: <linux-kernel-owner+w=401wt.eu-S1751175AbZCFKGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbZCFKGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCFKFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:05:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZCFKFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:05:44 -0500
Message-ID: <49B0F579.2030903@cn.fujitsu.com>
Date: Fri, 06 Mar 2009 18:05:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>	 <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>	 <1236250159.4228.186.camel@laptop> <20090305110522.GI32407@elte.hu>	 <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com> <1236328083.5187.1213.camel@laptop>
In-Reply-To: <1236328083.5187.1213.camel@laptop>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-03-05 at 13:57 -0800, David Rientjes wrote:
>> It shouldn't be dropped, the initialization is necessary because we can't 
>> rely on atomic_t's implementation.
> 
> I'm a bit slow, please use more words and explain this to me.
> 

I once was also (and is still not sure) wondering if it's better to use
INIT_HLIST_HEAD() for initialization for the reason David is claiming..

The situation is similar with this ATOMIC_INIT(), that INIT_HLIST_HEAD()
just set 2 pointers to 0, and not every user of hlist calls this INIT()
at initialization phase.

But I'll definitely on David's side if it's not kernel project.

> Before replying please read:
> 
> ea435467500612636f8f4fb639ff6e76b2496e4b
> 
> and stare at the output of:
> 
> git grep "define[ \t]*ATOMIC_INIT\>"
> 

