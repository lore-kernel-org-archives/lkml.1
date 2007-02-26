Return-Path: <linux-kernel-owner+w=401wt.eu-S1030223AbXBZNli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223AbXBZNli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030230AbXBZNli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:41:38 -0500
Received: from smtp105.plus.mail.mud.yahoo.com ([68.142.206.238]:30513 "HELO
	smtp105.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030223AbXBZNlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:41:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gcjoC+AzaKVcVPT6m6xN3E5bya4hgLEOkQJKZyl8M+dUfmICclazmqTJv6H8V3R3m8x9TUOcoTb7AX0MC339CXdeR5ypD6TGAWgQtgS4UFjMys/8wrsoW0GB98JZLRgxhTc1xTkq9fvT6t9+3Q/ddsavs05KQg+58xOkVjsuQV8=  ;
X-YMail-OSG: xbnaenYVM1lTHH8TjWtbpLazPBHAQ7o1.j7r4_XtpkmdyL43iFGCg6qZcbgb8iZauL2taR07g57epTcpSfk8S7Pte6Aq7PePG6hmCxyvDpAWQH4pp4FmTQ--
Message-ID: <45E2E38A.2010309@yahoo.com.au>
Date: Tue, 27 Feb 2007 00:41:30 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rik van Riel <riel@redhat.com>, Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
In-Reply-To: <45E2E244.8040009@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Rik van Riel wrote:
> 
>> Lorenzo Allegrucci wrote:
>>
>>> Hi lkml,
>>>
>>> according to the test below (sysbench) Linux seems to have scalability
>>> problems beyond 8 client threads:
>>> http://jeffr-tech.livejournal.com/6268.html#cutid1
>>> http://jeffr-tech.livejournal.com/5705.html
>>> Hardware is an 8-core amd64 system and jeffr seems willing to try more
>>> Linux versions on that machine.
>>> Anyway, is there anyone who can reproduce this?
>>
>>
>>
>> I have reproduced it on a quad core test system.
>>
>> With 4 threads (on 4 cores) I get a high throughput, with
>> approximately 58% user time and 42% system time.
>>
>> With 8 threads (on 4 cores) I get way lower throughput,
>> with 37% user time, 29% system time 35% idle time!
>>
>> The maximum time taken per query also increases from
>> 0.0096s to 0.5273s. Ouch!
>>
>> I don't know if this is MySQL, glibc or Linux kernel,
>> but something strange is going on...
> 
> 
> Like you, I'm also seeing idle time start going up as threads increase.
> 
> I initially thought this was a problem with the multiprocessor scheduler,
> because the pattern is exactly like some artificat in the load balancing.

"artificat"

Wow. I must need some sleep :) Please excuse any other typos!

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
