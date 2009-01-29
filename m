Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbZA2WHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbZA2WHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZA2WGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:06:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49668 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZA2WGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:06:45 -0500
Date: Thu, 29 Jan 2009 23:06:33 +0100
From: Pavel Machek <pavel@suse.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha Yrj?????? <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090129220633.GA18603@elf.ucw.cz>
References: <2f11576a0901160518g52a3e70endc98fe4792a98b9b@mail.gmail.com> <d6200be20901212213x1069762cpd377d04bc5a04a91@mail.gmail.com> <20090128234209.A949.KOSAKI.MOTOHIRO@jp.fujitsu.com> <d6200be20901281851k45f9692em1379140c8951c195@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20901281851k45f9692em1379140c8951c195@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I never expected it to be merged. I wrote it to allow us to ship a product.
> 
> > The top problem is, this file stay on non proper place.
> > then, MM folks don't review at all.
> >
> > I think this patch need to receive MM folks review.
> 
> This patch solves two problems for us:
> 1. It gives us more control over which process gets killed when we run
> out of memory. This can easily be fixed in the regular oom killer
> instead.
> 2. It prevents the system from getting unusable due to excessive
> demand paging. Before we added the low memory killer, we had devices
> stuck for many minutes before the system managed to allocate enough
> memory for the oom killer to kick in.
> The second problem is the most critical and if it is solved, we will
> not need this patch.

Ok, maybe the best way forward is to create a "demo" that can be run
on desktop machine, where machine misbehaves (like becomes useless for
10 minutes before OOM killer kicks in), then draw attetion of
Andrew/Nick/etc?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
