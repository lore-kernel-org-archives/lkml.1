Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXGYUJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXGYUJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXGYUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:09:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:59002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752323AbXGYUJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:09:28 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19w0Ktqzc5wsCPLGwh2d5+5l+z31yhF+01BpioSoX
	pd1gkWq+7xcdhp
Date: Wed, 25 Jul 2007 22:09:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
In-Reply-To: <46A7AC17.9060309@ru.mvista.com>
Message-ID: <Pine.LNX.4.60.0707252203160.6234@poirot.grange>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
 <Pine.LNX.4.60.0707252130090.6234@poirot.grange> <46A7A8FB.5090909@ru.mvista.com>
 <Pine.LNX.4.60.0707252150540.6234@poirot.grange> <46A7AC17.9060309@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Sergei Shtylyov wrote:

> Guennadi Liakhovetski wrote:
> 
> > >   Wrong list to submit sych stuff, post to linux-ide.
> 
> > Not entirely. The patch (or other patches in the series) would also touch
> > ARM platforms in the mainline, currently using that driver. As I didn't 
> 
>    Was worth cross-posting to linux-ide anyway to get the IDE experts'
> feedback. ;-)

linux-arm* mailing lists do not allow cross-posting.

> > have a chance to test them due to lack of hardware, I posted on arm, asking
> > if anyone would test those platforms for me.
> 
>   ... and they laughed at you? ;-)

No, noone had that hardware either:-) Those who had preferred to forget 
about it, I guess.

> > It was largely in accordance with my own opinion, so, I chose to accept
> > it:-)
> 
>    It's not clear why you decided to waste time on it then. :-)

Because I myself was in the situation where my local version of the driver 
was filling with #ifdef's supporting all possible variations of our 
hardware, so, I switched it to platform_driver to clean up that mess. And 
then decided to ask if others would consider it useful. Just in case. I 
hoped they wouldn't.

> > > > doubt, just wanted to double-check. So, why do we now need a new legacy
> > > > (a/drivers/ide/legacy/ide_platform.c) driver when a "modern" driver
> > > > exists?
> 
> > >   Good question (I know the answer but won't tell ;-).
> 
> > You've been very cooperative, thanks.
> 
>    In fact, I also highly doubt that we need it.  What we'd need is an OF
> driver.

Great, thanks. Now we have to find out why Alan acked it (added to cc).

Thanks
Guennadi
---
Guennadi Liakhovetski
