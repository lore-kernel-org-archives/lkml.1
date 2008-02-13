Return-Path: <linux-kernel-owner+w=401wt.eu-S1763852AbYBMARQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763852AbYBMARQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYBMARA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:17:00 -0500
Received: from mail.fieldses.org ([66.93.2.214]:51941 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbYBMAQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:16:59 -0500
Date: Tue, 12 Feb 2008 19:16:50 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213001650.GY18625@fieldses.org>
References: <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212.155107.251983955.davem@davemloft.net> <20080212235401.GL27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212235401.GL27894@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:54:01PM +0000, Al Viro wrote:
> On Tue, Feb 12, 2008 at 03:51:07PM -0800, David Miller wrote:
> > From: Jeff Garzik <jeff@garzik.org>
> > Date: Tue, 12 Feb 2008 11:31:48 -0500
> > 
> > > I understand the desire to want a nice and clean history, but the 
> > > frequency here really has a negative impact on your downstreams.
> > 
> > Ok, fair enough.  Any alternative suggestions on how to remove turds
> > without them being in the history?
> > 
> > > It also totally screws the commit statistics, wiping me and John and the 
> > > committers we have preserved out, replacing everybody's committer with 
> > > David Miller.
> > 
> > I am well aware of this downside, sorry.
> 
> Ahem...  Use of git-cherry-pick preserves commit information just fine.

Not by default, at least (note they said "commiters", not "authors"):

bfields@pig:~/local/linux-2.6$ git cherry-pick v2.6.25-rc1
Finished one cherry-pick.
Created commit c445dc0: Linux 2.6.25-rc1
 1 files changed, 2 insertions(+), 2 deletions(-)
bfields@pig:~/local/linux-2.6$ git show --pretty=raw HEAD
commit c445dc0a8b11877d6038dc528254733348c9f110
tree 4018d5d93f857d946dd89acbb4e45c9da04eadaf
parent b6ce068a1285a24185b01be8a49021827516b3e1
author Linus Torvalds <torvalds@woody.linux-foundation.org> 1202681894 -0800
committer J. Bruce Fields <bfields@citi.umich.edu> 1202861481 -0500


--b.
