Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZCACyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZCACyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 21:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZCACyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 21:54:10 -0500
Received: from thunk.org ([69.25.196.29]:42454 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZCACyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 21:54:09 -0500
Date: Sat, 28 Feb 2009 21:53:57 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090301025357.GC10751@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mark Brown <broonie@sirena.org.uk>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
References: <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301004618.GA12909@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 12:46:19AM +0000, Mark Brown wrote:
> 
> The reason I sent the patch was that sending changelogs like that for
> trivial changes is getting me negative feedback and I'm seeing other
> comments about "unchangeloged patches" on the lists so I'm pretty sure
> it's not just something I'm doing.  I'm not saying I'm always blameless
> here but when people are using terms like like "unchangeloged" it really
> does suggest that one line changelogs are just considered not to have
> changelogs.

Well, I certainly don't have a problem with this.  I in fact get
*really* *annoyed* when I get patch submissions where the subject line
is replicated in the body, since I then have to manually edit the mail
message before I can run "git am" on the mail message.

Who's been complaining?  I can certainly tell you I'll complain in the
opposite direction, but that's because it actually causes me more work
as a maintainer.  If people are kvetching, maybe they should complain
to git mailing list and ask for a different git commit to e-mail
message convention --- but it's really not hard to look at the subject
line.

						- Ted
