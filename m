Return-Path: <linux-kernel-owner+w=401wt.eu-S932188Ab0AVCHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0AVCHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932159Ab0AVCHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:07:13 -0500
Received: from ozlabs.org ([203.10.76.45]:53968 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab0AVCHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:07:12 -0500
Date: Fri, 22 Jan 2010 13:04:08 +1100
From: Anton Blanchard <anton@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix inconsistency between IP and callchain
 sampling
Message-ID: <20100122020408.GC2860@kryten>
References: <20100118054707.GT12666@kryten>
 <20100118104305.GA5256@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118104305.GA5256@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Frederic,

> Concerning interrupts that happen in idle, I think we should filter
> these if exclude_idle = 1. That looks more something a user may
> want: if we don't want to profile idle, neither do we want to encumber with
> interrupts that occur inside. On the opposite, if someone wants a finegrained
> profile, let's get idle and its interrupts.
> 
> What do you guys think about that?

Yeah that sounds reasonable to me. Thanks for looking into it!

Anton
