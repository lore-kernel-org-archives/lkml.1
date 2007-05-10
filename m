Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXEJC1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXEJC1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbXEJC1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:27:25 -0400
Received: from waste.org ([66.93.16.53]:46018 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbXEJC1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:27:25 -0400
Date: Wed, 9 May 2007 21:27:07 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, clameter@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070510022707.GO11115@waste.org>
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070508.185141.85412154.davem@davemloft.net> <46412BB5.1060605@yahoo.com.au> <20070509174238.b4152887.akpm@linux-foundation.org> <46426EA1.4030408@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46426EA1.4030408@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:00:17AM +1000, Nick Piggin wrote:
> Andrew Morton wrote:
> >On Wed, 09 May 2007 12:02:29 +1000
> >Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >
> >
> >>BTW, we _really_ should be doing RCU properly in slob, because you
> >>technically can't noop RCU on UP (even though the current users may be
> >>safe...).
> >>
> >>Patch attached to do that.
> >
> >
> >Does it work?
> 
> That one booted my desktop (very slowly) but as Matt pointed out, it broke
> alignment on RCU slabs. The last version I posted should work and has the
> alignment problem fixed. I can retest and resubmit it to you if you like,
> I was just waiting on an ack from Matt.

Looks good to me, but haven't had time to actually test it.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
