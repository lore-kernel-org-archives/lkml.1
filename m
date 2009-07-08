Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZGHMc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZGHMc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZGHMcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:32:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36261 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbZGHMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:32:47 -0400
Date: Wed, 8 Jul 2009 08:32:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 4/4] fs: tmpfs, ext2 use new truncate
Message-ID: <20090708123244.GA22722@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144918.GF2714@wotan.suse.de> <20090707163829.GB14947@infradead.org> <20090708065327.GM2714@wotan.suse.de> <20090708111420.GB20924@duck.suse.cz> <20090708122250.GP2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708122250.GP2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 02:22:50PM +0200, Nick Piggin wrote:
> OK fair enough. But I don't know if all those checks are
> realy appropriate. For example an IS_APPEND inode should
> be able to have its blocks trimmed off if a write fails.

It should.  But I think that's a separate issue of what we're trying to
fix right now.  So let's just do the method reshuffle now and then sort
out the checks later.

