Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZCBSoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZCBSoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZCBSoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:44:04 -0500
Received: from thunk.org ([69.25.196.29]:33933 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbZCBSoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:44:01 -0500
Date: Mon, 2 Mar 2009 13:43:16 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@sirena.org.uk>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090302184316.GA25469@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Brown <broonie@sirena.org.uk>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
References: <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu> <20090302131514.GC19744@sirena.org.uk> <49ABF825.1010501@s5r6.in-berlin.de> <20090302100158.bb83bec6.akpm@linux-foundation.org> <20090302182456.GF19744@sirena.org.uk> <20090302103437.f3109332.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302103437.f3109332.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 10:34:37AM -0800, Andrew Morton wrote:
> 
> The text covering a patch should describe what the patch does, why it
> does it, how it does it and it should describe the end-user effects of
> not having the patch present.  Any and all of these can be skipped if
> they are utterly obvious and unneeded.
> 
> Changes should be properly described, that's all.  The means by which
> that is done isn't terribly important.  Sometimes most of the
> description is in code comments, or in a newly-added Documentation/
> file.

My usual advise to folks is that if someone might be scratching their
head about why the code 3 months later, it probably does belong in the
code comments.  On the other hand, an explanation for why the previous
code was buggy probably should be in the commit description --- if it
isn't obvious.

An explanation for what the user might see when the bug gets hit is
also useful if after the fact someone is trying to see if a particular
bug has been fixed in mainline already, as is a pointer to the
bugzilla URL.

But if it's something as simple as "fix spelling mistake", or "handle
OOM condition gracefully", it may be that thing more than a single
one-line patch title is all that is necessary.

						- Ted

> The reason I asked you personally to always send a changelog is because
> I quite frequently sit there scratching my head at your patches not
> having a clue what they do nor how to prioritise them.
