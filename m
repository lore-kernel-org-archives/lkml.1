Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbZFOQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbZFOQ16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZFOQ1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:27:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49003 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZFOQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:27:50 -0400
Date: Mon, 15 Jun 2009 18:27:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>, Nicolas Pitre <nico@cam.org>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090615162746.GA25040@elf.ucw.cz>
References: <alpine.LFD.2.00.0906111314510.31536@xanadu.home> <4A3175AC.9070100@bluewatersys.com> <alpine.LFD.2.00.0906112105220.31536@xanadu.home> <4A31AECA.6070303@bluewatersys.com> <alpine.LFD.2.00.0906112138090.31536@xanadu.home> <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com> <20090612103521.GD18682@elf.ucw.cz> <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com> <a55d774e0906130005v5a35aa60ybabde470ff44cf77@mail.gmail.com> <20090615162150.GC6842@huya.quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615162150.GC6842@huya.quicinc.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I suspect it wouldn't be hard to just get something like a full
> > arm-debian distribution booting, but that's not something I've ever
> > tried.
> 
> We built a userspace around ptxdist.  We're still in the process
> of releasing it, but part of it is at
> <https://www.codeaurora.org/gitweb/quic/le/>
> 
> The Android busybox
> <http://benno.id.au/blog/2007/11/14/android-busybox> mostly
> works.  The poster doesn't seem to provide source, even though
> busybox requires modification to build for Android (although not
> much).

Thanks, I'll take a look.

With right .config file and google's msm tree, running debian is
fairly easy.

> The tricky part about something like arm-debian is storage.  You
> might be able to stick an ext2 on an microSD card, but obviously
> that's only going to work once the SD driver is functioning.  The
> phone targets don't generally have ethernet ports on them.

ext2 on microSD is the key, :-), yes. It boots into multiuser after
some complains when it tries to access internal NAND (udev?!). The
only problem is lack of reasonable keymap. No arrows, no escape, no
ctrl, no alt, no special symbols... That makes using command line very
tricky.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
