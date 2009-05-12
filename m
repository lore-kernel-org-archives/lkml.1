Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZELUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZELUPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZELUP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:15:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZELUP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:15:26 -0400
Date: Tue, 12 May 2009 16:15:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: nfsd fixes for 2.6.30
Message-ID: <20090512201526.GA20972@infradead.org>
References: <20090512192912.GH19164@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512192912.GH19164@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 03:29:12PM -0400, J. Bruce Fields wrote:
> The following nfsd fixes are available from the for-2.6.30 branch at:
> 
> 	git://linux-nfs.org/~bfields/linux.git for-2.6.30
> 
> (Note: I wasn't sure of the last one, "nfsd: silence lockdep warning":
> on the one hand, it's just a warning.  On the other hand, a lot of users
> may assume it's something more serious and freak out, just because
> there's a backtrace in it.  Should this have been saved for the next
> merge window?)

I think it's fine.  For non-lockdep builds the annotation doesn't change
anything, and for lockdep builds it fixes the false positive.

