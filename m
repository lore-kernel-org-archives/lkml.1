Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbYBNQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbYBNQEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYBNQDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:03:43 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2475 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYBNQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:03:42 -0500
Date: Thu, 14 Feb 2008 16:04:36 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-ID: <20080214160231.GC10713@shadowen.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215003537.8911ce35.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:35:37AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> I have created the first cut of the linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> Things to know about this tree:
> 
> It has two branches - master and stable.  Stable is currently just Linus'
> tree and will never rebase.  Master will rebase on an almost daily basis
> (maybe slower at the start).

As devout believers in testing things early we test -mm and -git releases
as they drop.  I am keen that we are able to continue this with the -next
tree once it gets going.  Having just pulled this tree its not obvious how
I would communicate which tree I had tested.  I guess we could use the
SHA1 of the actual head used, but that really is cumbersome for the poor
people who have to check the results and actually report things to lkml.

As I previously indicated (on my stupidly subjected "testing linux-next")
to make it simple for us to test these releases, and for the reporters to
have a clear way to refer to them, we need some kind of sensible handle
for each.  It is also very desirable that it be trivial for a script to
detect releases.  The -git series is pretty handily named, following that
example might make sense.

I was going to propose you name them in a similar way to the main -gitN
releases.  But, I note that you are merging with what appears to be an up to
date Linus master tree.  Which means there is no nice name for the real
base point for your merges anyhow.

I guess there are a couple of sensible names for these.  Either a simple
date or using the nearest sane tag.

So either:
	next-20080214
or:
	v2.6.25-rc1-next1

Where the "base" version would be determinable from:
	apw@pinky$ git describe --tags origin/stable
	v2.6.25-rc1-120-ge760e71

I am guessing if a maintainer is coming back to look at a failure
reported by yourself, they are also going to want to know what the base
was for the merge which failed.  So it may make sense to keep a tag for
that too?

Also will you be producing any tarballs for these releases?  If so I
would say they would definatly need to be against some common base, like
against the nearest official tag "below".

-apw
