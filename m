Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbYESWjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbYESWjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbYESWit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:38:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49012 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764507AbYESWis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:38:48 -0400
Date: Tue, 20 May 2008 00:39:33 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Message-ID: <20080519223933.GA2315@elf.ucw.cz>
References: <200804281239.51729.david-b@pacbell.net> <20080428134649.44cf239c.akpm@linux-foundation.org> <20080502203637.GG3956@ucw.cz> <200805171514.07619.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805171514.07619.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-05-17 15:14:06, David Brownell wrote:
> On Friday 02 May 2008, Pavel Machek wrote:
> > 
> > > >   echo "export 23" > /sys/class/gpio/control
> > > >     ... will gpio_request(23, "sysfs") and gpio_export(23); use
> > > >     /sys/class/gpio/gpio-23/direction to configure it.
> > > >   echo "unexport 23" > /sys/class/gpio/control
> > > >     ... will gpio_free(23)
> > > 
> > > hm, does ths sysfs one-value-per-file rule apply to writes?
> > 
> > Having seen ibm acpi interface... yes, that rule should be aplied for
> > writes, too.
> 
> The latest version of this patch, which I'll post soonish,
> follows the suggestion to have one file for the "export"
> operation and another for "unexport".
> 
> 
> > What about mkdir gpio-N to export it?
> 
> Ugh.  That would create way more complication than I want
> to see here.  I thought about that early on, and decided
> that was Not The Way To Go.

...but it would be consistent with configfs... and face it... doing
echo > file to make a directory is seriously ugly.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
