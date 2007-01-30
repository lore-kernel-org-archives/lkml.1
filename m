Return-Path: <linux-kernel-owner+w=401wt.eu-S965427AbXA3IOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbXA3IOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965428AbXA3IOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:14:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48094 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXA3IOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:14:22 -0500
Date: Tue, 30 Jan 2007 09:13:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070130081302.GA5671@elte.hu>
References: <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org> <20070130075325.GA591@elte.hu> <45BEFBB2.8090402@garzik.org> <20070130080830.GC2840@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130080830.GC2840@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.3 required=5.9 tests=ALL_TRUSTED autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> I /think/ my two patches should automatically avoid the 'cap themselves' 
                                                            ^--crap
> effect you outlined: the absolutely worst case should be that we'll 
> have twice the IRQ rate of the optimal one - but no irq storm nor lost 
> interrupts should happen due to irq trigger type mismatches, ever - as 
> long as the basic mapping of device to IRQ is correct. [ I tried to 
> push to include this in v2.6.20 but i lost that argument ;-) ]

