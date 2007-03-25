Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbXCYU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbXCYU3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 16:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXCYU3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 16:29:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:34475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbXCYU3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 16:29:16 -0400
Date: Sun, 25 Mar 2007 22:29:06 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/7] Add IRQF_IRQPOLL_IRQ flag to allow irqpoll
Message-ID: <20070325202906.GC23487@strauss.suse.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andrew Morton <akpm@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>
References: <20070323164447.659982000@strauss.suse.de> <Pine.LNX.4.60.0703232312180.5971@poirot.grange> <20070323222549.GA19772@strauss.suse.de> <Pine.LNX.4.60.0703240018240.5971@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0703240018240.5971@poirot.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Guennadi Liakhovetski <g.liakhovetski@gmx.de> [2007-03-24 00:21]:
> On Fri, 23 Mar 2007, Bernhard Walle wrote:
> 
> > * Guennadi Liakhovetski <g.liakhovetski@gmx.de> [2007-03-23 23:15]:
> > > On Fri, 23 Mar 2007, Bernhard Walle wrote:
> > > 
> > > > irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
> > > > interrupt like IA64. This patch adds a IRQF_IRQPOLL_IRQ flag.
> > > 
> > > emn, please, cannot we come up with a better name - one that doesn't have 
> > > "IRQ" 3 (!) times in it?...
> > 
> > Well, it was suggested by Andrew. What's your suggestion?
> 
> Purely esthetically (ehm, am I saying that?...) your original suggestion 
> to use IRQF_IRQPOLL looks better to me. Or even IRQF_POLL, but, maybe, 
> it's a bit too much of a simplification.

I personally don't care very much about the naming. So I think it's
Andrews final decision ...


Thanks,
   Bernhard
