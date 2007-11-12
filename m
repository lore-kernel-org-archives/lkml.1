Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbXKLQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbXKLQNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXKLQNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:13:05 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:35381 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXKLQND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:13:03 -0500
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2007 11:13:03 EST
Date: Mon, 12 Nov 2007 18:02:54 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071112160254.GA31972@jolt.modeemi.cs.tut.fi>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071112152057.GJ9771@stusta.de>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-11-12 16:20 +0100, Adrian Bunk wrote:
> The problem is not what the distributions ship, the problem is simply 
> that problems with distribution packaged software should be reported 
> to the distribution, not upstream.
> 
> And for becoming at least marginally on-topic again:
> Assuming your "stable base systems" contains the Linux kernel, how would
> you prevent users from reporting bugs in their ancient kernels [1] here?

You obviously can't prevent them from reporting problems, but you can
dissuade them from doing that. The kernel (and "Linux" in general)
being rather "generic" and faceless in the sense I mentioned in the
previous post does work to that end, and users are more aware that 
"it's the Debian kernel", than it's, say, "a Debian-corrupted 
ancient development snapshot of Ion". The Debian kernel packages
are not even called 'Linux', just 'kernel', unlike the Ion packages
(in "non-free" these days).

It is also of importance that the so-called community around such faceless
generic projects is much bigger than marginal software, where the author
is likely to be the only one being able to help, and the typical contact
address. Do people bother Linus specifically about the kernel? Do they
actually expect Linus himself to bother with their worries? Typically, no.
Not so with more marginal software with a face and a definite author.

The distro's kernel is also obviously much better tested and supported 
than random marginal software they throw in without regard for the 
upstream state of development -- distros don't care about upstream, 
they just them as workhorses. The average luser doesn't even need to 
know what kernel or other generic software the distro is running that
it installs by default, and many of the problems arise in the distro
installation phase. But when they hear of something new and fancy like
Ion, they just go ahead and install it from the distro, because there's
no other convenient way and they're used to it, and get broken, and
unsupported ancient crap (corrupted to use AA/XML-fascist Xft/fontconfig
that the author will have nothing to do with [1]) without being aware of
this, and then come bothering the author, the software having a face.

> You should rephrase it:
> Closed-source operating systems offer less software both available for 
> convenient installation and supported by the vendor of the operating 
> system.

That's utter and total bullshit. Distros don't provide proper support
for the marginal software they throw in to be able to brag with a huge
(and mostly worthless) package collection. It is very laboursome to 
install original author software rather than distro (Party) software,
unlike in closed-source operating systems, where the OS developer 
only provides a rather stable base on which to install third party 
software, not a broken megafrozen snapshot of Everything.

> Noone forces any users to install the software their distribution 
> supports - people can (and sometimes do) install other software or
> other versions of some software when they need it.

It's not that they can't, just that they often won't, because it's 
so laboursome. The "freedom" in free software is merely theoretical,
not practical. (See below too.)

> But the good thing about open source software is that when you believe 
> your ideas are better than what current distributions do you can 
> implement your ideas and create your own distribution. 

Haha, the typical FOSS advocate's fallacy. Quote:

“You have the binary, you can crack it.” Does that sound familiar? No? How
about? “It's free software, you can fix or implement what you want.” These
two statements are fundamentally the same: they expect that you have the
time and skill to modify the software to your needs. That it is easier when
the source is out in the open – and it doesn't even have to be “free” or
“open source” – is just a detail. Nevertheless, the uncritical free software
and open source advocates often resort to this argument when their software
is found flawed. It is true, the herd of the bazaar indeed has the power to
modify software to its liking – to the shoddy least common denominator
product that herd desires are for. It is even possible for the unique one to
set up a shop within the bazaar, providing minor improvements to a few of
the bazaar's shoddy products. But to build a cathedral providing treatments
to all the ills of the bazaar – that demands more effort than the herd can
appreciate. There is no practical choice but to use the shoddy products of
the bazaar. In the present state of affairs, for those not of the herd, the
only choice – the only practical freedom – in free software, is the choice
not to use it.

  [1]: http://iki.fi/tuomov/b/archives/2006/03/17/T20_15_31/

-- 
Tuomo
