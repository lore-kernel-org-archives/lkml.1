Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbXJKJdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbXJKJdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXJKJdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:33:46 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:59049 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXJKJdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:33:45 -0400
Message-ID: <470DEDDF.6040001@linuxtv.org>
Date: Thu, 11 Oct 2007 11:33:19 +0200
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
References: <1192053794.15601.47.camel@gaivota>	<d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>	<alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>	<d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>	<470DBDC7.8000304@aurel32.net> <d9def9db0710102331h68e1d9b0rf3095bd9e261ec21@mail.gmail.com>
In-Reply-To: <d9def9db0710102331h68e1d9b0rf3095bd9e261ec21@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger schrieb:
> On 10/11/07, Aurelien Jarno <aurelien@aurel32.net> wrote:
>> Markus Rechberger a écrit :
>>> On 10/11/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>> As such, the old and decrepit em28xx driver seems more useful to people,
>>>> since at least it supports the limited set of hardware on its own.
>>> it does not since it's broken and feature limited. On the other side
>> I have a device which works perfectly with it if you add the vendor and
>> product ID to the list. I don't really call that broken. And it doesn't
>> need a firmware.
>>
> 
> Aurelien,
> 
> the device you're using is around 2 years old. You're one of the lucky
> ones, I have tonns of support mails in my mail account from people who
> own almost a similar device but with different videodecoders which are
> not fully supported in the kernel or which worked and got broken
> during the time.
> It took me around 4 hours to debug such an issue last years remotly
> with an enduser (which includes that noone cared to ask me if I'm fine
> with such an update, neither did someone ask people who own such
> devices that they should test the changes).
> Please also take other devices and upcoming devices into account,
> since i'm willing to spend that time and since I'm in contact with
> various companies who provide several components of those devices.
> 
>> Please think that a lot of persons do not have enough knowledge to
>> compile out of tree drivers, and that a lot more do not even know about
>> this out of tree driver.
>>
> 
> this is what all is about, the project does not depend on certain
> broken drivers anymore. And people who initially disagreed without
> having any solution nor contributed any code can continue to play
> their game without having an impact on that driver anymore.
> 
> Markus

markus,

its the same old story you are telling over and over again.

of course there might be a huge community builded up the
last month @ mcentral,
of course your driver supports newer devices,

BUT

the same old story is - and you always miss that part

we discussed a lot on your changes and also ACCEPTED those
for merging, if you would have changed your UNNECCESSARY touching
of dvb-core. its proven that things could work without that
nacked change to dvb core. but, you decided to stop discussion then,
and went away to perform your own tree/userspace thing.

as linus and andrew stated within this thread they think they will not 
merge your code like it is cause of different reasons,
i am wondering a bit whats your next step is.

regards
marcel

ps. as linus tells from time to time
"It's not just black and white - there's also grey"

