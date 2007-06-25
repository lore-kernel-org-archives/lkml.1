Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbXFYGU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbXFYGU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 02:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXFYGUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 02:20:51 -0400
Received: from waste.org ([66.93.16.53]:41548 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbXFYGUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 02:20:51 -0400
Date: Mon, 25 Jun 2007 01:20:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slob: poor man's NUMA support.
Message-ID: <20070625062036.GJ11115@waste.org>
References: <20070619090616.GA23697@linux-sh.org> <467F5E14.5030401@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467F5E14.5030401@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 04:17:56PM +1000, Nick Piggin wrote:
> Paul Mundt wrote:
> >This adds preliminary NUMA support to SLOB, primarily aimed at systems
> >with small nodes (tested all the way down to a 128kB SRAM block), whether
> >asymmetric or otherwise.
> 
> Fine by me as well, FWIW. My points about per-cpu/node queues were not
> to say that I'm really opposed to getting this in first. In a way, you
> sell yourself short with the patch name: the implementation may be just
> a basic one, but simplicity is a key point of SLOB... Adding numa
> awareness to the slob APIs is obviously a key step and makes it much
> easier to experiment with enhancements to the implementation.
> 
> Unless it has been picked up already, I'd call it "initial NUMA support"
> ;) Thanks! Would be great to hear about your experiences using SLOB as
> well -- how much memory you're saving, how it performs, etc.

I haven't seen the usual echo from Andrew, so I think Paul should
resend it with three Acked-bys.

-- 
Mathematics is the supreme nostalgia of our time.
