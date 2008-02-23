Return-Path: <linux-kernel-owner+w=401wt.eu-S1764771AbYBWVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764771AbYBWVJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762247AbYBWVJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:09:00 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757835AbYBWVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:08:59 -0500
Date: Sat, 23 Feb 2008 13:07:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       zippel@linux-m68k.org, schwab@suse.de, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values
 to do_div() [try #3]
Message-Id: <20080223130743.02caa1ab.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802232200300.7583@apollo.tec.linutronix.de>
References: <20080221165035.16571.67531.stgit@warthog.procyon.org.uk>
	<20080223000455.a0f543e1.akpm@linux-foundation.org>
	<alpine.LFD.1.00.0802232200300.7583@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 22:01:55 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 23 Feb 2008, Andrew Morton wrote:
> 
> > On Thu, 21 Feb 2008 16:50:35 +0000 David Howells <dhowells@redhat.com> wrote:
> > 
> > > From: David Howells <dhowells@redhat.com>
> > > 
> > > The kernel NTP code shouldn't hand 64-bit *signed* values to do_div().  Make it
> > > instead hand 64-bit unsigned values.  This gets rid of a couple of warnings.
> > 
> > On certain architectures.  It would have bene nice to mention what those
> > architectures are, and to quote the warnings.  Next time, please ;)
> > 
> > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > ---
> > > 
> > >  kernel/time/ntp.c |   12 +++++++-----
> > 
> > Thomas, do you consider ntp to fall under git-hrt?
> 
> I'll pick it up.
> 


OK.  And this is still
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git#mm,
yes?

Can we please define the scope of that tree?

Please review

fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch

from http://userweb.kernel.org/~akpm/mmotm/broken-out/.  I think they're
all probably git-hrt material.

Can we get that tree into linux-next too please?
