Return-Path: <linux-kernel-owner+w=401wt.eu-S966233AbYD1SuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966233AbYD1SuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966112AbYD1Sty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:49:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966082AbYD1Stx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:49:53 -0400
Date: Mon, 28 Apr 2008 14:49:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
	sched-devel.git
Message-ID: <20080428184935.GA1205@infradead.org>
References: <20080424150324.802695381@polymtl.ca> <1209238735.6441.4.camel@lappy> <20080428113610.b2d1e8e4.akpm@linux-foundation.org> <20080428184050.GA23391@infradead.org> <20080428114758.bcc08eef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428114758.bcc08eef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:47:58AM -0700, Andrew Morton wrote:
> > On Mon, Apr 28, 2008 at 11:36:10AM -0700, Andrew Morton wrote:
> > > It hides the cosmetically-ugly bits, but not the deeply ugly: each of these
> > > trace points is an extension to the kernel->userspace API, with all that
> > > this implies.
> > 
> > Not at all.  It's only accessibe to kernel code, so it per defintion
> > can't be a userspace API.
> 
> eh?  It adds human-readable printk strings.

It looks like a printk string but it isn't.  You need a kernel module
to actually connect to it and do the tracing.
