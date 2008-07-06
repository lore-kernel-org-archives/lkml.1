Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYGFJ6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYGFJ6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 05:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYGFJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 05:58:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYGFJ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 05:58:24 -0400
Date: Sun, 6 Jul 2008 05:58:23 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New ext4 patchset 2.6.26-rc8-ext4-1
Message-ID: <20080706095823.GA21109@infradead.org>
References: <E1KFBPc-0006yI-Gx@closure.thunk.org> <20080705175047.GA11243@infradead.org> <20080706024115.GH20240@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706024115.GH20240@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 10:41:15PM -0400, Theodore Tso wrote:
> On Sat, Jul 05, 2008 at 01:50:47PM -0400, Christoph Hellwig wrote:
> > Strong NACK.  For one thing the code added to mpage.c doesn't belong
> > there.  It's far inferior to the existing delalloc code we already have
> > and that could be made generic easily, or the next generation code
> > developed by Chris mason.  It's an ext4-specific hack and doesn't belong
> > into common code.  I'm pretty sure we agreed on not having it in
> > common code long ago.
> 
> Looking back at the mailing list history, yes, we did.  I think the
> reason why we didn't was Andrew had expressed a vague wish that the
> ext4 and xfs developers would get together and try to hash out a
> common layer that all filesystems could work with.  But given that
> nothing has happened in the many months since that discussion, you're
> absolutely right.
> 
> I've reworked the vfs generic patch in the patch series to be much
> smaller --- mainly what's left is simply exporting some mpage
> interfaces that would be needed by ext4.  I trust this is much more to
> your liking?

Yes, this is much better.  But please also add kerneldoc comments for
the newly exported functions.

