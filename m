Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbXDYDLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbXDYDLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 23:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXDYDLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 23:11:16 -0400
Received: from holomorphy.com ([66.93.40.71]:35166 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbXDYDLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 23:11:15 -0400
Date: Tue, 24 Apr 2007 20:11:39 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070425031139.GB19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424222105.883597089@sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 03:21:05PM -0700, clameter@sgi.com wrote:
> V2->V3
> - More restructuring
> - It actually works!
> - Add XFS support
> - Fix up UP support
> - Work out the direct I/O issues
> - Add CONFIG_LARGE_BLOCKSIZE. Off by default which makes the inlines revert
>   back to constants. Disabled for 32bit and HIGHMEM configurations.
>   This also allows a gradual migration to the new page cache
>   inline functions. LARGE_BLOCKSIZE capabilities can be
>   added gradually and if there is a problem then we can disable
>   a subsystem.

Excellent, I'll do some testing here at the very least.


-- wli
