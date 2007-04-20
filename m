Return-Path: <linux-kernel-owner+w=401wt.eu-S1030939AbXDTSvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030939AbXDTSvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030672AbXDTSu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:50:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39600 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030853AbXDTSuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:50:25 -0400
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher
	order pages
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <20070420110516.GC12075@skynet.ie>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
	 <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
	 <20070420110516.GC12075@skynet.ie>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 18:50:21 +0000
Message-Id: <1177095021.10848.18.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 12:05 +0100, Mel Gorman wrote:

> comments about missing page_cache_size() covered elsewhere. However, I
> note that Dave Kleikamp might be interested in this changing of
> page_cache_size() from the perspective of page cache tails. I've added
> him to the cc so he can take a quick look.

Yeah.  I'm working on patches for storing file tails in buffers
allocated from the slab cache, and the tail will be represented by a
fake struct page.  (This is primarily for kernels with a larger page
size).  So my version of page_cache_size(page) may return a different
size for different pages belonging to the same mapping.  I'm in the
midst of cleaning up the patches and plan to post them to linux-mm by
Monday.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

