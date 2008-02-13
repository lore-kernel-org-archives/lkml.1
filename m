Return-Path: <linux-kernel-owner+w=401wt.eu-S1765540AbYBMBZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765540AbYBMBZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYBMBZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:25:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53605 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbYBMBZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:25:28 -0500
Date: Wed, 13 Feb 2008 01:25:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213012521.GN27894@ZenIV.linux.org.uk>
References: <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212.155107.251983955.davem@davemloft.net> <20080212235401.GL27894@ZenIV.linux.org.uk> <20080213001650.GY18625@fieldses.org> <20080213004841.GM27894@ZenIV.linux.org.uk> <alpine.LFD.1.00.0802121654300.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121654300.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:59:23PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 13 Feb 2008, Al Viro wrote:
> 
> > On Tue, Feb 12, 2008 at 07:16:50PM -0500, J. Bruce Fields wrote:
> > > > Ahem...  Use of git-cherry-pick preserves commit information just fine.
> > > 
> > > Not by default, at least (note they said "commiters", not "authors"):
> > 
> > That's why you give it -r.
> 
> Hmm. "-r" is a no-op to git-cherry-pick.
 
*duh*

OK, I plead the lack of caffeine when reading the original posting.
-r used to be "reproduce the changeset", but that _excludes_ committer.
Nevermind.

FWIW, I prefer to keep many branches and use suffix (.b<number>) to
distinguish between them.  And cherry-pick/reorder/split/collapse
as needed on transition to the next one.  At least that avoids
some problems for secondary trees - branches do not jump.

Since branches tend to be relatively small, they don't get conflicts
that open and I can postpone switch to new branch until it really
has to be done.

I don't know how to deal with tricky branch topology; every time when I
get to structure like <branch X is on top of Y+Z> it becomes very painful
to work on all these topics in parallel.  For trees maintained by different
people... <shudder>
