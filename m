Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbXFSOGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbXFSOGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXFSOGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:06:14 -0400
Received: from mail.screens.ru ([213.234.233.54]:46097 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbXFSOGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:06:11 -0400
Date: Tue, 19 Jun 2007 18:06:46 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
Message-ID: <20070619140646.GB27343@tv-sign.ru>
References: <1182064500.2798.6.camel@entropy> <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com> <1182108399.3794.4.camel@entropy> <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com> <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com> <1182127391.26853.207.camel@localhost.localdomain> <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org> <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182254988.26853.334.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Benjamin Herrenschmidt wrote:
>
> On Tue, 2007-06-19 at 13:14 +0400, Oleg Nesterov wrote:
> 
> > The commited "Fix signalfd interaction with thread-private signals"
> > (commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
> > this.
> 
> Indeed, if you want what Davide described, you need to also change
> signalfd side. The patch I did merely prevents another thread from
> dequeuing somebody else private signals.

Yes I see, but why do we need this change? Yes, we can dequeue SIGSEGV
from another thread. Just don't do it if you have a handler for SIGSEGV?

Oleg.

