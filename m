Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbXIRQNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbXIRQNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 12:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbXIRQNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 12:13:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49725 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050AbXIRQNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 12:13:40 -0400
Date: Tue, 18 Sep 2007 09:13:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070918161337.GC8665@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070918091728.GA6766@localhost.sw.ru> <20070918031723.05689e92.akpm@linux-foundation.org> <46EFA8DC.2020909@bull.net> <20070918033400.495b02dd.akpm@linux-foundation.org> <20070918142451.418b3b51@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918142451.418b3b51@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 02:24:51PM +0200, Peter Zijlstra wrote:
> On Tue, 18 Sep 2007 03:34:00 -0700 Andrew Morton
> <akpm@linux-foundation.org> wrote:
> 
> > Well, it was an optimisation.  spin_lock() implies rcu_read_lock().  That's
> > a bit dirty and we might choose to not do that.
> 
> Not true for the preemptible-rcu work. All such sites should be fixed,
> or at the very least heavily annotated.

What he said!!!

							Thanx, Paul
