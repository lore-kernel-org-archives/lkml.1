Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbXLBI7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbXLBI7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 03:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXLBI7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 03:59:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54767 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXLBI7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 03:59:14 -0500
Date: Sun, 2 Dec 2007 09:58:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202085847.GB28966@elte.hu>
References: <20071201092037.GA32544@elte.hu> <alpine.DEB.0.9999.0712011036340.10996@chino.kir.corp.google.com> <20071201193643.GA10911@elte.hu> <200712020155.00187.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712020155.00187.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Oeser <ioe-lkml@rameria.de> wrote:

> On Saturday 01 December 2007, Ingo Molnar wrote:
> > maybe, but we'd have to see how often this gets triggered. An OOM is 
> > something that could happen in any overloaded system - while a hung task 
> > is likely due to a kernel bug.
> 
> What about a client using hard mounted NFS shares here? That shouldn't 
> be killed by the OOM killer in that situation, should it?

NFS is a bit weird in this regard - fundamentally everything should be 
interruptible (or at least killable). Wont the TASK_KILLABLE solve these 
problems?

	Ingo
