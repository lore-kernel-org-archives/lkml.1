Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbXF3IuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbXF3IuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 04:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXF3IuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 04:50:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52735 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbXF3IuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 04:50:01 -0400
Date: Sat, 30 Jun 2007 09:49:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com, hugh@veritas.com,
       James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather lists
Message-ID: <20070630084948.GC21186@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Miller <davem@davemloft.net>, clameter@sgi.com,
	hugh@veritas.com, James.Bottomley@steeleye.com,
	rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com> <20070628.212825.78710369.davem@davemloft.net> <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com> <20070628.220606.112621271.davem@davemloft.net> <20070628222424.4cbae90c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628222424.4cbae90c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 10:24:24PM -0700, Andrew Morton wrote:
> > Really, it would be great if we could treat kmalloc() objects
> > just like real pages.
> 
> >From a high level, that seems like a bad idea.  kmalloc() gives you a
> virtual address and you really shouldn't be poking around at that memory's
> underlying page's pageframe metadata.
> 
> However we can of course do tasteless and weird things if the benefit is
> sufficient....

Hey, when we had exactly that issues coming up with xfs/ext3 recovery over
iscsi/aoe you said it's fine :)  End result is that XFS got fixed and ext3
is still broken..

