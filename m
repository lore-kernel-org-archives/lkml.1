Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbZCBSDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbZCBSDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZCBSDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:03:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933AbZCBSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:03:12 -0500
Date: Mon, 2 Mar 2009 10:01:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mark Brown <broonie@sirena.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-Id: <20090302100158.bb83bec6.akpm@linux-foundation.org>
In-Reply-To: <49ABF825.1010501@s5r6.in-berlin.de>
References: <49A962F8.30609@s5r6.in-berlin.de>
	<20090228164627.GC15127@sirena.org.uk>
	<49A97563.6040906@s5r6.in-berlin.de>
	<20090228175218.GA4606@sirena.org.uk>
	<49A98F93.5030206@s5r6.in-berlin.de>
	<20090228210223.GA23191@sirena.org.uk>
	<49A9C252.50204@s5r6.in-berlin.de>
	<20090301001829.GA10751@mit.edu>
	<20090301004618.GA12909@sirena.org.uk>
	<20090301025357.GC10751@mit.edu>
	<20090302131514.GC19744@sirena.org.uk>
	<49ABF825.1010501@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Mar 2009 16:15:49 +0100 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Mark Brown wrote:
> > On Sat, Feb 28, 2009 at 09:53:57PM -0500, Theodore Tso wrote:
> >> Who's been complaining?  I can certainly tell you I'll complain in the
> >> opposite direction, but that's because it actually causes me more work
> > 
> > Andrew Morton is one of them but not the only one.  Like I say, I don't
> > want to claim that my changelogs are always ideal here, it was mostly
> > the specific language used that made me think of doing this.
> 
> As far as I have observed, akpm's (Cc'd now) complaints are about
> patches whose impact or benefit etc. are insufficiently explained ---
> which is an issue on a higher level than pure formalism.  I believe I
> too have seen the term "unchangelogged" (as you mentioned) in one of
> those discussions but I associated lack of information with it rather
> than a violation of a formalism.

Oh absolutely.  Quite often the changelog body contains no information
which wasn't in the title, so there's no need for a body.

I think what triggered this was a patch from Mark which had no
changelog and which had me sitting there wondering wtf it does, whether
we need it in 2.6.29, whether we need it in 2.6.28.x and earlier and me
not having the foggiest clue then getting grumpy.
