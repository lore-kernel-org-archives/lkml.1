Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbYF0UxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbYF0UxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763446AbYF0Uv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:51:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:50181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152AbYF0Uvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:51:52 -0400
Subject: Re: [PATCH 0/3] sched: newidle and RT wake-buddy fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, npiggin@suse.de, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
References: <20080627202444.3829.21595.stgit@lsg.lsg.lab.novell.com>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 22:51:36 +0200
Message-Id: <1214599896.12348.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 14:29 -0600, Gregory Haskins wrote:
> Hi Ingo,
>   The following patches apply to linux-tip/sched/devel and enhance the
> performance of the kernel (specifically in PREEMPT_RT, though they do
> not regress mainline performance as far as I can tell).  They offer
> somewhere between 50-100% speedups in netperf performance, depending
> on the test.
> 
> Should you be interested in these patches, you can optionally pull them
> from git at the following URL:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git sched-devel
> 
> Comments/feedback/bugfixes welcome

Seem reasonable to me,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

