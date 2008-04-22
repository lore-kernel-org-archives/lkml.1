Return-Path: <linux-kernel-owner+w=401wt.eu-S1763279AbYDVVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763279AbYDVVCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbYDVVCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:02:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47727 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbYDVVCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:02:15 -0400
Date: Tue, 22 Apr 2008 22:01:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
Message-ID: <20080422210153.GB21435@flint.arm.linux.org.uk>
References: <1208895950.24124.9.camel@brick> <20080422203334.GA9809@flint.arm.linux.org.uk> <Pine.LNX.4.64.0804221337550.19817@shark.he.net> <20080422204549.GA21435@flint.arm.linux.org.uk> <Pine.LNX.4.64.0804221346470.19817@shark.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221346470.19817@shark.he.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:47:18PM -0700, Randy.Dunlap wrote:
> On Tue, 22 Apr 2008, Russell King wrote:
> > On Tue, Apr 22, 2008 at 01:38:28PM -0700, Randy.Dunlap wrote:
> > > On Tue, 22 Apr 2008, Russell King wrote:
> > > 
> > > > That was my initial approach as well, which got shot down by Andrew
> > > > Morton and others as being unacceptable.
> > > 
> > > where?
> > 
> > In private mail.
> > 
> > > why?
> > 
> > Well, first I need to gain the permission of Andrew to post his private
> > message.  I'm not being subborn here - I _do_ _not_ reproduce private
> > messages in public without prior permission.
> 
> Sure, understood.
> 
> > > Seems like we need to push back on that part.
> > 
> > Talk to Andrew then.
> 
> He is cc-ed (although traveling much this week IIRC).

In which case, since it's likely I won't get a reply in the next hour
(which'll delay my response by 24 hours) let me paraphrase what Andrew
said.

Andrew believes that it is beneficial to have other architectures,
particularly x86, build other architectures drivers.

Meanwhile, pHilipp Zabel believes this hardware not to be ARM specific.

So, the majority concensus in the three way discussion was that it
should remain visible, and the (unnecessary) include and its dependents
be removed.

Having now had some time (read: half an hour after dinner after getting
back home) to investigate, I can point to the patch in several places:

  http://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/arm:devel.mbox

and find the patch with subject line:

  [ARM] 5010/1: htc-pasic3: remove unused defines and includes

or grab 5010/1 from my patch system.  If you want a patch to plaster
over it, merging that would be a far better solution.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
