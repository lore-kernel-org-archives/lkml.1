Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYGOCso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYGOCso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYGOCsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:48:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbYGOCsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:48:30 -0400
Date: Mon, 14 Jul 2008 19:47:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       gorcunov@gmail.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
In-Reply-To: <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>  <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
> >
> > For example, I don't see any individual feature that would merit a jump
> > from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps
> > should be done by a time-based model too - matching how we actually do
> > releases anyway.
>
> Does it have to be even numbers only?

No. But the even/odd thing is still so fresh in peoples memory (despite us 
not having used it for years), and I think some projects aped us on it, so 
if I didn't change the numbering setup, but just wanted to reset the minor 
number, I'd probably jump from 2.6 to 2.8 just for historical reasons.

But I could also see the second number as being the "year", and 2008 would 
get 2.8, and then next year I'd make the first release of 2009 be 2.9.1 
(and probably avoid the ".0" just because it again has the connotations of 
a "big new untested release", which is not true in a date-based numbering 
scheme). And then 2010 would be 3.0.1 etc..

Anyway, I have to say that I personally don't have any hugely strong 
opinions on the numbering. I suspect others do, though, and I'm almost 
certain that this is an absolutely _perfect_ "bikeshed-painting" subject 
where thousands of people will be very passionate and send me their 
opinions on why _their_ particular shed color is so much better.

The only thing I do know is that I agree that "big meaningless numbers" 
are bad. "26" is already pretty big. As you point out, the 2.4.x series 
has much bigger numbers yet.

And yes, something like "2008" is obviously numerically bigger, but has a 
direct meaning and as such is possibly better than something arbitrary and 
non-descriptive like "26".

Let the bike-shed-painting begin.

(I had planned on taking this up at the kernel summit, where the shed 
painting is at least limited to a much smaller audience, but since you 
asked..)

			Linus
