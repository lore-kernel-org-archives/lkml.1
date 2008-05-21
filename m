Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbYEUKlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbYEUKlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYEUKlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:41:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35299 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYEUKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:41:39 -0400
Date: Wed, 21 May 2008 12:41:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: better msleep for drivers
Message-ID: <20080521104131.GA4948@ucw.cz>
References: <20080511110124.GA24187@basil.nowhere.org> <alpine.LFD.1.10.0805111408440.3197@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805111408440.3197@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Still longer term I suppose there's really no way around having accurate
> > sleep functions and it's probably better to start testing earlier than later.
> 
> No objections, but we should not do that with a stupid msleep
> replacement interface; instead we should expose a flexible in kernel
> variant of hrtimer_nanosleep() which lets the user utilize
> ABS/REL_TIME and the different clocks. A msleep helper can be built on
> top of this very easily.

While you are at it... it would be cool to have

'mdelay(2500 msec), but it is okay to wait 100msec more' -- type
interface, so we could use that for nohz benefit.

Currently, mdelay is 'it is okay to wait 10msec more' interface, and
it would be nice to have that explicit.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
