Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbXE3Tuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbXE3Tuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXE3Tu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:50:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2402 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbXE3Tu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:50:29 -0400
Date: Wed, 30 May 2007 19:50:16 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Rob Landley <rob@landley.net>
Cc: Michael-Luke Jones <mlj28@cam.ac.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070530195016.GA5198@ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200705280943.54312.rjw@sisk.pl> <9D3FC259-8391-4C2F-9F0F-AEF6CB3030E8@cam.ac.uk> <200705291851.41027.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705291851.41027.rob@landley.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> Userspace should handle the async request just fine when it comes  
> > >> back
> > >> running, regardless of the time it was submitted.
> > >
> > > Okay, so the solution is to convert the drivers to use
> > > request_firmware_nowait() instead of request_firmware() in  
> > > their .resume()
> > > routines.
> > 
> > [added Rob Landley to CC]
> > 
> > I think asynchronous loading should be made the default behaviour.  
> > However, we need to think and document how to do firmware loading.
> 
> I'd love to write up documentation on this if anybody can tell me what it 
> should say. :)

Well, chapter on firmware & suspend/hibernation should say something
about either loading the firmware during early suspend, or just
keeping firmware in ram from boot...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
