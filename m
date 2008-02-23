Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYBWWGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYBWWGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 17:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYBWWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 17:06:36 -0500
Received: from www.tglx.de ([62.245.132.106]:33161 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbYBWWGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 17:06:35 -0500
Date: Sat, 23 Feb 2008 23:05:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       zippel@linux-m68k.org, schwab@suse.de, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values
 to do_div() [try #3]
In-Reply-To: <20080223130743.02caa1ab.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802232302110.7583@apollo.tec.linutronix.de>
References: <20080221165035.16571.67531.stgit@warthog.procyon.org.uk> <20080223000455.a0f543e1.akpm@linux-foundation.org> <alpine.LFD.1.00.0802232200300.7583@apollo.tec.linutronix.de> <20080223130743.02caa1ab.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008, Andrew Morton wrote:
> > > Thomas, do you consider ntp to fall under git-hrt?
> > 
> > I'll pick it up.
> > 
> OK.  And this is still
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git#mm,
> yes?

Yes
 
> Can we please define the scope of that tree?

Primary scope is hrtimer, posixtimer, clockevents & Co.

In the last month I fed a lot of timekeeping/ntp stuff via -hrt as
well. If there is no objection, I'm happy to provide the sink for
those.

> Please review
> 
> fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
> timers-simplify-lockdep-stuff.patch
> hrtimers-simplify-lockdep-stuff.patch
> kill-double_spin_lock.patch
> ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch
> 
> from http://userweb.kernel.org/~akpm/mmotm/broken-out/.  I think they're
> all probably git-hrt material.

Will do tomorrow, when I'm more awake.

> Can we get that tree into linux-next too please?

Will contact Stephen.

Thanks,

	tglx

