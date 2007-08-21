Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbXHUJfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbXHUJfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbXHUJel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:34:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55116 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756730AbXHUJej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:34:39 -0400
Date: Tue, 21 Aug 2007 09:29:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Vojtech Pavlik <vojtech@suse.cz>,
       seife@suse.de, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
Subject: Re: encrypted hibernation (was Re: Hibernation considerations)
Message-ID: <20070821072917.GA7258@elf.ucw.cz>
References: <200707151433.34625.rjw@sisk.pl> <20070805195628.GA1947@elf.ucw.cz> <20070811234356.GA19183@gallifrey> <200708130012.27412.rjw@sisk.pl> <20070818193733.GC16635@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818193733.GC16635@gallifrey>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > > Two things which I think would be nice to consider are:
> > > > > > >    1) Encryption - I'd actually prefer if my luks device did not
> > > > > > >        remember the key accross a hibernation;
> > 
> > Why exactly (assuming that the hibernation image is encrypted)?
> 
> I was assuming the hibernation image was not encrypted.
> Certainly if it meant a penalty during normal operation (e.g. encrypted swap)
> it wouldn't be.

uswsusp works the way you want. Don't encrypt normal swap, and uswsusp
will still be encrypted.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
