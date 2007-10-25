Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXJYVhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXJYVhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXJYVhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:37:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33787 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXJYVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:37:32 -0400
Date: Thu, 25 Oct 2007 22:36:44 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial: do not call ->pm() on initialization for console port
Message-ID: <20071025213644.GA30141@flint.arm.linux.org.uk>
References: <20071019.011355.39154656.anemo@mba.ocn.ne.jp> <20071018161827.GB16244@flint.arm.linux.org.uk> <20071026.010510.59032545.anemo@mba.ocn.ne.jp> <20071025134044.58ca9d35.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025134044.58ca9d35.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 01:40:44PM -0700, Andrew Morton wrote:
> On Fri, 26 Oct 2007 01:05:10 +0900 (JST)
> Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> 
> > On Thu, 18 Oct 2007 17:18:27 +0100, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > > > Attached patch fixes this problem.  Is this a right way?
> > > > If not, I will fix the serial_txx9 driver to skip the initialization in
> > > > ->pm() if oldstate was -1.
> > > 
> > > I'll have to investigate further to refresh myself with what's going
> > > on here, but your patch looks wrong.
> > 
> > Now rc1 is released.  Any chances for this patch?
> > If none, I should push other workaround to fix this issue on 2.6.24.
> 
> I don't know what patch you're referring to.  I don't appear to have
> whatever-patch-this-is queued up anywhere?

"Further investigation" is quite a good indication that a patch needs to
be worked on, no?  In any case, I'm ill at the moment, so things are very
much on hold.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
