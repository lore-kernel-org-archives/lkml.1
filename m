Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbZFMNtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbZFMNtp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZFMNti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:49:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44220 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbZFMNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:49:37 -0400
Date: Sat, 13 Jun 2009 14:49:22 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/13] cpumask: Use accessors for cpu_*_mask: arm
Message-ID: <20090613134922.GA23433@flint.arm.linux.org.uk>
References: <20090612133100.765C2DDDA0@ozlabs.org> <20090612190303.GA7976@flint.arm.linux.org.uk> <200906132225.12855.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906132225.12855.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 10:25:12PM +0930, Rusty Russell wrote:
> On Sat, 13 Jun 2009 04:33:03 am Russell King wrote:
> > On Fri, Jun 12, 2009 at 10:33:14PM +0930, Rusty Russell wrote:
> > > Use the accessors rather than frobbing bits directly (the new versions
> > > are const).
> >
> > Please check linux-next - there are all kinds of SMP changes currently
> > queued up in the ARM tree, which include most of the updates for things
> > like this.
> 
> OK, here's the revision based on latest linux-next, if you wouldn't mind
> taking it.  (We should really make on_each_cpu_mask an arch-indep, too).

Hmm, weird.  Your diff is against does not correspond with my tree, which
supposedly is in linux-next.

Commit 8266810 "[ARM] smp: fix cpumask usage in ARM SMP code" (in my tree
since May 17th) fixes some of the areas which your patch touches.  See:

http://ftp.arm.linux.org.uk/git/gitweb.cgi?p=linux-2.6-arm.git;a=shortlog;h=refs/heads/smp

I suggest hanging fire on this until the ARM tree is merged into mainline.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
