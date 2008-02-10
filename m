Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYBJJLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYBJJLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYBJJLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:11:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYBJJL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:11:29 -0500
Date: Sun, 10 Feb 2008 04:11:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210091123.GA19912@infradead.org>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082408.GA10479@infradead.org> <20080210085735.GA13466@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210085735.GA13466@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 09:57:35AM +0100, Ingo Molnar wrote:
> > It would be nice if you could move the kerneldoc comments to the 
> > proper place at least. [...]
> 
> i'd agree in general but this is really a special case, please look at 
> the context. This would duplicate all the kerneldoc headers for all 
> architectures. We'd have to move the same kerneldoc header to all 
> architecture arch/*/kernel/kgdb.c files. It's much nicer in 
> asm-generic/kgdb.h.

Well, the point of kerneldoc comments is that they're reasily
extractable.  If you want to document the arch interface a pure
text document in Documentation/ might be a better choice.

> > Also it seems at least some of Jan's patches are missing aswell.
> 
> i dont think so. Which ones do you mean? I just reviewed them and they 
> are either already done, or moot (for kgdb complications that i objected 
> to and removed from this kgdb-x86 tree).

The one I noticed quickly is the __ASSEMBLY__ removal from
asm-x86/kgdb.h.  I haven't looked at the serial bits because I don't
think I'm qualified to comment on those, but I'm also not seeing any
replies to any of his patches.  Especially the comments on the arch
interface seem like something that should be acted upon to me.
