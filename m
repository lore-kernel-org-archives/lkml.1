Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYH1LTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYH1LTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYH1LTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:19:23 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13686 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYH1LTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:19:23 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080828110923.GL26610@one.firstfloor.org>
References: <20080819103301.787700742@chello.nl>
	 <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de>
	 <874p57s873.fsf@basil.nowhere.org>
	 <200808272008.16106.nickpiggin@yahoo.com.au>
	 <20080828105408.GA4488@elte.hu> <20080828110923.GL26610@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 13:19:13 +0200
Message-Id: <1219922353.6443.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 13:09 +0200, Andi Kleen wrote:
> > Even if the system has multiple CPUs, and even if just a single CPU is 
> > fully utilized by an RT task, without the rt-limit the system will still 
> > lock up in practice due to various other factors: workqueues and tasks 
> > being 'stuck' on CPUs that host an RT hog. 
> 
> The load balancer will not notice that a particular CPU is busy
> with real time tasks?

Not currently, working on that though.

