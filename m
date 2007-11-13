Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbXKMVE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbXKMVE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbXKMVEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:04:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756457AbXKMVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:04:15 -0500
Date: Tue, 13 Nov 2007 13:04:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [BUG] New Kernel Bugs
Message-Id: <20071113130411.26ccae12.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>
References: <20071113034916.2556edd7.akpm@linux-foundation.org>
	<20071113.035824.40509981.davem@davemloft.net>
	<20071113041259.79c9a8c5.akpm@linux-foundation.org>
	<20071113.043207.44732743.davem@davemloft.net>
	<20071113110259.44c56d42.akpm@linux-foundation.org>
	<alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 21:00:30 +0100 (CET) Christian Kujau <lists@nerdbynature.de> wrote:

> On Tue, 13 Nov 2007, Andrew Morton wrote:
> > I think that we're fairly good about working the regressions in
> > Adrian/Michal/Rafael's lists but once Linus releases 2.6.x we tend to let
> > the unsolved ones slide, and we don't pay as much attention to the
> > regressions which 2.6.x testers report.
> 
> Can't we wait until all regressions[0] are fixed before releasing a new 
> 2.6.x? I'd consider regressions a *literal* show stopper, and with this 
> policy they just have be fixed, nothing would "slide"...
> 

Problem is that everyone would then sit around pumping shiny new features
into their trees waiting until someone else fixes the regressions.

There are a number of process things we _could_ do.  Like

- have bugfix-only kernel releases

- Just refuse to merge any non-bugfix patches for a subsystem when it is
  determined that the subsystem has "too many" regressions.

- Create an "if you added a regression, you should fix some other bug
  too" rule.

- probably other stuff.

But we can't/shouldn't do any of that until it is generally agreed that we
have a problem and that the problem is of sufficient magnitude that process
changes are needed to address it.  We aren't at that stage yet.


Here's an important point: developers have a fixed amount of development
time.  They spend some of that time fixing bugs and the rest of that time
on <otherstuff>.  And while one could cook up all sorts of wonderful
process changes, they all would be aimed at a single thing: shifting some
of the developers' time away from <otherstuff> and onto bugfixing.

At this stage the only tool which is being deployed to attempt to bring
about that reprioritisation is suasion.  aka "lkml flamewar".

