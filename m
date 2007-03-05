Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXCENAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXCENAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933429AbXCENAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:00:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51610 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426AbXCENAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:00:01 -0500
Date: Mon, 5 Mar 2007 13:50:08 +0100
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
Message-ID: <20070305125008.GA21735@elte.hu>
References: <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu> <20070302102216.GA13575@elte.hu> <45E93012.4000100@qumranet.com> <20070305082251.GA23366@elte.hu> <45EBD9BC.4030801@qumranet.com> <20070305084449.GA1706@elte.hu> <20070305085718.GA2513@elte.hu> <20070305125425.GA4350@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305125425.GA4350@mellanox.co.il>
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


* Michael S. Tsirkin <mst@mellanox.co.il> wrote:

> > suspend/resume works fine now and there are no warning messages 
> > whatsoever (with suspend simulation). Thanks Avi!
> 
> I just tried Ingo's .config and it hangs on resume for me (with 
> suspend to memory).

could you try 's2ram' from http://suspend.sf.net ? It's basically 
equivalent to 'echo mem > /sys/power/state', but you can usually also 
see the reason why it doesnt resume, on the vga console. (by default the 
kernel doesnt resume the t60's vga properly)

on my box resume works, but it's incredibly slow. Takes a few minutes to 
have total effect.

	Ingo
