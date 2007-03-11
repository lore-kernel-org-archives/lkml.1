Return-Path: <linux-kernel-owner+w=401wt.eu-S965449AbXCLJqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbXCLJqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXCLJqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:46:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4067 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965449AbXCLJqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:46:17 -0400
Date: Sun, 11 Mar 2007 17:32:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Soeren Sonnenburg <kernel@nn7.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070311173238.GA4001@ucw.cz>
References: <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain> <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu> <20070306104618.GA5792@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306104618.GA5792@mellanox.co.il>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Quoting Linus Torvalds <torvalds@linux-foundation.org>:
> > > >
> > > > Ok, it does indeed solve the problem for me.
> > > 
> > > Not yet for me unfortunately, although this seems to help.
> > > Is this the patch I should have applied?
> > > http://lkml.org/lkml/2007/3/5/445
> > > 
> > > With this applied, on resume I get *some* screen output soon after 
> > > resume (e.g. with s2ram I get several characters on VGA, X starts 
> > > drawing some windows) but then the crescent symbol starts blinking 
> > > again and the system hangs.
> > 
> > could you try this via s2ram on a text console, to see whether the 
> > kernel spits out any warning before it locks up?
> 
> Yes, that's what I did. Unfortunately only a couple of characters were
> shown before it locked up.

Was it 'Linu'? That's different debugging hack.

Anyway, I suspect yout problem is debuggable with printk+mdelay...

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
