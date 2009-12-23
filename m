Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZLWImp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZLWImp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZLWImo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:42:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZLWImn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:42:43 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <4B31B508.5040903@garzik.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org>
	 <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org>
	 <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org>
	 <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org>
	 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>
	 <20091223060229.GA14805@elte.hu>  <4B31B508.5040903@garzik.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 09:41:14 +0100
Message-ID: <1261557674.4937.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 01:13 -0500, Jeff Garzik wrote:
> On 12/23/2009 01:02 AM, Ingo Molnar wrote:
> > One key thing i havent seen in this discussion are actual measurements. I
> > think a lot could be decided by simply testing this patch-set, by looking at
> > the hard numbers: how much faster (or slower) did a particular key workload
> > get before/after these patches.
> 
> We are dealing with situations where drivers are using workqueues to 
> provide a sleep-able context, and trying to solve problems related to that.

So why are threaded interrupts not considered? Isn't the typical atomic
context of drivers the IRQ handler?

