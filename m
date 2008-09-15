Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYIOJSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYIOJSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 05:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYIOJSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 05:18:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41170 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYIOJSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 05:18:01 -0400
Date: Mon, 15 Sep 2008 11:19:25 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Message-ID: <20080915091925.GB1787@elf.ucw.cz>
References: <20080912083113.GA1625@elf.ucw.cz> <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz> <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de> <20080914181228.GA18934@elf.ucw.cz> <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-09-14 12:15:04, Thomas Gleixner wrote:
> On Sun, 14 Sep 2008, Pavel Machek wrote:
> > On Sun 2008-09-14 10:51:04, Thomas Gleixner wrote:
> > > On Sun, 14 Sep 2008, Pavel Machek wrote:
> > > > > It _does_ happen with mainline 2.6.27-rc6.
> > > > 
> > > > s2ram hs problem in mainline 2.6.26, too. (Different problem: no
> > > > ammount pressing shift helps there.) nohz=off cures it, too.
> > > 
> > > Ok, so it's not a regression.
> > > 
> > > Is the problem in the suspend path or in the resume ?
> > 
> > During resume, on both 2.6.26 and 2.6.27-rc6. (27-rc6 actually resumes
> > if I keep hitting shift, and I get "sleepy" system after that --
> > cursor does not blink, but machine can be used -- as long as I keep
> > hitting keys).
> 
> Hmm. Can you please provide the output of /proc/timer_list when the
> system is in that "sleepy" state.

-rc5 seems to work ok... is there some patch I should try to revert
first?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
