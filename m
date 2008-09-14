Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYINKHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYINKHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 06:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYINKHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 06:07:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59412 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbYINKHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 06:07:45 -0400
Date: Sun, 14 Sep 2008 12:09:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Message-ID: <20080914100913.GB7909@elf.ucw.cz>
References: <20080912083113.GA1625@elf.ucw.cz> <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-09-14 04:56:48, Thomas Gleixner wrote:
> Pavel,
> 
> On Fri, 12 Sep 2008, Pavel Machek wrote:
> > The old "you have to press keys to get machine to progress" seems to
> > be back :-(. Thinkpad x60.
> 
> Is there a chance that we get some more information than that ?

Yep.

It does not happen after _every_ s2ram, but when it happens the system
limps around in half-dead state with non-blinking cursor etc. Next
s2ram will not fix it.

nohz=off helps.

Will try 2.6.27-rc6 w/o any custom patches next (not that I have
anything interesting in that area), and then probably 2.6.26.

(I had nohz turned off before 2.6.27-rc6...)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
