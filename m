Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbZCBQBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbZCBQBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZCBQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:01:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1494 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZCBQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:01:25 -0500
Date: Mon, 2 Mar 2009 16:01:11 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Theodore Tso <tytso@mit.edu>, Andy Whitcroft <apw@canonical.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090302160111.GE19744@sirena.org.uk>
References: <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu> <20090302131514.GC19744@sirena.org.uk> <49ABF825.1010501@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ABF825.1010501@s5r6.in-berlin.de>
X-Cookie: What hath Bob wrought?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 04:15:49PM +0100, Stefan Richter wrote:
> Mark Brown wrote:

> > Andrew Morton is one of them but not the only one.  Like I say, I don't

> As far as I have observed, akpm's (Cc'd now) complaints are about
> patches whose impact or benefit etc. are insufficiently explained ---
> which is an issue on a higher level than pure formalism.  I believe I
> too have seen the term "unchangelogged" (as you mentioned) in one of
> those discussions but I associated lack of information with it rather
> than a violation of a formalism.

The terminology and comments about normally skipping these "unchangelogged"
patches create a very different impression.  Obviously, there's going to
be a crossover between the two cases.

> I still say there are some straightforward changes which /can/ be well
> explained in a single line (which would be the title line).  Still, by
> far the most changes, including several kinds of janitorial changes,
> require more explanation than that.  At which level a changelog should

Sure, this is all very standard stuff.

> It is not trivial to give general advice on that, and it is impossible
> to encode even simple tests for the quality of a changelog in a script
> like checkpatch.

As I've said already on a number of occasions the patch was purely
intended to catch the case where there was no body in the patch log,
which appeared to be something that was being specifically objected to.
