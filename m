Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYGOHt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYGOHt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYGOHtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:49:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55065 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYGOHtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:49:19 -0400
Date: Tue, 15 Jul 2008 09:49:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0807150851040.13215@fbirervta.pbzchgretzou.qr>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>  <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
 <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-07-15 04:47, Linus Torvalds wrote:
>
>No. But the even/odd thing is still so fresh in peoples memory (despite us 
>not having used it for years), and I think some projects aped us on it, so 
>if I didn't change the numbering setup, but just wanted to reset the minor 
>number, I'd probably jump from 2.6 to 2.8 just for historical reasons.

Don't discriminate against odd numbers! :)
I always wanted to see a 2.<odd> on the mingetty login banner just
because that seemed cool, and to hopefully make the last people who
would say "but is not that development series?" finally get the
clue that Linux is not developed in that way anymore.

[in the previous to the previous mail]:
>We don't do releases based on "features" any more, so why should we do 
>version _numbering_ based on "features"?
>
>For example, I don't see any individual feature that would merit a jump 
>from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version 
>jumps should be done by a time-based model too - matching how we 
>actually do releases anyway.

Maybe not individual feature, but as a whole. We probably should have 
jumped when the new model was introduced. Ok, that did not happen, but 
over time, the kernel's abilities increased and then sometime, there 
was a release where you would say (as of today) "yes, that kernel back 
there has been a really good one" where a version jump would have been 
warranted at the same time. For me, these are 2.6.18, .22, .23 or .25 
(pick one). However, there also needs to be a bit of time between minor 
number bumps, so if 2.6.18 were 2.7.0, 2.6.25 would be the earliest to 
qualify for a 2.8.0.

My expectation is that 2.6.27 would be the next "good one" where a 
version jump would go nicely in line. Make it 2.7.0, it got loads 
of new features compared to 2.6.0 :)

My preference is of course that version numbers run at the same speed as 
they have been for most of the time now - that is, incrementing the 
micro as we go. If one were to increment the micro for every release 
(2.6.18 -> 2.7, 2.6.19 -> 2.8, 2.6.20 -> 2.9) then that is a magnitude 
higher and thus would count as faster-going.

>Anyway, I have to say that I personally don't have any hugely strong
>opinions on the numbering. I suspect others do, though, and I'm
>almost certain that this is an absolutely _perfect_
>"bikeshed-painting" subject where thousands of people will be very
>passionate and send me their opinions on why _their_ particular shed
>color is so much better.
>
>The only thing I do know is that I agree that "big meaningless numbers" 
>are bad. "26" is already pretty big. As you point out, the 2.4.x series 
>has much bigger numbers yet.

2.1.132 is big.


Numbering should be interesting and sometimes unexpected (like when 
there suddently was a 2.<even>.0 announcement in my mailbox, or the 
change of development model). The YYYY.r[.s] scheme defeats that, and 
it counts fast too, though I am not opposed to YYYY.r.
What I am against is [YYYY-2008].r (8.0, 8.1, 9.0, etc.) since that may 
be seen as a version number instead of the year.
