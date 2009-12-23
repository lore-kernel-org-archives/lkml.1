Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZLWIrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZLWIrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZLWIre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:47:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:46423 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZLWIrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:47:32 -0500
Message-ID: <4B31D99D.4070705@kernel.org>
Date: Wed, 23 Dec 2009 17:49:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu> <4B31C210.4010100@kernel.org> <20091223080144.GG23839@elte.hu> <4B31D487.6060706@kernel.org> <20091223083705.GA25240@elte.hu>
In-Reply-To: <20091223083705.GA25240@elte.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/23/2009 05:37 PM, Ingo Molnar wrote:
>> Sure, fair enough but there's also a different side.  It'll allow much 
>> easier implementation of things like in-kernel media presence polling (I 
>> have some code for this but it's still just forming) and per-device.  It 
>> gives a much easier tool to extract concurrency and thus opens up new 
>> possibilities.
>>
>> So, anyways, alright, I'll go try some conversions.
> 
> Well, but note that you are again talking performance. Concurrency
> _IS_ performance: either in terms of reduced IO/app/request latency
> or in terms of CPU utilization.

I wasn't talking about performance above.  Easiness or flexibility to
extract concurrency opens up possibilities for new things or easier
ways of doing things.  It affects the design process.  You don't have
to jump through hoops for concurrency management and removing that
restriction results in lower amount of convolution and simplifies
design.

Thanks.

-- 
tejun
