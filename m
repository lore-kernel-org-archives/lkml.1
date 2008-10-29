Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYJ2SwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYJ2SwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYJ2SwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:52:08 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40871 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbYJ2SwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:52:05 -0400
Date: Wed, 29 Oct 2008 19:53:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [PATCH] [CRIS] Move header files from include to arch/cris/include.
Message-ID: <20081029185313.GA22105@uranus.ravnborg.org>
References: <20081021164211.GG24715@axis.com> <20081029173420.GM4608@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029173420.GM4608@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 06:34:20PM +0100, Jesper Nilsson wrote:
> On Tue, Oct 21, 2008 at 06:42:11PM +0200, Jesper Nilsson wrote:
> > Hi,
> > 
> > I'm looking for some feedback on the changes in the branch include_move
> > at the git-tree:
> > 
> >         git://repo.or.cz/cris-mirror.git include_move
> > 
> > I've performed the move of the CRIS headers using the ARM and Blackfin
> > ports as a pattern.
> > 
> > That means that the machine dependent header files are moved to
> > arch/cris/mach-{fs,a3}/include, while the common and architecture
> > dependent files are moved to arch/cris/include.
> > 
> > It is mainly this I'd like some input on, since most other ports
> > that have moved their header files have put all headers in arch/*/include.
> 
> After some soul-searching I've changed this, and moved all header
> files into arch/cris/include. The most telling argument was that
> the CRIS port wouldn't have anything other than include files in
> the arch/cris/mach-* directories.
> 
> If that changes some time in the future, it is a simple operation
> moving the machine dependent header files there.
> 
> Since the complete patch is too large to post, I'm not including
> the diff of the files moved, only the files changed.

Hi Jesper.

I have looked at the diffstat and the patches and this is a
great improvement in readability of the cris stuff.

It would be good to get this in mainline as fast as possible.
Can I ask you to prepare to git trees to pull from and ask
Linus to pull it.
First tree should be the header move only and if you can
convince him it would be great to take the next two patches
so add them to another tree.

You can add an:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

on all three patches.

	Sam
