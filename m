Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbYBWVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbYBWVc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYBWVcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:32:51 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:25234 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbYBWVcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qf9iCJjycnfkNEfMr+0mH2LzSN0JpXMRVvzaH9dK7jk1YVZCLubjm7rdCftDu2XcsTNGxk80smio2vi6uvfDuPuaBYKMSp8YVe5W+hLXPKOt80NfEmd1FytuVwFf1ko4ZDxIWmwAcZ4zFWSgcoVo81P3vRcxYteLIPXoaCHARPY=
Message-ID: <f19298770802231332x79c0395fl5519e79ae75da0aa@mail.gmail.com>
Date: Sun, 24 Feb 2008 00:32:46 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Alexey Zaytsev" <zaytsev.a@protei.ru>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200802231727.54351.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de>
	 <20080223110751.GN23833@elte.hu> <200802231727.54351.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 7:27 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Saturday 23 February 2008 12:07:51 Ingo Molnar wrote:
>
> > I have to say, after having observed multiple incidents around b43 in
>  > the past few months you are one of the worst driver maintainers i've
>  > ever seen on lkml: you are ignoring regressions, you are frequently
>  > insulting our testers and now you even have the gall to NAK a patch to
>
>  The insults being? A few quotes, please.
>

If you really want to know, the
"Because the new driver works, if you just set it up right."
for me was clearly a hint that I'm just an other imcompetent
user, who can't even follow the instructions from linuxwireless.org.
And you knew that the new driver did no work with the bcm4311
chips, which is the sad thing.

>
>  > _your own buggy driver code_ without providing an alternative fix.
>  > Kudos.
>
>  How dare can you break my kernel, yeah... . We know that.
>  That my patches _fixed_ the kernel for thousands of people doesn't
>  matter.

Not true at all. I  my first and second emails, there was not a single word
about who broke the driver. There were only the fix, and the explanation,
why the fix is needed. I really appreciate the work done on the b43 driver,
and I'd emmediately switch to it, if only it worked for me*.

>  What matters is the one person for whom it broke.

I'm the one person who investigated the problem, wrote a
patch and sent it to the lkml. After lurking in #bcm-users
for a day, I saw quite a few users asking why the b43 driver
did not work for them, and the best answer they got, was
got read the linuxwireless.org. Are you sure they all were
just unable to upgrade the firmware?

And by the way, the bcm4311 and b44 combination is not
something I assembled just to piss you off. It's what HP puts
in their HP Compaq nx7300 laptops. They were like the
cheapest Core Duo laptops a year ago, and I'm sure they were
not exclusively made.

>  So let's
>  apply a questionable fix for it that we don't understand. Hopefully
>  that fixes it and doesn't break it again for somebody else... .
>
>  I provided an alternative fix. In my very first email.

Sorry, your fix does not work for my hardware. And you know it.

>  Ingo, if you know that this fix is right, then please sign it off
>  so we can apply it.
>
>  --
>  Greetings Michael.
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
