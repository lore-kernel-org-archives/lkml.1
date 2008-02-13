Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbYBMG6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbYBMG6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 01:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYBMG5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 01:57:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930AbYBMG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 01:57:53 -0500
Date: Tue, 12 Feb 2008 22:16:53 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213061653.GA10784@kroah.com>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <20080213002948.GA8899@kroah.com> <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:49:46PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Feb 2008, Greg KH wrote:
> > 
> > Perhaps you need to switch to using quilt.  This is the main reason why
> > I use it.
> 
> Btw, on that note: if some quilt user can send an "annotated history file" 
> of their quilt usage, it's something that git really can do, and I'll see 
> if I can merge (or rather, coax Junio to merge) the relevant part of stgit 
> to make it possible to just basically get "quilt behaviour" for the parts 
> of a git tree that you haven't pushed out yet.

Ted's description matches mine (keep quilt tree in git, edit changelog
entries, rebase on newer kernel versions, etc.)  I can go into details
if needed.

> A pure patch-stack will be faster at that thing than git would be (it's 
> simply easier to just track patches), but on the other hand, using git 
> would get some other advantages outside of the integration issue (eg the 
> cherry-pick thing really is a proper three-way merge, not just an "apply 
> patch", so it can do better).

I was amazed at how slow stgit was when I tried it out.  I use
git-quiltimport a lot and I don't think it's any slower than just using
quilt on its own.  So I think that the speed issue should be the same.

I had a number of issues last time I tried stgit out, but maybe they are
now resolved, I'll try it out tomorrow and report to the git list
anything I find that doesn't work for me.

thanks,

greg k-h
