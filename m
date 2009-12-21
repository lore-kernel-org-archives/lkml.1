Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZLUJB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZLUJB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZLUJB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:01:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33950 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZLUJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:01:55 -0500
Date: Mon, 21 Dec 2009 10:01:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091221090147.GA1405@ucw.cz>
References: <200912060254.10081.rjw@sisk.pl> <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain> <20091206113555.5a646713@infradead.org> <alpine.LFD.2.00.0912061144100.3560@localhost.localdomain> <20091206121803.70385c33@infradead.org> <7AB497C7-8495-4535-9E83-81307E008BF4@gmail.com> <20091206165551.2529075f@infradead.org> <20091207022756.GB20770@core.coreip.homeip.net> <20091206212600.44806308@infradead.org> <20091207060053.GA21451@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207060053.GA21451@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-06 22:00:53, Dmitry Torokhov wrote:
> On Sun, Dec 06, 2009 at 09:26:00PM -0800, Arjan van de Ven wrote:
> > On Sun, 6 Dec 2009 18:27:56 -0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > On Sun, Dec 06, 2009 at 04:55:51PM -0800, Arjan van de Ven wrote:
> > > > On Sun, 6 Dec 2009 14:54:48 -0800
> > > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > 
> > > > > > isn't serio the PS/2 stuff?
> > > > > 
> > > > > Yes, that's your PS/2 mouse (rather touchpad) and the delay comes
> > > > > from device reset (needed by some keyboard controllers - I
> > > > > remember HP -or it and keyboard will be dead at resume).
> > > > 
> > > > and I have a HP laptop... so this makes perfect sense.
> > > > Thanks for the explenation!
> > > > 
> > > 
> > > Well, we do it for everyone, it's just a particular series of HPs
> > > forced us to add it.
> > > 
> > wonder if it should be a DMI based quirk instead...
> > 
> 
> I have not received reports where it causes harm or reduces
> functionality so I'd prefer having it by default and not try to race
> with manufacturers.

Well, it slows down everyone... and people are actually testing with
linux, so it makes this problem more common on new systems.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
