Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYBJIYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYBJIYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYBJIYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 03:24:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbYBJIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 03:24:10 -0500
Date: Sun, 10 Feb 2008 03:24:08 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210082408.GA10479@infradead.org>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210080225.GC7188@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 09:02:25AM +0100, Ingo Molnar wrote:
> thanks - i found Sam's mail meanwhile and addressed most of the 
> observations and updated the kgdb.git tree. I'll now check the threads 
> above whether i missed anything. (feel free to point it out if you 
> notice anything outright) As the changes have been janitorial only i 
> refrain from reposting the series once again. The latest shortlog is 
> below.

It would be nice if you could move the kerneldoc comments to the proper
place at least.  And while you're at it please remove all the filenames
in the top-of-file comments, not just in include/asm-generic/kgdb.h.

While we're at it is there a good reason to have that file at all, it's
just function prototypes, and I'd say for now they should just go
into linux/kgdb.h.  If there's a a good reason why architectures
should implement them as inlines we can move them back, but looking
at the x86 implementation I doubt that's the case.

Also it seems at least some of Jan's patches are missing aswell.

I think we really shouldn't rush this too much.  Let's wait until
Monday at least when Jason and Jan are back.
