Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbXGEXPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbXGEXPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760239AbXGEXOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:14:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538AbXGEXOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:14:53 -0400
Message-Id: <200707052312.l65NCjfb025915@pasta.boston.redhat.com>
To: Chris Friesen <cfriesen@nortel.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
In-Reply-To: Your message of "Thu, 05 Jul 2007 16:49:35 MDT."
             <468D757F.5000804@nortel.com>
Date: Thu, 05 Jul 2007 19:12:45 -0400
From: Ernie Petrides <petrides@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5-Jul-2007 at 16:49 MDT, Chris Friesen wrote:

> Ernie Petrides wrote:
> 
> > Only kernels built with the CONFIG_HIGH_RES_TIMERS option enabled were
> > vulnerable.
> 
> As I mentioned in my post to Thomas, we have high res timers disabled 
> and were still affected.  Granted, our kernel has been modified so it is 
> possible that vanilla would not be affected....I haven't tested it.
> 
> Chris

That's odd, because Thomas's patch removed two calls to clock_was_set(),
which is a no-op when CONFIG_HIGH_RES_TIMERS is not enabled (at least in
the 2.6.21 source tree).

Also, I personally tested with the reproducer you posted here, initially
on a box running 2.6.22-rc4, and there were no problems (but I'm not sure
what config options were enabled on that kernel).  I did reproduce the
problem on a stock 2.6.21 kernel with CONFIG_HIGH_RES_TIMERS enabled.

Cheers.  -ernie
