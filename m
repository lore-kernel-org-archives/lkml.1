Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbXJTCCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbXJTCCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbXJTCCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:02:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39751 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbXJTCCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:02:34 -0400
Message-ID: <47196165.8070406@oracle.com>
Date: Fri, 19 Oct 2007 19:01:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-git Kconfig regression
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071019184607.06e1eef9.randy.dunlap@oracle.com> <20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>>> 	(Originally posted to kbuild-devel per MAINTAINERS, but
>>> 	that post was rejected since that is -- undocumented,
>>> 	sigh -- a members-only list.)
>> That mailing list is no longer used.  Today's git pull for kbuild
>> included this change:
>>
>>  KCONFIG
>>  P:	Roman Zippel
>>  M:	zippel@linux-m68k.org
>> -L:	kbuild-devel@lists.sourceforge.net
>> +L:	linux-kbuild@vger.kernel.org
>>  S:	Maintained
> 
> I hadn't pulled that one yet... ;)
> 
> 
>>> I noticed a regression, visible in the drivers/usb/gadget Kconfig;
>>> it seems to be quite recent.
>>>
>>> ...
>> Hm, it does look very odd.  It looks like it has something to
>> do with <choice> working differently for some reason.
>>
>> In xconfig, I set all of the View Options and when I click on one
>> of the periph. controllers, it says
>>
>> 	depends on =y && PCI
> 
> That's what I saw too.  Looked dubious ... 
> 
> 
>> but if I back up to -git7, it says
>>
>> 	depends on <choice> && PCI
> 
> And that git7 thing doesn't look _quite_ so odd.  Did git7 actually
> let you configure a modular GOKU (for example), i.e. work correctly?

Yes, -git9 does.

Looks to me like it broke on -git10.  -git9 is OK.

>> I'll keep looking.
> 
> Thanks.  Kconfig is one of the areas I prefer to let others
> be the experts.  :)


-- 
~Randy
