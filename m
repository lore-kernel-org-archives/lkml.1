Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbYAKMms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbYAKMms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbYAKMml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:42:41 -0500
Received: from brick.kernel.dk ([87.55.233.238]:25129 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065AbYAKMmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:42:40 -0500
Date: Fri, 11 Jan 2008 13:42:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Dillow <dillowda@ornl.gov>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080111124236.GV6258@kernel.dk>
References: <1199996752.9159.46.camel@lap75545.ornl.gov> <20080110234438.4826f658@inria.fr> <1200020661.5099.3.camel@obelisk.thedillows.org> <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu> <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu> <20080111122802.GT6258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111122802.GT6258@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2008, Jens Axboe wrote:
> > ktime_get() should have been used instead, which is a proper GTOD 
> > clocksource. The patch below implements this.
> 
> Will give it a whirl, it looks promising indeed and gets rid of the ugly
> cpu sync stuff. What is the cost of ktime_get() compared to
> sched_clock()?

Works for me - will apply it right now, we can always evaluate any
potential performance impact later. It's more important to have a
functional blktrace in 2.6.24.

Thanks Ingo!

-- 
Jens Axboe

