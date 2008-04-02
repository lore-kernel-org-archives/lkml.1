Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYDBNAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYDBNAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbYDBNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:00:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1396 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753040AbYDBNAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:00:36 -0400
Date: Wed, 2 Apr 2008 15:00:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Felix M?ller <fm@opensuse.org>,
       Arthur Erhardt <erhardt@pit.physik.uni-tuebingen.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI PM: Restore the 2.6.24 suspend ordering
Message-ID: <20080402130020.GB5295@ucw.cz>
References: <200803300319.08398.rjw@sisk.pl> <200803301515.33922.rjw@sisk.pl> <20080401084523.GA25278@atrey.karlin.mff.cuni.cz> <200804012155.52547.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804012155.52547.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > We could simply blacklist them, no?
> > > 
> > > Yes, but for this purpose we'll have to redesign the core so that everything
> > > (including debugging and the error paths) works if _PTS is executed before
> > > suspending devices.  _That_, however, is not a 2.6.25 thing.
> > 
> > So we have solution that fixes 2.6.24 systems, makes system that
> > worked in 2.6.25-rc5 work with command line option, but gets error
> > handling wrong.
> > 
> > I guess we could use that?
> 
> IMO we should not use that, because it's broken.  That's why I posted the
> patch.

I understand that. World will not fall down one way or another, but
I'd slightly prefer the 'only change default' version. That's why I
objected to your patch :-).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
