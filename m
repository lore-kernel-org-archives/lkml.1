Return-Path: <linux-kernel-owner+w=401wt.eu-S965341AbXAYNa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965341AbXAYNa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965343AbXAYNa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:30:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35034 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965341AbXAYNaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:30:25 -0500
Date: Thu, 25 Jan 2007 14:30:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
Message-ID: <20070125133004.GB23620@elf.ucw.cz>
References: <20070125113350.GA31068@elte.hu> <20070125130729.GA23620@elf.ucw.cz> <200701251429.25081.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701251429.25081.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-01-25 14:29:24, Rafael J. Wysocki wrote:
> On Thursday, 25 January 2007 14:07, Pavel Machek wrote:
> > Hi!
> > 
> > > Subject: [patch] suspend debugging: simulate suspend-to-RAM
> > > From: Ingo Molnar <mingo@elte.hu>
> > > 
> > > most resume bugs are due to the kernel hanging or crashing while trying 
> > > to resume a specific device. It is extremely hard to debug such hangs 
> > > because often when the hang happens there's no console available
> > > yet.
> > 
> > While the functionality is useful, no I do not think this should be
> > configured by sysctl or kernel parameter.
> > 
> > Perhaps right interface is "echo fake-mem > /sys/power/state"? 
> 
> Yes, the "test" and "testproc" debug modes are started via /sys/power/state,
> so let's make it consistent.

Ok, so this one should be "testmem".
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
