Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZEWMeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZEWMeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 08:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZEWMd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 08:33:57 -0400
Received: from mail-px0-f103.google.com ([209.85.216.103]:34507 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZEWMd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 08:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=frQill8HdmsfaMvT0UrZIrPWiKkIQgyOuvyGIDBBH2pvlECkWNpRgdM3z7ZSzJLG2E
         wDi1rTvAJrmmcm2duYw3svmBcj6Fw9RCyIcyQBYw7HqBm2VH5B8shR+NZCYPxuGIlHPh
         TcBB1oUg+Z8cZf0ebDXie/IeiLuJVh+/8zPmY=
MIME-Version: 1.0
In-Reply-To: <4A177ECE.7080508@candelatech.com>
References: <4A1743C5.9020803@candelatech.com>
	 <d82e647a0905221803w487fcdb3k2319bdaa7d9cc559@mail.gmail.com>
	 <4A177ECE.7080508@candelatech.com>
Date: Sat, 23 May 2009 20:33:57 +0800
Message-ID: <d82e647a0905230533qecd51fds7e8b980a1f39ef5a@mail.gmail.com>
Subject: Re: Question on lockdep and sysrq - d
From: Ming Lei <tom.leiming@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/23 Ben Greear <greearb@candelatech.com>:
> Ming Lei wrote:
>>
>> See http://marc.info/?l=linux-kernel&m=124211522525625&w=2.
>>
>
> That is about some real bug in the official kernel.  I am almost 100%
> certain that my own code is at fault here.
>
> I'm just trying to better understand the way lockdep prints out
> all of the locks so I can easier debug my issue.

Would you mind posting the whole lockdep warnings in your issue?

Thanks.

>
> Thanks,
> Ben
>
>> thanks.
>>
>> 2009/5/23 Ben Greear <greearb@candelatech.com>:
>>
>>>
>>> Hello!
>>>
>>> I'm trying to debug an apparent deadlock in some code I'm
>>> writing.
>>>
>>> When I do a sysrq 'd', I get a nice dump of locks (I have lockdep
>>> enabled).
>>>
>>> However, the output appears to show multiple processes holding the
>>> same locks (rtnl_mutex, for example):
>>>
>>> Showing all locks held in the system:
>>> 3 locks held by events/11/63:
>>>  #0:  (events){--..}, at: [<ffffffff8104f71e>] run_workqueue+0xb1/0x216
>>>  #1:  ((linkwatch_work).work){--..}, at: [<ffffffff8104f71e>]
>>> run_workqueue+0xb1/0x216
>>>  #2:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
>>> 1 lock held by irqbalance/3360:
>>>  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
>>> 1 lock held by hald/3605:
>>>  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
>>> ...
>>>
>>> Is this merely showing processes that are blocked on trying to acquire
>>> these
>>> locks?
>>>
>>> If so, is there any way to tell which processes have fully acquired locks
>>> v/s
>>> just waiting to acquire them?
>>>
>>> Thanks,
>>> Ben
>>>
>
> --
> Ben Greear <greearb@candelatech.com> Candela Technologies Inc
>  http://www.candelatech.com
>
>
>



-- 
Lei Ming
