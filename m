Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZIGKlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZIGKlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZIGKlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:41:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34549 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZIGKlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:41:16 -0400
Date: Mon, 7 Sep 2009 12:41:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907104118.GQ18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <h82ma1$h9f$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h82ma1$h9f$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Nikos Chantziaras wrote:
> On 09/07/2009 12:49 PM, Jens Axboe wrote:
>> [...]
>> And I have to apologize for using a large system to test this on, I
>> realize it's out of the scope of BFS, but it's just easier to fire one
>> of these beasts up than it is to sacrifice my notebook or desktop
>> machine...
>
> How does a kernel rebuild constitute "sacrifice"?

It's more of a bother since I have to physically be at the notebook,
where as the server type boxes usually have remote management. The
workstation I use currently, so it'd be very disruptive to do it there.
And as things are apparently very alpha on the bfs side currently, it's
easier to 'sacrifice' an idle test box. That's the keyword, 'test'
boxes. You know, machines used for testing. Not production machines.

Plus the notebook is using btrfs which isn't format compatible with
2.6.30 on disk format.

Is there a point to this question?

>> So it's a 64 thread box. CFS -jX runtime is the baseline at
>> 100, lower number means faster and vice versa. The latency numbers are
>> in msecs.
>>
>>
>> Scheduler       Runtime         Max lat     Avg lat     Std dev
>> ----------------------------------------------------------------
>> CFS             100             951         462         267
>> CFS-x2          100             983         484         308
>> BFS
>> BFS-x2
>>
>> And unfortunately this is where it ends for now, since BFS doesn't boot
>> on the two boxes I tried.
>
> Then who post this in the first place?

You snipped the relevant part of the conclusion, the part where I make a
comment on the cfs latencies.

Don't bother replying to any of my emails if YOU continue writing emails
in this fashion. I have MUCH better things to do than entertain kiddies.
If you do get your act together and want to reply, follow lkml etiquette
and group reply.

-- 
Jens Axboe

