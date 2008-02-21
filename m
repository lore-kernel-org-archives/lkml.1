Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYBUPJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYBUPJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYBUPJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:09:32 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:50932 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYBUPJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:09:31 -0500
Date: Thu, 21 Feb 2008 10:08:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mark Hounschell <markh@compro.net>
cc: Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
In-Reply-To: <47BD7D09.9050106@compro.net>
Message-ID: <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
References: <47BD6802.60604@cfl.rr.com> <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com>
 <47BD7D09.9050106@compro.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 Feb 2008, Mark Hounschell wrote:
> >
> > To prove this is the problem, boot with noapic in the kernel command line.
> > 1) the problem should disappear.
> > 2) (I'm betting) you see that the eth and EMU10K1 share the same
> >    interrupt line.
> >
>
> Yep, you were right. They do share the same IRQ and the problem does go away.
> Unfortunately  I can't run this machine with noapic. I need irq affinity.
>

Thanks for verifying. OK, I'll see if I can get the workaround on i386. I
thought I saw a patch someplace where someone ported that workaround. I'm
still sorting out bugs in -rt2 (why it is still not out). I'll see if I
can find time to get the workaround to i386 for -rt2 as well.

-- Steve

