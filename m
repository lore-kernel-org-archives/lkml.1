Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYCJLIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYCJLIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYCJLH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:07:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47606 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYCJLHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:07:55 -0400
Date: Mon, 10 Mar 2008 11:16:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.25-rc4: crash on boot when SMP enabled
Message-ID: <20080310101654.GD9520@elf.ucw.cz>
References: <20080306102927.GA4434@elf.ucw.cz> <20080306131547.GE21359@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306131547.GE21359@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Quad-Core AMD Opteron...
> > Checking TSC Synchronization [CPU#0 -> CPU#3]: passed
> > BUG: unable to handle kernel paging request at 00...005958
> > IP: __alloc_pages+0x38
> > ...
> > Call trace:
> > kmem_getpages
> > cache_grow
> > ____cache_alloc_node
> > cpuup_callback
> > kmem_cache_alloc_node
> > cpuup_callback
> > notifier_call_chain
> > _cpu_up
> 
> could you try latest x86.git:
> 
>     http://people.redhat.com/mingo/x86.git/README
> 
> does it fix it? Could be one of the numa fixes that are queued up.

I did an update to 2.6.25-rc4, and problem is now gone. Seems like
something really fixed it ;-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
