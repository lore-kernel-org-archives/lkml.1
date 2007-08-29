Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbXH2Ek7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbXH2Ek7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXH2Ekw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:40:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:40982 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750781AbXH2Ekw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:40:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/cIK8OWUzcoIjHEahajhnXWdToA4kWnAbm8dtcTn
	eZxn5MKA7PQvxt
Subject: Re: CFS review
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Boldi <a1426z@gawab.com>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Keith Packard <keith.packard@intel.com>
In-Reply-To: <20070829041827.GA8733@elte.hu>
References: <200708111344.42934.a1426z@gawab.com>
	 <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu>
	 <200708280737.53439.a1426z@gawab.com>  <20070829041827.GA8733@elte.hu>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 06:40:47 +0200
Message-Id: <1188362447.3787.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 06:18 +0200, Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> 
> > No need for framebuffer.  All you need is X using the X.org 
> > vesa-driver.  Then start gears like this:
> > 
> >   # gears & gears & gears &
> > 
> > Then lay them out side by side to see the periodic stallings for 
> > ~10sec.
> 
> i just tried something similar (by adding Option "NoDRI" to xorg.conf) 
> and i'm wondering how it can be smooth on vesa-driver at all. I tested 
> it on a Core2Duo box and software rendering manages to do about 3 frames 
> per second. (although glxgears itself thinks it does ~600 fps) If i 
> start 3 glxgears then they do ~1 frame per second each. This is on 
> Fedora 7 with xorg-x11-server-Xorg-1.3.0.0-9.fc7 and 
> xorg-x11-drv-i810-2.0.0-4.fc7.

At least you can run the darn test... the third instance of glxgears
here means say bye bye to GUI instantly.

	-Mike

