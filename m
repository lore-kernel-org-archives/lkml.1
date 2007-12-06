Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXLFXah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXLFXah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXLFXaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:30:30 -0500
Received: from simmts12-srv.bellnexxia.net ([206.47.199.141]:53425 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbXLFXa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:30:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAD4VWEecIvVD/2dsb2JhbAAI
Message-ID: <47588610.5010804@gmail.com>
Date: Thu, 06 Dec 2007 19:30:24 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
References: <20071206021857.826386004@mvista.com>  <20071206021909.131993721@mvista.com>  <20071206102334.GE17299@elte.hu> <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
In-Reply-To: <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Thu, 2007-12-06 at 11:23 +0100, Ingo Molnar wrote:
>> * Daniel Walker <dwalker@mvista.com> wrote:
>>
>>> The port_mutex is actually a semaphore, so easily converted to a 
>>> struct mutex.
>>>
>>> Signed-off-by: Daniel Walker <dwalker@mvista.com>
>> Acked-by: Ingo Molnar <mingo@elte.hu>
>>
>> cool. How far away are we from being able to remove all the semaphore 
>> code? :-)
> 
> I wish my 7 patches made a dent, but it's hasn't done much. ;(
> 
> I would guess at least a week just to mop up the relatively easy ones..
> I've got 12 in my queue, and there still ~50 hopefully trivial ones
> still to be looked at.. Then another ~30 more difficult ones (that use
> init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..
> 

I didn't realise there were so many of these patch sets still to go.  I
could probably help out with some of them.  Is there somewhere we could
keep track of which ones are left to do, and who is handling them?  If
it would be helpful, I could go through all of the semaphore uses in the
tree and try to figure out which (if any) are true counting semaphores
that cannot be converted, and then I could post/send the list of
convertible cases.  Would that be helpful, or has it already been done
somewhere else?

-- 
Kevin Winchester
