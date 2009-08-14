Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZHOQT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZHOQT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZHOQT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:19:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60780 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZHOQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:19:56 -0400
Date: Fri, 14 Aug 2009 18:31:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Question about userspace-consumer
Message-ID: <20090814163138.GA1626@ucw.cz>
References: <20090810200553.GB4652@gandalf> <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811054438.GA7176@gandalf>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Mon, Aug 10, 2009 at 10:58:01PM +0100, Mark Brown wrote:
> > On Mon, Aug 10, 2009 at 11:05:54PM +0300, Felipe Balbi wrote:
> > 
> > > I was reading userspace-consumer file ad was wondering whether would be
> > > possible to use that in order to implement what SBS-IF [1] proposes
> > > using sbs-enabled devices.
> > 
> > Looking at that I'm not sure why you wish to push this into user space?
> 
> we need some daemon monitoring battery statuses and taking actions on
> that. Imagine, for example, usb charging where we can:
> 
> a. charge up to 100mA when unconfigured
> b. charge up to 500mA when configured
> c. charge up to 2.5A when with dedicated charger
> d. charge up to 2.5mA when bus is suspended
> 
> handling all of those cases on kernel space seems a little bit odd,
> especially because we still need to take care of state-of-charge,
> pack temperature, time-to-charge, etc etc etc.
> 
> a big looping polling for that stuff in kernel space didn't seem ok to
> me.

As battery charging is done by hw on many common machines... yes it is
okay to do in kernel.

> > Like I say, from a quick read through of the specs I'm not sure that I'd
> > push this into user space but I've not thought about this deeply and may
> > be missing something.
> 
> I think kernel should, as long as possible, only provide functionalities
> for userland to take decisions and actions, no ?
> 
> Handling policy in kernel space I find it a little odd, specially
> because different manufacturers might have different charging algorithms
> they want to implement.

I don't see what policy you see in battery charging. There is
 basically single battery chemistry in use, so this is not as complex
 as you paint it...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
