Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZHNKVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZHNKVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZHNKVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:21:46 -0400
Received: from www.tglx.de ([62.245.132.106]:50301 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZHNKVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:21:46 -0400
Date: Fri, 14 Aug 2009 12:20:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
 slow busses
In-Reply-To: <20090814101739.GA32418@elf.ucw.cz>
Message-ID: <alpine.LFD.2.00.0908141220190.1283@localhost.localdomain>
References: <20090813191535.945521006@linutronix.de> <20090813193116.509070851@linutronix.de> <20090814101739.GA32418@elf.ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Pavel Machek wrote:
> > +extern void disable_slowbus_irq(unsigned int irq);
> > +extern void enable_slowbus_irq(unsigned int irq);
> > +
> 
> AFAICT this means that driver would need to know what kind of IRQ it
> is hooked to, right? That will lead to some ugly code in drivers that
> can handle both normal and slowbus irqs, right?

Are there such drivers in reality ?

Thanks,

	tglx
