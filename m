Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbXHBPsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbXHBPsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbXHBPsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:48:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4344 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754096AbXHBPsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:48:23 -0400
Date: Wed, 1 Aug 2007 09:34:37 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Milton Miller <miltonm@bga.com>,
       Ying Huang <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Message-ID: <20070801093437.GC4808@ucw.cz>
References: <200707202335.05519.oliver@neukum.org> <Pine.LNX.4.44L0.0707201820050.5241-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707201820050.5241-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  Do we have to block module loading?
> 
> No.  Registering new drivers is okay, registering new devices is bad.
> 
> Of course, some modules do want to register a new device in their init 
> method.  I don't know what we should do about them.  Force the 
> registration to fail, I suppose.  How often will people suspend while a 
> module is loading?

Well... plug this pcmcia card into the slot so that I do not have to
carry it separately, close the lid and go?

...not that impossible to imagine...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
