Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYDCSUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYDCSUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbYDCSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:20:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49546 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953AbYDCSUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:20:17 -0400
Message-ID: <47F51FD3.604@garzik.org>
Date: Thu, 03 Apr 2008 14:20:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Chris Snook <csnook@redhat.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GFP_ATOMIC page allocation failures.
References: <20080401235609.GA6947@codemonkey.org.uk> <20080402103355.77ef22ff.akpm@linux-foundation.org> <47F3CE10.1060903@garzik.org> <200804031657.43895.nickpiggin@yahoo.com.au>
In-Reply-To: <200804031657.43895.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thursday 03 April 2008 05:18, Jeff Garzik wrote:
> 
>> Turning to Nick's comment,
>>
>>> It's still actually nice to know how often it is happening even for
>>> these known good sites because too much can indicate a problem and
>>> that you could actually bring performance up by tuning some things.
>> then create a counter or acculuation buffer somewhere.
>>
>> We don't need spew every time there is memory pressure of this magnitude.
> 
> Not a complete solution. Counter would be nice, but you need backtraces
> and want a way to more proactively warn the user/tester/developer.
> 
> I agree that I don't exactly like adding nowarns around, and I don't think
> places like driver writers should have to know about this stuff.
> 
> 
>> IMO there are much better ways than printk(), to inform tasks, and
>> humans, of allocation failures.
> 
> I think with a tweaked warning message, a ratelimited printk is OK.

No objections here, and agreed on all points.

Though IMO adding __GFP_NOWARN to netdev_alloc_skb() falls into that 
category (should not generally be in a driver or driver API).

	Jeff




