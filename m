Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYJPSXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYJPSXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYJPSWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:22:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYJPSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:22:50 -0400
Date: Thu, 16 Oct 2008 14:22:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       linuxppc-dev@ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] ftrace: fixes for PPC
In-Reply-To: <20081016181452.GA29739@yoda.jdub.homelinux.org>
Message-ID: <alpine.DEB.1.10.0810161421530.11042@gandalf.stny.rr.com>
References: <20080906050602.409299112@goodmis.org> <20080906120346.GA30964@elte.hu> <20081016181452.GA29739@yoda.jdub.homelinux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Oct 2008, Josh Boyer wrote:

> On Sat, Sep 06, 2008 at 02:03:47PM +0200, Ingo Molnar wrote:
> >
> >* Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> I spent the day chasing a bug that would hang PPC on boot up when 
> >> ftrace is configured in. I found that it was simply a stupid bug I did 
> >> to handle the non MCOUNT_RECORD case. Since I was testing only on x86, 
> >> and the MCOUNT_RECORD is automatically set for dynamic ftrace if it is 
> >> available, I did not test the case where MCOUNT_RECORD was not set.
> >> 
> >> I have not finished porting MCOUNT_RECORD to PPC, but have found that 
> >> it has caused some issues for archs that do not support it yet.
> >> 
> >> This patch series handles these cases.
> >
> >applied to tip/tracing/ftrace, thanks Steve.
> 
> Are these two merged yet?  I just spent the better part of the morning
> trying to figure out why various Fedora kernels based on 2.6.27-rcX and
> 2.6.27 final hung on my G5 and finally got one booting with FTRACE
> disabled.

My powerbook does not boot with ftrace enabled. I'm currently debugging 
it. When I get it working, you'll see patches.

They will be to linux-tip though, and not for the current mainline (unless 
the code in linux-tip gets merged).

-- Steve

