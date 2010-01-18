Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151Ab0ARLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0ARLX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898Ab0ARLXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:23:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:40809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab0ARLXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:23:13 -0500
Message-ID: <4B54445E.302@kernel.org>
Date: Mon, 18 Jan 2010 20:22:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-5-git-send-email-tj@kernel.org> <1263808570.4283.149.camel@laptop>
In-Reply-To: <1263808570.4283.149.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 11:22:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 06:56 PM, Peter Zijlstra wrote:
>> NOTE: It would be nice to implement kthread_bind() in terms of
>>       __set_cpus_allowed() if we can drop the capability to bind to a
>>       dead CPU from kthread_bind(), which doesn't seem too popular
>>       anyway.  With such change, we'll have set_cpus_allowed_ptr() for
>>       regular tasks and kthread_bind() for kthreads and can use
>>       PF_THREAD_BOUND instead of passing @force parameter around.
> 
> 
> And your changelog still sucks... it only says what it does, not why.
> 
> still hate the patch too.

These part haven't changed at all since the last posting so if you
disliked it before it's kind of expected you still do so.

Anyways, I'm not the greatest fan of this patch either.  Let's see how
the whole series fares out first and try to make this better.  What do
you think about doing what's described in the NOTE?

Thanks.

-- 
tejun
