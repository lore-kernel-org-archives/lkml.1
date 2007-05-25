Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbXEYH6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbXEYH6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXEYH62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:58:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54697 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXEYH61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:58:27 -0400
Date: Fri, 25 May 2007 09:58:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched_clock(): cleanups
Message-ID: <20070525075824.GD8094@one.firstfloor.org>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525072512.GA12683@elte.hu> <20070525072641.GA13025@elte.hu> <a781481a0705250035q2173234dp4f6cc4d103fced5c@mail.gmail.com> <1180078773.7348.31.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180078773.7348.31.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 09:39:33AM +0200, Peter Zijlstra wrote:
> On Fri, 2007-05-25 at 13:05 +0530, Satyam Sharma wrote:
> > On 5/25/07, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > call_r_s_f() still needs an urgent rerenaming though =B-)
> > 
> > So does "call_r_s_f_here()" :-)
> 
> That name makes me think of INTERCAL's 'DO COME FROM' statement.
> And any code that makes one think of INTERCAL is say,.. special.. :-)

Propose a better way to code this then? It's not my fault that dealing with 
callbacks in C is so messy. _here just massages one callback
prototype (smp_call_function's) into another (cpufreq's) because
both callbacks do the same in this case.

The r_s_f BTW stands for resync_sc_freq which is a function earlier 
in the file and should be familiar to a serious reader.

-Andi

