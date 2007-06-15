Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXFOPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXFOPGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbXFOPGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:06:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40497 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbXFOPGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:06:06 -0400
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
	Blocksize support
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20070614150417.c73fb6b9.akpm@linux-foundation.org>
References: <20070614193839.878721298@sgi.com>
	 <20070614130645.cabdff1b.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	 <20070614143248.736312f8.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
	 <20070614150417.c73fb6b9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 10:05:59 -0500
Message-Id: <1181919959.10658.9.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 15:04 -0700, Andrew Morton wrote:
> > On Thu, 14 Jun 2007 14:37:33 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > On Thu, 14 Jun 2007, Andrew Morton wrote:
> > 
> > > We want the 100% case.
> > 
> > Yes that is what we intend to do. Universal support for larger blocksize. 
> > I.e. your desktop filesystem will use 64k page size and server platforms 
> > likely much larger.
> 
> With 64k pagesize the amount of memory required to hold a kernel tree (say)
> will go from 270MB to 1400MB.   This is not an optimisation.
> 
> Several 64k pagesize people have already spent time looking at various
> tail-packing schemes to get around this serious problem.  And that's on
> _server_ class machines.  Large ones.  I don't think
> laptop/desktop/samll-server machines would want to go anywhere near this.

I'm one of the ones investigating 64 KB pagesize tail-packing schemes,
and I believe Christoph's cleanups will reduce the intrusiveness and
improve the readability of a tail-packing solution.  I'll add my vote in
support of these patches.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

