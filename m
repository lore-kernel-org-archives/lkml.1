Return-Path: <linux-kernel-owner+w=401wt.eu-S965586AbXCBUda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbXCBUda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965584AbXCBUda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:33:30 -0500
Received: from mail.tmr.com ([64.65.253.246]:55637 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965582AbXCBUd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:33:29 -0500
Message-ID: <45E88A50.8060906@tmr.com>
Date: Fri, 02 Mar 2007 15:34:24 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: Fix for raid6 reshape.
References: <20070302155626.19014.patches@notabene>	<1070302045655.19069@suse.de>	<20070301223619.d9957521.akpm@linux-foundation.org> <17895.50900.585915.565155@notabene.brown>
In-Reply-To: <17895.50900.585915.565155@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Thursday March 1, akpm@linux-foundation.org wrote:
>   
>> On Fri, 2 Mar 2007 15:56:55 +1100 NeilBrown <neilb@suse.de> wrote:
>>
>>     
>>> -	conf->expand_progress = (sector_nr + i)*(conf->raid_disks-1);
>>> +	conf->expand_progress = (sector_nr + i) * new_data_disks);
>>>       
>> ahem.
>>     
>
>
> It wasn't like that when I tested it, honest...
> But the original got caught up with some other changes which were not
> really related so I removed them all and just made this change
> manually.... and totally messed it up (again).  Sorry.
>
> Of course it should be
>
>   
>>> +	conf->expand_progress = (sector_nr + i) * new_data_disks;
>>>       
Will the (real) fix be in 2.6.21?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

