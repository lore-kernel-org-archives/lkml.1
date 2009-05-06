Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbZEFUad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbZEFUad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZEFUaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:30:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35774 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZEFUaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:30:22 -0400
Date: Wed, 6 May 2009 22:30:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Bank screen after resume on Dell XPS M1330
Message-ID: <20090506203018.GA28070@elf.ucw.cz>
References: <200905031111.50789.arvidjaar@mail.ru> <200905061955.13161.arvidjaar@mail.ru> <20090506165226.GA9072@elf.ucw.cz> <200905062130.26099.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905062130.26099.arvidjaar@mail.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-05-06 21:30:23, Andrey Borzenkov wrote:
> On Wednesday 06 of May 2009 20:52:26 Pavel Machek wrote:
> > On Wed 2009-05-06 19:55:10, Andrey Borzenkov wrote:
> > > On Tuesday 05 of May 2009 23:49:02 Pavel Machek wrote:
> > > > On Mon 2009-05-04 06:27:35, Andrey Borzenkov wrote:
> > > > > On Sunday 03 of May 2009 15:56:03 Matthew Garrett wrote:
> > > > > > On Sun, May 03, 2009 at 03:43:28PM +0400, Andrey Borzenkov 
> wrote:
> > > > > > > On Sunday 03 of May 2009 14:59:32 Matthew Garrett wrote:
> > > > > > > > On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey
> > > > > > > > Borzenkov
> > >
> > > wrote:
> > > > > > > > > 01:00.0 VGA compatible controller: nVidia Corporation
> > > > > > > > > GeForce 8400M GS (rev a1)
> > > > > > > >
> > > > > > > > We don't know how to reinitialise nvidia graphics
> > > > > > > > hardware.
> > > > > > >
> > > > > > > Just in case - same issue also after resume from
> > > > > > > hibernation. I was under impression, that hibernation does
> > > > > > > not have these issues as card goes via normal POST routine.
> > > > > >
> > > > > > Hm. That sounds a bit weirder.
> > > > >
> > > > > Is it worth further debugging? Anything I can provide?
> > > >
> > > > Try it with minimum config, init=/bin/bash? Switch to plain vga
> > > > console?
> > >
> > > As stated in my first mail, that is exactly what I started with :)
> >
> > Ok, ok, and even that failed with hibernation?
> 
> You are right, I was not careful when testing. I tested once more with 
> two different kernels; hibernation works (also in normal init 3) as long 
> as video settings are the same between suspend and resume. If they 
> differ (e.g. plain VGA before suspend and frame buffer after) display is 
> most likely completely garbled (but still is not blank).
> 
> Of course, any attempt to switch to X (using nv driver) after resume is 
> doomed. OTOH *starting* X after resume seems to work. 

Ok, that's what I'd expect. Hibernation _should_ work on any hardware.

Now, nv driver probably has a problem that needs to be fixed... You
should be able to use framebuffer X driver and have hibernation
totally working for you...

And no, different video modes between hibernation and resume are bad
idea.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
