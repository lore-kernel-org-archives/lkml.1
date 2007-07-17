Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbXGQEXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbXGQEXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXGQEXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:23:06 -0400
Received: from mail.tmr.com ([64.65.253.246]:41855 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXGQEXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:23:05 -0400
Message-ID: <469C4418.4090207@tmr.com>
Date: Tue, 17 Jul 2007 00:22:48 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>
Subject: Re: [patch] CFS scheduler, -v19
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu>
In-Reply-To: <20070716215541.GA27171@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chuck Ebbert <cebbert@redhat.com> wrote:
>
>   
>> On 07/13/2007 05:19 PM, Bill Davidsen wrote:
>>     
>>> I should really go back to 2.6.21.6, 2.6.22 has many bizarre behaviors
>>> with FC6. Automount starts taking 30% of CPU (unused at the moment)
>>>       
>> Can you confirm whether CFS is involved, i.e. does it spin like that 
>> even without the CFS patch applied?
>>     
>
>   
I will try that, but not until Tuesday night. I've been here too long 
today and have an out-of-state meeting tomorrow. I'll take a look after 
dinner. Note that the latest 2.6.21 with cfs-v19 doesn't have any 
problems of any nature, other than suspend to RAM not working, and I may 
have the config wrong. Runs really well otherwise, but I'll test drive 
2.6.22 w/o the patch.

> hmmm .... could you take out the kernel/time.c (sys_time()) changes from 
> the CFS patch, does that solve the automount issue? If yes, could 
> someone take a look at automount and check whether it makes use of 
> time(2) and whether it combines it with finer grained time sources?
>
>   
Will do.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

