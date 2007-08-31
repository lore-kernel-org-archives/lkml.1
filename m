Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbXHaXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbXHaXCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbXHaXCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 19:02:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbXHaXCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 19:02:34 -0400
Date: Fri, 31 Aug 2007 19:02:15 -0400
From: Dave Jones <davej@redhat.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
Message-ID: <20070831230215.GF11499@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 05:38:34PM -0400, Robert P. J. Day wrote:

 >   it may be that some people had a different understanding of what was
 > meant by "maturity" than i did.  what *i* meant by that attribute is
 > a feature's current position in the normal software life cycle, and
 > that would be one of:
 > 
 >   experimental -> normal (stable) -> deprecated -> obsolete

Life isn't so black and white.
 * We have stuff go into the tree that isn't experimental on a regular
   basis, due to proving outside of Linus' tree, be that in -mm, or
   a distro tree, or anywhere else.
 * We've had code become undeprecated a few times.
 * Likewise stuff has sometimes got so fucked up that it's become
   experimental again (see the longhaul driver for a great example
   of a catastrophe in motion).

 >   it's a natural progression and, at any point, a feature cannot
 > possibly have more than one maturity value.  it would be as absurd as
 > saying that someone was a teenager *and* was a twenty-something at the
 > same time.  not possible.

Again, not so black and white.
It's feasible that something can be experimental on one architecture,
stable on another (typically x86), or even deprecated on x86, but still
supported on other architectures.
It's not just a per arch thing either, in some cases, we've had
differing levels of maturity based upon other hardware constraints,
or even varying versions of system software.
 
 > another attribute can then be what i was calling "status" but could
 > also be called "quality".   *that* is where you could categorize a
 > feature as one of FLAKY, BROKEN and so on.  that's an entirely
 > independent categorization from maturity, which means you could have
 > features that were both experimental and flaky, or deprecated and
 > broken, or what have you.  and those settings would be done with
 > separate Kconfig directives:

Kconfig is an awful mechanism for tracking whether something is stable or not.
Take for example the skge net driver.  It's "perfect" on some systems,
and utterly busted on others. How would you express that in Kconfig ?

	Dave

-- 
http://www.codemonkey.org.uk
