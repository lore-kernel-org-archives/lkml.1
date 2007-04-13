Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbXDMCTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbXDMCTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 22:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXDMCTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 22:19:08 -0400
Received: from mx33.mail.ru ([194.67.23.194]:34441 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbXDMCTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 22:19:06 -0400
Date: Fri, 13 Apr 2007 06:15:50 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, kernel-discuss@handhelds.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070413021550.GA15790@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org> <1734853889.20070412173626@gmail.com> <20070412185630.GC27804@khazad-dum.debian.net> <20070412204413.GA3151@zarina> <20070413005112.GA20890@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070413005112.GA20890@khazad-dum.debian.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:51:12PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 13 Apr 2007, Anton Vorontsov wrote:
> > Let's name attributes with mWh units as {min_,max_,design_,}energy,
> > and attributes with mAh units as {min_,max_,design_,}charge.
> 
> [...]
> 
> > * Yup, I've read last discussion regarding batteries, and I've seen
> >   objections against "charge" term, quoting Shem Multinymous:
> > 
> >   "And, for the reasons I explained earlier, I strongly suggest not using
> >   the term "charge" except when referring to the action of charging.
> >   Hence:
> >   s/charge_rate/rate/;  s/charge/capacity/"
> > 
> >   But lets think about it once again? We'll make things much cleaner
> >   if we'll drop "capacity" at all.
> 
> I stand with Shem on this one.  The people behind the SBS specification
> seems to agree... that specification is aimed at *engineers* and still
> avoids the obvious trap of using "charge" due to its high potential for
> confusion.
> 
> I don't even want to know how much of a mess the people writing applets
> woudl make of it...

:-(

Okay, term "charge" is out of scope, I guess. But can we use "capacity"
for xAh, and "energy" for xWh? I just trying to separate these terms
somehow, and avoid "_units" stuff.

> 
> > > That said, you may need to use uWh and uAh instead of mAh and mWh, though.
> > 
> > Not sure. Is there any existing chip that can report uAh/uWh? That is
> > great precision.
> 
> The way things are going, it should be feasible for small embedded systems
> quite soon.  Refer to the previous thread.

I see... is it also applicable to currents and voltages? I.e. should we
use uA and uV from the start?

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
