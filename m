Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbXLCJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbXLCJCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXLCJCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:02:18 -0500
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:57399 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbXLCJCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:02:17 -0500
X-Greylist: delayed 1764 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 04:02:17 EST
Message-ID: <4753BF5A.5030507@sw.ru>
Date: Mon, 03 Dec 2007 11:33:30 +0300
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Adrian Bunk <bunk@kernel.org>, Ben Greear <greearb@candelatech.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, containers@lists.osdl.org
Subject: Re: namespace support requires network modules to say "GPL"
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com> <47515D39.9030900@rtr.ca> <20071201111736.297dd99a@freepuppy.rosehill> <20071201163035.321fd554@freepuppy.rosehill> <475227B1.2060802@rtr.ca> <20071201202354.672aed18@freepuppy.rosehill> <47530778.7030605@candelatech.com> <47530FAC.1070804@trash.net> <20071202204356.GN15974@stusta.de> <47532AD2.8090704@trash.net>
In-Reply-To: <47532AD2.8090704@trash.net>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Adrian Bunk wrote:
>> On Sun, Dec 02, 2007 at 09:03:56PM +0100, Patrick McHardy wrote:
>>
>>> For all I care binary modules can break, but frankly I don't see
>>> how encapsulating a couple of structures and pointers in a new
>>> structure and adding a new argument to existing functions shifts
>>> the decision about how a function should be usable to the namespace
>>> guys. IMO all functions should continue to be usable as before,
>>> as decided by whoever actually wrote them.
>>> ...
>>
>> Even ignoring the fact that it's unclear whether distributing modules
>> with not GPLv2 compatible licences is legal at all or might bring you
>> in jail,
> 
> Agreed, lets ignore that :)
> 
>> your statement has an interesting implication:
>>
>> Stuff like e.g. the EXPORT_SYMBOL(sk_alloc) predates the
>> EXPORT_SYMBOL_GPL stuff.
>>
>> Who is considered the author of this code?
>>
>> And when should he state whether he prefers to use EXPORT_SYMBOL_GPL
>> but wasn't able to use it at that when he wrote it since his code
>> predates it and is glad to be able to decide this now?
> 
> 
> He can state it when he feels like it, I don't see the point.
> Authors generally get to decide whether they use EXPORT_SYMBOL
> or EXPORT_SYMBOL_GPL unless in cases where its really clear-cut
> that EXPORT_SYMBOL is inapproriate. But thats a different matter.
> 
> If a symbol was OK to be used previously and something using it
> would not automatically be considered a derived work, how does
> passing &init_net to the function just to make the compiler
> happy, avoid BUG_ONs and generally keep things working as before
> make it more of a derived work?

We, namely, Pavel Emelyanov and me, if we have some rights as a
committers to this staff :), do not mind against change
EXPORT_SYMBOL_GPL to EXPORT_SYMBOL.

Regards,
	Den
