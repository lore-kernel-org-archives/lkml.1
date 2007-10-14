Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbXJNWk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbXJNWk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 18:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760006AbXJNWkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 18:40:51 -0400
Received: from 1wt.eu ([62.212.114.60]:3114 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759803AbXJNWkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 18:40:51 -0400
Date: Mon, 15 Oct 2007 00:39:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-ID: <20071014223921.GA4677@1wt.eu>
References: <1192383445.8372.18.camel@dell1.softservecom.com> <20071014182542.GA2832@1wt.eu> <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 11:45:36PM +0300, Vitaliy Ivanov wrote:
> > Also, while I understand you would be very glad to get your work merged
> > (we all once had our first piece of code), I'd like to mention that you
> > seem to be the only user of this hardware under 2.4 (since it is currently
> > not supported). I'm not sure it's very reasonable to merge a driver in 2.4
> > right now for just one user. Even more, I understand that you finally moved
> > to other hardware, so my feeling is that you did this work as an exercice
> > (which was cleanly performed, BTW), but that it will not get any real use
> > in 2.4.
> 
> Yes, I would like it to be merged... But not just to see my name in
> the kernel sources.
> I'm the only one user of this hardware under 2.4 because it's some
> kind of trick to make it work under 2.4 w/o its support in the kernel.
> We moved to the other hardware because of our reasons and some
> customers can move to the other OS where this hardware will be
> supported.

But something's strange. If people were using 2.4, this hardware has
never worked for them, right ? Why suddenly would they decide that
they have to switch OS or hardware ? Or maybe this hardware replaces
an old one which was supported ?

> I'm sure that we're not the first who tried to make it work in 2.4.

Perhaps, but if you were the last, interest is pretty limited :-)

> Original driver was created for 2.5 and > because interrupt out urbs
> were not supported in 2.4. Now it's not an issue.
> 
> >
> > Since 2.4 is moving very slowly, there should be no problem applying
> > this patch to any version if you really need to use it. Maybe it would
> > even work with your 2.4 enterprise kernel.
> >
> > Note that I'm not radically opposed to merge support for new drivers.
> > If you provide us with really good arguments for a merge, maybe I'll
> > change my opinion, but I doubt about it, since the only users of this
> > device must currently be running 2.6.
> 
> I'm not going to force you to do this, also I can't do this:). But
> after going through the recent news where Greg proposed to create
> drivers for companies for free it looks really reasonable. I
> understand that we are talking about 2.4 but if you will simply run
> diff for adutux of 2.4 and 2.6 you will see that changes are really
> trivial.

That's what I've seen. I can propose you something (unless someone
else raises his hand saying "no") : you update your patch with a
short description of what the hardware module is supposed to be used
for, and you accept to step up as the maintainer for this backport,
which will imply that you put your name and mail in the MAINTAINERS
file. That way, if you're the only user, nobody will be annoyed, and
if there are other users and some of them have problems, I don't waste
my time on something I don't know at all. If you agree with this deal
(which I think is fair), then I'm willing to merge your patch into
2.4.36-pre.

> Also IMHO the more drivers are in the tree the more users will use it.

Not necessarily. 2.4 is currently used by people who already are in 2.4
and cannot/do not want to switch, and by people who are looking for close
to zero maintenance. Drivers are often a reason to switch away from 2.4,
but not to stay in 2.4.

> Once it will be merged in the mainline then it will be backported to
> enterprise kernels and would gain wide usage.

I don't believe that. Enterprise kernels will not evolve much and will
probably not enable it as long as they have not tested it.

Regards,
Willy

