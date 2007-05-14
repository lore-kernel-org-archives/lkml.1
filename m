Return-Path: <linux-kernel-owner+w=401wt.eu-S965992AbXENLPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965992AbXENLPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXENLPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:15:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37089 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbXENLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:15:08 -0400
Date: Mon, 14 May 2007 16:52:59 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514112259.GC28348@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514110500.GV19966@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 04:05:00AM -0700, William Lee Irwin III wrote:
> The variability in ->fair_clock advancement rate was the mistake, at
> least according to my way of thinking. The queue's virtual time clock
> effectively stops under sufficiently high load, possibly literally in
> the event of fixpoint underflow. 

[snip]

> Basically it needs to move closer to EEVDF in these respects.

Doesn't EEVDF have the same issue? From the paper:

	V(t) = 1/(w1 + w2 + ...wn)

-- 
Regards,
vatsa
