Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbYHULXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbYHULXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbYHULXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:23:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58798 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbYHULXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:23:03 -0400
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
	load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, vatsa <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080821111713.GA15680@elte.hu>
References: <1219310330.8651.93.camel@twins>
	 <20080821104718.GA28331@elte.hu>  <20080821111713.GA15680@elte.hu>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 13:22:46 +0200
Message-Id: <1219317766.8651.110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 13:17 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > This patch tries to solve this issue by accounting the time spend on 
> > > both Real-Time tasks and IRQ handling, and using that to 
> > > proportionally inflate the SCHED_OTHER load.
> > 
> > applied it to tip/sched/devel for more testing.
> 
> -tip testing found that it wouldnt build on UP in sched_debug.c - made 
> that bit dependent on CONFIG_SMP. sched_scale_load() does not seem to be 
> too meaningful on UP.

Thanks - just prior to posting I removed the empty stub for
sched_scale_load() because it didn't make sense for UP code to use it...

So much for double checking myself.

