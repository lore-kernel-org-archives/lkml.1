Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZGYWtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZGYWtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 18:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZGYWtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 18:49:10 -0400
Received: from mail2.shareable.org ([80.68.89.115]:38676 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZGYWtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 18:49:09 -0400
Date: Sat, 25 Jul 2009 23:48:48 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Peter Zijlstra <peterz@infradead.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
Message-ID: <20090725224848.GA15260@shareable.org>
References: <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com> <1248442415.6987.56.camel@twins> <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com> <1248443656.6987.61.camel@twins> <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com> <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org> <1248451279.6987.138.camel@twins> <20090724233057.GO27755@shareable.org> <4A6A96AB.7030609@billgatliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6A96AB.7030609@billgatliff.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Gatliff wrote:
> Jamie Lokier wrote:
> >For simple things like "try to keep the buffer to my DVD writer full"
> >(no I don't know how much CPU that requires - it's a kind of "best
> >effort but try very hard!"), it would be quite useful to have
> >something like RT-bandwidth which grants a certain percentage of time
> >as an RT task, and effectively downgrades it to SCHED_OTHER when that
> >time is exceeded to permit some fairness with the rest of the system.
> >  
> 
> Useful perhaps, but an application design that explicitly communicates 
> your desires to the scheduler will be more robust, even if it does seem 
> more complex at the outset.

I agree with communicting the desire explicitly to the scheduler.

In the above example, the exact desire is "give me as much CPU as I
ask for, because my hardware servicing will be adversely but
non-fatally affected if you don't, and the amount of CPU needed to
service the hardware cannot be determined in advance, but prevent me
from blocking progress in the rest of the system by limiting my
exclusive ownership of the CPU".

How do you propose to communicate that to the scheduler, if not by
something rather like RT-bandwidth with downgrading to SCHED_OTHER
when a policy limit is exceeded?

-- Jamie
