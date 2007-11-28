Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbXK1UUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbXK1UUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXK1UU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:20:29 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:53667 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbXK1UU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:20:28 -0500
Date: Wed, 28 Nov 2007 15:16:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Remy Bohmer <linux@bohmer.net>, Daniel Walker <dwalker@mvista.com>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will
 stall forever
In-Reply-To: <20071128200550.GA3494@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com>
 <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com>
 <1196176294.13982.58.camel@localhost.localdomain> <1196177122.23808.7.camel@imap.mvista.com>
 <1196178834.23808.11.camel@imap.mvista.com> <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
 <20071128172509.GA30173@flint.arm.linux.org.uk>
 <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com>
 <20071128200550.GA3494@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Nov 2007, Russell King - ARM Linux wrote:

> On Wed, Nov 28, 2007 at 02:04:41PM -0500, Steven Rostedt wrote:
> > Thanks for the reply and this nice explanation.
> >
> > I'm taking this as a NACK.
> >
> > Daniel or Remy, could you find the offending users and make send patches
> > to fix them.
>
> Note that I'm not acking nor nacking the patch; I'm not involved with
> the RT stuff and I've never looked at the code, so I don't know what
> the implications of the patch itself are.

Understood. But I didn't know to pull it in or not. So I used your
explanation to NACK it myself. I don't understand all the intricacies of
the arm architecture. So while Thomas is out, I'm not pulling this in.

If he comes back and gives his ACK, I'll simply NACK my NACK ;-)

>
> I've merely explained the point of the simple irq handler.
>
> Maybe the simple irq handler should never have been something that got
> sucked into the generic IRQ stuff, but kept as something specific to
> Neponset.
>

This could also simply be unique to the interrupt threads (only in RT). So
perhaps the patch is OK.

Remy, sorry about this round-a-bout. But I don't have any of the hardware
that this affects, and I'm just being cautious.

Thanks,

-- Steve

