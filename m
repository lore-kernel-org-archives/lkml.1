Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbXIYLF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbXIYLF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXIYLFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:05:49 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:53612 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbXIYLFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:05:48 -0400
Date: Tue, 25 Sep 2007 13:05:44 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070925130544.3d74d04d@twins>
In-Reply-To: <20070924212058.76017e47@lappy>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	<46F7B7FD.1000905@linux.vnet.ibm.com>
	<20070924094448.d08cf3a6.akpm@linux-foundation.org>
	<20070924185737.717b2650@twins>
	<46F7EEF3.7080902@linux.vnet.ibm.com>
	<20070924212058.76017e47@lappy>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 21:20:58 +0200 Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:

> > > Nope, and the stacktrace is utterly puzzling.
> > > 
> > > /me goes read the lkml.org link
> > > 
> > > Kamalesh Babulal: do you still get:
> > >   BUG: spinlock bad magic on
> > > 
> > > msgs?
> > > 
> > > Because those I could reproduce using fsx, and I fixed all that.
> > Hi Peter,
> > 
> > I do not get BUG: spinlock bad magic messages any more, but the softlock message is
> > thrown more than 30 time, while running the ltp runall.
> 
> It would be good to know what function on_each_cpu is executing, could
> you try something like:

I've just completed 2 full ltp runs on a dual-core opteron machine but
could not reproduce this problem.

Kamalesh, would it be possible for you to reproduce with that patch, so
we can see what function is holding up the cpu?
