Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYHADpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYHADpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYHADo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:44:58 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:44023 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYHADo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:44:58 -0400
Message-ID: <489286B6.20502@billgatliff.com>
Date: Thu, 31 Jul 2008 22:44:54 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, vatsa@linux.vnet.ibm.com,
       efault@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270
 (at least)?
References: <20080729223105.GK10982@flint.arm.linux.org.uk> <20080729154605.d540cf6d.akpm@linux-foundation.org> <20080731213741.GJ2729@elte.hu> <1217540875.8157.105.camel@twins> <20080731215703.GA5392@flint.arm.linux.org.uk>
In-Reply-To: <20080731215703.GA5392@flint.arm.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Thu, Jul 31, 2008 at 11:47:55PM +0200, Peter Zijlstra wrote:
>> On Thu, 2008-07-31 at 23:37 +0200, Ingo Molnar wrote:
>>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>> On Tue, 29 Jul 2008 23:31:05 +0100
>>>> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>>>>
>>>>> But then some bright spark thought it would be a good idea to get
>>>>> rid of printk_clock().
>>>> <does git-log, searches for printk_clock>
>>> i think this is a fresh regression via the introduction of 
>>> kernel/sched_clock.c. We lost the (known) early-init behavior of 
>>> cpu_clock() in the !UNSTABLE_SCHED_CLOCK case. The fix would be to 
>>> restore that, not to reintroduce printk_clock().
>>>
>>> Peter, any ideas?
>> How about something like this, it builds an atificial delay, exactly
>> like we already have for the HAVE_UNSTABLE_SCHED_CLOCK case.
>>
>> This keeps cpu_clock() 0 until after sched_clock_init().
>>
>> Russell, Bill, is this sufficient?
> 
> It looks like it should.  Bill - can you test the patch in Peter's mail
> please?

I've got one foot out the door headed towards a business trip.  I can check it
out Monday or Tuesday.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
