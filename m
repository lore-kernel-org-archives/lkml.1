Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZHOPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZHOPSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 11:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZHOPSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 11:18:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZHOPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 11:18:24 -0400
Date: Sat, 15 Aug 2009 11:18:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
Message-ID: <20090815151824.GA16697@infradead.org>
References: <20090706165438.GQ2714@wotan.suse.de> <20090815145131.GA25509@infradead.org> <20090815151412.GB30951@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815151412.GB30951@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 05:14:12PM +0200, Nick Piggin wrote:
> On Sat, Aug 15, 2009 at 10:51:31AM -0400, Christoph Hellwig wrote:
> > Nick, what's the plan with moving forward on this?  We're badly waiting
> > for it on the XFS side.  
> 
> I was hoping Al would take it but no reply... Any other git tree you
> suggest, or -mm?

If we can get it into -mm until Al reappear that would be good.  What
are your plans to convert other filesystems?  I'd like to have at least
all that use O_DIRECT converted ASAP.

