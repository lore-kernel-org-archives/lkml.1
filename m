Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYH1LsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYH1LsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYH1LsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:48:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51376 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYH1Lr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:47:59 -0400
Date: Thu, 28 Aug 2008 13:50:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828115035.GM26610@one.firstfloor.org>
References: <20080819103301.787700742@chello.nl> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> <874p57s873.fsf@basil.nowhere.org> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu> <20080828110923.GL26610@one.firstfloor.org> <1219922353.6443.14.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219922353.6443.14.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 01:19:13PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-08-28 at 13:09 +0200, Andi Kleen wrote:
> > > Even if the system has multiple CPUs, and even if just a single CPU is 
> > > fully utilized by an RT task, without the rt-limit the system will still 
> > > lock up in practice due to various other factors: workqueues and tasks 
> > > being 'stuck' on CPUs that host an RT hog. 
> > 
> > The load balancer will not notice that a particular CPU is busy
> > with real time tasks?
> 
> Not currently, working on that though.

I wonder if it would make sense to break affinities in extreme case?
With that even the workqueues would work again.

-Andi

-- 
ak@linux.intel.com
