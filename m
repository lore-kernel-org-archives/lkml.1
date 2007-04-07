Return-Path: <linux-kernel-owner+w=401wt.eu-S965672AbXDGIuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbXDGIuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965680AbXDGIuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:50:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965672AbXDGIug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:50:36 -0400
Date: Sat, 7 Apr 2007 10:50:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [patch] high-res timers: UP resume fix
Message-ID: <20070407085028.GA8354@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <1175899460.5393.9.camel@localhost> <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org> <20070407081244.GA28284@elte.hu> <20070407082554.GA1943@elte.hu> <1175935730.28263.510.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175935730.28263.510.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 2007-04-07 at 10:25 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > [...] Soeren, can you confirm that you are using a !CONFIG_SMP kernel, 
> > > and if yes, does the patch below fix the resume problem for you?
> > 
> > hm, you seem to have a CONFIG_SMP=y kernel. I dont immediately see 
> > where we re-enable interrupts in the SMP case, but could you try my 
> > patch nevertheless
> 
> We do in on_each_cpu() unconditionally. I missed that.

doh, indeed!

	Ingo
