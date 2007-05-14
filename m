Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbXENLTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbXENLTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758358AbXENLTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:19:34 -0400
Received: from holomorphy.com ([66.93.40.71]:50455 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbXENLTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:19:33 -0400
Date: Mon, 14 May 2007 04:20:16 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514112016.GW19966@holomorphy.com>
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com> <20070514112259.GC28348@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514112259.GC28348@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 04:05:00AM -0700, William Lee Irwin III wrote:
>> The variability in ->fair_clock advancement rate was the mistake, at
>> least according to my way of thinking. The queue's virtual time clock
>> effectively stops under sufficiently high load, possibly literally in
>> the event of fixpoint underflow. 

On Mon, May 14, 2007 at 04:52:59PM +0530, Srivatsa Vaddagiri wrote:
> [snip]

On Mon, May 14, 2007 at 04:05:00AM -0700, William Lee Irwin III wrote:
>> Basically it needs to move closer to EEVDF in these respects.

On Mon, May 14, 2007 at 04:52:59PM +0530, Srivatsa Vaddagiri wrote:
> Doesn't EEVDF have the same issue? From the paper:
> 	V(t) = 1/(w1 + w2 + ...wn)

Who knows what I was smoking, then. I misremembered the scale factor
as being on the other side of comparisons with the queue's clock. I'm
suspicious of EEVDF's timekeeping now as well.


-- wli
