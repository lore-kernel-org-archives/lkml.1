Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbXEYHcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbXEYHcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXEYHcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:32:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40712 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXEYHcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:32:04 -0400
Date: Fri, 25 May 2007 09:31:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups
Message-ID: <20070525073158.GB8094@one.firstfloor.org>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> if (!f)
> 	f = cpufreq_get(freq->cpu);
> if (!f)
> 	f = tsc_khz;
> 
> ?
> 
> Something's not quite right here :-)

What do you think is wrong? cpufreq_get can return 0.

Admittedly the second test could be inside a block of the first,
but then it would make the code more ugly and this code is not
performance critical.

-Andi
