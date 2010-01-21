Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248Ab0AUMTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0AUMTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055Ab0AUMTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:19:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0AUMTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:19:10 -0500
Date: Thu, 21 Jan 2010 07:19:04 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       hch@infradead.org, xfs-masters@oss.sgi.com,
       Reinhard.Tartler@informatik.uni-erlangen.de,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Obsolete config in kernel build system (XFS_TRACE)
Message-ID: <20100121121904.GA1082@infradead.org>
References: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de> <20100120224626.GP14035@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120224626.GP14035@discord.disaster>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 09:46:26AM +1100, Dave Chinner wrote:
> Christoph's conversion to use the kernel trace infrastructure is
> a work in progress. It's no small task - he's converted around 220
> trace points points so far.
> 
> However, the btree tracing code has not been converted yet. IIRC
> this is because the kernel trace code didn't have the required
> infrastructure at the time of initial conversion. Hence the old code
> has not yet been completely removed because the conversion is not
> yet complete.  It will go away when the conversion is completed.

The btree ones are rather difficult because it will require attaching
difference events to a single tracepoint and filter on which one
we want, so it may take a bit of time.

The existing xfs_btree_trace.c won't be much use for that and if we
really need it we can look at it in git history.

Christoph, can you send a properly signed off patch to kill
xfs_btree_trace.c and and the #ifdef XFS_BTREE_TRACE code in
xfs_btree_trace.h?
