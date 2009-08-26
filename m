Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbZHZAtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbZHZAtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZHZAtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:49:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63495 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZHZAts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:49:48 -0400
Message-ID: <4A94868C.4080801@cn.fujitsu.com>
Date: Wed, 26 Aug 2009 08:49:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, David Miller <davem@davemloft.net>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace_events: fix napi's tracepoint
References: <4A937EF5.4040505@cn.fujitsu.com> <4A93895F.4010708@cn.fujitsu.com> <20090825075816.GB857@elte.hu> <20090825105707.GA24710@hmsreliant.think-freely.org>
In-Reply-To: <20090825105707.GA24710@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Neil Horman wrote:
> On Tue, Aug 25, 2009 at 09:58:16AM +0200, Ingo Molnar wrote:
>> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
>>
>> This will collide with tracing bits in the networking tree. The 
>> skb-tracing plugin there should be turned into proper TRACE_EVENT() 
>> tracepoints.
>>
>> Neil was away for some time but i think soon we should see some 
>> movement here.
>>
>> 	Ingo
>>
> 
> Thank you Ingo, yes, I'm back from the beach now and will look at this shortly.
> I concur, we should just convert the napi_poll tracepoint to be defined via the
> TRACE_EVENT macro, same as the kfree_skb tracepoint.  Xaio would you like to
> take care of that, or shall I?
>

Hi Neil,

I'm glad to do it.

Actually, we should fix the include file dependencies first
(the second patch in this patchset), else we can't include two
TRACE_EVENT head files in net-traces.c

Steve will pull this patchset, so, I'll convert it after this
patchset merged.
