Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYKGQNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYKGQNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYKGQNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:13:11 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:34020 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYKGQNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:13:10 -0500
Message-ID: <491468F1.8070304@cosmosbay.com>
Date: Fri, 07 Nov 2008 17:12:33 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Robert Richter <robert.richter@amd.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI> <4910CD65.1010301@cosmosbay.com> <49113894.5040806@cosmosbay.com> <49130694.7000007@cosmosbay.com> <20081107130249.GN29626@one.firstfloor.org> <49145B26.4040701@cosmosbay.com> <20081107160553.GR29626@one.firstfloor.org>
In-Reply-To: <20081107160553.GR29626@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 07 Nov 2008 17:12:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> On Fri, Nov 07, 2008 at 04:13:42PM +0100, Eric Dumazet wrote:
>> Andi Kleen a écrit :
>>> Can you please test this patch and see if it solves the problem?
>>>
>>> Thanks,
>>> -Andi
>>>
>>> ---
>>>
>>> oprofile: Fix p6 counter overflow check
>>>
>>> Fix the counter overflow check for CPUs with counter width > 32
>>>
>>> I had a similar change in a different patch that I didn't submit
>>> and I didn't notice the problem earlier because it was always
>>> tested together.
>>>
>>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>>>
>> Thanks Andi
>>
>> Unfortunatly, there is still a freeze of NMIS after a while.
> 
> How long is the while?
> 

Less than 20 seconds if fully loaded with "tbench 8" on my 8 cpus machine.

With your patch, many events are handled by oprofile (about 10.000.000
last time I tried) before freeze.

Without your patch, freeze was very very fast, no more than 10.000 NMI...



> I don't see this here on a Merom when I let it run for
> 10 minutes or so.
> 
> You might need to bisect it.

Too many bugs during bisection unfortunatly, machine doesnt boot :(


