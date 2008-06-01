Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYFAQWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYFAQWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYFAQWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:22:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2774 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751106AbYFAQWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:22:05 -0400
Date: Sun, 1 Jun 2008 18:21:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
       tytso@mit.edu, benh@kernel.crashing.org,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, seife@suse.de
Subject: s2ram video problems Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080601162150.GC5555@ucw.cz>
References: <20080529124548.GC8065@mit.edu> <20080529.135431.235149338.davem@davemloft.net> <20080529211404.GH8065@mit.edu> <20080529.143921.34376298.davem@davemloft.net> <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de> <1212330249.3373.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212330249.3373.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Fix NOHZ/CPUIDLE along with suspend/resume on all participants
> > laptops, which are probably 50+ different models. That'd be an odd
> > enough mix of wreckaged hardware / BIOS / ACPI.
> > 
> > Should be fun and solve a bunch of hard to grok bugs in the bugzillas
> > along the way.
> 
> Well ... in theory.
> 
> In practice, for instance, my laptop had suspend/resume working shortly
> after I got it, and the widescreen video too.  Most of the problems were
> video related, so I did interact with the upstream intel video driver
> people, but by and large it was a set of black magic rules to restore
> the video to its prior state (in my case, even the vbe tools didn't work
> and I had to manually save and restore the pci config space).

that's s2ram -v, right? Can you submit a whitelist entry so it starts
working for other people, too?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
