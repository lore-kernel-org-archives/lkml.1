Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZBLI2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZBLI2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZBLI2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:28:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZBLI2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:28:14 -0500
Date: Thu, 12 Feb 2009 09:27:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: fix ipi kfree(), introduce IPI_SOFTIRQ
Message-ID: <20090212082751.GA29856@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212081801.GA22979@elte.hu> <20090212081923.GA26838@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212081923.GA26838@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > hm, that's a complex one - we do kfree() from IPI context, [...]
> 
> The patch below might do the trick - it offloads this to a softirq.
> Not tested yet.

ok, it's lightly tested now: it built and booted up fine to X with your config.

	Ingo
