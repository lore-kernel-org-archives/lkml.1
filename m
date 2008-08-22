Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYHVJ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYHVJ21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 05:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYHVJ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 05:28:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35447 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYHVJ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 05:28:15 -0400
Date: Fri, 22 Aug 2008 11:28:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Message-ID: <20080822092814.GD6542@atrey.karlin.mff.cuni.cz>
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com> <19f34abd0808211121l25e6b187p93db789607c2af30@mail.gmail.com> <84144f020808211427j7e046f1dya07ecca18787dfbd@mail.gmail.com> <200808220016.34494.rjw@sisk.pl> <19f34abd0808212145x6fbb481ex99829b22599439d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808212145x6fbb481ex99829b22599439d9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Ok, here we have the block layer passing a bad pointer to SLUB this
> >> time. And it's also from the suspend code (although it's the resume
> >> path this time). As we never see an oops from the block layer first,
> >> it's possible that someone else corrupted everything and it just shows
> >> up in the block layer. Maybe something worth investigating,
> >> though.

Do you use any unusual drivers? WHat kind of machine is that?

Can you try with minimal drivers?

Can you try with minimum config? Like smp disabled...? Does echo test > /sys/power/state 
work?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
