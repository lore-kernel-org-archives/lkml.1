Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZCAWy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZCAWy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 17:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbZCAWyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 17:54:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45931 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbZCAWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 17:54:17 -0500
Date: Sun, 1 Mar 2009 23:56:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090301225647.GE1961@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org> <200902180022.00239.rjw@sisk.pl> <d6200be20902172046sf00599ckc6710c6132d6b92f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20902172046sf00599ckc6710c6132d6b92f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Phase 3: Probably explicit control left to open/close.
> >>
> >> While that's generally a good idea, it's important to recognize that
> >> some devices should be runtime-suspended even while they are open.
> >
> > From the kernel side, yes (and that should be transparent to the user space
> > having them open).  By the user space, no.
> 
> Allowing user space to suspend input devices while they are still open
> is useful. The user-space code that reads from the input devices does
> not need to know if the device is suspended or not, and the kernel
> cannot auto suspend input devices based on inactivity.

Actually, I'd like you to fix your userspace and close input devices
when it does not need them. Given the way you control the platform it
should not be that hard. I do not see why we'd want to invent new
interface for "uhuh, I have opened the keyboard but I am not really
interested in keys being pressed".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
