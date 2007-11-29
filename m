Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbXK2Qg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbXK2Qg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbXK2QgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:36:17 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:42919 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbXK2QgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:36:16 -0500
Date: Thu, 29 Nov 2007 11:30:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Daniel Walker <dwalker@mvista.com>, RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will
 stall forever
In-Reply-To: <3efb10970711290733m59e30b5eyf96b914d63a72058@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0711291128540.23075@gandalf.stny.rr.com>
References: <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com> 
 <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com> 
 <20071128200550.GA3494@flint.arm.linux.org.uk> 
 <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com> 
 <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com> 
 <20071129102506.GB22793@flint.arm.linux.org.uk> 
 <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com> 
 <20071129133604.GA23845@flint.arm.linux.org.uk> 
 <3efb10970711290618v2bd93edfrbc53d9df4b73b33b@mail.gmail.com> 
 <20071129142920.GB23845@flint.arm.linux.org.uk>
 <3efb10970711290733m59e30b5eyf96b914d63a72058@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 29 Nov 2007, Remy Bohmer wrote:

> I changed the interrupt handler from the simple_irq to the edge_irq,
> and it works...!!
> (I added a noop routine for that .ack part, because there is no ack)
>
> I believe I was too focussed on the masking bug in the RT kernel on
> the simple_irq() that I did not see that for the AT91 series the edge
> type interrupt handler also works... (even better...) What I thought
> was 1 single bug in the RT-kernel turned out to be a number of things
> together that aren't correct, even for mainline.
>
> So, to come to a conclusion: The masking bug in RT is still there in
> the simple_irq path, and masking has to be removed from the simple_irq
> code. Also for mainline. AT91 can live without simple_irq.
> I think we are in sync again...
>
> I will post a patch for the AT91 later on, after some more testing.


Remy,

Thanks a lot for figuring this out!! Makes me feel better for the NACK ;-)

If you also want to send me a patch to remove the masking in the
simple_irq code, please do.

Thanks,

-- Steve

