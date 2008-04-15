Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbYDOJOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbYDOJOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYDOJOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:14:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45582 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbYDOJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:14:05 -0400
Date: Tue, 15 Apr 2008 11:14:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: K?roly Kasza <kaszak@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       kernel list <linux-kernel@vger.kernel.org>, lcostantino@gmail.com,
       someone@dunanet.hu
Subject: Re: w35und: add softmac interface
Message-ID: <20080415091403.GA32652@atrey.karlin.mff.cuni.cz>
References: <20080414224740.GA31431@elf.ucw.cz> <20080415002826.GC4270@tuxdriver.com> <20080415070923.GA13767@elf.ucw.cz> <544ab8580804150110x2f1841b4m7ebd43f1a6441458@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544ab8580804150110x2f1841b4m7ebd43f1a6441458@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  > > This adds softmac interface to w35und driver... so it becomes monster
> >  > > driver with _two_ interfaces.
> >  > >
> >  > > If you initialize hardmac interface, then softmac starts to
> >  > > works... it associates to AP, and can even ping.
> >  > >
> >  > > (Or at least I hope so... it was somewhat too easy.)
> >  >
> >
> > > OK, I'm late to the party...what is this stuff going into
> >  > drivers/net/wireless?
> >
> >  Actually you are about month early to the party ;-). We are trying to
> >  clean up winbond usb wireless driver, so that it can think about
> >  inclusion in kernel.
> >
> >  http://code.google.com/p/winbondport/
> >
> >  Unfortunately, original driver carries its own 802.11 stack with it;
> >  that needs to be stripped down. (And then code needs to be rewritten
> >  due to horrible coding style).

> 
> Last weekend we have started to rewrite the whole code based on
> rtl8187's softmac driver.

Hmm, I used adm* code as a template.

> The wlan0 device init with it's own mac is ok, but thats all so far. I
> think it would be more sane to just drop the
> old driver now (it would take more work the correct the old one), and
> create a new svn branch for the softmac
> only brand new one.

Really take a look at those patches. I believe I'm pretty close to
dropping those upper layer code... Then, we'll be able to proceed
incrementally.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
