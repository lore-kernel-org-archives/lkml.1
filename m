Return-Path: <linux-kernel-owner+w=401wt.eu-S934873AbXGYSkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934873AbXGYSkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763908AbXGYSkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:40:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2052 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763843AbXGYSkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:40:18 -0400
Date: Wed, 25 Jul 2007 18:40:06 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Lindsay Roberts <lindsay.roberts.os@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, celinux-dev@tree.celinuxforum.org
Subject: Re: [PATCH] fs: Add romfs version 2
Message-ID: <20070725184005.GD8225@ucw.cz>
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com> <20070717013635.d6d0b124.akpm@linux-foundation.org> <20070717192100.GE11166@waste.org> <8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734b7880707172016v530ce775p108910f7baf9de8e@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> >   block aligned regular file data to bring 
> >performance
> >> >   parity with ext2/3. This is about 225% of the read
> >> >   speed of the existing romfs.
> >
> >Doesn't that make these filesystems much bigger? By, on 
> >average, .5k
> >per file? Or, if I'm understanding things correctly, 
> >~1k?
> 
> Yes, my experience has been that it has been almost 
> chillingly close
> to .5k per regular file increase in partition size. I 
> know in
> applications in which size is utterly critical this may 
> be slightly
> unattractive, but in cases where romfs is chosen for its 
> byte
> reproducibility and read-only nature the 
> size/performance tradeoff is
> fairly advantageous.

If the fs is read-only.. can we do some tail packing and get _both_
speed and space efficiency?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
