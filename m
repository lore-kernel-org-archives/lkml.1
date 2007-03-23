Return-Path: <linux-kernel-owner+w=401wt.eu-S2992617AbXCWXVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992617AbXCWXVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992622AbXCWXVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:21:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:37543 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2992617AbXCWXVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:21:04 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+lp1lx1aylq8QKJUkobgHG3B8XjNSM3XDjO2w8Do
	Pj8H7vN4M9tGB9
Date: Sat, 24 Mar 2007 00:21:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bernhard Walle <bwalle@suse.de>
cc: Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/7] Add IRQF_IRQPOLL_IRQ flag to allow irqpoll
In-Reply-To: <20070323222549.GA19772@strauss.suse.de>
Message-ID: <Pine.LNX.4.60.0703240018240.5971@poirot.grange>
References: <20070323164447.659982000@strauss.suse.de>
 <Pine.LNX.4.60.0703232312180.5971@poirot.grange> <20070323222549.GA19772@strauss.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007, Bernhard Walle wrote:

> * Guennadi Liakhovetski <g.liakhovetski@gmx.de> [2007-03-23 23:15]:
> > On Fri, 23 Mar 2007, Bernhard Walle wrote:
> > 
> > > irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
> > > interrupt like IA64. This patch adds a IRQF_IRQPOLL_IRQ flag.
> > 
> > emn, please, cannot we come up with a better name - one that doesn't have 
> > "IRQ" 3 (!) times in it?...
> 
> Well, it was suggested by Andrew. What's your suggestion?

Purely esthetically (ehm, am I saying that?...) your original suggestion 
to use IRQF_IRQPOLL looks better to me. Or even IRQF_POLL, but, maybe, 
it's a bit too much of a simplification.

Thanks
Guennadi
---
Guennadi Liakhovetski
