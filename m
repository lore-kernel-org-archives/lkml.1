Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbXI1JXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbXI1JXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbXI1JWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:22:53 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2217 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbXI1JWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:22:52 -0400
Date: Fri, 28 Sep 2007 10:22:35 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928092235.GA31180@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928020132.f6c6f528.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 02:01:32AM -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 10:40:03 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i ran it over kernel/sched.c and there are many bogus warnings that i 
> > reported to you earlier:
> > 
> >   WARNING: multiple assignments should be avoided
> >   #2319:
> >   +       max_load = this_load = total_load = total_pwr = 0;
> 
> That warning is non-bogus, although this is one of the bogosities which
> I personally don't bother fixing or making a fuss about.
> 
> But I do think it detracts from the readability of the code, and from
> patches which later alter that code.  A bit.

I tend to agree, watching the automatic replies from checkpatch, the
majority of these are "justifiable" in their context.  I think I'll
lower this one to a CHECK in the next release.

-apw
