Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXHIWSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXHIWSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbXHIWSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:18:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50887 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753805AbXHIWSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:18:14 -0400
Date: Thu, 9 Aug 2007 12:11:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       kernel list <linux-kernel@vger.kernel.org>, ak@suse.de,
       Netdev list <netdev@vger.kernel.org>
Subject: Re: ATA over ethernet swapping
Message-ID: <20070809101105.GA7581@elf.ucw.cz>
References: <20070731135831.GA4604@elf.ucw.cz> <20070731150324.GE3206@coraid.com> <20070731152924.GM2087@elf.ucw.cz> <20070731162140.GI3206@coraid.com> <20070731222742.GR2087@elf.ucw.cz> <1185959909.12034.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185959909.12034.38.camel@twins>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've been working on this for quite some time. And should post again
> soon. Please see the patches:
> 
>   http://programming.kicks-ass.net/kernel-patches/vm_deadlock/current/
> 
> For now it requires one uses SLUB, I hope that SLAB will go away (will
> save me the trouble of adding support) and I guess I ought to do SLOB
> some time (if that does stay).
> 
> You'd need the first 22 patches of that series, and then call
> sk_set_memalloc(sk) on the proper socket, and do some fiddling with the
> reconnect logic. See nfs-swapfile.patch for examples.

What do you use for testing? I set up ata over ethernet... swapping
over that should deadlock w/o your patches.

But I'm able to compile kernel (-j 10) on 128MB machine, and I tried
cat /dev/zero | grep foo to exhaust memory... and could not reproduce
the deadlock. Should I pingflood? Tweak down ammount of atomic memory
avaialable to make deadlocks easier to reproduce?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
