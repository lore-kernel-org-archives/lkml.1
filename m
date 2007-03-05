Return-Path: <linux-kernel-owner+w=401wt.eu-S1030426AbXCENlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030426AbXCENlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030580AbXCENlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:41:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030579AbXCENlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:41:50 -0500
Date: Mon, 5 Mar 2007 14:32:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] KVM: T60 resume fix
Message-ID: <20070305133221.GA28780@elte.hu>
References: <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu> <45EBD9BC.4030801@qumranet.com> <20070305084449.GA1706@elte.hu> <20070305085718.GA2513@elte.hu> <20070305125425.GA4350@mellanox.co.il> <20070305125008.GA21735@elte.hu> <20070305132625.GA5311@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305132625.GA5311@mellanox.co.il>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > could you try 's2ram' from http://suspend.sf.net ? It's basically 
> > equivalent to 'echo mem > /sys/power/state', but you can usually also 
> > see the reason why it doesnt resume, on the vga console. (by default the 
> > kernel doesnt resume the t60's vga properly)
> 
> OK, I'll give it a try. Do I have to shut down X or is it enough to 
> switch to another VT?

s2ram takes care of that on your behalf.

> > on my box resume works, but it's incredibly slow.
> 
> I guess it is possible that what I mistook for a hang was actually an 
> incredibly slow system, and that it would resume, eventually. I waited 
> for 5 min and gave up.

5 min should be enough to have the box pingable again.

> However, after resume was completed, system would hang on the *next* 
> suspend to ram.
> 
> Ingo, do you see this behaviour, or can you suspend/resume any number 
> of times?

havent tried that yet - first trying to figure out why the first resume 
misbehaves ;)

	Ingo
