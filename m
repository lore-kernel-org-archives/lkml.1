Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbXENX53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbXENX53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXENX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:57:23 -0400
Received: from holomorphy.com ([66.93.40.71]:54449 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbXENX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:57:22 -0400
Date: Mon, 14 May 2007 16:57:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, efault@gmx.de, tingy@cs.umass.edu,
       linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
Message-ID: <20070514235759.GN31925@holomorphy.com>
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com> <20070514112259.GC28348@in.ibm.com> <20070514112016.GW19966@holomorphy.com> <20070514120405.GA3364@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514120405.GA3364@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III <wli@holomorphy.com> wrote:
>> [...] I'm suspicious of EEVDF's timekeeping now as well.

On Mon, May 14, 2007 at 02:04:05PM +0200, Ingo Molnar wrote:
> well, EEVDF is a paper-only academic scheduler, one out of thousands 
> that never touched real hardware. For nearly every mathematically 
> possible scheduling algorithm i suspect there's at least one paper out 
> there already describing it ;-) But this time the EEVDF paper got it 
> right and you got it wrong. But really, if you want to make an impact on 
> how CFS looks like then please try it and send test feedback and/or 
> patches - not words. =B-)

Perhaps the paper was inspired by preexisting code. Perhaps the code
dated back to the 70's.

The weight consistency testcase is largely done on account of Davide
Libenzi's already having written such a load generator apart from
incorporating the already-written code to postprocess the results.

I have no particular need to rely on the cfs patches for whatever
scheduler patches I'd care to write. I suppose I could write some if
I feel particularly inspired. Code review is not my forte anyway.


-- wli
