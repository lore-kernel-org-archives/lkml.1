Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbXC0FQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbXC0FQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933975AbXC0FQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:16:28 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39200 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbXC0FQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:16:27 -0400
Date: Mon, 26 Mar 2007 21:16:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Bernhard Walle <bwalle@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/7] Add IRQF_IRQPOLL_IRQ flag to allow irqpoll
Message-Id: <20070326211605.48a46957.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.60.0703270700250.3960@poirot.grange>
References: <20070323164447.659982000@strauss.suse.de>
	<Pine.LNX.4.60.0703232312180.5971@poirot.grange>
	<20070323222549.GA19772@strauss.suse.de>
	<Pine.LNX.4.60.0703240018240.5971@poirot.grange>
	<20070325202906.GC23487@strauss.suse.de>
	<Pine.LNX.4.60.0703270700250.3960@poirot.grange>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 07:01:44 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Sun, 25 Mar 2007, Bernhard Walle wrote:
> 
> > * Guennadi Liakhovetski <g.liakhovetski@gmx.de> [2007-03-24 00:21]:
> > > On Fri, 23 Mar 2007, Bernhard Walle wrote:
> > > 
> > > > * Guennadi Liakhovetski <g.liakhovetski@gmx.de> [2007-03-23 23:15]:
> > > > > On Fri, 23 Mar 2007, Bernhard Walle wrote:
> > > > > 
> > > > > > irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
> > > > > > interrupt like IA64. This patch adds a IRQF_IRQPOLL_IRQ flag.
> > > > > 
> > > > > emn, please, cannot we come up with a better name - one that doesn't have 
> > > > > "IRQ" 3 (!) times in it?...
> > > > 
> > > > Well, it was suggested by Andrew. What's your suggestion?
> > > 
> > > Purely esthetically (ehm, am I saying that?...) your original suggestion 
> > > to use IRQF_IRQPOLL looks better to me. Or even IRQF_POLL, but, maybe, 
> > > it's a bit too much of a simplification.
> > 
> > I personally don't care very much about the naming. So I think it's
> > Andrews final decision ...
> 
> Sure. And for him to have a better chance to do this, I'll fix his email 
> address too:-)
> 

I don't think I went as daringly far as to suggest the full name, but I
must admit that IRQF_IRQPOLL_IRQ is actually logical.

