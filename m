Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZCAASv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZCAASv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZCAASm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:18:42 -0500
Received: from thunk.org ([69.25.196.29]:42381 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbZCAASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:18:42 -0500
Date: Sat, 28 Feb 2009 19:18:29 -0500
From: Theodore Tso <tytso@mit.edu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mark Brown <broonie@sirena.org.uk>, Andy Whitcroft <apw@canonical.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090301001829.GA10751@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Mark Brown <broonie@sirena.org.uk>,
	Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A9C252.50204@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 12:01:38AM +0100, Stefan Richter wrote:
> > As I have previously said, that is not the case in reality.  There
> > appears to be substantial sentiment among people handling patches that
> > not having any text in the body of the e-mail makes it harder to handle
> > patches.
> 
> It is indeed a problem
>   - if the patch title alone insufficiently describes the patch
> or
>   - if a patch reviewer believes that it is OK to ignore patch titles.

Worse yet, if we start getting these sorts of entries being returned
by "git log":

------------
ext4: Fix spelling error: successfull

Fix spelling error: successfull

Signed-off-by: "Trivial Patch Submitter" <spelling@nits.org>
------------

Just to shut up checkpatch, I'm going to feel the urge to shake a
checkpatch maintainer warmly by the throat.

Sometimes, all that is needed is:

------------
ext4: Fix spelling error: successfull

Signed-off-by: "Trivial Patch Submitter" <spelling@nits.org>
------------

							- Ted
