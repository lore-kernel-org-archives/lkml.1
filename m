Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXIAS3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXIAS3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 14:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbXIAS33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 14:29:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2021 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbXIAS32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 14:29:28 -0400
Date: Sat, 1 Sep 2007 18:18:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070901181845.GA4839@ucw.cz>
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr> <20070821204951.GC3658@interface.famille.thibault.fr> <20070712191932.GA3947@ucw.cz> <20070901122604.GA3251@implementation.famille.thibault.fr> <20070901123258.GA4612@ucw.cz> <20070901125120.GC3251@implementation.famille.thibault.fr> <20070901172301.GA4275@ucw.cz> <20070901173329.GB12644@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901173329.GB12644@implementation>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Very early is not so early, and loading initrd itself may actually fail.
> > > The kernel may indeed hang, but there are more chances to get some
> > > messages before the hang.  Don't _you_ have a VGA screen for getting
> > > earliest failure messages from the kernel?
> > 
> > No. I'm using framebuffer, that's initialized quite late in boot
> > process. Plus many users just use bootsplash. I do use vga mode for
> > heavy debugging, but that's quite unusual.
> 
> But that's what some people do for their work, so they need it.

How many such users are out there?

> > So... you actually have speech-enabled grub/lilo/something?
> 
> That's in project too (and there's no reason it shouldn't be done).

I'd say kernel debugging is hard without accessible bootloader, so I'd
hope number of such users is very low.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
