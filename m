Return-Path: <linux-kernel-owner+w=401wt.eu-S1765278AbZLQSDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765278AbZLQSDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765241AbZLQSDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:03:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764990AbZLQSDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:03:21 -0500
Date: Thu, 17 Dec 2009 18:03:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2
Message-ID: <20091217180319.GB18217@ZenIV.linux.org.uk>
References: <20091217162454.GA18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 08:39:14AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 17 Dec 2009, Al Viro wrote:
> >
> > Misc bits and pieces, cleaning the table for scaling stuff...
> > Please, pull from
> > git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ master
> > in a few minutes (or directly from hera)
> 
> Btw, would you mind cleaning that repo up?

Sure.

> That's really unexpected for a bare repository. I spent some time looking 
> at the odd conflicts the other day when I pulled originally.
> 
> I suspect you just did a "scp -rp" or something to initially set it up, 
> which is why it contains some random branch - that just happened to be 
> your active branch at the time you did that setup.

IIRC, it was _way_ back and done as git clone -l -s <your tree> vfs-2.6
followed by mv vfs-2.6/.git /pub/scm/...../vfs-2.6.git.  So it probably
_isn't_ a proper bare repository in the first place.

OK...  I've edited config a bit, set HEAD to ref: refs/heads/master and
tried to clean the things up.  What I still don't understand is why the
hell does it have an apparently unkillable dangling commit that seems
to be yours, despite having alternates pointing to your tree.  *And*
a bunch of loose objects sitting around and impossible to get rid of...
