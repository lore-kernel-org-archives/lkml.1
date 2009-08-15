Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZHOPg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZHOPg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 11:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZHOPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 11:36:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:50489 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZHOPg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 11:36:58 -0400
Date: Sat, 15 Aug 2009 17:36:56 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
Message-ID: <20090815153656.GC30951@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <20090815145131.GA25509@infradead.org> <20090815151412.GB30951@wotan.suse.de> <20090815151824.GA16697@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815151824.GA16697@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 11:18:24AM -0400, Christoph Hellwig wrote:
> On Sat, Aug 15, 2009 at 05:14:12PM +0200, Nick Piggin wrote:
> > On Sat, Aug 15, 2009 at 10:51:31AM -0400, Christoph Hellwig wrote:
> > > Nick, what's the plan with moving forward on this?  We're badly waiting
> > > for it on the XFS side.  
> > 
> > I was hoping Al would take it but no reply... Any other git tree you
> > suggest, or -mm?
> 
> If we can get it into -mm until Al reappear that would be good.  What

OK, if that helps, I'll resubmit them.


> are your plans to convert other filesystems?  I'd like to have at least
> all that use O_DIRECT converted ASAP.

I was going to start going through some of them and at least try to get
patches out for maintainers to review. I was putting it off until at
least they got merged into a tree... but they do look pretty good after
your reviews now so I don't think there should be major objections.

I will send them to Andrew then tonight or tomorrow.

