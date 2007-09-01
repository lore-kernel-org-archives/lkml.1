Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbXIARXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbXIARXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 13:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbXIARXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 13:23:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3919 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753993AbXIARXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 13:23:16 -0400
Date: Sat, 1 Sep 2007 17:23:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070901172301.GA4275@ucw.cz>
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr> <20070821204951.GC3658@interface.famille.thibault.fr> <20070712191932.GA3947@ucw.cz> <20070901122604.GA3251@implementation.famille.thibault.fr> <20070901123258.GA4612@ucw.cz> <20070901125120.GC3251@implementation.famille.thibault.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901125120.GC3251@implementation.famille.thibault.fr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Because userland only begins quite late in the boot process, and
> > > userland may hang.
> > 
> > Initrd means userland is started very early on most machines these
> > days, and kernel may hang, too.
> 
> Very early is not so early, and loading initrd itself may actually fail.
> The kernel may indeed hang, but there are more chances to get some
> messages before the hang.  Don't _you_ have a VGA screen for getting
> earliest failure messages from the kernel?

No. I'm using framebuffer, that's initialized quite late in boot
process. Plus many users just use bootsplash. I do use vga mode for
heavy debugging, but that's quite unusual.

So... you actually have speech-enabled grub/lilo/something?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
