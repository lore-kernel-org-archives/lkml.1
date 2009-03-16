Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZCPGjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZCPGjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 02:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZCPGiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 02:38:50 -0400
Received: from thunk.org ([69.25.196.29]:35586 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZCPGit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 02:38:49 -0400
Date: Mon, 16 Mar 2009 02:38:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>,
       Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090316063830.GC6357@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
	tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au> <200903141941.10030.phillips@phunq.net> <200903151445.04552.nickpiggin@yahoo.com.au> <20090315214426.GA6357@mit.edu> <20090316051211.GB26138@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316051211.GB26138@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

It wasn't my intention to say that XFS was bad; in fact, I thought I
was actually complementing XFS by talking about some of the advanced
features that XFS had (many of which I have always said that ext3 has,
and some of which ext4 still does not have, and probably never will
have).  I stand corrected on some of the details that I got wrong.
What I was trying to say was that *if* (and perhaps I'm
misunderstanding fsblock) that fsblock is requiring that as soon as a
page is dirty, fsblock requests the filesystem to assign a block
allocation to the buffers attached to the dirty page, that this would
spike out delayed allocation, which would be unfortunate for *both*
ext4 and XFS.

But maybe I'm misunderstanding what fsblock is doing, and there isn't
a problem here.

Regards,

						- Ted
