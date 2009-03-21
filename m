Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbZCUXks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbZCUXks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 19:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZCUXkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 19:40:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbZCUXkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 19:40:39 -0400
Date: Sat, 21 Mar 2009 19:38:39 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321233839.GB5157@redhat.com>
References: <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090321222030.GA5157@redhat.com> <20090321223759.GA22770@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321223759.GA22770@x200.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sun, Mar 22, 2009 at 01:37:59AM +0300, Alexey Dobriyan wrote:
> [...]
> struct task_struct::utrace became embedded struct. This is good and
> should remove quite a few of utrace bugs. Better late than never.

Yeah.

> However, "rewrite-ptrace-via-utrace" patch was omitted, so almost
> noone can easily see by how much situation improved. [...]  Will
> ptrace(2) will be rewritten through utrace?

Yes, I believe that is Roland's intent.  I believe it was separated
from the current suite of patches for staging purposes, to merge the
most solid code up first.  The code is available from the utrace git
tree in the utrace-ptrace branch.

- FChE
