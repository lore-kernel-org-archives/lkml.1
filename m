Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbXGTMd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbXGTMd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbXGTMds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:33:48 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:42814 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbXGTMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:33:47 -0400
Message-ID: <46A0AB44.70009@googlemail.com>
Date: Fri, 20 Jul 2007 14:32:04 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] IP_VS should depend on EXPERIMENTAL ?
References: <46A0A01A.7030403@googlemail.com> <Pine.LNX.4.64.0707200753300.10966@localhost.localdomain> <46A0A7C2.3090006@googlemail.com> <Pine.LNX.4.64.0707200818010.12187@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707200818010.12187@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Fri, 20 Jul 2007, Gabriel C wrote:
> 
>> Robert P. J. Day wrote:
>>> On Fri, 20 Jul 2007, Gabriel C wrote:
>>>
>>>> Hi,
>>>>
>>>> IP_VS has :
>>>>
>>>> ..
>>>>
>>>> tristate "IP virtual server support (EXPERIMENTAL)"
>>>>
>>>> ..
>>>>
>>>> but it does not depend on EXPERIMENTAL.
>>>>
>>>>
>>>> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
>>>>
>>>> ---
>>>>
>>>>  net/ipv4/ipvs/Kconfig |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/net/ipv4/ipvs/Kconfig b/net/ipv4/ipvs/Kconfig
>>>> index 09d0c3f..3c594ec 100644
>>>> --- a/net/ipv4/ipvs/Kconfig
>>>> +++ b/net/ipv4/ipvs/Kconfig
>>>> @@ -3,7 +3,7 @@
>>>>  #
>>>>  menuconfig IP_VS
>>>>  	tristate "IP virtual server support (EXPERIMENTAL)"
>>>> -	depends on NETFILTER
>>>> +	depends on NETFILTER && EXPERIMENTAL
>>>>  	---help---
>>>>  	  IP Virtual Server support will let you build a high-performance
>>>>  	  virtual server based on cluster of two or more real servers. This
>>> there's maturity-level inconsistency like that in a few places, like
>>> when stuff is tagged as EXPERIMENTAL, but labelled as OBSOLETE:
>>>
>> [ a lot examples ]
>>
>> I know that and there are a lot more things depending on
>> 'EXPERIMENTAL' and not having EXPERIMENTAL visible all over the tree
>> but that patch I've made for the _net_ part got NACK'ed while your
>> maturity idea and I rm -rf'ed all the other.
>>
>> This one has a missing depends on EXPERIMENTAL while saying it is.
>>
>> So *could* we please stop this maturity stuff for now ? I don't see
>> it in .23 nor .24 if at all.
> 
> this has *nothing* to do with the aforementioned maturity levels.  i
> understand entirely the inconsistency above.  what i'm suggesting is
> that it might very well be more appropriate to *drop the dependency*
> rather than munge the prompt to add the qualifier.

This is a thing the author/maintainer/subsystem maintainer should and need do.

They know when something is not EXPERIMENTAL anymore.

> 
> i think it's safe to say that there's *piles* of stuff in the Kconfig
> files that is still saddled with an EXPERIMENTAL dependency that's
> been around for years and has stabilized nicely.  

I agree with you , there may be a lot things are marked EXPERIMENTAL but aren't anymore.

>i mean, seriously,
> is IP virtual server support still "experimental" in any way?
> 
> rday


Gabriel
