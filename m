Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYCCNYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYCCNYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYCCNY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:24:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYCCNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:24:26 -0500
Date: Mon, 3 Mar 2008 08:24:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jon Masters <jonathan@jonmasters.org>
cc: Mark Hounschell <markh@compro.net>, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
In-Reply-To: <1204518711.22885.68.camel@perihelion>
Message-ID: <Pine.LNX.4.58.0803030820580.20684@gandalf.stny.rr.com>
References: <47BD6802.60604@cfl.rr.com>  <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com>
  <47BD7D09.9050106@compro.net>  <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
 <1204518711.22885.68.camel@perihelion>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2 Mar 2008, Jon Masters wrote:
> On Thu, 2008-02-21 at 10:08 -0500, Steven Rostedt wrote:
> > On Thu, 21 Feb 2008, Mark Hounschell wrote:
> > > >
> > > > To prove this is the problem, boot with noapic in the kernel command line.
> > > > 1) the problem should disappear.
> > > > 2) (I'm betting) you see that the eth and EMU10K1 share the same
> > > >    interrupt line.
> > > >
> > >
> > > Yep, you were right. They do share the same IRQ and the problem does go away.
> > > Unfortunately  I can't run this machine with noapic. I need irq affinity.
> > >
> >
> > Thanks for verifying. OK, I'll see if I can get the workaround on i386.
>
> What's the situation with this one? Want me to look at it?

Jon,

The board Mark has may just be some cheap hardware. It would be great
that RT would work on all boxes, but I'm not sure we want to spend time on
"broken-by-design" hardware while there's bigger fish in the sea to catch.

The current workaround is just use noapic, although I do understand
that's not good enough for Mark. But I'm sure Mark has other hardware
he could use ;-)

-- Steve

