Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbYDVKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbYDVKK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbYDVKKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:10:19 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46942 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760154AbYDVKKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:10:18 -0400
Date: Tue, 22 Apr 2008 13:09:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0.01/1] hlist_for_each_entry_xxx: kill the "pos" argument
Message-ID: <20080422090921.GA130@tv-sign.ru>
References: <20080421151443.GA29670@tv-sign.ru> <20080422013302.GJ9153@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422013302.GJ9153@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21, Paul E. McKenney wrote:
>
> On Mon, Apr 21, 2008 at 07:14:43PM +0400, Oleg Nesterov wrote:
> > (The actual patch is huge, 116K, I'll send it offline. This email contains
> >  the chunk for list.h only).
> > 
> > COMPILE TESTED ONLY (make allyesconfig).
> > 
> > All hlist_for_each_entry_xxx() macros require the "pos" argument, which is not
> > actually needed and can be removed. See the changes in include/linux/list.h
> > (note that hlist_for_each_entry_safe() now does prefetch() too).
> 
> Might it be better to do this in two
> phases to allow these patches to be applied incrementally?
> 
> 1.	Change all to "obsolete" __hlist_for_each_entry_xxx().
> 
> 2.	Incrementally change to hlist_for_each_entry_xxx(), removing
> 	the extra variable where possible.

Yes sure. Actually this was my initial plan.

Andrew, which way do you prefer? and should I wait for -rc1?

Oleg.

