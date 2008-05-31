Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYFAOSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYFAOSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYFAORD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:17:03 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4391 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752146AbYFAOQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:16:55 -0400
Date: Sat, 31 May 2008 09:20:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: Tobias Diedrich <ranma+kernel@tdiedrich.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Message-ID: <20080531072036.GC5405@ucw.cz>
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080525181329.GA5044@yamamaya.is-a-geek.org> <20080527062153.GA3651@yamamaya.is-a-geek.org> <200805271432.12881.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805271432.12881.david-b@pacbell.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The platform_enable_wakeup() hook is still there, but unused.
> 
> The patches to support it (still) haven't been merged.
> 
> 
> > AFAICS this patch should solve the "'ethtool -s eth0 wol g' doesn't
> > suffice, I also have to write magic values into /proc/acpi/wakeup"
> > issue.
> 
> Yeah; under ACPI, PCI does not act like it does everywhere else.
> Nor does wakeup in general.
> 
> After sending patches to fix that for a couple years now, I'm
> well past being tired of doing that.  I suggest it's overdue for
> the ACPI team to get this part of their act together.

I'm afraid you expect too much from the acpi team. If you can't merge
patches yourself, perhaps someone interested (Tobias? me?) can push
them for you?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
