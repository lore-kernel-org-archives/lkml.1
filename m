Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZAKVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZAKVx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZAKVxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:53:16 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:45922 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZAKVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:53:15 -0500
Date: Sun, 11 Jan 2009 22:54:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: current git kernel has strange problems during bisect
Message-ID: <20090111215454.GA6019@uranus.ravnborg.org>
References: <200901111602.53082.borntraeger@de.ibm.com> <200901111607.59054.borntraeger@de.ibm.com> <alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de> <200901111620.03345.borntraeger@de.ibm.com> <alpine.LFD.2.00.0901111113150.6528@localhost.localdomain> <20090111194258.GA4840@uranus.ravnborg.org> <alpine.LFD.2.00.0901111200330.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901111200330.6528@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:04:12PM -0800, Linus Torvalds wrote:
> 
> 
> On Sun, 11 Jan 2009, Sam Ravnborg wrote:
> > 
> > The cost of moving this piece of history from one git tree to another
> > git tree is that we make it harder to debug the kernel for the advanced user
> > that knows how to do bisect.
> > 
> > It is not like this history would be lost - one just had to look
> > somewhere else to find it.
> > 
> > That may be a bad pain/benefit ratio - time will tell.
> 
> Umm. No. 
> 
> Time is exactly what makes it useful. It will make all the downsides 
> shrink, and the advantages stay.
> 
> > There should be a way to avoid such pain when bisecting without
> > having to mark a semi-random (for the average person) commit as good.
> 
> Well, you don't actually have to mark that semi-random one as good either. 
> What you can do is to just mark anything that _only_ contains fs/btrfs as 
> good. IOW, you don't have to know the magic number - you just have to be 
> told that "oh, if you only have btrfs files, and you're not actively 
> bisecting a btrfs bug, just do 'git bisect good' and continue".

And we lost 24 hours due to timezone differences etc. and maybe
a few testers.
Thats my point.

There are other obvious ways to do this where we keep history in kernel
but do not impact bisect.
And we have one frustrated tester already - so this is not a made up example.

	Sam
