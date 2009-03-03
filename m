Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZCCNz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZCCNz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZCCNzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:55:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40251 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZCCNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:55:15 -0500
Date: Tue, 3 Mar 2009 14:57:50 +0100
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
Message-ID: <20090303135750.GC5060@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902272155.42010.rjw@sisk.pl> <d6200be20902271456w77951afata1d5f378ddbe6b84@mail.gmail.com> <200902281118.14595.rjw@sisk.pl> <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> If you ignore wakelocks with timeouts, the current
> >> wakelock interface can be implemented with a global atomic_t to
> >> prevent suspend, and a per wakelock atomic_t to prevent a single
> >> client from changing the global reference count by more than one.
> >>
> >> There are a couple of reasons that I have not done this. It removes
> >> the ability to easily inspect the system when it is not suspending.
> >
> > Care to elaborate?
> 
> If you have a single atomic_t and it is not 0, you do not know who
> incremented it.

Which is okay for already debugged system. For debugging, yes some
support can be nice.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
