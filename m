Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbZCWPTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbZCWPTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZCWPS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:18:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35686 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbZCWPS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:18:59 -0400
Date: Mon, 23 Mar 2009 16:14:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090323151400.GA3413@redhat.com>
References: <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090322123749.GF19826@elte.hu> <20090323134813.GA18219@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323134813.GA18219@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Alexey Dobriyan wrote:
>
> Right now with ptrace(2) rewrite the following is easily triggerable:
>
> WARNING: at kernel/ptrace.c:515 ptrace_report_signal+0x2c1/0x2d0()

Yes, ptrace-over-utrace needs more work. But your message looks as if
utrace core is buggy, imho this is a bit unfair ;)

As Roland said, ptrace-over-utrace is not ready yet. If you mean that
utrace core should not be merged alone - this is another story.

But personally I understand why Roland sends utrace core before changing
ptrace.

Oleg.

