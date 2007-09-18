Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbXIRRJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbXIRRJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbXIRRJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:09:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758903AbXIRRJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:09:27 -0400
Date: Tue, 18 Sep 2007 09:57:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-Id: <20070918095715.05899d12.akpm@linux-foundation.org>
In-Reply-To: <20070918161337.GC8665@linux.vnet.ibm.com>
References: <20070918091728.GA6766@localhost.sw.ru>
	<20070918031723.05689e92.akpm@linux-foundation.org>
	<46EFA8DC.2020909@bull.net>
	<20070918033400.495b02dd.akpm@linux-foundation.org>
	<20070918142451.418b3b51@twins>
	<20070918161337.GC8665@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 09:13:37 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Sep 18, 2007 at 02:24:51PM +0200, Peter Zijlstra wrote:
> > On Tue, 18 Sep 2007 03:34:00 -0700 Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > 
> > > Well, it was an optimisation.  spin_lock() implies rcu_read_lock().  That's
> > > a bit dirty and we might choose to not do that.
> > 
> > Not true for the preemptible-rcu work. All such sites should be fixed,
> > or at the very least heavily annotated.
> 
> What he said!!!
> 

What he said!

How are you going to find all such sites?
