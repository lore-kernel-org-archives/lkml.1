Return-Path: <linux-kernel-owner+w=401wt.eu-S2992524AbXDRUMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992524AbXDRUMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992513AbXDRUMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:12:41 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992506AbXDRUMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:12:39 -0400
Date: Wed, 18 Apr 2007 13:11:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <Pine.LNX.4.64.0704181254580.25880@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0704181302370.2828@woody.linux-foundation.org>
References: <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de>
 <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de>
 <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de>
 <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
 <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
 <20070418174945.GA7930@elte.hu> <alpine.LFD.0.98.0704181215260.2828@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704181254580.25880@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Apr 2007, Davide Libenzi wrote:
> 
> "Perhaps on the rare occasion pursuing the right course demands an act of 
>  unfairness, unfairness itself can be the right course?"

I don't think that's the right issue.

It's just that "fairness" != "equal".

Do you think it "fair" to pay everybody the same regardless of how good a 
job they do? I don't think anybody really believes that. 

Equating "fair" and "equal" is simply a very fundamental mistake. They're 
not the same thing. Never have been, and never will.

Now, there's no question that "equal" is much easier to implement, if only 
because it's a lot easier to agree what it means. "Equal parts" is 
somethign everybody can agree on. "Fair parts" automatically involves a 
balancing act, and people will invariably count things differently and 
thus disagree about what is "fair" and what is not.

I don't think we can ever get a "perfect" setup for that reason, but I 
think we can get something that at least gets reasonably close, at least 
for the obvious cases.

So my suggested test-case of running one process as one user and two 
processes as another one has a fairly "obviously correct" solution if you 
have just one CPU's, and you can probably be pretty fair in practice on 
two CPU's (there's an obvious theoretical solution, whether you can get 
there with a practical algorithm is another thing). On three or more 
CPU's, you obviously wouldn't even *want* to be fair, since you can very 
naturally just give a CPU to each..

			Linus
