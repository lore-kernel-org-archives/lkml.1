Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbXGIKC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbXGIKC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXGIKCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:02:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45911 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755379AbXGIKCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:02:13 -0400
Date: Mon, 9 Jul 2007 12:02:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070709100204.GN5401@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org> <1183929611.3388.303.camel@localhost.localdomain> <200707090847.43378.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707090847.43378.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > But I'm not sure it's a good idea in the long run.  Think of a printer 
> > > daemon, for example.  It shouldn't have to experience unexpected I/O 
> > > problems merely because someone has decided to put the system to sleep.
> > 
> > Why not ? Printer is offline when machine is asleep... trying to print

...filesystems are offline, too, when the machine is asleep. Yet,
unmounting everything on suspend would not result in useful suspend
support.

Yes, I believe we should be transparent.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
