Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbXHTR31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbXHTR31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbXHTR3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:29:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2612 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbXHTR3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:29:19 -0400
Date: Mon, 20 Aug 2007 17:29:07 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_SUSPEND and power consumption
Message-ID: <20070820172907.GC3975@ucw.cz>
References: <20070819153259.2c96b904@hyperion.delvare> <200708192242.43819.rjw@sisk.pl> <20070820120258.7d090cc4@hyperion.delvare> <200708201211.34698.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708201211.34698.oliver@neukum.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If I rmmod "ehci-hcd" then the power consumption is back to 69 W. This
> > confirms that this is really USB-related. I have to admit that I did
> > not expect an external drive to eat that much power from the system,
> > especially when not used. I am told that VIA chips are notoriously bad
> > at this kind of things. I'll try the same external drive on an Intel
> > system later today.
> > 
> > The last mystery remaining is how USB "activity" can cause my CPU to
> > heat. I would expect the south bridge to heat, not the CPU.
> 
> USB, or strictly speaking EHCI, OHCI and UHCI, use DMA. To allow
> that the cache coherency logic has to be active. Therefore your CPU
> cannot go to C3. Therefore it draws more power. The problem we are
> facing in USB is that to get great savings, our coverage has to be perfect.
> One device that cannot be autosuspended and we lose most savings.

Ok.. but CONFIG_USB_SUSPEND should not really have anything to do with
CONFIG_SUSPEND (= s2ram). Perhaps it should depend on CONFIG_PM
instead?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
