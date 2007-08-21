Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXHUKef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXHUKef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbXHUKe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:34:27 -0400
Received: from mx12.go2.pl ([193.17.41.142]:55510 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753479AbXHUKe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:34:26 -0400
Date: Tue, 21 Aug 2007 12:35:27 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: handle_fasteoi_irq vs IRQ_INPROGRESS && IRQ_DISABLED
Message-ID: <20070821103527.GC1778@ff.dom.local>
References: <20070821091700.GB1778@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821091700.GB1778@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 11:17:00AM +0200, Jarek Poplawski wrote:
> 
> Hi,
> 
> I've still some doubts about these irq handlers and I hope somebody
> could explain some of these (despite my problems with earlier such
> explanations, sorry...):
> 
> 1. According to some well-known Intel's manual (vol.3A page 8-41)
> lapic can interrupt irq handler dispatching higher-priority irq; it
> seems, such an event is possible during handle_IRQ_event, and would
> be treated by "common" handlers with IRQ_INPROGRESS; but:

OOPS!!! Of course, I got this wrong again: this IRQ_INPROGRESS is
for another irq... Sorry!

But, then, it seems such IRQ_INPROGRESS shouldn't be possible at all
with properly working lapic? Or do I miss something...

Jarek P. 
