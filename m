Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXJLQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXJLQeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760987AbXJLQM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:12:59 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:34566 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761223AbXJLQM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:12:57 -0400
Date: Fri, 12 Oct 2007 12:12:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Sigler <linux.kernel@free.fr>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NMI watchdog
In-Reply-To: <470F7620.6040705@free.fr>
Message-ID: <Pine.LNX.4.58.0710121210210.12663@gandalf.stny.rr.com>
References: <470F3BE0.4050807@free.fr> <Pine.LNX.4.58.0710120625380.8208@gandalf.stny.rr.com>
 <470F7620.6040705@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Fri, 12 Oct 2007, John Sigler wrote:
> Steven Rostedt wrote:
>
> > John Sigler wrote:
>  > APIC timer registered as dummy, due to nmi_watchdog=1!
> 213a216,217
>  > Clockevents: could not switch to one-shot mode: lapic is not functional.
>  > Could not switch to high resolution mode on CPU 0
>
> Do you know why nmi_watchdog=1 disables high-resolution timers?
>
> And why nmi_watchdog=1 implies APIC timer registered as dummy?

Crap, I forgot about that. Thomas explained why to me once, and I forgot.

Does it still crash? If not, does it crash if you turn off highres?

Or better yet, try turning off dynamic-ticks. We had a bug once before
that had a problem with the new RCU code and dynamic ticks.

-- Steve
