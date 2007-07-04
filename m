Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbXGDV5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbXGDV5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXGDV5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:57:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40517 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755636AbXGDV5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:57:08 -0400
Date: Wed, 4 Jul 2007 23:57:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Andi Kleen <ak@suse.de>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bwalle@suse.de
Subject: Re: blink driver power saving
Message-ID: <20070704215701.GA1896@elf.ucw.cz>
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021439.27357.ak@suse.de> <20070702230827.GA9071@elf.ucw.cz> <200707030142.36252.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707030142.36252.dtor@insightbb.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-07-03 01:42:35, Dmitry Torokhov wrote:
> On Monday 02 July 2007 19:08, Pavel Machek wrote:
> > On Mon 2007-07-02 14:39:27, Andi Kleen wrote:
> > > 
> > > > > Perhaps one of you geniuses who all hate it can find a better way to
> > > > > solve the "video output dead after kexec; but need visual feedback to the user
> > > > > while crash dumping" problem. I'm waiting for your patches.
> > > > >
> > > > 
> > > > I don't don't like it ;) Unfortunately too many people end up enabling
> > > 
> > > Yes that's pretty weird. I admit I hadn't expected
> > > that problem. blink is equivalent to "annoy me" and it
> > > is a mystery why so many people should willingly ask their computer to 
> > > annoy them.
> > 
> > tristate "Keyboard blink driver"
> > 
> > ...drivers are not expected to act on their own. I was expecting to
> > get nice /sys/class/led* interface to my keyboard leds.
> > 
> > BTW ... I still believe we should have /sys/class/led* interface to
> > those leds. I'd like to make them blink with hdd activity on some
> > machines... of course, that needs non-buggy KBC.
> 
> I'll take patches. Ofcourse we'll have to keep the current EV_LED interface
> for compatibility.

Update.. both your and mine code seem to do something here -- but they
only keep turning the led off. If I press numlock to turn it on, they
will turn it off. Strange.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
