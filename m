Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZCWVpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZCWVpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZCWVpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:45:00 -0400
Received: from thunk.org ([69.25.196.29]:53072 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZCWVo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:44:59 -0400
Date: Mon, 23 Mar 2009 17:44:17 -0400
From: Theodore Tso <tytso@mit.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090323214417.GD5814@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Oleg Nesterov <oleg@redhat.com>,
	Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roland McGrath <roland@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090322123749.GF19826@elte.hu> <20090323134813.GA18219@x200.localdomain> <20090323151400.GA3413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323151400.GA3413@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 04:14:00PM +0100, Oleg Nesterov wrote:
> 
> Yes, ptrace-over-utrace needs more work. But your message looks as if
> utrace core is buggy, imho this is a bit unfair ;)
> 
> As Roland said, ptrace-over-utrace is not ready yet. If you mean that
> utrace core should not be merged alone - this is another story.
> 
> But personally I understand why Roland sends utrace core before changing
> ptrace.

Yes, but if it's going to be merged this during 2.6.x cycle, we need
to have a user for the kernel interface along with the new kernel
interface.  This is true for any body trying to add some new
infrastructure to the kernel; you have to have an in-tree user of said
interface.

I mean, if some device manufacturer were to go to Red Hat's kernel
team, and say, "we need this interface for our uber expensive RDMA
interface card", and there was no in-kernel user for the interface, we
know what Red Hat would tell that device manufacturer, right?  So why
is the SystemTap team trying to get an exception for utrace?  It just
seems a little hypocritical.

So what about the ftrace user of utrace?  Is that ready to be merged?

   	      	  	      	 	     - Ted
