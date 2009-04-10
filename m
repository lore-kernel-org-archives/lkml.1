Return-Path: <linux-kernel-owner+w=401wt.eu-S1765943AbZDJQ00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765943AbZDJQ00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbZDJQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:26:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41808 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977AbZDJQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:26:14 -0400
Date: Fri, 10 Apr 2009 18:29:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: Re: 2.6.30-rc1: touchscreen BUG() on spitz
Message-ID: <20090410162915.GA27805@elf.ucw.cz>
References: <20090410103429.GA31367@elf.ucw.cz> <f17812d70904100350l19fa7493ma9c4695d49d19398@mail.gmail.com> <1239360967.14324.2.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239360967.14324.2.camel@brutus>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > After update to 2.6.30-rc1, sharp zaurus c-3000 fails to boot with
> > > white screen (with stripes). That's a regression w.r.t. 2.6.29.
> > 
> > What kind of white stripes? Does it look like the LCD controller
> > stops working or something.
> > 
> > There is a regression which caused X server hang during bootup,
> > with commit id 66c1ca0, which you can revert and have another
> > try.
> 
> As spitz also use cs_control for pxa2xx_spi, i believe that this is the
> same issue i found wednesday.
> 
> See the "Kernel freeze caused by
> a7bb3909b3293d503211d7f6af8ed62c1644b686" thread.

Ok, I'll try changing ASSERT->DEASSERT and see what happens. Hmm, it
now boots, with these messages:

WARNING: at kernel/irq/handle.c:366
BUG: IRQ handler called from non-hardirq context!

just after loading touchscreen device.

Thanks!

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
