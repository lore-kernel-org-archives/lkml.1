Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXHJRMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXHJRMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXHJRMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:12:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbXHJRMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:12:39 -0400
Date: Fri, 10 Aug 2007 10:12:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Adrian Bunk <bunk@kernel.org>, Josh Triplett <josh@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-Id: <20070810101212.d59ce24a.akpm@linux-foundation.org>
In-Reply-To: <20070810151208.GC8511@linux.vnet.ibm.com>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
	<20070810013146.GD18938@stusta.de>
	<20070810020040.GK8424@linux.vnet.ibm.com>
	<20070809190623.f60dcf70.akpm@linux-foundation.org>
	<20070810151208.GC8511@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 08:12:08 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > One used to use sched_clock() for this, then get frowned at.  Now we
> > have cpu_clock()...
> 
> Hmmm...  And cpu_clock() is not in 2.6.22, so must appear in some later
> release.  Which means that the rate of API change in this area is a
> bit high, so I should avoid it like the plague.

eh, it's been there for weeks.  It is dust-encrusted.

>  Therefore, I should
> look for some other convenient source of entropy.
> 
> One convenient source would the per-CPU statistics that rcutorture
> maintains.  Of course, a given CPU's RNG is nearly in lock-step with
> its own statistics, but not with the adjacent CPU's statistics...
> 
> I will send a patch.

Please use cpu_clock().  It ain't going away.
