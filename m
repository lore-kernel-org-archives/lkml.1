Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbYKGVg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbYKGVg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYKGVgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:36:39 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:50831 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYKGVgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:36:38 -0500
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
	context)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1226085407.31966.58.camel@lappy.programming.kicks-ass.net>
References: <1226083858.20569.14.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
	 <1226085407.31966.58.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 13:35:10 -0800
Message-Id: <1226093710.20569.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 20:16 +0100, Peter Zijlstra wrote:
> On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> > Peter, I think we've seen this before. It is the highmem code sleeping.
> 
> I've been working on an alternative kmap_atomic implementation for -rt,
> the below has been build and booted but not stressed, anybody care to
> give it a spin ?

I'll give it a try. Anything in particular I should try to do? Or not
do? Or watch for?

-- Fernando


> ---
>  arch/x86/mm/highmem_32.c  |  130 ++++++++++++++++++++++++++++++++++++++++++---
>  include/asm-x86/highmem.h |   11 ----
>  include/linux/sched.h     |    5 ++
>  kernel/sched.c            |   10 ++++
>  4 files changed, 137 insertions(+), 19 deletions(-)
>  [MUNCH]


