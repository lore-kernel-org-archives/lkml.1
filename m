Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbXJRP4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbXJRP4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761868AbXJRP4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:56:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52231 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbXJRP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:56:10 -0400
Date: Thu, 18 Oct 2007 16:54:29 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/21] KGDB: Request to merge KGDB
Message-ID: <20071018155429.GA16244@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
References: <4713B238.4030409@windriver.com> <20071017212025.d8a52694.akpm@linux-foundation.org> <20071018152310.GA7299@linux-sh.org> <20071018152552.GA13985@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018152552.GA13985@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 04:25:53PM +0100, Christoph Hellwig wrote:
> On Fri, Oct 19, 2007 at 12:23:10AM +0900, Paul Mundt wrote:
> > It would also be nice to balance this out with the utrace merge, as both
> > are going to cause quite a lot of pain on the architecture side.
> 
> I don't think a utrace merge as in one big merge is going to happen ever.
> It's just a too big patch doing too many things at once.  And the flag day
> for switching all architectures over is another blocker.

I agree with Christoph - the fact that *all* architectures have to be
either ptrace or utrace make it very very painful.

What would be good is if some effort could be made by the utrace-
interested parties to make the transition to utrace much less painful.
For instance, I quite like the getregs/setregs abstractions, and it
looks like these *could* be self-contained in a single patch.  It
would be nice if we could move architectures over to this one a time.
Once that's in, that's one chunk of utrace merged.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
