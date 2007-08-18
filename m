Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbXHRTiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbXHRTiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbXHRThy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:37:54 -0400
Received: from mx.treblig.org ([80.68.94.177]:3697 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbXHRThx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:37:53 -0400
Date: Sat, 18 Aug 2007 20:37:34 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Vojtech Pavlik <vojtech@suse.cz>,
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
Message-ID: <20070818193733.GC16635@gallifrey>
References: <200707151433.34625.rjw@sisk.pl> <20070805195628.GA1947@elf.ucw.cz> <20070811234356.GA19183@gallifrey> <200708130012.27412.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708130012.27412.rjw@sisk.pl>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 20:34:17 up 5 days,  3:48,  2 users,  load average: 0.87, 0.60, 0.50
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> On Sunday, 12 August 2007 01:43, Dr. David Alan Gilbert wrote:
> > * Pavel Machek (pavel@ucw.cz) wrote:
> > > Hi!
> > > 
> > > > > > Two things which I think would be nice to consider are:
> > > > > >    1) Encryption - I'd actually prefer if my luks device did not
> > > > > >        remember the key accross a hibernation;
> 
> Why exactly (assuming that the hibernation image is encrypted)?

I was assuming the hibernation image was not encrypted.
Certainly if it meant a penalty during normal operation (e.g. encrypted swap)
it wouldn't be.

(I have a small amount of encrypted data in a luks partition,
most of the time it isn't used, only rarely do apps have it open
and I'm not actually worried about crawling through swap to find out
what is there - this is just a personal laptop; I appreciate these
concerns are different depending what you are storing).

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
