Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZAQElt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZAQElt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 23:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbZAQElk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 23:41:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbZAQEli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 23:41:38 -0500
Date: Fri, 16 Jan 2009 20:40:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler fixes
Message-Id: <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
In-Reply-To: <1231964647.14825.59.camel@laptop>
References: <20090111144305.GA7154@elte.hu>
	<20090114121521.197dfc5e.akpm@linux-foundation.org>
	<1231964647.14825.59.camel@laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 21:24:07 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-01-14 at 12:15 -0800, Andrew Morton wrote:
> > On Sun, 11 Jan 2009 15:43:05 +0100
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > Please pull the latest sched-fixes-for-linus git tree
> > 
> > In http://bugzilla.kernel.org/show_bug.cgi?id=12309 the reporters have
> > identified what appears to be a sched-related performance regression. 
> > A fairly long-term one - post-2.6.18, perhaps.
> > 
> > Testcase code has been added today.  Could someone please take a look
> > sometime?
> 
> There appear to be two different bug reports in there. One about iowait,
> and one I'm not quite sure what it is about.
> 
> The second thing shows some numbers and a test case, but I fail to see
> what the problem is with it.

I had no problem seeing the problem: a gigantic performance regression
in two CPU-scheduler intensive workloads.

I can see some other problems, too.
