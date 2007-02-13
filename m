Return-Path: <linux-kernel-owner+w=401wt.eu-S1751737AbXBMTOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbXBMTOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXBMTOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:14:46 -0500
Received: from javad.com ([216.122.176.236]:3002 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbXBMTOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:14:46 -0500
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
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com>
	<84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
Date: Tue, 13 Feb 2007 22:14:23 +0300
In-Reply-To: <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com>
	(Pekka Enberg's message of "Tue, 13 Feb 2007 20:26:23 +0200")
Message-ID: <87bqjxooog.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Pekka Enberg" <penberg@cs.helsinki.fi> writes:

> On 2/13/07, Sergei Organov <osv@javad.com> wrote:
>> May I suggest another definition for a warning being entirely sucks?
>> "The warning is entirely sucks if and only if it never has true
>> positives." In all other cases it's only more or less sucks, IMHO.
>
> You're totally missing the point.

No, I don't. 

> False positives are not a minor annoyance, they're actively harmful as
> they hide other _useful_ warnings.

Every warning I'm aware of do have false positives. They are indeed
harmful, so one takes steps to get rid of them. If a warning had none
false positives, it should be an error, not a warning in the first
place.

> So, you really want warnings to be about things that can and
> should be fixed.

That's the definition of a "perfect" warning, that is actually called
"error".

> So you really should aim for _zero false positives_ even if you risk
> not detecting some real positives.

With almost any warning out there one makes more or less efforts to
suppress the warning where it gives false positives, isn't it? At least
that's my experience so far.

-- Sergei.
