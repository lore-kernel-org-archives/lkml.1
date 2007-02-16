Return-Path: <linux-kernel-owner+w=401wt.eu-S1750745AbXBPLVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750745AbXBPLVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 06:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXBPLVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 06:21:55 -0500
Received: from javad.com ([216.122.176.236]:4369 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXBPLVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 06:21:54 -0500
From: Sergei Organov <osv@javad.com>
To: 7eggert@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "J.A. =?utf-8?B?TWFn?= =?utf-8?B?YWxsw4PDg8ODw4LCs24=?=" 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <7Mj5f-3oz-21@gated-at.bofh.it> <7MktH-5EW-35@gated-at.bofh.it>
	<7Mmvy-vj-17@gated-at.bofh.it> <7MnBC-2fk-13@gated-at.bofh.it>
	<7MoQx-4p8-11@gated-at.bofh.it> <7MpjE-50z-7@gated-at.bofh.it>
	<7MpCS-5Fe-9@gated-at.bofh.it> <7MDd7-17w-1@gated-at.bofh.it>
	<7MGkB-62k-31@gated-at.bofh.it> <7NHoe-2Mb-37@gated-at.bofh.it>
	<7NMe9-1ZN-7@gated-at.bofh.it> <7Oagl-6bO-1@gated-at.bofh.it>
	<7ObvW-89N-23@gated-at.bofh.it> <7Oc8t-NS-1@gated-at.bofh.it>
	<E1HHmuB-0001lW-E1@be1.lrz>
Date: Fri, 16 Feb 2007 14:21:27 +0300
In-Reply-To: <E1HHmuB-0001lW-E1@be1.lrz> (Bodo Eggert's message of "Thu, 15
	Feb 2007 21:08:35 +0100")
Message-ID: <874ppmjqko.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert <7eggert@gmx.de> writes:
> Sergei Organov <osv@javad.com> wrote:
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
[...]
> Using signed chars for strings is wrong in most countries on earth. It was
> wrong when the first IBM PC came out in 1981, and creating a compiler in
> 1987 defaulting to signed char is a sure sign of originating from an
> isolated country and knowing nothing about this planet.

Maybe I'm wrong, but wasn't it the case that C had no "signed char" type
that time, so "char" had to be abused for the "tiny signed integer"?

> Using signed chars in comparisons is especially wrong, and casting
> each char to unsigned before comparing them is likely to be
> forgotten.

If we start talking about the C language, my opinion is that it's C
problem that it allows numeric comparison of "char" variables at
all. If one actually needs to compare alphabetic characters numerically,
he should first cast to required integer type.

> Unsigned character strings are useless because there is no such thing
> as char(-23), and if these strings weren't casted to signed inside all
> IO functions, they wouldn't work correctly.

Didn't you swap "signed" and "unsigned" by mistake in this phrase? Or
are you indeed think that using "unsigned char*" for strings is useless?

> Only because many programmers don't compare chars, most programs will
> work outside the USA.

Comparison of characters being numeric is not a very good property of
the C language.

> I repeat: Thanks to using signed chars, the programs only
> work /by/ /accident/! Promoting the use of signed char strings is promoting
> bugs and endangering the stability of all our systems. You should stop this
> bullshit now, instead of increasing the pile.

Where did you see I promoted using of "singed char strings"?! If you
don't like the fact that in C language characters are "char", strings
are "char*", and the sign of char is implementation-defined, please
argue with the C committee, not with me.

Or use -funsigned-char to get dialect of C that fits your requirements
better.

-- Sergei.
