Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYJPKfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYJPKfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbYJPKea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:34:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39642 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754464AbYJPKe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:34:29 -0400
Date: Thu, 16 Oct 2008 12:33:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: Martin Steigerwald <ms@teamix.de>
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [TuxOnIce-devel] safe resuming: automatically invalidating an
	outdated hibernate snapshot
Message-ID: <20081016103338.GB1563@ucw.cz>
References: <200810131335.25793.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810131335.25793.ms@teamix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-10-13 13:35:25, Martin Steigerwald wrote:
> Am Montag, 13. Oktober 2008 schrieben Sie:
> > Hi Martin.
> 
> Hi Nigel,
> 
> > On Mon, 2008-10-13 at 12:13 +0200, Martin Steigerwald wrote:
> > > Cc to linux-kernel: This is mainly for tuxonice, but it might also be
> > > relevant for other hibernate implementations. Maybe some general
> > > mechanism for checking whether an on disk snapshot of the system is
> > > current would be good - as also the resume parameter could be missing or
> > > wrong or whatnot.
> > >
> > >
> > > Hi!
> > >
> > > Is there a way to automatically invalidate the tuxonice snapshot when a
> > > non tuxonice kernel is booted accidentally? I.e. could tuxonice recognize
> > > when the swap partition has been accessed *after* the snapshot has been
> > > written?
> 
> [...]
> 
> > The simplest way is to mkswap the appropriate partitions from a script
> > run when booting (after we check whether to resume, of course). I
> > believe the hibernate script already has support for this. Maybe
> > pm-utils or such like needs it too?
> 
> Simple idea. But I dislike automatically formatting a partition on each boot. 
> What if the user changes the partition layout and forgets to adapt
> swap 

Simple solution: add --only-mkswap-when-its-hibernation-image option
to mkswap.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
