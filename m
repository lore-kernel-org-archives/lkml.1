Return-Path: <linux-kernel-owner+w=401wt.eu-S1764377AbYBMA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764377AbYBMA4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYBMA4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:56:11 -0500
Received: from mail.fieldses.org ([66.93.2.214]:41409 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbYBMA4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:56:10 -0500
Date: Tue, 12 Feb 2008 19:56:04 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213005604.GA5830@fieldses.org>
References: <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212.155107.251983955.davem@davemloft.net> <20080212235401.GL27894@ZenIV.linux.org.uk> <20080213001650.GY18625@fieldses.org> <20080213004841.GM27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213004841.GM27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:48:41AM +0000, Al Viro wrote:
> On Tue, Feb 12, 2008 at 07:16:50PM -0500, J. Bruce Fields wrote:
> > > Ahem...  Use of git-cherry-pick preserves commit information just fine.
> > 
> > Not by default, at least (note they said "commiters", not "authors"):
> 
> That's why you give it -r.

What version of git have you tried this with?  At least on my version,
-r is a no-op, and the results are the same; the author is still kept
and the maintainer changed.  I thought it had been that way for ages.

--b.

bfields@pig:~/local/linux-2.6$ git --version
git version 1.5.4.rc2.60.gb2e62
bfields@pig:~/local/linux-2.6$ git cherry-pick -r v2.6.25-rc1
Finished one cherry-pick.
Created commit 0277143: Linux 2.6.25-rc1
 1 files changed, 2 insertions(+), 2 deletions(-)
bfields@pig:~/local/linux-2.6$ git cat-file -p HEAD
tree 4018d5d93f857d946dd89acbb4e45c9da04eadaf
parent b6ce068a1285a24185b01be8a49021827516b3e1
author Linus Torvalds <torvalds@woody.linux-foundation.org> 1202681894 -0800
committer J. Bruce Fields <bfields@citi.umich.edu> 1202863894 -0500

Linux 2.6.25-rc1

.. and I really need to call it something else.  Maybe it is time to
bring back the weasel series, since weasels always make me feel good
about a kernel.

