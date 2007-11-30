Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXK3Vrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXK3Vrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbXK3Vre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:47:34 -0500
Received: from www.tglx.de ([62.245.132.106]:43645 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbXK3Vrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:47:33 -0500
Date: Fri, 30 Nov 2007 22:44:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Remy Bohmer <linux@bohmer.net>, Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>, RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will
 stall forever
In-Reply-To: <20071129133604.GA23845@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.0.9999.0711302239100.13961@localhost.localdomain>
References: <1196177122.23808.7.camel@imap.mvista.com> <1196178834.23808.11.camel@imap.mvista.com> <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com> <20071128172509.GA30173@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com>
 <20071128200550.GA3494@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com> <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com> <20071129102506.GB22793@flint.arm.linux.org.uk> <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com>
 <20071129133604.GA23845@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Russell King - ARM Linux wrote:
> If people insist on adding the mask/unmask crap to it, the function
> might as well be deleted and be an alias for handle_level_IRQ.  Because
> that's _precisely_ what you lot are turning it into.
> 
> Ah, and looking at the changes to the file, the addition of the mask
> and unmask was done by someone who didn't understand what this was
> trying to do.  So that change should be backed out.

It looks like a mechanical "fix them all" thingy. I never intended to
use the simple handler for anything else than a fast demux handler.

You are right, it needs to be backed out.

Thanks,

	tglx



