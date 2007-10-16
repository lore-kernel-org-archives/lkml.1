Return-Path: <linux-kernel-owner+w=401wt.eu-S1762871AbXJPAo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762871AbXJPAo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbXJPAoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:44:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55059 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757276AbXJPAoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:44:16 -0400
Date: Mon, 15 Oct 2007 17:44:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Chris Mason <chris.mason@oracle.com>
cc: David Chinner <dgc@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Andrea Arcangeli <andrea@suse.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: More Large blocksize benchmarks
In-Reply-To: <20071016002231.GA21378@think.oraclecorp.com>
Message-ID: <Pine.LNX.4.64.0710151741200.19172@schroedinger.engr.sgi.com>
References: <20071016002231.GA21378@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Chris Mason wrote:

> Dave reported that XFS saw much higher write throughput with large
> blocksizes, but so far I'm seeing the most benefits during reads.

Dave's tests were done with an early large blocksize patchset that had 
issues with readahead. More recent versions have the fixes by Fengguang 
that address the issue.
