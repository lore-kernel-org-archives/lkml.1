Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbXEEVBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbXEEVBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXEEVBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:01:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43848 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933869AbXEEVBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:01:44 -0400
Date: Sat, 5 May 2007 23:01:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Message-ID: <20070505210139.GA26652@elf.ucw.cz>
References: <200705041132.32227.rjw@sisk.pl> <200705051421.31067.rjw@sisk.pl> <1178368028.7408.93.camel@johannes.berg> <200705051550.53436.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705051550.53436.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Power off the system instead of halting it if the 'platform' mode of
> > > hibernation
> > > has been requested, but hibernation_ops is not set. 
> > 
> > Ehm, unless you made a mistake in the patch then that shouldn't be
> > possible.
> 
> Hmm, right, but the patch is correct nevertheless. :-)
> 
> I see where the problem is.  hibernation_mode is 0 by default
> (HIBERNATION_INVALID) and it's not changed to anything else later if
> defaults are used.

> Something like this is necessary, I think:
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make sure that hibernation_mode is set to a reasonable value by default.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
