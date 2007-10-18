Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbXJROkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbXJROkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933964AbXJROkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:40:23 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:1329 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763789AbXJROkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MGT+0e+AeuoQj+zSkNXy3NRH1OBObXxmYlYkY234591kGzdt+OVrajfU4YYh2l3ytvlYnmpNRGdQ6P44BoEcn7oh4edFx63Umi/gECCY8q2Jb+3M1aqLgNInJCDVSysJ1cKmclxLybU7qotWjRBmg3x9yVVUGsg/87KdUQUIJgE=
Message-ID: <47177079.2090201@gmail.com>
Date: Thu, 18 Oct 2007 22:40:57 +0800
From: Yi Yang <yang.y.yi@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: akpm@osdl.org, crutcher+kernel@datastacks.com,
       linux-kernel@vger.kernel.org, mj@atrey.karlin.mff.cuni.cz, pavel@ucw.cz,
       schwab@suse.de
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef
 key,  try 2
References: <471628D2.8010903@gmail.com> <E1IiBTu-0007cr-3i@faramir.fjphome.nl>
In-Reply-To: <E1IiBTu-0007cr-3i@faramir.fjphome.nl>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop Ð´µÀ:
> Yi Yang wrote:
>   
>> Hot Key    Function Description
>> =======    ====================
>>    0       Changing Loglevel to this value
>>    1       Changing Loglevel to this value
>>    2       Changing Loglevel to this value
>>    3       Changing Loglevel to this value
>>    4       Changing Loglevel to this value
>>    5       Changing Loglevel to this value
>>    6       Changing Loglevel to this value
>>    7       Changing Loglevel to this value
>>    8       Changing Loglevel to this value
>>    9       Changing Loglevel to this value
>>     
>
> Wouldn't "Change Loglevel to this value" be more consistent with other
> descriptions?
> Or maybe even "Change Kernel Loglevel to <value>"; the repeated "this
> value" seems somewhat silly.
>   
I think so, too, only one line should be enough.
>   
>>    b       Resetting
>>     
>
> This is not very descriptive. Maybe "Immediate System Reboot"?
>   
>   
>>    c       Trigger a crashdump
>>     
>
> Most descriptions are capitalized. So for consistency this should be
> "Trigger a Crashdump". (Although my personal preference would be to drop
> the capitalization for all descriptions.)
>   
>   
>>    p       Show Regs
>>     
>
> Should "Regs" be expanded to "Registers"?
>
>   
>>   r       Keyboard mode set to XLATE
>>     
>
> For consistency: "Set Keyboard Mode to XLATE"
>
> Cheers,
> Frans Pop
>
>   
These descriptions are from the callers who are from many subsystems, so
I can't change it.
