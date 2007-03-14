Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbXCNBAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbXCNBAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 21:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXCNBAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 21:00:51 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:42715 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbXCNBAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 21:00:51 -0400
Message-ID: <45F74917.40806@cosmosbay.com>
Date: Wed, 14 Mar 2007 02:00:07 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Anton Blanchard <anton@samba.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan>	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>	 <20070312220042.GA807@kryten> <29495f1d0703131736l74a63c15n94f03527d7e63500@mail.gmail.com>
In-Reply-To: <29495f1d0703131736l74a63c15n94f03527d7e63500@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 14 Mar 2007 02:00:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan a écrit :
> On 3/12/07, Anton Blanchard <anton@samba.org> wrote:
>>
>> Hi Nick,
>>
>> > Anyway, I'll keep experimenting. If anyone from MySQL wants to help 
>> look
>> > at this, send me a mail (eg. especially with the sched_setscheduler 
>> issue,
>> > you might be able to do something better).
>>
>> I took a look at this today and figured Id document it:
>>
>> http://ozlabs.org/~anton/linux/sysbench/
>>
>> Bottom line: it looks like issues in the glibc malloc library, replacing
>> it with the google malloc library fixes the negative scaling:
>>
>> # apt-get install libgoogle-perftools0
>> # LD_PRELOAD=/usr/lib/libtcmalloc.so /usr/sbin/mysqld
> 
> Quick datapoint, still collecting data and trying to verify it's
> always the case: on my 8-way Xeon, I'm actually seeing *much* worse
> performance with libtcmalloc.so compared to mainline. Am generating
> graphs and such still, but maybe someone else with x86_64 hardware
> could try the google PRELOAD and see if it helps/hurts (to rule out
> tester stupidity)?

I wish I had a 8-way test platform :)

Anyway, could you post some oprofile results ?

