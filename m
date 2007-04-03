Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXDCGTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXDCGTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 02:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXDCGTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 02:19:30 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44021 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753228AbXDCGT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 02:19:29 -0400
Date: Tue, 3 Apr 2007 16:19:16 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, reiserfs-dev@namesys.com
Subject: Re: [xfs-masters] Re: [PATCH] Cleanup and kernelify shrinker registration (rc5-mm2)
Message-ID: <20070403061916.GW32597093@melbourne.sgi.com>
References: <1175571885.12230.473.camel@localhost.localdomain> <20070402205825.12190e52.akpm@linux-foundation.org> <1175575503.12230.484.camel@localhost.localdomain> <20070402215702.6e3782a9.akpm@linux-foundation.org> <20070403054419.GV32597093@melbourne.sgi.com> <20070402230158.4fcdd455.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402230158.4fcdd455.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 11:01:58PM -0700, Andrew Morton wrote:
> On Tue, 3 Apr 2007 15:44:19 +1000 David Chinner <dgc@sgi.com> wrote:
> 
> > In XFS, one of the shrinkers cwthat gets registered calls causes all
> > the xfsbufd's in the system to run and write back delayed write
> > metadata - this can't be freed up until it is clean, and this is the
> > only hook we have that can be used to trigger writeback on memory
> > pressure. We need this because we can potentially have hundreds of
> > megabytes of dirty metadata per XFS filesystem.
> > 
> 
> <looks>
> 
> Gad, someone went mad in there.  Can we do this (please)?

Yup, added to my QA tree.

Rusty, can you redo you patch on top of this one? I'll
add it to my QA tree as well...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
