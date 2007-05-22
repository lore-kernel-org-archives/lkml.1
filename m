Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbXEVUMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbXEVUMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbXEVUMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:12:47 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7585 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbXEVUMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:12:47 -0400
Date: Tue, 22 May 2007 22:10:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070522201012.GA4705@kernel.dk>
References: <559665.2852.qm@web52608.mail.re2.yahoo.com> <Pine.LNX.4.64.0705221358360.4904@blonde.wat.veritas.com> <20070522153622.GZ4705@kernel.dk> <Pine.LNX.4.64.0705221129151.29456@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705221129151.29456@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22 2007, Christoph Lameter wrote:
> On Tue, 22 May 2007, Jens Axboe wrote:
> 
> > > You've made no mention of trying the patch I sent yesterday, or better,
> > > the patch Christoph replied with to replace it.  Please clarify whether
> > > you're getting the above after applying one of those patches - thanks.
> > 
> > Christophs patch works for me!
> 
> So you are able to run slub with the patch and 
> 
> 1. CONFIG_NUMA set (CONFIG_SMP works fine here too)
> 
> 2. CONFIG_LOCKDEP
> 
> 3. CONFIG_DEBUG_LOCK_ALLOCS
> 
> ?
> 
> That fails here.

I didn't say that. Previously a kernel without SLUB_DEBUG set would not
work, with the patch it does. That is all I tested so far.

-- 
Jens Axboe

