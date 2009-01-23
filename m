Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZAWPeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZAWPeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZAWPeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:34:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54010 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZAWPeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:34:09 -0500
Date: Fri, 23 Jan 2009 16:34:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: Daniel Troeder <daniel@admin-box.com>
Cc: deller@gmx.de, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: LED (leds_hp_disk) causes BUG: scheduling while atomic
Message-ID: <20090123153400.GC23668@elf.ucw.cz>
References: <1231156352.9735.6.camel@maya.local> <20090106101415.GA13972@elf.ucw.cz> <1231401855.8422.15.camel@maya.local> <20090108114956.GB12120@elf.ucw.cz> <1232719747.18163.96.camel@maya.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232719747.18163.96.camel@maya.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-23 15:09:07, Daniel Troeder wrote:
> Am Donnerstag, den 08.01.2009, 12:49 +0100 schrieb Pavel Machek:
> > On Thu 2009-01-08 09:04:15, Daniel Troeder wrote:
> > > Am Dienstag, den 06.01.2009, 11:14 +0100 schrieb Pavel Machek:
> > > > > I have a HP Compaq nc2400 notebook, and having recently installed 2.6.28
> > > > > (gentoo patchset, self configured), I have observed the following:
> > > > > 
> > > > > When {I manually, udev automatically} load the leds_hp_disk module, my
> > > > > disk-led flashes regularly _without_ disk activity. When I look at my
> > > > > dmesg I see the following:
> > > > 
> > > > Yes, that's a (mis-feature).
> > 
> > What did does it flash, btw? It is red on hp2133 (while disk light is
> > normally white).
> It flashes orange, while normal HDD-activity-color is green.

Thanks.

> (BTW: Problem persists in 2.6.28.1.)

Should be fixed in 2.6.29-rc2.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
