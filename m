Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYBWWVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYBWWVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 17:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYBWWVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 17:21:41 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:60323 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYBWWVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 17:21:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Sat, 23 Feb 2008 23:20:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <200802231727.54351.mb@bu3sch.de> <f19298770802231332x79c0395fl5519e79ae75da0aa@mail.gmail.com>
In-Reply-To: <f19298770802231332x79c0395fl5519e79ae75da0aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232320.58562.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 22:32:46 Alexey Zaytsev wrote:
> >  The insults being? A few quotes, please.
> If you really want to know, the
> "Because the new driver works, if you just set it up right."
> for me was clearly a hint that I'm just an other imcompetent
> user, who can't even follow the instructions from linuxwireless.org.

Well. That's 99% of all bugreports I receive. You will understand
that I won't explain the same crap that's written on linuxwireless.org
over and over 20 times each day to random people.
And yes, you belong to the group of my "random people", as I don't
remember your name from the top of my head.
So in 99% of the cases the user did something wrong.

But I still don't see the insult.

> And you knew that the new driver did no work with the bcm4311
> chips, which is the sad thing.

That is not true. It doesn't work with exactly _one_ revision
of the bcm4311 card. And that is already fixed in 2.6.25.
I'd like to have that in .24-stable, too, but I guess it's too big.
It changes some parts of the DMA engine code.

> Not true at all. I  my first and second emails, there was not a single word
> about who broke the driver. There were only the fix, and the explanation,
> why the fix is needed. I really appreciate the work done on the b43 driver,
> and I'd emmediately switch to it, if only it worked for me*.

Yeah. But I don't like that patch. Then people came and said stuff like
I _have_ to accept it because it fixes stuff I broke. Excuse me, but
nobody can force me to sign off a patch that I am not completely
convinced of. _Even_ if it turns out that a commit made by me
broke something. Especially, if there's already another fix for the
situation queued up in the development kernel.

> I'm the one person who investigated the problem, wrote a
> patch and sent it to the lkml. After lurking in #bcm-users
> for a day, I saw quite a few users asking why the b43 driver
> did not work for them, and the best answer they got, was
> got read the linuxwireless.org. Are you sure they all were
> just unable to upgrade the firmware?

Yeah. Experience shows that. Read the archives.

> And by the way, the bcm4311 and b44 combination is not
> something I assembled just to piss you off. It's what HP puts
> in their HP Compaq nx7300 laptops. They were like the
> cheapest Core Duo laptops a year ago, and I'm sure they were
> not exclusively made.

So be it. And you guess what? We already sent a fix for those
people upstream a long time ago. It is in 2.6.25.

> >  So let's
> >  apply a questionable fix for it that we don't understand. Hopefully
> >  that fixes it and doesn't break it again for somebody else... .
> >
> >  I provided an alternative fix. In my very first email.
> 
> Sorry, your fix does not work for my hardware. And you know it.

Did you _ever_ even try it?
http://linuxwireless.org/en/users/Download

-- 
Greetings Michael.
