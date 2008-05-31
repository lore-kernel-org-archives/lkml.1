Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbYFAORi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbYFAORi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYFAOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:16:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4364 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbYFAOQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:16:50 -0400
Date: Sat, 31 May 2008 10:00:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Theodore Tso <tytso@mit.edu>, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080531080015.GG5405@ucw.cz>
References: <20080508161008.59361de5@appleyard> <20080527030854.GC7515@mit.edu> <20080527143202.4bab5bf0@appleyard> <20080527225926.GE6843@mit.edu> <20080527163251.04054a74@appleyard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527163251.04054a74@appleyard>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > As far as I know the patch has gone nowhere.  I believe that 
> > > Jeff wanted something more flexible than the module parameter that
> > > I provided to override the BIOS options.  I am not working on this,
> > > I figured he had a pretty firm idea what he wanted so he was better
> > > equipped to write the patch.
> > 
> > Thanks Kristen,
> > 
> > Can you say which laptops you had tested this on where it saved power?
> > (Did you test any Thinkpads, in particular?)  I'm wondering if it's
> > worth trying to forward port your patch as a private mod to my kernel;
> > 30 to 40 minutes of extra battery life is nothing to sneeze at!
> > 
> > 						- Ted
> > 
> 
> I tested this on an Intel mobile software development platform 
> with a newer mobile ICH - the power savings were measured at the actual 
> component (via probes on the ICH), so I did not measure the power 
> savings at the wall socket, although I would expect the power savings
> to be even greater on the other side of the power supply.  So in short,
> yes, I think it's worth it to give it a try - the patch is pretty
> unintrusive, so it should be that difficult a port to do.

Can you repost the patch? I believe we should push it and only add
complex enable/disable functionality if someone needs it...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
