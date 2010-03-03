Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0CCV4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:56:52 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:25642 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0CCV4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:56:46 -0500
MIME-Version: 1.0
In-Reply-To: <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	 <20100303184132.GA11471@core.coreip.homeip.net>
	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	 <20100303190753.GB11471@core.coreip.homeip.net>
	 <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com>
Date: Wed, 3 Mar 2010 13:56:45 -0800
Message-ID: <8bb80c381003031356s4b9fa6abj15e7ca207552ac6d@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Mike Chan <mike@android.com>
To: Dima Zavin <dmitriyz@google.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 1:38 PM, Dima Zavin <dmitriyz@google.com> wrote:
>>> Sure, you migth use it to turn up the lights too. But how is that
>>> different from having a switch to do the same? Again, it doesn't sound
>>> that different from a key to me.
>>
>> I guess for me the distinction is that the event was not caused by an
>> action of a human being but by change in environment.
>>
>> Also, if we decide that input layer is the best place for such devices,
>> it should not be a key but absolute event, ABS_LIGHT_LEVEL or something.
>
> Agreed, a key is not the best approach. We currently have been hacking
> around it by using ABS_MISC, which I know is wrong.
>
>>> The thing is, if the choice is about a whole new subsystem just for some
>>> silly light sensor logic, I'd _much_ rather see the much simpler - and
>>> more useful - approach of just considering it an input event.
>>>
>>> It happens in the same kind of situations, it has the same kinds of timing
>>> issues (ie we're not talking streaming megabytes of data), and it has the
>>> same kind of users (ie a lightsensor really would be used along with
>>> something that cares about input).
>>>
>>> I agree that that's not true in many other situations. A cable insertion
>>> event is about the networking, not about some independent input. The kind
>>> of application that cares about network cable presense is _not_ the kind
>>> of app that would care about keyboard input. Same goes for voltage.
>>
>> What about magnetometers, accelerometers and so forth? I still do not
>> think they are pure input layer devices although it is possible to build
>> a bridge modules so they could plug into input framework if desired.
>
> Actually, accelerometers fit into that model fine. They have some
> variable number of absolute axes (3, 6, etc.).
>

Slightly off topic here, but with the introduction of an als
subsystem, wouldn't you want to unify how the kernel export lux
values? Currently it seems the driver can export whatever they want to
export, lux or lumen, whatever they want.

-- Mike

> --Dima
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
