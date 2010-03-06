Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0CFJzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 04:55:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47700 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0CFJzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 04:55:17 -0500
Date: Sat, 6 Mar 2010 04:55:09 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       dushistov@mail.ru, joel.becker@oracle.com, shaggy@linux.vnet.ibm.com,
       linux-ext4@vger.kernel.org
Subject: Re: [PULL REQUEST] Quota cleanups & fixes and ext3 fixes for
	2.6.34-rc1
Message-ID: <20100306095509.GA23951@infradead.org>
References: <20100305003304.GE4887@quack.suse.cz> <alpine.LFD.2.00.1003051314330.3906@localhost.localdomain> <20100305230117.GZ30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305230117.GZ30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 11:01:17PM +0000, Al Viro wrote:
> I'd say that places where it's added are lousy - if we want to do that
> on directory modifications, we ought to take it into places that actually
> create directory entries.  Not to mention that we never shrink directories
> there, so it should be just one call in ext2_add_link() instead of all
> that pile.
> 
> Looks like a good case for a followup series, if nothing else.

Yes, this will get sorted out per filesystem later, but I didn't want
to mess around with all filesystems in one series.

