Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbZCNDos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbZCNDos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 23:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZCNDoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 23:44:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:43158 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbZCNDoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 23:44:38 -0400
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>, prasad@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090311121220.GI2282@elte.hu>
References: <20090310172605.GA28767@elte.hu>
	 <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org>
	 <20090311121220.GI2282@elte.hu>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 14:43:23 +1100
Message-Id: <1237002203.25062.80.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 13:12 +0100, Ingo Molnar wrote:
> 
> #3 is probably the most informative (and hence probably the
>    best) variant. It also leaves policy of how to resolve the 
>    conflict to the admin.

Agreed.
> 
> Would be nice to have it simple. Reluctance regarding this 
> patchset is mostly rooted in that diffstat above.
> 
> The changes it does in the x86 architecture code are nice 
> generalizations and cleanups. Both the scheduler, task 
> startup/exit and ptrace bits look pretty sane in terms of 
> factoring out debug register details. But the breakpoint 
> management looks very complex

I agree there is some interest in generalization and cleanup, especially
as far as userspace APIs go, though it's a hard nut to crack as every
CPU family out there has some subtle differences in the way breakpoints
or watchpoints work (for example, alignment constraints, ability to do
ranges, the way they handle kernel vs. user, etc...)

I'm not yet sold.

Cheers,
Ben.

