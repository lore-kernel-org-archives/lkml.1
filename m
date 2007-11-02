Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbXKBNy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbXKBNy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXKBNyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:54:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53247 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbXKBNyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:54:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Subject: Re: [2.6.23] IBM X41 looses time after Suspend2Disk
Date: Fri, 2 Nov 2007 15:11:32 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071029201955.GA1955@titan.lahn.de> <20071030210801.GA1767@elf.ucw.cz> <20071102133323.GC2780@titan.lahn.de>
In-Reply-To: <20071102133323.GC2780@titan.lahn.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711021511.32834.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 2 November 2007 14:33, Philipp Matthias Hahn wrote:
> Hello!
> 
> On Tue, Oct 30, 2007 at 10:08:01PM +0100, Pavel Machek wrote:
> > > > On Monday, 29 October 2007 21:19, Philipp Matthias Hahn wrote:
> > > > > I have an IBM X41 tablet pc running 2.6.23 with the following problem:
> > > > > Suspend2Ram work fine, but when I do a Suspend2Disk (echo disk >
> > > > > /sys/power/state), the notebook hangs showing the following lines:
> > > ...
> > > > >         Suspending console(s)
> > > > > 
> > > > > When I repeatedly press some keys or move the TrackPoint, the SwSusp
> > > > > continues and the notebook powers off.
> > > > > On reboot, the notebook resumes but hangs showing the following screen:
> > > ...
> > > > >         Suspending console(s)
> > > > > 
> > > > > Generating interrupts by pressing keys or moving the TrackPoints makes
> > > > > the resume continue. But after that, the notebook looses time, xterms
> > > > > don't get updated until I press a key, the beeper beeps until I press a
> > > > > key, etc.
> ...
> > > On Mon, Oct 29, 2007 at 10:24:14PM +0100, Pavel Machek wrote:
> > > > Yep, I seen that before. Try "nohz=off".
> > > 
> > > Okay, that seems to solve the "timer loosing time after resume" problem.
> > > 
> > > 
> > > But I still need to press some keys on suspend (7-12 key presses and
> > > releases) to unhang it. On resume not key presses are needed any
> > > more.
> > 
> > So it fixed resume but not suspend? strange. Try highres=off, too. And
> > maybe irqpoll?
> 
> highres=off did the trick. Thank you.
> 
> Does somebody want more data to debug this further?

Please create a bugzilla entry at http://bugzilla.kernel.org for this bug
(against "Power Management"->"Hibernation/Suspend") and put a summary of your
findings in there.  Also, please add my address to the bug's CC list.

Thanks,
Rafael
