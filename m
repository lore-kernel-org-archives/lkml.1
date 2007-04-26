Return-Path: <linux-kernel-owner+w=401wt.eu-S1031328AbXDZQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031328AbXDZQQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031331AbXDZQQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:16:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59154 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031330AbXDZQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:16:42 -0400
Date: Thu, 26 Apr 2007 17:16:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426161629.GA21039@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	David Chinner <dgc@sgi.com>, Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <20070426155855.GA16337@infradead.org> <20070426160507.GC2017@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426160507.GC2017@kernel.dk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 06:05:07PM +0200, Jens Axboe wrote:
> Agree. I don't know why we are arguing the merrits of this, it's an
> obvious win. The problem is more if it's doable this way or not due to
> fragmentation, but that's a different discussion and should be kept
> seperate.

Btw, another bit I really like about the patches is that it make
the page cache size notation actually useful.  People used PAGE_SIZE
and PAGE_CACHE_SIZE totally interchangeable before and created a total
mess.  Getting rid of PAGE_CACHE_SIZE and only use the per-mapping
macros would be a nice cleanup all by iself even without putting the
rest in for now.

