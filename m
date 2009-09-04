Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbZIDPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbZIDPbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbZIDPba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:31:30 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:47389 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927AbZIDPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:31:30 -0400
Date: Fri, 4 Sep 2009 17:31:31 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Subject: Re: CPU scheduler weirdness?
In-Reply-To: <20090904124054.GA9490@elte.hu>
Message-ID: <alpine.LNX.2.00.0909041724210.11404@cinke.fazekas.hu>
References: <alpine.LNX.2.00.0908191353100.19120@cinke.fazekas.hu> <1250683834.7583.360.camel@twins> <alpine.LNX.2.00.0908191428300.20409@cinke.fazekas.hu> <1250707331.7154.1.camel@laptop> <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>
 <20090820105645.GA23635@elte.hu> <alpine.LNX.2.00.0908201814270.12548@cinke.fazekas.hu> <alpine.LNX.2.00.0908282240480.32738@cinke.fazekas.hu> <alpine.LNX.2.00.0909032350580.20701@cinke.fazekas.hu> <1252053631.7564.2.camel@twins>
 <20090904124054.GA9490@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 4 Sep 2009, Ingo Molnar wrote:

>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Thu, 2009-09-03 at 23:57 +0200, Marton Balint wrote:
>>>> sched: fine-tune SD_MC_INIT:
>>>> 14800984706bf6936bbec5187f736e928be5c218
>>>>
>>>> If I add again the removed SD_BALANCE_NEWIDLE to flags, then everything works
>>>> as expected. So what would be the correct fix for this bug? Revert the patch?
>>>> Or just add SD_BALANCE_NEWIDLE to flags?
>>>
>>>
>>> Ingo, Peter, could any of you guys have a look at the commit
>>> that caused this bug? Is it OK to revert it? Or a fix somewhere
>>> else is necessary? I'm pushing this because I hope that this bug
>>> will get fixed in the upcoming stable kernel...
>>
>> I'm fine with re-adding SD_BALANCE_IDLE and SD_WAKE_IDLE on
>> SMT/MC/CPU levels.
>>
>> Ingo?
>
> Ok, agreed. I have re-benchmarked a couple of key workload and it
> seems like a good change, on top of your load-balancer fixes.
>
> Marton, could you please double check the latest -tip tree:
>
>  http://people.redhat.com/mingo/tip.git/README
>
> Does it resolve the problem?

Yes it does, thanks.

Regards,
   Marton
