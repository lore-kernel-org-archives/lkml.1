Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZBJNEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZBJNEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZBJNEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:04:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbZBJNEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:04:25 -0500
Date: Tue, 10 Feb 2009 14:04:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] git pull request for tip/tracing/urgent
Message-ID: <20090210130411.GB8341@elte.hu>
References: <20090209151744.459736868@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209151744.459736868@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Here's the changes by Lai. The bug scared me enough to investigate
> it further, to see if we had other bug reports that this could
> have fixed. But I found out that ring_buffer_read_page currently
> does not have any users. The only user I have is for my splice work,
> which has not been included yet.
> 
> I guess Lai is adding one. These are true bug fixes to code that
> is in the kernel, even if that code is currently "dead code". But I think
> they should still be included in 29, since this will reflect on ftrace
> when we have developers starting to use it (such as Lai).
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/tracing/urgent/devel

hm, the branch does not exist anymore:

  fatal: Couldn't find remote ref tip/tracing/urgent/devel
  fatal: Couldn't find remote ref tracing/urgent/devel
  fatal: Couldn't find remote ref tracing/urgent

In any case, please include this in the devel path not the urgent path.
Urgent patches are for real regressions that occur with the upstream
kernel and affect users. New uses of tracing code should be done on
top of the tracing tree.

	Ingo
