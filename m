Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXLCWSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXLCWSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbXLCWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:18:26 -0500
Received: from rtr.ca ([76.10.145.34]:4370 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXLCWSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:18:25 -0500
Message-ID: <475480AF.2010307@rtr.ca>
Date: Mon, 03 Dec 2007 17:18:23 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Friesen <cfriesen@nortel.com>, davids@webmaster.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
References: <MDEHLPKNGKAHNMBLJOLKEEHJIJAC.davids@webmaster.com> <47545F88.6070609@nortel.com> <4754777F.7020302@rtr.ca> <20071203214803.GA8989@elte.hu> <47547BB6.3040402@rtr.ca> <20071203220559.GA11906@elte.hu>
In-Reply-To: <20071203220559.GA11906@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mark Lord <lkml@rtr.ca> wrote:
> 
>> Ack.  And what of the suggestion to try to ensure that a yielding task 
>> simply not end up as the very next one chosen to run?  Maybe by 
>> swapping it with another (adjacent?) task in the tree if it comes out 
>> on top again?
> 
> we did that too for quite some time in CFS - it was found to be "not 
> agressive enough" by some folks and "too agressive" by others. Then when 
> people started bickering over this we added these two simple corner 
> cases - switchable via a flag. (minimum agression and maximum agression)
> 
>> (I really don't know the proper terminology to use here, but hopefully 
>> Ingo can translate that).
> 
> the terminology you used is perfectly fine.
> 
>> Thanks Ingo -- I *really* like this scheduler!
> 
> heh, thanks :) For which workload does it make the biggest difference 
> for you? (and compared to what other scheduler you used before? 2.6.22?)
..

Heh.. I'm just a very unsophisticated desktop user, and I like it when
Thunderbird and Firefox are unaffected by the "make -j3" kernel builds
that are often running in another window.  BIG difference there.

And on the cool side, the Swarm game (swarm.swf) is a great example of
something that used to get jerky really fast whenever anything else was
running, and now it really doesn't seem to be affected by anything.
(I don't really play computer games, but this one is has a very retro feel..).

Cheers
