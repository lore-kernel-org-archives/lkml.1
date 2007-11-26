Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXKZMQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXKZMQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 07:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXKZMQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 07:16:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1047 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754339AbXKZMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 07:16:23 -0500
Date: Mon, 26 Nov 2007 12:06:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
Message-ID: <20071126120649.GC4701@ucw.cz>
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com> <20071120220512.46b9e975@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120220512.46b9e975@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  kernel: [734344.717844] irq 21: nobody cared (try booting with the
> > "irqpoll" option)
> >  kernel: [734344.717866]
> 
> Your machine decided to emit interrupt 21 without an apparent reason.
> Whatever caused that made the kernel shut down IRQ 21 at which point the
> disk drives on that IRQ were no longer being serviced. Everything on IRQ
> 21 would have died - which may be why your networking failed too.

Hmm, perhaps that 'nobody cared' message should be worded more
strongly, and printed and KERN_CRIT?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
