Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYBWRwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYBWRwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYBWRwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:52:17 -0500
Received: from www.tglx.de ([62.245.132.106]:43158 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYBWRwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:52:16 -0500
Date: Sat, 23 Feb 2008 18:51:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-kernel@vger.kernel.org
Subject: Re: linux/kernel/irq/chip.c IRQ disable, shutdown bug
In-Reply-To: <20080223101313.GE23833@elte.hu>
Message-ID: <alpine.LFD.1.00.0802231850240.7583@apollo.tec.linutronix.de>
References: <600D5CB4DFD93545BF61FF01473D11AC124E5D34@limkexm2.ad.analog.com> <20080223000717.3ed3a4c1.akpm@linux-foundation.org> <20080223101313.GE23833@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008, Ingo Molnar wrote:
 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +       desc->chip->mask(irq);
> > > +       desc->status |= IRQ_MASKED;
> > >  }
> > > 
> > >  /*
> > 
> > Ingo, Thomas: ack?
> 
> we've already queued it in up the genirq tree. (in a slightly different 
> form)

Already mainline: 89d694b9dbe769ca1004e01db0ca43964806a611

Thanks,

	tglx
