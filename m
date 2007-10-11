Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbXJKNBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbXJKNBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbXJKNBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:01:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:62781 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJKNBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ahxLL4h++C8onqAhsu9RhfwirYEMEfUD+kWqWeJhhGFc3UAhHHinyTJ0QPOFwaBry6yj6c4Ugho6xRmvsdkb/RRN81wd6G7P2QAId91kLHl6iUV3MjjOX2wCB/nclnQrhP4ZS1aeZWRLriuCBeWuN5ZTU4wf1/ITz0DazabQvTI=
Message-ID: <d9def9db0710110601m198f2ad8naafc8a33253ea14f@mail.gmail.com>
Date: Thu, 11 Oct 2007 15:01:05 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Marcel Siegert" <mws@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: "Aurelien Jarno" <aurelien@aurel32.net>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <470E1CEC.6000402@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>
	 <d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>
	 <470DBDC7.8000304@aurel32.net>
	 <d9def9db0710102331h68e1d9b0rf3095bd9e261ec21@mail.gmail.com>
	 <470DEDDF.6040001@linuxtv.org>
	 <d9def9db0710110320t476483d4pcfd7e2d446517164@mail.gmail.com>
	 <470E1CEC.6000402@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Marcel Siegert <mws@linuxtv.org> wrote:
> Markus Rechberger schrieb:
> > On 10/11/07, Marcel Siegert <mws@linuxtv.org> wrote:
> >> Markus Rechberger schrieb:
> >>> On 10/11/07, Aurelien Jarno <aurelien@aurel32.net> wrote:
> >>>> Markus Rechberger a écrit :
> >>>>> On 10/11/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>>>>> As such, the old and decrepit em28xx driver seems more useful to
> >> people,
> >>>>>> since at least it supports the limited set of hardware on its own.
> >>>>> it does not since it's broken and feature limited. On the other side
> >>>> I have a device which works perfectly with it if you add the vendor and
> >>>> product ID to the list. I don't really call that broken. And it doesn't
> >>>> need a firmware.
> >>>>
> >>> Aurelien,
> >>>
> >>> the device you're using is around 2 years old. You're one of the lucky
> >>> ones, I have tonns of support mails in my mail account from people who
> >>> own almost a similar device but with different videodecoders which are
> >>> not fully supported in the kernel or which worked and got broken
> >>> during the time.
> >>> It took me around 4 hours to debug such an issue last years remotly
> >>> with an enduser (which includes that noone cared to ask me if I'm fine
> >>> with such an update, neither did someone ask people who own such
> >>> devices that they should test the changes).
> >>> Please also take other devices and upcoming devices into account,
> >>> since i'm willing to spend that time and since I'm in contact with
> >>> various companies who provide several components of those devices.
> >>>
> >>>> Please think that a lot of persons do not have enough knowledge to
> >>>> compile out of tree drivers, and that a lot more do not even know about
> >>>> this out of tree driver.
> >>>>
> >>> this is what all is about, the project does not depend on certain
> >>> broken drivers anymore. And people who initially disagreed without
> >>> having any solution nor contributed any code can continue to play
> >>> their game without having an impact on that driver anymore.
> >>>
> >>> Markus
> >> markus,
> >>
> >> its the same old story you are telling over and over again.
> >>
> >> of course there might be a huge community builded up the
> >> last month @ mcentral,
> >> of course your driver supports newer devices,
> >>
> >> BUT
> >>
> >> the same old story is - and you always miss that part
> >>
> >> we discussed a lot on your changes and also ACCEPTED those
> >> for merging, if you would have changed your UNNECCESSARY touching
> >> of dvb-core. its proven that things could work without that
> >> nacked change to dvb core. but, you decided to stop discussion then,
> >> and went away to perform your own tree/userspace thing.
> >>
> >> as linus and andrew stated within this thread they think they will not
> >> merge your code like it is cause of different reasons,
> >> i am wondering a bit whats your next step is.
> >>
> >
> > I didn't read a clean statement about it. If so I won't continue to
> > pull out opensource drivers from that company.
> > Marcel, you haven't been and you are not into that topic otherwise
> > you'd write about missing parts and address codeparts which I have
> > mentioned in the past which are not ok in the kernel and how to solve
> > that best.
>
> saving my time instead of commenting your code does not mean i am not
> into it. as far as i remember i did say, that the api mixup within
> dvb-core is NOT wanted and there are solutions for other devices,
> that show it can be done otherwise. i must admit it would be a different
> way but the only answer you said was "No, i wont do that"
>
> please go back through the irc logs on linuxtv.org and find the
> appropiate place.
>
> > I remember the mail [1] where you (and Michael) tried to point me to
> > something that doesn't work out. Please get into the whole topic which
> > includes studying the requirements and what parts I'm complaining
> > about.
> as you may remember, i also offered you to ack a MERGE AS IS base for
> your code in a private conversation on irc.
>

I didn't see that.

> the main topics in there have been:
> merge your stuff
> wait for multiproto applied (as i still think it is a better solution)
> rework your stuff to work with multiproto
>
> your answer was afair "i will not allow anyone to modify my code after a
> merge"
>

I would like to see where I wrote that.
I remember that I stated out merge it as it is and modify it
afterwards because then you have to take care about the requirements
which are implemented and which some are not aware of. (There are also
heavy discussions about that ... think we shouldn't rediscuss it and
if someone wants to rediscuss it please put together a wikisite about
the discussions since it makes no sense to get over it again).

> that showed me, others did recognise meanwhile too, that you are NOT
> able to discuss different things or opinions for real, but you take
> your proposals as the "one and only". this can not work, and will not
> work.
>

I am although I won't drop parts of my code in favour of someone who
has different ideas which are not even more complete or don't add some
extra value to it.

Markus
