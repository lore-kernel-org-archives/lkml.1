Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYASVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYASVps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYASVpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:45:41 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53466 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYASVpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:45:41 -0500
Date: Sat, 19 Jan 2008 22:45:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: Help needed to fix section mismatch warnings
Message-ID: <20080119214549.GH29070@uranus.ravnborg.org>
References: <20080106140728.GA3504@uranus.ravnborg.org> <20080119115255.d114065f.randy.dunlap@oracle.com> <20080119212242.GC29070@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119212242.GC29070@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > 
> > > WARNING: vmlinux.o(.text+0x43524): Section mismatch: reference to .init.text: (between 'timer_cpu_notify' and 'msleep')
> > > WARNING: vmlinux.o(.text+0x4c6f6): Section mismatch: reference to .init.text: (between 'rcu_cpu_notify' and 'wakeme_after_rcu')
> > > WARNING: vmlinux.o(.text+0x51cbe): Section mismatch: reference to .init.text: (between 'hrtimer_cpu_notify' and 'down_read_trylock')
> > 
> > I'll post patches for the 3 above.  However, the rcu code in -mm
> > is quite different, so the rcu patch may have a short life.
> 
> Hi Randy.
> 
> Thanks for your efforts!

And I just reviewd the three patches. All oops triggers under special conditions.
It is stuff like this that makes me wonder why some people still say that the
Section mismatch warnings are not worth fixing?!?!?

	Sam
