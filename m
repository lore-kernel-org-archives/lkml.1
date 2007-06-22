Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbXFVX0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbXFVX0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXFVX0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:26:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:41070 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbXFVX0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qvYurYZk1VVx+dYwgJhRKjoHTplvkC9xyIiIm1m6+S1JFBOUJPoF+A8PQ5UXnVtr69wbsHHMQFDBIQKtbMLmZL0SXkCco9qPYEe0wOhVgcTVXRjdhbtuQaRQ/rMIW0X6YgL4JfQq6dU6xs62v7Bti4yMWwSL02J5/DAhKhIXUtw=
Message-ID: <a781481a0706221626q17f533ccnac09b2cc7c89126d@mail.gmail.com>
Date: Sat, 23 Jun 2007 04:56:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>, toralf.foerster@gmx.de,
       "Oliver Neukum" <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Luca Risolia" <luca.risolia@studio.unibo.it>
In-Reply-To: <Pine.LNX.4.64.0706230049480.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de>
	 <1182518566.14289.20.camel@gaivota>
	 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
	 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
	 <Pine.LNX.4.64.0706222336210.1817@scrub.home>
	 <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com>
	 <Pine.LNX.4.64.0706230017430.1817@scrub.home>
	 <a781481a0706221533j34c341c5gf7ff92997e2463a6@mail.gmail.com>
	 <Pine.LNX.4.64.0706230049480.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/23/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> On Sat, 23 Jun 2007, Satyam Sharma wrote:
>
> > 1. Kconfig symbols will always have code associated with them.
> > That's the entire purpose of Kconfig, is it not?
>
> A possible counter example: CONFIG_SCSI.
> (RAID_ATTRS is currently a little misplaced).
> It's optional for any config symbol to have any code attached to it,
> menuconfig doesn't change anything.

CONFIG_SCSI _does_ have code associated with it.
(so does CONFIG_RAID_ATTRS)

[ I was expecting you to give the counter-example of various
config symbols that control the assignment of some value to
some variable, actually, but then I would've countered back
with the fact that a variable is also "code" and not something
that is only about presentation / user interface :-) ]

> > 2. "menuconfig" symbols, otoh, were _invented_ for another reason
> > entirely: presentation and user interface i.e. so that users are able
> > to disable entire menus (and all the options contained therein)
> > without having to enter into the menu first, and without having to
> > disable all options individually (which was the situation that existed
> > before the introduction of these menuconfig objects).
>
> Since I'm the one who _invented_ it, I can tell you you're wrong. :)
> This functionality isn't limited to menuconfig symbols. The menu option
> simply changes how the child symbols can be displayed.

Yup, so how / why am I wrong? I was making the point that a
"menuconfig" does not have code associated with it. Why else
_was_ it invented then, if not only for presentation / user interface
purposes? I really don't see what role it plays as a "config symbol"
in Kconfig (other than the fact that that is how it got implemented
to do its thing).

Satyam
