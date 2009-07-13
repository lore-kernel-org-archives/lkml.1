Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZGMOKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZGMOKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 10:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZGMOKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 10:10:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZGMOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 10:10:53 -0400
Date: Mon, 13 Jul 2009 10:10:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090713141050.GA16926@infradead.org>
References: <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com> <20090712144717.GA18163@infradead.org> <20090713065917.GO14666@wotan.suse.de> <20090713135324.GB3685@infradead.org> <20090713140515.GB10739@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713140515.GB10739@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 04:05:15PM +0200, Nick Piggin wrote:
> OK that's kind of what I imagine inode_setattr becomes, but now
> that you make me look at it in that perspective, it is better to
> say inode_setattr returns to a plain helper to copy values into
> the inode once we move the truncate code out of there.
> 
> It would be good to add your simple_setattr and factor it out
> from fnotify_change, then. I guess this is what you plan to do
> after my patchset?

Exactly.  Maybe we can even fold it into your patchset, but I want
to see a few more if not all conversions before going ahead.

