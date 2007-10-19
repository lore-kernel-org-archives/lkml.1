Return-Path: <linux-kernel-owner+w=401wt.eu-S935395AbXJSHxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935395AbXJSHxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763597AbXJSHxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:53:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbXJSHw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:52:58 -0400
Date: Fri, 19 Oct 2007 08:47:06 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/21] KGDB: Request to merge KGDB
Message-ID: <20071019074706.GA10446@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
References: <4713B238.4030409@windriver.com> <20071017212025.d8a52694.akpm@linux-foundation.org> <20071018152310.GA7299@linux-sh.org> <20071018152552.GA13985@infradead.org> <20071018155429.GA16244@flint.arm.linux.org.uk> <20071018160050.GA18508@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018160050.GA18508@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 05:00:50PM +0100, Christoph Hellwig wrote:
> On Thu, Oct 18, 2007 at 04:54:29PM +0100, Russell King wrote:
> > What would be good is if some effort could be made by the utrace-
> > interested parties to make the transition to utrace much less painful.
> > For instance, I quite like the getregs/setregs abstractions, and it
> > looks like these *could* be self-contained in a single patch.  It
> > would be nice if we could move architectures over to this one a time.
> > Once that's in, that's one chunk of utrace merged.
> 
> Alexey Dobriyan had some patches to implement regsets, and these were
> posted here on lkml.

Given that not all architecture maintainers read lkml, and they are
patches affecting all *architectures*, wouldn't it have been a good
idea if they'd copied linux-arch?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
