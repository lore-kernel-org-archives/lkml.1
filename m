Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbXIXSL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbXIXSL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbXIXSLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:11:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXIXSLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:11:51 -0400
Date: Mon, 24 Sep 2007 19:11:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/7] Linux Kernel Markers (redux)
Message-ID: <20070924181148.GA3285@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070924164950.006047409@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924164950.006047409@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 12:49:50PM -0400, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> Following Christoph Hellwig's suggestion, aiming at a Linux Kernel Markers
> inclusion for 2.6.24, I made a simplified version of the Linux Kernel Markers.
> There are no more dependencies on any other patchset.
> 
> The modification only involved turning the immediate values into static
> variables and adapting the documentation accordingly. It will have a little more
> data cache impact when disabled than the version based on the immediate values,
> but it is far less complex.
> 
> Since things have not moved much in the markers area recently (most of the
> concerns were about the immediate values), I expect it to be ready for 2.6.24.

I've done a quick review and except for my usual nitpicking it looks
very good to me.  I'll try my sputrace code with this version and will
report on how it works.

I'd really love to see markers in 2.6.24.  The impact to core code of
the actual markers is minimal with some more struct fields in functions
in the module code, although we'll want Mathieu's fix for the modules
list aswell which is a little more invasive.  But I think we want that
one anyway.

I'd say we probably don't want the blktrace conversion that late in the
game, though - but we can queue that once together with the optimizations
from Mathieu's earlier patches in -mm.

