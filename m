Return-Path: <linux-kernel-owner+w=401wt.eu-S1751037AbXBMUcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbXBMUcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbXBMUcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:32:19 -0500
Received: from javad.com ([216.122.176.236]:4903 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXBMUcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:32:18 -0500
From: Sergei Organov <osv@javad.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       =?utf-8?B?Si5BLiBN?= =?utf-8?B?YWdhbGzDg8ODw4LCs24=?= 
	<jamagallon@ono.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com>
	<84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
	<87bqjxooog.fsf@javad.com>
	<84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
Date: Tue, 13 Feb 2007 23:29:44 +0300
In-Reply-To: <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com>
	(Pekka Enberg's message of "Tue, 13 Feb 2007 21:43:41 +0200")
Message-ID: <87fy99n6mf.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Pekka Enberg" <penberg@cs.helsinki.fi> writes:
> On 2/13/07, Sergei Organov <osv@javad.com> wrote:
>> With almost any warning out there one makes more or less efforts to
>> suppress the warning where it gives false positives, isn't it?
>
> Yes, as long it's the _compiler_ that's doing the effort.
> You shouldn't need to annotate the source just to make the compiler
> shut up.

Sorry, what do you do with "variable 'xxx' might be used uninitialized"
warning when it's false? Turn it off? Annotate the source? Assign fake
initialization value? Change the compiler so that it does "the effort"
for you? Never encountered false positive from this warning?

> Once the compiler starts issuing enough false positives, it's
> time to turn off that warning completely.

Yes, I don't argue that. I said "otherwise the warning is more or less
sucks", and then it's up to programmers to decide if it's enough sucks
to be turned off. The decision depends on the importance of its true
positives then. Only if warning never has true positives it is
unconditional, total, unhelpful crap, -- that was my point.

> Therefore, the only sane strategy for a warning is to aim for zero
> false positives.

Sure. But unfortunately this in an unreachable aim in most cases.

-- Sergei.
