Return-Path: <linux-kernel-owner+w=401wt.eu-S966587AbXIKUOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966587AbXIKUOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbXIKUDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:03:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56741 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934331AbXIKUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:03:46 -0400
Date: Tue, 11 Sep 2007 13:03:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@suse.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070911120513.GA10328@v2.random>
Message-ID: <Pine.LNX.4.64.0709111302400.25781@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <20070911120513.GA10328@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Andrea Arcangeli wrote:

> Furthermore all the issues with writeprotect faults over MAP_PRIVATE
> regions will have to be addressed the same way with both approaches if
> we want real 100% 4k-granular backwards compatibility.

Could you be more specific as to why my patch does not address that issue?

> And if I'm terribly wrong and the variable order pagecache is the way
> to go for the long run, the 64k tlb feature will fit in that model
> very nicely too.

Right.
