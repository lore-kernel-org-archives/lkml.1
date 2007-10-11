Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbXJKMyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbXJKMyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXJKMyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:54:39 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:47492 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXJKMyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:54:37 -0400
Message-ID: <470E1CEC.6000402@linuxtv.org>
Date: Thu, 11 Oct 2007 14:54:04 +0200
From: Marcel Siegert <mws@linuxtv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Aurelien Jarno <aurelien@aurel32.net>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
References: <1192053794.15601.47.camel@gaivota>	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>	 <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>	 <d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>	 <470DBDC7.8000304@aurel32.net>	 <d9def9db0710102331h68e1d9b0rf3095bd9e261ec21@mail.gmail.com>	 <470DEDDF.6040001@linuxtv.org> <d9def9db0710110320t476483d4pcfd7e2d446517164@mail.gmail.com>
In-Reply-To: <d9def9db0710110320t476483d4pcfd7e2d446517164@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger schrieb:
> On 10/11/07, Marcel Siegert <mws@linuxtv.org> wrote:
>> Markus Rechberger schrieb:
>>> On 10/11/07, Aurelien Jarno <aurelien@aurel32.net> wrote:
>>>> Markus Rechberger a écrit :
>>>>> On 10/11/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>>>> As such, the old and decrepit em28xx driver seems more useful to
>> people,
>>>>>> since at least it supports the limited set of hardware on its own.
>>>>> it does not since it's broken and feature limited. On the other side
>>>> I have a device which works perfectly with it if you add the vendor and
>>>> product ID to the list. I don't really call that broken. And it doesn't
>>>> need a firmware.
>>>>
>>> Aurelien,
>>>
>>> the device you're using is around 2 years old. You're one of the lucky
>>> ones, I have tonns of support mails in my mail account from people who
>>> own almost a similar device but with different videodecoders which are
>>> not fully supported in the kernel or which worked and got broken
>>> during the time.
>>> It took me around 4 hours to debug such an issue last years remotly
>>> with an enduser (which includes that noone cared to ask me if I'm fine
>>> with such an update, neither did someone ask people who own such
>>> devices that they should test the changes).
>>> Please also take other devices and upcoming devices into account,
>>> since i'm willing to spend that time and since I'm in contact with
>>> various companies who provide several components of those devices.
>>>
>>>> Please think that a lot of persons do not have enough knowledge to
>>>> compile out of tree drivers, and that a lot more do not even know about
>>>> this out of tree driver.
>>>>
>>> this is what all is about, the project does not depend on certain
>>> broken drivers anymore. And people who initially disagreed without
>>> having any solution nor contributed any code can continue to play
>>> their game without having an impact on that driver anymore.
>>>
>>> Markus
>> markus,
>>
>> its the same old story you are telling over and over again.
>>
>> of course there might be a huge community builded up the
>> last month @ mcentral,
>> of course your driver supports newer devices,
>>
>> BUT
>>
>> the same old story is - and you always miss that part
>>
>> we discussed a lot on your changes and also ACCEPTED those
>> for merging, if you would have changed your UNNECCESSARY touching
>> of dvb-core. its proven that things could work without that
>> nacked change to dvb core. but, you decided to stop discussion then,
>> and went away to perform your own tree/userspace thing.
>>
>> as linus and andrew stated within this thread they think they will not
>> merge your code like it is cause of different reasons,
>> i am wondering a bit whats your next step is.
>>
> 
> I didn't read a clean statement about it. If so I won't continue to
> pull out opensource drivers from that company.
> Marcel, you haven't been and you are not into that topic otherwise
> you'd write about missing parts and address codeparts which I have
> mentioned in the past which are not ok in the kernel and how to solve
> that best.

saving my time instead of commenting your code does not mean i am not 
into it. as far as i remember i did say, that the api mixup within
dvb-core is NOT wanted and there are solutions for other devices,
that show it can be done otherwise. i must admit it would be a different
way but the only answer you said was "No, i wont do that"

please go back through the irc logs on linuxtv.org and find the 
appropiate place.

> I remember the mail [1] where you (and Michael) tried to point me to
> something that doesn't work out. Please get into the whole topic which
> includes studying the requirements and what parts I'm complaining
> about.
as you may remember, i also offered you to ack a MERGE AS IS base for
your code in a private conversation on irc.

the main topics in there have been:
merge your stuff
wait for multiproto applied (as i still think it is a better solution)
rework your stuff to work with multiproto

your answer was afair "i will not allow anyone to modify my code after a 
merge"

that showed me, others did recognise meanwhile too, that you are NOT 
able to discuss different things or opinions for real, but you take
your proposals as the "one and only". this can not work, and will not
work.

i will leave this discussion again, as discussing with you mostly just 
leads into the old story of how stupid linuxtv devs are...

YOU LEFT linuxtv to build up your own - proceed further with that 
strategy _or_ come back to a level where you are open for different 
suggestions than yours.

HTH
marcel



> Markus
> 
> (just for the record, although it's not relevant anymore)
> http://threebit.net/mail-archive/video4linux/msg07548.html

