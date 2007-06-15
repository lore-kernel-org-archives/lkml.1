Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXFOA3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXFOA3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbXFOA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:29:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42909 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868AbXFOA3n (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:29:43 -0400
Date: Fri, 15 Jun 2007 10:29:31 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Message-ID: <20070615002931.GI86004887@sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com> <20070614143248.736312f8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com> <20070614150417.c73fb6b9.akpm@linux-foundation.org> <20070614233002.GG86004887@sgi.com> <20070614164118.cbd48e53.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614164118.cbd48e53.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 04:41:18PM -0700, Andrew Morton wrote:
> > On Fri, 15 Jun 2007 09:30:02 +1000 David Chinner <dgc@sgi.com> wrote:
> > xfs_repair also uses direct I/O and does it's own userspace block
> > caching and so avoids the problems involved with low memory, context
> > unaware cache reclaim and blockdev cache thrashing.
> 
> umm, that sounds like a mistake to me.  fscks tend to get run when there's
> no swap online.  A small system with a large disk risks going oom and can
> no longer be booted. 

xfs_repair is never run at boot time - we don't force periodic
boot time checks like ext3/4 does so this isn't a problem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
