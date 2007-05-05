Return-Path: <linux-kernel-owner+w=401wt.eu-S1031752AbXEEPcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031752AbXEEPcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031761AbXEEPcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:32:03 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:51596 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031752AbXEEPcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=QvUo/GiyNOLhoONjKc9RLj4AdsJwljRRaluKzY8PIu8iZmjVHxBC8Npn99aNqR3lb4S5VMLkg/dALO/PjvMewXeIgWwP5AoqLlmwvbWxi7fCkY9xM9gp0feeFdYB5qW4Go+jYzYl4S7pzSYAntCZ7bQXzmwQanSOtfjDpQ9OcIM=
Date: Sat, 5 May 2007 17:29:56 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <67630751.20070505172956@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
       David Woodhouse <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
       Shem Multinymous <multinymous@gmail.com>,
       <kernel-discuss@handhelds.org>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class (was: battery class)
In-Reply-To: <20070505123230.GA6460@zarina>
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <20070505123230.GA6460@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Anton,

Saturday, May 5, 2007, 3:32:30 PM, you wrote:

> Hello Henrique, Shem,

> On Sat, May 05, 2007 at 12:54:13AM -0300, Henrique de Moraes Holschuh wrote:
>> On Fri, 04 May 2007, Shem Multinymous wrote:
>> > >+enum power_supply_type {
>> > >+       POWER_SUPPLY_TYPE_BATTERY = 0,
>> > >+       POWER_SUPPLY_TYPE_UPS,
>> > >+       POWER_SUPPLY_TYPE_AC,
>> > >+       POWER_SUPPLY_TYPE_USB,
>> > >+};
>> > 
>> > How about dumb (non-USB) DC power? Any reason to distinguish it from AC?
>> 

[]

> I think I got the start point of confusion. It's indeed bad to call such
> power supply type as AC.

        Ok, let's try to at least find the root of this confusion. Of
course, course, what we mean by "AC" is exactly continuous, "infinite"
power source. Of course, from real physicist point of view, this is
incorrect - hardly any device in topic domain (i.e.
portable/battery-power) has AC cord sticking out of case. There's usually
an AC/DC adapter, and DC is what really fed into device.

        But in real world, it's rather common to colloquially name
such kind of power "AC", and that's "term" is known to many-many
people, and intuitively understood even for those, who didn't hit it yet.
Actually, this discussion is good confirmation that's the case -
people understand in what meaning it is used here, and go to point
that it's not "scientifically" correct.

> Maybe I should it rename to ADAPTER? Or WALL?

        Well-well, above was pointed out, that "AC" even if not fully
correct, that at least colloquial term of choice for the phenomena inq
question. Words above on the other hand seems like out-of-scope and
ambiguous. There's actually a nice and terse term for that - mains,
but I wonder how well non-English speaking people are familiar with it
(I personally saw them only in manuals, which, as well known, nobody
reads).


        Summing up, it may be worth a quick thought, should it be
"absolutely correct and absolutely useless", or just well-understood
up to the level that even elementary school pupil could write an
eloquence essay criticizing it ;-).


[]


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

