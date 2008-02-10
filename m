Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYBJJfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYBJJfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBJJew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:34:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYBJJev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:34:51 -0500
Date: Sun, 10 Feb 2008 04:34:50 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210093450.GA3754@infradead.org>
References: <20080210071331.GC3851@elte.hu> <20080210073542.GB26666@infradead.org> <20080210074352.GA7188@elte.hu> <20080210075732.GA9349@infradead.org> <20080210080225.GC7188@elte.hu> <20080210082408.GA10479@infradead.org> <20080210085735.GA13466@elte.hu> <20080210091123.GA19912@infradead.org> <20080210092728.GA19252@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210092728.GA19252@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 10:27:28AM +0100, Ingo Molnar wrote:
> > The one I noticed quickly is the __ASSEMBLY__ removal from 
> > asm-x86/kgdb.h. [...]
> 
> people might want to experiment with early debug code as well and 
> include asm-x86/kgdb.h in assembly files. So i kept that, it's sensible. 

But asm-x86/kgdb.h doesn't have anythign people invoking kgdb might
need, it's just the arch interface to the kgdb core.  Nor does it
compile even with the ifdef as it already contains a C enum.

