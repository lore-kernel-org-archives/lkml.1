Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbYG2ENw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbYG2ENw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYG2ENn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:13:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58629 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbYG2ENm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:13:42 -0400
Date: Tue, 29 Jul 2008 00:13:37 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080729041337.GC9378@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jon Smirl <jonsmirl@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
	lkml <linux-kernel@vger.kernel.org>
References: <488E0BB6.7020006@simon.arlott.org.uk> <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com> <488E1147.5040803@simon.arlott.org.uk> <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com> <20080729011526.GF28946@ZenIV.linux.org.uk> <9e4733910807281825v42f9700al420ba48aebf3d790@mail.gmail.com> <20080729013650.GG28946@ZenIV.linux.org.uk> <9e4733910807281901i1a39ce93v902dd6bd240e1a34@mail.gmail.com> <20080729025016.GT9378@mit.edu> <9e4733910807282023h5479c755wde55e2324909b678@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910807282023h5479c755wde55e2324909b678@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:23:31PM -0400, Jon Smirl wrote:
> The kernel already has a mailmap file, but it is not complete. So I
> should just take this work that makes the mailmap file a lot better
> and throw it away? The policy is that the log file should be messed up
> enough so that a computer can't process it and that a human can
> recover it only with several day's effort? That's a really hard line
> to define and we'll probably lose the identity of a bunch of
> contributors. I'll follow up with a patch that deletes the current
> .mailmap

Personally, I have no objection to the mailmap file as it's on the
whole an improvement; if it's been automatically generated and it
falsely maps multiple people to a single person, that would be highly
unfortunate, but maybe it fixes more problems than it creates.

I think the part most people are seriously objecting to is that the
supposition that Linus and some of his top lieutenants should be
enforcing some arbitrary rule that rejects commits if they come from
addresses outside of your .mailmap file (unless they first send a
patch to add their e-mail address to the .mailmap file), in some kind
of misguided attempt to enforce validation, which apparently the main
justification for which is so that you and others can runs some
statistical analysis, of which there seems to be some dispute whether
or not encouraging people to compete to get into the top 20
signed-off-by by splitting up commits into 100 different micro-patches
should be considered a desirable side effect of said statistical
analysis.

As I said earlier, the moment you started advocating enforcing
validation, you may have started to confuse which is the tail and
which is the dog.  People should be supplying patches to improve the
kernel; not to provide accurate fodder for statistical analysis.

						- Ted
