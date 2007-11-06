Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXKFQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXKFQr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbXKFQrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:47:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55713 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118AbXKFQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:47:47 -0500
Date: Tue, 6 Nov 2007 08:47:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
In-Reply-To: <20071106161406.GD9086@thunk.org>
Message-ID: <alpine.LFD.0.999.0711060841570.15101@woody.linux-foundation.org>
References: <20071105215601.GA4612@kroah.com>
 <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org>
 <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
 <20071106161406.GD9086@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Nov 2007, Theodore Tso wrote:
> 
> hmm, I wonder if it would be a good idea to put together a git hook
> script that looks for things that look like git commit ID's, and if
> they aren't valid commit ID's that appear in the repository, the
> maintainer gets a warning when they do a "git am" or otherwise suck in
> a patch that was sent via e-mail...

Well, the thing is, sometimes it makes sense.

In the stable tree, for example, the commits often point to the particular 
commit in the *development* tree that the particular stable commit was 
cherry-picked from. And that all makes perfect sense - but such a commit 
will not even exist in that tree (very much by definition: the whole point 
of a stable tree is to *not* have all the development commits in that 
tree, so just individual commits get moved over).

So it does make sense to point to commits in totally independent trees at 
times.

Yes, it could be an option, and yes, you could probably enable/disable it 
on a per-repository basis (ie the above kind of thing tens to make sense 
for certain repositories but not others). But it's definitely not 
something that necessarily always makes sense to do, so it's likely not a 
good default (and if it's not a default, then mistakes will continue to 
happen).

		Linus
