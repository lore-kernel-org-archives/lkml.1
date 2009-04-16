Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZDPXV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZDPXV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZDPXVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:21:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51565 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZDPXVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:21:17 -0400
Message-ID: <49E7BD64.7060507@garzik.org>
Date: Thu, 16 Apr 2009 19:21:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Oruba <peter.oruba@amd.com>, amd64-microcode@amd64.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: microcode driver newly spews warnings
References: <49E38331.3090808@garzik.org> <49E38393.8000700@garzik.org> <20090413182746.GA9954@elte.hu> <49E5EABB.9010402@garzik.org> <b647ffbd0904150751u64e69097q79c511533f949c00@mail.gmail.com> <20090416230731.GA19553@elte.hu>
In-Reply-To: <20090416230731.GA19553@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> 
>> 2009/4/15 Jeff Garzik <jeff@garzik.org>:
>>> Ingo Molnar wrote:
>>>> (added Cc:s)
>>>>
>>>> * Jeff Garzik <jeff@garzik.org> wrote:
>>>>
>>>>> Jeff Garzik wrote:
>>>>>> Kernel: 2.6.30-rc1-00306-g8371f87
>>>>>> Hardware: ICH10 x86-64
>>>>>>
>>>>>> This is a regression from 2.6.29.  Microcode spews the following WARNING
>>>>>> multiple times during boot:
>>>>>>
>>>>>>> ------------[ cut here ]------------
>>>>>>> WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xeb/0xf0()
>>>>>>> Hardware name:         sysfs group ffffffffa0209700 not found for
>>>>>>>  kobject 'cpu0'
>>>
>>> Update:  Regression occurs in 2.6.30-rc2.
>>>
>>> I've now reproduced this on ICH9/Core2 as well as ICH10/Nahelem.
>> Hi,
>>
>>
>> the following patch should eliminate the problem (and revert to 
>> the old behavior that was altered by Rusty's patch).
> 
> Jeff, did this do the trick for you?

Yes -- but I worry about keeping sysfs files around too long?

	Jeff



