Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbZAQIwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbZAQIwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 03:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZAQIw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 03:52:28 -0500
Received: from viefep16-int.chello.at ([62.179.121.36]:18548 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbZAQIw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 03:52:27 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 09:52:31 +0100
Message-Id: <1232182351.7141.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 20:40 -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2009 21:24:07 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2009-01-14 at 12:15 -0800, Andrew Morton wrote:
> > > On Sun, 11 Jan 2009 15:43:05 +0100
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > Please pull the latest sched-fixes-for-linus git tree
> > > 
> > > In http://bugzilla.kernel.org/show_bug.cgi?id=12309 the reporters have
> > > identified what appears to be a sched-related performance regression. 
> > > A fairly long-term one - post-2.6.18, perhaps.
> > > 
> > > Testcase code has been added today.  Could someone please take a look
> > > sometime?
> > 
> > There appear to be two different bug reports in there. One about iowait,
> > and one I'm not quite sure what it is about.
> > 
> > The second thing shows some numbers and a test case, but I fail to see
> > what the problem is with it.
> 
> I had no problem seeing the problem: a gigantic performance regression
> in two CPU-scheduler intensive workloads.

Right, but it wasn't clearly stated what the issue was, and there seem
to be two with that testcase

 1) the total running time increases
 2) it causes some severe latency spikes

Now why it was stuck in with that iowait thing I have no clue, as it
doesn't do anything with iowait, I ran the thing (well, both things) and
iowait is 0%.

Of course we'll try and fix these issues -- but as far as I'm concerned
its utterly unrelated to the iowait thing.

> I can see some other problems, too.

The universe is full of problems, mixing them all up doesn't get us
anywhere.

