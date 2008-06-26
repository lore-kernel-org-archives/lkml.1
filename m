Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbYFZVnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbYFZVnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYFZVnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:43:11 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10123 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbYFZVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:43:10 -0400
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <48640C04.9020600@firstfloor.org>
References: <20080625191100.GI21892@dirshya.in.ibm.com>
	 <87k5gcqpbm.fsf@basil.nowhere.org> <4863AF57.3040005@linux.vnet.ibm.com>
	 <4863DB29.1020304@firstfloor.org>
	 <20080626185254.GA12416@dirshya.in.ibm.com>
	 <4863F93C.9040102@firstfloor.org> <20080626210025.GB26167@in.ibm.com>
	 <48640C04.9020600@firstfloor.org>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 23:43:04 +0200
Message-Id: <1214516584.12265.10.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 23:37 +0200, Andi Kleen wrote:
> Dipankar Sarma wrote:
> 
> > Some workload managers already do that - they provision cpu and memory
> > resources based on request rates and response times. Such software is
> > in a better position to make a decision whether they can live with
> > reduced performance due to power saving mode or not. The point I am
> > making is the the kernel doesn't have any notion of transactional
> > performance 
> 
> The kernel definitely knows about burstiness vs non burstiness at least
> (although it currently has no long term memory for that). Does it need
> more than that for this? Anyways if nice levels were used that is not
> even needed, because it's ok to run niced processes slower.
> 
> And your workload manager could just nice processes. It should probably
> do that anyways to tell ondemand you don't need full frequency.

Except that I want my nice 19 distcc processes to utilize as much cpu as
possible, but just not bother any other stuff I might be doing...



