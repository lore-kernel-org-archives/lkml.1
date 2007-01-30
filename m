Return-Path: <linux-kernel-owner+w=401wt.eu-S965436AbXA3IEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965436AbXA3IEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965444AbXA3IEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:04:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33497 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965436AbXA3IEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:04:37 -0500
Date: Tue, 30 Jan 2007 09:03:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070130080321.GB2840@elte.hu>
References: <1170109401.29240.49.camel@localhost.localdomain> <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org> <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org> <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BEF61F.7000400@garzik.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4478]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Sharing irqs /sucks/. [...]

btw., MSI is not really needed to avoid the sharing of irqs: x86 has 224 
IRQ vectors which is abundant for all but the largest boxes. Even the 
smallest laptop tends to have an IO-APIC with at least 24 pins - which 
is enough to never have to share irqs. How system designers can still 
end up with mapping so many devices to the same pin is really their 
fault.

so MSI's only true accomplishment AFAICS is that it now says on the 
hardware level that "you must not share IRQs". Well, doh...

	Ingo
