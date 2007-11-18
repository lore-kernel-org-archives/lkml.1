Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbXKRW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbXKRW06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXKRW0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:26:50 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33132 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752527AbXKRW0t (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:26:49 -0500
Date: Mon, 19 Nov 2007 09:26:20 +1100
From: David Chinner <dgc@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Remy Bohmer <linux@bohmer.net>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
Message-ID: <20071118222620.GN66820511@sgi.com>
References: <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com> <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com> <1195316550.25393.21.camel@imap.mvista.com> <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com> <1195320569.25393.38.camel@imap.mvista.com> <20071117174608.GA30641@elte.hu> <1195322141.25393.41.camel@imap.mvista.com> <20071117180430.GA10768@elte.hu> <1195323177.25393.56.camel@imap.mvista.com> <1195389230.6747.5.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195389230.6747.5.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 01:33:50PM +0100, Peter Zijlstra wrote:
> 
> On Sat, 2007-11-17 at 10:12 -0800, Daniel Walker wrote:
> 
> > What specifically is wrong with dev->sem ?
> 
> Nothing really, other than that they use semaphores to avoid lockdep :-/
> 
> I think I know how to annotate this, after Alan Stern explained all the
> use cases, but I haven't come around to implementing it. Hope to do that
> soonish.
> 
> Another real semaphore user is XFS, they really use the down/up
> asymmetry that semaphores allow, last time I spoke with Dave Chinner he
> didn't know a way around this.

Hasn't changed recently. We could convert some to completions, but
others are much more difficult.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
