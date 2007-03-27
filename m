Return-Path: <linux-kernel-owner+w=401wt.eu-S934246AbXC0W3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246AbXC0W3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934230AbXC0W3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:29:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50357 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934237AbXC0W3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:29:43 -0400
Date: Wed, 28 Mar 2007 00:29:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc5
Message-ID: <20070327222921.GA6752@elf.ucw.cz>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <6bffcb0e0703271134i328af6feu47a780d143ebe046@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703271134i328af6feu47a780d143ebe046@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >There's various fixes here, ranging from some architecture updates (ia64,
> >ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
> >
> 
> Suspend to disk doesn't work for me with this patch. It hangs after
> PM: Preparing devices for restore.
> Suspending console(s)
> during resuming.
> 
> a504e64ab42bcc27074ea37405d06833ed6e0820 is first bad commit
> commit a504e64ab42bcc27074ea37405d06833ed6e0820
> Author: Stephen Hemminger <shemminger@linux-foundation.org>
> Date:   Fri Feb 2 08:22:53 2007 -0800
> 
>    skge: WOL support
> 
>    Add WOL support for Yukon chipsets in skge device.
> 
>    Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
>    Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> :040000 040000 d3d4335e6cba330b7880b4787fbe48733e69f8fc
> 5845b004228d811de912a55da6a7843b72f23f81 M      drivers
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/git-config2

Do you use skge as your network device?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
