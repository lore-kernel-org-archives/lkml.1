Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZDTKpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZDTKpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZDTKpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:45:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53485 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbZDTKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:45:44 -0400
Message-ID: <49EC523C.80908@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 19:45:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH -tip 2/3] x86, mce: Revert "add mce=nopoll option
 to disable timer polling"\
References: <49EBCDB0.7000505@jp.fujitsu.com> <49EBCF67.1060400@jp.fujitsu.com> <87r5znpyze.fsf@basil.nowhere.org> <49EC3AB5.5070902@jp.fujitsu.com> <20090420100323.GW14687@one.firstfloor.org>
In-Reply-To: <20090420100323.GW14687@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> 1) There is a agent checking/clearing corrected errors
>>    (such as BIOS) other than OS.
>>
>>    In this case, clearing MSRs by OS is not applicable.
>>    So ignore_ce is better option here.
> 
> Yes, but how do you make sure the option is set when the agent is active?
> I think relying on a kernel boot option here is quite fragile.
> Also it's something the administrator shouldn't be involved in.

Chicken and egg?

If there is a agent, and if the administrator cannot deactivate the agent,
then use this option.  For example, there are no updated BIOS.

>>> Also for your use case really the better way would be to use
>>> some way to let the firmware communicate that it doesn't want the OS
>>> to log.
>> Yes.  However AFAIK there is no way to do it yet.
> 
> We can just define one. We had Linux specific extensions before.
> Just needs a new bit somewhere. I think that would give a better
> experience for your customers.

You are right in part.
But even if I defined one, it doesn't work until it actually used by
someone.  In other words, for example, it will require update of BIOS.

> There might be something forthcomming that could be usable in fact.

Some standard interface will be appreciated.
Having linux specific thing is not happy for hardware vendors, I guess.

>> The original of this repost were posted about three weeks ago (Apr.2)...
>>
>> I think your patches will go smoothly if my revert patches added before
>> them.
> 
> The bug fixes should go in 2.6.30. After all that is what the rc stage
> is for -- applying bug fixed.

Maybe you overlooked that patches here are against -tip tree, don't you?
I'd like to fix -tip tree, that will be merged in next window, 2.6.31-rc1.

>> BTW, could you give me your Acked-by on this 2/3 too?
> 
> Not yet sorry.

You have acked on 3/3... So you mean "keep mce=nopoll option in -tip" ?


Thanks,
H.Seto  


