Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbXIPNZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbXIPNZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 09:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXIPNZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 09:25:30 -0400
Received: from www.osadl.org ([213.239.205.134]:32864 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213AbXIPNZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 09:25:29 -0400
Subject: Re: [1/3] 2.6.23-rc6: known regressions v2 --- ieee1394, empty
	suspend stopped working
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>
In-Reply-To: <20070916024159.c067dc1a.akpm@linux-foundation.org>
References: <46EB436E.6030509@googlemail.com>
	 <46ECF8C8.5040308@s5r6.in-berlin.de>
	 <20070916024159.c067dc1a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 16 Sep 2007 15:25:24 +0200
Message-Id: <1189949124.4319.13.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-16 at 02:41 -0700, Andrew Morton wrote:
> > I did a quick test on my main test machine, a Mac mini running x86-64
> > Linux.  Regardless whether swap is on or off and whether ieee1394 and
> > ohci1394 are loaded or not, it always behaves the same.  It does
> > something, then ends up with power LED off but a non-blinking cursor,
> > i.e. _, still shown on the text console.  Is this good or bad?  Note, I
> > didn't try to resume and won't, because I'm out of spare time.
> 
> When it is in this state, try hitting a key lots of times.  It Works For Me ;)
> 
> Try Thomas's hrt tree, below.  It Also Works For Me.

Will not help much. He is running x86-64 which is not affected by
clockevents & Co. (yet).

	tglx


