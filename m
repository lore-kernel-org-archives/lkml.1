Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbXKUMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbXKUMqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 07:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbXKUMq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 07:46:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2110 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754067AbXKUMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 07:46:24 -0500
Date: Wed, 21 Nov 2007 12:45:03 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Message-ID: <20071121124503.GB5474@ucw.cz>
References: <200711052201.17150.arvidjaar@mail.ru> <200711112010.24874.rjw@sisk.pl> <200711170001.46710.arvidjaar@mail.ru> <200711162233.52910.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711162233.52910.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > It works. Subjectively I have relatively long pause after first Suspending console
> > > > message (where it hangs otherwise), according to dmesg timestamp it is about
> > > > 1 second before next messages appear. Also last two times I tried it writeout
> > > > of suspend image was really slow; it was both with and without battery. Reading
> > > > on resume in really in order of magnitude faster.
> > > > 
> > > > But manual STD so far works both on AC (with or without battery) or on battery.
> > > > 
> > > > Of course it is possible that battery gets exhausted during STD, but system
> > > > is not switched off. Rather I would suspect something like ACPI notification
> > > > that comes during freeze ...
> > > 
> > > Frankly, I'm suspecting a deadlock in the ACPI code.
> > > 
> > > Please try to make kpowersave start hibernation a bit earlier and see what
> > > happens.
> > > 
> > > What's your critical time now?
> > > 
> > > 
> > 
> > it was set to 5%. Setting it to 10% makes it work, but it just confirms what I
> > said before - suspend-to-RAM in normal battery conditions (or without battery)
> > works.
> 
> Yes.

I have something similar in suse bugzilla, but there the claim is 'it
always works if I trigger it manually'.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
