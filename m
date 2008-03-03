Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbYCCEct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbYCCEct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYCCEck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:32:40 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:48734 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYCCEcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:32:39 -0500
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
From: Jon Masters <jonathan@jonmasters.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mark Hounschell <markh@compro.net>, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
References: <47BD6802.60604@cfl.rr.com>
	 <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com>
	 <47BD7D09.9050106@compro.net>
	 <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sun, 02 Mar 2008 23:31:51 -0500
Message-Id: <1204518711.22885.68.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 10:08 -0500, Steven Rostedt wrote:
> On Thu, 21 Feb 2008, Mark Hounschell wrote:
> > >
> > > To prove this is the problem, boot with noapic in the kernel command line.
> > > 1) the problem should disappear.
> > > 2) (I'm betting) you see that the eth and EMU10K1 share the same
> > >    interrupt line.
> > >
> >
> > Yep, you were right. They do share the same IRQ and the problem does go away.
> > Unfortunately  I can't run this machine with noapic. I need irq affinity.
> >
> 
> Thanks for verifying. OK, I'll see if I can get the workaround on i386.

What's the situation with this one? Want me to look at it?

Jon.


