Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZAKBTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZAKBTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZAKBTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:19:31 -0500
Received: from relay3.sgi.com ([192.48.171.31]:34302 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031AbZAKBTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:19:30 -0500
Message-ID: <49694915.7020605@sgi.com>
Date: Sat, 10 Jan 2009 17:19:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] irq: change irq_desc and kstat_irq_legacy to	variable
 sized arrays
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110224323.GA17917@elte.hu> <49693A18.5090802@sgi.com> <20090111011044.GE12885@elte.hu>
In-Reply-To: <20090111011044.GE12885@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Here's my latest stats:
>>
>> ====== Text/Data ()
>>
>>     1 - 128-defconfig
>>     2 - 4k-defconfig
> 
> 
> small nit, shouldnt this:
>>       .1.       .2.    ..final..
> 
> be:
>>       .1.      .2    .delta
> 
> as 'final' is .2 in essence, just in absolute numbers, right? Confusing.
> 
> 
>>   5935104     -6144   5928960 -0.10%  TextSize
>>   3833856    +43008   3876864 +1.12%  DataSize
>>   9734144   -219136   9515008 -2.25%  BssSize
>>   2449408   +790528   3239936   +32%  InitSize
>>   1884160     +6144   1890304 +0.33%  PerCPU
>>    110592   +462848    573440  +418%  OtherSize
> 
> and flip around columns 2 and 3 ? It's the delta that matters, and the 
> percentage figure.
> 
> 	Ingo

Sure thing.  This originally was built for many columns so the net effect
of each was fairly important.  But with only two columns it does make
sense to do a direct comparision.

Thanks,
Mike

