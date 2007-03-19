Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXCSMW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXCSMW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933262AbXCSMW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:22:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53379 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbXCSMW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:22:56 -0400
Date: Mon, 19 Mar 2007 12:22:53 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
Message-ID: <20070319122252.GA12029@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20070318233008.GA32597093@melbourne.sgi.com> <20070319092222.GA1720@infradead.org> <45FE61D3.90105@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FE61D3.90105@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 09:11:31PM +1100, Nick Piggin wrote:
> I've got the patches in -mm now. I hope they will get merged when the
> the next window opens.
> 
> I didn't submit the ->page_mkwrite conversion yet, because I didn't
> have any callers to look at. It is is slightly less trivial than for
> nopage and nopfn, so having David's block_page_mkwrite is helpful.

Yes.  I was just wondering whether it makes more sense to do this
functionality directly ontop of ->fault instead of converting i over
real soon.

