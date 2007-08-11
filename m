Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbXHKXpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbXHKXpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 19:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbXHKXov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 19:44:51 -0400
Received: from mx.treblig.org ([80.68.94.177]:2773 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbXHKXou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 19:44:50 -0400
Date: Sun, 12 Aug 2007 00:43:56 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Vojtech Pavlik <vojtech@suse.cz>, seife@suse.de,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20070811234356.GA19183@gallifrey>
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey> <200707160038.12943.rjw@sisk.pl> <20070729065352.GB17084@suse.cz> <20070805195628.GA1947@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805195628.GA1947@elf.ucw.cz>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 00:41:30 up 99 days, 17:24,  2 users,  load average: 0.53, 0.55, 0.56
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> Hi!
> 
> > > > Two things which I think would be nice to consider are:
> > > >    1) Encryption - I'd actually prefer if my luks device did not
> > > >        remember the key accross a hibernation; I want to be forced to
> > > >        reenter the phrase.  However I don't know what the best thing
> > > >        to do to partitions/applications using the luks device is.
> > > 
> > > Encryption is possible with both the userland hibernation (aka uswsusp) and
> > > TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a "must
> > > have" feature for a framework to be generally useful (many users don't use it
> > > anyway).
> > 
> > If a user uses an encrypted filesystem, then he also needs an encrypted
> > swap and encrypted hibernation image: Otherwise the fileystem encryption
> > is not very useful.
> 
> Actually, we can do most of that stuff already. 
> 
> We can encrypt filesystems, encrypt swaps (LVM), and encrypt hibernation.

But can you do what my original question was; find a way to lose a luks
encrypted device key and cleanly unmount the filesystem that was
using it?  (and preferably put it all back together after resume).

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
