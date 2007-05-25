Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbXEYIRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbXEYIRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXEYIQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:16:55 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:40706 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936AbXEYIQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:16:54 -0400
Subject: Re: [patch] sched_clock(): cleanups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070525075824.GD8094@one.firstfloor.org>
References: <20070525071005.GA6431@elte.hu>
	 <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
	 <20070525072512.GA12683@elte.hu> <20070525072641.GA13025@elte.hu>
	 <a781481a0705250035q2173234dp4f6cc4d103fced5c@mail.gmail.com>
	 <1180078773.7348.31.camel@twins> <20070525075824.GD8094@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 25 May 2007 10:16:39 +0200
Message-Id: <1180081000.7348.39.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 09:58 +0200, Andi Kleen wrote:
> On Fri, May 25, 2007 at 09:39:33AM +0200, Peter Zijlstra wrote:
> > On Fri, 2007-05-25 at 13:05 +0530, Satyam Sharma wrote:
> > > On 5/25/07, Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > call_r_s_f() still needs an urgent rerenaming though =B-)
> > > 
> > > So does "call_r_s_f_here()" :-)
> > 
> > That name makes me think of INTERCAL's 'DO COME FROM' statement.
> > And any code that makes one think of INTERCAL is say,.. special.. :-)
> 
> Propose a better way to code this then? It's not my fault that dealing with 
> callbacks in C is so messy. _here just massages one callback
> prototype (smp_call_function's) into another (cpufreq's) because
> both callbacks do the same in this case.

I see you point; however a function called:
call_<some_other_function>_here() just doesn't make sense. It says as
much as: we should call some_other_function() but for some reason we
dont.

> The r_s_f BTW stands for resync_sc_freq which is a function earlier 
> in the file and should be familiar to a serious reader.

It was.

