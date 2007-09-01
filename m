Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbXIAMdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbXIAMdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 08:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXIAMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 08:33:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3093 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750931AbXIAMdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 08:33:12 -0400
Date: Sat, 1 Sep 2007 12:32:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dtor@mail.ru
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070901123258.GA4612@ucw.cz>
References: <20070821005718.GD3658@interface.famille.thibault.fr> <Pine.LNX.4.64.0708210732270.5333@fbirervta.pbzchgretzou.qr> <20070821204951.GC3658@interface.famille.thibault.fr> <20070712191932.GA3947@ucw.cz> <20070901122604.GA3251@implementation.famille.thibault.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070901122604.GA3251@implementation.famille.thibault.fr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > They can use the raw xlation for that.
> > > 
> > > For userland, yes.  This is for kernel modules.
> > 
> > And should speakup be a kernel module? Why?
> 
> Because userland only begins quite late in the boot process, and
> userland may hang.

Initrd means userland is started very early on most machines these
days, and kernel may hang, too.

> > What is missing? Yes, you may want to do a small kernel module to read
> > kernel bootup messages.
> 
> That's what it's all about.

But this small module should not need keyboard leds support, as those are not used during
boot. If all you want is to read kernel bootup messages, you should
just register a special console. Actually serial console should do.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
