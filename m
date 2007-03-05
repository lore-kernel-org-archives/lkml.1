Return-Path: <linux-kernel-owner+w=401wt.eu-S965267AbXCENbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbXCENbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXCENbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:31:24 -0500
Received: from dev.mellanox.co.il ([194.90.237.44]:35955 "EHLO
	dev.mellanox.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267AbXCENbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:31:23 -0500
Date: Mon, 5 Mar 2007 15:26:25 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] KVM: T60 resume fix
Message-ID: <20070305132625.GA5311@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu> <45EBD9BC.4030801@qumranet.com> <20070305084449.GA1706@elte.hu> <20070305085718.GA2513@elte.hu> <20070305125425.GA4350@mellanox.co.il> <20070305125008.GA21735@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305125008.GA21735@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Ingo Molnar <mingo@elte.hu>:
> Subject: Re: [patch] KVM: T60 resume fix
> 
> 
> * Michael S. Tsirkin <mst@mellanox.co.il> wrote:
> 
> > > suspend/resume works fine now and there are no warning messages 
> > > whatsoever (with suspend simulation). Thanks Avi!
> > 
> > I just tried Ingo's .config and it hangs on resume for me (with 
> > suspend to memory).
> 
> could you try 's2ram' from http://suspend.sf.net ? It's basically 
> equivalent to 'echo mem > /sys/power/state', but you can usually also 
> see the reason why it doesnt resume, on the vga console. (by default the 
> kernel doesnt resume the t60's vga properly)

OK, I'll give it a try. Do I have to shut down X or is it enough to
switch to another VT?

> on my box resume works, but it's incredibly slow.

I guess it is possible that what I mistook for a hang was actually an incredibly
slow system, and that it would resume, eventually. I waited for 5 min and gave
up.

> Takes a few minutes to have total effect.

I have same here with my old .config (2-3 min).

However, after resume was completed, system would hang on the *next* suspend to
ram.

Ingo, do you see this behaviour, or can you suspend/resume any number of times?

-- 
MST
