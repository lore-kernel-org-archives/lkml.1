Return-Path: <linux-kernel-owner+w=401wt.eu-S964839AbXCFKt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839AbXCFKt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964840AbXCFKt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:49:26 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:36059 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839AbXCFKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:49:25 -0500
Date: Tue, 6 Mar 2007 12:46:18 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Soeren Sonnenburg <kernel@nn7.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070306104618.GA5792@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain> <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> <1173142948.24738.257.camel@localhost.localdomain> <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306103712.GA10942@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: [5/6] 2.6.21-rc2: known regressions
> 
> 
> * Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> > > Quoting Linus Torvalds <torvalds@linux-foundation.org>:
> > >
> > > Ok, it does indeed solve the problem for me.
> > 
> > Not yet for me unfortunately, although this seems to help.
> > Is this the patch I should have applied?
> > http://lkml.org/lkml/2007/3/5/445
> > 
> > With this applied, on resume I get *some* screen output soon after 
> > resume (e.g. with s2ram I get several characters on VGA, X starts 
> > drawing some windows) but then the crescent symbol starts blinking 
> > again and the system hangs.
> 
> could you try this via s2ram on a text console, to see whether the 
> kernel spits out any warning before it locks up?

Yes, that's what I did. Unfortunately only a couple of characters were
shown before it locked up.

I still need to check what does this do in the NO_HZ configuration.

BTW, Ingo, can you suspend/resume any number of times with this patch?

-- 
MST
