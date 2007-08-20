Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbXHTS6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbXHTS6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXHTS6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:58:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXHTS6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:58:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: CONFIG_SUSPEND and power consumption
Date: Mon, 20 Aug 2007 21:08:35 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, Jean Delvare <khali@linux-fr.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070819153259.2c96b904@hyperion.delvare> <200708201211.34698.oliver@neukum.org> <20070820172907.GC3975@ucw.cz>
In-Reply-To: <20070820172907.GC3975@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708202108.35674.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 20 August 2007 19:29, Pavel Machek wrote:
> Hi!
> 
> > > If I rmmod "ehci-hcd" then the power consumption is back to 69 W. This
> > > confirms that this is really USB-related. I have to admit that I did
> > > not expect an external drive to eat that much power from the system,
> > > especially when not used. I am told that VIA chips are notoriously bad
> > > at this kind of things. I'll try the same external drive on an Intel
> > > system later today.
> > > 
> > > The last mystery remaining is how USB "activity" can cause my CPU to
> > > heat. I would expect the south bridge to heat, not the CPU.
> > 
> > USB, or strictly speaking EHCI, OHCI and UHCI, use DMA. To allow
> > that the cache coherency logic has to be active. Therefore your CPU
> > cannot go to C3. Therefore it draws more power. The problem we are
> > facing in USB is that to get great savings, our coverage has to be perfect.
> > One device that cannot be autosuspended and we lose most savings.
> 
> Ok.. but CONFIG_USB_SUSPEND should not really have anything to do with
> CONFIG_SUSPEND (= s2ram). Perhaps it should depend on CONFIG_PM
> instead?

CONFIG_USB_SUSPEND doesn't depend on CONFIG_SUSPEND.

Greetings,
Rafael
