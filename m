Return-Path: <linux-kernel-owner+w=401wt.eu-S1763932AbXJZU2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763932AbXJZU2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJZU2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:28:45 -0400
Received: from waste.org ([66.93.16.53]:32796 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbXJZU2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:28:44 -0400
Date: Fri, 26 Oct 2007 15:28:31 -0500
From: Matt Mackall <mpm@selenic.com>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: IRQ off latency of printk is very high
Message-ID: <20071026202831.GP17536@waste.org>
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com> <20071025231237.GT19691@waste.org> <472129C3.6040405@am.sony.com> <20071026012342.GV19691@waste.org> <m3r6jighjl.fsf@ursa.amorsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3r6jighjl.fsf@ursa.amorsen.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 02:57:18PM +0200, Benny Amorsen wrote:
> >>>>> "MM" == Matt Mackall <mpm@selenic.com> writes:
> 
> MM> Well there are things we can do, yes, but I'd be worried that
> MM> they've give up the deterministic behavior we rely on quite
> MM> heavily for debugging. If event A happens before event B, we must
> MM> see the message from A before the one from B, even if B happens in
> MM> irq context.
> 
> MM> And if event B is a hard lock up, we'd also like to be sure the
> MM> message for A actually gets out. If B happens in the interrupt
> MM> that comes in when we re-enable them, that won't happen.
> 
> I can see the concerns, but right now it all leads to disabling serial
> console for real-time servers. That is even less helpful for
> debugging.

That's not clear. No data is often better than false or misleading
data.

-- 
Mathematics is the supreme nostalgia of our time.
