Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYIEOmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYIEOmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYIEOmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:42:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59762 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbYIEOmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:42:39 -0400
Date: Fri, 5 Sep 2008 15:37:16 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Khem Raj <raj.khem@gmail.com>
Subject: Re: [PATCH 02/23] arm: use the new byteorder headers
Message-ID: <20080905143716.GA17091@flint.arm.linux.org.uk>
References: <1219106875.17033.55.camel@brick> <20080819072715.GB30521@flint.arm.linux.org.uk> <1219172580.17033.87.camel@brick> <1220608169.2985.305.camel@pmac.infradead.org> <20080905102533.GA26458@flint.arm.linux.org.uk> <1220623566.2985.343.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220623566.2985.343.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 03:06:06PM +0100, David Woodhouse wrote:
> On Fri, 2008-09-05 at 11:25 +0100, Russell King wrote:
> > On Fri, Sep 05, 2008 at 10:49:29AM +0100, David Woodhouse wrote:
> > > On Tue, 2008-08-19 at 12:03 -0700, Harvey Harrison wrote:
> > > > include/linux/swab.h, include/linux/byteorder.h are in current
> > > > mainline which is all that these patches depend on.
> > > 
> > > Er, it also depends on the patch which exports those headers to
> > > userspace, which isn't in Linus' tree yet.
> > 
> > How useful.  If those generic headers are already in Linus' tree, and
> > are required for architectures to convert, why hasn't the patch which
> > exports them to userspace already been submitted?
> 
> Because they weren't being used by anything exported to userspace yet.
> The patch has been seen, but wasn't destined for 2.6.27...
>
> > However, another question: why should userspace be using a kernel header
> > file for byteswapping?
> 
> ... mostly (on my part, at least) because of that question.
> 
> Given my druthers, I'd revert the ARM part of the patch for now, and we
> can have a _serious_ think about whether we really need to export these
> functions to userspace.

I'll revert it, and if it's resubmitted, I'll ignore it until after the
next merge window - since my tree for the upcoming merge window currently
pre-dates the revert, so effectively continues to carry it until it's
merged.

I'm not sure what went wrong, other than being continuously bugged by
Harvey to apply his patch.  If his patches are inappropriate, surely
that should've been pointed out to Harvey before he got the first of
his series merged?

Maybe more of his patches need reverting if some have been applied?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
