Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZDZNOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZDZNOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZDZNO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:14:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZDZNO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:14:28 -0400
Date: Sun, 26 Apr 2009 09:14:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Benny Halevy <bhalevy@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Fred Isaman <iisaman@citi.umich.edu>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH] lib: find_last_bit.o needed by a module only, move it
	from lib to obj
Message-ID: <20090426131422.GA19701@infradead.org>
References: <1240494032-9674-1-git-send-email-bhalevy@panasas.com> <200904262205.20608.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904262205.20608.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 10:05:19PM +0930, Rusty Russell wrote:
> On Thu, 23 Apr 2009 11:10:32 pm Benny Halevy wrote:
> > From: Fred Isaman <iisaman@citi.umich.edu>
> > 
> > Currently, although find_last_bit is EXPORTed, it is statically linked with
> > the lernel and is referenced only under CONFIG_SMP.
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> We know that any EXPORT_SYMBOL in lib-y is dubious, at least, but we're
> lazy (ISTR it would gut lib-y to exclude them all).

The whole of lib-y is dangerous and we should just kill it..

