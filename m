Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbYBAXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbYBAXWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbYBAXWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:22:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938AbYBAXWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:22:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Date: Sat, 2 Feb 2008 00:19:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
References: <200801272229.48955.rjw@sisk.pl> <20080201124702.GA31321@elte.hu> <200802011542.42483.rjw@sisk.pl>
In-Reply-To: <200802011542.42483.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020019.25599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Rafael J. Wysocki wrote:
> On Friday, 1 of February 2008, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > The below fixes it for me..
> > > 
> > > ---
> > >  - restore the old wakeup mechanism
> > >  - fix break usage in do_each_thread() { } while_eac_thread().
> > >  - fix the hotplug switch stmt, a fall-through case was broken.
> > 
> > thanks Peter, i've picked your fix up. I hope this solves the problem 
> > for Rafael too.
> 
> No, it doesn't, unfortunately.  Actually, it breaks things even more, as
> suspend now hangs (probably deadlocks) while disabling the nonboot CPU.

For some obscure reason, I'm no longer able to reproduce the problem
with the Peter's patch and I think it's correct.  You can add

Tested-by: Rafael J. Wysocki <rjw@sisk.pl>

to it.

Thanks,
Rafael
