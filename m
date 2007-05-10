Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbXEJJUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbXEJJUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXEJJUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:20:46 -0400
Received: from brick.kernel.dk ([80.160.20.94]:22262 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbXEJJUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:20:45 -0400
Date: Thu, 10 May 2007 11:20:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 10/10] Port of blktrace to the Linux Kernel Markers.
Message-ID: <20070510092015.GJ4629@kernel.dk>
References: <20070510015555.973107048@polymtl.ca> <20070510020918.085866258@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510020918.085866258@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09 2007, Mathieu Desnoyers wrote:
> Here is a proof of concept patch, for demonstration purpose, of moving
> blktrace to the markers.
> 
> A few remarks : this patch has the positive effect of removing some code
> from the block io tracing hot paths, minimizing the i-cache impact in a
> system where the io tracing is compiled in but inactive.
> 
> It also moves the blk tracing code from a header (and therefore from the
> body of the instrumented functions) to a separate C file.
> 
> There, as soon as one device has to be traced, every devices have to
> fall into the tracing function call. This is slower than the previous
> inline function which tested the condition quickly. If it becomes a
> show stopper, it could be fixed by having the possibility to test a
> supplementary condition, dependant of the marker context, at the marker
> site, just after the enable/disable test.

Did you benchmark it?

-- 
Jens Axboe

