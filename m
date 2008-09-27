Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYI0TSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYI0TSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYI0TSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:18:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbYI0TSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:18:36 -0400
Date: Sat, 27 Sep 2008 21:18:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: dcg <diegocg@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080927191824.GC18619@elte.hu>
References: <20080924183517.GA24209@nostromo.devel.redhat.com> <20080925091558.GE16734@elte.hu> <20080925161300.GA17162@nostromo.devel.redhat.com> <20080927185027.GB17867@elte.hu> <20080927211131.2e0b60f0@diego-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080927211131.2e0b60f0@diego-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* dcg <diegocg@gmail.com> wrote:

> El Sat, 27 Sep 2008 20:50:27 +0200, Ingo Molnar <mingo@elte.hu> escribió:
> 
> > that has some marginal use: it shows that we are past the really 
> > basic system setup code, we decompressed the kernel and entered 
> > protected mode with boot paging enabled.
> 
> What I find annoying about that printk is that I see it even with the 
> "quiet" boot flag.

that's a property of early_printk() - it just doesnt listen to any of 
the normal printk modifiers. (and that's the point of early_printk())

could you please send a patch that only calls that early_printk() if 
console_loglevel == 10? (i.e. if "debug" has been passed)

	Ingo
