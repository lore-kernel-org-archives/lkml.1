Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbYAEVvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbYAEVvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbYAEVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:51:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37662 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757518AbYAEVvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:51:14 -0500
Date: Sat, 5 Jan 2008 22:51:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20080105215123.GA21565@elf.ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <20071230111552.GA8578@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230111552.GA8578@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-30 12:15:52, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Todays hardware is mostly capable of doing better: with correctly set 
> > up wakeups, machine can sleep and successfully pretend it is not 
> > sleeping -- by waking up whenever something interesting happens. Of 
> > course, it is easier on machines not connected to the network, and on 
> > notebook computers.
> > 
> > Requirements:
> > 
> > 0) Working suspend-to-RAM, with kernel being able to bring video back.
> > 
> > 1) RTC clock that can wake up system
> 
> very nice approach! It might require smarter hardware to be really 
> efficient, but the generic ability for Linux to utilize S3 automatically 
> would _quickly_ drive the creation of smarter hardware i'm sure - so i'd 
> propose to include this even if it wastes power in some cases.
> 
> a quick feature request: could you please make the wake-on-RTC 
> capability generic and add a CONFIG_DEBUG_SUSPEND_ON_RAM=y config option 
> (disabled by default) that does a short 1-second suspend-to-RAM sequence 
> upon bootup? That way we could test s2ram automatically (which is a MUCH 
> needed feature for automated regression testing and automatic 
> bisection). In addition, some sort of 'suspend for N seconds' /sys or 
> /dev/rtc capability would be nice as well.

Hmm, are you sure it is good idea to do this from kernel? I guess this
is better done from script... 

> btw., how far are you from having a working prototype?

SCSI/SATA issues stop me just now, but even if I get that to work, it
will be extremely disgusting hack... and it is unclear how to do it
nicely :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
