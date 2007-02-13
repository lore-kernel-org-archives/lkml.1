Return-Path: <linux-kernel-owner+w=401wt.eu-S1750900AbXBMT7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbXBMT7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXBMT7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:59:51 -0500
Received: from javad.com ([216.122.176.236]:2851 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXBMT7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:59:50 -0500
From: Sergei Organov <osv@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J.A. =?utf-8?B?TWFnYWxsw4PDg8ODw4LCs24=?=" <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com>
	<Pine.LNX.4.64.0702131121590.3604@woody.linux-foundation.org>
Date: Tue, 13 Feb 2007 22:59:29 +0300
In-Reply-To: <Pine.LNX.4.64.0702131121590.3604@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 13 Feb 2007 11:25:05 -0800 (PST)")
Message-ID: <87odnxn80u.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Tue, 13 Feb 2007, Sergei Organov wrote:
>> >
>> > 	"I want a char of indeterminate sign"!
>> 
>> I'm afraid I don't follow. Do we have a way to say "I want an int of
>> indeterminate sign" in C? The same way there doesn't seem to be a way
>> to say "I want a char of indeterminate sign".
>
> You're wrong.

Sure, I knew it from the very beginning ;)

>
> Exactly because "char" *by*definition* is "indeterminate sign" as far as 
> something like "strlen()" is concerned.

Thanks, I now understand that you either don't see the difference
between "indeterminate" and "implementation-defined" in this context or
consider it non-essential, so I think I've got your point.

> "char" is _special_. Char is _different_. Char is *not* "int".

Sure.

>
>> So no, strlen() doesn't actually say that, no matter if we like it or 
>> not. It actually says "I want a char with implementation-defined sign".
>
> You're arguing some strange semantic difference in the English
> language.

Didn't I further explain what I meant exactly (that you've skipped)?
OK, never mind.

> I'm not really interested.

OK, no problem.

>
> THE FACT IS, THAT "strlen()" IS DEFINED UNIVERSALLY AS TAKING "char *".

So just don't pass it "unsigned char*". End of story.

>
> That BY DEFINITION means that "strlen()" cannot care about the sign, 
> because the sign IS NOT DEFINED UNIVERSALLY!
>
> And if you cannot accept that fact, it's your problem. Not mine.

I never had problems either with strlen() or with this warning, so was
curious why does the warning is such a problem for the kernel. I'm sorry
I took your time and haven't got an answer that I entirely agree
with. Thank you very much for your explanations anyway.

> The warning is CRAP. End of story.

Amen!

-- Sergei.
