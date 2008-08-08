Return-Path: <linux-kernel-owner+w=401wt.eu-S1763579AbYHHWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763579AbYHHWBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761223AbYHHVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1273 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761817AbYHHVyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:20 -0400
Date: Fri, 8 Aug 2008 23:54:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: Freezer: How to handle timers?
Message-ID: <20080808215410.GA11452@ucw.cz>
References: <87fxq4a4x3.fsf@denkblock.local> <877ibe6mik.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ibe6mik.fsf@denkblock.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-22 16:06:59, Elias Oltmanns wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
> > Hi there,
> >
> > am I right in thinking that timers set by mod_timer() will not fire
> > once suspend_freeze_processes() has completed? If so, what options do I
> > have to make sure that either suspending will be delayed until my timer
> > has expired, or the timeout callback will be called as part of the
> > suspend sequence even if the timer has not expired yet?
> 
> Alright, I think I can solve my particular problem quite well by means
> of a pm notifier. However, I'm still wondering whether timers really
> should be affected by suspend_freeze_processes().

I don't think they are... are they?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
