Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbZFSCFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbZFSCFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZFSCFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:05:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61956 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZFSCFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:05:21 -0400
Message-ID: <4A3AF273.6010502@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 10:05:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2] ftrace: change the export format of trace_kfree_skb()
References: <4A2DF91F.7030906@cn.fujitsu.com> <20090609182730.GA6057@nowhere> <4A2F0F1D.7010101@cn.fujitsu.com> <20090610072618.GA6016@nowhere> <4A39B3E4.6060004@cn.fujitsu.com> <alpine.DEB.2.00.0906182033101.6890@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906182033101.6890@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Steven Rostedt wrote:

>> Changelog v1->v2:
>> Convert protocol from raw numeric to its name as Frederic's suggestion
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> I get this:
> 
>   CC      net/core/net-traces.o
> In file included from include/trace/ftrace.h:262,
>                  from include/trace/define_trace.h:57,
>                  from include/trace/events/skb.h:107,
>                  from net/core/net-traces.c:28:
> include/trace/events/skb.h: In function 'ftrace_raw_output_kfree_skb':
> include/trace/events/skb.h:78: error: 'ETH_P_IEEE802154' undeclared (first 
> use in this function)
> include/trace/events/skb.h:78: error: (Each undeclared identifier is 
> reported only once
> include/trace/events/skb.h:78: error: for each function it appears in.)
> 

I use Ingo's tip tree and this build error not occur in my test, I also find
ETH_P_IEEE802154 is added by Sergey Lapin's patch, it's merged recently, can
be found here:
	http://marc.info/?l=git-commits-head&m=124515655608598&w=2

Could you check ETH_P_IEEE802154 is defined in include/linux/if_ether.h and
your code is the latest?

Thanks,
Xiao Guangrong

> -- Steve
> 
> 
